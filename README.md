# Jarkom-Modul-1-2026-K-28

## Kelompok K-28

| Nama | NRP |
| :---: | :---: |
| Maitasya Rohmatul Ula | 5027251026 |
| A. Algifari Rantiga Isdar | 5027251084 |

soal 1

Untuk mempersiapkan pembangunan The Wired, kita membangun topologi jaringan The Wired di GNS3, dengan Router Lain sebagai pusat yang terhubung ke tiga Switch: Switch 1 (menuju Alice & Mika), Switch 2 (menuju Chisa), dan Switch 3 (menuju Knights & Eiri) — di mana kelima entitas tersebut dikonfigurasi sebagai Client, menggunakan prefix IP sesuai kelompok masing-masing.

### (Bangun Topologi):

***Langkah 1: Siapkan node-nya***
Tarik ke workspace GNS3:
- 1 Router (kasih 4 adapter/interface)
- 1 NAT node
- 3 Switch (Ethernet switch)
- 5 Client (1 adapter aja tiap client)

**Langkah 2: Kasih nama biar gak bingung**
Rename semua node sesuai perannya:
`Router-Lain`, `Switch1`, `Switch2`, `Switch3`, `Alice`, `Mika`, `Chisa`, `Knights`, `Eiri`

**Langkah 3: Sambungkan kabelnya**
- NAT → Router-Lain (di eth0)
- Switch1 → Router-Lain (di eth1), lalu Switch1 → Alice, dan Switch1 → Mika
- Switch2 → Router-Lain (di eth2), lalu Switch2 → Chisa
- Switch3 → Router-Lain (di eth3), lalu Switch3 → Knights, dan Switch3 → Eiri

*(Jadi Router-Lain punya 4 kaki: 1 ke NAT, 3 ke masing-masing switch)*

**Langkah 4: Setting IP di tiap node**
Edit file `/etc/network/interfaces` di setiap node sesuai IP yang sudah ditentukan kelompok kalian. Contoh settingan Router-Lain ada di Fase 2, dan contoh settingan Client polanya sama seperti di modul bagian 2.7.2 — tinggal disesuaikan IP dan interface-nya saja.

**Langkah 5: Tes dulu**
Nyalakan semua node, lalu di tiap node ketik:
```
ip a
```
Hasil:


soal 2

Untuk menghubungkan Router Lain ke jaringan internet publik melalui NAT/DHCP pada interface eth0, karena The Wired saat itu masih terisolasi dari dunia luar.

soal 3

Untuk memastikan seluruh Entitas (Client) di bawah Switch 1, Switch 2, dan Switch 3 dapat saling terhubung dan berkomunikasi satu sama lain, dengan mengkonfigurasi routing pada Router Lain setelah router tersebut terhubung ke internet.

soal 4

Untuk mengkonfigurasi firewall/iptables (NAT Masquerade) dan DNS resolver di Router Lain, agar setiap Entitas (Client) dapat terhubung ke internet secara mandiri — dibuktikan dengan bisa ping ke 8.8.8.8 dan membuka domain google.com.

soal 5

Untuk memastikan seluruh konfigurasi jaringan tetap tersimpan (persisten) meskipun semua node di-restart, serta membuat script verifikasi `/root/cek_status.sh` di Router Lain yang menampilkan ringkasan interface (`ip -br a`) dan status tabel NAT (`iptables -t nat -L -v -n`) setelah reboot.

soal 6

Untuk menjalankan traffic generator ([link](https://drive.google.com/drive/folders/1ZjFvWIjvAQAjE9pPthm7V_bGyaSt93lY?usp=sharing)) pada node Mika, pada node Mika, lalu melakukan packet sniffing dengan Wireshark di interface node Mika menggunakan display filter khusus untuk protokol DNS atau ICMP, serta menunjukkan screenshot hasil filter beserta ringkasan paket yang lolos.

soal 7

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
