# SQL dosyaları

Tüm örnekler **MySQL** içindir.

## Önerilen sıra

| Sıra | Dosya | Veritabanı |
|------|--------|------------|
| 1 | `ogrenme/00_company_mini_schema.sql` | `company_ogrenme` |
| 2 | `ogrenme/02_select_join_adim_adim.sql` | `company_ogrenme` |
| 3 | `ogrenme/01_ddl_ve_constraint_denemeleri.sql` | `company_ogrenme` (blok blok) |
| 4 | `ogrenme/03_lab6_university.sql` | `lab_ogrenme` |
| 5 | `company_ornek_sorgular.sql` | `company_ogrenme` |
| 6 | `lab5_university.sql` | `Lab5comblm258` |
| 7 | `lab6_ornek.sql` | `LAB6` |
| 8 | `f1_schema.sql` → `f1_demo_seed.sql` → `f1_ornek_sorgular.sql` | `formula_1` |

```bash
cd sql/ogrenme
mysql -u root -p < 00_company_mini_schema.sql
mysql -u root -p company_ogrenme < ../ogrenme/02_select_join_adim_adim.sql

cd ..
mysql -u root -p < f1_schema.sql
mysql -u root -p formula_1 < f1_demo_seed.sql
mysql -u root -p formula_1 < f1_ornek_sorgular.sql
```

## Sık hatalar

| Hata | Çözüm |
|------|--------|
| `Unknown database` | Önce şema script’ini çalıştır |
| `Table doesn't exist` | `USE dogru_veritabani;` |
| FK hatası (`01_*`) | Beklenen — constraint notunu yaz |

Windows: MySQL Workbench → **Run SQL Script**.
