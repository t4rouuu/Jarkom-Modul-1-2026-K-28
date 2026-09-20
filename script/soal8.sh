```sh
#!/bin/sh

# Upload file laporan ke FTP Chisa

ftp 192.225.2.2 << EOF
alice
alice
put /root/knights_report.txt
bye
EOF
```
