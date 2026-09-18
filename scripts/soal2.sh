#!/bin/sh
set -eu
sysctl -w net.ipv4.ip_forward=1
printf '%s\n' 'net.ipv4.ip_forward=1' > /etc/sysctl.d/99-wired-forwarding.conf
sysctl -p /etc/sysctl.d/99-wired-forwarding.conf
