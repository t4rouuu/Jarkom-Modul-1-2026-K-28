#!/bin/sh
set -eu
apk add openssh
rc-update add sshd default 2>/dev/null || true
ssh-keygen -A
rc-service sshd restart 2>/dev/null || /usr/sbin/sshd

echo 'Server SSH aktif.'
echo 'Salin public key Mika ke /home/mika_admin/.ssh/authorized_keys.'
