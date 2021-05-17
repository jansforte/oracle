--
-- 
--AUTHOR: JOHAN SEBASTIAN FUENTES ORTEGA
--DATE: 16/05/2021
--
-- ----------------------------------------------------------
ACCEPT tabla PROMPT 'Ingresa la tabla :' --Solicito la tabla
SET SERVEROUTPUT ON
SET FEEDBACK OFF
SET VERIFY OFF
SPOOL C:\Users\jansf\Desktop\ORACLE\Taller2generadorPL\punto1.sql
DECLARE
    CURSOR cu_col
    IS
        SELECT t.COLUMN_NAME FROM user_tab_columns t
        WHERE t.table_name=Upper('&tabla');
    ctrl BOOLEAN := FALSE;
BEGIN
    DBMS_OUTPUT.PUT_LINE('--');
    DBMS_OUTPUT.PUT_LINE('--');
    DBMS_OUTPUT.PUT_LINE('-- AUTHOR: JOHAN SEBASTIAN FUENTES ORTEGA');
    DBMS_OUTPUT.PUT_LINE('-- DATE: '|| sysdate);
    DBMS_OUTPUT.PUT_LINE('--');
    DBMS_OUTPUT.PUT_LINE('-- ----------------------------------------');
    --Encabezado de la funcion
    DBMS_OUTPUT.PUT('CREATE OR REPLACE FUNCTION in'|| Initcap('&tabla ('));
    --Parametros para la funcion
    FOR re_col IN cu_col
    LOOP
        IF ctrl THEN
            DBMS_OUTPUT.PUT_LINE(', ');
            DBMS_OUTPUT.PUT(Chr(09)); --Caracter tabulador
        END IF;
        DBMS_OUTPUT.PUT('p_' || Lower(re_col.COLUMN_NAME) || ' IN &tabla' || '.'
        || Lower(re_col.COLUMN_NAME) || '%TYPE');
        ctrl := TRUE;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE(')');
    DBMS_OUTPUT.PUT_LINE('RETURN NUMBER');
    DBMS_OUTPUT.PUT_LINE('IS');
    DBMS_OUTPUT.PUT_LINE(Chr(09) || 'nuRetorno := 0;');
    DBMS_OUTPUT.PUT_LINE('BEGIN');
    DBMS_OUTPUT.PUT_LINE(Chr(09) || 'INSERT INTO &tabla');
    DBMS_OUTPUT.PUT(Chr(09) || 'VALUES (');
    ctrl := FALSE;
    FOR re_col IN cu_col
    LOOP
        IF ctrl THEN
            DBMS_OUTPUT.PUT_LINE(', ');
            DBMS_OUTPUT.PUT(Chr(09) || Chr(09)); --Caracter tabulador
        END IF;
        DBMS_OUTPUT.PUT('p_' || Lower(re_col.COLUMN_NAME));
        ctrl := TRUE;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE(');');
    DBMS_OUTPUT.PUT_LINE(Chr(09) || 'nuRetorno := SQL%ROWCOUNT;');
    DBMS_OUTPUT.PUT_LINE(Chr(09) || 'RETURN nuRetorno;');
    DBMS_OUTPUT.PUT_LINE('END in'||Initcap('&tabla')||';');
END;
/
SPOOL OFF
QUIT   