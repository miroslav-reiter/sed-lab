#!/usr/bin/env bash
set -euo pipefail

printf '\n# 02 - Výpis riadkov\n'

sed -n '1p' data/text.txt
sed -n '1,3p' data/text.txt
sed -n '/sed/p' data/text.txt
sed -n '/ 404 /p' data/access.log
sed -n '/\/bin\/bash/p' data/passwd.sample
