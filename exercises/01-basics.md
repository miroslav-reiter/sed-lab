# 01 - Základy sed

Cieľ: overiť, že `sed` funguje a pochopiť základnú syntax.

## Úlohy

1. Zobraz verziu programu `sed`.
2. Zobraz pomocníka programu `sed`.
3. Vypíš obsah súboru `data/text.txt` cez `sed` bez zmeny textu.
4. Nahraď prvý výskyt slova `Linux` textom `GNU Linux`.
5. Nahraď všetky výskyty slova `Linux` textom `GNU Linux`.

## Pomôcka

```bash
sed 's/staré/nové/' súbor
sed 's/staré/nové/g' súbor
```
