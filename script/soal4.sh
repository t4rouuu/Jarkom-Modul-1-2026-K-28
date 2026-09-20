```sh
#!/bin/sh

# Setup NAT Internet

sysctl -w net.ipv4.ip_forward=1

iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE

iptables -A FORWARD -i eth1 -o eth0 -j ACCEPT
iptables -A FORWARD -i eth2 -o eth0 -j ACCEPT
iptables -A FORWARD -i eth3 -o eth0 -j ACCEPT

iptables -A FORWARD -i eth0 -m state --state ESTABLISHED,RELATED -j ACCEPT

echo "=== NAT Setup selesai ==="
iptables -t nat -L -v -n
```
