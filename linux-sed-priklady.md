# Linux sed príklady

## Základné použitie
```bash
sed '' /etc/passwd
```

```bash
echo "toto je vstup" | sed ''
```

## Mazanie riadkov (delete)
```bash
sed 'd' /etc/passwd
sed '1d' /etc/passwd
sed '3d' /etc/passwd
sed '2,5d' /etc/passwd
sed '1,10d;15,$d' /etc/passwd
```

## Výpis riadkov (print)
```bash
sed -n '2,5p' /etc/passwd
sed -n '/root/p' /etc/passwd
```

## Náhrada textu (substitution)
```bash
sed 's/root/admin/' /etc/passwd
sed 's/root/admin/g' /etc/passwd
sed 's/root/admin/2' /etc/passwd
sed 's/root/admin/2g' /etc/passwd
```

## In-place úprava
```bash
sed -i 's/root/admin/g' /etc/passwd
sed -i.bak '1d' /etc/passwd
```

## Vkladanie a pridávanie
```bash
sed '3i\\NOVÝ RIADOK' /etc/passwd
sed '3a\\NOVÝ RIADOK' /etc/passwd
```

## Viac príkazov
```bash
sed -e '1,10d' -e '15,$d' /etc/passwd
sed '1,10d;15,$d' /etc/passwd
```

## Rozšírené regex
```bash
sed 's#/home#/root#' /etc/passwd
sed 's%/home%/root%' /etc/passwd
sed -E 's/(root)(.*)/\\1-user-\\2/' /etc/passwd
```

## Print iba pri substitúcii
```bash
sed -n 's/root/admin/gp' /etc/passwd
```

## Transformácie
```bash
sed -E 's/(ro)ot/\\U\\1\\E-ADMIN/' /etc/passwd
```
