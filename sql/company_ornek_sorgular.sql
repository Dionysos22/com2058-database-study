-- COM2058 Final Hazirlik - COMPANY schema ornek sorgulari
-- CompanySchema.pdf ile birlikte calis
-- Not: Tablolarin mevcut oldugunu varsay (university veya company dump)

-- 1) Maasi 30000'den fazla calisanlarin soyadi
SELECT Lname FROM EMPLOYEE WHERE Salary > 30000;

-- 2) Departman basina calisan sayisi
SELECT D.Dname, COUNT(E.Ssn) AS cnt
FROM DEPARTMENT D
JOIN EMPLOYEE E ON E.Dno = D.Dnumber
GROUP BY D.Dnumber, D.Dname;

-- 3) Ortalama maasi 30000'den yuksek departmanlar
SELECT D.Dname, COUNT(*) AS num_emp
FROM DEPARTMENT D
JOIN EMPLOYEE E ON E.Dno = D.Dnumber
GROUP BY D.Dnumber, D.Dname
HAVING AVG(E.Salary) > 30000;

-- 4) En yuksek maasli calisanin departmanindaki herkes
SELECT E.Fname, E.Lname
FROM EMPLOYEE E
WHERE E.Dno = (
  SELECT Dno FROM EMPLOYEE
  WHERE Salary = (SELECT MAX(Salary) FROM EMPLOYEE)
);

-- 5) Proje basina calisan sayisi
SELECT P.Pnumber, P.Pname, COUNT(W.Essn) AS workers
FROM PROJECT P
LEFT JOIN WORKS_ON W ON P.Pnumber = W.Pno
GROUP BY P.Pnumber, P.Pname;

-- 6) Hic calisani olmayan projeler
SELECT P.Pname
FROM PROJECT P
WHERE NOT EXISTS (
  SELECT 1 FROM WORKS_ON W WHERE W.Pno = P.Pnumber
);

-- 7) En dusuk maastan 10000 fazla alanlar
SELECT Fname, Lname, Salary
FROM EMPLOYEE
WHERE Salary >= (SELECT MIN(Salary) FROM EMPLOYEE) + 10000;

-- 8) Stafford lokasyonlu projelerde calisanlarin ortalama maasi
SELECT AVG(E.Salary) AS avg_sal
FROM EMPLOYEE E
JOIN WORKS_ON W ON E.Ssn = W.Essn
JOIN PROJECT P ON W.Pno = P.Pnumber
WHERE P.Plocation = 'Stafford';

-- 9) Departman mudurunun toplam proje saati
SELECT D.Dname, SUM(W.Hours) AS mgr_hours
FROM DEPARTMENT D
JOIN WORKS_ON W ON D.Mgr_ssn = W.Essn
GROUP BY D.Dnumber, D.Dname;

-- 10) Calisan + departman adi (join)
SELECT E.Fname, E.Lname, D.Dname
FROM EMPLOYEE E
JOIN DEPARTMENT D ON E.Dno = D.Dnumber;
