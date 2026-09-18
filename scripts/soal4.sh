#!/bin/sh
set -eu

apk update
apk add vsftpd

mkdir -p /var/wired/data
for u in alice mika eiri; do
    id "$u" >/dev/null 2>&1 || adduser -D -h /var/wired/data "$u"
done

echo 'alice:alice' | chpasswd
echo 'mika:mika' | chpasswd
echo 'eiri:eiri' | chpasswd

chown alice:alice /var/wired/data
chmod 775 /var/wired/data

cat > /etc/vsftpd/vsftpd.conf <<'CONF'
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
CONF

echo 'eiri' > /etc/vsftpd/user_list
mkdir -p /etc/vsftpd/user_conf
printf '%s\n' 'write_enable=NO' > /etc/vsftpd/user_conf/mika

cp /root/signal_alice.txt /var/wired/data/ 2>/dev/null || true
cp /root/protocol7_manifesto.txt /var/wired/data/ 2>/dev/null || true
chown alice:alice /var/wired/data/*.txt 2>/dev/null || true
chmod 644 /var/wired/data/*.txt 2>/dev/null || true

pkill vsftpd 2>/dev/null || true
sleep 1
vsftpd /etc/vsftpd/vsftpd.conf &
echo 'FTP server aktif.'
