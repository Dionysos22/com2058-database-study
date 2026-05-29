# Formula 1 Projesi – Sınav İçin Özet

SQL: [`sql/f1_schema.sql`](../../sql/f1_schema.sql), [`sql/f1_ornek_sorgular.sql`](../../sql/f1_ornek_sorgular.sql)

---

## Mini-world (1 paragraf)

F1 şampiyonası: **seasons**, **teams**, **drivers**, **circuits**, **races** (weak), **team_drivers** (ternary contracts), **team_standings**, **race_results**.

---

## Tablolar ve PK

| Tablo | Primary Key |
|-------|-------------|
| seasons | season_year |
| teams | team_id |
| drivers | driver_id |
| circuits | circuit_id |
| races | (season_year, round_number) |
| team_drivers | (season_year, team_id, driver_id) |
| team_standings | (season_year, team_id) |
| race_results | (season_year, round_number, driver_id) |

---

## İş kuralları (sınavda yazılabilir)

1. `season_year >= 1950`
2. `team_name`, `driver_code`, `circuit_name` UNIQUE
3. RACE weak → `season_year` FK + `round_number` partial key
4. `role = MAIN` ⇒ `seat_no IN (1,2)`; `RESERVE` ⇒ `seat_no IS NULL`
5. `race_start_date <= race_end_date`
6. `num_poles`, `num_podiums`, `num_championships` derived (stored)

---

## ER ilişkileri

| İlişki | Kardinalite | SQL |
|--------|-------------|-----|
| HAS_RACE | 1:N | races.season_year |
| HOSTS | 1:N | races.circuit_id |
| CONTRACTS | M:N:P | team_drivers |
| STANDINGS | M:N | team_standings |
| RESULTS | M:N | race_results |

---

## Örnek sınav sorusu: “2024 sezonu yarışlarını kronolojik listele”

```sql
SELECT r.round_number, r.grand_prix_name, c.circuit_name, r.race_start_date
FROM races r
JOIN circuits c ON c.circuit_id = r.circuit_id
WHERE r.season_year = 2024
ORDER BY r.race_start_date, r.round_number;
```

---

## Örnek: Constructors standings (aggregate + window)

```sql
SELECT t.team_name,
       DENSE_RANK() OVER (ORDER BY SUM(rr.points) DESC) AS season_position,
       SUM(rr.points) AS season_points
FROM race_results rr
JOIN team_drivers td ON td.season_year = rr.season_year
  AND td.driver_id = rr.driver_id AND td.role = 'MAIN'
JOIN teams t ON t.team_id = td.team_id
WHERE rr.season_year = 2024
GROUP BY t.team_id, t.team_name
ORDER BY season_position;
```

Daha fazla: [`sql/f1_ornek_sorgular.sql`](../../sql/f1_ornek_sorgular.sql) (12 sorgu)

---

## Normalizasyon (rapor cevabı kısa)

- **1NF:** Atomik; tekrarlayan grup yok
- **2NF:** Composite key’lerde partial dependency yok
- **3NF:** Transitive yok (team alanları team_id’ye bağlı)
- **BCNF:** UK’ler candidate key
- **İstisna:** Driver career counters bilinçli denormalize

---

## Proje ↔ ders eşlemesi

| Proje fazı | Ders bölümü |
|------------|-------------|
| Phase 1 requirements | Ch7 mini-world |
| Phase 2 ERD Chen | Ch7–8 |
| Phase 3 SQL | Ch4–5 |
| Phase 4 report normalization | Ch15 |

Hocanın COMPANY örneği ile **aynı anlatım stili** — finalde F1 veya COMPANY benzeri tasarım sorusu gelebilir.
