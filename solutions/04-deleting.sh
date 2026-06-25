#!/usr/bin/env bash
set -euo pipefail

printf '\n# 04 - Mazanie riadkov\n'

sed '2d' data/text.txt
sed '1,2d' data/text.txt
sed '/^#/d' data/config.txt
sed '/^$/d' data/config.txt
sed '/DEBUG/d' data/notes.txt
