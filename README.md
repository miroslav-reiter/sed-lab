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
| grep | filtrácia | boolean matcher | subset riadkov |
| sed | transformácia | stream editor | upravené riadky |
| awk | analýza | pattern-action | report/aggregácia |

### 🔁 Pipeline
```bash
cat log.txt | grep "ERROR" | sed 's/ERROR/WARNING/' | awk '{ print $1, $3 }'
```

### 🧠 rozhodovanie
- grep = filtrovanie
- sed = transformácia
- awk = analýza

## 🧾 Cheat Sheet

### 🔁 Nahrádzanie
| Príkaz | Popis | Príklad |
|---|---|---|
| `s/old/new/` | prvý výskyt | `sed 's/a/b/' file` |
| `s/old/new/g` | všetky výskyty | `sed 's/a/b/g' file` |
| `s/^start/BEGIN/` | začiatok | `sed 's/^a/X/' file` |
| `s/end$/FIN/` | koniec | `sed 's/x$/y/' file` |

### 🧭 Riadky
| Príkaz | Popis | Príklad |
|---|---|---|
| `5d` | zmaže riadok | `sed '5d' file` |
| `1,10d` | rozsah | `sed '1,10d' file` |
| `/error/d` | pattern | `sed '/error/d' file` |
| `/a/,/b/d` | rozsah | `sed '/start/,/end/d' file` |

### 📤 Výpis
| Príkaz | Popis | Príklad |
|---|---|---|
| `-n p` | vypne auto print | `sed -n 'p' file` |
| `1p` | prvý riadok | `sed -n '1p' file` |
| `/err/p` | pattern | `sed -n '/err/p' file` |

### ✏️ Editácie
| Príkaz | Popis | Príklad |
|---|---|---|
| `i` | insert | `sed '1i A' file` |
| `a` | append | `sed '1a B' file` |
| `c` | change | `sed '3c X' file` |
| `d` | delete | `sed '2d' file` |

### 🔧 Pokročilé
| Príkaz | Popis | Príklad |
|---|---|---|
| `-E` | regex | `sed -E 's/[0-9]+/X/'` |
| `=` | čísla riadkov | `sed '=' file` |
| `G` | prázdny riadok | `sed G file` |

## 🔒 Bezpečnosť
- `-i` môže zničiť dáta
- používať `.bak`
- testovať bez editácie
- žiadny rollback

## 🪟 Windows
- WSL (odporúčané)
- Cygwin
- MSYS2
- Git Bash

## 📚 Zdroje
- GNU sed
- POSIX
- GNU manuals

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