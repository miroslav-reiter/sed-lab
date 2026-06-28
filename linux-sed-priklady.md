# 🧪 Linux sed – praktické príklady (cheat sheet)

## 📌 Čo je sed
`sed` (Stream Editor) je nástroj na **automatické spracovanie textu v prúde**. Používa sa na transformácie riadkov bez otvárania editora.

Typické použitie:
- úprava konfigurácií
- spracovanie logov
- automatizované skripty (DevOps)

---

# 1️⃣ 🟢 Základné použitie sed

### 🔹 Použitie
Overenie funkčnosti alebo prázdny príkaz (žiadna transformácia).

```bash
sed '' /etc/passwd
```

```bash
echo "toto je vstup" | sed ''
```

---

# 2️⃣ 🗑️ Mazanie riadkov (delete)

### 🔹 Použitie
Odstraňovanie riadkov podľa čísla alebo rozsahu.

```bash
sed 'd' /etc/passwd
```
➡ vymaže všetky riadky

```bash
sed '1d' /etc/passwd
```
➡ vymaže 1. riadok

```bash
sed '3d' /etc/passwd
```
➡ vymaže 3. riadok

```bash
sed '2,5d' /etc/passwd
```
➡ vymaže riadky 2 až 5

```bash
sed '1,10d;15,$d' /etc/passwd
```
➡ vymaže rozsahy 1–10 a 15 až koniec

---

# 3️⃣ 📤 Výpis riadkov (print)

### 🔹 Použitie
Filtrovanie výstupu bez úpravy súboru.

```bash
sed -n '2,5p' /etc/passwd
```
➡ zobrazí riadky 2–5

```bash
sed -n '/root/p' /etc/passwd
```
➡ zobrazí riadky obsahujúce "root"

---

# 4️⃣ 🔁 Náhrada textu (substitution)

### 🔹 Použitie
Základná transformácia textu pomocou `s///`.

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
➡ nahradí 2. výskyt v riadku

```bash
sed 's/root/admin/2g' /etc/passwd
```
➡ nahradí od 2. výskytu ďalej

---

# 5️⃣ ✏️ In-place úprava súboru

### ⚠️ Pozor
Prepíše súbor priamo.

```bash
sed -i 's/root/admin/g' /etc/passwd
```
➡ úprava súboru na disku

```bash
sed -i.bak '1d' /etc/passwd
```
➡ vytvorí zálohu `.bak`

---

# 6️⃣ ➕ Vkladanie a pridávanie riadkov

### 🔹 Použitie
Vkladanie textu do konkrétnej pozície.

```bash
sed '3i\NOVÝ RIADOK' /etc/passwd
```
➡ vloží pred 3. riadok

```bash
sed '3a\NOVÝ RIADOK' /etc/passwd
```
➡ pridá za 3. riadok

---

# 7️⃣ ⚙️ Viac príkazov naraz

### 🔹 Použitie
Kombinovanie operácií.

```bash
sed -e '1,10d' -e '15,$d' /etc/passwd
```

```bash
sed '1,10d;15,$d' /etc/passwd
```

---

# 8️⃣ 🧠 Rozšírené regex operácie

### 🔹 Použitie
Pokročilé pattern matching a delimitery.

```bash
sed 's#/home#/root#' /etc/passwd
```

```bash
sed 's%/home%/root%' /etc/passwd
```

```bash
sed -E 's/(root)(.*)/\1-user-\2/' /etc/passwd
```

---

# 9️⃣ 🎯 Print iba pri substitúcii

### 🔹 Použitie
Zobrazenie len upravených riadkov.

```bash
sed -n 's/root/admin/gp' /etc/passwd
```

---

# 🔟 🔠 Transformácie textu

### 🔹 Použitie
Práca s case a skupinami.

```bash
sed -E 's/(ro)ot/\U\1\E-ADMIN/' /etc/passwd
```

---

## ⚠️ Poznámky
- `/etc/passwd` je bezpečný systémový súbor (bez hesiel)
- `sed -i` môže poškodiť systémové súbory → používať opatrne
- rozdiely existujú medzi GNU sed a BSD sed
