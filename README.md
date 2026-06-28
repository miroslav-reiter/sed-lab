# 🧪 Online Kurz Sed (sed-lab)

Testovací repozitár na praktické trénovanie príkazu `sed` v Linuxe, hlavne v Kali Linuxe a Ubuntu Linuxe.
Repozitár je určený na precvičenie práce s textom, riadkami, regulárnymi výrazmi, nahrádzaním, mazaním, výpismi a jednoduchými transformáciami priamo v termináli.

## 📌 Čo je sed

`sed` (stream editor) je príkazový textový nástroj určený na **automatizované spracovanie a transformáciu textu po riadkoch**. Pracuje ako stream procesor – vstup číta postupne, riadok po riadku, aplikuje pravidlá a výsledok posiela na výstup.

### 🧠 Pôvod a história

`sed` vznikol v prostredí Bell Labs ako súčasť Unixového ekosystému.
- Autor: **Lee E. McMahon**
- Obdobie vzniku: **1973–1974**
- Inšpirácia: textový editor `ed`

Cieľom bolo odstrániť potrebu interaktívneho editora a umožniť **skriptovateľné úpravy textu v pipeline (automatizovane)**.

`sed` sa stal súčasťou Unix filozofie:
> „rob jednu vec a rob ju dobre“ – spracovanie textových tokov

### ⚙️ Ako sed funguje

`sed` spracováva vstup takto:
- načíta riadok zo vstupu
- porovná ho so vzormi (pattern)
- aplikuje príkazy (action)
- vypíše upravený riadok

### 📌 Základná syntax

```bash
sed [OPTIONS] 'SCRIPT' subor
```

### 🧪 Základné formy príkazu

```bash
sed 's/stary/novy/' subor.txt
```

alebo explicitnejší tvar:

```bash
sed -e 's/stary/novy/' subor.txt
```

### 🧩 Štruktúra sed skriptu

```text
[address] command
```

Kde:
- `address` → riadok alebo rozsah (napr. 1,5 alebo /error/)
- `command` → operácia (s, d, p, i, a, c)

### 🧪 Príklady adresovania

- `5d` → zmaže 5. riadok
- `1,10d` → zmaže rozsah riadkov
- `/error/d` → zmaže riadky obsahujúce pattern

### ⚙️ Typický workflow

```bash
cat file | sed 's/foo/bar/'
```

alebo

```bash
sed -n '1,10p' file
```

## 🎯 Na čo sa sed používa v praxi

`sed` používame hlavne na rýchle textové úpravy v termináli alebo shell skriptoch.

- nahrádzanie textu,
- výpis riadkov,
- filtrovanie,
- mazanie,
- log analýza,
- úpravy konfigurácií,
- pipeline spracovanie dát.

## 🧩 grep vs sed vs awk (praktická architektúra spracovania textu)

| Nástroj | Úloha v pipeline | Model správania | Typický výstup |
|---|---|---|---|
| grep | filtrácia | boolean matcher (true/false) | subset riadkov |
| sed | transformácia | stream editor (line-by-line edit) | upravené riadky |
| awk | analýza | pattern-action programovací model | report / agregácia |

### 🔁 Pipeline realita

```bash
cat log.txt | grep "ERROR" | sed 's/ERROR/WARNING/' | awk '{ print $1, $3 }'
```

### 🧠 rozhodovací model

- použij `grep`, keď chceš **nájsť alebo filtrovať riadky**
- použij `sed`, keď chceš **prepísať text**
- použij `awk`, keď chceš **pracovať so štruktúrou (stĺpce, logika, výpočty)**

### ⚠️ kľúčový rozdiel

- grep = „má to tam byť?“
- sed = „ako to prepíšem?“
- awk = „čo z toho viem vypočítať?“

## 🧠 Sed cheat sheet

### 🔁 Nahrádzanie
| Príkaz | Popis | Príklad |
|---|---|---|
| `s/old/new/` | nahradí prvý výskyt | `sed 's/a/b/' file` |
| `s/old/new/g` | všetky výskyty | `sed 's/a/b/g' file` |
| `s/^start/BEGIN/` | začiatok riadku | `sed 's/^a/X/' file` |
| `s/end$/FIN/` | koniec riadku | `sed 's/x$/y/' file` |

### 🧭 Adresovanie riadkov
| Príkaz | Popis | Príklad |
|---|---|---|
| `5d` | zmaže riadok 5 | `sed '5d' file` |
| `1,10d` | zmaže rozsah | `sed '1,10d' file` |
| `/error/d` | podľa vzoru | `sed '/error/d' file` |
| `/a/,/b/d` | rozsah vzorov | `sed '/start/,/end/d' file` |

### 📤 Výpis
| Príkaz | Popis | Príklad |
|---|---|---|
| `-n 'p'` | vypne auto print | `sed -n 'p' file` |
| `-n '1p'` | prvý riadok | `sed -n '1p' file` |
| `/pattern/p` | podľa vzoru | `sed -n '/err/p' file` |

### ✏️ Vkladanie / mazanie / zmena
| Príkaz | Popis | Príklad |
|---|---|---|
| `i TEXT` | vloží pred riadok | `sed '1i A' file` |
| `a TEXT` | vloží za riadok | `sed '1a B' file` |
| `c TEXT` | nahradí riadok | `sed '3c X' file` |
| `d` | zmaže riadok | `sed '2d' file` |

### 🔧 Pokročilé operácie
| Príkaz | Popis | Príklad |
|---|---|---|
| `-E 's/[0-9]+/NUM/g'` | regex replace | `sed -E 's/[0-9]+/X/g' file` |
| `=` | číslovanie riadkov | `sed '=' file` |
| `G` | pridá prázdny riadok | `sed G file` |

## 🪟 Microsoft Windows podpora pre sed 

`sed` nie je natívny nástroj Windows prostredia. Funguje iba cez kompatibilné Unix vrstvy alebo porty. V praxi to znamená, že správanie sa môže líšiť podľa použitého prostredia, najmä pri práci so súbormi, cestami a koncami riadkov.
---

## 🔧 Varianty spustenia sed na Windows

| Prostredie | Hodnotenie | Charakteristika | Poznámka |
|------------|------------|-----------------|----------|
| WSL (Windows Subsystem for Linux) | ⭐⭐⭐⭐⭐ | plnohodnotný Linux | najstabilnejšie a odporúčané riešenie |
| Cygwin | ⭐⭐⭐⭐ | Unix emulačná vrstva | vysoká kompatibilita, ale vyššia režijná záťaž |
| MSYS2 | ⭐⭐⭐⭐ | vývojárske Unix prostredie | vhodné pre build toolchainy a skripty |
| Git Bash | ⭐⭐⭐ | minimal Unix shell | vhodné len na základné príkazy |
| natívny sed port (napr. GnuWin32) | ⭐⭐ | Windows build sed | obmedzená kompatibilita a časté rozdiely |

---

## ⚠️ Dôležité technické rozdiely

### 1. CRLF vs LF (koniec riadkov)

Windows používa:
- CRLF (`\r\n`)

Linux/Unix používa:
- LF (`\n`)

📌 Dopady v `sed`:
- `sed` môže vidieť `\r` ako súčasť textu
- regexy môžu zlyhávať (`$`, `.` a podobne)
- porovnávanie reťazcov nemusí sedieť

✔️ Riešenie:
```bash
sed 's/\r$//' file.txt

## 🎬 Praktické príklady vo videu

### 1. Výpis celého súboru
```bash
sed '' data/employees.txt
```

### 2. Výpis prvého stĺpca (odstránenie zvyšku riadku)
```bash
sed 's/ .*//' data/employees.txt
```

### 3. Používateľské mená zo „passwd“ formátu
```bash
sed 's/:.*//' data/passwd.sample
```

### 4. Prvých 5 riadkov
```bash
sed -n '1,5p' data/employees.txt
```

### 5. Odstránenie prázdnych riadkov
```bash
sed '/^$/d' data/log.txt
```

### 6. Hľadanie error riadkov
```bash
sed -n '/error/p' data/log.txt
```

### 7. Replace textu
```bash
sed 's/error/ERROR/g' data/log.txt
```

### 8. Zmazanie riadku
```bash
sed '3d' data/employees.txt
```

### 9. Číslovanie riadkov
```bash
sed '=' data/employees.txt | sed 'N;s/\n/ /'
```

### 10. Replace začiatku riadku
```bash
sed 's/^root/ADMIN/' data/passwd.sample
```
````markdown
## ⚠️ Typické chyby v sed a správne použitie

### Nesprávne použitie `-e` a skriptu

❌ Nesprávne:
```bash
sed 's/foo/bar/' -e file.txt
````

✔️ Správne:

```bash
sed -e 's/foo/bar/' file.txt
```

---

### Nesprávne použitie premenných v shelli (rozšírenie bez úniku)

❌ Nesprávne:

```bash
pattern="foo"
sed "s/$pattern/bar/" file.txt
```

✔️ Správne:

```bash
pattern="foo"
sed "s/${pattern}/bar/g" file.txt
```

---

## 🔒 Bezpečnostné poznámky

Pri práci so `sed` často spracovávame logy, konfigurácie a systémové textové súbory. Preto dodržiavame tieto pravidlá:

* Nespúšťame neznáme `sed` skripty bez kontroly obsahu.
* Pri spracovaní citlivých dát anonymizujeme IP adresy, e-maily, tokeny a identifikátory.
* Nepracujeme priamo na produkčných súboroch bez zálohy.
* Pri úpravách súborov používame bezpečný režim zápisu (dočasný súbor + nahradenie).

✔️ Bezpečnejší prístup pri vkladaní hodnôt zo shellu do `sed`:

```bash
input="hodnota"
sed "s|${input}|REPLACEMENT|g" file.txt
```
### Atomicita
sed nie je transakčný nástroj → neexistuje rollback
---

## 🧳 Poznámka k prenositeľnosti

Riešenia so `sed` sa snažíme písať tak, aby boli kompatibilné naprieč GNU `sed` aj BSD `sed` (macOS).
Ak používame rozšírenia GNU `sed`, explicitne to označujeme, pretože nie sú prenositeľné do všetkých Unix/Linux systémov.

## 📚 Užitočné odkazy a zdroje

- GNU sed manuál: https://www.gnu.org/software/sed/manual/sed.html
- GNU sed projekt: https://www.gnu.org/software/sed/
- The Open Group Base Specifications, Issue 8: https://pubs.opengroup.org/onlinepubs/9799919799/
- POSIX sed špecifikácia: https://pubs.opengroup.org/onlinepubs/9799919799/utilities/sed.html
- GNU sed zdrojový kód (Git): https://git.savannah.gnu.org/cgit/sed.git
- Sed tutorial (intro a príklady): https://www.grymoire.com/Unix/Sed.html
- The AWK and Sed Programming (referenčné zdroje): https://awk.dev/

### 📖 Odporúčané knihy o sed

| Kniha | Autori | Prečo je užitočná |
|------|--------|-------------------|
| sed & awk, Second Edition | Dale Dougherty, Arnold Robbins | Klasická kombinovaná kniha pre text processing v Unixe. Silná praktická časť pre sed aj awk. |
| sed and awk Pocket Reference | Arnold Robbins | Rýchla referenčná príručka pre sed a awk syntax. Vhodná ako „cheat sheet“. |
| UNIX Text Processing | Dale Dougherty | Klasika pre prácu s textom v Unix/Linux prostredí, vrátane sed pipeline prístupov. |
| The UNIX Programming Environment | Brian W. Kernighan, Rob Pike | Fundamentálny pohľad na Unix filozofiu vrátane stream editovania pomocou sed. |
| Mastering Regular Expressions | Jeffrey E. F. Friedl | Nepriamo k sed – kľúčové pre regex, ktoré sed intenzívne používa. |
