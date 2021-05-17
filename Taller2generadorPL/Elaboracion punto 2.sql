--
-- 
--AUTHOR: JOHAN SEBASTIAN FUENTES ORTEGA
--DATE: 16/05/2021
--
-- ----------------------------------------------------------
ACCEPT tabla PROMPT 'Ingresa la tabla :'
SET SERVEROUTPUT ON
SET FEEDBACK OFF
SET VERIFY OFF
SPOOL C:\Users\jansf\Desktop\ORACLE\Taller2generadorPL\punto2.sql
DECLARE
    v_pk user_cons_columns.column_name%TYPE;
    CURSOR cu_col
    IS
        SELECT t.COLUMN_NAME, t.DATA_TYPE FROM user_tab_columns t
        WHERE t.table_name=Upper('&tabla');
    CURSOR cu_pk
    IS
    SELECT col.column_name FROM user_cons_columns col, user_constraints con
    WHERE col.constraint_name = con.constraint_name
        AND con.constraint_type = 'P'
        AND con.table_name = Upper('&tabla');
BEGIN
    DBMS_OUTPUT.PUT_LINE('--');
    DBMS_OUTPUT.PUT_LINE('--');
    DBMS_OUTPUT.PUT_LINE('-- AUTHOR: JOHAN SEBASTIAN FUENTES ORTEGA');
    DBMS_OUTPUT.PUT_LINE('-- DATE: '|| sysdate);
    DBMS_OUTPUT.PUT_LINE('--');
    DBMS_OUTPUT.PUT_LINE('-- ----------------------------------------');
    DBMS_OUTPUT.PUT_LINE('CREATE OR REPLACE PACKAGE pad'|| Initcap('&tabla'));
    DBMS_OUTPUT.PUT_LINE('IS');
    --Parametros para la funcion
    FOR re_col IN cu_col
    LOOP
        DBMS_OUTPUT.PUT(Chr(09));
        DBMS_OUTPUT.PUT('FUNCTION get' || Initcap(re_col.COLUMN_NAME) || ' (');
        OPEN cu_pk;
        FETCH cu_pk INTO v_pk;
        CLOSE cu_pk;
        DBMS_OUTPUT.PUT_LINE('p_'|| Initcap(v_pk) ||' IN &tabla' || '.' || Lower(v_pk) || '%TYPE)');
        DBMS_OUTPUT.PUT_LINE(Chr(09) || 'RETURN &tabla' || '.'|| Lower(re_col.COLUMN_NAME) || '%TYPE;');
        DBMS_OUTPUT.PUT_LINE(' ');
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('END pad'||Initcap('&tabla')||';');
END;
/
SPOOL OFF
QUIT   
  