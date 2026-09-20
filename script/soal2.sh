```sh
#!/bin/sh

# Setup Internet Router Lain

cat > /etc/network/interfaces << 'EOF'
auto eth0
iface eth0 inet dhcp

auto eth1
iface eth1 inet static
    address 192.225.1.1
    netmask 255.255.255.0

auto eth2
iface eth2 inet static
    address 192.225.2.1
    netmask 255.255.255.0

auto eth3
iface eth3 inet static
    address 192.225.3.1
    netmask 255.255.255.0
EOF

echo "=== Konfigurasi Router Lain selesai ==="
ip -br a
```
