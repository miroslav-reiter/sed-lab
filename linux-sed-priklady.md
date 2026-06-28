# Linux sed – praktické príklady (cheat sheet)

## Čo je sed
sed (Stream Editor) je nástroj na automatické spracovanie textu v prúde. Používa sa na transformácie riadkov bez interaktívneho editora.

Typické použitie:
- úprava konfigurácií
- spracovanie logov
- automatizácia v shell skriptoch (DevOps)

---

## 1. Základné použitie sed

Použitie bez transformácie alebo test funkčnosti.

```bash
sed '' /etc/passwd
```

```bash
echo "toto je vstup" | sed ''
```

---

## 2. Mazanie riadkov (delete)

Použitie: odstránenie riadkov podľa čísla alebo rozsahu.

```bash
sed 'd' /etc/passwd
```
➡ vymaže všetky riadky

```bash
sed '1d' /etc/passwd
```
➡ vymaže prvý riadok

```bash
sed '3d' /etc/passwd
```
➡ vymaže tretí riadok

```bash
sed '2,5d' /etc/passwd
```
➡ vymaže riadky 2 až 5

```bash
sed '1,10d;15,$d' /etc/passwd
```
➡ vymaže rozsahy 1–10 a 15 až koniec

---

## 3. Výpis riadkov (print)

Použitie: filtrovanie výstupu bez zmeny súboru.

```bash
sed -n '2,5p' /etc/passwd
```
➡ zobrazí riadky 2–5

```bash
sed -n '/root/p' /etc/passwd
```
➡ zobrazí riadky obsahujúce "root"

---

## 4. Náhrada textu (substitution)

Použitie: transformácia textu pomocou s///

```bash
sed 's/root/admin/' /etc/passwd
```
➡ nahradí prvý výskyt v riadku

```bash
sed 's/root/admin/g' /etc/passwd
```
➡ nahradí všetky výskyty

```bash
sed 's/root/admin/2' /etc/passwd
```
➡ nahradí druhý výskyt

```bash
sed 's/root/admin/2g' /etc/passwd
```
➡ nahradí od druhého výskytu ďalej

---

## 5. In-place úprava súboru

⚠️ Pozor: mení súbor na disku

```bash
sed -i 's/root/admin/g' /etc/passwd
```

```bash
sed -i.bak '1d' /etc/passwd
```
➡ vytvorí zálohu

---

## 6. Vkladanie a pridávanie riadkov

```bash
sed '3i\\NOVÝ RIADOK' /etc/passwd
```
➡ vloží pred riadok 3

```bash
sed '3a\\NOVÝ RIADOK' /etc/passwd
```
➡ pridá za riadok 3

---

## 7. Viac príkazov naraz

```bash
sed -e '1,10d' -e '15,$d' /etc/passwd
```

```bash
sed '1,10d;15,$d' /etc/passwd
```

---

## 8. Rozšírené regex

```bash
sed 's#/home#/root#' /etc/passwd
```

```bash
sed 's%/home%/root%' /etc/passwd
```

```bash
sed -E 's/(root)(.*)/\\1-user-\\2/' /etc/passwd
```

---

## 9. Print iba pri substitúcii

```bash
sed -n 's/root/admin/gp' /etc/passwd
```

---

## 10. Transformácie textu

```bash
sed -E 's/(ro)ot/\\U\\1\\E-ADMIN/' /etc/passwd
```

---

## Poznámky
- /etc/passwd je bezpečný systémový súbor (neobsahuje heslá)
- sed -i môže byť nebezpečný pri systémových súboroch
- rozdiely existujú medzi GNU sed a BSD sed
