--
-- 
--JOHAN SEBASTIAN FUENTES ORTEGA
--DATE: 24/04/2021
--

-- ----------------------------------------------------------
/*LIQUIDAR LOS PAGOS*/
CREATE OR REPLACE PROCEDURE pLiquNomi (finFechLiqu DATE DEFAULT SYSDATE)
IS
  CURSOR cu_emp
  IS
    SELECT *
    FROM   emp;

  rango NUMBER;

BEGIN
  FOR recu_emp IN cu_emp LOOP
    INSERT INTO payment
    VALUES (recu_emp.empno, finFechLiqu, recu_emp.sal, recu_emp.comm);

    SELECT sg.grade INTO rango
    FROM   salgrade sg
    WHERE  recu_emp.sal >= sg.losal AND recu_emp.sal <= sg.hisal;

    IF rango >= 4 THEN
      INSERT INTO logemp
      VALUES (sysdate, 'Empleado : ' || recu_emp.ename || ' con salario mayor en grango :' || rango || ' liquidador por : ' || USER);

    END IF;
  END LOOP;

EXCEPTION
  WHEN Others THEN
    Dbms_Output.put_line(SQLCODE || ' - ' || SQLERRM);
END pLiquNomi;

/
EXECUTE pliqunomi;