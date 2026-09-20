```sh
#!/bin/sh

# Download manifesto dari FTP Chisa

ftp 192.225.2.2 << EOF
mika
mika
get protocol7_manifesto.txt
bye
EOF

echo ""
echo "=== Isi file hasil download ==="
cat protocol7_manifesto.txt
```
