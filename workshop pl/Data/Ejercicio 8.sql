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

  BEGIN
    SELECT Decode(p_dname, NULL, 'dname', ''''||p_dname||'''') INTO sql_p1
    FROM   dual;

    SELECT Decode(p_loc,   NULL, 'loc',   ''''||p_loc||  '''') INTO sql_p2
    FROM   dual;

    sql_str := 'UPDATE dept SET dname = '||sql_p1||', loc = '||sql_p2||
               ' WHERE deptno = '|| p_deptno;
    
    EXECUTE IMMEDIATE sql_str;
     
    RETURN SQL%ROWCOUNT;    
  EXCEPTION
    WHEN OTHERS THEN
      Dbms_Output.put_line(SQLCODE || ' - ' || SQLERRM);
      RETURN -1;

  END fUpdDept;
END acceso;
/

BEGIN
  Dbms_Output.put_line('Departamento 10 : '|| acceso.fGetDept(10).deptno ||'-'||acceso.fGetDept(10).dname||
                                                                             '-'||acceso.fGetDept(10).loc);
  Dbms_Output.put_line('Departamento 20 : '|| acceso.fGetDept(20).deptno ||'-'||acceso.fGetDept(20).dname||
                                                                             '-'||acceso.fGetDept(20).loc);
  Dbms_Output.put_line('Departamento 30 : '|| acceso.fGetDept(30).deptno ||'-'||acceso.fGetDept(30).dname||
                                                                             '-'||acceso.fGetDept(30).loc);

  Dbms_Output.put_line('Insertando 50,I+D,TULUA : '||acceso.fPutDept (50,'I+D','TULUA'));

  Dbms_Output.put_line('Borrando 40 : '||acceso.fDelDept (40));

  Dbms_Output.put_line('Actualizando 10 : '||acceso.fUpdDept (10,'NEO',NULL));

  Dbms_Output.put_line('Actualizando 20 : '||acceso.fUpdDept (20,NULL,'CALI'));

  Dbms_Output.put_line('Actualizando 30 : '||acceso.fUpdDept (30,'EDUC','ARMENIA'));

  Dbms_Output.put_line('Departamento 10 : '|| acceso.fGetDept(10).deptno ||'-'||acceso.fGetDept(10).dname||
                                                                             '-'||acceso.fGetDept(10).loc);
  Dbms_Output.put_line('Departamento 20 : '|| acceso.fGetDept(20).deptno ||'-'||acceso.fGetDept(20).dname||
                                                                             '-'||acceso.fGetDept(20).loc);
  Dbms_Output.put_line('Departamento 30 : '|| acceso.fGetDept(30).deptno ||'-'||acceso.fGetDept(30).dname||
                                                                             '-'||acceso.fGetDept(30).loc);
END;