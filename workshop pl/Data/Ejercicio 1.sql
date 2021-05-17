--
-- 
--AUTHOR: JOHAN SEBASTIAN FUENTES ORTEGA
--DATE: 24/04/2021
--
-- ----------------------------------------------------------
/*REALIZAMOS PAGO CON INSERT Y SELECT*/
INSERT INTO payment SELECT empno, sysdate, sal, comm FROM emp;
-- ----------------------------------------------------------
/*RALIZAR PAGOS CON PL/SQL*/
DECLARE
    CURSOR pagos IS SELECT empno,sal,comm FROM emp;
BEGIN
    FOR agarrar IN pagos LOOP
        INSERT INTO payment VALUES(agarrar.empno,
                                   sysdate,
                                   agarrar.sal,
                                   agarrar.comm);
    END LOOP;
EXCEPTION
  WHEN Others THEN
    Dbms_Output.put_line(SQLCODE || ' - ' || SQLERRM);
END;
-- ---------------------------------------------------------