# 🐧 Linux Sed – Praktické príklady pre system hacking, DevOps a bezpečnosť

Tento súbor obsahuje praktické príklady použitia `sed` v Linux prostredí (Kali, Ubuntu, Debian). Zameriava sa na reálne scenáre z praxe: administrácia, DevOps, bezpečnostná analýza, etický hacking a troubleshooting.

---

## ⚠️ Bezpečnostná poznámka

Príkazy so `sed` môžu meniť dáta. V produkcii:

- vždy testujeme bez `-i`
- používame `-i.bak`
- nikdy neupravujeme systémové súbory bez zálohy
- logy a konfigurácie iba čítame pri analýze

---

## 🧠 Model práce sed

```bash
sed 'príkaz' súbor
```

Model:

- čítaj riadok
- aplikuj pravidlo
- vypíš výsledok
- pôvodný súbor sa nemení (ak nepoužijeme `-i`)

---

## 📁 Demo súbory (lab režim)

```bash
subor.txt
config.txt
app.log
urls.txt
access.log
```

---

## 🧩 1. Základné nahrádzanie textu (s)

### Nahradenie reťazca

```bash
sed 's/Linux/GNU Linux/' subor.txt
```

### Globálna náhrada

```bash
sed 's/Linux/GNU Linux/g' subor.txt
```

---

## 🧩 2. Mazanie riadkov (d)

### Vymazanie konkrétneho riadku

```bash
sed '3d' subor.txt
```

### Rozsah riadkov

```bash
sed '1,5d' subor.txt
```

### Mazanie podľa vzoru

```bash
sed '/debug/d'
```

```bash
sed '/error/d'
```

### Odstránenie prázdnych riadkov

```bash
sed '/^$/d'
```

### Odstránenie komentárov

```bash
sed '/^#/d'
```

---

## 🧩 3. Výpis riadkov (-n + p)

```bash
sed -n '1p' subor.txt
sed -n '1,5p' subor.txt
sed -n '/error/p' app.log
```

---

## 🧩 4. Kombinácia pravidiel

```bash
sed '/debug/d; /^$/d' app.log
sed 's/ERROR/CHYBA/g; /debug/d' app.log
```

---

## 🧩 5. Regulárne výrazy

```bash
sed -E 's/[0-9]+/CISLO/g' subor.txt
sed -E 's/[0-9]{1,3}(\.[0-9]{1,3}){3}/IP/g' access.log
```

---

## 🧩 6. Log analýza (security)

```bash
sed -n '/Failed password/p' /var/log/auth.log
sed -E 's/.*from ([0-9.]+).*/\1/' /var/log/auth.log
```

---

## 🧩 7. Web logy

```bash
sed -n '/ 404 /p' access.log
sed -E 's/[0-9]{1,3}(\.[0-9]{1,3}){3}/IP/g' access.log
```

---

## 🧩 8. System výstupy

```bash
df -h | sed '1d'
ps aux | sed '1d'
```

---

## 🧩 9. Cron analýza

```bash
sed '/^#/d' /etc/crontab
sed -n '/curl\|wget\|bash/p' /etc/crontab
```

---

## 🧩 10. URL transformácie

```bash
sed -i.bak 's/http:/https:/g' urls.txt
```

---

## ⚠️ 11. Časté chyby

- použitie -i bez testu
- zlá práca s regex
- nesprávne úvodzovky
- očakávanie stĺpcového spracovania (sed ≠ awk)
- nepochopenie s/// vs d

---

## 🧠 12. Kedy nepoužiť sed

- JSON → jq
- XML → xmllint
- CSV → python/csvkit
- komplexná logika → awk alebo Python

---

## 🚀 Zhrnutie

sed je nástroj na:

- rýchle textové transformácie
- log filtering
- config cleanup
- stream processing
- shell pipeline operácie