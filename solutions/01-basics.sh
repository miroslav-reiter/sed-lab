#!/usr/bin/env bash
set -euo pipefail

printf '\n# 01 - Základy sed\n'

sed --version | head -n 1
sed --help | head -n 5
sed '' data/text.txt
sed 's/Linux/GNU Linux/' data/text.txt
sed 's/Linux/GNU Linux/g' data/text.txt
