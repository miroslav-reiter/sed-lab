# 04 - Mazanie riadkov

Cieľ: precvičiť príkaz `d` na mazanie riadkov podľa čísla, rozsahu a vzoru.

## Úlohy

1. Zmaž druhý riadok zo súboru `data/text.txt`.
2. Zmaž riadky 1 až 2 zo súboru `data/text.txt`.
3. Zo súboru `data/config.txt` odstráň komentáre začínajúce znakom `#`.
4. Zo súboru `data/config.txt` odstráň prázdne riadky.
5. Zo súboru `data/notes.txt` odstráň riadky obsahujúce `DEBUG`.

## Pomôcka

```bash
sed '2d' súbor
sed '1,2d' súbor
sed '/^#/d' súbor
sed '/^$/d' súbor
```
