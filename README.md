# 🧪 Online Kurz Sed (sed-lab)

Testovací repozitár na praktické trénovanie príkazu `sed` v Linuxe, hlavne v Kali Linuxe a Ubuntu Linuxe.

Repozitár je určený na precvičenie práce s textom, riadkami, regulárnymi výrazmi, nahrádzaním, mazaním, výpismi a jednoduchými transformáciami priamo v termináli.

## 📌 Čo je sed

`sed` znamená **stream editor**. Je to príkazový nástroj na spracovanie textového toku.

Typický spôsob práce:

```bash
sed 'príkaz' súbor
```

`sed` načíta riadok, aplikuje naň zadaný príkaz a výsledok vypíše na štandardný výstup. Pôvodný súbor sa nemení, pokiaľ nepoužijeme voľbu `-i`.

## 🎯 Na čo sa sed používa v praxi

`sed` používame hlavne na rýchle textové úpravy v termináli alebo shell skriptoch.

- nahrádzanie textu,
- výpis riadkov,
- filtrovanie,
- mazanie,
- log analýza,
- úpravy konfigurácií,
- pipeline spracovanie dát.

## 🧩 sed vs grep vs awk

| Nástroj | Použitie |
|---|---|
| grep | vyhľadávanie |
| sed | transformácia textu |
| awk | stĺpcové spracovanie |

## 🖥️ Výstupy sed v Kali a Ubuntu

### 🐉 Kali Linux

```text
Usage: sed [OPTION]... {script-only-if-no-other-script} [input-file]...
```

**Vysvetlenie hlavných volieb:**

- `-n` → vypne automatický výpis riadkov (používa sa s `p`)
- `-e` → pridá sed príkaz
- `-f` → načíta skript zo súboru
- `-i` → editácia súboru na mieste (rizikové, odporúča sa `.bak`)
- `-E` / `-r` → rozšírené regulárne výrazy
- `--posix` → vypne GNU rozšírenia (portable režim)
- `--sandbox` → obmedzený režim bez riskantných operácií
- `--debug` → krokovanie vykonávania skriptu
- `--version` → verzia nástroja
- `--help` → pomocník

---

### 🐧 Ubuntu Linux

Výstup je prakticky identický, keďže ide o GNU sed:

```text
Usage: sed [OPTION]... {script-only-if-no-other-script} [input-file]...
```

Rozdiel nie je v syntaxi, ale v:

- verzii GNU sed,
- dostupných rozšíreniach,
- správaní pri `--posix` a `--sandbox`.

## ⚙️ Detailné vysvetlenie najdôležitejších prepínačov

### `-n` (silent mode)
Zabraňuje automatickému výpisu riadkov.
Používa sa s `p`:
```bash
sed -n '1p' file
```

### `-e` (expression)
Umožňuje viac príkazov:
```bash
sed -e 's/a/b/' -e 's/c/d/' file
```

### `-f` (file script)
Načítanie skriptu zo súboru:
```bash
sed -f script.sed file
```

### `-i` (in-place)
Úprava súboru:
```bash
sed -i.bak 's/a/b/' file
```
⚠️ nebezpečné bez zálohy

### `-E` / `-r`
Rozšírené regex:
```bash
sed -E 's/[0-9]+/X/' file
```

### `--posix`
Zakáže GNU rozšírenia → kompatibilita

### `--sandbox`
Zakáže nebezpečné operácie (r/w/spawn)

### `--debug`
Zobrazí vykonávanie krok po kroku

### `--version`
Zobrazí verziu sed

### `--help`
Zobrazí pomoc

## 🧠 Zhrnutie

- Kali a Ubuntu používajú GNU sed
- rozdiel je minimálny
- najdôležitejšie sú `-n`, `s///`, `-i`, regex

## 📚 Ostatné sekcie

(pokračujú cheat sheet, príklady, cvičenia...)
