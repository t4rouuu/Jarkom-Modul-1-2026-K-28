```sh
#!/bin/sh

echo "=== Ringkasan Interface ==="
ip -br a

echo ""
echo "=== Tabel NAT ==="
iptables -t nat -L -v -n
```
