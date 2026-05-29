# ER / EER ve İlişkisel Eşleme

## Chen notasyonu (sınav + proje)

| Sembol | Anlam |
|--------|--------|
| Dikdörtgen | Entity |
| Çift çerçeve | Weak entity |
| Elips | Attribute |
| Eşkenar dörtgen | Relationship |
| Altı çizili | Key / partial key |
| Kenar 1, N, M | Cardinality |

---

## Cardinality örnekleri

| İlişki | Anlam |
|--------|--------|
| 1:1 | Her E1 en fazla bir E2 |
| 1:N | Bir E1, çok E2 |
| M:N | Çoktan çoğa — ayrı tablo şart |

**Participation:** Total (her entity en az bir ilişkide) vs Partial.

---

## Weak entity (F1: RACE)

- **Owner:** SEASON (identifying relationship HAS_RACE)
- **Partial key:** `round_number`
- **Full PK:** `(season_year, round_number)`
- SQL: `races` tablosu; FK `season_year → seasons`

---

## Ternary relationship (F1: CONTRACTS)

- Üç entity: SEASON, TEAM, DRIVER
- Attributes on relationship: `role`, `seat_no`
- SQL: `team_drivers(season_year, team_id, driver_id, role, seat_no)`
- Business rule CHECK:
  - MAIN → seat_no ∈ {1,2}
  - RESERVE → seat_no IS NULL

---

## M:N with attributes

| F1 ilişki | Tablo |
|-----------|--------|
| RESULTS | `race_results` |
| STANDINGS | `team_standings` |

PK genelde her iki entity’nin key’lerinin birleşimi + gerekirse ek attribute.

---

## EER – Specialization

| Constraint | Anlam |
|------------|--------|
| Disjoint | Alt sınıflar kesişmez |
| Overlapping | Aynı entity birden fazla alt sınıfta olabilir |
| Total | Her superclass üyesi bir alt sınıfta |
| Partial | Olmayabilir |

**Mapping seçenekleri (Ch9 Step 8):**
- **8A:** Super + her subclass ayrı tablo
- **8B:** Sadece subclass tabloları (total disjoint)
- **8C:** Tek tablo + type attribute

---

## ER → Relational – 7 adım özeti

1. Strong entity → tablo
2. Weak entity → tablo + owner FK + partial key
3. 1:1 → FK veya cross-ref tablo
4. 1:N → FK N tarafında
5. M:N → ilişki tablosu
6. Multivalued → ayrı tablo (E, A)
7. N-ary → tek tablo (tüm PK’lar)

---

## COMPANY – hızlı ER hatırlatma

- EMPLOYEE — DEPARTMENT: works_in (N:1), Dno FK
- EMPLOYEE — EMPLOYEE: supervises (1:N), Super_ssn
- DEPARTMENT — DEPT_LOCATIONS: 1:N
- EMPLOYEE — PROJECT: WORKS_ON (M:N), Hours
- EMPLOYEE — DEPENDENT: 1:N, composite PK (Essn, Dependent_name)

**Sınav:** `CompanySchema.pdf` ile birlikte constraint soruları gelir.

---

## Pratik: Kağıda 5 dk’da F1 ERD

1. Ortada SEASON
2. HAS_RACE → çift çerçeve RACE
3. CIRCUIT — HOSTS — RACE
4. Üçgen: SEASON–TEAM–DRIVER (CONTRACTS)
5. SEASON—STANDINGS—TEAM, RACE—RESULTS—DRIVER

Detay: `08_PROJE_F1_OZET.md`, `../Project/ERD.md`
