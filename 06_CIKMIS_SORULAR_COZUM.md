# Çıkmış Sorular ve Model Çözümler

Kaynaklar:
- `../ÇIKMIŞ/COM2058_Midterm_2023.pdf`
- `../ÇIKMIŞ/BLM2058Midterm2021 (1).pdf`
- `../ÇIKMIŞ/DATABASE MANAGEMENT_solation.pdf`
- `../CompanySchema.pdf`

---

## Bölüm A – UPDATE işlemleri (COMPANY) — ~35 puan

Verilen DDL’de tipik FK davranışları:
- `EMPLOYEE.Super_ssn` → ON DELETE **SET NULL**
- `EMPLOYEE.Dno` → ON DELETE **SET DEFAULT** (1)
- `WORKS_ON` → Essn CASCADE, Pno SET DEFAULT
- `DEPT_LOCATIONS` → CASCADE
- `DEPENDENT` → Essn CASCADE

### Soru 1 – INSERT `<'ProductA',3,'Bellaire',6>` INTO PROJECT

**İhlal:** Referential integrity — `Dnum=6` için `DEPARTMENT(Dnumber=6)` yok.  
**Sonuç:** İşlem **reddedilir**; tablo değişmez.

### Soru 2 – INSERT `<'677678989',40,'40.0'>` INTO WORKS_ON

**İhlaller (sınavda hepsini yaz):**
1. **Referential integrity (Essn):** 677678989 `EMPLOYEE`’de yok.
2. **Referential integrity (Pno):** 40 `PROJECT`’te yok (midterm’de Pno=40).
3. (Varsa) **Entity integrity:** PK bileşenleri NULL olamaz.

**Sonuç:** Red.

### Soru 3 – DELETE PROJECT where Pname='ProductY'

**Başarılı** ise: `WORKS_ON`’da `Pno` bu projeye referans veriyorsa → **ON DELETE SET DEFAULT** → Pno default değere (ör. 10 veya 20) güncellenir.  
Sadece etkilenen `WORKS_ON` satırlarını göster.

### Soru 4 – DELETE DEPARTMENT where Dnumber=5

- `EMPLOYEE.Dno`: **SET DEFAULT** → 1
- `PROJECT.Dnum`: **SET DEFAULT** → 1
- `DEPT_LOCATIONS`: **CASCADE** → ilgili satırlar silinir

Güncellenen tabloları ayrı ayrı listele.

### Soru 5 – UPDATE PROJECT Pnumber 3 → 20

**Başarılı** ise `ON UPDATE CASCADE`:
- `WORKS_ON.Pno` 3 olanlar → 20
- Başka FK’lar varsa zincirle güncellenir

**İhlal olasılığı:** 20 zaten başka projede PK ise → **key constraint**.

---

## Bölüm B – SQL (COMPANY) — 2023 midterm

### a) Ortalama maaş > 30000 departmanlar

```sql
SELECT D.Dname, COUNT(*) AS num_emp
FROM DEPARTMENT D, EMPLOYEE E
WHERE E.Dno = D.Dnumber
GROUP BY D.Dnumber, D.Dname
HAVING AVG(E.Salary) > 30000;
```

### b) En yüksek maaşlı çalışanın departmanındaki tüm çalışanlar

```sql
SELECT E.Fname, E.Lname
FROM EMPLOYEE E
WHERE E.Dno = (
  SELECT Dno FROM EMPLOYEE
  WHERE Salary = (SELECT MAX(Salary) FROM EMPLOYEE)
);
```

### c) Proje başına çalışan sayısı

```sql
SELECT P.Pnumber, P.Pname, COUNT(W.Essn)
FROM PROJECT P
LEFT JOIN WORKS_ON W ON P.Pnumber = W.Pno
GROUP BY P.Pnumber, P.Pname;
```

### d) En düşük maaş + 10000’den fazla alanlar

```sql
SELECT Fname, Lname
FROM EMPLOYEE
WHERE Salary > (SELECT MIN(Salary) FROM EMPLOYEE) + 10000;
```

---

## Bölüm C – İkinci şema (employee / works / company / manages)

### a) Müdüründen fazla kazanan

```sql
SELECT E.personName
FROM employee E
JOIN manages M ON E.personName = M.personName
JOIN works WE ON WE.personName = E.personName
JOIN works WM ON WM.personName = M.managerName
WHERE WE.salary > WM.salary;
```

### b) Müdürüyle aynı street ve city

```sql
SELECT E.personName
FROM employee E
JOIN manages M ON E.personName = M.personName
JOIN employee Boss ON Boss.personName = M.managerName
WHERE E.street = Boss.street AND E.city = Boss.city;
```

### c) BNY Mellon’da çalışmayan

```sql
SELECT E.personName
FROM employee E
WHERE NOT EXISTS (
  SELECT 1 FROM works W
  WHERE W.personName = E.personName
    AND W.companyName = 'BNY Mellon'
);
```

---

## Bölüm D – 2021 midterm ek SQL

1. **Maaşı > 30000 soyadlar:** `SELECT Lname FROM EMPLOYEE WHERE Salary > 30000;`
2. **Stafford projelerinde çalışan ortalama maaş:** PROJECT + WORKS_ON + EMPLOYEE join, `Plocation='Stafford'`, `AVG(Salary)`.
3. **Departman müdürünün toplam saatleri:** `Mgr_ssn = Essn` ile GROUP BY.
4. **Hiç çalışanı olmayan proje:** `NOT IN` veya `NOT EXISTS` (yukarıdaki gibi).

---

## Bölüm E – Relational algebra (isolation PDF tarzı)

Örnek tablolar `R(A,B)`, `S(B,C)` verilirse:

| İfade | Anlam |
|-------|--------|
| σ_{A>2}(R) | A>2 satırlar |
| π_B(R ⋈ S) | Join sonra B |
| R ∪ S | Union compatible olmalı |

Çözüm PDF’de adım adım tablo verilmiş — benzer soruda **ara sonuç tablosunu** çiz.

---

## Bölüm F – Final için ekstra hazırlık

Taranmış PDF’ler (`DB final 2020.pdf`, `Veritabanı final çalışma.pdf`, `çıkmışlar 2.pdf`) için:

1. Dosyayı aç, ER çizimi ve normalizasyon var mı işaretle.
2. Aynı tip soruyu `04_NORMALIZASYON.md` ve `03_ER_EER_OZET.md` ile çöz.
3. 120 dk’da: 5 constraint + 4 SQL + 1 ER veya 1 normalization yazmayı dene.

---

## Kendi kendine deneme (1 saat)

| # | Konu | Süre |
|---|------|------|
| 1 | 5 INSERT/DELETE analizi | 25 dk |
| 2 | 4 COMPANY SQL | 25 dk |
| 3 | 2 employee şeması SQL | 10 dk |
| 4 | 1 ER çiz (F1 veya COMPANY) | 15 dk |
| 5 | Kontrol | 5 dk |

Cevapları `02_SQL_KILAVUZU.md` ile karşılaştır.
