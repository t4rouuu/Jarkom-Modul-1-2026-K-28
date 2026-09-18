#!/bin/sh
set -eu
TARGET="${1:?Masukkan IP Chisa, contoh: $0 192.225.2.2}"
ping -c 77 -s 128 -i 0.3 "$TARGET"
