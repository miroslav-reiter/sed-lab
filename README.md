# 🧪 Online Kurz Sed (sed-lab)

Testovací repozitár na praktické trénovanie príkazu `sed` v Linuxe, hlavne v Kali Linuxe a Ubuntu Linuxe.

Repozitár je určený na precvičenie práce s textom, riadkami, regulárnymi výrazmi, nahrádzaním, mazaním, výpismi a jednoduchými transformáciami priamo v termináli.

## 📌 Čo je sed

`sed` znamená **stream editor**. Je to príkazový nástroj na spracovanie textového toku.

Typický spôsob práce:

```bash
sed 'príkaz' súbor
```

`sed` načíta riadok, aplikuje naň zadaný príkaz a výsledok vypíše na štandardný výstup. Pôvodný súbor sa nemení, pokiaľ nepoužijeme voľbu `-i`.

## 🎯 Na čo sa sed používa v praxi

`sed` používame hlavne na rýchle textové úpravy v termináli alebo shell skriptoch.

- nahrádzanie textu,
- výpis riadkov,
- filtrovanie,
- mazanie,
- log analýza,
- úpravy konfigurácií,
- pipeline spracovanie dát.

## 🧩 sed vs grep vs awk

| Nástroj | Použitie |
|---|---|
| grep | vyhľadávanie |
| sed | transformácia textu |
| awk | stĺpcové spracovanie |

## 🧾 Cheat Sheet (TABULKOVÁ FORMA)

### 🔁 Nahrádzanie
| Príkaz | Popis | Príklad |
|---|---|---|
| `s/old/new/` | nahradí prvý výskyt | `sed 's/a/b/' file` |
| `s/old/new/g` | nahradí všetky výskyty | `sed 's/a/b/g' file` |
| `s/^start/BEGIN/` | začiatok riadku | `sed 's/^a/X/' file` |
| `s/end$/FIN/` | koniec riadku | `sed 's/x$/y/' file` |

### 🧭 Adresovanie riadkov
| Príkaz | Popis | Príklad |
|---|---|---|
| `5d` | zmaže riadok 5 | `sed '5d' file` |
| `1,10d` | zmaže rozsah | `sed '1,10d' file` |
| `/error/d` | podľa vzoru | `sed '/error/d' file` |
| `/a/,/b/d` | rozsah vzorov | `sed '/start/,/end/d' file` |

### 📤 Výpis
| Príkaz | Popis | Príklad |
|---|---|---|
| `-n 'p'` | vypne auto print | `sed -n 'p' file` |
| `-n '1p'` | prvý riadok | `sed -n '1p' file` |
| `/pattern/p` | podľa vzoru | `sed -n '/err/p' file` |

### ✏️ Vkladanie / mazanie / zmena
| Príkaz | Popis | Príklad |
|---|---|---|
| `i TEXT` | vloží pred riadok | `sed '1i A' file` |
| `a TEXT` | vloží za riadok | `sed '1a B' file` |
| `c TEXT` | nahradí riadok | `sed '3c X' file` |
| `d` | zmaže riadok | `sed '2d' file` |

### 🔧 Pokročilé operácie
| Príkaz | Popis | Príklad |
|---|---|---|
| `-E 's/[0-9]+/NUM/g'` | regex replace | `sed -E 's/[0-9]+/X/g' file` |
| `=` | číslovanie riadkov | `sed '=' file` |
| `G` | pridá prázdny riadok | `sed G file` |

## 🔒 Bezpečnostné poznámky (rozšírené)

Používanie `sed` v praxi má riziká najmä pri automatizácii.

### Kritické riziká:

- `-i` bez backupu môže zničiť dáta
- nesprávny regex môže prepísať celý súbor
- pipeline môže prepísať vstup bez návratu

### Best practices:

- vždy používať `.bak`:
```bash
sed -i.bak 's/a/b/' file
```

- testovať bez `-i`
- používať `--sandbox` pri neznámych skriptoch
- logy nikdy neupravovať priamo v produkcii

### Atomicita
sed nie je transakčný nástroj → neexistuje rollback

## 🪟 Windows podpora (rozšírené)

`sed` nie je natívny Windows nástroj.

### Varianty:

| Prostredie | Hodnotenie | Poznámka |
|---|---|---|
| WSL | ⭐⭐⭐⭐⭐ | najlepšia voľba |
| Cygwin | ⭐⭐⭐⭐ | Unix vrstva |
| MSYS2 | ⭐⭐⭐⭐ | vývojárske prostredie |
| Git Bash | ⭐⭐⭐ | základné použitie |
| natívny sed | ⭐⭐ | obmedzené |

### Dôležité rozdiely:

- CRLF vs LF
- Windows cesty vs Linux `/`
- quoting rozdiely

### Odporúčanie:

Použiť WSL pre výučbu a prax.

## 📚 Užitočné odkazy a zdroje (rozšírené)

- GNU sed: https://www.gnu.org/software/sed/
- POSIX: https://pubs.opengroup.org/onlinepubs/9699919799/
- GNU manuals: https://www.gnu.org/

