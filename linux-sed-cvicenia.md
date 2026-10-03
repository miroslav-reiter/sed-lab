# Linux sed – cvičenia

Tento súbor obsahuje praktické cvičenia pre GNU `sed` v Kali Linuxe a Ubuntu. Cvičenia sú pripravené tak, aby sa dali spúšťať priamo v repozitári `sed-lab`. Pri príkladoch, ktoré potrebujú vstupný súbor, používame testovacie dáta v adresári `data/sed-cvicenia/`.

> Poznámka: príklady 4, 5 a 6 používajú zachytávacie skupiny v tvare `(...)`, preto používame prepínač `-E` pre rozšírené regulárne výrazy. Bez `-E` by sme v základných regulárnych výrazoch museli zátvorky zapisovať ako `\(...\)`.

## 📁 Testovacie súbory

Pre cvičenia sú pripravené tieto súbory:

- `data/sed-cvicenia/new.txt` – krátky text pre substitúcie,
- `data/sed-cvicenia/riadky.txt` – 120 riadkov pre rozsahy a adresovanie,
- `data/sed-cvicenia/word.txt` – riadky s výrazom `WORD` pre príkazy `i`, `a` a `c`.

---

## 1. Substitúcia slov alebo znakov

```bash
sed 's/day/night/' data/sed-cvicenia/new.txt
```

**Vysvetlenie:** príkaz `s/day/night/` nahradí prvý výskyt reťazca `day` za `night` v každom spracovanom riadku.

- `s` znamená substitution,
- `day` je hľadaný vzor,
- `night` je nový text,
- bez príznaku `g` sa v jednom riadku nahrádza iba prvý výskyt.

**Použitie:** jednoduché premenovanie hodnôt, úprava konfigurácií a normalizácia textu.

---

## 2. Vloženie textu do zátvoriek

```bash
echo abcd1234 | sed 's/[a-z]*/(&)/'
```

**Výsledok:**

```text
(abcd)1234
```

**Vysvetlenie:** regulárny výraz `[a-z]*` vyberie postupnosť malých písmen. Znak `&` v náhradnom texte reprezentuje celý text, ktorý zodpovedal regulárnemu výrazu.

- `[a-z]` znamená malé písmeno od `a` po `z`,
- `*` znamená nula alebo viac opakovaní,
- `&` vloží celý nájdený text,
- `(&)` teda vloží zhodu medzi zátvorky.

**Použitie:** obalenie vybraného textu značkami, zátvorkami alebo inými oddeľovačmi.

---

## 3. Zdvojenie čísiel pomocou `&`

```bash
echo "123 abc" | sed 's/[0-9][0-9]*/& &/'
```

**Výsledok:**

```text
123 123 abc
```

**Vysvetlenie:** výraz `[0-9][0-9]*` nájde jednu alebo viac číslic. V náhradnom texte sa `&` použije dvakrát, preto sa nájdené číslo vypíše dvakrát.

- prvé `[0-9]` vyžaduje aspoň jednu číslicu,
- druhé `[0-9]*` povoľuje ďalšie číslice,
- `& &` vytvorí dve kópie celej zhody.

**Použitie:** demonštrácia špeciálneho významu `&` v náhradnej časti príkazu `s///`.

---

## 4. Odstránenie čísiel a ponechanie písmen

```bash
echo abcd123 | sed -E 's/([a-z]*).*/\1/'
```

**Výsledok:**

```text
abcd
```

**Vysvetlenie:** prvá zachytávacia skupina `([a-z]*)` uloží úvodnú postupnosť písmen. Zvyšok riadku `.*` sa síce zhoduje, ale v náhradnom texte sa nepoužije.

- `-E` zapne rozšírené regulárne výrazy,
- `([a-z]*)` je prvá zachytávacia skupina,
- `.*` zodpovedá zvyšku riadku,
- `\1` vloží obsah prvej zachytávacej skupiny.

**Použitie:** extrakcia požadovanej časti textu a odstránenie zvyšku.

---

## 5. Výmena poradia reťazcov

```bash
echo "abcd dcba" | sed -E 's/([a-z]*) ([a-z]*)/\2 \1/'
```

**Výsledok:**

```text
dcba abcd
```

**Vysvetlenie:** dve zachytávacie skupiny uložia prvý a druhý reťazec. V náhradnej časti ich vypíšeme v opačnom poradí.

- `([a-z]*)` je prvá skupina,
- druhé `([a-z]*)` je druhá skupina,
- `\1` odkazuje na prvú skupinu,
- `\2` odkazuje na druhú skupinu,
- `\2 \1` zmení ich poradie.

**Použitie:** preskupovanie častí textu, mien, stĺpcov alebo jednoduchých textových formátov.

---

## 6. Otočenie trojznakového textu odzadu

```bash
echo 123 | sed -E 's/^(.)(.)(.)$/\3\2\1/'
```

**Výsledok:**

```text
321
```

**Vysvetlenie:** každý znak sa uloží do samostatnej zachytávacej skupiny a následne sa skupiny vypíšu v opačnom poradí.

- `^` označuje začiatok riadku,
- každé `(.)` zachytí jeden znak,
- `$` označuje koniec riadku,
- `\3\2\1` vypíše tretiu, druhú a prvú skupinu.

**Použitie:** cvičenie na zachytávacie skupiny a spätné referencie. Tento konkrétny príkaz je určený pre presne tri znaky.

---

## 7. Viac substitúcií v jednom kroku

```bash
sed -e 's/a/A/' -e 's/b/B/' data/sed-cvicenia/new.txt
```

**Vysvetlenie:** prepínač `-e` umožňuje zadať viac sed výrazov v jednom príkaze.

- prvý výraz nahradí prvé `a` za `A`,
- druhý výraz nahradí prvé `b` za `B`,
- oba príkazy sa aplikujú postupne na každý riadok.

**Použitie:** viacnásobné transformácie bez vytvárania samostatného sed skriptu.

---

## 8. Zmena veľkého `A` na malé `a` iba v riadkoch 1–100

```bash
sed '1,100 s/A/a/' data/sed-cvicenia/riadky.txt
```

**Vysvetlenie:** adresa `1,100` obmedzí substitúciu iba na prvých 100 riadkov vstupu.

- `1,100` je rozsah riadkov,
- `s/A/a/` nahradí prvý výskyt `A` za `a`,
- riadky 101 a vyššie sa iba vypíšu bez tejto substitúcie.

**Použitie:** selektívna úprava iba konkrétnej časti veľkého súboru.

---

## 9. Výpis prvých 10 riadkov – štyri ekvivalentné zápisy

### Variant A – explicitný výpis

```bash
sed -n '1,10p' data/sed-cvicenia/riadky.txt
```

### Variant B – negácia rozsahu 11 až koniec

```bash
sed -n '11,$!p' data/sed-cvicenia/riadky.txt
```

### Variant C – vymazanie všetkého mimo prvých 10 riadkov

```bash
sed '1,10!d' data/sed-cvicenia/riadky.txt
```

### Variant D – vymazanie od 11. riadku po koniec

```bash
sed '11,$d' data/sed-cvicenia/riadky.txt
```

**Vysvetlenie:** všetky štyri príkazy vedú k rovnakému výsledku – vypíšu prvých 10 riadkov.

- `-n` vypne automatický výpis,
- `p` explicitne vypíše vybrané riadky,
- `!` neguje adresu alebo rozsah,
- `d` odstráni aktuálny riadok z ďalšieho spracovania,
- `$` označuje posledný riadok vstupu.

**Použitie:** precvičenie adresovania, negácie a rozdielu medzi `p` a `d`.

---

## 10. Pridanie riadku pred riadok obsahujúci `WORD`

Jednoriadkový GNU sed zápis:

```bash
sed '/WORD/i\Add this line before every line with WORD' data/sed-cvicenia/word.txt
```

Skriptový zápis:

```sh
#!/bin/sh
sed '/WORD/i\
Add this line before every line with WORD
' data/sed-cvicenia/word.txt
```

**Vysvetlenie:** príkaz `i` vloží text pred každý riadok, ktorý zodpovedá vzoru `/WORD/`.

- `/WORD/` je adresa definovaná regulárnym výrazom,
- `i` znamená insert,
- pôvodný riadok s `WORD` zostáva vo výstupe zachovaný.

**Použitie:** pridávanie komentárov, hlavičiek alebo konfiguračných riadkov pred nájdené miesto.

---

## 11. Nahradenie riadku obsahujúceho `WORD`

Jednoriadkový GNU sed zápis:

```bash
sed '/WORD/c\Replace the current line with the line' data/sed-cvicenia/word.txt
```

Skriptový zápis:

```sh
#!/bin/sh
sed '/WORD/c\
Replace the current line with the line
' data/sed-cvicenia/word.txt
```

**Vysvetlenie:** príkaz `c` nahradí celý riadok, ktorý obsahuje `WORD`, novým textom.

- `/WORD/` vyberie riadky podľa vzoru,
- `c` znamená change,
- pôvodný obsah vybraného riadku sa vo výstupe už neobjaví.

**Použitie:** nahradenie celých konfiguračných alebo textových riadkov podľa identifikujúceho vzoru.

---

## 12. Pridanie riadku pred a po výskyte `WORD` a nahradenie pôvodného riadku

```sh
#!/bin/sh
sed '/WORD/{
i\
Add this line before
a\
Add this line after
c\
Change the line to this one
}' data/sed-cvicenia/word.txt
```

**Vysvetlenie:** blok `{ ... }` aplikuje viac sed príkazov na každý riadok, ktorý obsahuje `WORD`.

- `/WORD/` vyberie riadok,
- `i` vloží text pred vybraný riadok,
- `a` naplánuje text na výpis za aktuálnym riadkom,
- `c` nahradí pôvodný riadok novým textom,
- zložené zátvorky umožňujú vykonať viac operácií pre rovnakú adresu.

**Použitie:** pokročilejšia úprava blokov textu, keď potrebujeme súčasne vložiť obsah pred, za a namiesto pôvodného riadku.

---

## 🧠 Čo si na cvičeniach precvičíme

Po prejdení príkladov by sme mali rozumieť týmto prvkom GNU sed:

| Prvok | Význam |
|---|---|
| `s/vzor/nahrada/` | substitúcia textu |
| `&` | celý text, ktorý zodpovedal vzoru |
| `\1`, `\2`, `\3` | spätné referencie na zachytávacie skupiny |
| `-E` | rozšírené regulárne výrazy |
| `-e` | pridanie ďalšieho sed výrazu |
| `1,100` | rozsah riadkov |
| `$` | posledný riadok |
| `!` | negácia adresy alebo rozsahu |
| `p` | výpis pattern space |
| `d` | odstránenie pattern space a začatie ďalšieho cyklu |
| `i` | vloženie textu pred vybraný riadok |
| `a` | pridanie textu za vybraný riadok |
| `c` | nahradenie celého vybraného riadku |
| `{ ... }` | blok viacerých príkazov pre rovnakú adresu |
