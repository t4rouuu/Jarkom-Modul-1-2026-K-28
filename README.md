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

###### Memberikan nama sesuai soal

Rename semua node sesuai perannya:

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

###### Merestart networking / reboot node

agar konfigurasi di jalankan.

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

➡️ Berarti Router-Lain **sudah berhasil online** dan siap jadi pintu keluar untuk semua Client di bawahnya.

jika gagal (`Destination unreachable` atau `100% packet loss`), kemungkinan masalah di NAT node atau eth0 belum dapat IP cek dengan `ip a` di eth0 dulu.

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

Supaya semua Client (Alice, Mika, Chisa, Knights, Eiri) bisa akses internet **sendiri-sendiri** lewat Router-Lain, bukan cuma Router-Lain doang yang online.

###### Menyetting NAT & Firewall di Router-Lain

Ketik perintah-perintah ini di konsol Router-Lain:

```
iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
iptables -A FORWARD -i eth1 -o eth0 -j ACCEPT
iptables -A FORWARD -i eth2 -o eth0 -j ACCEPT
iptables -A FORWARD -i eth3 -o eth0 -j ACCEPT
iptables -A FORWARD -i eth0 -m state --state ESTABLISHED,RELATED -j ACCEPT
```

**Penjelasan :**
| Perintah | Fungsinya |
|---|---|
| `MASQUERADE` di eth0 | "Menyamarkan" IP lokal Client jadi IP Router-Lain saat keluar ke internet ini inti dari NAT |
| `FORWARD -i eth1/eth2/eth3 -o eth0` | Mengizinkan traffic dari Switch1/2/3 diteruskan **keluar** lewat eth0 (internet) |
| `FORWARD -i eth0 ... ESTABLISHED,RELATED` | Mengizinkan balasan dari internet **masuk kembali** ke Client yang tadi request |

*(Kalau baris terakhir gak ada, Client bisa kirim request keluar tapi gak akan pernah terima balasannya)*

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

**Cara kerjanya:** 

Baris `up` itu artinya "jalankan perintah ini otomatis setiap kali interface eth0 dinyalakan" jadi walau node di-restart, semua setting NAT & forwarding akan otomatis terpasang lagi tanpa perlu diketik manual.

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

Script ini membuat satu file `cek_status.sh` yang kalau dijalankan, langsung nampilin dua hal sekaligus:
**Ringkasan interface** (`ip -br a`) → cek IP tiap eth masih terpasang atau tidak
**Tabel NAT** (`iptables -t nat -L -v -n`) → cek aturan MASQUERADE masih ada atau tidak

*(Script ini aman disimpan agar tidak ikut hilang saat container restart)*

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
3. File ini nanti dilampirkan sebagai bukti di laporan.

---
### soal 7

Untuk membuat FTP Server di node Chisa dengan shared folder `/var/wired/data`, menerapkan kebijakan akses (alice: read & write, mika: read-only, eiri: no access/blacklist), serta membuktikannya dengan membuat file `signal_alice.txt` dari akun alice dan menunjukkan penolakan akses saat eiri mencoba login.

soal 8

Untuk melakukan koneksi FTP dari node Knights ke FTP Server Chisa memakai akun alice, mengupload file ([link](https://drive.google.com/drive/folders/1tvZpueSH9E3GWwXM6KNnM64Y5wNoIAYP?usp=sharing)), lalu menganalisis sesi Wireshark untuk menemukan perintah STOR, kode status 226, dan port data TCP mode PASV.

soal 9

Untuk mengunduh dokumen Protokol Tujuh ([link](https://drive.google.com/drive/folders/1S3hG0dnZBTkCta4uILWwKVc6dSYYGRJ6?usp=sharing)) dari FTP Server Chisa memakai akun mika, lalu membuktikan pembatasan read-only dengan mencoba upload file baru dan menunjukkan pesan error 550 Permission denied.

soal 10

Untuk mengirim ping dari node Knights ke node Chisa dengan payload 128 bytes, interval 0.3 detik, sebanyak 77 paket (ping -c 77 -s 128 -i 0.3 <IP_Chisa>), lalu menganalisis di Wireshark nilai ICMP Type/Code untuk Echo Request vs Echo Reply, serta packet loss dan RTT (min/avg/max).

soal 11

Untuk membuktikan kelemahan protokol Telnet dengan membuat akun phantom_user/wired_ghost di telnetd node Chisa, login dari node Eiri, menangkap sesi dengan Wireshark, menunjukkan kredensial plain text lewat Follow TCP Stream, serta menjelaskan mengapa tiap karakter terkirim dalam paket TCP terpisah.

soal 12

Untuk melakukan port scanning dari node Alice ke node Knights memakai Netcat pada port 22, 80 (terbuka), dan 7777 (tertutup), lalu menganalisis di Wireshark perbedaan TCP Flag antara port terbuka (SYN-ACK) dan port tertutup (RST-ACK).

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
