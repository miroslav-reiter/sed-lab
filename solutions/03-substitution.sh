#!/usr/bin/env bash
set -euo pipefail

printf '\n# 03 - Nahrádzanie textu\n'

sed 's/Linux/GNU Linux/' data/text.txt
sed 's/Linux/GNU Linux/g' data/text.txt
sed 's/enabled=false/enabled=true/' data/config.txt
sed 's/port=8080/port=9090/' data/config.txt
sed 's#http://#https://#g' data/urls.txt
