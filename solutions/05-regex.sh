#!/usr/bin/env bash
set -euo pipefail

printf '\n# 05 - Regulárne výrazy\n'

sed -E 's/[0-9]+/CISLO/g' data/notes.txt
sed -E 's/[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+/EMAIL/g' data/notes.txt
sed -E 's/[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+/IP/g' data/access.log
sed -E 's/,[0-9]+,/,0,/' data/products.csv
sed -n '/\/bin\/bash/p' data/passwd.sample
