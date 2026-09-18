#!/bin/sh
set -eu
TARGET="${1:?Masukkan IP Knights}"
for port in 22 80 7777; do
    nc -zv -w 3 "$TARGET" "$port" || true
done
