# 05 - Regulárne výrazy v sed

Cieľ: precvičiť základné a rozšírené regulárne výrazy cez `-E`.

## Úlohy

1. V súbore `data/notes.txt` nahraď všetky čísla textom `CISLO`.
2. V súbore `data/notes.txt` nahraď e-mailovú adresu textom `EMAIL`.
3. V súbore `data/access.log` nahraď IP adresy textom `IP`.
4. V súbore `data/products.csv` nahraď všetky ceny číslom `0`.
5. V súbore `data/passwd.sample` vypíš riadky používateľov so shellom `/bin/bash`.

## Pomôcka

```bash
sed -E 's/[0-9]+/CISLO/g' súbor
sed -E 's/[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+/IP/g' súbor
```
