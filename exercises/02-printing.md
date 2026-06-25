# 02 - Výpis riadkov

Cieľ: precvičiť `-n`, príkaz `p`, čísla riadkov a vzory.

## Úlohy

1. Vypíš iba prvý riadok zo súboru `data/text.txt`.
2. Vypíš riadky 1 až 3 zo súboru `data/text.txt`.
3. Vypíš iba riadky, ktoré obsahujú slovo `sed`.
4. Vypíš iba riadky z logu, ktoré obsahujú stavový kód `404`.
5. Vypíš iba riadky zo súboru `data/passwd.sample`, ktoré obsahujú `/bin/bash`.

## Pomôcka

```bash
sed -n '1p' súbor
sed -n '1,3p' súbor
sed -n '/vzor/p' súbor
```
