# 7 Günlük Final Çalışma Planı (COM2058)

Süre yoksa **kalın** günleri önceliklendir.

## Gün 1 – Temel kavramlar (Ch1–2)
- [ ] DB vs dosya sistemi, meta-data, transaction
- [ ] Üç şema mimarisi: internal / conceptual / external
- [ ] Logical vs physical data independence
- [ ] DDL, DML, SDL, VDL

**Kaynak:** `01_OZET_NOTLAR.md` §1–2

## Gün 2 – İlişkisel model (Ch3)
- [ ] Relation, tuple, domain, schema vs instance
- [ ] PK, FK, UNIQUE, CHECK, NULL
- [ ] Integrity: entity, referential, domain

**Pratik:** `sql/company_ornek_sorgular.sql` başı

## Gün 3 – SQL (Ch4–5) — **en kritik**
- [ ] CREATE TABLE, constraints, ON DELETE/UPDATE
- [ ] SELECT, WHERE, JOIN (INNER/LEFT/RIGHT/FULL)
- [ ] Nested query, IN, EXISTS, correlated subquery
- [ ] GROUP BY, HAVING, aggregate
- [ ] VIEW, TRIGGER (kavram)

**Pratik:** `02_SQL_KILAVUZU.md` + Lab5/Lab6 SQL

## Gün 4 – ER / EER / Mapping (Ch7–9)
- [ ] Entity, attribute, relationship, cardinality
- [ ] Weak entity, identifying relationship
- [ ] Ternary relationship, specialization
- [ ] 7 adımlı ER→relational mapping

**Pratik:** `08_PROJE_F1_OZET.md` + `03_ER_EER_OZET.md`

## Gün 5 – Cebir + Normalizasyon (Ch6, Ch15)
- [ ] SELECT, PROJECT, JOIN, DIVISION
- [ ] FD, closure, 2NF, 3NF, BCNF
- [ ] Update anomaly, spurious tuple

**Pratik:** `05_RELATIONAL_ALGEBRA.md`, `04_NORMALIZASYON.md`

## Gün 6 – Çıkmış deneme
- [ ] `06_CIKMIS_SORULAR_COZUM.md` – 120 dk zamanlı
- [ ] `../ÇIKMIŞ/COM2058_Midterm_2023.pdf` görsel tekrar
- [ ] `../ÇIKMIŞ/DATABASE MANAGEMENT_solation.pdf` kontrol

## Gün 7 – Tekrar + zayıf noktalar
- [ ] `09_SINAV_ONCESI_KONTROL.md` tamamla
- [ ] Yanlış yaptığın constraint / JOIN tiplerini tekrar yaz
- [ ] F1 ERD’yi kağıda Chen ile çiz (5 dk)

## Sınavda tipik puan dağılımı (çıkmışlara göre)

| Konu | Yaklaşık pay |
|------|----------------|
| INSERT/DELETE/UPDATE + constraint ihlali | %30–35 |
| SQL sorgu yazma (COMPANY / genel şema) | %30–35 |
| İkinci şema üzerinde SQL veya cebir | %20–30 |
| ER / normalizasyon (finalde daha fazla olabilir) | değişken |
