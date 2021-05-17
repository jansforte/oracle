--
-- 
--AUTHOR: JOHAN SEBASTIAN FUENTES ORTEGA
--DATE: 24/04/2021
--

-- ----------------------------------------------------------
--
-- 
--JOHAN SEBASTIAN FUENTES ORTEGA
--DATE: 24/04/2021
--

-- ----------------------------------------------------------
/*Paquete de acceso a datos – departamento*/
CREATE OR REPLACE PACKAGE acceso
IS
  --retorna los datos del departamento
  FUNCTION fGetDept(p_deptno dept.deptno%TYPE)
    RETURN dept%ROWTYPE;
--inserto datos en el departamento
  FUNCTION fPutDept(p_deptno dept.deptno%TYPE,
                    p_dname  dept.dname%TYPE,
                    p_loc    dept.loc%TYPE)
    RETURN NUMBER;
--borro datos del departamento
  FUNCTION fDelDept(p_deptno dept.deptno%TYPE)
    RETURN NUMBER;
--actualizo datos del departamento
  FUNCTION fUpdDept(p_deptno dept.deptno%TYPE,
                    p_dname  dept.dname%TYPE,
                    p_loc    dept.loc%TYPE)
    RETURN NUMBER;

END acceso;
/

CREATE OR REPLACE PACKAGE BODY acceso
IS

 FUNCTION fGetDept(p_deptno dept.deptno%TYPE)
  RETURN dept%ROWTYPE
  IS
    v_dept dept%ROWTYPE;

  BEGIN
    SELECT * INTO v_dept
    FROM   dept d
    WHERE  d.deptno = p_deptno;

    RETURN v_dept;
  EXCEPTION
    WHEN No_Data_Found THEN
      Dbms_Output.put_line(SQLCODE || ' - ' || SQLERRM);
      RETURN NULL;

    WHEN OTHERS THEN
      Dbms_Output.put_line(SQLCODE || ' - ' || SQLERRM);
      RETURN NULL;

  END fGetDept;

  FUNCTION fPutDept(p_deptno dept.deptno%TYPE,
                    p_dname  dept.dname%TYPE,
                    p_loc    dept.loc%TYPE)
  RETURN NUMBER
  IS
  BEGIN
    INSERT INTO dept (deptno, dname, loc)
           VALUES (p_deptno, p_dname, p_loc);
           
    RETURN SQL%ROWCOUNT;      
  EXCEPTION
    WHEN OTHERS THEN
      Dbms_Output.put_line(SQLCODE || ' - ' || SQLERRM);
      RETURN -1;

  END fPutDept;

  FUNCTION fDelDept(p_deptno dept.deptno%TYPE)
  RETURN NUMBER
  IS
  BEGIN
    DELETE dept
    WHERE  deptno = p_deptno;
           
    RETURN SQL%ROWCOUNT;      
  EXCEPTION
    WHEN OTHERS THEN
      Dbms_Output.put_line(SQLCODE || ' - ' || SQLERRM);
      RETURN -1;

  END fDelDept;

  FUNCTION fUpdDept(p_deptno dept.deptno%TYPE,
                    p_dname  dept.dname%TYPE,
                    p_loc    dept.loc%TYPE)
  RETURN NUMBER
  IS
    sql_str VARCHAR2(1000);
    sql_p1 VARCHAR2(100); 
    sql_p2 VARCHAR2(100); 
	activar VARCHAR(47);
    desactivar VARCHAR2(48);
    filas NUMBER;

  BEGIN
    SELECT Decode(p_dname, NULL, 'dname', ''''||p_dname||'''') INTO sql_p1
    FROM   dual;

    SELECT Decode(p_loc,   NULL, 'loc',   ''''||p_loc||  '''') INTO sql_p2
    FROM   dual;

    sql_str := 'UPDATE dept SET dname = '||sql_p1||', loc = '||sql_p2||
               ' WHERE deptno = '|| p_deptno;
    
    activar:='ALTER TRIGGER restriction_update_console ENABLE';
    desactivar:='ALTER TRIGGER restriction_update_console DISABLE';
    
    EXECUTE IMMEDIATE desactivar;
    EXECUTE IMMEDIATE sql_str;
    filas:=SQL%ROWCOUNT;
    EXECUTE IMMEDIATE activar;

    RETURN filas;    
  EXCEPTION
    WHEN OTHERS THEN
      Dbms_Output.put_line(SQLCODE || ' - ' || SQLERRM);
      RETURN -1;

  END fUpdDept;
END acceso;
/

/*Restringir el comando update por consola 
al ejecutar la función update en el package body antes de hacer el
EXCUTE IMMEDIATE, desactivo el trigger, y lo vuelvo a
activar despues de realizar el EXECUTE IMMEDIATE*/
CREATE OR REPLACE TRIGGER restriction_update_console
  BEFORE UPDATE
  ON dept
BEGIN
  IF UPDATING THEN
    RAISE_APPLICATION_ERROR(-20500, 'You may update'
    ||' only using the package acceso. ');
  END IF;
END restriction_update_console;