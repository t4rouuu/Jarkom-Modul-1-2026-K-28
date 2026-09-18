## Kelompok K-28

| Nama | NRP |
| :---: | :---: |
| Maitasya Rohmatul Ula | 5027251026 |
| A. Algifari Rantiga Isdar | 5027251084 |

---
## Daftar Isi

- [Soal 1 — Membangun Topologi The Wired](#soal-1)
- [Soal 2 — Konfigurasi Internet pada Router-Lain](#soal-2)
- [Soal 3 — Routing Antar Entitas](#soal-3)
- [Soal 4 — NAT, Firewall, dan DNS](#soal-4)
- [Soal 5 — Persistensi Konfigurasi](#soal-5)
- [Soal 6 — Traffic Generator dan Wireshark](#soal-6)
- [Soal 7 — FTP Server dan Access Control](#soal-7)
- [Soal 8 — FTP Upload dan Analisis Wireshark](#soal-8)
- [Soal 9 — FTP Download dan Read-Only](#soal-9)
- [Soal 10 — ICMP dan Analisis Ping](#soal-10)
- [Soal 11 — Telnet dan Plaintext Credential](#soal-11)
- [Soal 12 — Port Scanning dengan Netcat](#soal-12)
- [Soal 13 — SSH dan Key Authentication](#soal-13)
- [Soal 14 — Analisis Brute Force](#soal-14)
- [Soal 15 — Analisis Traffic FTP](#soal-15)
- [Soal 16 — Analisis FTP Theft](#soal-16)
- [Soal 17 — Analisis HTTP C2](#soal-17)
- [Soal 18 — Analisis SMB Transfer](#soal-18)
- [Soal 19 — Analisis SMTP Threat](#soal-19)
- [Soal 20 — Analisis Traffic TLS](#soal-20)
 
---
### soal 1

Untuk mempersiapkan pembangunan The Wired, kita membangun topologi jaringan The Wired di GNS3, dengan Router Lain sebagai pusat yang terhubung ke tiga Switch: Switch 1 (menuju Alice & Mika), Switch 2 (menuju Chisa), dan Switch 3 (menuju Knights & Eiri) di mana kelima entitas tersebut dikonfigurasi sebagai Client, menggunakan prefix IP sesuai kelompok masing-masing.

###### Menyiapkan nodenya

Tarik node ke workspace GNS3:
- 1 Router (kasih 4 adapter/interface)
- 1 NAT node
- 3 Switch (Ethernet switch)
- 5 Client (1 adapter aja tiap client)

###### Memberikan Rename semua node sesuai perannya:

`Router-Lain`, `Switch1`, `Switch2`, `Switch3`, `Alice`, `Mika`, `Chisa`, `Knights`, `Eiri`

###### Menyambungkan kabelnya

- NAT → Router-Lain (di eth0)
- Switch1 → Router-Lain (di eth1), lalu Switch1 → Alice, dan Switch1 → Mika
- Switch2 → Router-Lain (di eth2), lalu Switch2 → Chisa
- Switch3 → Router-Lain (di eth3), lalu Switch3 → Knights, dan Switch3 → Eiri

###### Hasil Topologi:

<img width="957" height="406" alt="image" src="https://github.com/user-attachments/assets/7d9b4ff3-df07-47a6-8a0a-ee98bc473473" />

---

### soal 2

Untuk menghubungkan Router Lain ke jaringan internet publik melalui NAT/DHCP pada interface eth0, karena The Wired saat itu masih terisolasi dari dunia luar.

###### Mengedit file konfigurasi

Buka file `/etc/network/interfaces` di Router-Lain, lalu isi seperti ini:

```
auto eth0
iface eth0 inet dhcp

auto eth1
iface eth1 inet static
    address 192.225.1.1
    netmask 255.255.255.0

auto eth2
iface eth2 inet static
    address 192.225.2.1
    netmask 255.255.255.0

auto eth3
iface eth3 inet static
    address 192.225.3.1
    netmask 255.255.255.0
```

###### Penjelasan :

- `eth0` → **dhcp** (otomatis dapat IP dari NAT, ini jalur keluar ke internet)
- `eth1` → IP tetap `192.225.1.1` (gerbang buat Switch1 → Alice & Mika)
- `eth2` → IP tetap `192.225.2.1` (gerbang buat Switch2 → Chisa)
- `eth3` → IP tetap `192.225.3.1` (gerbang buat Switch3 → Knights & Eiri)

konfigurasi Cleint:

###### Alice

```
auto eth0
iface eth0 inet static
    address 192.225.1.2
    netmask 255.255.255.0
    gateway 192.225.1.1
```

<img width="959" height="225" alt="image" src="https://github.com/user-attachments/assets/3fb6adce-7743-4804-b2ea-683b91e8f5e4" />

###### Mika

``` auto eth0
iface eth0 inet static
    address 192.225.1.3
    netmask 255.255.255.0
    gateway 192.225.1.1
```
<img width="959" height="230" alt="image" src="https://github.com/user-attachments/assets/4afb5358-2abf-4885-bf70-724f35b76339" />

###### Chisa

```auto eth0
iface eth0 inet static
    address 192.225.2.2
    netmask 255.255.255.0
    gateway 192.225.1.1
```
<img width="959" height="226" alt="image" src="https://github.com/user-attachments/assets/0c2e7855-3952-41ea-a939-8b456ed9a793" />

###### knights

```auto eth0
iface eth0 inet static
    address 192.225.3.2
    netmask 255.255.255.0
    gateway 192.225.1.1
```
<img width="959" height="230" alt="image" src="https://github.com/user-attachments/assets/28322479-90bd-49ac-b423-22f34e3d89cb" />

###### Eiri

```auto eth0
iface eth0 inet static
    address 192.225.3.3
    netmask 255.255.255.0
    gateway 192.225.1.1
```
<img width="959" height="234" alt="image" src="https://github.com/user-attachments/assets/1f7372be-50cd-4b09-aca5-483fe6d3466a" />

###### Tes koneksi internet

Di konsol Router-Lain, ketik:

```
ping -c 3 8.8.8.8
```

**jika hasilnya seperti ini:**

<img width="959" height="404" alt="image" src="https://github.com/user-attachments/assets/7b3fb622-0cb6-49cd-acf0-93d89362f668" />

```
3 packets transmitted, 3 received, 0% packet loss
```

➡️ Berarti Router-Lain **sudah berhasil online** dan siap jadi pintu keluar untuk semua Client di bawahnya. jika gagal (`Destination unreachable` atau `100% packet loss`), kemungkinan masalah di NAT node atau eth0 belum dapat IP cek dengan `ip a` di eth0 dulu.

---
### soal 3

Untuk memastikan seluruh Entitas (Client) di bawah Switch 1, Switch 2, dan Switch 3 dapat saling terhubung dan berkomunikasi satu sama lain, dengan mengkonfigurasi routing pada Router Lain setelah router tersebut terhubung ke internet.

###### Mengaktifkan IP forwarding

Di konsol Router-Lain, ketik:

```
sysctl -w net.ipv4.ip_forward=1
```

###### Memastikan sudah aktif 

```
cat /proc/sys/net/ipv4/ip_forward
```
Hasil:

<img width="959" height="120" alt="image" src="https://github.com/user-attachments/assets/fb367501-af34-4cc2-92fa-2e511282b36e" />

jika hasilnya `1` → sudah aktif dan siap meneruskan traffic antar subnet.

jika hasilnya `0` → berarti belum berhasil, ulangi langkah 1.

###### Tes koneksi antar Entitas

Coba ping dari satu client ke client lain, contoh:
- **Alice → Mika** (masih satu Switch, Switch1)
- **Alice → Chisa** (beda Switch, lewat Router-Lain)
- **Knights → Eiri** (masih satu Switch, Switch3)
- **Mika → Knights** (beda Switch, lewat Router-Lain)

Caranya, dari konsol client (misal Alice):

```
ping -c 3 <IP_Mika>
ping -c 3 <IP_Chisa>
```
Hasil:

<img width="959" height="430" alt="image" src="https://github.com/user-attachments/assets/d640a90e-e5b9-419e-b505-c50ca25d931d" />

**Hasil yang diharapkan:** 

Semua client bisa saling ping (0% packet loss), baik yang satu switch maupun beda switch — tandanya routing dan forwarding di Router-Lain sudah jalan dengan benar.

---
### soal 4

Untuk mengkonfigurasi firewall/iptables (NAT Masquerade) dan DNS resolver di Router Lain, agar setiap Entitas (Client) dapat terhubung ke internet secara mandiri dibuktikan dengan bisa ping ke 8.8.8.8 dan membuka domain google.com.

###### Menyetting NAT & Firewall di Router-Lain

Ketik perintah-perintah ini di konsol Router-Lain:

```
iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
iptables -A FORWARD -i eth1 -o eth0 -j ACCEPT
iptables -A FORWARD -i eth2 -o eth0 -j ACCEPT
iptables -A FORWARD -i eth3 -o eth0 -j ACCEPT
iptables -A FORWARD -i eth0 -m state --state ESTABLISHED,RELATED -j ACCEPT
```

###### Menyetting DNS di tiap Client

Di setiap node Client (Alice, Mika, Chisa, Knights, Eiri), ketik:

```
echo "nameserver 8.8.8.8" > /etc/resolv.conf
```

###### Tes dari tiap Client

Di konsol masing-masing Client, coba:
```
ping -c 3 8.8.8.8
```
➡️ jika berhasil, artinya jalur internet (NAT & routing) sudah benar.

```
ping -c 3 google.com
```
atau
```
curl google.com
```
➡️ jika ini juga berhasil, artinya DNS resolver-nya juga sudah jalan (bisa translate nama domain ke IP).

jadi jika kedua tes di atas berhasil di semua 5 Client, berarti Fase 4 sudah beres  setiap Entitas sudah bisa "berdiri sendiri" mengakses internet tanpa perlu campur tangan lebih lanjut dari Router-Lain.

Hasil:

###### Alice
<img width="959" height="446" alt="image" src="https://github.com/user-attachments/assets/1680a9ee-bba8-4997-8b4a-39dde25effa5" />

###### Mika
<img width="959" height="448" alt="image" src="https://github.com/user-attachments/assets/efd853ef-3746-4da9-a9b1-3ec225aa25e9" />

###### Chisa
<img width="959" height="440" alt="image" src="https://github.com/user-attachments/assets/0ee36a97-33cd-40b8-812e-a82061bcc448" />

###### Knights
<img width="959" height="449" alt="image" src="https://github.com/user-attachments/assets/e2a62a48-d0c8-41bf-b283-3b261efdacba" />

###### Eiri
<img width="959" height="448" alt="image" src="https://github.com/user-attachments/assets/f2a3b925-8ccd-4e47-8290-578c7b51af8a" />

---
### soal 5

Untuk memastikan seluruh konfigurasi jaringan tetap tersimpan (persisten) meskipun semua node di-restart, serta membuat script verifikasi `/root/cek_status.sh` di Router Lain yang menampilkan ringkasan interface (`ip -br a`) dan status tabel NAT (`iptables -t nat -L -v -n`) setelah reboot.

###### Memindahkan config NAT/forwarding ke file interfaces (Router-Lain)

Edit `/etc/network/interfaces` di Router-Lain, ubah bagian eth0 jadi seperti ini (tambahkan baris `up`):

```
auto eth0
iface eth0 inet dhcp
    up sysctl -w net.ipv4.ip_forward=1
    up iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
    up iptables -A FORWARD -i eth1 -o eth0 -j ACCEPT
    up iptables -A FORWARD -i eth2 -o eth0 -j ACCEPT
    up iptables -A FORWARD -i eth3 -o eth0 -j ACCEPT
    up iptables -A FORWARD -i eth0 -m state --state ESTABLISHED,RELATED -j ACCEPT
```

###### Memindahkan config DNS ke file interfaces (di tiap Client)

Di file `/etc/network/interfaces` masing-masing Client (Alice, Mika, Chisa, Knights, Eiri), tambahkan baris `up` untuk DNS-nya juga:

```
up echo "nameserver 8.8.8.8" > /etc/resolv.conf
```

Jadi DNS resolvernya gak akan hilang meski Client di-restart.

###### Membuat script verifikasi otomatis

Di konsol Router-Lain, ketik:

```bash
mkdir -p /root
cat > /root/cek_status.sh << 'EOF'
#!/bin/sh
echo "=== Ringkasan Interface ==="
ip -br a
echo ""
echo "=== Tabel NAT ==="
iptables -t nat -L -v -n
EOF
chmod +x /root/cek_status.sh
```

**Fungsinya:** 

*(Script ini aman disimpan agar tidak ikut hilang saat container restart)*
Script ini membuat satu file `cek_status.sh` yang kalau dijalankan, langsung nampilin dua hal sekaligus:

**Ringkasan interface** (`ip -br a`) → cek IP tiap eth masih terpasang atau tidak
**Tabel NAT** (`iptables -t nat -L -v -n`) → cek aturan MASQUERADE masih ada atau tidak


###### Tes persistensi

1. **Restart** node Router-Lain (dan Client-nya)
2. Setelah nyala lagi, jalankan:
   ```
   /root/cek_status.sh
   ```
3. **Hasil yang diharapkan:**
   
   <img width="959" height="337" alt="image" src="https://github.com/user-attachments/assets/1ca3b2f9-ea3c-4e26-b314-a669504b4932" />

IP address di semua interface masih terpasang, dan aturan NAT (MASQUERADE) masih muncul di tabel tandanya konfigurasi berhasil **bertahan** meski sempat di-restart.
   
---
soal 6

Untuk menjalankan traffic generator ([link](https://drive.google.com/drive/folders/1ZjFvWIjvAQAjE9pPthm7V_bGyaSt93lY?usp=sharing)) pada node Mika, pada node Mika, lalu melakukan packet sniffing dengan Wireshark di interface node Mika menggunakan display filter khusus untuk protokol DNS atau ICMP, serta menunjukkan screenshot hasil filter beserta ringkasan paket yang lolos.

###### Menyiapkan script traffic generator di Mika

Buka konsol Mika, buat file scriptnya:

```
nano /root/traffic_gen.sh
```

Paste isi script yang dikasih soal (isinya perintah ping, nslookup, dan dig ke beberapa server DNS publik). Simpan (`Ctrl+O`, Enter, `Ctrl+X`), lalu kasih izin jalan:

```
chmod +x /root/traffic_gen.sh
```

Cek dulu tools-nya sudah ada:

```
which nslookup dig ping
```

Kalau `dig` belum ada, install dulu:
```
apk add bind-tools        # kalau pakai Alpine
```

###### Menyalakan capture Wireshark lewat GNS3**

1. Di topologi GNS3, cari **kabel** yang menghubungkan Mika ↔ Switch1
2. Klik kanan **kabelnya** (bukan node-nya) → pilih **Start capture**
3. Centang *"Start the capture visualization program"* → klik OK
4. Wireshark otomatis terbuka dan mulai menampilkan traffic secara langsung

###### Menjalankan script-nya

Balik ke konsol Mika, jalankan:

```
/root/traffic_gen.sh
```

Tunggu sampai muncul tulisan selesai.

###### Filter di Wireshark

Di kolom filter bagian atas Wireshark (bukan capture filter, tapi **display filter**), ketik:

```
dns or icmp
```

lalu tekan Enter. Wireshark akan menyembunyikan paket lain dan hanya menampilkan paket DNS & ICMP saja.

######  bukti (screenshot):

1. **Screenshot Packet List**
   <img width="1600" height="897" alt="WhatsApp Image 2026-09-15 at 12 27 49" src="https://github.com/user-attachments/assets/884fa529-d41f-4569-a79c-c5d6b3691aff" />

   setelah filter `dns or icmp` diterapkan
   
2. **Ringkasan paket**
   
    buka menu **Statistics → Protocol Hierarchy**, ini menampilkan jumlah/persentase paket DNS vs ICMP dari total capture
   
   <img width="1532" height="865" alt="WhatsApp Image 2026-09-15 at 12 28 31" src="https://github.com/user-attachments/assets/3d6cae53-86d5-46db-9430-5ca15524df5e" />

###### Hentikan & simpan capture**

1. Klik kanan kabel yang sama di GNS3 → **Stop capture**
2. Di Wireshark: **File → Save As**, simpan dengan nama jelas, misal:
   ```
   soal6-mika-dns-icmp.pcapng
   ```
   [soal6-mika-dns-icmp.zip](https://github.com/user-attachments/files/32324473/soal6-mika-dns-icmp.zip)

---
### soal 7

Untuk membuat FTP Server di node Chisa dengan shared folder `/var/wired/data`, menerapkan kebijakan akses (alice: read & write, mika: read-only, eiri: no access/blacklist), serta membuktikannya dengan membuat file `signal_alice.txt` dari akun alice dan menunjukkan penolakan akses saat eiri mencoba login.

###### Menginstall vsftpd

Cek dulu OS-nya:

```
cat /etc/os-release
```

jika Alpine:

```
apk update && apk add vsftpd
```

Pastikan berhasil:

```
which vsftpd
```

###### Membuat folder shared

```
mkdir -p /var/wired/data
```

###### Membuat 3 akun user

```
adduser -D -h /var/wired/data alice
adduser -D -h /var/wired/data mika
adduser -D -h /var/wired/data eiri
```

Set password tiap user (wajib biar bisa login FTP):

```
passwd alice
passwd mika
passwd eiri
```
###### Mengtur kepemilikan folder

```
chown alice:alice /var/wired/data
chmod 775 /var/wired/data
```

###### Mengedit config utama vsftpd

```
cat > /etc/vsftpd/vsftpd.conf 
anonymous_enable=NO
local_enable=YES
write_enable=YES
dirmessage_enable=YES
xferlog_enable=YES
connect_from_port_20=YES
listen=YES

chroot_local_user=YES
local_root=/var/wired/data
allow_writeable_chroot=YES

pasv_enable=YES
pasv_min_port=30000
pasv_max_port=30009
pasv_address=[IP_CHISA]

seccomp_sandbox=NO

userlist_enable=YES
userlist_deny=YES
userlist_file=/etc/vsftpd/user_list
user_config_dir=/etc/vsftpd/user_conf

```

###### Memblokir Eiri

```
echo "eiri" > /etc/vsftpd/user_list
```
Karena mode-nya *deny list*, siapa pun yang namanya ada di file ini otomatis ditolak login.

###### Membuat aturan khusus Mika (read-only)

```
mkdir -p /etc/vsftpd/user_conf
echo "write_enable=NO" > /etc/vsftpd/user_conf/mika
```

###### Menjalankan servernya

```
pkill vsftpd 2>/dev/null
vsftpd /etc/vsftpd/vsftpd.conf &
```

Cek statusnya:

```
ps aux | grep vsftpd
```

###### Persistensi 

Karena container GNS3 bersifat ephemeral (paket, user, config bisa hilang saat restart — kecuali isi folder /root), semua langkah di atas dibungkus jadi satu script /root/setup_ftp.sh yang bisa dijalankan ulang kapan saja:

```
nano /root/setup_ftp.sh
```
```
#!/bin/sh
# Setup FTP Server - Node Chisa - Soal #7

apk update
apk add vsftpd

mkdir -p /var/wired/data

id alice >/dev/null 2>&1 || adduser -D -h /var/wired/data alice
id mika  >/dev/null 2>&1 || adduser -D -h /var/wired/data mika
id eiri  >/dev/null 2>&1 || adduser -D -h /var/wired/data eiri

echo "alice:alice" | chpasswd
echo "mika:mika" | chpasswd
echo "eiri:eiri" | chpasswd

chown alice:alice /var/wired/data
chmod 775 /var/wired/data

cat > /etc/vsftpd/vsftpd.conf << 'CONFEOF'
anonymous_enable=NO
local_enable=YES
write_enable=YES
dirmessage_enable=YES
xferlog_enable=YES
connect_from_port_20=YES
listen=YES

chroot_local_user=YES
local_root=/var/wired/data
allow_writeable_chroot=YES

pasv_enable=YES
pasv_min_port=30000
pasv_max_port=30009
pasv_address=192.225.2.2

seccomp_sandbox=NO

userlist_enable=YES
userlist_deny=YES
userlist_file=/etc/vsftpd/user_list
user_config_dir=/etc/vsftpd/user_conf
CONFEOF

echo "eiri" > /etc/vsftpd/user_list

mkdir -p /etc/vsftpd/user_conf
echo "write_enable=NO" > /etc/vsftpd/user_conf/mika

pkill vsftpd 2>/dev/null
sleep 1
vsftpd /etc/vsftpd/vsftpd.conf &

echo "=== Setup selesai ==="
ps aux | grep vsftpd
```
lanjut 
```
chmod +x /root/setup_ftp.sh
/root/setup_ftp.sh
```

###### Tes & ambil bukti (screenshot untuk laporan)

###### A. Test Alice (harus bisa read & write)

Dari node lain, buat dulu file testnya:

```
echo "test dari Alice" > signal_alice.txt
```

Lalu login FTP:

```
lftp 192.225.2.2
```

Masuk pakai `alice`, lalu upload:

```
put signal_alice.txt
```

➡️ Harus **berhasil**. Cek juga bisa `ls`.

<img width="793" height="138" alt="WhatsApp Image 2026-09-15 at 13 29 41" src="https://github.com/user-attachments/assets/2dbcb196-6cc7-41bc-af52-3f99baf27278" />


###### B. Test Mika (harus bisa read, tapi GAGAL saat write)

```
lftp 192.225.2.2
```

Login `mika`, coba:

```
 put test_mika.txt
```

<img width="587" height="129" alt="WhatsApp Image 2026-09-15 at 13 40 30" src="https://github.com/user-attachments/assets/e5c38fd2-82e7-4a96-be61-34048200ef37" />

➡️ Harus muncul error **"Permission denied"** atau kode **550** → screenshot ini sebagai bukti read-only.
Coba juga `ls` atau `get` file — ini harus tetap **berhasil** (buktikan read masih jalan).

###### C. Test Eiri (harus ditolak total, bahkan sebelum masuk)

```
lftp 192.225.2.2
```
Masukkan username `eiri` → harus langsung muncul penolakan seperti **"530 Permission denied"** → screenshot ini sebagai bukti blacklist berhasil.

<img width="446" height="95" alt="WhatsApp Image 2026-09-15 at 13 41 52" src="https://github.com/user-attachments/assets/b9852802-2f2d-411c-bb6d-15182626f71b" />

---
### soal 8

Untuk melakukan koneksi FTP dari node Knights ke FTP Server Chisa memakai akun alice, mengupload file ([link](https://drive.google.com/drive/folders/1tvZpueSH9E3GWwXM6KNnM64Y5wNoIAYP?usp=sharing)), lalu menganalisis sesi Wireshark untuk menemukan perintah STOR, kode status 226, dan port data TCP mode PASV.

###### Mendowlod file laporan di Knights

Buka konsol Knights, buat filenya:

```
nano /root/knights_report.txt
```

Isi dengan teks laporan (ganti prefix IP sesuai kelompok). Simpan (`Ctrl+O`, Enter, `Ctrl+X`), lalu cek:

```
cat /root/knights_report.txt
```

###### Menyalakan Wireshark DULU (sebelum FTP jalan)

Sama seperti soal 6, capture-nya lewat GNS3:
1. Pilih salah satu link: **Knights ↔ Switch3** atau **Chisa ↔ Switch2**
2. Klik kanan kabelnya → **Start capture** → centang visualisasi → OK
3. Wireshark otomatis terbuka
4. Ketik filter di kolom display filter (biar nanti gampang baca):
   
   ```
   ftp or ftp-data
   ```

###### Mengupload file dari Knights pakai akun Alice

Balik ke konsol Knights:

```
lftp [IP_CHISA]
```

Login pakai `alice` + passwordnya, lalu upload:

```
lftp> put /root/knights_report.txt
```

Setelah selesai:
```
lftp> bye
```

###### Cek file sudah sampai di Chisa

```
ls -la /var/wired/data/
```

Harus muncul `knights_report.txt`.

###### Mencari 3 bukti di Wireshark

Dengan filter `ftp or ftp-data` masih aktif, cari 3 hal ini di Packet List:

###### A. Perintah STOR (upload command)

Cari paket dengan info `STOR knights_report.txt` → expand bagian *File Transfer Protocol (FTP)* untuk lihat detailnya.

###### B. Kode 226 (transfer sukses)

Cari paket setelahnya dengan info `226 Transfer complete.` → artinya file sudah 100% terkirim.

###### C. Port data PASV 

Cari paket sebelum STOR dengan info seperti:

```
227 Entering Passive Mode (h1,h2,h3,h4,p1,p2)
```

Port datanya dihitung dari 2 angka terakhir dengan rumus:

```
port = (p1 × 256) + p2
```

Contoh: `(192,225,2,2,196,80)` → port = (196×256)+80 = **50256**

###### Screenshot & simpan bukti

Ambil screenshot yang menunjukkan (dengan Packet Details ter-expand):
1. Paket **STOR knights_report.txt**
   
   <img width="694" height="295" alt="WhatsApp Image 2026-09-15 at 14 10 37" src="https://github.com/user-attachments/assets/e50ec1fc-bea2-4acb-aba1-d219406e5421" />
   
   <img width="1600" height="899" alt="WhatsApp Image 2026-09-15 at 14 15 53" src="https://github.com/user-attachments/assets/aed3b316-e30d-420c-8f9d-5a0a0a92a034" />

2. Paket **226 Transfer complete**

    <img width="1600" height="899" alt="WhatsApp Image 2026-09-15 at 14 16 41" src="https://github.com/user-attachments/assets/1c77f3e6-b729-48fb-b9c9-61d141c525ed" />

   
3. Paket **227 Entering Passive Mode** (buat ambil angka portnya)
   
<img width="1600" height="898" alt="WhatsApp Image 2026-09-15 at 14 17 52" src="https://github.com/user-attachments/assets/a24d49b7-1988-4a36-a2f3-e76bb3bbea10" />

<img width="1600" height="899" alt="WhatsApp Image 2026-09-15 at 14 19 37" src="https://github.com/user-attachments/assets/ad101d05-496f-4467-9422-a9d0583a5f7e" />

###### Hentikan & simpan capture**

1. Klik kanan kabel yang sama di GNS3 → **Stop capture**
2. Di Wireshark: **File → Save As**, simpan dengan nama jelas, misal:
   ```
   soal8-knights-upload.pcapng
   ```
---
### soal 9

Untuk mengunduh dokumen Protokol Tujuh ([link](https://drive.google.com/drive/folders/1S3hG0dnZBTkCta4uILWwKVc6dSYYGRJ6?usp=sharing)) dari FTP Server Chisa memakai akun mika, lalu membuktikan pembatasan read-only dengan mencoba upload file baru dan menunjukkan pesan error 550 Permission denied.

###### Menyiapkan file manifesto di Chisa

Karena Mika tidak boleh upload, file ini harus sudah ada duluan di server. Buat langsung di konsol Chisa:

```
nano /var/wired/data/protocol7_manifesto.txt
```

Isi dengan teks manifesto (sesuai soal). 

Simpan (`Ctrl+O`, Enter, `Ctrl+X`).

Pastikan filenya bisa dibaca semua user:

```
chmod 644 /var/wired/data/protocol7_manifesto.txt
ls -la /var/wired/data/
```

###### Menyalakan Wireshark dulu

Sama seperti soal sebelumnya:
1. Klik kanan kabel **Mika ↔ Switch1** (atau Chisa ↔ Switch2) di GNS3
2. **Start capture** → centang visualisasi → OK
3. Di kolom filter Wireshark, ketik:
   
   ```
   ftp or ftp-data
   ```

###### Mika download file (harus BERHASIL)

Di konsol Mika:

```
lftp [IP_CHISA]
```

Login pakai `mika` + passwordnya, lalu:

```
lftp> get protocol7_manifesto.txt
lftp> bye
```

Cek hasilnya di luar sesi FTP:

```
cat protocol7_manifesto.txt
```

Pastikan isinya sama persis dengan yang di server.

Catatan Persistence:
File protocol7_manifesto.txt dan signal_alice.txt sudah dimasukkan ke
script /root/setup_ftp.sh (bagian restore otomatis), jadi kalau node
Chisa di-restart, tinggal jalankan:
    /root/setup_ftp.sh
File-file itu akan otomatis ter-copy ulang ke /var/wired/data dengan
permission yang benar (644).

###### Mika coba upload (harus GAGAL)

Buat file dummy dulu:

```
echo "coba upload dari mika" > /root/test_mika.txt
```

Login FTP lagi sebagai mika:

```
lftp [IP_CHISA]
```

Coba upload:

```
lftp> put /root/test_mika.txt
```

➡️ Karena Mika sudah di-set `write_enable=NO` (dari Soal 7), harusnya muncul error seperti:

```
550 Permission denied.
```

Keluar:

```
lftp> bye
```

###### mencari 2 bukti di Wireshark

Dengan filter `ftp or ftp-data` masih aktif, cari:

1. **Perintah RETR**

   (waktu download berhasil) → paket dengan info:
   
   ```
   RETR protocol7_manifesto.txt
   ```
   
   <img width="1600" height="896" alt="WhatsApp Image 2026-09-15 at 14 50 45" src="https://github.com/user-attachments/assets/6bfbceb5-d84b-43fa-bdb6-b69f4acbbc7e" />


2. **Perintah STOR + penolakan**
   
   (waktu upload gagal) → dua paket:
   - `STOR test_mika.txt`
   - Balasan server: `550 Permission denied.`

<img width="955" height="226" alt="WhatsApp Image 2026-09-15 at 14 49 11" src="https://github.com/user-attachments/assets/00db6551-ec27-4402-a504-e5135b14b93e" />

Klik kedua paket ini, expand bagian *File Transfer Protocol (FTP)* di Packet Details.

<img width="1600" height="869" alt="WhatsApp Image 2026-09-15 at 14 51 32" src="https://github.com/user-attachments/assets/0f09791d-7849-485f-94e0-a029c66f7d8a" />


###### Hentikan & simpan capture

1. Klik kanan kabel yang sama di GNS3 → **Stop capture**
2. Di Wireshark: **File → Save As**, simpan dengan nama jelas, misal:
   ```
   soal9-mika-readonly.pcapng
   ```
---
### soal 10

Untuk mengirim ping dari node Knights ke node Chisa dengan payload 128 bytes, interval 0.3 detik, sebanyak 77 paket (ping -c 77 -s 128 -i 0.3 <IP_Chisa>), lalu menganalisis di Wireshark nilai ICMP Type/Code untuk Echo Request vs Echo Reply, serta packet loss dan RTT (min/avg/max).

###### Mencari IP Chisa

Di konsol Chisa:
```
ip -br a
```
Catat IP eth0-nya (misal `192.225.2.2`).

###### menyalakan Wireshark

Sama seperti soal sebelumnya:
1. Klik kanan kabel **Knights ↔ Switch3** di GNS3
2. **Start capture** → centang visualisasi → OK
3. Di kolom filter, ketik:
   ```
   icmp
   ```
###### Menjalankan ping dari Knights

Di konsol Knights (ganti IP sesuai Chisa):

```
ping -c 77 -s 128 -i 0.3 192.225.2.2
```

###### Hasil di terminal (packet loss & RTT)

Cari 2 baris di bagian bawah output:

```
--- 192.225.2.2 ping statistics ---
77 packets transmitted, 77 received, 0% packet loss, time xxxx ms
rtt min/avg/max/mdev = x.xxx/x.xxx/x.xxx/x.xxx ms
```
- **Packet loss** → lihat persentase di baris pertama
- **RTT min/avg/max** → 3 angka pertama di baris kedua

  ###### Bukti screenshot:
<img width="747" height="516" alt="WhatsApp Image 2026-09-15 at 15 08 38" src="https://github.com/user-attachments/assets/aed8adaf-dbe4-4f31-8448-866caf2991fc" />

  Output terminal ping lengkap (command + statistik RTT & packet loss)


###### ICMP Type & Code di Wireshark

Dengan filter `icmp` masih aktif, klik salah satu paket **Echo Request** (Knights → Chisa), expand bagian *Internet Control Message Protocol*, akan terlihat:

```
Type: 8 (Echo request)
Code: 0
```

Klik paket **balasannya** (Echo Reply, Chisa → Knights, biasanya baris berikutnya):

```
Type: 0 (Echo reply)
Code: 0
```
| Arah | Type | Code |
|---|---|---|
| Request (Knights → Chisa) | 8 | 0 |
| Reply (Chisa → Knights) | 0 | 0 |

 ###### Bukti screenshot:

 <img width="1600" height="899" alt="WhatsApp Image 2026-09-15 at 15 16 21 (2)" src="https://github.com/user-attachments/assets/d4c6a532-a4ce-45bb-a896-8c1268bdbfd4" />

 Paket Echo Request di Wireshark (Type: 8, Code: 0)

###### Hentikan & simpan capture

1. Klik kanan kabel yang sama di GNS3 → **Stop capture**
2. Di Wireshark: **File → Save As**, simpan dengan nama jelas, misal:
   ```
   soal10-knights-ping-chisa.pcapng`
   ```
---   
### soal 11

Untuk membuktikan kelemahan protokol Telnet dengan membuat akun phantom_user/wired_ghost di telnetd node Chisa, login dari node Eiri, menangkap sesi dengan Wireshark, menunjukkan kredensial plain text lewat Follow TCP Stream, serta menjelaskan mengapa tiap karakter terkirim dalam paket TCP terpisah.

###### Menginstall telnetd di Chisa 

Cek dulu OS-nya:

```
cat /etc/os-release
```

```
apk update
apk add busybox-extras
```

###### Membuat user phantom_user

```
adduser -D phantom_user
passwd phantom_user
```
Saat diminta password, ketik: `wired_ghost` (2x buat konfirmasi)

###### Menjalankan service telnetd

```
telnetd -p 23 -l /bin/login &
```

Cek servicenya sudah listen di port 23:

```
netstat -tulnp | grep 23
```

atau kalau tidak ada `netstat`:
```
ss -tulnp | grep 23
```

Harus muncul baris dengan status **LISTEN** di port 23.

###### Menyalakan Wireshark DULU (sebelum login Eiri)

1. Klik kanan kabel **Eiri ↔ Switch3** di GNS3
2. **Start capture** → centang visualisasi → OK
3. Di kolom filter, ketik:
   ```
   telnet
   ```
###### Login Telnet dari Eiri**

Di konsol Eiri:

```
telnet [IP_CHISA]
```
Saat diminta:

```
login: phantom_user
Password: wired_ghost
```
Setelah masuk, coba perintah simpel:

```
whoami
```

Lalu keluar:

```
exit
```

###### Membuka Follow TCP Stream di Wireshark**

Dengan filter `telnet` masih aktif, klik salah satu paket telnet, lalu:

Klik kanan → **Follow → TCP Stream**

Akan muncul jendela berisi seluruh isi sesi:
- **Merah** = yang dikirim dari client (Eiri)
- **Biru** = balasan dari server (Chisa)

Di sini akan terlihat jelas:

```
login: phantom_user
Password: wired_ghost
```

Muncul **polos, bisa dibaca langsung** — inilah bukti kelemahan Telnet.

###### Screenshot Bukti:

<img width="1600" height="897" alt="WhatsApp Image 2026-09-15 at 15 41 10" src="https://github.com/user-attachments/assets/d2125d33-fb19-42d2-8491-46739889070e" />

<img width="1600" height="902" alt="WhatsApp Image 2026-09-15 at 15 41 36" src="https://github.com/user-attachments/assets/57582b3c-6ca9-4086-871e-33188536266a" />


###### Kenapa tiap karakter jadi paket terpisah?

Karena Telnet dirancang untuk emulasi terminal interaktif secara real-time, sehingga berjalan dalam mode **karakter-per-karakter**, bukan mode baris. Setiap kali user menekan satu tombol, client langsung mengirim karakter tersebut ke server dalam satu segmen TCP terpisah, tanpa menunggu baris selesai diketik. Ini memungkinkan fitur seperti echo langsung dari server dan respons instan terhadap tombol kontrol (misal Ctrl+C). Akibatnya, di Wireshark akan terlihat banyak paket TCP kecil beruntun  masing-masing hanya membawa 1 byte data  untuk tiap karakter password yang diketik.

Bukti visualnya: di Packet List Pane (bukan Follow Stream), scroll ke bagian saat password diketik akan terlihat banyak paket kecil (panjang total frame sekitar 55-60 byte, isi data cuma 1 byte) beruntun dari Eiri ke Chisa, diselingi paket balasan echo dari Chisa.

###### ###### Screenshot Bukti:
<img width="1600" height="899" alt="WhatsApp Image 2026-09-15 at 15 45 51" src="https://github.com/user-attachments/assets/c5319918-ff5a-4607-a2c3-74179a4af6c8" />


###### Hentikan & simpan capture

1. Klik kanan kabel yang sama di GNS3 → **Stop capture**
2. Di Wireshark: **File → Save As**, simpan dengan nama jelas, misal:
   ```
   soal11-alice-scan-knights.pcapng`
   ```
---
###### soal 12

Untuk melakukan port scanning dari node Alice ke node Knights memakai Netcat pada port 22, 80 (terbuka), dan 7777 (tertutup), lalu menganalisis di Wireshark perbedaan TCP Flag antara port terbuka (SYN-ACK) dan port tertutup (RST-ACK).
<img width="743" height="514" alt="WhatsApp Image 2026-09-15 at 16 21 29" src="https://github.com/user-attachments/assets/4d21e88c-3f54-44ef-9ea2-16ef1ff008ed" />

###### Memastikan port 22 (SSH) terbuka di Knights

Cek dulu apakah SSH server sudah jalan:

```
ps aux | grep sshd
netstat -tulnp | grep :22
```

Kalau belum ada, install & jalankan (di konsol **Knights**):

```
apk update
apk add openssh
ssh-keygen -A
/usr/sbin/sshd
```

Cek lagi sudah listen:

```
netstat -tulnp | grep :22
```

###### Membuka port 80 (HTTP) di Knights

Paling gampang pakai Python built-in server (sudah dicontohkan di modul bagian 1.6.3):

```
python3 -m http.server 80 &
```

Cek:
```
netstat -tulnp | grep :80
```

###### Memastikan port 7777 TIDAK dibuka apa-apa

Tidak perlu ngapa-ngapain — selama tidak ada service yang sengaja dijalankan di port itu, otomatis **tertutup**. Cek buat mastiin:

```
netstat -tulnp | grep :7777
```

Harusnya **kosong** (tidak ada output).

###### Menyalakan Wireshark capture DULU

1. Klik kanan kabel di topologi GNS3 yang menghubungkan **Alice ↔ Switch1** (atau bisa juga di link Knights, tergantung mana yang gampang diakses).
2. **Start capture** → centang **Start the capture visualization program** → **OK**.
3. Di kolom filter Wireshark, ketik:
   
```
tcp
```

###### Scan pakai Netcat dari Alice

Balik ke konsol **Alice**. Cek dulu `nc` ada:

```
which nc
```

Kalau belum ada:

```
apk add netcat-openbsd
```

Scan tiap port satu-satu (biar gampang dibedain waktunya di Wireshark), pakai opsi `-z` (zero-I/O mode, khusus buat scanning) dan `-v` (verbose):

```
nc -zv [IP_KNIGHTS] 22
```

Tunggu hasilnya (biasanya langsung muncul `open` atau `succeeded`), lalu:

```
nc -zv [IP_KNIGHTS] 80
```

Lalu port yang tertutup:

```
nc -zv [IP_KNIGHTS] 7777
```

Kirim/screenshot hasil ketiga command ini — biasanya nc langsung bilang "open"/"succeeded" atau "refused"/"failed" di terminal.

###### Membaca hasil di Wireshark

Balik ke Wireshark. Sekarang persempit filter biar gampang baca **cuma paket SYN dan balasannya**:

```
tcp.flags.syn==1
```

Kamu akan lihat pola seperti ini per port:

###### Untuk port 22 dan 80 (terbuka):
```
Alice → Knights   [SYN]           (Alice minta koneksi)
Knights → Alice   [SYN, ACK]      (Knights: "oke, saya buka")
Alice → Knights   [ACK] atau [RST] (Alice: "oke makasih", lalu tutup lagi karena cuma scan)
```

###### Untuk port 7777 (tertutup):
```
Alice → Knights   [SYN]           (Alice minta koneksi)
Knights → Alice   [RST, ACK]      (Knights: "gaada yang denger di sini, nolak")
```

Cara baca flag-nya di Wireshark: klik paket balasan dari Knights, expand bagian **Transmission Control Protocol** di Packet Details Pane, cari baris **Flags**:

- Kalau isinya `0x012 (SYN, ACK)` → port terbuka
  
- Kalau isinya `0x014 (RST, ACK)` → port tertutup

##### Screenshot bukti
![Uploading WhatsApp Image 2026-09-15 at 16.21.29.jpeg…]()


Ambil 3 screenshot, masing-masing menunjukkan paket balasan dari Knights dengan Packet Details Pane ter-expand di bagian TCP Flags:

1. **Balasan port 22** → tunjukkan flag `SYN, ACK`
   <img width="1600" height="898" alt="WhatsApp Image 2026-09-15 at 16 28 08" src="https://github.com/user-attachments/assets/294c311d-7778-4264-9b10-8b74e7cd368f" />
  
2. **Balasan port 80** → tunjukkan flag `SYN, ACK`
   <img width="1600" height="899" alt="WhatsApp Image 2026-09-15 at 16 27 35" src="https://github.com/user-attachments/assets/6b936233-a293-4150-8cbd-dd15d6efa3d9" />

3. **Balasan port 7777** → tunjukkan flag `RST, ACK`
   <img width="1600" height="899" alt="WhatsApp Image 2026-09-15 at 16 26 56" src="https://github.com/user-attachments/assets/ab8d2410-82cb-42c8-a010-0d3a23593cb7" />

###### Hentikan & simpan capture

1. Klik kanan kabel yang sama di GNS3 → **Stop capture**
2. Di Wireshark: **File → Save As**, simpan dengan nama jelas, misal:
 ```
soal12-alice-scan-knights.pcapng
```
---
### soal 13

Menyuruh kita untuk menginstall OpenSSH di node Knights, membuat SSH key (ssh-keygen) di node Mika untuk user mika_admin, mengatur PasswordAuthentication no, lalu melakukan koneksi SSH dari Mika ke Knights, menangkap sesi dengan Wireshark, mengidentifikasi paket Protocol Version Exchange & Key Exchange, serta menjelaskan mengapa kredensial tidak terlihat plain text seperti di Telnet.


###### Menginstall OpenSSH server di Knights

Cek OS dulu:
```
cat /etc/os-release
```
```
apk update
apk add openssh
ssh-keygen -A
```

###### Membuat user mika_admin di Knights
```
adduser -D mika_admin          # Alpine
useradd -m -s /bin/bash mika_admin   # Debian
```
Set password sementara dulu (nanti dimatikan setelah key jalan):
```
passwd mika_admin
```

###### Menjalankan SSH server di Knights
```
/usr/sbin/sshd
```
Cek jalan:
```
netstat -tulnp | grep :22
```

---

###### Generate SSH key pair di Mika

Cek `ssh-keygen` ada:
```
which ssh-keygen
```
Kalau belum ada:
```
apk add openssh-client    # Alpine
apt install -y openssh-client    # Debian
```
Generate key pair:
```
ssh-keygen -t rsa -b 2048 -f /root/.ssh/id_rsa -N ""
```
**Penjelasan opsi:**
- `-t rsa -b 2048` → jenis dan panjang key
- `-f` → lokasi file key disimpan
- `-N ""` → tanpa passphrase (biar benar-benar tanpa password)

Cek hasilnya:
```
ls -la /root/.ssh/
```
Harus muncul 2 file: `id_rsa` (private, **jangan pernah dikirim ke mana pun**) dan `id_rsa.pub` (public, boleh disebar).


###### Menyalin public key dari Mika ke Knights

Di Mika, tampilkan isi public key:
```
cat /root/.ssh/id_rsa.pub
```
**Copy seluruh baris output ini** (mulai `ssh-rsa AAAA...` sampai akhir).

Balik ke Knights, buat folder `.ssh` untuk `mika_admin`:
```
mkdir -p /home/mika_admin/.ssh
nano /home/mika_admin/.ssh/authorized_keys
```
Paste public key tadi, simpan (`Ctrl+O`, Enter, `Ctrl+X`).

Set permission yang benar (SSH ketat soal ini — kalau salah, login ditolak):
```
chmod 700 /home/mika_admin/.ssh
chmod 600 /home/mika_admin/.ssh/authorized_keys
chown -R mika_admin:mika_admin /home/mika_admin/.ssh
```

######  Tes login pakai key (sebelum matikan password)

Dari Mika:
```
ssh -i /root/.ssh/id_rsa mika_admin@[IP_KNIGHTS]
```
Kalau berhasil masuk **tanpa diminta password** (atau cuma diminta konfirmasi fingerprint pertama kali, ketik `yes`), berarti key authentication sudah jalan. Keluar:
```
exit
```
*(Kalau masih diminta password, cek lagi permission folder `.ssh` atau isi `authorized_keys` di Step 5)*

---

###### Matikan password authentication di Knights

Edit config SSH:
```
nano /etc/ssh/sshd_config
```
Cari/ubah baris:
```
PasswordAuthentication no
PubkeyAuthentication yes
```
Simpan, lalu restart SSH:
```
pkill sshd
/usr/sbin/sshd
```

###### Menyalakan Wireshark

1. Klik kanan kabel **Mika ↔ Switch1** di GNS3
2. **Start capture** → centang visualisasi → OK
3. Filter:
   ```
   ssh
   ```

###### Login SSH lagi (buat direkam Wireshark)

Dari Mika:
```
ssh -i /root/.ssh/id_rsa mika_admin@[IP_KNIGHTS]
```
Jalankan perintah simpel:
```
whoami
```
Keluar:
```
exit
```


###### Membaca hasil di Wireshark**

Dengan filter `ssh` aktif, cari 3 tahap:

**A. Protocol Version Exchange**
2 paket paling awal (Mika ↔ Knights). Expand **SSH Protocol** di Packet Details:
```
SSH Version 2 (banner) exchange
```
Isinya string seperti `SSH-2.0-OpenSSH_9.x` — ini **satu-satunya bagian yang masih plaintext**, cuma info versi software, bukan kredensial.

**B. Key Exchange (KEX)**
Cari paket dengan info `Key Exchange Init` dan `Elliptic Curve Diffie-Hellman Key Exchange` — ini proses negosiasi algoritma enkripsi.

**C. Setelah KEX — semua terenkripsi**
Paket berikutnya (termasuk proses autentikasi dan perintah `whoami`) akan muncul sebagai **"Encrypted Packet"** — klik salah satu, isinya cuma random bytes tidak terbaca.


###### Follow TCP Stream (opsional, bagus buat laporan)

Klik kanan salah satu paket SSH → **Follow → TCP Stream**. Bandingkan dengan hasil Soal 11 (Telnet) — di sini cuma sedikit teks terbaca (banner versi), sisanya karakter acak/binary. **Beda total** dengan Telnet yang semuanya kebaca jelas.

###### Analisis untuk laporan

> Berbeda dengan Telnet yang mengirim setiap karakter (termasuk username dan password) sebagai plaintext murni, SSH melakukan proses **Key Exchange (KEX)** di awal sesi untuk menyepakati kunci enkripsi simetris antara client dan server secara aman (misal pakai Diffie-Hellman), tanpa pernah mengirim kunci rahasia lewat jaringan. Setelah KEX selesai, seluruh komunikasi berikutnya — termasuk proses autentikasi dan semua data sesi — dienkripsi pakai cipher yang disepakati (misal AES). Akibatnya, penyadap hanya melihat **Protocol Version Exchange** (info versi software, tidak sensitif) dan setelahnya murni **Encrypted Packet** yang tidak bisa dibaca tanpa kunci privat yang sah.

-

###### screenshot Bukti
1. Output `ssh -i ...` yang berhasil login **tanpa diminta password**
   <img width="1123" height="360" alt="WhatsApp Image 2026-09-16 at 07 52 31" src="https://github.com/user-attachments/assets/def40737-931d-4f19-be7b-74a0515526d8" />

   <img width="750" height="339" alt="WhatsApp Image 2026-09-16 at 08 12 55" src="https://github.com/user-attachments/assets/45fb6054-5233-4d44-b722-43e359e4e134" />


2. Isi `/etc/ssh/sshd_config` yang menunjukkan `PasswordAuthentication no`
   <img width="735" height="164" alt="WhatsApp Image 2026-09-15 at 16 36 58" src="https://github.com/user-attachments/assets/a71a2348-ee28-412c-bccb-ef40b12ee7fb" />

3. Wireshark — paket **Protocol Version Exchange**
   client:
   
   <img width="1600" height="839" alt="WhatsApp Image 2026-09-16 at 08 18 19" src="https://github.com/user-attachments/assets/b2126545-e482-4b8b-afc5-35beebbea25a" />

   server:

   <img width="1600" height="846" alt="WhatsApp Image 2026-09-16 at 08 18 57" src="https://github.com/user-attachments/assets/6e4e03e0-91a7-4c69-8366-a2af71031304" />

4. Wireshark — paket **Key Exchange Init**
   
client:

<img width="1600" height="846" alt="WhatsApp Image 2026-09-16 at 08 21 29" src="https://github.com/user-attachments/assets/64ed6e70-1c1f-49f7-ba20-9a5ff15dfdd3" />

 server:
 
   <img width="1600" height="844" alt="WhatsApp Image 2026-09-16 at 08 22 08" src="https://github.com/user-attachments/assets/e82be9bc-b396-4aa1-bb70-4e405d4bbdbb" />

5. Wireshark — salah satu paket **Key Exchange** 

   client:
    <img width="1600" height="849" alt="WhatsApp Image 2026-09-16 at 08 48 24" src="https://github.com/user-attachments/assets/ea331270-04b8-4be8-b601-f81a292d2e12" />

    server:
   <img width="1600" height="846" alt="WhatsApp Image 2026-09-16 at 08 50 38" src="https://github.com/user-attachments/assets/5e42afe0-a9a8-4329-808c-6d770885b18f" />

6. Wireshark — salah satu paket **Key Exchange ** **Encrypted Packet** setelah KEX
   <img width="1600" height="839" alt="WhatsApp Image 2026-09-16 at 08 52 55" src="https://github.com/user-attachments/assets/ed278fd0-f338-42be-8577-bcc720526c81" />


###### Hentikan & simpan capture

1. Klik kanan kabel yang sama di GNS3 → **Stop capture**
2. Di Wireshark: **File → Save As**, simpan dengan nama jelas, misal:
 ```
     soal13-mika-ssh-knights.pcapng
```
---

### soal 14

Untuk menganalisis file capture `wired_bruteforce.pcapng` ([link](https://drive.google.com/drive/folders/1-MloxOyGauBYglc6TKTQ84VeILvJjjG2?usp=sharing)) guna menemukan IP penyerang, target IP & port yang diserang, password `lain_admin` yang berhasil ditembus, serta web server software & versinya — lalu validasi temuan lewat `nc [IP_Group] 3401`.


**Step 1: Buka file capture di Wireshark**

Buka aplikasi Wireshark, lalu:
```
File → Open → pilih wired_bruteforce.pcapng
```
Tunggu sampai semua paket termuat di Packet List Pane.

---

**Step 2: Filter semua percobaan login (POST request)**

Di kolom display filter bagian atas, ketik:
```
http.request.method == "POST"
```
Tekan Enter. Wireshark akan menyaring dan hanya menampilkan paket-paket **request POST** — ini adalah semua percobaan login yang dikirim penyerang ke `/login.php`. Kalau brute-force-nya besar, di sini akan terlihat puluhan/ratusan baris paket serupa.

*(Opsional, biar lebih spesifik: tambahkan `and ip.addr==172.26.7.50` untuk fokus hanya ke traffic dari IP penyerang)*

---

**Step 3: Cari percobaan yang berhasil (respons 200 OK)**

Klik salah satu paket POST di Packet List, lalu:
1. Klik kanan paket tersebut
2. Pilih **Follow → HTTP Stream** (atau **Follow → TCP Stream** kalau versi Wireshark tidak punya opsi HTTP Stream)

Jendela baru akan terbuka menampilkan pasangan request-response lengkap dalam satu tampilan. Karena brute-force biasanya banyak percobaan, kamu perlu **cek stream satu-per-satu** (ada tombol navigasi "Stream" di pojok kanan bawah jendela Follow, klik panah untuk pindah ke stream berikutnya) sampai ketemu yang responsnya:
```
HTTP/1.1 200 OK
```
bukan:
```
HTTP/1.1 401 Unauthorized
```

Di stream yang berhasil ini, kamu akan melihat body request-nya berisi username & password yang berhasil menembus login — screenshot jendela Follow Stream ini sebagai bukti utama.

**Cara lebih cepat (opsional):** ketik filter khusus untuk langsung lompat ke respons sukses:
```
http.response.code == 200
```
Klik paket yang muncul, lalu klik kanan → Follow → HTTP Stream untuk lihat pasangan request-nya.

---

**Step 4: Cari versi web server dari response header**

Ganti filter jadi:
```
http.response
```
Ini akan menampilkan semua paket **balasan dari server** (baik yang 200 maupun 401 — keduanya biasanya mengirim header `Server` yang sama).

Klik salah satu paket respons, lalu di Packet Details Pane, expand bagian:
```
Hypertext Transfer Protocol
```
Cari baris:
```
Server: Apache/2.4.62
```
Ini menunjukkan software dan versi web server yang dipakai target. Kalau ada, catat juga baris `X-Powered-By` (biasanya menunjukkan versi bahasa pemrograman backend, misal PHP).

Screenshot Packet Details Pane ini dengan bagian HTTP ter-expand supaya baris `Server:` kelihatan jelas.

---

**Step 5: Buktikan pola brute-force (banyak percobaan gagal)**

Ganti filter jadi:
```
http.response.code == 401
```
Wireshark akan menampilkan **hanya** paket-paket dengan respons gagal (Unauthorized). Kalau brute-force-nya intensif, di sini akan terlihat jumlah paket yang banyak dan berurutan — ini bukti visual bahwa penyerang mencoba banyak kombinasi kredensial secara berulang sebelum akhirnya berhasil.

Screenshot Packet List Pane ini (dengan filter `http.response.code == 401` kelihatan di kolom filter) untuk menunjukkan volume percobaan gagalnya.

*(Tips tambahan: klik menu Statistics → Protocol Hierarchy atau Statistics → Conversations untuk melihat total jumlah request POST yang terkirim — ini bisa jadi angka pendukung di laporan, misal "56 percobaan sebelum berhasil")*

---

**screenshot Bukti:**
1. Packet List dengan filter `http.request.method == "POST"` aktif
   
<img width="1600" height="839" alt="WhatsApp Image 2026-09-16 at 11 29 10" src="https://github.com/user-attachments/assets/612133ec-e5ba-45f0-b7b0-356e4cc73669" />

2. Follow HTTP/TCP Stream yang menunjukkan request+response **200 OK** berisi kredensial berhasil

<img width="1600" height="836" alt="WhatsApp Image 2026-09-16 at 11 38 03" src="https://github.com/user-attachments/assets/1fea3e26-e71c-405c-a6ee-9e0b395a9c2e" />

3. Packet Details dengan header `Server: Apache/2.4.62` ter-expand

   <img width="1284" height="1014" alt="WhatsApp Image 2026-09-16 at 11 38 54" src="https://github.com/user-attachments/assets/84bdd04a-db48-47fa-bdea-32354c830f35" />

   kredensial yang berhasil:

   <img width="1284" height="1014" alt="WhatsApp Image 2026-09-16 at 11 38 54 (1)" src="https://github.com/user-attachments/assets/765b9ea4-7107-4282-a0d3-2fa21a941027" />

5. Packet List dengan filter `http.response.code == 401` menunjukkan banyaknya percobaan gagal
<img width="1002" height="619" alt="WhatsApp Image 2026-09-16 at 11 39 26" src="https://github.com/user-attachments/assets/591cdd1d-d2d0-44c6-98cd-57dcad720bc5" />

###### Step selanjutnya — validasi ke socket server:

nc [IP_Group] 3401

Socket ini akan menanyakan beberapa field satu per satu (IP penyerang, IP:port target, password, versi server). Jalankan dulu, lalu muncul di layar prompt pertanyaannya.

**Hasil Analisis file `wired_bruteforce.pcapng`:**

| Yang dicari | Jawaban |
|---|---|
| **IP Penyerang (Eiri)** | `172.26.7.50` |
| **IP Target (Alice)** | `172.26.7.100` |
| **Port yang diserang** | `8080` |
| **Tool serangan** | `ffuf` (Fuzz Faster U Fool) — terlihat di User-Agent |
| **Endpoint diserang** | `/login.php` (method POST) |
| **Username berhasil** | `lain_admin` |
| **Password berhasil** | `wired_pr0tocol_7` |
| **Web server & versi** | `Apache/2.4.62` |
| **Info tambahan** | `X-Powered-By: PHP/8.3.14` |

screenshot Bukti:

<img width="1002" height="619" alt="WhatsApp Image 2026-09-16 at 11 39 26" src="https://github.com/user-attachments/assets/32a6ad52-735d-442f-9128-ab95b203aee4" />
<img width="1600" height="841" alt="WhatsApp Image 2026-09-16 at 13 01 10" src="https://github.com/user-attachments/assets/7248abb4-8607-4629-8b2a-4def7179dc70" />

----
soal 15

Untuk menganalisis file capture `wired_usb_hid.pcap` ([link](https://drive.google.com/drive/folders/1oAPzN9IEN0264_LlvGnl_CsIiYh-Hp8w?usp=drive_link)) guna menemukan Vendor ID & Product ID perangkat USB, nomor device USB, serta pesan rahasia yang dicuri dari keystroke — lalu validasi temuan lewat `nc [IP_Group] 3402`.

## Step 1 — Buka file di Wireshark

1. Download file `soal15_wired_usb_hid.pcap` ke komputer kamu (kalau belum ada).
2. Buka Wireshark → **File → Open** → pilih file itu.

Kamu akan lihat daftar paket USB — ini beda dari capture jaringan biasa (Ethernet), soalnya ini nyadap komunikasi antara komputer dan perangkat USB.

## Step 2 — Cari Vendor ID & Product ID (deskriptor device)

1. Di kolom filter Wireshark, ketik:
```
usb.idVendor
```
Tekan Enter. Ini akan nyaring cuma paket yang berisi deskriptor device (paket awal-awal biasanya, pas device pertama kali dikenali/enumerasi).

2. Klik salah satu paket yang muncul di hasil filter.
3. Di **Packet Details Pane** (panel tengah), cari dan expand baris:
```
USB Device Descriptor
```
4. Di dalamnya akan ada baris:
```
idVendor: Logitech, Inc. (0x046d)
idProduct: ... (0xc31c)
```
Ini persis jawaban VID dan PID-nya. Screenshot bagian ini.

## Step 3 — Cari nomor alamat device USB

1. Ganti filter jadi:
```
usb.device_address
```
2. Lihat kolom **Device** di Packet List Pane (kalau kolom itu belum kelihatan, klik kanan header kolom manapun → **Column Preferences** → tambahkan kolom "Device"). Atau lebih gampang: klik paket manapun, di Packet Details cari baris paling atas **USB URB**, expand, cari baris:
```
Device: 7
```
3. Perhatikan: di awal-awal paket, device-nya masih `0` (device belum dikenali/di-assign alamat). Setelah proses **SET_ADDRESS** (bagian dari enumerasi USB), device-nya berubah jadi `7` — itu alamat resminya. Screenshot paket yang nunjukkin `Device: 7`.

## Step 4 — Cari pesan rahasia dari keystroke

Ini bagian paling ribet karena harus dibaca manual satu-satu. Caranya:

1. Ganti filter jadi:
```
usb.transfer_type == 0x01
```
Ini nyaring cuma **Interrupt Transfer** — jenis transfer yang dipakai keyboard buat ngirim tiap kali tombol ditekan/dilepas.

2. Kamu akan lihat banyak paket berpasang-pasangan: satu berisi data (pas tombol ditekan), satu lagi kosong/nol semua (pas tombol dilepas). **Fokus cuma ke yang datanya tidak nol.**

3. Klik satu paket yang datanya tidak nol. Di Packet Details, expand bagian data USB (biasanya muncul sebagai **Leftover Capture Data** atau **HID Data**, tergantung versi Wireshark). Kamu akan lihat 8 byte, contoh:
```
02 00 1a 00 00 00 00 00
```

4. Cara baca 8 byte itu:
   - **Byte pertama** = modifier (tombol bantu). `02` = Shift kiri ditekan, `00` = tidak ada modifier.
   - **Byte ketiga** = kode tombol yang ditekan (byte kedua selalu reserved/kosong).

5. Cocokkan kode tombol (byte ketiga) ke tabel **HID Keyboard Usage ID** (ini standar internasional, sama untuk semua keyboard):

| Kode (hex) | Huruf | Kode (hex) | Huruf | Kode (hex) | Huruf |
|---|---|---|---|---|---|
| 0x04 | a | 0x0F | l | 0x1A | w |
| 0x05 | b | 0x10 | m | 0x1B | x |
| 0x06 | c | 0x11 | n | 0x1C | y |
| 0x07 | d | 0x12 | o | 0x1D | z |
| 0x08 | e | 0x13 | p | 0x1E-0x27 | 1-0 |
| 0x09 | f | 0x14 | q | 0x2C | (spasi) |
| 0x0A | g | 0x15 | r | 0x2D | - (atau _ kalau Shift) |
| 0x0B | h | 0x16 | s | | |
| 0x0C | i | 0x17 | t | | |
| 0x0D | j | 0x18 | u | | |
| 0x0E | k | 0x19 | v | | |

Kalau byte modifier-nya `02` (Shift ditekan), hurufnya jadi **kapital** (atau simbol, misal `0x2D` + Shift = `_` bukan `-`).

6. **Lakukan ini satu-satu buat SETIAP paket** yang datanya tidak nol, urut dari atas ke bawah sesuai waktu (kolom **Time** atau **No.**). Catat huruf per huruf.

7. Kalau kamu urutkan semuanya, hasilnya bakal kebentuk kalimat: `Wired_Protocol_7_is_alive_2026`

## Tips biar nggak pusing decode manual satu-satu

Karena manual decode 30 paket capek, kamu bisa:
- **Export dulu semua paket interrupt** ke file: klik kanan salah satu paket hasil filter → **Export Packet Bytes**, atau
- Cukup screenshot tabel Packet List (dengan filter `usb.transfer_type == 0x01` aktif) dan Packet Details salah satu contoh paketnya sebagai bukti, lalu di laporan tulis hasil akhir yang sudah aku decode-in: `Wired_Protocol_7_is_alive_2026` — dengan menjelaskan metodenya (seperti Step 4 di atas) sebagai bukti kamu paham cara bacanya, tidak perlu screenshot literally 30 paket satu-satu.

## Step 5 — Screenshot yang wajib buat laporan

Cari Vendor ID & Product ID (deskriptor device)

<img width="1600" height="834" alt="WhatsApp Image 2026-09-16 at 13 12 29" src="https://github.com/user-attachments/assets/68df50dc-e7ab-4077-9527-3053ac506dbe" />

Paket **USB Device Descriptor** — expand, tunjukkan `idVendor` & `idProduct`

   <img width="1600" height="834" alt="WhatsApp Image 2026-09-16 at 13 12 29" src="https://github.com/user-attachments/assets/488b0d47-d2f3-42bf-b926-90126bae3003" />
   
Paket yang tunjukkin **Device: 7** (device address setelah enumerasi)
<img width="1600" height="839" alt="WhatsApp Image 2026-09-16 at 13 20 36" src="https://github.com/user-attachments/assets/3b591dd1-a54b-4505-b757-8b650ca9aa1b" />


## Step 6 — Validasi ke socket server

```
nc 10.4.89.247 3402
```
Socket ini akan menanyakan beberapa field satu per satu (IP penyerang, IP:port target, password, versi server). Jalankan dulu, lalu muncul di layar prompt pertanyaannya.

## Hasil Analisis `soal15_wired_usb_hid.pcap`

| Yang dicari | Jawaban |
|---|---|
| **Vendor ID (VID)** | `0x046D` (Logitech) |
| **Product ID (PID)** | `0xC31C` |
| **Nomor alamat device USB** | `7` (device address 7, di bus 2) |
| **Pesan rahasia dari keystroke** | `Wired_Protocol_7_is_alive_2026` |

Screenshot Bukti:
<img width="1150" height="1006" alt="WhatsApp Image 2026-09-16 at 13 30 58" src="https://github.com/user-attachments/assets/ac65cb0c-b950-410d-b257-26a9f979c3b2" />

---
### soal 16

Untuk menganalisis file capture `wired_ftp_theft.pcap` ([link](https://drive.google.com/drive/folders/1qBeAXVx1MG14L0jzGefqs3t8qO8VRMmb?usp=sharing)) guna menemukan IP server FTP penyerang, banner software FTP, kredensial login penyerang, serta ukuran file malware `knights_payload.exe` — lalu validasi temuan lewat `nc [IP_Group] 3403`.

Oke, aku uraikan pelan-pelan cara verifikasi manual di Wireshark buat soal 16 ini.

## Step 1 — Buka file di Wireshark

1. Download file `soal16_wired_ftp_theft.pcapng` ke komputer kamu.
2. Buka Wireshark → **File → Open** → pilih file tersebut.

## Step 2 — Filter khusus paket FTP

Di kolom filter (atas), ketik:
```
ftp
```
Tekan Enter. Sekarang cuma paket-paket FTP control channel yang muncul (bukan FTP-data). Kamu akan lihat **beberapa sesi berbeda** tercampur — ini penting, karena capture-nya sengaja berisi FTP server legit (Chisa) **dan** FTP server jahat (Eiri) sekaligus. Kita perlu pisahkan mana yang mana.

## Step 3 — Cari banner server yang mencurigakan

1. Scroll dari atas, perhatikan kolom **Info**. Cari baris yang isinya semacam:
```
Response: 220 ...
```
Ini adalah "salam pembuka" tiap kali ada yang connect ke server FTP.

2. Kamu akan nemu **3 banner berbeda**:
   - `220 InternalFileServer FTP ready` → ini server legit Chisa, abaikan
   - `220 wired-drop FTP server` → percobaan pertama ke server luar, tapi nanti gagal
   - `220 Welcome to Wired FTP Server (vsftpd 3.0.5)` → **ini yang penting**

3. Klik paket dengan banner `Welcome to Wired FTP Server (vsftpd 3.0.5)`. Lihat kolom **Source** — itu alamat IP server penyerangnya: `198.51.100.7`.

4. Expand **File Transfer Protocol (FTP)** di Packet Details Pane (panel tengah), lihat baris:
```
Response: 220 Welcome to Wired FTP Server (vsftpd 3.0.5)
```
**Screenshot ini** — ini bukti IP server + banner software.

## Step 4 — Cari kredensial login

1. Masih dengan filter `ftp`, cari paket **setelah** banner tadi (urutan waktu/nomor paket lebih besar) dengan Info:
```
Request: USER knights_agent
```
Klik paket ini, screenshot Packet Details-nya (expand FTP, lihat baris `Request command: USER`, `Request arg: knights_agent`).

2. Cari paket berikutnya dengan Info:
```
Request: PASS N4v1_s3cur3_2026
```
Screenshot juga ini.

3. Pastikan setelah itu ada balasan sukses:
```
Response: 230 Login successful.
```
Ini konfirmasi kredensial itu **valid** (beda dengan percobaan `guest`/`guest` sebelumnya yang dibalas `530 Login incorrect`).

## Step 5 — Cari ukuran file malware

1. Cari paket dengan Info:
```
Request: SIZE knights_payload.exe
```
2. Paket **balasannya** (tepat setelahnya) punya Info:
```
Response: 213 524288
```
Angka `524288` itu ukuran file dalam **bytes** (kalau dikonversi = 512 KB). Screenshot kedua paket ini (request + response).

3. Sebagai bukti tambahan, cari juga paket:
```
Response: 150 Opening BINARY mode data connection for knights_payload.exe (524288 bytes).
```
Ini juga menyebutkan ukuran yang sama, jadi saling menguatkan.

## Step 6 — Lihat seluruh percakapan sekaligus (biar lebih meyakinkan)

1. Klik kanan salah satu paket dari sesi `198.51.100.7` yang berhasil login tadi.
2. Pilih **Follow → TCP Stream**.
3. Jendela baru muncul menampilkan seluruh command-response FTP dalam satu tampilan teks — dari `USER knights_agent` sampai `226 Transfer complete.`. Screenshot ini sebagai bukti utama paling lengkap.

##  screenshot Bukti

1. Banner: `220 Welcome to Wired FTP Server (vsftpd 3.0.5)` + IP source `198.51.100.7`
   <img width="1600" height="844" alt="WhatsApp Image 2026-09-16 at 13 56 30" src="https://github.com/user-attachments/assets/c8138198-b4ba-4759-91b1-fc7008f69d6e" />

3. `USER knights_agent` dan `PASS N4v1_s3cur3_2026`
   <img width="1438" height="1020" alt="WhatsApp Image 2026-09-16 at 14 04 54" src="https://github.com/user-attachments/assets/b5d7e47b-771f-405e-aa23-fc0d4620ba3a" />

5. `230 Login successful.`
   <img width="1600" height="839" alt="WhatsApp Image 2026-09-16 at 13 58 53" src="https://github.com/user-attachments/assets/2f83c57c-e20a-4a18-9e31-feffb1fcf90b" />

6. `SIZE knights_payload.exe` → `213 524288`
   <img width="1600" height="846" alt="WhatsApp Image 2026-09-16 at 14 01 25" src="https://github.com/user-attachments/assets/9671c979-ecdd-48ba-8803-041507891fb2" />

8. (Opsional tapi bagus) Follow TCP Stream keseluruhan sesi
   <img width="1600" height="841" alt="WhatsApp Image 2026-09-16 at 14 01 46" src="https://github.com/user-attachments/assets/7dc239be-2f30-4581-809b-7ea19fee7b09" />

## Step 8 — Simpan bukti

Kalau ini file yang dikasih soal (bukan hasil capture kamu sendiri), tidak perlu di-save ulang — cukup screenshot-screenshot di atas dilampirkan ke laporan.

## Step 9 — Validasi ke socket server

Sekarang coba jalankan:
```
nc 10.4.89.247 3403
```
Socket ini akan menanyakan beberapa field satu per satu (IP penyerang, IP:port target, password, versi server). Jalankan dulu, lalu muncul di layar prompt pertanyaannya.

## Hasil Analisis `soal16_wired_ftp_theft.pcapng`

| Yang dicari | Jawaban |
|---|---|
| **IP server FTP penyerang (Eiri)** | `198.51.100.7` |
| **Banner software FTP** | `vsftpd 3.0.5` — dari banner: `220 Welcome to Wired FTP Server (vsftpd 3.0.5)` |
| **Kredensial login yang berhasil** | Username: `knights_agent`, Password: `N4v1_s3cur3_2026` |
| **Ukuran file `knights_payload.exe`** | **524288 bytes** (= 512 KB) |

Screenshot Bukti:
<img width="1147" height="1006" alt="WhatsApp Image 2026-09-16 at 14 13 29" src="https://github.com/user-attachments/assets/402f5d19-c74b-4b30-b6e1-0b37480b6f9b" />

---
### soal 17

Untuk menganalisis file capture `wired_http_c2.pcap` ([link](https://drive.google.com/drive/folders/1iPYESj5AN-uXYXfD2Wo2cRrm_Rigr_D6?usp=sharing)) guna menemukan domain (Host) sumber malware, IP server penyerang, nama file executable malware, serta kode status HTTP — lalu validasi temuan lewat `nc [IP_Group] 3404`.

## Bagian A — Buka & analisis di Wireshark

### Step 1 — Buka file
1. Buka aplikasi **Wireshark** di komputer kamu.
2. Klik **File** → **Open**.
3. Cari file `soal17_wired_http_c2__1_.pcapng` (atau nama file yang kamu punya), klik **Open**.

### Step 2 — Filter cuma paket HTTP
1. Klik kolom putih panjang di bagian atas (kolom filter).
2. Ketik:
```
http
```
3. Tekan **Enter**.
4. Sekarang tabel di atas cuma menampilkan beberapa baris (bukan ratusan) — ini paket-paket HTTP.

### Step 3 — Cari request yang mencurigakan
1. Lihat kolom **Info** di tiap baris tabel.
2. Kamu akan lihat beberapa baris berbeda (beberapa Host berbeda). Cari baris yang tulisannya:
```
GET /navi_agent.exe HTTP/1.1
```
3. **Klik sekali** di baris itu (klik di area barisnya, nanti jadi biru/ke-highlight).

### Step 4 — Catat IP server
1. Masih di baris yang sama, lihat kolom **Destination** — itu IP server penyerangnya.
2. Akan tertulis: `203.0.113.42`

### Step 5 — Cari respons dari server
1. Di tabel yang sama, cari baris **setelahnya** (nomor lebih besar) yang Info-nya:
```
HTTP/1.1 200 OK
```
dan sumbernya (**Source**) dari `203.0.113.42`.
2. **Klik sekali** di baris itu.

### Step 6 — Buka detail di panel tengah
1. Setelah baris response itu di-klik, lihat ke **panel tengah** (Packet Details Pane) — ada beberapa baris dengan tanda panah `>` di kiri.
2. Cari baris **"Hypertext Transfer Protocol"**.
3. Klik tanda panah `>` di sebelah kirinya biar terbuka (expand).
4. Sekarang akan muncul detailnya, termasuk baris:
```
HTTP/1.1 200 OK\r\n
```
dan
```
Content-Disposition: attachment; filename="navi_agent.exe"
```

**Screenshot Bukti:**

ip server penyerang

<img width="1600" height="891" alt="WhatsApp Image 2026-09-16 at 16 06 31" src="https://github.com/user-attachments/assets/21169ff0-561e-4f5a-9d03-488b35a3c45b" />

nama file malware

<img width="1600" height="899" alt="WhatsApp Image 2026-09-16 at 16 08 34" src="https://github.com/user-attachments/assets/d17f059a-7c5e-45bd-af11-8262e2a99676" />

bukti status code http

<img width="1600" height="899" alt="WhatsApp Image 2026-09-16 at 16 12 25" src="https://github.com/user-attachments/assets/b6c1a757-3ed8-4c0d-bb6e-63498de1ae26" />

percakapan request client dan server

<img width="1288" height="1079" alt="WhatsApp Image 2026-09-16 at 16 14 50" src="https://github.com/user-attachments/assets/6d7c0775-ede8-490c-8196-a7ad64e0b6a2" />

<img width="1600" height="899" alt="WhatsApp Image 2026-09-16 at 16 18 50" src="https://github.com/user-attachments/assets/136bf5e9-c445-421a-8c36-3eedfdec12c9" />

### Step 7 — Lihat percakapan lengkap (opsional tapi bagus)
1. Klik kanan (klik tombol kanan mouse) pada baris `GET /navi_agent.exe` tadi.
2. Arahkan ke **Follow** → klik **HTTP Stream**.
3. Jendela baru muncul, tunjukkan seluruh request+response jadi satu teks. **Screenshot ini juga.**

## Validasi ke socket server

### Step 9 — Jalankan

Sekarang coba jalankan:
```
nc 10.4.89.247 3404
```
Tekan Enter.

Socket ini akan menanyakan beberapa field satu per satu (IP penyerang, IP:port target, password, versi server). Jalankan dulu, lalu muncul di layar prompt pertanyaannya.

## Hasil Analisis `soal17_wired_http_c2.pcapng`

| Yang dicari | Jawaban |
|---|---|
| Domain (Host) | `wired-update.net` |
| IP server penyerang | `203.0.113.42` |
| Nama file malware | `navi_agent.exe` |
| Kode status HTTP | `200` |

Screenshot Bukti:

<img width="862" height="727" alt="WhatsApp Image 2026-09-16 at 16 26 18" src="https://github.com/user-attachments/assets/6209b0bf-8cd4-41eb-b9a8-09118a3fa791" />

---
### soal 18

Untuk menganalisis file capture `wired_smb_transfer.pcapng` ([link](https://drive.google.com/file/d/1XBtKWtNM_RrSBTp2e3O5vBdiklcPNsKs/view?usp=sharing)) guna menemukan protokol yang dieksploitasi, IP pengirim & penerima, folder tujuan malware, serta nama file executable-nya — lalu validasi temuan lewat `nc [IP_Group] 3405`.

 Screenshot Bukti:
 
 SMB2
 
<img width="1600" height="887" alt="WhatsApp Image 2026-09-16 at 16 37 47" src="https://github.com/user-attachments/assets/303c9f43-7983-480f-ac80-e6a67cc96d2e" />

field dialect

<img width="1600" height="896" alt="WhatsApp Image 2026-09-16 at 16 39 20" src="https://github.com/user-attachments/assets/185aeeeb-504c-48f5-ba9c-e090295aa1fa" />

ip pengirim dan penerima

<img width="1600" height="899" alt="WhatsApp Image 2026-09-16 at 16 40 46" src="https://github.com/user-attachments/assets/09774a0a-753b-44be-b5f6-63fe980d8d6b" />

tree connect request

<img width="1600" height="902" alt="WhatsApp Image 2026-09-16 at 16 42 08" src="https://github.com/user-attachments/assets/da075e31-2094-4334-a6c4-8cfce042c8f1" />

nama file malware

<img width="1600" height="899" alt="WhatsApp Image 2026-09-16 at 16 43 19" src="https://github.com/user-attachments/assets/7a960c58-58c9-4812-b0ac-69209bd1f3c8" />

## Validasi ke socket server

### Step 9 — Jalankan

Sekarang coba jalankan:
```
nc 10.4.89.247 3405

```
Tekan Enter.

Socket ini akan menanyakan beberapa field satu per satu (IP penyerang, IP:port target, password, versi server). Jalankan dulu, lalu muncul di layar prompt pertanyaannya.

## Hasil Analisis `soal18

Screenshot Bukti:

<img width="954" height="1077" alt="WhatsApp Image 2026-09-16 at 16 50 49" src="https://github.com/user-attachments/assets/338cf973-e6f6-4bd0-af60-adda65630471" />

---
### soal 19

Untuk menganalisis file capture `wired_smtp_threat.pcap` ([link](https://drive.google.com/drive/folders/1RAW0cMoGDDStPyFHeJ_0t9kkoLGBsCmH?usp=sharing)) guna menemukan email korban, password yang diklaim bocor, jenis malware, batas waktu (hari), serta MailClientID — lalu validasi temuan lewat `nc [IP_Group] 3406`.

Screenshot Bukti:

 SMTP AWAL

 <img width="1600" height="899" alt="WhatsApp Image 2026-09-16 at 17 04 33" src="https://github.com/user-attachments/assets/4a4a19b3-f60a-46ee-85d9-9a38fc253362" />
 
converstation sus

<img width="1600" height="901" alt="WhatsApp Image 2026-09-16 at 17 06 34" src="https://github.com/user-attachments/assets/5f5b6225-42ab-4f50-b348-53dfbe09b0f3" />


filter ip addr == 203.0.113.100

<img width="1600" height="898" alt="WhatsApp Image 2026-09-16 at 17 10 00" src="https://github.com/user-attachments/assets/311e9895-effa-49fa-aae1-4034d54ab303" />

isi pesan attacker

<img width="1600" height="898" alt="WhatsApp Image 2026-09-16 at 17 11 41" src="https://github.com/user-attachments/assets/df0864eb-67ba-4e79-a5f4-5aaa8669efe8" />

## Validasi ke socket server

### Step 9 — Jalankan

Sekarang coba jalankan:
```
nc 10.4.89.247 3406

```
Tekan Enter.

Socket ini akan menanyakan beberapa field satu per satu (IP penyerang, IP:port target, password, versi server). Jalankan dulu, lalu muncul di layar prompt pertanyaannya.

## Hasil Analisis `soal19

Screenshot Bukti:

<img width="1170" height="605" alt="WhatsApp Image 2026-09-16 at 17 16 49" src="https://github.com/user-attachments/assets/0e6254db-4343-4371-968f-281b7856fddf" />

---

soal 20

Untuk menganalisis file capture `wired_tls_decrypt.pcapng` bersama `keyslogfile.txt` ([link](https://drive.google.com/file/d/1F7xN3ydIrA-pZaCb32MGseVeHKt-D_qZ/view?usp=sharing)) guna menemukan versi TLS, domain (SNI), IP server HTTPS penyerang, User-Agent, serta method & path HTTP tersembunyi — lalu validasi temuan lewat `nc [IP_Group] 3407`.

Screenshot Bukti:

version

<img width="1600" height="900" alt="WhatsApp Image 2026-09-16 at 17 21 45" src="https://github.com/user-attachments/assets/a35cedb0-4deb-4ae6-8e9e-a8f5a8b7e783" />

server name

<img width="1600" height="898" alt="WhatsApp Image 2026-09-16 at 17 26 53" src="https://github.com/user-attachments/assets/5989dfa5-7d98-492a-8148-5d8edaee84c9" />

filter http

<img width="1333" height="1077" alt="WhatsApp Image 2026-09-16 at 17 31 25" src="https://github.com/user-attachments/assets/81a41fe2-510d-469b-9f84-c9a2c8cb6fb7" />

User Agent

<img width="1600" height="899" alt="WhatsApp Image 2026-09-16 at 17 32 17" src="https://github.com/user-attachments/assets/8d94062c-63ad-4e33-962d-20bd11c59c3b" />

TLS

<img width="858" height="707" alt="WhatsApp Image 2026-09-16 at 17 42 31" src="https://github.com/user-attachments/assets/65ba9045-c0dd-4279-9f17-e7d968ec665d" />

FILTER TLS

<img width="1331" height="1074" alt="WhatsApp Image 2026-09-16 at 17 43 23" src="https://github.com/user-attachments/assets/4a7f87b7-27da-48a6-9428-73a7c5cf48b8" />

## Validasi ke socket server

### Step 9 — Jalankan

Sekarang coba jalankan:
```
nc 10.4.89.247 3407

```
Tekan Enter.

Socket ini akan menanyakan beberapa field satu per satu (IP penyerang, IP:port target, password, versi server). Jalankan dulu, lalu muncul di layar prompt pertanyaannya.

## Hasil Analisis `soal20

Screenshot Bukti:

<img width="965" height="685" alt="WhatsApp Image 2026-09-16 at 17 49 59" src="https://github.com/user-attachments/assets/09bef642-beca-4cdd-9cbb-aba0526e10c6" />

---
