# GitHub’a senin adınla push rehberi

Commit’ler **senin bilgisayarında** yapıldığında GitHub’da **sen** görünürsün. Önemli olan: `git config` ve `gh auth` senin hesabınla olmalı.

---

## 0) Önce kontrol et (kimlik)

```bash
git config --global user.name
git config --global user.email
```

GitHub’daki isim ve **doğrulanmış e-posta** ile aynı olsun. Değiştirmek için:

```bash
git config --global user.name "Sarp Mataş"
git config --global user.email "GITHUB_HESABINDAKI_EMAIL@..."
```

---

## Seçenek A — Sadece çalışma paketi (önerilen)

Küçük repo: notlar + SQL. (~birkaç MB)

### 1) GitHub’da boş repo oluştur

**Web:** https://github.com/new  
- Repository name: `com2058-database-study` (istediğin isim)  
- Public veya Private  
- **README, .gitignore, license ekleme** (boş repo)

**veya terminal (GitHub CLI):**

```bash
brew install gh    # yoksa
gh auth login      # senin hesabınla giriş
gh repo create com2058-database-study --public --source=. --remote=origin --push
# (aşağıdaki init/commit’ten SONRA bu komutu kullan)
```

### 2) Bu klasörde git başlat

```bash
cd "/Users/sarp/Desktop/üni/Database/COM2058_Calisma_Paketi"

git init
git add .
git status
git commit -m "COM2058 çalışma paketi: notlar, SQL örnekleri, kod rehberi"
```

### 3) Remote ekle ve push

`KULLANICI` = GitHub kullanıcı adın (ör. `sarp-matas`)

```bash
git branch -M main
git remote add origin https://github.com/KULLANICI/com2058-database-study.git
git push -u origin main
```

SSH kullanıyorsan:

```bash
git remote add origin git@github.com:KULLANICI/com2058-database-study.git
git push -u origin main
```

İlk push’ta tarayıcı veya token isteyebilir → **senin** GitHub hesabınla onayla.

---

## Seçenek B — Tüm `Database` klasörü

Dikkat: klasör çok büyük (~800MB). `.venv`, zip, büyük PDF’ler **push edilmemeli**.

`Database` kökünde `.gitignore` oluştur (aşağıdaki gibi), sonra:

```bash
cd "/Users/sarp/Desktop/üni/Database"
git init
# .gitignore ekle (rehberdeki örnek)
git add COM2058_Calisma_Paketi/
git add Project/UPLOAD_READY/   # isteğe bağlı, dikkatli
git commit -m "Database ders materyalleri"
```

**Not:** `Project/UPLOAD_READY` zaten başka bir remote’a bağlı (`f1-website`). Karışmasın diye ya sadece çalışma paketini (Seçenek A) push et, ya da F1 projesini ayrı repo olarak bırak.

---

## F1 projesi (zaten git var)

```bash
cd "/Users/sarp/Desktop/üni/Database/Project/UPLOAD_READY"
git remote -v
# origin → github.com/Dionysos22/f1-website
```

Buraya push için **o repoya yazma yetkin** olmalı. Kendi fork’un:

```bash
gh repo fork Dionysos22/f1-website --clone=false
git remote add myfork git@github.com:SENIN_KULLANICI/f1-website.git
git push myfork main
```

---

## Sık sorunlar

| Sorun | Çözüm |
|--------|--------|
| `Permission denied` | SSH key ekle veya HTTPS + Personal Access Token |
| Yanlış isim commit’te | `git config user.name/email` düzelt; yeni commit’ler düzelir |
| `rejected (fetch first)` | `git pull --rebase origin main` sonra `git push` |
| Çok büyük dosya | `.gitignore`’a `.venv/`, `*.zip` ekle; commit’ten çıkar |

---

## Paylaşım linki

Push sonrası: `https://github.com/KULLANICI/com2058-database-study`

README otomatik görünür; arkadaşların **Clone** → `git clone ...` ile indirir.
