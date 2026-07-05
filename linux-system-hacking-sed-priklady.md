# Linux Sed – Praktické príklady (System Hacking / DevOps / Security)

Tento súbor obsahuje štandardizované príklady použitia nástroja `sed` v Linuxe. Zameranie: administrácia, DevOps, bezpečnostná analýza, incident response a automatizácia.

---

# MODEL SPRACOVANIA SED

sed pracuje ako stream editor:

INPUT → PATTERN SPACE → RULE → OUTPUT

- spracovanie po riadkoch
- bez potreby načítania celého súboru
- bez štruktúry (line-based processing)

---

# TEXT TRANSFORMÁCIA

01. Nahradenie reťazca
sed 's/Linux/GNU Linux/' subor.txt

čo to robí:
Nahradí prvý výskyt reťazca Linux v každom riadku.

vysvetlenie:
s/// je substitution operátor
pattern space sa spracuje pre každý riadok

---

02. Globálna náhrada
sed 's/Linux/GNU Linux/g' subor.txt

čo to robí:
Nahradí všetky výskyty Linux v riadku.

vysvetlenie:
flag g znamená global replacement

---

03. Mazanie riadku
sed '3d' subor.txt

čo to robí:
Odstráni tretí riadok.

vysvetlenie:
d = delete pattern space

---

04. Mazanie rozsahu
sed '1,5d' subor.txt

čo to robí:
Odstráni riadky 1 až 5.

vysvetlenie:
range addressing (start,end)

---

# FILTEROVANIE RIADKOV

05. Filter podľa vzoru
sed '/debug/d' app.log

čo to robí:
Odstráni riadky obsahujúce debug.

vysvetlenie:
regex match v adrese

---

06. Prázdne riadky
sed '/^$/d' subor.txt

čo to robí:
Odstráni prázdne riadky.

vysvetlenie:
^$ = empty line regex

---

07. Komentáre
sed '/^#/d' config.txt

čo to robí:
Odstráni komentáre.

vysvetlenie:
comment filter

---

# VÝPIS RIADKOV

08. Prvý riadok
sed -n '1p' subor.txt

čo to robí:
Vypíše prvý riadok.

vysvetlenie:
-n disables auto print
p prints pattern space

---

09. Rozsah výpisu
sed -n '1,5p' subor.txt

čo to robí:
Vypíše riadky 1 až 5.

vysvetlenie:
range + print mode

---

10. Pattern match
sed -n '/error/p' app.log

čo to robí:
Vypíše riadky s error.

vysvetlenie:
regex filtering + print

---

# KOMBINÁCIE PRAVIDIEL

11. Cleanup logu
sed '/debug/d; /^$/d' app.log

čo to robí:
Odstráni debug a prázdne riadky.

vysvetlenie:
multiple rules in one script

---

12. Replace + filter
sed 's/ERROR/CRITICAL/g; /debug/d' app.log

čo to robí:
Zmení ERROR a odstráni debug.

vysvetlenie:
sequential execution

---

# REGEX OPERÁCIE

13. Čísla
sed -E 's/[0-9]+/NUM/g' subor.txt

čo to robí:
Nahradí čísla.

vysvetlenie:
extended regex

---

14. IP adresy
sed -E 's/[0-9]{1,3}(\.[0-9]{1,3}){3}/IP/g' access.log

čo to robí:
Maskuje IP adresy.

vysvetlenie:
regex groups

---

# SYSTEM SECURITY

15. SSH failed login
sed -n '/Failed password/p' auth.log

čo to robí:
Zobrazí neúspešné login pokusy.

---

16. Extrakcia IP
sed -E 's/.*from ([0-9.]+).*/\1/' auth.log

čo to robí:
Vytiahne IP adresu.

vysvetlenie:
capture group

---

# SYSTEM MONITORING

17. Disk usage

df -h | sed '1d'

čo to robí:
odstráni header

---

18. Process list

ps aux | sed '1d'

čo to robí:
odstráni hlavičku

---

# NETWORK ANALYSIS

19. HTTP 404
sed -n '/ 404 /p' access.log

čo to robí:
filtruje 404 requesty

---

20. IP anonymizácia
sed -E 's/[0-9]{1,3}(\.[0-9]{1,3}){3}/X.X.X.X/g' access.log

čo to robí:
skryje IP adresy

---

# CRON A SYSTÉM

21. Cron cleanup
sed '/^#/d' /etc/crontab

čo to robí:
odstráni komentáre

---

22. Suspicious commands
sed -n '/curl\|wget\|bash/p' /etc/crontab

čo to robí:
hľadá potenciálne nebezpečné príkazy

---

# LIMITÁCIE SED

23. Kedy nepoužiť sed

- JSON → jq
- XML → xmllint
- CSV → python
- komplexná logika → awk

---

# ZHRNUTIE

sed = stream transform engine
awk = data processing engine
grep = filter engine