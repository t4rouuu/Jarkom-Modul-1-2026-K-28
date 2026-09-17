# Jarkom-Modul-1-2026-K-28

## Kelompok K-28

| Nama | NRP |
| :---: | :---: |
| Maitasya Rohmatul Ula | 5027251026 |
| A. Algifari Rantiga Isdar | 5027251084 |
---
### soal 1

Untuk mempersiapkan pembangunan The Wired, kita membangun topologi jaringan The Wired di GNS3, dengan Router Lain sebagai pusat yang terhubung ke tiga Switch: Switch 1 (menuju Alice & Mika), Switch 2 (menuju Chisa), dan Switch 3 (menuju Knights & Eiri) di mana kelima entitas tersebut dikonfigurasi sebagai Client, menggunakan prefix IP sesuai kelompok masing-masing.

##### Bangun Topologi:

###### Menyiapkan nodenya

Tarik ke workspace GNS3:
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

###### Menyeting IP di tiap node

Edit file `/etc/network/interfaces` di setiap node sesuai IP yang sudah ditentukan. Contoh settingan Router-Lain ada di Modul Fase 2, dan contoh settingan Client polanya sama seperti di modul bagian 2.7.2  tinggal disesuaikan IP dan interfacenya saja.

###### Menguji coba
Menyalakan semua node, lalu di tiap node ketik:

```
ip a
```

Hasil:

###### Topologi

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

2. **Perintah STOR + penolakan**
   
   (waktu upload gagal) → dua paket:
   - `STOR test_mika.txt`
   - Balasan server: `550 Permission denied.`

Klik kedua paket ini, expand bagian *File Transfer Protocol (FTP)* di Packet Details.

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

  Output terminal ping lengkap (command + statistik RTT & packet loss)

Screenshot output ini utuh.

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
 
 Paket Echo Request di Wireshark (Type: 8, Code: 0)
 
###### Cek ukuran paket sesuai `-s 128`**

Klik salah satu Echo Request, lihat kolom **Length** di Packet List (atau expand bagian **Data** di ICMP) — payload-nya sekitar 128 bytes (total frame lebih besar karena ada header Ethernet+IP+ICMP di depannya, itu wajar).

###### Bukti screenshot:

Paket Echo Reply di Wireshark (Type: 0, Code: 0)

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

1. Klik kanan → **Follow → TCP Stream**

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


###### Kenapa tiap karakter jadi paket terpisah?

Karena Telnet dirancang untuk emulasi terminal interaktif secara real-time, sehingga berjalan dalam mode **karakter-per-karakter**, bukan mode baris. Setiap kali user menekan satu tombol, client langsung mengirim karakter tersebut ke server dalam satu segmen TCP terpisah, tanpa menunggu baris selesai diketik. Ini memungkinkan fitur seperti echo langsung dari server dan respons instan terhadap tombol kontrol (misal Ctrl+C). Akibatnya, di Wireshark akan terlihat banyak paket TCP kecil beruntun  masing-masing hanya membawa 1 byte data  untuk tiap karakter password yang diketik.

Bukti visualnya: di Packet List Pane (bukan Follow Stream), scroll ke bagian saat password diketik akan terlihat banyak paket kecil (panjang total frame sekitar 55-60 byte, isi data cuma 1 byte) beruntun dari Eiri ke Chisa, diselingi paket balasan echo dari Chisa.

###### ###### Screenshot Bukti:

###### Hentikan & simpan capture

1. Klik kanan kabel yang sama di GNS3 → **Stop capture**
2. Di Wireshark: **File → Save As**, simpan dengan nama jelas, misal:
   ```
   soal11-alice-scan-knights.pcapng`
   ```
---
###### soal 12

Untuk melakukan port scanning dari node Alice ke node Knights memakai Netcat pada port 22, 80 (terbuka), dan 7777 (tertutup), lalu menganalisis di Wireshark perbedaan TCP Flag antara port terbuka (SYN-ACK) dan port tertutup (RST-ACK).



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

Ambil 3 screenshot, masing-masing menunjukkan paket balasan dari Knights dengan Packet Details Pane ter-expand di bagian TCP Flags:

1. **Balasan port 22** → tunjukkan flag `SYN, ACK`
2. **Balasan port 80** → tunjukkan flag `SYN, ACK`
3. **Balasan port 7777** → tunjukkan flag `RST, ACK`

#####  jelaskan mengapa kredensial tidak terlihat dalam bentuk teks terbuka seperti pada Telnet? 

>SSH melakukan Key Exchange (pertukaran kunci) di awal koneksi untuk menyepakati kunci enkripsi sesi antara client dan server, tanpa mengirim kunci itu sendiri lewat jaringan. Setelah kunci disepakati, semua data (termasuk username, password, dan isi sesi) dienkripsi. Jadi kalau disadap di Wireshark, yang terlihat cuma "Encrypted Packet" — bytes acak yang tidak terbaca — bukan teks polos seperti Telnet.

###### Hentikan & simpan capture

1. Klik kanan kabel yang sama di GNS3 → **Stop capture**
2. Di Wireshark: **File → Save As**, simpan dengan nama jelas, misal:
 ```
soal12-alice-scan-knights.pcapng
```
---

soal 13

Menyuruh kita untuk menginstall OpenSSH di node Knights, membuat SSH key (ssh-keygen) di node Mika untuk user mika_admin, mengatur PasswordAuthentication no, lalu melakukan koneksi SSH dari Mika ke Knights, menangkap sesi dengan Wireshark, mengidentifikasi paket Protocol Version Exchange & Key Exchange, serta menjelaskan mengapa kredensial tidak terlihat plain text seperti di Telnet.

soal 14

Untuk menganalisis file capture `wired_bruteforce.pcapng` ([link](https://drive.google.com/drive/folders/1-MloxOyGauBYglc6TKTQ84VeILvJjjG2?usp=sharing)) guna menemukan IP penyerang, target IP & port yang diserang, password `lain_admin` yang berhasil ditembus, serta web server software & versinya — lalu validasi temuan lewat `nc [IP_Group] 3401`.

soal 15

Untuk menganalisis file capture `wired_usb_hid.pcap` ([link](https://drive.google.com/drive/folders/1oAPzN9IEN0264_LlvGnl_CsIiYh-Hp8w?usp=drive_link)) guna menemukan Vendor ID & Product ID perangkat USB, nomor device USB, serta pesan rahasia yang dicuri dari keystroke — lalu validasi temuan lewat `nc [IP_Group] 3402`.

soal 16

Untuk menganalisis file capture `wired_ftp_theft.pcap` ([link](https://drive.google.com/drive/folders/1qBeAXVx1MG14L0jzGefqs3t8qO8VRMmb?usp=sharing)) guna menemukan IP server FTP penyerang, banner software FTP, kredensial login penyerang, serta ukuran file malware `knights_payload.exe` — lalu validasi temuan lewat `nc [IP_Group] 3403`.

soal 17

Untuk menganalisis file capture `wired_http_c2.pcap` ([link](https://drive.google.com/drive/folders/1iPYESj5AN-uXYXfD2Wo2cRrm_Rigr_D6?usp=sharing)) guna menemukan domain (Host) sumber malware, IP server penyerang, nama file executable malware, serta kode status HTTP — lalu validasi temuan lewat `nc [IP_Group] 3404`.

soal 18

Untuk menganalisis file capture `wired_smb_transfer.pcapng` ([link](https://drive.google.com/file/d/1XBtKWtNM_RrSBTp2e3O5vBdiklcPNsKs/view?usp=sharing)) guna menemukan protokol yang dieksploitasi, IP pengirim & penerima, folder tujuan malware, serta nama file executable-nya — lalu validasi temuan lewat `nc [IP_Group] 3405`.

soal 19

Untuk menganalisis file capture `wired_smtp_threat.pcap` ([link](https://drive.google.com/drive/folders/1RAW0cMoGDDStPyFHeJ_0t9kkoLGBsCmH?usp=sharing)) guna menemukan email korban, password yang diklaim bocor, jenis malware, batas waktu (hari), serta MailClientID — lalu validasi temuan lewat `nc [IP_Group] 3406`.

soal 20

Untuk menganalisis file capture `wired_tls_decrypt.pcapng` bersama `keyslogfile.txt` ([link](https://drive.google.com/file/d/1F7xN3ydIrA-pZaCb32MGseVeHKt-D_qZ/view?usp=sharing)) guna menemukan versi TLS, domain (SNI), IP server HTTPS penyerang, User-Agent, serta method & path HTTP tersembunyi — lalu validasi temuan lewat `nc [IP_Group] 3407`.
