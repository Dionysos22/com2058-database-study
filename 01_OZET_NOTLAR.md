# COM2058 – Bölüm Özet Notları (Elmasri 6e)

Ders slaytları: Ch01, 02, 03, 04, 05, 06, 07, 08, 09, 15 (+ Ch21 transaction).

---

## Bölüm 1 – Veritabanı ve Kullanıcılar

- **Database:** İlişkili veri koleksiyonu; miniworld (UoD) gerçek dünyayı temsil eder.
- **DBMS:** Tanımlama (DDL), manipülasyon (DML), paylaşım, koruma, transaction yönetimi.
- **Meta-data:** Katalog/sözlük — şema tanımı.
- **Transaction:** Tutarlılık + recovery; ACID sınavda sık geçer (Ch21 ile birlikte).
- **UNIVERSITY örneği:** STUDENT, COURSE, SECTION, GRADE_REPORT, PREREQUISITE.
- **Tasarım fazları:** Requirements → Conceptual → Logical → Physical.

### DB yaklaşımının özellikleri
1. Self-describing (katalog)
2. Program–data independence
3. Data abstraction
4. Çoklu kullanıcı / paylaşım

---

## Bölüm 2 – Kavramlar ve Mimari

- **Data model:** Kavramsal / fiziksel / implementasyon (relational, object).
- **Schema vs instance:** Şema sabit yapı; instance anlık veri.
- **Three-schema architecture:**
  - External (view)
  - Conceptual
  - Internal (storage)
- **Data independence:** Logical (conceptual değişir, external etkilenmez), Physical.

### DBMS dilleri
| Dil | Amaç |
|-----|------|
| DDL | Şema |
| DML | Sorgu/güncelleme |
| SDL | Internal şema |
| VDL | View tanımı |

---

## Bölüm 3 – İlişkisel Model

- **Relation:** n-tuple kümesi; **degree** = attribute sayısı; **cardinality** = tuple sayısı.
- **1NF:** Atomik değerler; çok değerli / composite attribute yok (flat model).
- **NULL:** Bilinmiyor / uygulanamaz / bilinçli gizli.

### Kısıtlar
- **Domain:** Veri tipi aralığı
- **Key:** Unique + minimal (candidate); biri **primary**
- **Entity integrity:** PK ≠ NULL
- **Referential integrity:** FK ya eşleşen PK ya NULL (tabloya göre)

---

## Bölüm 4 – Temel SQL

```sql
CREATE TABLE T (
  A INT NOT NULL,
  B VARCHAR(20) DEFAULT 'x',
  PRIMARY KEY (A),
  UNIQUE (B),
  FOREIGN KEY (A) REFERENCES Other(X)
    ON DELETE CASCADE ON UPDATE SET NULL,
  CHECK (A > 0)
);
```

- **ALTER, DROP**
- **SELECT** … FROM … WHERE … ORDER BY
- **INSERT, UPDATE, DELETE**
- **VIEW:** Sanal tablo

---

## Bölüm 5 – İleri SQL

- **NULL mantığı:** Üç değerli; `IS NULL`, `IS NOT NULL`
- **Nested / correlated** subqueries
- **IN, EXISTS, ANY, ALL**
- **JOIN:** NATURAL, INNER, LEFT/RIGHT/FULL OUTER
- **Aggregate:** COUNT, SUM, AVG, MIN, MAX + **GROUP BY**, **HAVING**
- **ASSERTION, TRIGGER** (kavramsal)
- **Schema change:** ALTER TABLE, ADD/DROP column

---

## Bölüm 6 – İlişkisel Cebir

| Operasyon | Sembol | Anlam |
|-----------|--------|--------|
| SELECT | σ | Satır filtre |
| PROJECT | π | Sütun seç |
| UNION | ∪ | Birleşim (uyumlu şema) |
| INTERSECTION | ∩ | Kesişim |
| DIFFERENCE | − | Fark |
| CARTESIAN | × | Kartezyen |
| JOIN | ⋈ | θ veya equi-join |
| DIVISION | ÷ | “Hepsine sahip” sorguları |

**TRC / DRC:** Tuple ve domain relational calculus — “there exists”, “for all” ile sorgu.

---

## Bölüm 7 – ER Model

- **Entity type / set**, **attribute** (simple, composite, multivalued, derived)
- **Key attribute**
- **Relationship:** degree, cardinality (1:1, 1:N, M:N)
- **Role** (recursive relationship)
- **Structural constraint:** min-max (ör. (1,1) — (0,N))
- **COMPANY** örneği: EMPLOYEE, DEPARTMENT, PROJECT, WORKS_ON, …

---

## Bölüm 8 – EER

- **Subclass / superclass**, inheritance
- **Specialization** (top-down), **generalization** (bottom-up)
- **Disjoint / overlapping**, **total / partial**
- **Category (union type):** Birden fazla superclass

---

## Bölüm 9 – ER → İlişkisel

1. Her **regular entity** → tablo (PK korunur)
2. **Weak entity** → tablo; PK = owner PK + partial key
3. **1:1** → FK bir tarafa veya ayrı tablo
4. **1:N** → FK “N” tarafında
5. **M:N** → yeni ilişki tablosu (iki PK parçası)
6. **Multivalued attribute** → ayrı tablo
7. **N-ary** → tek tablo (tüm PK’lar + attribute)
8. **Specialization** → 8A/8B/8C seçenekleri (slaytta)

---

## Bölüm 15 – Normalizasyon

### Tasarım kuralları (informal)
1. Anlamı net şema
2. Update anomaly yok
3. Gereksiz NULL az
4. Spurious tuple üretmeyen join

### Normal formlar
- **1NF:** Atomik
- **2NF:** 1NF + partial dependency yok (composite PK’da)
- **3NF:** 2NF + transitive dependency yok
- **BCNF:** Her FD’nin determinant’ı candidate key
- **4NF:** MVD; **5NF:** join dependency

### Functional dependency
- X → Y: Aynı X için aynı Y
- **Closure F⁺**, **minimal cover**

---

## Bölüm 21 – Transaction (özet)

- **ACID:** Atomicity, Consistency, Isolation, Durability
- **Schedule:** Serial vs non-serial
- **Concurrency control:** Lock, 2PL, deadlock
- **Isolation levels:** READ UNCOMMITTED … SERIALIZABLE
- Finalde bazen kavram sorusu; `../ÇIKMIŞ/DATABASE MANAGEMENT_solation.pdf` dosyasına bak

---

## Sınavda ezberlenecek 10 cümle

1. PK asla NULL olamaz (entity integrity).
2. FK ihlali = referential integrity.
3. Duplicate PK = key constraint.
4. CHECK ihlali = domain/tuple constraint.
5. Weak entity owner olmadan yaşayamaz.
6. M:N her zaman ayrı tablo (mapping step 5).
7. Correlated subquery dış sorgunun satırına bağlıdır.
8. LEFT JOIN: sağda eşleşmeyenler NULL.
9. BCNF ⊂ 3NF ⊂ 2NF ⊂ 1NF.
10. ON DELETE CASCADE: parent silinince child da silinir.
