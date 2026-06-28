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

## 🎬 Praktické príklady vo videu

Táto sekcia obsahuje príkazy vhodné na ukážku vo videu. Používame súbory v priečinku `data/`.

---

### 1. Výpis celého súboru
```bash
sed '' data/employees.txt
```
Vypíše celý súbor (sed defaultne tlačí všetky riadky).

---

### 2. Výpis prvého slova z riadku
```bash
sed 's/ .*//' data/employees.txt
```
Odstráni všetko od prvej medzery po koniec riadku.

---

### 3. Výpis používateľských mien (formát user:...)
```bash
sed 's/:.*//' data/passwd.sample
```
Odstráni všetko od dvojbodky – ostane prvé pole.

---

### 4. Výpis prvých N riadkov (napr. 5)
```bash
sed -n '1,5p' data/employees.txt
```
Používa režim `-n` a explicitný print.

---

### 5. Odstránenie prázdnych riadkov
```bash
sed '/^$/d' data/log.txt
```
Zmaže všetky prázdne riadky.

---

### 6. Výpis riadkov obsahujúcich error
```bash
sed -n '/error/p' data/log.txt
```
Filtruje riadky podľa vzoru.

---

### 7. Nahradenie textu (case replace)
```bash
sed 's/error/ERROR/g' data/log.txt
```
Zmení všetky výskyty.

---

### 8. Odstránenie konkrétneho riadku
```bash
sed '3d' data/employees.txt
```
Zmaže tretí riadok.

---

### 9. Výpis riadkov s číslovaním
```bash
sed '=' data/employees.txt | sed 'N;s/\n/ /'
```
Spojí číslo riadku s obsahom.

---

### 10. Výmena začiatku riadku
```bash
sed 's/^root/ADMIN/' data/passwd.sample
```
Zmení prefix riadku.

---

## 🎯 Poznámka
sed nie je nástroj na prácu so stĺpcami (na to sa používa awk). sed je určený na **line-based transformácie a regex operácie**.
