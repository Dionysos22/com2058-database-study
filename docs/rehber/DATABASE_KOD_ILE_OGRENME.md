# Veritabanını Kod ile Öğren — Detaylı Uygulamalı Rehber

Bu doküman, **elle yazıp çalıştırarak** öğrenmen için hazırlandı. Teori için: [`DATABASE_TAM_CALISMA_DOKUMANI.md`](DATABASE_TAM_CALISMA_DOKUMANI.md).

---

## İçindekiler

1. [Ortam kurulumu](#1-ortam-kurulumu)
2. [Modül 1: İlk veritabanı ve DDL](#2-modül-1-ilk-veritabanı-ve-ddl)
3. [Modül 2: Constraint’leri kodla test et](#3-modül-2-constraintleri-kodla-test-et)
4. [Modül 3: SELECT ve JOIN adım adım](#4-modül-3-select-ve-join-adım-adım)
5. [Modül 4: Lab5–Lab6 şemaları](#5-modül-4-lab5lab6-şemaları)
6. [Modül 5: Formula 1 şeması (proje)](#6-modül-5-formula-1-şeması-proje)
7. [Modül 6: İleri SQL (F1 sorguları)](#7-modül-6-ileri-sql-f1-sorguları)
8. [Modül 7: Transaction kodu](#8-modül-7-transaction-kodu)
9. [Çalıştırılabilir dosya listesi](#9-çalıştırılabilir-dosya-listesi)

---

## 1. Ortam kurulumu

### Seçenek A — Yerel MySQL

```bash
# macOS (Homebrew)
brew install mysql
brew services start mysql
mysql -u root -p
```

### İlk veritabanını yükle (COMPANY mini)

```bash
cd sql/ogrenme
mysql -u root -p < 00_company_mini_schema.sql
mysql -u root -p company_ogrenme < 02_select_join_adim_adim.sql
```

---

## 2. Modül 1: İlk veritabanı ve DDL

**DDL** = Data Definition Language → yapıyı tanımlarsın.

### 2.1 En küçük örnek

```sql
CREATE DATABASE IF NOT EXISTS ilk_db;
USE ilk_db;

CREATE TABLE kisiler (
  id    INT AUTO_INCREMENT PRIMARY KEY,  -- PK: benzersiz, NULL olamaz
  ad    VARCHAR(50) NOT NULL,          -- zorunlu alan
  yas   INT CHECK (yas >= 0)           -- domain kısıtı
);

INSERT INTO kisiler (ad, yas) VALUES ('Sarp', 22);
SELECT * FROM kisiler;
```

| Satır | Ne yapıyor? |
|-------|-------------|
| `CREATE DATABASE` | Veritabanı oluşturur |
| `USE` | Sonraki komutların hedefi |
| `AUTO_INCREMENT` | id’yi MySQL otomatik artırır |
| `PRIMARY KEY` | Entity integrity: tekilleştirme |
| `NOT NULL` | Boş bırakılamaz |
| `CHECK` | Satır eklenirken koşul kontrolü |

### 2.2 FOREIGN KEY — ilişki kurma

```sql
CREATE TABLE bolumler (
  bolum_id INT PRIMARY KEY,
  ad       VARCHAR(30) UNIQUE
);

CREATE TABLE ogrenciler (
  no       INT PRIMARY KEY,
  isim     VARCHAR(40),
  bolum_id INT,
  FOREIGN KEY (bolum_id) REFERENCES bolumler(bolum_id)
    ON DELETE RESTRICT    -- bölüm silinirken öğrenci varsa RED
    ON UPDATE CASCADE     -- bolum_id değişirse öğrencide de güncelle
);
```

**Referential integrity:** `ogrenciler.bolum_id` değeri ya `bolumler`’de var olmalı ya da `NULL`.

### 2.3 COMPANY mini şeması (sınav mantığı)

Dosya: `../../sql/ogrenme/00_company_mini_schema.sql`

Önemli parça — `WORKS_ON` (M:N ilişki tablosu):

```sql
CREATE TABLE WORKS_ON (
  Essn   CHAR(9) NOT NULL,
  Pno    INT NOT NULL,
  Hours  DECIMAL(4,1),
  PRIMARY KEY (Essn, Pno),              -- composite PK
  FOREIGN KEY (Essn) REFERENCES EMPLOYEE(Ssn) ON DELETE CASCADE,
  FOREIGN KEY (Pno) REFERENCES PROJECT(Pnumber) ON DELETE SET DEFAULT
);
```

| Kavram | Kodda karşılığı |
|--------|------------------|
| M:N | Ayrı tablo + iki FK |
| Composite PK | `PRIMARY KEY (Essn, Pno)` |
| CASCADE | Parent silinince child da silinir |

---

## 3. Modül 2: Constraint’leri kodla test et

Dosya: `../../sql/ogrenme/01_ddl_ve_constraint_denemeleri.sql`

**Nasıl çalışılır:** Her bloğu **tek tek** MySQL’de çalıştır; hata alırsan mesajı oku — sınavda aynı isimleri yazacaksın.

### 3.1 Referential integrity örneği

```sql
USE company_ogrenme;

-- Dnum=99 yok → RED
INSERT INTO PROJECT VALUES (11, 'BadDept', 'X', 99);
```

Beklenen (MySQL 8):

```
ERROR 1452 (23000): Cannot add or update a child row:
a foreign key constraint fails
```

**Sınav cevabı şablonu:**
> Referential integrity ihlali: `PROJECT.Dnum=99` için `DEPARTMENT(Dnumber=99)` kaydı yok. İşlem reddedilir.

### 3.2 CHECK ihlali

```sql
INSERT INTO EMPLOYEE VALUES ('000000001', 'Neg', 'Salary', -100, 5, NULL);
```

> Domain/tuple constraint: `Salary > 0` CHECK false.

### 3.3 ON DELETE CASCADE gözlemle

```sql
SELECT COUNT(*) FROM WORKS_ON WHERE Essn = '123456789';
DELETE FROM EMPLOYEE WHERE Ssn = '123456789';
SELECT COUNT(*) FROM WORKS_ON WHERE Essn = '123456789';
-- Ikinci sayi 0 olmali
```

### 3.4 Sınav tipi DELETE analizi (kalemle yaz)

```sql
DELETE FROM DEPARTMENT WHERE Dnumber = 5;
```

Kontrol listesi:
1. `EMPLOYEE.Dno` → `ON DELETE SET DEFAULT` → Dno = 1
2. `PROJECT.Dnum` → SET DEFAULT
3. `DEPT_LOCATIONS` → `ON DELETE CASCADE` → satırlar silinir
4. `WORKS_ON` dolaylı etkilenir (employee/project)

---

## 4. Modül 3: SELECT ve JOIN adım adım

Dosya: `../../sql/ogrenme/02_select_join_adim_adim.sql`

### 4.1 SELECT yapısı (mantıksal sıra)

```sql
SELECT   -- 5) hangi sütunlar
FROM     -- 1) hangi tablolar
WHERE    -- 2) satır filtresi
GROUP BY -- 3) grupla
HAVING   -- 4) grup filtresi
ORDER BY -- 6) sırala
```

### 4.2 INNER JOIN — eşleşenler

```sql
SELECT E.Fname, D.Dname
FROM EMPLOYEE E
INNER JOIN DEPARTMENT D ON E.Dno = D.Dnumber;
```

`ON` = join koşulu. Eşleşmeyen çalışan veya departman **gelmez**.

### 4.3 LEFT JOIN — sol tablonun hepsi

```sql
SELECT P.Pname, W.Essn
FROM PROJECT P
LEFT JOIN WORKS_ON W ON P.Pnumber = W.Pno;
```

| P.Pname | W.Essn |
|---------|--------|
| ProductX | 123... |
| ProductZ | NULL ← hiç çalışan yok |

**Hiç çalışanı olmayan proje:**

```sql
SELECT P.Pname
FROM PROJECT P
LEFT JOIN WORKS_ON W ON P.Pnumber = W.Pno
WHERE W.Essn IS NULL;
```

### 4.4 GROUP BY + HAVING

```sql
SELECT D.Dname, AVG(E.Salary) AS avg_sal
FROM DEPARTMENT D
JOIN EMPLOYEE E ON D.Dnumber = E.Dno
GROUP BY D.Dnumber, D.Dname
HAVING AVG(E.Salary) > 27000;
```

| Kural | Açıklama |
|-------|----------|
| `GROUP BY` | Her grup bir satır döner |
| `HAVING` | Grupları filtreler (`WHERE` satırları filtreler) |
| SELECT | Aggregate olmayan sütun GROUP BY’da olmalı |

### 4.5 Alt sorgu türleri

**Skaler (tek değer):**

```sql
SELECT Fname, Lname FROM EMPLOYEE
WHERE Salary = (SELECT MAX(Salary) FROM EMPLOYEE);
```

**IN:**

```sql
WHERE Dno IN (SELECT Dnumber FROM DEPARTMENT WHERE Dname = 'Research');
```

**EXISTS (genelde NOT EXISTS ile “hiç yok”):**

```sql
SELECT P.Pname FROM PROJECT P
WHERE NOT EXISTS (
  SELECT 1 FROM WORKS_ON W WHERE W.Pno = P.Pnumber
);
```

**Correlated — dış satıra bağlı:**

```sql
SELECT E1.Fname, E1.Salary
FROM EMPLOYEE E1
WHERE E1.Salary > (
  SELECT AVG(E2.Salary) FROM EMPLOYEE E2 WHERE E2.Dno = E1.Dno
);
```

`E1.Dno` iç sorguda kullanıldığı için **her dış satır için** alt sorgu yeniden çalışır.

### 4.6 Self-join

```sql
SELECT E.Fname AS calisan, M.Fname AS amir
FROM EMPLOYEE E
LEFT JOIN EMPLOYEE M ON E.Super_ssn = M.Ssn;
```

Aynı tablo iki kez; alias şart (`E`, `M`).

---

## 5. Modül 4: Lab5–Lab6 şemaları

Dosya: `../../sql/ogrenme/03_lab6_university.sql`

### Lab5 — composite PK

```sql
CREATE TABLE class (
  name    VARCHAR(20),
  meetsat VARCHAR(20),
  ...
  PRIMARY KEY (name, meetsat)   -- ikisi birlikte anahtar
);
```

### Lab6 — sipariş + aggregate

```sql
SELECT SUM(O.QUANTITY * P.PRICE) AS total_revenue
FROM ORDERS O
JOIN PART P ON O.PARTNUM = P.PARTNUM;
```

**Üç tablo join:**

```sql
SELECT C.NAME, O.QUANTITY * P.PRICE AS line_total, P.DESCRIPTION
FROM CUSTOMER C
JOIN ORDERS O ON C.NAME = O.NAME
JOIN PART P ON O.PARTNUM = P.PARTNUM;
```

Tam COMPANY örnekleri: `../../sql/company_ornek_sorgular.sql`

---

## 6. Modül 5: Formula 1 şeması (proje)

Şema dosyası: [`sql/f1_schema.sql`](../../sql/f1_schema.sql)

### 6.1 Weak entity — `races`

```sql
CREATE TABLE races (
  season_year   INT NOT NULL,      -- owner (SEASON) FK
  round_number  INT NOT NULL,      -- partial key
  circuit_id    INT NOT NULL,
  grand_prix_name VARCHAR(160) NOT NULL,
  ...
  PRIMARY KEY (season_year, round_number),
  FOREIGN KEY (season_year) REFERENCES seasons(season_year)
);
```

ER’de: RACE çift çerçeve; PK = `season_year` + `round_number`.

### 6.2 Ternary ilişki — `team_drivers`

```sql
CREATE TABLE team_drivers (
  season_year INT NOT NULL,
  team_id     INT NOT NULL,
  driver_id   INT NOT NULL,
  role        ENUM('MAIN','RESERVE') NOT NULL,
  seat_no     TINYINT NULL,
  PRIMARY KEY (season_year, team_id, driver_id),
  CHECK (
    (role = 'MAIN' AND seat_no IS NOT NULL) OR
    (role = 'RESERVE' AND seat_no IS NULL)
  )
);
```

Üç entity tek tabloda; iş kuralı **CHECK** ile kodlanmış.

### 6.3 Composite FK — `race_results`

```sql
FOREIGN KEY (season_year, round_number)
  REFERENCES races(season_year, round_number)
  ON DELETE CASCADE
```

İki sütun birlikte parent PK’ya referans verir.

### 6.4 Şemayı ve demo veriyi yükle

```bash
cd sql
mysql -u root -p < f1_schema.sql
mysql -u root -p formula_1 < f1_demo_seed.sql
mysql -u root -p formula_1 -e "SHOW TABLES; SELECT * FROM seasons;"
```

---

## 7. Modül 6: İleri SQL (F1 sorguları)

Dosya: [`sql/f1_ornek_sorgular.sql`](../../sql/f1_ornek_sorgular.sql)

### 7.1 Sezon yarışları (JOIN + ORDER BY)

```sql
SELECT
  r.round_number,
  r.grand_prix_name,
  c.circuit_name,
  r.race_start_date
FROM races r
JOIN circuits c ON c.circuit_id = r.circuit_id
WHERE r.season_year = 2024
ORDER BY r.race_start_date, r.round_number;
```

| Parça | Rol |
|-------|-----|
| `JOIN circuits` | Pist adını getir |
| `WHERE season_year` | Filtre |
| `ORDER BY` | Kronolojik sıra |

### 7.2 Constructors standings (aggregate + window)

```sql
SELECT
  t.team_name,
  DENSE_RANK() OVER (ORDER BY SUM(rr.points) DESC) AS season_position,
  SUM(rr.points) AS season_points
FROM race_results rr
JOIN team_drivers td
  ON td.season_year = rr.season_year
 AND td.driver_id = rr.driver_id
 AND td.role = 'MAIN'
JOIN teams t ON t.team_id = td.team_id
WHERE rr.season_year = 2024
GROUP BY t.team_id, t.team_name
ORDER BY season_position;
```

- `SUM` + `GROUP BY` → takım başına puan
- `DENSE_RANK() OVER (...)` → sıralama (aynı puanda aynı sıra)
- `td.role = 'MAIN'` → sadece asıl pilotlar

### 7.3 Takım kadrosu

```sql
SELECT d.first_name, d.last_name, td.role, td.seat_no
FROM team_drivers td
JOIN drivers d ON d.driver_id = td.driver_id
WHERE td.season_year = 2024 AND td.team_id = 1
ORDER BY td.role, td.seat_no;
```

---

## 8. Modül 7: Transaction kodu

```sql
USE company_ogrenme;

START TRANSACTION;

UPDATE EMPLOYEE SET Salary = Salary * 1.1 WHERE Dno = 5;
-- Hata olursa: ROLLBACK;
-- Tamam ise:
COMMIT;
```

**ACID pratik:**

| Özellik | Bu örnekte |
|---------|------------|
| Atomicity | COMMIT veya ROLLBACK — ikisi birden olmaz |
| Consistency | CHECK/FK hâlâ geçerli |
| Isolation | Başka oturum ara değeri görmemeli (seviyeye bağlı) |
| Durability | COMMIT sonrası kalıcı |

İki bağlantili test (iki terminal):

```sql
-- Terminal 1
START TRANSACTION;
UPDATE EMPLOYEE SET Salary = 99999 WHERE Ssn = '333445555';
-- henuz COMMIT yok

-- Terminal 2
SELECT Salary FROM EMPLOYEE WHERE Ssn = '333445555';
-- READ COMMITTED ise eski degeri gorursun
```

---

## 9. Çalıştırılabilir dosya listesi

| Dosya | Ne öğretir? |
|-------|-------------|
| `sql/ogrenme/00_company_mini_schema.sql` | DDL + FK + örnek veri |
| `sql/ogrenme/01_ddl_ve_constraint_denemeleri.sql` | Constraint sınavı |
| `sql/ogrenme/02_select_join_adim_adim.sql` | SELECT → JOIN |
| `sql/ogrenme/03_lab6_university.sql` | Lab5 + Lab6 |
| `sql/company_ornek_sorgular.sql` | COMPANY |
| `sql/f1_schema.sql` + `f1_demo_seed.sql` | F1 şema + demo veri |
| `sql/f1_ornek_sorgular.sql` | F1 sorguları |

### Önerilen plan

| Gün | Görev |
|-----|--------|
| 1–2 | `sql/ogrenme/00`–`02` |
| 3 | `company_ornek_sorgular.sql` |
| 4 | `f1_schema` + `f1_demo_seed` + `f1_ornek` |
| 5–7 | `docs/notlar/06_CIKMIS` + tekrar |

---

**Sonraki adım:** `mysql -u root -p < ../../sql/ogrenme/00_company_mini_schema.sql` ile başla; takıldığın sorguyu gönder, satır satır açıklayabilirim.
