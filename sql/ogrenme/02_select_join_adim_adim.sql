-- SELECT / JOIN ogrenme - her sorguyu calistir, sonucu yorumla
USE company_ogrenme;

-- ADIM 1: Tek tablo + WHERE
SELECT Ssn, Fname, Lname, Salary
FROM EMPLOYEE
WHERE Salary > 26000;

-- ADIM 2: Eski stil JOIN (WHERE ile)
SELECT E.Fname, E.Lname, D.Dname
FROM EMPLOYEE E, DEPARTMENT D
WHERE E.Dno = D.Dnumber;

-- ADIM 3: ANSI INNER JOIN (tercih edilen)
SELECT E.Fname, E.Lname, D.Dname
FROM EMPLOYEE E
INNER JOIN DEPARTMENT D ON E.Dno = D.Dnumber;

-- ADIM 4: LEFT JOIN - calisani olmayan proje de gelsin
SELECT P.Pname, W.Essn, W.Hours
FROM PROJECT P
LEFT JOIN WORKS_ON W ON P.Pnumber = W.Pno;

-- ADIM 5: Hic calisani olmayan proje
SELECT P.Pname
FROM PROJECT P
LEFT JOIN WORKS_ON W ON P.Pnumber = W.Pno
WHERE W.Essn IS NULL;

-- ADIM 6: GROUP BY
SELECT D.Dname, COUNT(E.Ssn) AS emp_count, AVG(E.Salary) AS avg_sal
FROM DEPARTMENT D
LEFT JOIN EMPLOYEE E ON D.Dnumber = E.Dno
GROUP BY D.Dnumber, D.Dname;

-- ADIM 7: HAVING (grup filtresi)
SELECT D.Dname, AVG(E.Salary) AS avg_sal
FROM DEPARTMENT D
JOIN EMPLOYEE E ON D.Dnumber = E.Dno
GROUP BY D.Dnumber, D.Dname
HAVING AVG(E.Salary) > 27000;

-- ADIM 8: Alt sorgu - en yuksek maas
SELECT MAX(Salary) AS max_sal FROM EMPLOYEE;

-- ADIM 9: Alt sorgu ile filtre
SELECT Fname, Lname, Salary
FROM EMPLOYEE
WHERE Salary = (SELECT MAX(Salary) FROM EMPLOYEE);

-- ADIM 10: IN ile departman
SELECT Fname, Lname
FROM EMPLOYEE
WHERE Dno IN (SELECT Dnumber FROM DEPARTMENT WHERE Dname = 'Research');

-- ADIM 11: EXISTS
SELECT P.Pname
FROM PROJECT P
WHERE EXISTS (
  SELECT 1 FROM WORKS_ON W WHERE W.Pno = P.Pnumber
);

-- ADIM 12: Correlated subquery - kendi departmaninin ortalamasindan fazla alanlar
SELECT E1.Fname, E1.Lname, E1.Salary, E1.Dno
FROM EMPLOYEE E1
WHERE E1.Salary > (
  SELECT AVG(E2.Salary) FROM EMPLOYEE E2 WHERE E2.Dno = E1.Dno
);

-- ADIM 13: Self-join - amir calisan
SELECT E.Fname AS calisan, M.Fname AS amir
FROM EMPLOYEE E
LEFT JOIN EMPLOYEE M ON E.Super_ssn = M.Ssn;
