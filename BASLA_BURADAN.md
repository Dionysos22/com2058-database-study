# Başla buradan

## 1 — Repoyu indir

GitHub’da **Code → Download ZIP** veya:

```bash
git clone <bu-repo-url>
cd com2058-database-study
```

## 2 — MySQL kur ve test et

```bash
mysql -u root -p -e "SELECT VERSION();"
```

## 3 — İlk veritabanı (10 dk)

```bash
cd sql/ogrenme
mysql -u root -p < 00_company_mini_schema.sql
mysql -u root -p company_ogrenme -e "SELECT * FROM EMPLOYEE;"
```

## 4 — JOIN pratiği (20 dk)

```bash
mysql -u root -p company_ogrenme < 02_select_join_adim_adim.sql
```

Constraint denemeleri (bilerek hata): `01_ddl_ve_constraint_denemeleri.sql` — **blok blok** çalıştır.

## 5 — Okuma planı

| Gün | Oku | Pratik |
|-----|-----|--------|
| 1–2 | [01_OZET_NOTLAR](docs/notlar/01_OZET_NOTLAR.md) | `sql/ogrenme/` |
| 3 | [02_SQL_KILAVUZU](docs/notlar/02_SQL_KILAVUZU.md) | `sql/company_ornek_sorgular.sql` |
| 4 | [03_ER](docs/notlar/03_ER_EER_OZET.md) + [04_NF](docs/notlar/04_NORMALIZASYON.md) | ERD çiz |
| 5–6 | [06_CIKMIS](docs/notlar/06_CIKMIS_SORULAR_COZUM.md) | Zamanlı deneme |
| 7 | [09_KONTROL](docs/notlar/09_SINAV_ONCESI_KONTROL.md) | Tekrar |

Tam plan: [00_CALISMA_PLANI.md](docs/notlar/00_CALISMA_PLANI.md)

## 6 — F1 örnekleri (isteğe bağlı)

```bash
cd sql
mysql -u root -p < f1_schema.sql
mysql -u root -p formula_1 < f1_demo_seed.sql
mysql -u root -p formula_1 < f1_ornek_sorgular.sql
```

Özet: [08_PROJE_F1_OZET.md](docs/notlar/08_PROJE_F1_OZET.md)

---

Tüm dosyalar: [docs/INDEX.md](docs/INDEX.md) · SQL detay: [sql/README.md](sql/README.md)
