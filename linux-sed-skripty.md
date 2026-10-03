# Linux sed – skripty

Tento súbor obsahuje praktické GNU `sed` skripty inšpirované kapitolou **Some Sample Scripts** z oficiálneho GNU sed manuálu. Príklady sú upravené do laboratórnej podoby pre Kali Linux a Ubuntu tak, aby sa dali priamo skúšať v repozitári `sed-lab`.

Zdroj a inšpirácia: https://www.gnu.org/software/sed/manual/html_node/Examples.html

> Poznámka: nejde o doslovný prepis GNU manuálu. Príklady sú prispôsobené na praktické cvičenie a vysvetlenie príkazov `N`, `D`, `P`, `G`, `H`, `h`, `x`, `b`, `t`, `q`, `=`, `y` a ďalších prvkov GNU sed.

## 📁 Testovacie súbory

Pre príklady sú pripravené tieto súbory:

- `data/sed-skripty/continuation.txt` – riadky pokračujúce spätnou lomkou,
- `data/sed-skripty/text.txt` – 15 riadkov pre číslovanie, head, tail a reverzné poradie,
- `data/sed-skripty/cisla.txt` – číselné hodnoty pre inkrementáciu,
- `data/sed-skripty/subory.txt` – názvy súborov s rôznou veľkosťou písmen,
- `data/sed-skripty/multiline.txt` – opakované slová aj cez hranicu riadkov,
- `data/sed-skripty/long.txt` – dlhé riadky na zalamovanie,
- `data/sed-skripty/duplikaty.txt` – susediace duplicitné riadky,
- `data/sed-skripty/prazdne-riadky.txt` – viacnásobné prázdne riadky,
- `data/sed-skripty/HEADER.txt` – testovacia hlavička,
- `data/sed-skripty/c-src/*.c` – ukážkové C súbory.

---

## 🔗 Spájanie a formátovanie textu

**1. Spájanie riadkov ukončených spätnou lomkou**

```bash
sed ':join; /\\$/ { N; s/\\\n//; b join }' data/sed-skripty/continuation.txt
```

Spojí logické riadky, ktoré sú vo vstupnom súbore rozdelené pomocou spätnej lomky na konci riadku.

**Vysvetlenie:**

- `:join` vytvorí návestie s názvom `join`.
- §$/\\$/` vyberá riadky končiace spätnou lomkou.
- `N` pridá nasledujúci vstupný riadok do pattern space.
- `s/\\\n//` odstráni spätnú lomku aj vložený newline.
- `b join` vykoná nepodmienený skok späť na návestie, ak treba pripojiť ďalší riadok.

**Použitie:** viacriadkové konfigurácie, shellové príkazy a texty s explicitným pokračovaním riadku.

---

**2. Centrovanie textu na šírku 60 znakov**

```bash
sed -E '
1 {
    x
    s/^$/                                                            /
    x
}
s/^[[:space:]]+//
s/[[:space:]]+$//
G
s/^(.{61}).*$/\1/
s/^(.*)\n(.*)\2/\2\1/
' data/sed-skripty/text.txt
```

Približne vycentruje riadky v textovom poli širokom 60 znakov.

**Vysvetlenie:**

- Na začiatku sa do hold space uloží blok medzier.
- `x` vymieňa pattern space a hold space.
- `G` pripojí hold space k aktuálnemu riadku.
- Regulárne výrazy odstránia nadbytočný obsah a presunú približne polovicu voľného priestoru pred text.
- Ide o demonštráciu práce s oboma buffermi, nie o náhradu formátovacieho nástroja.

**Použitie:** pochopenie pattern space, hold space a viacstupňovej transformácie.

---

**3. Inkrementácia čísla o 1**

```bash
sed -E 's/^[0-9]+$/echo $((& + 1))/e' data/sed-skripty/cisla.txt
```

Každé čisto číselné vstupné číslo zvýši o jednotku.

**Vysvetlenie:**

- `^[0-9]+$` povolí iba celé nezáporné čísla.
- `&` v náhradnej časti reprezentuje celý nájdený text.
- Po substitúcii vznikne shellový výraz typu `echo $((99 + 1))`.
- Príznak `e` je GNU sed rozšírenie, ktoré výsledný príkaz vykoná cez shell.

> Bezpečnostná poznámka: príznak `e` spúšťa shellový príkaz. V tomto labe ho používame iba nad kontrolovaným číselným súborom `cisla.txt`.

**Použitie:** demonštrácia GNU rozšírenia `e` a dynamickej transformácie.

---

**4. Prevod názvov súborov na malé písmená – bezpečný náhľad**

```bash
sed 'h; y/ABCDEFGHIJKLMNOPQRSTUVWXYZ/abcdefghijklmnopqrstuvwxyz/; x; G; s/\n/ -> /' data/sed-skripty/subory.txt
```

Zobrazí pôvodný a transformovaný názov súboru bez toho, aby čokoľvek premenoval na disku.

**Vysvetlenie:**

- `h` skopíruje pôvodný názov do hold space.
- `y/ABC.../abc.../` vykoná transliteráciu veľkých písmen na malé.
- `x` vymení transformovaný a pôvodný text.
- `G` pripojí nový názov za pôvodný.
- Posledná substitúcia zmení newline medzi hodnotami na šípku ` -> `.

**Použitie:** bezpečný dry-run pred hromadným premenovaním súborov.

---

**5. Výpis premenných Bash bez definícií funkcií**

```bash
set | sed -n '/^[A-Za-z_][A-Za-z0-9_]*=/p'
```

Z výstupu Bash príkazu `set` ponechá iba riadky, ktoré vyzerajú ako priradenia premenných.

**Vysvetlenie:**

- `-n` vypne automatický výpis.
- Regulárny výraz kontroluje tvar `NAZOV=hodnota`.
- `p` explicitne vypíše iba zodpovedajúce riadky.
- Funkčné definície typu `nazov ()` sa týmto filtrom nevyberú.

**Použitie:** kontrola shellových premenných a precvičenie regulárnych adries.

---

**6. Otočenie znakov v každom riadku**

```bash
sed '
/../!b
s/^/\n/
s/$/\n/
:swap
s/\n\(.\)\(.*\)\(.\)\n/\3\n\2\n\1/
t swap
s/\n//g
' data/sed-skripty/text.txt
```

Obráti poradie znakov v každom neprázdnom alebo viacznakovom riadku.

**Vysvetlenie:**

- Pred a za text sa dočasne vložia newline značky.
- Regulárny výraz postupne presúva posledný znak pred prvý.
- `t swap` opakuje transformáciu iba vtedy, keď predchádzajúca substitúcia uspela.
- Na konci sa pomocné newline znaky odstránia.

**Použitie:** vetvenie, cykly a spätné referencie v sed skripte.

---

**7. Hľadanie opakovaného slova aj cez dva riadky**

```bash
sed -En '{N; /\b([[:alnum:]_]+)[[:space:]]+\1\b/{=;p}; D}' data/sed-skripty/multiline.txt
```

Vyhľadá dvojité slovo aj v prípade, že prvý výskyt je na konci jedného riadku a druhý na začiatku nasledujúceho.

**Vysvetlenie:**

- `-E` zapne rozšírené regulárne výrazy.
- `-n` vypne automatický výpis.
- `N` vytvorí dvojriadkové okno v pattern space.
- `([[:alnum:]_]+)` zachytí slovo.
- `\1` vyžaduje opakovanie rovnakého slova.
- `=` vypíše číslo aktuálneho vstupného riadku.
- `D` odstráni prvú časť pattern space po newline a pokračuje ďalším dvojriadkovým oknom.

**Použitie:** kontrola textov, dokumentácie a logov, kde hľadaný vzor presahuje hranicu riadka.

---

**8. Zalamovanie dlhých riadkov približne na 40 znakov**

```bash
sed -E ':w; s/^(.{1,40})[[:space:]]+/\1\n/; t p; b; :p; P; D' data/sed-skripty/long.txt
```

Rozdelí dlhý text na kratšie riadky bez rozseknutia slova v mieste, kde je dostupná medzera.

**Vysvetlenie:**

- Substitúcia hľadá maximálne 40 znakov nasledovaných whitespace.
- Nájdenú medzeru nahradí newline.
- `P` vypíše prvú časť viacriadkového pattern space.
- `D` ju odstráni a pokračuje spracovaním zvyšku bez čítania nového vstupného riadku.
- `t` a `b` riadia tok skriptu.

**Použitie:** jednoduché formátovanie reportov a textových exportov.

---

**9. Pridanie hlavičky pred obsah C súboru**

Náhľad bez úpravy súboru:

```bash
sed '0r data/sed-skripty/HEADER.txt' data/sed-skripty/c-src/main.c
```

Náhľad pre všetky testovacie C súbory:

```bash
for f in data/sed-skripty/c-src/*.c; do
    echo "===== $f ====="
    sed '0r data/sed-skripty/HEADER.txt' "$f"
done
```

Príkaz pridá obsah súboru `HEADER.txt` pred prvý riadok cieľového súboru.

**Vysvetlenie:**

- `0r subor` je GNU sed technika, pri ktorej sa externý súbor načíta pred prvý vstupný riadok.
- Bez `-i` sa iba zobrazí výsledok a zdrojový súbor zostane nezmenený.
- Pred reálnym hromadným prepisom je vhodné vždy najskôr použiť tento preview režim.

**Použitie:** pridávanie copyright, licenčných alebo projektových hlavičiek.

---

## 🔄 Emulácia štandardných Unix nástrojov

**10. Otočenie poradia riadkov ako `tac`**

```bash
sed -n '1!G; h; $ { g; p }' data/sed-skripty/text.txt
```

Vypíše posledný riadok ako prvý a prvý ako posledný.

**Vysvetlenie:**

- `G` pridáva predchádzajúci obsah hold space za aktuálny riadok.
- `h` uloží postupne rastúci obrátený blok.
- Na poslednom riadku `g` načíta výsledok späť do pattern space.
- `p` ho vypíše.
- Tento spôsob drží postupne rastúci obsah v pamäti, preto nie je vhodný na obrovské súbory.

**Použitie:** pochopenie hold space a akumulácie textu.

---

**11. Číslovanie všetkých riadkov ako jednoduchý `cat -n`**

```bash
sed = data/sed-skripty/text.txt | sed 'N; s/\n/\t/'
```

Vypíše číslo a obsah každého riadku na jednom výstupnom riadku.

**Vysvetlenie:**

- Príkaz `=` vypíše číslo aktuálneho vstupného riadku.
- Prvý sed teda vytvorí dvojice `číslo` a `obsah`.
- Druhý sed pomocou `N` spojí dvojicu do pattern space.
- Substitúcia zmení newline medzi číslom a obsahom na tabulátor.

**Použitie:** číslovanie výstupov pri debugovaní alebo vysvetľovaní súboru.

---

**12. Číslovanie iba neprázdnych riadkov**

```bash
sed -n '/./{=;p}' data/sed-skripty/prazdne-riadky.txt | sed 'N; s/\n/\t/'
```

Vypíše iba neprázdne riadky spolu s ich pôvodným číslom vo vstupnom súbore.

**Vysvetlenie:**

- §$/./` vyberie riadky obsahujúce aspoň jeden znak.
- `=` vypíše číslo riadku.
- `p` vypíše samotný obsah.
- Druhý sed spojí číslo a obsah do jednej línie.

> Ide o zjednodušenú laboratórnu verziu témy `cat -b`. Číslo zodpovedá pôvodnej pozícii riadku v súbore.

**Použitie:** rýchla orientácia v súboroch s množstvom prázdnych riadkov.

---

**13. Počítanie znakov pomocou sed pipeline**

```bash
sed 's/./&\n/g' data/sed-skripty/text.txt | sed '/^$/d' | sed -n '$='
```

Spočíta znaky tak, že každý znak rozdelí na samostatný výstupný riadok a následne spočíta riadky.

**Vysvetlenie:**

- `s/./&\n/g` vloží newline za každý znak.
- Druhý sed odstráni prázdne riadky.
- `$=` vypíše číslo posledného riadku, teda počet vzniknutých položiek.
- Táto laboratórna verzia počíta znaky textu bez pôvodných oddeľovacích newline znakov.

**Použitie:** demonštrácia toho, ako možno počítanie simulovať textovou transformáciou.

---

**14. Počítanie slov pomocou sed pipeline**

```bash
sed -E 's/[[:space:]]+/\n/g' data/sed-skripty/long.txt | sed '/^$/d' | sed -n '$='
```

Prevedie slová na samostatné riadky a následne ich spočíta.

**Vysvetlenie:**

- `[[:space:]]+` vyberie jednu alebo viac whitespace položiek.
- Náhrada `\n` oddelí slová do samostatných riadkov.
- `/^$/d` odstráni prázdne položky.
- `$=` poskytne počet výsledných riadkov.

**Použitie:** pochopenie textovej normalizácie pred počítaním.

---

**15. Počítanie riadkov ako `wc -l`**

```bash
sed -n '$=' data/sed-skripty/text.txt
```

Vypíše číslo posledného riadku, ktoré pri bežnom textovom súbore zodpovedá počtu riadkov.

**Vysvetlenie:**

- `$` adresuje posledný vstupný riadok.
- `=` vypisuje číslo aktuálneho riadku.
- `-n` potláča bežný obsah súboru.

**Použitie:** najjednoduchší príklad počítania pomocou sed.

---

**16. Prvých 10 riadkov ako `head`**

```bash
sed '10q' data/sed-skripty/text.txt
```

Vypíše prvých 10 riadkov a potom sed okamžite ukončí.

**Vysvetlenie:**

- Adresa `10` vyberie desiaty riadok.
- `q` znamená quit.
- Riadky 1 až 10 sa vypíšu štandardným automatickým výpisom a po desiatom sa spracovanie skončí.

**Použitie:** rýchly náhľad začiatku veľkého súboru.

---

**17. Posledných 10 riadkov ako `tail`**

```bash
sed -e :a -e '$q;N;11,$D;ba' data/sed-skripty/text.txt
```

Udržiava posuvné okno posledných 10 riadkov.

**Vysvetlenie:**

- `:a` vytvorí návestie.
- `N` pripája ďalší riadok k pattern space.
- Od jedenásteho vstupného riadku `D` odstraňuje najstarší riadok z viacriadkového pattern space.
- `ba` pokračuje v slučke.
- `$q` ukončí spracovanie na konci vstupu a výsledné okno sa vypíše.

**Použitie:** demonštrácia sliding-window techniky pomocou `N` a `D`.

---

**18. Zlúčenie susediacich duplicitných riadkov ako `uniq`**

```bash
sed -n '$!N; /^\(.*\)\n\1$/!P; D' data/sed-skripty/duplikaty.txt
```

Z každej skupiny rovnakých susediacich riadkov ponechá jednu kópiu.

**Vysvetlenie:**

- `N` drží v pattern space dva susediace riadky.
- Regulárny výraz porovná prvý riadok s druhým pomocou spätného odkazu `\1`.
- Ak sa líšia, `P` vypíše prvý riadok.
- `D` odstráni prvý riadok a vytvorí ďalšie dvojriadkové okno.
- Rovnako ako pri štandardnom `uniq` sa porovnávajú susediace duplicity.

**Použitie:** deduplikácia už zoradených alebo zoskupených dát.

---

**19. Výpis iba duplicitných skupín ako `uniq -d`**

```bash
sed -n '$!N; /^\(.*\)\n\1$/P; D' data/sed-skripty/duplikaty.txt |
sed -n '$!N; /^\(.*\)\n\1$/!P; D'
```

Vypíše jednu kópiu z každej skupiny, ktorá sa vo vstupných dátach opakuje.

**Vysvetlenie:**

- Prvý sed vypíše riadky, ktoré majú rovnakého suseda.
- Pri troch a viacerých rovnakých riadkoch môže prvý stupeň vyprodukovať rovnakú hodnotu viackrát.
- Druhý sed tento pomocný výstup znovu deduplikuje.
- Výsledkom sú iba hodnoty, ktoré mali susediace duplicity.

**Použitie:** kontrola duplicitných záznamov v už zoskupených dátach.

---

**20. Výpis iba riadkov bez duplicity ako `uniq -u`**

```bash
sed '
$b
N
/^\(.*\)\n\1$/! {
    P
    D
}
:c
$d
s/.*\n//
N
/^\(.*\)\n\1$/bc
D
' data/sed-skripty/duplikaty.txt
```

Odstráni celé skupiny susediacich duplicít a ponechá iba riadky, ktoré sa v susednej skupine neopakujú.

**Vysvetlenie:**

- Skript porovnáva vždy dve susediace hodnoty.
- Ak sú odlišné, prvá sa vypíše cez `P`.
- Ak sú rovnaké, vetva `:c` preskakuje celú duplicitnú skupinu.
- `D` potom pokračuje ďalším kandidátom.
- Rovnako ako `uniq -u` tento model predpokladá, že duplicity sú vedľa seba.

**Použitie:** výber jedinečných záznamov zo zoskupeného vstupu.

---

**21. Zredukovanie viacerých prázdnych riadkov ako `cat -s`**

```bash
sed '/^$/N; /^\n$/D' data/sed-skripty/prazdne-riadky.txt
```

Viac po sebe idúcich prázdnych riadkov zredukuje na jeden.

**Vysvetlenie:**

- Na prázdnom riadku `N` pripojí nasledujúci riadok.
- Ak vznikne pattern space obsahujúci dva prázdne riadky, regulárny výraz `/^\n$/` ho rozpozná.
- `D` odstráni prvú prázdnu časť a opakuje cyklus bez čítania ďalšieho riadku.
- Tým sa ľubovoľne dlhá séria prázdnych riadkov zmenší na jeden.

**Použitie:** čistenie dokumentov, logov a exportov s nadbytočnými prázdnymi riadkami.

---

## 🧠 Čo si na týchto sed skriptoch precvičíme

| Prvok | Význam |
|---|---|
| `N` | pridá nasledujúci vstupný riadok do pattern space |
| `D` | odstráni text po prvý newline a reštartuje cyklus bez načítania nového riadku |
| `P` | vypíše pattern space iba po prvý newline |
| `h` | skopíruje pattern space do hold space |
| `H` | pripojí pattern space do hold space |
| `g` | skopíruje hold space do pattern space |
| `G` | pripojí hold space do pattern space |
| `x` | vymení pattern space a hold space |
| `b` | nepodmienený skok na návestie |
| `t` | skok na návestie po úspešnej substitúcii |
| `q` | ukončí spracovanie |
| `=` | vypíše číslo aktuálneho riadku |
| `y///` | transliterácia znakov |
| `r` | načítanie obsahu externého súboru |
| `e` | GNU rozšírenie – vykonanie textu cez shell |
| `\1` | spätný odkaz na prvú zachytávaciu skupinu |
| `-n` | vypne automatický výpis pattern space |
| `-E` | zapne rozšírené regulárne výrazy |

## 📚 Zdroj

Príklady a témy vychádzajú z kapitoly **Some Sample Scripts** oficiálneho GNU sed manuálu:

https://www.gnu.org/software/sed/manual/html_node/Examples.html
