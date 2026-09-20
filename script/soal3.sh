```sh
#!/bin/sh

# Aktifkan IP Forwarding
sysctl -w net.ipv4.ip_forward=1

echo "=== IP Forwarding Status ==="
cat /proc/sys/net/ipv4/ip_forward

echo "=== Routing Table ==="
ip route
```
