-- LAB5 - University schema (Lab5comblm258)
-- Kaynak: ../LAB_eski/LAB5/2058Lab5.sql

USE Lab5comblm258;

-- Tum ogrenciler
SELECT * FROM student;

-- History bolumu
SELECT sname, level FROM student WHERE major = 'History';

-- ENG205'e kayitli ogrenciler
SELECT s.sname, s.major
FROM student s
JOIN enrolled e ON s.snum = e.snum
WHERE e.cname = 'ENG205';

-- Faculty basina kac ders
SELECT f.fname, COUNT(*) AS ders_sayisi
FROM faculty f
JOIN class c ON f.fid = c.fid
GROUP BY f.fid, f.fname;

-- Bir ogrencinin tum dersleri
SELECT e.cname, c.meetsat, c.room
FROM enrolled e
JOIN class c ON e.cname = c.name
WHERE e.snum = 1234;

-- Ayni odada gecen dersler (self-join class)
SELECT c1.name AS ders1, c2.name AS ders2, c1.room
FROM class c1
JOIN class c2 ON c1.room = c2.room AND c1.name < c2.name;
