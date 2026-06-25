# 03 - Nahrádzanie textu

Cieľ: precvičiť príkaz `s///`, príznak `g` a alternatívne oddeľovače.

## Úlohy

1. V súbore `data/text.txt` nahraď prvý výskyt `Linux` za `GNU Linux`.
2. Nahraď všetky výskyty `Linux` za `GNU Linux`.
3. V súbore `data/config.txt` zmeň `enabled=false` na `enabled=true`.
4. V súbore `data/config.txt` zmeň `port=8080` na `port=9090`.
5. V súbore `data/urls.txt` zmeň `http://` na `https://` pomocou oddeľovača `#`.

## Pomôcka

```bash
sed 's/text/novy_text/' súbor
sed 's/text/novy_text/g' súbor
sed 's#http://#https://#g' súbor
```
