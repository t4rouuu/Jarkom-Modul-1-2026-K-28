```sh
#!/bin/sh

echo "=== Port Scan Knights ==="

echo ""
echo "[*] Testing Port 22 (SSH)"
nc -zv 192.225.3.2 22

echo ""
echo "[*] Testing Port 80 (HTTP)"
nc -zv 192.225.3.2 80

echo ""
echo "[*] Testing Port 7777"
nc -zv 192.225.3.2 7777
```
