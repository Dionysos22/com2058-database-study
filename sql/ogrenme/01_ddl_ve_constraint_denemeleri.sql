-- Her blogu TEK TEK calistir; hata mesajini oku (sinavda ayni mantik)
USE company_ogrenme;

-- ========== BASARILI INSERT ==========
INSERT INTO PROJECT VALUES (10, 'ProductA', 'Houston', 5);
SELECT * FROM PROJECT WHERE Pnumber = 10;

-- ========== REFERENTIAL INTEGRITY (FK yok) ==========
-- Beklenen: ERROR 1452 - Dnum=99 DEPARTMENT'ta yok
INSERT INTO PROJECT VALUES (11, 'BadDept', 'X', 99);

-- ========== ENTITY INTEGRITY (PK NULL) ==========
-- Beklenen: ERROR - PK NULL
INSERT INTO EMPLOYEE (Ssn, Fname, Lname, Salary) VALUES (NULL, 'A', 'B', 1000);

-- ========== CHECK ihlali ==========
-- Beklenen: CHECK constraint failed (Salary > 0)
INSERT INTO EMPLOYEE VALUES ('000000001', 'Neg', 'Salary', -100, 5, NULL);

-- ========== UNIQUE ihlali ==========
-- Beklenen: Duplicate entry for key 'Dname'
INSERT INTO DEPARTMENT VALUES (99, 'Research', NULL, NULL);

-- ========== ON DELETE CASCADE (WORKS_ON) ==========
-- Once kayit say
SELECT COUNT(*) AS works_on_before FROM WORKS_ON WHERE Essn = '123456789';
DELETE FROM EMPLOYEE WHERE Ssn = '123456789';
SELECT COUNT(*) AS works_on_after FROM WORKS_ON WHERE Essn = '123456789';

-- ========== ON DELETE SET DEFAULT (PROJECT.Dnum) ==========
-- Dikkat: MySQL'de SET DEFAULT icin DEFAULT tanimli olmali (bizde Dnum DEFAULT 1)
DELETE FROM DEPARTMENT WHERE Dnumber = 5;
SELECT Pnumber, Pname, Dnum FROM PROJECT;

-- ========== ON DELETE CASCADE (DEPT_LOCATIONS) ==========
-- Department 1 silinirse lokasyonlar da silinir (once dept 1'i geri ekle gerekirse 00'i tekrar calistir)
