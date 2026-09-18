#knights_report.txt

#!/bin/sh
set -eu
SERVER="${1:-192.225.2.2}"
FILE="${2:-signal_alice.txt}"

ftp -inv "$SERVER" <<EOF
user mika mika
binary
get $FILE
bye
EOF
