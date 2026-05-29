# İlişkisel Cebir – Sınav Özeti

## Unary

### SELECT (σ)
```
σ_condition(R)
```
Örnek: `σ_{Dno=5}(EMPLOYEE)`

### PROJECT (π)
```
π_{Fname,Lname}(EMPLOYEE)
```
Duplicate elenir.

### RENAME (ρ)
```
ρ_{E}(Ssn→Emp_ssn)(EMPLOYEE)
```

---

## Set operations

R ve S **union-compatible** (aynı degree, uyumlu domain).

| Op | Sembol |
|----|--------|
| Union | R ∪ S |
| Intersection | R ∩ S |
| Difference | R − S |
| Cartesian product | R × S |

---

## JOIN

### Theta join
```
R ⋈_{AθB} S
```

### Equi-join / Natural join
Eşit kolonlar üzerinden; natural join ortak isimleri birleştirir.

### Outer join (cebirde konsept)
Eşleşmeyen satırlar NULL padding — SQL’de LEFT/RIGHT/FULL.

---

## DIVISION (÷)

**“For all”** sorguları:

> Hangi `Ssn` değerleri **tüm** `Pno ∈ P1` projelerinde çalışıyor?

```
π_{Ssn, Pno}(WORKS_ON) ÷ π_{Pno}(σ_{...}(PROJECT))
```

Adımlar:
1. `T = π_{Ssn,Pno}(WORKS_ON)`
2. `D = π_{Pno}(hedef projeler)`
3. `T ÷ D` → istenen Ssn’ler

---

## COMPANY – cebir ↔ SQL

**Maaşı > 30000 çalışanların soyadı:**

```
π_{Lname}(σ_{Salary>30000}(EMPLOYEE))
```

**Departman 5’te çalışanlar:**

```
π_{Fname,Lname}(σ_{Dno=5}(EMPLOYEE))
```

**Çalışan + departman adı:**

```
π_{Fname,Lname,Dname}(EMPLOYEE ⋈_{Dno=Dnumber} DEPARTMENT)
```

---

## Tuple Relational Calculus (TRC)

```
{ t | t ∈ EMPLOYEE ∧ t.Salary > 30000 }
```

- **∃** “var”, **∀** “hepsi”
- Domain calculus: değişkenler attribute domain’inden

Sınavda bazen “TRC ile yaz” denir — SQL’e çok benzer mantık.

---

## Pipeline (sınavda adım adım yaz)

Örnek: Stafford’da çalışan proje saatleri ortalaması

1. `σ_{Plocation='Stafford'}(PROJECT)` → P'
2. `WORKS_ON ⋈_{Pno=Pnumber} P'` → W'
3. `EMPLOYEE ⋈_{Ssn=Essn} W'` → E'
4. `π_{...}(E')` veya aggregate SQL’de

---

## Sık hatalar

- PROJECT sonrası gerekli join key’i silmek
- × sonra θ unutmak → kartezyen patlar
- DIVISION’da bölen kümenin doğru seçilmemesi
