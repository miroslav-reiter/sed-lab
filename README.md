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
- ak nie je súbor → číta zo STDIN
- ak je viac súborov → sekvenčné spracovanie

### 3. Behaviorálne pravidlá
- bez `-n` sa každý riadok vypíše
- s `-n` iba riadený výstup (`p`)

### 4. Kombinácia skriptov
- `-e` inline príkazy
- `-f` skripty zo súboru
- viac `-e` = reťazenie

## 🧾 Cheat Sheet (rýchly prehľad)

### Nahrádzanie
```bash
sed 's/stary/novy/' file
sed 's/stary/novy/g' file
```

### Mazanie
```bash
sed '2d' file
sed '/pattern/d' file
```

### Výpis
```bash
sed -n '1p' file
sed -n '/pattern/p' file
```

### Insert / Append
```bash
sed '1i TEXT' file
sed '1a TEXT' file
```

### Replace celý riadok
```bash
sed 's/.*/NEW LINE/' file
```

## 🔒 Bezpečnostné poznámky

- `-i` používať iba so zálohou (`.bak`)
- nikdy nespúšťať sed priamo na systémové konfigurácie bez kontroly
- logy a configy vždy najprv čítať bez úprav
- `--sandbox` používať pri testovaní
- pipeline príkazy môžu prepísať dáta nevratne

## 🪟 Windows podpora

`sed` nie je natívne vo Windows.

Odporúčané riešenia:

- WSL (Ubuntu) – odporúčané
- Cygwin
- Git Bash
- MSYS2
- natívny sed/gawk build

Rozdiely:

- Windows cesty vs Linux `/`
- CRLF vs LF
- rôzne shell správanie

## 📚 Užitočné odkazy a zdroje

- GNU sed manual: https://www.gnu.org/software/sed/
- Open Group POSIX: https://pubs.opengroup.org/onlinepubs/9699919799/
- GNU documentation: https://www.gnu.org/

## 🗣️ Výslovnosť a pôvod

- `sed` = stream editor
- výslovnosť: „sed“ /sɛd/
- vznik v Unix prostredí Bell Labs

## 🧠 Zhrnutie

- sed = stream editor
- pracuje riadok po riadku
- ideálny pre transformácie textu
- kľúčové sú `s///`, `-n`, `-i`
