-- Lab5 + Lab6 bir arada - kucuk universite + siparis semasi
DROP DATABASE IF EXISTS lab_ogrenme;
CREATE DATABASE lab_ogrenme;
USE lab_ogrenme;

-- ----- LAB5 University -----
CREATE TABLE student (
  snum   INT PRIMARY KEY,
  sname  VARCHAR(30),
  major  VARCHAR(20),
  level  VARCHAR(5),
  age    INT
);

CREATE TABLE faculty (
  fid    INT PRIMARY KEY,
  fname  VARCHAR(30),
  deptid INT
);

CREATE TABLE class (
  name    VARCHAR(20),
  meetsat VARCHAR(20),
  room    VARCHAR(10),
  fid     INT,
  PRIMARY KEY (name, meetsat),
  FOREIGN KEY (fid) REFERENCES faculty(fid)
);

CREATE TABLE enrolled (
  snum  INT,
  cname VARCHAR(20),
  PRIMARY KEY (snum, cname),
  FOREIGN KEY (snum) REFERENCES student(snum)
);

INSERT INTO student VALUES (1001, 'Ali', 'History', 'Jr', 20);
INSERT INTO student VALUES (1002, 'Ayse', 'CS', 'Sr', 22);
INSERT INTO faculty VALUES (1, 'Dr. Brown', 10);
INSERT INTO class VALUES ('ENG205', 'MWF10', 'A101', 1);
INSERT INTO enrolled VALUES (1001, 'ENG205');

SELECT s.sname, e.cname
FROM student s
JOIN enrolled e ON s.snum = e.snum;

-- ----- LAB6 Orders -----
CREATE TABLE CUSTOMER (
  NAME CHAR(50) PRIMARY KEY,
  ADDRESS CHAR(50)
);

CREATE TABLE PART (
  PARTNUM INT PRIMARY KEY,
  DESCRIPTION CHAR(50),
  PRICE DOUBLE
);

CREATE TABLE ORDERS (
  ORDEREDON DATE,
  NAME CHAR(50),
  PARTNUM INT,
  QUANTITY INT,
  PRIMARY KEY (ORDEREDON, NAME, PARTNUM),
  FOREIGN KEY (NAME) REFERENCES CUSTOMER(NAME),
  FOREIGN KEY (PARTNUM) REFERENCES PART(PARTNUM)
);

INSERT INTO CUSTOMER VALUES ('TRUE WHEEL', '550 HUSKER');
INSERT INTO PART VALUES (23, 'MOUNTAIN BIKE', 350.45);
INSERT INTO ORDERS VALUES ('1996-05-15', 'TRUE WHEEL', 23, 6);

SELECT SUM(O.QUANTITY * P.PRICE) AS total_revenue
FROM ORDERS O
JOIN PART P ON O.PARTNUM = P.PARTNUM;
