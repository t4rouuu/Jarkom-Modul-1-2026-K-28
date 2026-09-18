#!/bin/sh
# Konfigurasi IP router/lab sesuai topologi.
# Sesuaikan nama interface bila berbeda.
set -eu

ip addr add 192.225.1.1/24 dev eth1 2>/dev/null || true
ip addr add 192.225.2.1/24 dev eth2 2>/dev/null || true
ip addr add 192.225.3.1/24 dev eth3 2>/dev/null || true
ip link set eth1 up
ip link set eth2 up
ip link set eth3 up
ip addr show
