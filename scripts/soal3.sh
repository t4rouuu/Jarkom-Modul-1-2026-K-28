#!/bin/sh
set -eu
# Ganti eth0 jika interface menuju Internet berbeda.
iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
iptables -A FORWARD -i eth0 -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
iptables -A FORWARD -o eth0 -j ACCEPT
iptables -t nat -L -n -v
