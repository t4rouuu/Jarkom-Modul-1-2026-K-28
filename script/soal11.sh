```sh
#!/bin/sh

# Install Telnet
apk add busybox-extras

# Buat user phantom_user
id phantom_user >/dev/null 2>&1 || adduser -D phantom_user

echo "phantom_user:wired_ghost" | chpasswd

# Jalankan Telnet Server
pkill telnetd 2>/dev/null
sleep 1
telnetd -p 23 -l /bin/login &

echo "=== Telnet Server aktif ==="
ps aux | grep telnetd
```
