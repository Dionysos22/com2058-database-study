# COM2058 — Tüm Çalışma Dosyaları (tek klasör)

Bu klasörde ders notları, kod ile öğrenme rehberi, sınav hazırlığı ve çalıştırılabilir SQL/Python dosyalarının **tamamı** bir arada.

## Başlangıç

| Dosya | Ne için? |
|-------|----------|
| [**DATABASE_TAM_CALISMA_DOKUMANI.md**](DATABASE_TAM_CALISMA_DOKUMANI.md) | Teori A→Z (Ch1–21, lab, proje, sınav) |
| [**DATABASE_KOD_ILE_OGRENME.md**](DATABASE_KOD_ILE_OGRENME.md) | Uygulamalı SQL + Python + F1 |
| [00_CALISMA_PLANI.md](00_CALISMA_PLANI.md) | 7 günlük plan |

## Konu özetleri (sınav)

| Dosya | İçerik |
|-------|--------|
| [01_OZET_NOTLAR.md](01_OZET_NOTLAR.md) | Bölüm özetleri |
| [02_SQL_KILAVUZU.md](02_SQL_KILAVUZU.md) | SQL + çıkmış sorgular |
| [03_ER_EER_OZET.md](03_ER_EER_OZET.md) | ER / EER / mapping |
| [04_NORMALIZASYON.md](04_NORMALIZASYON.md) | FD, 1NF–BCNF |
| [05_RELATIONAL_ALGEBRA.md](05_RELATIONAL_ALGEBRA.md) | İlişkisel cebir |
| [06_CIKMIS_SORULAR_COZUM.md](06_CIKMIS_SORULAR_COZUM.md) | Model çözümler |
| [07_LAB_OZETLERI.md](07_LAB_OZETLERI.md) | Lab1–8 |
| [08_PROJE_F1_OZET.md](08_PROJE_F1_OZET.md) | F1 projesi özeti |
| [09_SINAV_ONCESI_KONTROL.md](09_SINAV_ONCESI_KONTROL.md) | Son kontrol listesi |
| [KAYNAK_HARITASI.md](KAYNAK_HARITASI.md) | Orijinal PDF/slayt yolları |

## SQL (çalıştırılabilir)

```
sql/
  ogrenme/          ← Adım adım öğrenme (önce bunlar)
    00_company_mini_schema.sql
    01_ddl_ve_constraint_denemeleri.sql
    02_select_join_adim_adim.sql
    03_lab6_university.sql
  company_ornek_sorgular.sql
  lab5_university.sql
  lab6_ornek.sql
  f1_ornek_sorgular.sql
```

```bash
cd sql/ogrenme
mysql -u root -p < 00_company_mini_schema.sql
mysql -u root -p company_ogrenme < 02_select_join_adim_adim.sql
```

## Python

```
scripts/ogrenme_python_mysql.py   ← F1 veritabanına bağlanıp örnek sorgular
```

```bash
cd ../Project/UPLOAD_READY   # docker compose up -d önce
python ../COM2058_Calisma_Paketi/scripts/ogrenme_python_mysql.py
```

## Dış kaynaklar (üst klasör: Database/)

- Slaytlar: `../Elmasri_6e_Ch*.pptx`
- Çıkmış: `../ÇIKMIŞ/`
- Proje: `../Project/UPLOAD_READY/`

## GitHub’a yükleme (senin hesabınla)

Adım adım terminal komutları: [**PUSH_GITHUB.md**](PUSH_GITHUB.md)

## Önerilen sıra

1. `DATABASE_TAM_CALISMA_DOKUMANI.md` (okuma)
2. `sql/ogrenme/` (MySQL pratik)
3. `DATABASE_KOD_ILE_OGRENME.md` (kod modülleri)
4. `06_CIKMIS_SORULAR_COZUM.md` (deneme)
5. `09_SINAV_ONCESI_KONTROL.md`
