# Lab Özetleri (COM2058)

Kaynak klasörler: `../LAB_eski/`, `../LAB_yeni/`

---

## LAB 1 – Giriş / kurulum
- MySQL kurulumu, `CREATE DATABASE`, `USE`
- Temel `CREATE TABLE`, `INSERT`
- **Dosya:** `LAB_eski/LAB1/COM2058_LAB1.pdf`, `LAB_yeni/COM2058_LAB1.docx`

**Sınava etkisi:** DDL syntax alışkanlığı.

---

## LAB 2 – ER / şema okuma
- Varlık–ilişki kavramları
- Şema diyagramı yorumlama
- **Dosya:** `LAB2/COM2058_LAB2.pdf` (+ ER görselleri)

**Sınava etkisi:** Chen çizimi ve cardinality.

---

## LAB 3 – SQL SELECT temel
- `SELECT`, `WHERE`, basit filtre
- **Dosya:** `LAB3/COM2058LAB3_2025.pdf`

---

## LAB 4 – JOIN
- Çoklu tablo, join koşulları
- **Dosya:** `LAB4/COM2058_LAB4.pdf`

**Sınava etkisi:** Midterm SQL’in temeli.

---

## LAB 5 – Üniversite şeması (class / student / faculty)

Tablolar (`2058Lab5.sql`):
- `student(snum, sname, major, level, age)`
- `faculty(fid, fname, deptid)`
- `class(name, meetsat, room, fid)` — PK `(name, meetsat)`
- `enrolled(snum, cname)` — PK `(snum, cname)`

### Örnek sorgu fikirleri
```sql
-- History major öğrenciler
SELECT * FROM student WHERE major = 'History';

-- Bir derse kayıtlılar + öğrenci adı
SELECT s.sname, e.cname
FROM student s JOIN enrolled e ON s.snum = e.snum
WHERE e.cname = 'ENG205';

-- Faculty başına ders sayısı
SELECT f.fname, COUNT(*) AS class_count
FROM faculty f JOIN class c ON f.fid = c.fid
GROUP BY f.fid, f.fname;
```

**Dosya:** `sql/lab5_university.sql`

---

## LAB 6 – CUSTOMER / PART / ORDERS

Tam çözüm: `../LAB_eski/LAB6/SOLUTION.txt` → `sql/lab6_ornek.sql`

Öğrenilenler:
- **Composite PK:** `(ORDEREDON, NAME, PARTNUM)`
- **FK:** ORDERS → CUSTOMER, PART
- **JOIN + aggregate:** SUM, GROUP BY
- **Multi-way JOIN:** CUSTOMER ⋈ ORDERS ⋈ PART

---

## LAB 7 – İleri SQL
- Alt sorgular, VIEW, güncelleme
- **Dosya:** `LAB7/COM2058_LAB7.pdf`, `2058LAB7_Answer.pdf`

---

## LAB 8 – Transaction / index (kavram)
- **Dosya:** `LAB8/COM2058_LAB8.pdf`, `2058LAB8_Answer.pdf`
- Ch21 ile birlikte oku: ACID, isolation

---

## Lab → Sınav köprüsü

| Lab | Sınav konusu |
|-----|----------------|
| 5–6 | SQL JOIN, GROUP BY |
| 6 | FK + constraint mantığı |
| 2, 7 | ER, nested SQL |
| 8 | Transaction (kısa) |

Proje (F1) = **büyük lab**: ER + DDL + karmaşık SQL → `08_PROJE_F1_OZET.md`
