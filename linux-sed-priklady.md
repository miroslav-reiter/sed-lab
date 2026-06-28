# Linux sed – praktické príklady (lab štýl)

## Čo je sed
sed (Stream Editor) je nástroj na spracovanie textu v prúde. Umožňuje transformácie riadkov bez interaktívneho editora a je vhodný pre automatizáciu v shell skriptoch.

Typické použitie:
- spracovanie konfigurácií
- analýza logov
- DevOps automatizácia

---

## 1. Základný výpis súboru
```bash
sed '' /etc/passwd
```

**Vysvetlenie:** sed prečíta vstupný súbor a nevykoná žiadnu transformáciu.

**Použitie:** test funkčnosti alebo pipeline validácia.

---

## 2. Spracovanie vstupu cez pipe
```bash
echo "toto je vstup" | sed ''
```

**Vysvetlenie:** vstup z STDIN je spracovaný bez úprav.

**Použitie:** testovanie správania v pipe reťazcoch.

---

## 3. Vymazanie všetkých riadkov
```bash
sed 'd' /etc/passwd
```

**Vysvetlenie:** príkaz `d` odstráni všetky riadky zo vstupu.

**Použitie:** filtrovanie obsahu alebo test delete operácie.

---

## 4. Vymazanie prvého riadku
```bash
sed '1d' /etc/passwd
```

**Vysvetlenie:** odstráni iba prvý riadok súboru.

**Použitie:** odstránenie hlavičky dát.

---

## 5. Vymazanie konkrétneho riadku
```bash
sed '3d' /etc/passwd
```

**Vysvetlenie:** odstráni tretí riadok vstupu.

**Použitie:** odstránenie konkrétnej položky v zozname.

---

## 6. Vymazanie rozsahu riadkov
```bash
sed '2,5d' /etc/passwd
```

**Vysvetlenie:** odstráni riadky od 2 po 5.

**Použitie:** odstránenie blokov dát.

---

## 7. Vymazanie viacerých rozsahov
```bash
sed '1,10d;15,$d' /etc/passwd
```

**Vysvetlenie:** kombinuje viac delete operácií.

**Použitie:** čistenie štruktúrovaných dát.

---

## 8. Výpis rozsahu riadkov
```bash
sed -n '2,5p' /etc/passwd
```

**Vysvetlenie:** vypíše iba vybrané riadky.

**Použitie:** extrakcia častí súboru.

---

## 9. Výpis podľa vzoru
```bash
sed -n '/root/p' /etc/passwd
```

**Vysvetlenie:** filtruje riadky obsahujúce text root.

**Použitie:** vyhľadávanie v konfiguráciách.

---

## 10. Náhrada prvého výskytu
```bash
sed 's/root/admin/' /etc/passwd
```

**Vysvetlenie:** nahradí prvý výskyt v každom riadku.

**Použitie:** základná transformácia textu.

---

## 11. Globálna náhrada
```bash
sed 's/root/admin/g' /etc/passwd
```

**Vysvetlenie:** nahradí všetky výskyty v riadku.

**Použitie:** hromadná zmena hodnôt.

---

## 12. Náhrada druhého výskytu
```bash
sed 's/root/admin/2' /etc/passwd
```

**Vysvetlenie:** upraví iba druhý výskyt v riadku.

**Použitie:** selektívne transformácie.

---

## 13. In-place úprava
```bash
sed -i 's/root/admin/g' /etc/passwd
```

**Vysvetlenie:** priamo upravuje súbor na disku.

**Použitie:** automatizované opravy konfigurácií.

---

## 14. In-place so zálohou
```bash
sed -i.bak '1d' /etc/passwd
```

**Vysvetlenie:** vytvorí zálohu pred úpravou.

**Použitie:** bezpečné modifikácie systémových súborov.

---

## 15. Vloženie riadku pred pozíciu
```bash
sed '3i\\NOVÝ RIADOK' /etc/passwd
```

**Vysvetlenie:** vloží text pred tretí riadok.

**Použitie:** dopĺňanie konfigurácie.

---

## 16. Pridanie riadku za pozíciu
```bash
sed '3a\\NOVÝ RIADOK' /etc/passwd
```

**Vysvetlenie:** pridá text za tretí riadok.

**Použitie:** rozšírenie dátových blokov.

---

## 17. Viac príkazov pomocou -e
```bash
sed -e '1,10d' -e '15,$d' /etc/passwd
```

**Vysvetlenie:** umožňuje reťazenie operácií.

**Použitie:** komplexné čistenie dát.

---

## 18. Viac príkazov cez bodkočiarku
```bash
sed '1,10d;15,$d' /etc/passwd
```

**Vysvetlenie:** alternatívny zápis viacerých operácií.

**Použitie:** skriptovanie bez viacerých -e.

---

## 19. Zmena delimitera v regex
```bash
sed 's#/home#/root#' /etc/passwd
```

**Vysvetlenie:** umožňuje použiť iný oddeľovač.

**Použitie:** čitateľnejšie regexy s cestami.

---

## 20. Zachytávanie skupín (regex)
```bash
sed -E 's/(root)(.*)/\1-user-\2/' /etc/passwd
```

**Vysvetlenie:** využíva capture groups v extended regex.

**Použitie:** pokročilé transformácie textu.

---

## 21. Výpis iba pri substitúcii
```bash
sed -n 's/root/admin/gp' /etc/passwd
```

**Vysvetlenie:** vypíše iba riadky, kde nastala zmena.

**Použitie:** kontrola zmien v dátach.

---

## 22. Transformácia pomocou regex rozšírení
```bash
sed -E 's/(ro)ot/\U\1\E-ADMIN/' /etc/passwd
```

**Vysvetlenie:** upravuje case a text pomocou regex operácií.

**Použitie:** normalizácia a formátovanie výstupov.
