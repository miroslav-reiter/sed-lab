# Linux Sed – Praktické príklady (System Hacking / DevOps / Security)

Tento súbor obsahuje štandardizované príklady použitia nástroja `sed` v Linuxe. Zameranie: administrácia, DevOps, bezpečnostná analýza, incident response a automatizácia.

---

## 🧠 Ako čítať tieto SED príkazy

Základný tvar príkazu:

```bash
sed 'script' subor
```

### Najdôležitejšie prvky:

| Prvok | Význam |
|------|--------|
| `sed` | spustí nástroj sed |
| `'...'` | sed skript (príkazy v shelli) |
| `s///` | substitúcia textu |
| `d` | vymazanie riadku |
| `p` | výpis riadku |
| `-n` | vypne automatický výpis |
| `-e` | pridá výraz do spracovania |
| `-f` | načíta skript zo súboru |
| `-E` | extended regex |
| `^` | začiatok riadku |
| `$` | koniec riadku |
| `/pattern/` | regex výber riadkov |
| `;` | oddelenie viacerých príkazov |

### Dôležitý rozdiel oproti AWK:

| Koncept | sed | awk |
|--------|-----|-----|
| model | stream editor | textový jazyk |
| polia `$1` | ❌ nepoužíva | ✅ používa |
| riadky | áno | áno |
| stav | bezstavový | čiastočne stavový |
| vhodné na | transformácie | analýzu dát |

---

## 🧠 Model spracovania sed

sed pracuje ako stream editor:

INPUT → PATTERN SPACE → RULE → OUTPUT

- spracovanie po riadkoch
- bez načítania celého súboru
- line-based processing

---

## 🔁 Text transformácia

**01. Nahradenie reťazca**  
```bash
sed 's/Linux/GNU Linux/' subor.txt
```
čo to robí:
Nahradí prvý výskyt reťazca Linux v každom riadku.

vysvetlenie:
s/// je substitution operátor
pattern space sa spracuje po riadkoch

---

**02. Globálna náhrada**  
```bash
sed 's/Linux/GNU Linux/g' subor.txt
```
čo to robí:
Nahradí všetky výskyty Linux v riadku.

vysvetlenie:
flag g znamená global replacement

---

**03. Mazanie riadku**  
```bash
sed '3d' subor.txt
```
čo to robí:
Odstráni tretí riadok.

vysvetlenie:
d = delete pattern space

---

**04. Mazanie rozsahu**  
```bash
sed '1,5d' subor.txt
```
čo to robí:
Odstráni riadky 1 až 5.

vysvetlenie:
range addressing (start,end)

---

## 🔎 Filterovanie riadkov

**05. Filter podľa vzoru**  
```bash
sed '/debug/d' app.log
```
čo to robí:
Odstráni riadky obsahujúce debug.

vysvetlenie:
regex match v adrese

---

**06. Prázdne riadky**  
```bash
sed '/^$/d' subor.txt
```
čo to robí:
Odstráni prázdne riadky.

vysvetlenie:
^$ = empty line regex

---

**07. Komentáre**  
```bash
sed '/^#/d' config.txt
```
čo to robí:
Odstráni komentáre.

vysvetlenie:
filter komentárov

---

## 👀 Výpis riadkov

**08. Prvý riadok**  
```bash
sed -n '1p' subor.txt
```
čo to robí:
Vypíše prvý riadok.

vysvetlenie:
-n vypne auto print, p vypíše pattern space

---

**09. Rozsah výpisu**  
```bash
sed -n '1,5p' subor.txt
```
čo to robí:
Vypíše riadky 1 až 5.

vysvetlenie:
range + print mode

---

**10. Pattern match**  
```bash
sed -n '/error/p' app.log
```
čo to robí:
Vypíše riadky s error.

vysvetlenie:
regex filter + print

---

## ⚙️ Kombinácie pravidiel

**11. Cleanup logu**  
```bash
sed '/debug/d; /^$/d' app.log
```
čo to robí:
Odstráni debug a prázdne riadky.

vysvetlenie:
viac pravidiel v jednom skripte

---

**12. Replace + filter**  
```bash
sed 's/ERROR/CRITICAL/g; /debug/d' app.log
```
čo to robí:
Zmení ERROR a odstráni debug.

vysvetlenie:
sekvenčné spracovanie pravidiel

---

## 🧪 Regex operácie

**13. Čísla**  
```bash
sed -E 's/[0-9]+/NUM/g' subor.txt
```
čo to robí:
Nahradí čísla.

vysvetlenie:
extended regex

---

**14. IP adresy**  
```bash
sed -E 's/[0-9]{1,3}(\.[0-9]{1,3}){3}/IP/g' access.log
```
čo to robí:
Maskuje IP adresy.

vysvetlenie:
regex grouping

---

## 🔐 System security

**15. SSH failed login**  
```bash
sed -n '/Failed password/p' auth.log
```
čo to robí:
Zobrazí neúspešné login pokusy.

---

**16. Extrakcia IP**  
```bash
sed -E 's/.*from ([0-9.]+).*/\1/' auth.log
```
čo to robí:
Vytiahne IP adresu.

vysvetlenie:
capture group

---

## 📊 System monitoring

**17. Disk usage**  
```bash
df -h | sed '1d'
```
čo to robí:
odstráni header

---

**18. Process list**  
```bash
ps aux | sed '1d'
```
čo to robí:
odstráni hlavičku

---

## 🌐 Network analysis

**19. HTTP 404**  
```bash
sed -n '/ 404 /p' access.log
```
čo to robí:
filtruje 404 requesty

---

**20. IP anonymizácia**  
```bash
sed -E 's/[0-9]{1,3}(\.[0-9]{1,3}){3}/X.X.X.X/g' access.log
```
čo to robí:
skryje IP adresy

---

## ⏱️ Cron a systém

**21. Cron cleanup**  
```bash
sed '/^#/d' /etc/crontab
```
čo to robí:
odstráni komentáre

---

**22. Suspicious commands**  
```bash
sed -n '/curl\|wget\|bash/p' /etc/crontab
```
čo to robí:
hľadá podozrivé príkazy

---

## 🧠 Zhrnutie

sed = stream transform engine
awk = data processing engine
grep = filter engine