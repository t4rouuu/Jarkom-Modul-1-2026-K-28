#!/bin/sh
set -eu
apk add openssh-client
mkdir -p "$HOME/.ssh"
chmod 700 "$HOME/.ssh"

if [ ! -f "$HOME/.ssh/id_ed25519" ]; then
    ssh-keygen -t ed25519 -f "$HOME/.ssh/id_ed25519" -N ''
fi

TARGET="${1:?Masukkan IP Knights}"
USER_NAME="${2:-mika_admin}"
echo "Public key: $HOME/.ssh/id_ed25519.pub"
echo "Salin key tersebut ke server, lalu jalankan:"
echo "ssh-copy-id $USER_NAME@$TARGET"
echo "Setelah itu:"
echo "ssh $USER_NAME@$TARGET"
