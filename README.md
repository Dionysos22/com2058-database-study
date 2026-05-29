# COM2058 Veritabanı Sistemleri — Çalışma Paketi

Elmasri & Navathe (6. baskı) için **teori**, **SQL pratiği**, **çıkmış çözümleri** ve **F1 şema örnekleri** — tek repoda.

---

## Hızlı başlangıç

**Gereksinim:** [MySQL 8+](https://dev.mysql.com/downloads/mysql/) (veya 5.7)

```bash
git clone <bu-repo-url>
cd com2058-database-study

cd sql/ogrenme
mysql -u root -p < 00_company_mini_schema.sql
mysql -u root -p company_ogrenme < 02_select_join_adim_adim.sql
```

**Okuma sırası:** [BASLA_BURADAN.md](BASLA_BURADAN.md) → [docs/INDEX.md](docs/INDEX.md)

---

## Repo içeriği

```
├── README.md
├── BASLA_BURADAN.md          # İlk gün rehberi
├── docs/
│   ├── INDEX.md
│   ├── rehber/               # Tam teori + kod ile öğrenme
│   └── notlar/               # Özetler, plan, çıkmış (00–09)
└── sql/
    ├── ogrenme/              # Sıfırdan (00 → 03)
    ├── company_ornek_sorgular.sql
    ├── lab5_university.sql
    ├── lab6_ornek.sql
    ├── f1_schema.sql         # F1 tabloları
    ├── f1_demo_seed.sql      # Küçük örnek veri
    └── f1_ornek_sorgular.sql
```

---

## Öğrenme yolları

| Hedef | Nereden? |
|--------|----------|
| Sıfırdan | [BASLA_BURADAN](BASLA_BURADAN.md) → `sql/ogrenme/` |
| Teori | [Tam rehber](docs/rehber/DATABASE_TAM_CALISMA_DOKUMANI.md) |
| SQL + terminal | [Kod ile öğrenme](docs/rehber/DATABASE_KOD_ILE_OGRENME.md) |
| Sınav | [7 gün plan](docs/notlar/00_CALISMA_PLANI.md) → [Çıkmış](docs/notlar/06_CIKMIS_SORULAR_COZUM.md) |
| F1 şeması | [F1 özeti](docs/notlar/08_PROJE_F1_OZET.md) + `sql/f1_*.sql` |

---

## F1 sorgularını çalıştırma

```bash
cd sql
mysql -u root -p < f1_schema.sql
mysql -u root -p formula_1 < f1_demo_seed.sql
mysql -u root -p formula_1 < f1_ornek_sorgular.sql
```

---

## Gereksinimler

| Araç | Zorunlu |
|------|---------|
| MySQL | Evet |
| Python / Docker | Hayır |

---

## Lisans

[MIT](LICENSE) — eğitim amaçlı paylaşım serbest.

**Not:** Resmi ders slayt ve çıkmış PDF’leri bu repoda yok; kaynak kitap: Elmasri 6e. İçerik özeti [KAYNAK_HARITASI](docs/notlar/KAYNAK_HARITASI.md).
