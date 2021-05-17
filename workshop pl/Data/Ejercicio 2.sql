--
-- 
--AUTHOR: JOHAN SEBASTIAN FUENTES ORTEGA
--DATE: 24/04/2021
--

-- ----------------------------------------------------------
/*RALIZAR PAGOS CON PL/SQL*/
CREATE OR REPLACE FUNCTION get_rango
    (id salgrade.grade%TYPE) RETURN NUMBER IS
    grado salgrade.hisal%TYPE := 0;
BEGIN
    SELECT hisal INTO grado FROM salgrade WHERE grade=id;
    RETURN grado;
END get_rango;
/

DECLARE
    GradoSalarial salgrade.hisal%TYPE;
    CURSOR pagos IS SELECT empno,ename,sal,comm FROM emp;
BEGIN
    GradoSalarial := get_rango(3);
    FOR agarrar IN pagos LOOP
        INSERT INTO payment VALUES(agarrar.empno,
                                   sysdate,
                                   agarrar.sal,
                                   agarrar.comm);
        IF agarrar.sal > gradosalarial THEN
            INSERT INTO logemp 
                VALUES(sysdate,'Se realizó el pago al señor '|| agarrar.ename || ' con grado salarial igual o superior 4');
        END IF;
    END LOOP;
EXCEPTION
  WHEN Others THEN
    Dbms_Output.put_line(SQLCODE || ' - ' || SQLERRM);
END;
-- ---------------------------------------------------------