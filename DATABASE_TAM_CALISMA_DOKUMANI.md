# COM2058 Veritabanı Sistemleri — Baştan Sona Tam Çalışma Dokümanı

**Ders:** COM2058 – Database Systems  
**Kaynak kitap:** Elmasri & Navathe, *Fundamentals of Database Systems*, 6. baskı  
**Kapsam:** Ch01–09, Ch15 (normalizasyon), Ch21 (transaction) + Lab1–8 + Formula 1 projesi + çıkmış sınavlar  

Bu doküman, `/Database` klasöründeki slaytlar, lab’ler, çıkmışlar ve projenin birleştirilmiş öğrenme rehberidir. Kısa özetler için bu klasördeki `01`–`09` dosyaları; bu dosya ise **A’dan Z’ye sistematik öğrenme** içindir.

> **Kod ile öğrenme (uygulamalı):** [`DATABASE_KOD_ILE_OGRENME.md`](DATABASE_KOD_ILE_OGRENME.md) — SQL, constraint denemeleri, F1 şeması, Python/FastAPI örnekleri ve [`sql/ogrenme/`](sql/ogrenme/) altındaki çalıştırılabilir scriptler.

---

## İçindekiler

1. [Bu dokümanı nasıl kullanırsın?](#1-bu-dokümanı-nasıl-kullanırsın)
2. [Veritabanı nedir? (Ch1)](#2-veritabanı-nedir-ch1)
3. [Mimari ve kavramlar (Ch2)](#3-mimari-ve-kavramlar-ch2)
4. [İlişkisel model (Ch3)](#4-ilişkisel-model-ch3)
5. [SQL — tanımlama ve sorgulama (Ch4–5)](#5-sql--tanımlama-ve-sorgulama-ch45)
6. [İlişkisel cebir (Ch6)](#6-ilişkisel-cebir-ch6)
7. [ER modeli (Ch7)](#7-er-modeli-ch7)
8. [EER — genişletilmiş ER (Ch8)](#8-eer--genişletilmiş-er-ch8)
9. [ER → ilişkisel eşleme (Ch9)](#9-er--ilişkisel-eşleme-ch9)
10. [Normalizasyon (Ch15)](#10-normalizasyon-ch15)
11. [Transaction ve eşzamanlılık (Ch21)](#11-transaction-ve-eşzamanlılık-ch21)
12. [Lab’ler — uygulamalı öğrenme](#12-labler--uygulamalı-öğrenme)
13. [Formula 1 projesi — bütünleşik örnek](#13-formula-1-projesi--bütünleşik-örnek)
14. [Sınav ve çıkmış stratejisi](#14-sınav-ve-çıkmış-stratejisi)
15. [Sözlük ve formül kartı](#15-sözlük-ve-formül-kartı)
16. [Kaynak dosya haritası](#16-kaynak-dosya-haritası)

---

## 1. Bu dokümanı nasıl kullanırsın?

### Öğrenme sırası (önerilen)

| Hafta | Konu | Okuma | Pratik |
|-------|------|--------|--------|
| 1 | Ch1–2 temel kavramlar | §2–3 | Lab1 kurulum |
| 2 | Ch3 ilişkisel model | §4 | `company_ornek_sorgular.sql` başı |
| 3 | Ch4 SQL DDL/DML | §5.1–5.4 | Lab3–4 |
| 4 | Ch5 ileri SQL | §5.5–5.8 | Lab5–6, `02_SQL_KILAVUZU.md` |
| 5 | Ch7–9 ER/EER/mapping | §7–9 | Lab2, F1 ERD çiz |
| 6 | Ch6 cebir | §6 | Çıkmış cebir soruları |
| 7 | Ch15 normalizasyon | §10 | F1 rapor §5 |
| 8 | Ch21 + tekrar | §11 | Lab8, `06_CIKMIS` |

### Üç seviye okuma

- **Seviye A (ilk geçiş):** Her bölümdeki *“Özet”* ve *“Ezber”* kutuları.
- **Seviye B (anlama):** Örnekler, tablolar, SQL blokları — MySQL’de çalıştır.
- **Seviye C (sınav/proje):** `` dosyaları + çıkmış PDF’ler.

### Pratik ortam

```bash
# MySQL (Docker ile proje)
cd Project/UPLOAD_READY
docker compose up -d
mysql -h 127.0.0.1 -P 3306 -u f1user -p f1db

# Veya yerel MySQL + Lab SQL dosyaları
mysql -u root -p < sql/lab5_university.sql
```

---

## 2. Veritabanı nedir? (Ch1)

### 2.1 Temel tanımlar

| Terim | Tanım |
|-------|--------|
| **Mini-world (UoD)** | Modelediğimiz gerçek dünya parçası (ör. üniversite, şirket, F1) |
| **Database** | İlişkili verinin organize koleksiyonu |
| **DBMS** | Veriyi tanımlayan, saklayan, sorgulayan, koruyan yazılım |
| **Meta-data** | Verinin verisi — katalog (şema, constraint, istatistik) |
| **Application program** | DBMS üzerinden veriye erişen programlar |

### 2.2 DBMS’in işlevleri

1. **Veri tanımlama (DDL)** — tablo, tip, kısıt
2. **Veri manipülasyon (DML)** — SELECT, INSERT, UPDATE, DELETE
3. **Paylaşım ve eşzamanlı erişim**
4. **Güvenlik ve yetkilendirme**
5. **Transaction yönetimi** — tutarlılık, kurtarma
6. **Fiziksel depolama ve indeksleme**

### 2.3 Dosya sistemi vs veritabanı

| Dosya sistemi | Veritabanı yaklaşımı |
|---------------|----------------------|
| Her program kendi formatı | Ortak şema (katalog) |
| Program değişince veri değişir | Program–veri bağımsızlığı |
| Çakışan güncellemeler | Transaction + kilit |
| Anlamsal bütünlük zor | PK, FK, CHECK |

### 2.4 Tasarım fazları

```
Gereksinimler → Kavramsal tasarım (ER) → Mantıksal (ilişkisel şema) → Fiziksel (indeks, disk)
```

**UNIVERSITY örneği (slayt):** STUDENT, COURSE, SECTION, GRADE_REPORT, PREREQUISITE — sınavda COMPANY kadar sık değil ama kavram için iyi.

### 2.5 DB yaklaşımının dört özelliği

1. **Self-describing** — sistem katalogu şemayı tutar  
2. **Program–data independence** — uygulama mantıksal şemadan bağımsız  
3. **Data abstraction** — kullanıcı sadece ihtiyacı olan seviyeyi görür  
4. **Paylaşım** — çok kullanıcı, tutarlı erişim  

### Ezber (Ch1)

- Transaction = atomik iş birimi; ACID (§11’de detay).
- Tasarım: Requirements → Conceptual → Logical → Physical.

---

## 3. Mimari ve kavramlar (Ch2)

### 3.1 Veri modelleri

| Seviye | Model | Örnek |
|--------|--------|--------|
| Kavramsal | ER, EER | Varlık, ilişki diyagramı |
| Mantıksal / implementasyon | İlişkisel | Tablolar, SQL |
| Fiziksel | Depolama | Sayfa, indeks, dosya |

### 3.2 Şema vs örnek (instance)

- **Schema:** Yapının tanımı (sabit, nadiren değişir).
- **Instance:** Anlık veri (sık değişir).

### 3.3 Üç şema mimarisi (ANSI/SPARC)

```
                    ┌─────────────────┐
   Kullanıcı A ───►│ External schema │ (View)
                    └────────┬────────┘
                             │
                    ┌────────▼────────┐
                    │ Conceptual      │ (Tüm kurum verisi)
                    └────────┬────────┘
                             │
                    ┌────────▼────────┐
                    │ Internal schema │ (Fiziksel)
                    └─────────────────┘
```

| Bağımsızlık | Ne değişir? | Ne korunur? |
|-------------|-------------|-------------|
| **Logical** | Kavramsal şema | Dış şemalar (view’lar) |
| **Physical** | Internal şema | Kavramsal şema |

### 3.4 DBMS dilleri

| Kısaltma | Ad | Görev |
|----------|-----|--------|
| **DDL** | Data Definition Language | CREATE, ALTER, DROP |
| **DML** | Data Manipulation Language | SELECT, INSERT, UPDATE, DELETE |
| **SDL** | Storage Definition | Internal şema |
| **VDL** | View Definition | CREATE VIEW |
| **DCL** | (ek) | GRANT, REVOKE |

### Ezber (Ch2)

- External = view; Conceptual = tüm model; Internal = disk.
- Logical independence: kavramsal değişir, kullanıcı view’ları mümkünse aynı kalır.

---

## 4. İlişkisel model (Ch3)

### 4.1 Relation (ilişki)

- **Relation** = tablo adıyla karıştırma: matematikte *n-tuple kümesi*.
- **Tuple** = satır; **attribute** = sütun.
- **Degree** = attribute sayısı; **cardinality** = tuple sayısı.
- **Domain** = bir attribute’un alabileceği değer kümesi.

### 4.2 Birinci normal form (1NF) — model düzeyinde

İlişkisel model **düz (flat):** her hücre atomik; çok değerli veya composite attribute doğrudan tek sütunda tutulmaz (ER’de olabilir, tabloya geçerken ayrılır).

### 4.3 NULL

- Bilinmiyor, uygulanamaz veya bilinçli eksik.
- Karşılaştırmalarda üç değerli mantık: `UNKNOWN`.
- SQL: `IS NULL`, `IS NOT NULL` — `= NULL` **yanlış**.

### 4.4 Anahtarlar

| Tür | Tanım |
|-----|--------|
| **Superkey** | Tuple’ı tekilleştiren attribute kümesi |
| **Candidate key** | Minimal superkey |
| **Primary key (PK)** | Seçilen candidate key |
| **Alternate key** | Diğer candidate key’ler (UNIQUE) |
| **Foreign key (FK)** | Başka tablonun PK’sine referans |

### 4.5 Bütünlük kısıtları

| Kısıt | Kural |
|-------|--------|
| **Entity integrity** | PK hiçbir zaman NULL olamaz |
| **Referential integrity** | FK değeri ya parent PK ile eşleşir ya NULL (tablo tanımına bağlı) |
| **Domain integrity** | Tip + CHECK |

### 4.6 COMPANY şeması — ilişkisel düşünme alıştırması

Sınavın merkez şeması (`CompanySchema.pdf`):

- **EMPLOYEE** (Ssn PK), **DEPARTMENT** (Dnumber PK)
- **PROJECT** (Pnumber PK), **WORKS_ON** (Essn, Pno) + Hours
- **DEPENDENT** (Essn, Dependent_name)
- **DEPT_LOCATIONS** (Dnumber, Dlocation)

FK örnekleri: `EMPLOYEE.Dno → DEPARTMENT`, `WORKS_ON.Essn → EMPLOYEE`.

---

## 5. SQL — tanımlama ve sorgulama (Ch4–5)

### 5.1 DDL — tablo oluşturma

```sql
CREATE TABLE EMPLOYEE (
  Ssn        CHAR(9)  NOT NULL,
  Fname      VARCHAR(15),
  Lname      VARCHAR(15) NOT NULL,
  Salary     DECIMAL(10,2),
  Dno        INT,
  Super_ssn  CHAR(9),
  PRIMARY KEY (Ssn),
  UNIQUE (Lname, Fname),  -- örnek
  FOREIGN KEY (Dno) REFERENCES DEPARTMENT(Dnumber)
    ON DELETE SET DEFAULT
    ON UPDATE CASCADE,
  FOREIGN KEY (Super_ssn) REFERENCES EMPLOYEE(Ssn)
    ON DELETE SET NULL,
  CHECK (Salary > 0)
);
```

| Komut | Açıklama |
|-------|----------|
| `ALTER TABLE` | Sütun ekle/sil, kısıt ekle |
| `DROP TABLE` | Tabloyu sil |
| `CREATE VIEW` | Sanal tablo |
| `CREATE INDEX` | Performans (Lab8) |

### 5.2 DML — temel

```sql
INSERT INTO EMPLOYEE (Ssn, Lname, Dno) VALUES ('123456789', 'Smith', 5);
UPDATE EMPLOYEE SET Salary = Salary * 1.1 WHERE Dno = 5;
DELETE FROM EMPLOYEE WHERE Ssn = '123456789';
```

**Sınav tipi:** INSERT/DELETE/UPDATE öncesi sırayla kontrol et:
1. Entity integrity (PK)
2. Referential integrity (FK)
3. UNIQUE / KEY
4. CHECK / domain

### 5.3 SELECT yapısı

```sql
SELECT [DISTINCT] sütun_listesi
FROM   tablo_listesi
[WHERE koşul]
[GROUP BY sütunlar]
[HAVING grup_koşulu]
[ORDER BY sütun [ASC|DESC]];
```

**İşlem sırası (mantıksal):** FROM → WHERE → GROUP BY → HAVING → SELECT → ORDER BY

### 5.4 JOIN türleri

```sql
-- Eski stil (sınavda kabul)
FROM EMPLOYEE E, DEPARTMENT D WHERE E.Dno = D.Dnumber

-- ANSI (tercih)
FROM EMPLOYEE E
INNER JOIN DEPARTMENT D ON E.Dno = D.Dnumber

FROM PROJECT P
LEFT OUTER JOIN WORKS_ON W ON P.Pnumber = W.Pno
```

| JOIN | Sonuç |
|------|--------|
| INNER | Sadece eşleşenler |
| LEFT | Sol tablonun tümü; sağda eşleşmeyen → NULL |
| RIGHT | Sağ tablonun tümü |
| FULL | Her iki tarafın tümü |

### 5.5 Alt sorgular

```sql
-- IN
WHERE Dno IN (SELECT Dnumber FROM DEPARTMENT WHERE Dname = 'Research');

-- EXISTS (çoğu zaman NOT EXISTS ile “hiç yok”)
WHERE EXISTS (SELECT 1 FROM WORKS_ON W WHERE W.Essn = E.Ssn);

-- Correlated — iç sorgu dış satıra bağlı
WHERE Salary > (SELECT AVG(Salary) FROM EMPLOYEE E2 WHERE E2.Dno = E1.Dno);

-- ANY / ALL
WHERE Salary > ALL (SELECT Salary FROM EMPLOYEE WHERE Dno = 5);
```

**NOT IN tuzağı:** Alt sorgu NULL dönerse sonuç beklenmedik olabilir → `NOT EXISTS` daha güvenli.

### 5.6 Aggregate

| Fonksiyon | Not |
|-----------|-----|
| COUNT(*) | Tüm satırlar |
| COUNT(col) | NULL hariç |
| SUM, AVG, MIN, MAX | Sayısal |

```sql
SELECT D.Dname, AVG(E.Salary) AS avg_sal
FROM DEPARTMENT D
JOIN EMPLOYEE E ON D.Dnumber = E.Dno
GROUP BY D.Dnumber, D.Dname
HAVING AVG(E.Salary) > 30000;
```

**Kural:** SELECT’teki her non-aggregate sütun GROUP BY’da olmalı.

### 5.7 VIEW ve TRIGGER (kavram)

- **VIEW:** Saklanmayan sorgu; güvenlik ve basitleştirme.
- **TRIGGER:** Olay (INSERT/UPDATE/DELETE) sonrası otomatik prosedür.
- **ASSERTION:** Genelde DBMS’te sınırlı; CHECK veya trigger ile.

### 5.8 ON DELETE / ON UPDATE — sınav tablosu

| Clause | Etki |
|--------|------|
| CASCADE | Parent değişince child zincirle güncellenir/silinir |
| SET NULL | FK → NULL (sütun nullable olmalı) |
| SET DEFAULT | FK → default değer |
| RESTRICT / NO ACTION | İhlal varsa işlem **reddedilir** |

Detaylı örnekler: `02_SQL_KILAVUZU.md`, `06_CIKMIS_SORULAR_COZUM.md`

### 5.9 Sık SQL örnekleri (COMPANY)

**Departman ortalama maaş > 30000:**
```sql
SELECT D.Dname, COUNT(E.Ssn) AS emp_count
FROM DEPARTMENT D
JOIN EMPLOYEE E ON E.Dno = D.Dnumber
GROUP BY D.Dnumber, D.Dname
HAVING AVG(E.Salary) > 30000;
```

**Hiç çalışanı olmayan proje:**
```sql
SELECT P.Pname FROM PROJECT P
WHERE NOT EXISTS (SELECT 1 FROM WORKS_ON W WHERE W.Pno = P.Pnumber);
```

Çalıştırılabilir set: `sql/company_ornek_sorgular.sql`

---

## 6. İlişkisel cebir (Ch6)

### 6.1 Temel operatörler

| Operasyon | Sembol | SQL karşılığı |
|-----------|--------|----------------|
| SELECT | σ_condition | WHERE |
| PROJECT | π_cols | SELECT cols (duplicate gider) |
| RENAME | ρ | Alias |
| UNION | ∪ | UNION |
| INTERSECTION | ∩ | INTERSECT |
| DIFFERENCE | − | EXCEPT |
| CARTESIAN | × | CROSS JOIN |
| THETA JOIN | ⋈_θ | JOIN ... ON θ |
| NATURAL JOIN | ⋈ | NATURAL JOIN |
| DIVISION | ÷ | “Tüm X için” sorguları |

### 6.2 SELECT ve PROJECT

```
σ_{Salary>30000}(EMPLOYEE)
π_{Lname,Fname}(σ_{Dno=5}(EMPLOYEE))
```

### 6.3 JOIN pipeline örneği

Stafford’daki projelerde çalışanların soyadı:

1. `P' ← σ_{Plocation='Stafford'}(PROJECT)`
2. `W' ← WORKS_ON ⋈_{Pno=Pnumber} P'`
3. `E' ← EMPLOYEE ⋈_{Ssn=Essn} W'`
4. `π_{Lname}(E')`

### 6.4 DIVISION — “for all”

*Hangi çalışanlar **tüm** belirli projelerde çalışıyor?*

```
T ← π_{Essn,Pno}(WORKS_ON)
D ← π_{Pno}(σ_{...}(PROJECT))
Sonuç ← T ÷ D
```

### 6.5 Tuple / Domain Relational Calculus

**TRC:** `{ t | t ∈ R ∧ t.A > 5 }`  
**DRC:** Değişkenler domain’den.

Sınavda “TRC ile yaz” → SQL WHERE mantığına çok benzer; ∃ ve ∀ dikkat.

Detay: `05_RELATIONAL_ALGEBRA.md`

---

## 7. ER modeli (Ch7)

### 7.1 Chen notasyonu

| Sembol | Anlam |
|--------|--------|
| Dikdörtgen | Entity type |
| Çift çerçeve | Weak entity |
| Elips | Attribute |
| Çift elips | Multivalued attribute |
| Kesik çizgi elips | Derived attribute |
| Eşkenar dörtgen | Relationship |
| Altı çizili isim | Key / partial key |

### 7.2 Attribute türleri

- **Simple / composite** (Adres = Sokak + Şehir)
- **Single-valued / multivalued**
- **Stored / derived**
- **Key attribute** — entity’yi tanımlar

### 7.3 İlişki kardinalitesi

| Tip | Anlam | Mapping (özet) |
|-----|--------|------------------|
| 1:1 | Her biri en fazla bir | FK bir tarafa |
| 1:N | Bir çok | FK N tarafında |
| M:N | Çoktan çoğa | Ayrı ilişki tablosu |

### 7.4 Participation (min-max)

- **Total:** Her entity en az bir ilişkide (ör. her çalışan bir departmanda).
- **Partial:** Olmayabilir.

`(min, max)` gösterimi: (1,1) — (0,N) gibi.

### 7.5 Recursive relationship

Örnek: EMPLOYEE **supervises** EMPLOYEE — roller: supervisor / supervisee.

### 7.6 Weak entity

- Kendi başına PK yok; **owner entity** + **partial key** = tam PK.
- **Identifying relationship** (çift çizgi eşkenar dörtgen).

**F1 örneği:** RACE, owner SEASON, partial key `round_number`.

---

## 8. EER — genişletilmiş ER (Ch8)

### 8.1 Specialization / Generalization

| Kavram | Yön |
|--------|-----|
| Specialization | Üst → alt (top-down) |
| Generalization | Alt → üst (bottom-up) |

### 8.2 Kısıtlar

| | Disjoint | Overlapping |
|---|----------|-------------|
| **Total** | Her üye tam bir alt sınıfta | Aynı |
| **Partial** | Alt sınıfta olmayabilir | Aynı |

### 8.3 Category (union type)

Birden fazla superclass’tan gelen alt tip (ör. OWNER: PERSON | COMPANY | BANK).

### 8.4 Mapping seçenekleri (Step 8)

- **8A:** Superclass + her subclass ayrı tablo
- **8B:** Sadece subclass tabloları (total disjoint)
- **8C:** Tek tablo + `type` attribute

---

## 9. ER → ilişkisel eşleme (Ch9)

### 9.1 Yedi adım (ezber listesi)

| Adım | Kural |
|------|--------|
| 1 | Her **strong entity** → tablo; PK korunur |
| 2 | **Weak entity** → tablo; PK = owner PK + partial key; owner FK |
| 3 | **1:1** → FK bir tarafa veya ayrı tablo |
| 4 | **1:N** → FK **N** tarafında |
| 5 | **M:N** → yeni ilişki tablosu (iki FK, genelde composite PK) |
| 6 | **Multivalued attribute** → ayrı tablo (E_pk, value) |
| 7 | **N-ary (ternary+)** → tek tablo; tüm entity PK’ları + ilişki attribute’ları |
| 8 | **Specialization** → 8A / 8B / 8C |

### 9.2 COMPANY mapping özeti

- WORKS_ON: M:N → (Essn, Pno, Hours)
- DEPENDENT: 1:N → PK (Essn, Dependent_name)
- DEPT_LOCATIONS: 1:N → (Dnumber, Dlocation)

### 9.3 F1 mapping özeti

| ER | Tablo |
|----|--------|
| SEASON | seasons |
| RACE (weak) | races (season_year, round_number) |
| CONTRACTS (ternary) | team_drivers |
| RESULTS | race_results |
| STANDINGS | team_standings |

Detay: `Project/ERD.md`, `03_ER_EER_OZET.md`

---

## 10. Normalizasyon (Ch15)

### 10.1 Anomaliler

| Anomali | Ne olur? |
|---------|----------|
| **Insert** | Eksik bilgiyle kayıt ekleyememe |
| **Delete** | Silince başka bilgi de gider |
| **Update** | Aynı bilgi birden fazla yerde; tutarsızlık riski |

### 10.2 Functional dependency (FD)

- **X → Y:** Aynı X için Y tek değer.
- **Trivial:** Y ⊆ X
- **Closure F⁺:** F’ten türetilen tüm FD’ler.

**Armstrong aksiyomları:** Reflexivity, Augmentation, Transitivity.

### 10.3 Normal formlar — hiyerarşi

```
BCNF ⊂ 3NF ⊂ 2NF ⊂ 1NF
```

| NF | Tanım (pratik) |
|----|----------------|
| **1NF** | Atomik değerler |
| **2NF** | 1NF + composite PK’da partial dependency yok |
| **3NF** | 2NF + transitive dependency yok (non-key → non-key) |
| **BCNF** | Her non-trivial FD’nin determinant’ı candidate key |
| **4NF** | Multivalued dependency |
| **5NF** | Join dependency |

### 10.4 Örnek: 2NF ihlali

`(Ssn, Pno) → Hours` ✓  
`(Ssn, Pno) → Ename` ✗ (aslında `Ssn → Ename` — partial dependency)

### 10.5 Tasarım kuralları (informal)

1. Anlamlı şema  
2. Update anomaly minimize  
3. Gereksiz NULL az  
4. Spurious tuple üretmeyen join (yalnızca FK=PK ile join)

### 10.6 F1 projesi cevabı (özet)

| NF | F1 |
|----|-----|
| 1NF | Atomik; pilot listesi ayrı tablo |
| 2NF | Composite key’lerde partial yok |
| 3NF | Team alanları team_id’ye bağlı |
| BCNF | UNIQUE anahtarlar determinant |

**Bilinçli denormalizasyon:** `drivers.num_poles` vb. türetilmiş ama saklanan alanlar.

Detay: `04_NORMALIZASYON.md`, `Project/REPORT.md`

---

## 11. Transaction ve eşzamanlılık (Ch21)

### 11.1 ACID

| Özellik | Anlam |
|---------|--------|
| **Atomicity** | Ya hep ya hiç |
| **Consistency** | Kurallar korunur |
| **Isolation** | Eşzamanlı işlemler birbirini görmez (seviyeye göre) |
| **Durability** | Commit sonrası kalıcı |

### 11.2 Schedule

- **Serial:** Transaction’lar sırayla, çakışma yok.
- **Serializable:** Sonuç serial ile aynı — kabul edilir.
- **Non-serial:** Paralel; conflict/r/view serializability ile analiz.

### 11.3 Concurrency control

- **Lock** (shared / exclusive)
- **Two-phase locking (2PL)**
- **Deadlock:** Döngüsel bekleme → detection veya prevention

### 11.4 Isolation levels (SQL)

| Seviye | Tipik sorun |
|--------|-------------|
| READ UNCOMMITTED | Dirty read |
| READ COMMITTED | Non-repeatable read |
| REPEATABLE READ | Phantom |
| SERIALIZABLE | En sıkı |

Kaynak: `ÇIKMIŞ/DATABASE MANAGEMENT_solation.pdf`, Lab8.

---

## 12. Lab’ler — uygulamalı öğrenme

| Lab | Konu | Sınava etkisi | Pratik dosya |
|-----|------|----------------|--------------|
| 1 | Kurulum, CREATE, INSERT | DDL alışkanlığı | `LAB_eski/LAB1/` |
| 2 | ER okuma/çizim | Chen, cardinality | `LAB2/` |
| 3 | SELECT, WHERE | Temel sorgu | `LAB3/` |
| 4 | JOIN | Vize SQL temeli | `LAB4/` |
| 5 | Üniversite şeması | JOIN, GROUP BY | `sql/lab5_university.sql` |
| 6 | CUSTOMER/PART/ORDERS | FK, aggregate | `sql/lab6_ornek.sql` |
| 7 | Alt sorgu, VIEW | İleri SQL | `LAB7/` |
| 8 | Transaction, index | ACID kavram | `LAB8/` |

### Lab 5 — örnek sorgu

```sql
SELECT f.fname, COUNT(*) AS class_count
FROM faculty f
JOIN class c ON f.fid = c.fid
GROUP BY f.fid, f.fname;
```

### Lab 6 — öğrenilenler

- Composite PK: `(ORDEREDON, NAME, PARTNUM)`
- Çoklu JOIN + `SUM(QUANTITY * PRICE)`

Tam özet: `07_LAB_OZETLERI.md`

---

## 13. Formula 1 projesi — bütünleşik örnek

Proje, dersin **tüm fazlarını** tek mini-world’de uygular.

### 13.1 Fazlar (COM2058)

| Faz | Çıktı | Dosya |
|-----|--------|--------|
| 1 | Gereksinimler | `Project/Requirements.md` |
| 2 | Chen ERD | `Project/ERD.pdf`, `ERD.md` |
| 3 | MySQL + FastAPI (raw SQL) | `Formula_1.sql`, `app/` |
| 4 | Rapor | `Project/REPORT.md` |

### 13.2 Varlıklar ve zayıf/ternary yapılar

- **Weak entity:** RACE → `(season_year, round_number)`
- **Ternary:** CONTRACTS → `team_drivers(season_year, team_id, driver_id, role, seat_no)`
- **M:N:** RESULTS, STANDINGS

### 13.3 İş kuralları (CHECK örnekleri)

- `season_year >= 1950`
- `role = 'MAIN'` ⇒ `seat_no IN (1,2)`; `RESERVE` ⇒ `seat_no IS NULL`
- `race_start_date <= race_end_date`

### 13.4 Örnek sorgu

```sql
SELECT r.round_number, r.grand_prix_name, c.circuit_name
FROM races r
JOIN circuits c ON c.circuit_id = r.circuit_id
WHERE r.season_year = 2024
ORDER BY r.race_start_date;
```

12 örnek sorgu: `sql/f1_ornek_sorgular.sql`  
Kurulum: `Project/UPLOAD_READY/KURULUM.txt`

### 13.5 Projeyi öğrenme aracı olarak kullan

1. `Requirements.md` oku → mini-world cümleleri yazmayı öğren.  
2. ERD’yi kağıda Chen ile çiz (10 dk).  
3. `Formula_1.sql` ile mapping adımlarını eşle.  
4. `SAMPLE_QUERIES.sql` ile SQL pratiği yap.  
5. Rapordaki normalizasyon bölümünü 3NF sorusu gibi çöz.

Detay: `08_PROJE_F1_OZET.md`, `Project/HOCAYA_ANLATIM.md`

---

## 14. Sınav ve çıkmış stratejisi

### 14.1 Tipik puan dağılımı (çıkmışlara göre)

| Konu | Yaklaşık pay |
|------|----------------|
| INSERT/DELETE/UPDATE + constraint | %30–35 |
| SQL (COMPANY / ikinci şema) | %30–35 |
| Cebir / ikinci şema / ER | %20–30 |
| Normalizasyon / ER çizim | finalde değişken |

### 14.2 Constraint sorusu çözüm şablonu

Her işlem için yaz:

1. **İşlem:** INSERT / DELETE / UPDATE …  
2. **Kontrol:** PK → FK → UNIQUE → CHECK  
3. **Sonuç:** Red / Başarılı  
4. **Etkilenen tablolar:** CASCADE zinciri tablo tablo  

Örnek çözümler: `06_CIKMIS_SORULAR_COZUM.md`

### 14.3 7 günlük yoğun plan

`00_CALISMA_PLANI.md` — gün gün checklist.

### 14.4 Son gece

`09_SINAV_ONCESI_KONTROL.md`

### 14.5 1 saatlik deneme

| # | Görev | Süre |
|---|--------|------|
| 1 | 5 constraint analizi | 25 dk |
| 2 | 4 COMPANY SQL | 25 dk |
| 3 | 2 employee şeması SQL | 10 dk |
| 4 | 1 ER çizimi | 15 dk |

---

## 15. Sözlük ve formül kartı

### 15.1 Kritik 15 cümle (sınav)

1. PK asla NULL olamaz.  
2. FK ihlali = referential integrity.  
3. Duplicate PK/UNIQUE = key constraint.  
4. CHECK false = domain/tuple constraint.  
5. Weak entity owner olmadan var olamaz.  
6. M:N → her zaman ilişki tablosu (adım 5).  
7. Correlated subquery dış satıra bağlıdır.  
8. LEFT JOIN: sağ eşleşmezse NULL.  
9. BCNF ⊂ 3NF ⊂ 2NF ⊂ 1NF.  
10. CASCADE: parent silinince child da silinir.  
11. SET NULL: FK nullable olmalı.  
12. GROUP BY: SELECT’teki non-aggregate GROUP BY’da.  
13. HAVING filtreler grupları; WHERE satırları.  
14. NOT EXISTS genelde NOT IN’den güvenli (NULL).  
15. Spurious tuple: yanlış join attribute.

### 15.2 Kısaltmalar

| Kısaltma | Açılım |
|----------|--------|
| DBMS | Database Management System |
| DDL / DML | Definition / Manipulation |
| PK / FK | Primary / Foreign Key |
| ER / EER | Entity-Relationship / Extended |
| FD | Functional Dependency |
| UoD | Universe of Discourse |
| ACID | Atomicity, Consistency, Isolation, Durability |

---

## 16. Kaynak dosya haritası

### Ders materyalleri (klasör kökü)

| Tür | Konum |
|-----|--------|
| Slaytlar | `Elmasri_6e_Ch01.pptx` … `Ch09`, `Ch15`, `Ch21.pdf` |
| COMPANY şema | `CompanySchema.pdf` |
| Çıkmış | `ÇIKMIŞ/` (2021/2023 vize, final, isolation) |
| Lab’ler | `LAB_eski/`, `LAB_yeni/` |
| Proje | `Project/`, `Project/UPLOAD_READY/` |

### Hazırlık paketi (konu bazlı kısa notlar)

| Dosya | İçerik |
|-------|--------|
| `README.md` | Paket rehberi |
| `00_CALISMA_PLANI.md` | 7 günlük plan |
| `01_OZET_NOTLAR.md` | Bölüm özetleri |
| `02_SQL_KILAVUZU.md` | SQL + çıkmış sorgular |
| `03_ER_EER_OZET.md` | ER/EER/mapping |
| `04_NORMALIZASYON.md` | FD, NF |
| `05_RELATIONAL_ALGEBRA.md` | Cebir |
| `06_CIKMIS_SORULAR_COZUM.md` | Model çözümler |
| `07_LAB_OZETLERI.md` | Lab köprüsü |
| `08_PROJE_F1_OZET.md` | F1 sınav özeti |
| `09_SINAV_ONCESI_KONTROL.md` | Son kontrol |
| `sql/*.sql` | Çalıştırılabilir örnekler |

### Önerilen çalışma akışı

```
Bu doküman (A→Z) → Konu özeti (01–05) → sql/ pratik → 06 çıkmış → 09 kontrol
```

---

## Son not

Veritabanı öğrenmek **teori + SQL pratiği + şema okuma** üçlüsüdür. Bu dokümandaki her bölümden sonra en az bir sorguyu MySQL’de çalıştırman, COMPANY ve F1 şemalarını kağıda çizmen ve bir çıkmış constraint sorusunu sessizce çözmen kalıcı öğrenmeyi sağlar.

**İyi çalışmalar.**

*Son güncelleme: ders materyalleri ve F1 projesi (COM2058, 2025–2026) ile uyumlu.*
