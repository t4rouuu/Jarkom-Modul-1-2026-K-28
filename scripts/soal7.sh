#setup_ftp.sh

#!/bin/sh
set -eu
# Jalankan dari klien FTP; ubah IP server bila perlu.
SERVER="${1:-192.225.2.2}"
FILE="${2:-signal_alice.txt}"

ftp -inv "$SERVER" <<EOF
user alice alice
binary
put $FILE
bye
EOF
