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

### `-n`
Selektívny výstup (potláča automatický print).

### `-e`
Viac príkazov v jednom behu.

### `-f`
Skript zo súboru.

### `-i`
In-place úprava (kritické: vždy backup).

### `-E` / `-r`
Extended regex (lepší pattern matching).

### `--posix`
Striktná kompatibilita.

### `--sandbox`
Bezpečnostne obmedzené vykonávanie.

### `--debug`
Tracing vykonávania.

### `--version` / `--help`
Meta informácie.

## 🧾 Cheat Sheet (rozšírený prehľad)

### 🔁 Nahrádzanie
```bash
sed 's/old/new/' file
sed 's/old/new/g' file
sed 's/^start/BEGIN/' file
sed 's/end$/FIN/' file
```

### 🧭 Adresovanie riadkov
```bash
sed '5d' file
sed '1,10d' file
sed '/error/d' file
sed '/start/,/end/d' file
```

### 📤 Výpis
```bash
sed -n 'p' file
sed -n '1p' file
sed -n '/pattern/p' file
```

### ✏️ Vkladanie
```bash
sed '1i TEXT' file
sed '1a TEXT' file
sed '3c REPLACE LINE' file
```

### 🔧 Pokročilé operácie
```bash
sed -E 's/[0-9]+/NUM/g' file
sed -n '=' file
sed G file
```

## 🔒 Bezpečnostné poznámky (rozšírené)

Používanie `sed` v praxi má riziká najmä pri automatizácii.

### Kritické riziká:

- `-i` bez backupu môže zničiť dáta
- nesprávny regex môže prepísať celý súbor
- pipeline môže prepísať vstup bez návratu

### Best practices:

- vždy používať `.bak`:
```bash
sed -i.bak 's/a/b/' file
```

- testovať bez `-i`
- používať `--sandbox` pri neznámych skriptoch
- logy nikdy neupravovať priamo v produkcii

### Atomicita
sed nie je transakčný nástroj → neexistuje rollback

## 🪟 Windows podpora (rozšírené)

`sed` nie je natívny Windows nástroj.

### Varianty:

| Prostredie | Hodnotenie | Poznámka |
|---|---|---|
| WSL | ⭐⭐⭐⭐⭐ | najlepšia voľba |
| Cygwin | ⭐⭐⭐⭐ | Unix vrstva |
| MSYS2 | ⭐⭐⭐⭐ | vývojárske prostredie |
| Git Bash | ⭐⭐⭐ | základné použitie |
| natívny sed | ⭐⭐ | obmedzené |

### Dôležité rozdiely:

- CRLF vs LF
- Windows cesty vs Linux `/`
- quoting rozdiely (PowerShell vs Bash)
- výkon (WSL výrazne lepší)

### Mapovanie diskov:

- WSL: `/mnt/c/...`
- Cygwin: `/cygdrive/c/...`

### Odporúčanie:

Použiť WSL pre školenia a produkčné demo.

## 📚 Užitočné odkazy a zdroje (rozšírené)

### Dokumentácia:

- GNU sed: https://www.gnu.org/software/sed/
- POSIX: https://pubs.opengroup.org/onlinepubs/9699919799/
- GNU manuals: https://www.gnu.org/

### Knihy:

- Aho, Kernighan, Weinberger – *The AWK Programming Language*
- Dale Dougherty, Arnold Robbins – *sed & awk*
- Arnold Robbins – *Effective awk Programming*

### Praktické zdroje:

- Linux man pages: `man sed`
- GNU coreutils docs

## 🗣️ Výslovnosť a pôvod

- sed = stream editor
- výslovnosť: /sɛd/
- Unix Bell Labs

## 🧠 Zhrnutie

- sed = stream editor
- line-based processing
- vhodný pre transformácie
- kľúčové: `s///`, `-i`, regex, pipelines
