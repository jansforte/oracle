--
-- 
--JOHAN SEBASTIAN FUENTES ORTEGA
--DATE: 24/04/2021
--

-- ----------------------------------------------------------
/*Paquete de servicios – obtener salario actual*/
CREATE OR REPLACE PACKAGE servicios2
IS
  --Retorno el codigo del empleado
  FUNCTION  fGetSal (p_empno emp.empno%TYPE) RETURN NUMBER;
  --Retorno el nombre del empleado
  FUNCTION  fGetSal (p_ename emp.ename%TYPE) RETURN NUMBER;

END servicios2;
/

CREATE OR REPLACE PACKAGE BODY servicios2
IS
 FUNCTION  fGetSal (p_empno emp.empno%TYPE) RETURN NUMBER
  IS
    salario NUMBER;
  BEGIN
    SELECT sal INTO salario
    FROM   emp e
    WHERE  e.empno = p_empno;

    RETURN salario;
  EXCEPTION
    WHEN No_Data_Found THEN
      RETURN -1;
    WHEN OTHERS THEN
      Dbms_Output.put_line(SQLCODE || ' - ' || SQLERRM);
      RETURN -1;
  END fGetSal;

  FUNCTION  fGetSal (p_ename emp.ename%TYPE) RETURN NUMBER
  IS
    salario NUMBER;
  BEGIN
    SELECT sal INTO salario
    FROM   emp e
    WHERE  e.ename = p_ename;

    RETURN salario;
  EXCEPTION
    WHEN No_Data_Found THEN
      RETURN -1;
    WHEN OTHERS THEN
      Dbms_Output.put_line(SQLCODE || ' - ' || SQLERRM);
      RETURN -1;
  END fGetSal;
END servicios2;
/

BEGIN
  Dbms_Output.put_line('Salario de 7782 : '||servicios2.fGetSal (7782));
  Dbms_Output.put_line('Salario de CLARK : '||servicios2.fGetSal ('CLARK'));
  DBMS_OUTPUT.PUT('hola');
END;