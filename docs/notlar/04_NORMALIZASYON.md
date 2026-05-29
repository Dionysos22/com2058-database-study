# Normalizasyon ve Functional Dependencies

## Anomaliler

| Anomali | Sebep | Örnek |
|---------|--------|--------|
| Insert | Eksik bilgiyle ekleyememe | Proje yokken çalışan saat |
| Delete | Silince başka bilgi kaybı | Son WORKS_ON silinince proje bilgisi |
| Update | Tek bilgi birden fazla yerde | Departman adı her satırda |

---

## Functional Dependency (FD)

- **X → Y:** Aynı X değerleri için Y aynı olmalı.
- **Trivial:** Y ⊆ X
- **Non-trivial:** Y ⊄ X

### Armstrong aksiyomları
- **Reflexivity:** Y ⊆ X ⇒ X → Y
- **Augmentation:** X → Y ⇒ XZ → YZ
- **Transitivity:** X → Y, Y → Z ⇒ X → Z

**Closure F⁺:** F’ten türetilebilen tüm FD’ler.

---

## Normal formlar (pratik tanım)

### 1NF
- Her hücre **atomik** (tek değer).
- Tekrarlayan gruplar ayrı satır/tablo.

### 2NF
- 1NF +
- Composite PK varsa: her non-key attribute **tüm PK’ya** bağımlı (partial dependency yok).

Örnek: `(Ssn, Pno) → Hours` OK; `(Ssn, Pno) → Ename` **2NF ihlali** (sadece Ssn → Ename).

### 3NF
- 2NF +
- Non-key attribute’lar birbirine **transitive** bağımlı değil.
- Yani: X → A, A → B ve A candidate key değilse sorun.

### BCNF
- Her **non-trivial** FD X → Y için **X candidate key**.
- 3NF’den daha sıkı; bazen dependency preservation kaybı.

---

## F1 projesi – normalizasyon cevabı (rapor özeti)

| Form | F1 şemasında |
|------|----------------|
| 1NF | Atomik alanlar; çoklu pilot listesi yok → `team_drivers` |
| 2NF | Composite key’lerde partial yok |
| 3NF | Team metadata `team_id`’ye bağlı |
| BCNF | UK’ler (team_name, driver_code) determinant |

**Bilinçli denormalizasyon:** `drivers.num_poles` vb. derived ama performans için saklanıyor.

---

## Spurious tuple (Guideline 4)

Yanlış join attribute’ları → fazla satır.  
Çözüm: Sadece **FK = PK** eşleşmesiyle join.

---

## Sınav sorusu tipi

1. Verilen tablo + FD listesi → hangi normal form?
2. 3NF’e ayırma (decomposition)
3. Anomali örneği yaz ve hangi NF ile çözülür açıkla

### Örnek FD seti (COMPANY)

- `Ssn → Fname, Lname, Salary, Dno, …`
- `Dnumber → Dname, Mgr_ssn`
- `(Essn, Pno) → Hours`
- `Pnumber → Pname, Plocation, Dnum`

**WORKS_ON** tek başına BCNF’a yakın; **EMP_DEPT_LOC** birleşik tabloda anomaly üretir (slayt Fig 15.5).

---

## 4NF / 5NF (kısa)

- **4NF:** Multivalued dependency X →→ Y (X’e göre Y’nin bağımsız çoklu değerleri)
- **5NF:** Join dependency — tablo anlamlı parçalara ayrılamaz

Finalde nadiren detay; 3NF/BCNF yeterli olur.
