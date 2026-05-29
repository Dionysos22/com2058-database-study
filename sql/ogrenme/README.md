# sql/ogrenme — adım adım pratik

Bu klasör **sıfırdan** başlamak için. Dosyaları **numara sırasıyla** çalıştır.

| # | Dosya | Ne öğrenirsin? |
|---|--------|----------------|
| 00 | `00_company_mini_schema.sql` | CREATE TABLE, PK, FK, örnek veri |
| 01 | `01_ddl_ve_constraint_denemeleri.sql` | INSERT hataları, CASCADE (blok blok) |
| 02 | `02_select_join_adim_adim.sql` | SELECT, JOIN, GROUP BY, alt sorgu |
| 03 | `03_lab6_university.sql` | Lab5+Lab6 mini şema |

```bash
mysql -u root -p < 00_company_mini_schema.sql
mysql -u root -p company_ogrenme < 02_select_join_adim_adim.sql
```

Üst klasör rehberi: [sql/README.md](../README.md)
