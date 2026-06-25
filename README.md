# 🧪 sed-lab

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

Typické použitie:

- nahrádzanie textu,
- výpis konkrétnych riadkov,
- filtrovanie podľa vzoru,
- mazanie riadkov,
- odstraňovanie prázdnych riadkov a komentárov,
- jednoduché úpravy konfiguračných súborov,
- čistenie logov,
- hromadné zmeny v textových súboroch,
- príprava dát pred ďalším spracovaním cez `awk`, `grep`, `sort` alebo shell skripty.

## 🧩 sed vs grep vs awk

| Nástroj | Hlavné použitie | Príklad |
|---|---|---|
| `grep` | hľadanie riadkov podľa vzoru | `grep error app.log` |
| `sed` | úprava textového toku | `sed 's/http:/https:/g' urls.txt` |
| `awk` | práca so stĺpcami, výpočty a reporty | `awk -F, '{ print $1 }' data.csv` |

Praktické pravidlo:

- `grep` použijeme, keď chceme hlavne nájsť riadky,
- `sed` použijeme, keď chceme riadky upraviť,
- `awk` použijeme, keď potrebujeme pracovať so stĺpcami, premennými alebo výpočtami.

## ⚙️ GNU sed v Kali a Ubuntu

V Kali Linuxe aj Ubuntu je bežne dostupný GNU sed. Základný výpis po spustení bez argumentov:

```text
Usage: sed [OPTION]... {script-only-if-no-other-script} [input-file]...
```

Dôležité voľby:

| Voľba | Význam |
|---|---|
| `-n`, `--quiet`, `--silent` | nevypisuje automaticky pattern space |
| `-e script` | pridá príkaz, ktorý sa má vykonať |
| `-f script-file` | načíta sed príkazy zo súboru |
| `-i[SUFFIX]` | upraví súbor priamo na mieste, voliteľne vytvorí zálohu |
| `-E`, `-r` | použije rozšírené regulárne výrazy, pre prenositeľnosť preferujeme `-E` |
| `--posix` | vypne GNU rozšírenia |
| `--sandbox` | obmedzí príkazy na prácu so súbormi |
| `--debug` | anotuje vykonávanie programu |
| `--version` | zobrazí verziu sed |
| `--help` | zobrazí pomocníka |

## 🗂️ Štruktúra repozitára

```text
sed-lab/
├── README.md
├── data/
│   ├── access.log
│   ├── config.txt
│   ├── notes.txt
│   ├── passwd.sample
│   ├── products.csv
│   ├── text.txt
│   └── urls.txt
├── exercises/
│   ├── 01-basics.md
│   ├── 02-printing.md
│   ├── 03-substitution.md
│   ├── 04-deleting.md
│   ├── 05-regex.md
│   └── 06-in-place-and-scripts.md
├── solutions/
│   ├── 01-basics.sh
│   ├── 02-printing.sh
│   ├── 03-substitution.sh
│   ├── 04-deleting.sh
│   ├── 05-regex.sh
│   └── 06-in-place-and-scripts.sh
└── scripts/
    └── run-all.sh
```

## 🚀 Rýchly štart

```bash
git clone https://github.com/miroslav-reiter/sed-lab.git
cd sed-lab
```

Spustenie všetkých ukážkových riešení:

```bash
bash scripts/run-all.sh
```

## 🧾 Základná syntax

Výpis súboru bez zmeny:

```bash
sed '' data/text.txt
```

Nahradenie prvého výskytu v riadku:

```bash
sed 's/Linux/GNU Linux/' data/text.txt
```

Nahradenie všetkých výskytov v riadku:

```bash
sed 's/Linux/GNU Linux/g' data/text.txt
```

Výpis konkrétneho riadku:

```bash
sed -n '2p' data/text.txt
```

Výpis rozsahu riadkov:

```bash
sed -n '1,3p' data/text.txt
```

Mazanie riadku:

```bash
sed '3d' data/text.txt
```

Mazanie riadkov podľa vzoru:

```bash
sed '/error/d' data/notes.txt
```

## 🎬 Praktické príklady do videa

### 1. Overenie sed

```bash
sed --version
sed --help
```

### 2. Základné nahrádzanie

```bash
sed 's/Linux/GNU Linux/' data/text.txt
sed 's/Linux/GNU Linux/g' data/text.txt
```

### 3. Výpis riadkov bez automatického výpisu

```bash
sed -n '1p' data/text.txt
sed -n '1,4p' data/text.txt
sed -n '/sed/p' data/text.txt
```

### 4. Mazanie riadkov

```bash
sed '2d' data/text.txt
sed '1,2d' data/text.txt
sed '/^#/d' data/config.txt
sed '/^$/d' data/config.txt
```

### 5. Úprava konfigurácie

```bash
sed 's/enabled=false/enabled=true/' data/config.txt
sed 's/port=8080/port=9090/' data/config.txt
```

### 6. Práca s URL adresami

```bash
sed 's/http:/https:/g' data/urls.txt
sed 's#http://#https://#g' data/urls.txt
```

Pri URL je praktické použiť iný oddeľovač ako `/`, napríklad `#`.

### 7. Rozšírené regulárne výrazy

```bash
sed -E 's/[0-9]+/CISLO/g' data/notes.txt
sed -E 's/([a-z]+)@([a-z.]+)/EMAIL/g' data/notes.txt
```

### 8. Spracovanie logov

```bash
sed -n '/ 404 /p' data/access.log
sed -n '/GET/p' data/access.log
sed 's/ 404 / NOT_FOUND /g' data/access.log
```

### 9. Úprava súboru na mieste so zálohou

```bash
cp data/urls.txt /tmp/urls.txt
sed -i.bak 's/http:/https:/g' /tmp/urls.txt
cat /tmp/urls.txt
cat /tmp/urls.txt.bak
```

### 10. Viac sed príkazov naraz

```bash
sed -e 's/Linux/GNU Linux/g' -e '/error/d' data/notes.txt
```

## 🧠 sed cheat sheet

| Použitie | Príkaz |
|---|---|
| Nahradiť prvý výskyt | `sed 's/staré/nové/' subor.txt` |
| Nahradiť všetky výskyty | `sed 's/staré/nové/g' subor.txt` |
| Vypísať prvý riadok | `sed -n '1p' subor.txt` |
| Vypísať rozsah riadkov | `sed -n '1,5p' subor.txt` |
| Vypísať riadky so vzorom | `sed -n '/error/p' app.log` |
| Zmazať riadok | `sed '3d' subor.txt` |
| Zmazať prázdne riadky | `sed '/^$/d' subor.txt` |
| Zmazať komentáre | `sed '/^#/d' config.txt` |
| Rozšírené regexy | `sed -E 's/[0-9]+/CISLO/g' subor.txt` |
| Úprava na mieste so zálohou | `sed -i.bak 's/a/b/g' subor.txt` |
| Viac príkazov | `sed -e 's/a/b/g' -e '/debug/d' subor.txt` |
| Skript zo súboru | `sed -f script.sed subor.txt` |

## ⚠️ Časté chyby

### Zámenné používanie `-n` a `p`

Ak použijeme iba `p` bez `-n`, sed vypíše pôvodný riadok aj explicitný výpis:

```bash
sed '1p' data/text.txt
```

Správne pri cielenej tlači:

```bash
sed -n '1p' data/text.txt
```

### Zabudnutý `g` príznak pri nahrádzaní

```bash
sed 's/Linux/GNU Linux/' data/text.txt
```

Nahradí iba prvý výskyt v každom riadku.

Ak chceme všetky výskyty v riadku:

```bash
sed 's/Linux/GNU Linux/g' data/text.txt
```

### Rizikové použitie `-i`

Príkaz `-i` mení súbor priamo. Pri tréningu používame najprv kópiu alebo zálohu:

```bash
sed -i.bak 's/http:/https:/g' urls.txt
```

### Lomky v URL adresách

Pri URL je lepšie použiť iný oddeľovač:

```bash
sed 's#http://#https://#g' data/urls.txt
```

## 🔒 Bezpečnostné poznámky

- Nepoužívame `sed -i` na dôležité súbory bez zálohy.
- Najprv si príkaz otestujeme bez `-i`.
- Pri konfiguračných súboroch vytvárame `.bak` zálohu.
- Pri hromadných zmenách používame Git alebo inú formu verziovania.
- Nepúšťame cudzie sed skripty bez kontroly obsahu.
- Pri logoch anonymizujeme IP adresy, tokeny, e-maily a osobné údaje.

## 🧭 Odporúčané poradie tréningu

1. Prejdeme `exercises/01-basics.md`.
2. Pokračujeme výpisom riadkov cez `-n` a `p`.
3. Precvičíme nahrádzanie cez `s///`.
4. Doplníme mazanie riadkov cez `d`.
5. Precvičíme regulárne výrazy a voľbu `-E`.
6. Nakoniec použijeme `-i`, `-e` a `-f`.

## 🧳 Poznámka k prenositeľnosti

V hlavných ukážkach používame bežnú syntax GNU sed dostupnú v Kali a Ubuntu. Pri prenositeľných skriptoch preferujeme POSIX kompatibilné konštrukcie a rozšírené regulárne výrazy zapíname cez `-E`.

## 📚 Užitočné odkazy a zdroje

- GNU sed manuál: https://www.gnu.org/software/sed/manual/sed.html
- GNU sed projekt: https://www.gnu.org/software/sed/
- POSIX sed špecifikácia: https://pubs.opengroup.org/onlinepubs/9799919799/utilities/sed.html
- The Open Group Base Specifications, Issue 8: https://pubs.opengroup.org/onlinepubs/9799919799/
- sed FAQ: http://sed.sourceforge.net/sedfaq.html

## 📖 Odporúčané knihy

| Kniha | Autori | Poznámka |
|---|---|---|
| sed & awk, Second Edition | Dale Dougherty, Arnold Robbins | Praktická kniha pre Unix text processing. |
| sed and awk Pocket Reference | Arnold Robbins | Stručná príručka k sed a awk. |
| Unix Power Tools | Shelley Powers, Jerry Peek, Tim O'Reilly, Mike Loukides | Širší Unix kontext a praktické textové nástroje. |
