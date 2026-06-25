#!/usr/bin/env bash
set -euo pipefail

printf '\n# 06 - Úprava na mieste a sed skripty\n'

cp data/urls.txt /tmp/urls.txt
sed -i.bak 's/http:/https:/g' /tmp/urls.txt
cat /tmp/urls.txt
cat /tmp/urls.txt.bak

sed -e 's/Linux/GNU Linux/g' -e '/awk/d' data/text.txt

cat > /tmp/demo.sed <<'SED'
s/Linux/GNU Linux/g
/grep/d
SED
sed -f /tmp/demo.sed data/text.txt
