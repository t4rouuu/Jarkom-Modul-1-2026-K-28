```sh
#!/bin/sh

# ============================================
# Setup FTP Server - Node Chisa
# ============================================

apk update
apk add vsftpd

mkdir -p /var/wired/data

# Membuat user
id alice >/dev/null 2>&1 || adduser -D -h /var/wired/data alice
id mika >/dev/null 2>&1 || adduser -D -h /var/wired/data mika
id eiri >/dev/null 2>&1 || adduser -D -h /var/wired/data eiri

# Password
echo "alice:alice" | chpasswd
echo "mika:mika" | chpasswd
echo "eiri:eiri" | chpasswd

# Permission folder
chown alice:alice /var/wired/data
chmod 775 /var/wired/data

# Konfigurasi vsftpd
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

# Blacklist Eiri
echo "eiri" > /etc/vsftpd/user_list

# Konfigurasi user Mika read-only
mkdir -p /etc/vsftpd/user_conf

cat > /etc/vsftpd/user_conf/mika << 'EOF'
write_enable=NO
EOF

# PAM configuration
cat > /etc/pam.d/vsftpd << 'EOF'
auth required pam_unix.so
account required pam_unix.so
EOF

# Jalankan FTP
pkill vsftpd 2>/dev/null
sleep 1
vsftpd /etc/vsftpd/vsftpd.conf &

echo "=== FTP Server selesai ==="
ps aux | grep vsftpd
```
