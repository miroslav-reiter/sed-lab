# 06 - Úprava súboru na mieste a sed skripty

Cieľ: bezpečne precvičiť `-i`, zálohy, `-e` a `-f`.

## Úlohy

1. Skopíruj `data/urls.txt` do `/tmp/urls.txt`.
2. V súbore `/tmp/urls.txt` nahraď `http:` za `https:` pomocou `sed -i.bak`.
3. Over rozdiel medzi `/tmp/urls.txt` a `/tmp/urls.txt.bak`.
4. Použi viac príkazov cez `-e`: nahraď `Linux` a odstráň riadky s `awk`.
5. Vytvor súbor `/tmp/demo.sed` a spusti ho cez `sed -f`.

## Pomôcka

```bash
cp data/urls.txt /tmp/urls.txt
sed -i.bak 's/http:/https:/g' /tmp/urls.txt
sed -e 's/Linux/GNU Linux/g' -e '/awk/d' data/text.txt
sed -f /tmp/demo.sed data/text.txt
```
