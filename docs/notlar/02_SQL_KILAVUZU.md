# SQL Hızlı Kılavuz (Sınav Odaklı)

## 1. Constraint isimleri (INSERT/DELETE/UPDATE sorularında)

| İhlal | Ne zaman? |
|-------|-----------|
| **Entity integrity** | PK NULL veya eksik |
| **Referential integrity** | FK değeri parent’ta yok |
| **Key / uniqueness** | PK veya UNIQUE duplicate |
| **Domain** | Yanlış tip, CHECK false |
| **Tuple / relation CHECK** | Tablo sonundaki CHECK |

### ON DELETE / ON UPDATE

| Clause | Etki |
|--------|------|
| CASCADE | Zincirle sil/güncelle |
| SET NULL | FK → NULL (nullable olmalı) |
| SET DEFAULT | FK → default |
| RESTRICT / NO ACTION | İhlal → işlem reddedilir |

---

## 2. COMPANY – tip çıkmış sorgular

### a) Departman ortalama maaş > 30000

```sql
SELECT D.Dname, COUNT(E.Ssn) AS emp_count
FROM DEPARTMENT D, EMPLOYEE E
WHERE E.Dno = D.Dnumber
GROUP BY D.Dname
HAVING AVG(E.Salary) > 30000;
```

### b) En yüksek maaşlı çalışanın departmanındaki herkes

```sql
SELECT E.Fname, E.Lname
FROM EMPLOYEE E
WHERE E.Dno IN (
  SELECT Dno FROM EMPLOYEE
  WHERE Salary = (SELECT MAX(Salary) FROM EMPLOYEE)
);
```

### c) Proje başına çalışan sayısı

```sql
SELECT P.Pnumber, P.Pname, COUNT(W.Essn) AS cnt
FROM PROJECT P
LEFT JOIN WORKS_ON W ON P.Pnumber = W.Pno
GROUP BY P.Pnumber, P.Pname;
```

### d) En az maaşlıdan 10000+ fazla alanlar

```sql
SELECT E.Fname, E.Lname
FROM EMPLOYEE E
WHERE E.Salary >= 10000 + (SELECT MIN(Salary) FROM EMPLOYEE);
```

### e) Hiç çalışanı olmayan proje

```sql
SELECT P.Pname
FROM PROJECT P
WHERE P.Pnumber NOT IN (
  SELECT W.Pno FROM WORKS_ON W WHERE W.Pno IS NOT NULL
);
-- veya NOT EXISTS
```

---

## 3. İkinci şema (employee / works / company / manages)

### a) Müdüründen fazla kazanan

```sql
SELECT E.personName
FROM employee E, works W1, works W2, manages M
WHERE E.personName = W1.personName
  AND M.personName = E.personName
  AND M.managerName = W2.personName
  AND W1.salary > W2.salary;
```

### b) Müdürüyle aynı city ve street

```sql
SELECT E.personName
FROM employee E, manages M, employee Mgr
WHERE E.personName = M.personName
  AND M.managerName = Mgr.personName
  AND E.street = Mgr.street
  AND E.city = Mgr.city;
```

### c) "BNY Mellon" dışında çalışan

```sql
SELECT E.personName
FROM employee E
WHERE E.personName NOT IN (
  SELECT W.personName FROM works W
  WHERE W.companyName = 'BNY Mellon'
);
```

---

## 4. JOIN özeti

```sql
-- Eski stil
FROM A, B WHERE A.id = B.id

-- ANSI
FROM A INNER JOIN B ON A.id = B.id
FROM A LEFT OUTER JOIN B ON ...
```

| Tip | Sonuç |
|-----|--------|
| INNER | Eşleşenler |
| LEFT | Solun hepsi + sağ NULL |
| RIGHT | Sağın hepsi |
| FULL | Her iki taraf |

---

## 5. Aggregate kuralları

- SELECT’teki non-aggregate sütunlar **GROUP BY**’da olmalı.
- **HAVING** = grupları filtreler (WHERE satırları filtreler).
- `COUNT(*)`, `COUNT(col)` (NULL sayılmaz), `SUM`, `AVG`.

---

## 6. Nested query ipuçları

```sql
-- Correlated
SELECT ... FROM E e
WHERE EXISTS (
  SELECT 1 FROM DEPARTMENT d
  WHERE d.Dnumber = e.Dno AND ...
);

-- IN vs = ANY
WHERE col IN (subquery)
WHERE col = ANY (subquery)  -- benzer
```

---

## 7. Lab6 tarzı (CUSTOMER / PART / ORDERS)

```sql
-- Toplam sipariş tutarı
SELECT SUM(O.QUANTITY * P.PRICE)
FROM ORDERS O, PART P
WHERE O.PARTNUM = P.PARTNUM;

-- Müşteri bazında toplam adet
SELECT C.NAME, SUM(O.QUANTITY)
FROM CUSTOMER C, ORDERS O
WHERE O.NAME = C.NAME
GROUP BY C.NAME;
```

Tam script: [`sql/lab6_ornek.sql`](../../sql/lab6_ornek.sql)

---

## 8. Sınavda yazım sırası

1. Hangi tablolar?
2. JOIN koşulu
3. WHERE filtre
4. GROUP BY / HAVING
5. SELECT listesi
6. ORDER BY (istenirse)
