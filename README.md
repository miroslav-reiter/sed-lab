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

Používa sa na selektívny výstup:
```bash
sed -n '1p' file
```

### `-e` (expression)
Umožňuje reťaziť viac príkazov:
```bash
sed -e 's/a/b/' -e 's/c/d/' file
```

### `-f` (file script)
Načítanie príkazov zo súboru:
```bash
sed -f script.sed file
```

### `-i` (in-place editácia)
Mení súbor priamo:
```bash
sed -i.bak 's/a/b/' file
```
⚠️ vždy používať zálohu

### `-E` / `-r` (extended regex)
Zapína rozšírené regulárne výrazy:
```bash
sed -E 's/[0-9]+/X/' file
```

### `--posix`
Vypína GNU rozšírenia a zaisťuje kompatibilitu

### `--sandbox`
Obmedzuje operácie (bez zápisu a systémových zásahov)

### `--debug`
Zobrazuje krokové vykonávanie príkazu

### `--version`
Zobrazí verziu programu

### `--help`
Zobrazí kompletnú pomoc

## 🧪 Detailný rozpis výstupu `sed --help`

Výstup `sed` helpu má pevne definovanú štruktúru:

### 1. Usage sekcia
```text
Usage: sed [OPTION]... {script-only-if-no-other-script} [input-file]...
```

Vysvetlenie:
- `OPTION` → všetky prepínače (`-n`, `-i`, `-e`)
- `...` → možnosť opakovania parametrov
- `{script-only-if-no-other-script}` → sed skript, ak nie je použitý `-e` alebo `-f`
- `[input-file]...` → jeden alebo viac vstupných súborov

### 2. Spracovanie vstupu
- ak nie je súbor → číta zo STDIN (klávesnica / pipe)
- ak je viac súborov → spracúva ich sekvenčne

### 3. Behaviorálne pravidlá
- bez `-n` sa každý riadok automaticky vypíše
- s `-n` sa vypisujú iba riadené výstupy (`p`)

### 4. Kombinácia skriptov
- `-e` → inline skript
- `-f` → skript zo súboru
- viac `-e` sa správa ako reťazenie príkazov

### 5. Praktický význam pre prax
Tento výstup je dôležitý pri:
- debugovaní sed skriptov
- tvorbe automatizácie
- pochopení pipeline spracovania dát

## 🧠 Zhrnutie

- Kali a Ubuntu používajú GNU sed
- rozdiely sú minimálne
- kľúčové je pochopiť `-n`, `-i`, `-e`, regex
- help output je štruktúrovaný a predvídateľný

## 📚 Ostatné sekcie

(pokračujú cheat sheet, príklady, cvičenia...)