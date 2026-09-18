#!/bin/sh
set -eu
apk add busybox-extras
id phantom_user >/dev/null 2>&1 || adduser -D phantom_user
echo 'phantom_user:phantom_user' | chpasswd
pkill telnetd 2>/dev/null || true
telnetd -p 23 -l /bin/login
echo 'Telnet aktif pada port 23.'
