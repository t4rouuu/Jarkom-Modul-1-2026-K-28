#!/bin/sh
set -eu
echo '=== Interface ==='
ip -br addr
echo
echo '=== Routing ==='
ip route
echo
echo '=== NAT ==='
iptables -t nat -L -n -v 2>/dev/null || true
echo
echo '=== Listening ports ==='
ss -lntup 2>/dev/null || netstat -lntup 2>/dev/null || true
