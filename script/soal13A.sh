```sh
#!/bin/sh

# Install OpenSSH Server
apk add openssh

# Generate host keys
ssh-keygen -A

# Buat user mika_admin
id mika_admin >/dev/null 2>&1 || adduser -D mika_admin

echo "mika_admin:temppass123" | chpasswd

# Konfigurasi SSH
grep -q "^PasswordAuthentication no" /etc/ssh/sshd_config || \
echo "PasswordAuthentication no" >> /etc/ssh/sshd_config

grep -q "^PubkeyAuthentication yes" /etc/ssh/sshd_config || \
echo "PubkeyAuthentication yes" >> /etc/ssh/sshd_config

# Folder SSH
mkdir -p /home/mika_admin/.ssh
chmod 700 /home/mika_admin/.ssh

echo "=== SSH Server siap ==="
```
