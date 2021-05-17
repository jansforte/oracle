--
-- Copyright (c) Oracle Corporation 1999. All Rights Reserved.
--
-- NAME
-- demobld.sql
--
-- DESCRIPTION
-- This script creates the SQL*Plus demonstration tables in the
-- current schema. It should be STARTed by each user wishing to
-- access the tables. To remove the tables use the demodrop.sql
-- script.
--
-- USAGE
-- SQL> START demobld.sql
--
--
SET TERMOUT ON
PROMPT Building demonstration tables. Please wait.
--SET TERMOUT OFF

DROP TABLE EMP CASCADE CONSTRAINTS;
DROP TABLE DEPT CASCADE CONSTRAINTS;
DROP TABLE PAYMENT CASCADE CONSTRAINTS;
DROP TABLE SALGRADE CASCADE CONSTRAINTS;
DROP TABLE DUMMY CASCADE CONSTRAINTS;
DROP TABLE LOGEMP CASCADE CONSTRAINTS;
DROP TABLE AUDITEMP CASCADE CONSTRAINTS;


CREATE TABLE EMP
(EMPNO NUMBER(4) NOT NULL,
ENAME VARCHAR2(10),
JOB VARCHAR2(9),
MGR NUMBER(4),
HIREDATE DATE,
SAL NUMBER(7, 2),
COMM NUMBER(7, 2),
DEPTNO NUMBER(2));

INSERT INTO EMP VALUES
(7369, 'SMITH', 'CLERK', 7902,
TO_DATE('17-DEC-1980', 'DD-MON-YYYY'), 800, NULL, 20);
INSERT INTO EMP VALUES
(7499, 'ALLEN', 'SALESMAN', 7698,
TO_DATE('20-FEB-1981', 'DD-MON-YYYY'), 1600, 300, 30);
INSERT INTO EMP VALUES
(7521, 'WARD', 'SALESMAN', 7698,
TO_DATE('22-FEB-1981', 'DD-MON-YYYY'), 1250, 500, 30);
INSERT INTO EMP VALUES
(7566, 'JONES', 'MANAGER', 7839,
TO_DATE('2-APR-1981', 'DD-MON-YYYY'), 2975, NULL, 20);
INSERT INTO EMP VALUES
(7654, 'MARTIN', 'SALESMAN', 7698,
TO_DATE('28-SEP-1981', 'DD-MON-YYYY'), 1250, 1400, 30);
INSERT INTO EMP VALUES
(7698, 'BLAKE', 'MANAGER', 7839,
TO_DATE('1-MAY-1981', 'DD-MON-YYYY'), 2850, NULL, 30);
INSERT INTO EMP VALUES
(7782, 'CLARK', 'MANAGER', 7839,
TO_DATE('9-JUN-1981', 'DD-MON-YYYY'), 2450, NULL, 10);
INSERT INTO EMP VALUES
(7788, 'SCOTT', 'ANALYST', 7566,
TO_DATE('09-DEC-1982', 'DD-MON-YYYY'), 3000, NULL, 20);
INSERT INTO EMP VALUES
(7839, 'KING', 'PRESIDENT', NULL,
TO_DATE('17-NOV-1981', 'DD-MON-YYYY'), 5000, NULL, 10);
INSERT INTO EMP VALUES
(7844, 'TURNER', 'SALESMAN', 7698,
TO_DATE('8-SEP-1981', 'DD-MON-YYYY'), 1500, 0, 30);
INSERT INTO EMP VALUES
(7876, 'ADAMS', 'CLERK', 7788,
TO_DATE('12-JAN-1983', 'DD-MON-YYYY'), 1100, NULL, 20);
INSERT INTO EMP VALUES
(7900, 'JAMES', 'CLERK', 7698,
TO_DATE('3-DEC-1981', 'DD-MON-YYYY'), 950, NULL, 30);
INSERT INTO EMP VALUES
(7902, 'FORD', 'ANALYST', 7566,
TO_DATE('3-DEC-1981', 'DD-MON-YYYY'), 3000, NULL, 20);
INSERT INTO EMP VALUES
(7934, 'MILLER', 'CLERK', 7782,
TO_DATE('23-JAN-1982', 'DD-MON-YYYY'), 1300, NULL, 10);

CREATE TABLE DEPT
(DEPTNO NUMBER(2),
DNAME VARCHAR2(14),
LOC VARCHAR2(13) );

INSERT INTO DEPT VALUES (10, 'ACCOUNTING', 'NEW YORK');
INSERT INTO DEPT VALUES (20, 'RESEARCH', 'DALLAS');
INSERT INTO DEPT VALUES (30, 'SALES', 'CHICAGO');
INSERT INTO DEPT VALUES (40, 'OPERATIONS', 'BOSTON');

CREATE TABLE PAYMENT
(EMPNO NUMBER(4) NOT NULL,
PAYDATE DATE,
SAL NUMBER,
COMM NUMBER);

INSERT INTO PAYMENT VALUES
(7369, TO_DATE('30-04-2013', 'DD-MM-YYYY'), 800, NULL);
INSERT INTO PAYMENT VALUES
(7499, TO_DATE('30-04-2013', 'DD-MM-YYYY'), 1600, 300);
INSERT INTO PAYMENT VALUES
(7521, TO_DATE('30-04-2013', 'DD-MM-YYYY'), 1250, 500);
INSERT INTO PAYMENT VALUES
(7566, TO_DATE('30-04-2013', 'DD-MM-YYYY'), 2975, NULL);
INSERT INTO PAYMENT VALUES
(7654, TO_DATE('30-04-2013', 'DD-MM-YYYY'), 1250, 1400);
INSERT INTO PAYMENT VALUES
(7698, TO_DATE('30-04-2013', 'DD-MM-YYYY'), 2850, NULL);
INSERT INTO PAYMENT VALUES
(7782, TO_DATE('30-04-2013', 'DD-MM-YYYY'), 2450, NULL);
INSERT INTO PAYMENT VALUES
(7788, TO_DATE('30-04-2013', 'DD-MM-YYYY'), 3000, NULL);
INSERT INTO PAYMENT VALUES
(7839, TO_DATE('30-04-2013', 'DD-MM-YYYY'), 5000, NULL);
INSERT INTO PAYMENT VALUES
(7844, TO_DATE('30-04-2013', 'DD-MM-YYYY'), 1500, 0);
INSERT INTO PAYMENT VALUES
(7876, TO_DATE('30-04-2013', 'DD-MM-YYYY'), 1100, NULL);
INSERT INTO PAYMENT VALUES
(7900, TO_DATE('30-04-2013', 'DD-MM-YYYY'), 950, NULL);
INSERT INTO PAYMENT VALUES
(7902, TO_DATE('30-04-2013', 'DD-MM-YYYY'), 3000, NULL);
INSERT INTO PAYMENT VALUES
(7934, TO_DATE('30-04-2013', 'DD-MM-YYYY'), 1300, NULL);

CREATE TABLE SALGRADE
(GRADE NUMBER,
LOSAL NUMBER,
HISAL NUMBER);

INSERT INTO SALGRADE VALUES (1, 700, 1200);
INSERT INTO SALGRADE VALUES (2, 1201, 1400);
INSERT INTO SALGRADE VALUES (3, 1401, 2000);
INSERT INTO SALGRADE VALUES (4, 2001, 3000);
INSERT INTO SALGRADE VALUES (5, 3001, 9999);

CREATE TABLE DUMMY
(DUMMY NUMBER);

INSERT INTO DUMMY VALUES (0);

CREATE TABLE logemp (
  occdate DATE         NULL,
  msg     VARCHAR2(80) NULL
);

CREATE TABLE auditemp (
  changed_type  VARCHAR2(1) NOT NULL,
  changed_by    VARCHAR2(40) NOT NULL,
  datestamp     DATE         NOT NULL,
  empno         NUMBER(4,0)  NOT NULL,
  oldsal        NUMBER(7,2)  NULL,
  oldcomm       NUMBER(7,2)  NULL,
  newsal        NUMBER(7,2)  NULL,
  newcomm       NUMBER(7,2)  NULL
);


COMMIT;

SET TERMOUT ON
PROMPT Demonstration table build is complete.
