--
-- 
--AUTHOR: JOHAN SEBASTIAN FUENTES ORTEGA
--AUTHOR: JEISON ANDRES FUENTES ORTEGA
--DATE: 20/05/2021
--
-- ----------------------------------------------------------
ACCEPT tabla PROMPT 'Ingrese el nombre de la tabla: '
SET SERVEROUTPUT ON
SET FEEDBACK OFF
SET VERIFY OFF
SPOOL \C:\Users\jansf\Desktop\ORACLE\airbnb\CRUD_AMENITY.sql
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
    ctrl BOOLEAN := FALSE;
    ctrl2 BOOLEAN:= FALSE;
BEGIN
    DBMS_OUTPUT.PUT_LINE('--');
    DBMS_OUTPUT.PUT_LINE('--');
    DBMS_OUTPUT.PUT_LINE('-- AUTHOR: JEISON ANDRES FUENTES ORTEGA');
    DBMS_OUTPUT.PUT_LINE('-- AUTHOR: JOHAN SEBASTIAN FUENTES ORTEGA');
    DBMS_OUTPUT.PUT_LINE('-- DATE: '|| sysdate);
    DBMS_OUTPUT.PUT_LINE('--');
    DBMS_OUTPUT.PUT_LINE('-- ----------------------------------------');
    DBMS_OUTPUT.PUT_LINE('CREATE OR REPLACE PACKAGE crud'|| Initcap('&tabla'));
    DBMS_OUTPUT.PUT_LINE('IS');
    OPEN cu_pk;
    FETCH cu_pk INTO v_pk;
    CLOSE cu_pk;
    DBMS_OUTPUT.PUT(Chr(09)); --Función Select
    DBMS_OUTPUT.PUT('FUNCTION get'||Initcap('&tabla')||' (p_'||Initcap(v_pk)||' IN ');
    DBMS_OUTPUT.PUT_LINE('&tabla'||'.'||Lower(v_pk)||'%TYPE)');
    DBMS_OUTPUT.PUT_LINE(Chr(09)||'RETURN &tabla'||'%ROWTYPE;');
    DBMS_OUTPUT.PUT_LINE(' ');
    DBMS_OUTPUT.PUT(Chr(09)); --Función Insert
    DBMS_OUTPUT.PUT('FUNCTION put'||Initcap('&tabla ('));
    FOR re_col IN cu_col
    LOOP
        IF ctrl THEN
            DBMS_OUTPUT.PUT_LINE(', ');
            DBMS_OUTPUT.PUT(Chr(09)||Chr(09));
        END IF;
        DBMS_OUTPUT.PUT('p_' || Lower(re_col.COLUMN_NAME) || ' IN &tabla' || '.'
        || Lower(re_col.COLUMN_NAME) || '%TYPE');
        ctrl := TRUE;
    END LOOP;
    ctrl := FALSE;
    DBMS_OUTPUT.PUT_LINE(')');
    DBMS_OUTPUT.PUT_LINE(Chr(09)||'RETURN NUMBER;');
    DBMS_OUTPUT.PUT_LINE(' ');
    DBMS_OUTPUT.PUT(Chr(09)); --Función Delete
    DBMS_OUTPUT.PUT('FUNCTION del'||Initcap('&tabla')||' (p_'||Initcap(v_pk)||' IN ');
    DBMS_OUTPUT.PUT_LINE('&tabla'||'.'||Lower(v_pk)||'%TYPE)');
    DBMS_OUTPUT.PUT_LINE(Chr(09)||'RETURN NUMBER;');
    DBMS_OUTPUT.PUT_LINE(' ');
    DBMS_OUTPUT.PUT(Chr(09)); --Función Update
    DBMS_OUTPUT.PUT('FUNCTION upd'||Initcap('&tabla ('));
    FOR re_col IN cu_col
    LOOP
        IF ctrl THEN
            DBMS_OUTPUT.PUT_LINE(', ');
            DBMS_OUTPUT.PUT(Chr(09)||Chr(09));
        END IF;
        DBMS_OUTPUT.PUT('p_' || Lower(re_col.COLUMN_NAME) || ' IN &tabla' || '.'
        || Lower(re_col.COLUMN_NAME) || '%TYPE');
        ctrl := TRUE;
    END LOOP;
    ctrl := FALSE;
    DBMS_OUTPUT.PUT_LINE(')');
    DBMS_OUTPUT.PUT_LINE(Chr(09)||'RETURN NUMBER;');
    DBMS_OUTPUT.PUT_LINE(' ');
    DBMS_OUTPUT.PUT_LINE('END crud'|| Initcap('&tabla')||';');
    DBMS_OUTPUT.PUT_LINE('/');
    DBMS_OUTPUT.PUT_LINE(' ');
    DBMS_OUTPUT.PUT_LINE('--');
    DBMS_OUTPUT.PUT_LINE('-- ----------------------------------------');
    DBMS_OUTPUT.PUT_LINE('--');
    DBMS_OUTPUT.PUT_LINE('CREATE OR REPLACE PACKAGE BODY crud'|| Initcap('&tabla'));
    DBMS_OUTPUT.PUT_LINE('IS');
    DBMS_OUTPUT.PUT_LINE(' ');
    DBMS_OUTPUT.PUT_LINE('-- ------ FUNCION SELECT ------');
    DBMS_OUTPUT.PUT(Chr(09)); --Función Select
    DBMS_OUTPUT.PUT('FUNCTION get'||Initcap('&tabla')||' (p_'||Initcap(v_pk)||' IN ');
    DBMS_OUTPUT.PUT_LINE('&tabla'||'.'||Lower(v_pk)||'%TYPE)');
    DBMS_OUTPUT.PUT_LINE(Chr(09)||'RETURN &tabla'||'%ROWTYPE');
    DBMS_OUTPUT.PUT_LINE(Chr(09)||'IS');
    DBMS_OUTPUT.PUT_LINE(Chr(09)||Chr(09)||'v_'||'&tabla &tabla'||'%ROWTYPE;');
    DBMS_OUTPUT.PUT_LINE(Chr(09)||'BEGIN');
    DBMS_OUTPUT.PUT_LINE(Chr(09)||Chr(09)||'SELECT * INTO '||'v_'||'&tabla');
    DBMS_OUTPUT.PUT_LINE(Chr(09)||Chr(09)||'FROM &tabla');
    DBMS_OUTPUT.PUT_LINE(Chr(09)||Chr(09)||'WHERE &tabla'||'.'||Lower(v_pk)||' = p_'||Initcap(v_pk)||';');
    DBMS_OUTPUT.PUT_LINE(Chr(09)||Chr(09)||'RETURN v_'||'&tabla;');
    DBMS_OUTPUT.PUT_LINE(' ');
    DBMS_OUTPUT.PUT_LINE(Chr(09)||'EXCEPTION');
    DBMS_OUTPUT.PUT_LINE(Chr(09)||Chr(09)||'WHEN No_Data_Found THEN');
    DBMS_OUTPUT.PUT(Chr(09)||Chr(09)||Chr(09)||'DBMS_OUTPUT.PUT_LINE(');
    DBMS_OUTPUT.PUT_LINE('SQLCODE || '||Chr(39)||' - '|| Chr(39) ||' || SQLERRM);');
    DBMS_OUTPUT.PUT_LINE(Chr(09)||Chr(09)||Chr(09)||'RETURN NULL;');
    DBMS_OUTPUT.PUT_LINE(' ');
    DBMS_OUTPUT.PUT_LINE(Chr(09)||Chr(09)||'WHEN OTHERS THEN');
    DBMS_OUTPUT.PUT(Chr(09)||Chr(09)||Chr(09)||'DBMS_OUTPUT.PUT_LINE(');
    DBMS_OUTPUT.PUT_LINE('SQLCODE || '||Chr(39)||' - '|| Chr(39) ||' || SQLERRM);');
    DBMS_OUTPUT.PUT_LINE(Chr(09)||Chr(09)||Chr(09)||'RETURN NULL;');
    DBMS_OUTPUT.PUT_LINE(' ');
    DBMS_OUTPUT.PUT_LINE(Chr(09)||'END get'||Initcap('&tabla')||';'); --Termino funcion SELECT
    DBMS_OUTPUT.PUT_LINE(' ');
    DBMS_OUTPUT.PUT_LINE('-- ------ FUNCION INSERT ------');
    DBMS_OUTPUT.PUT(Chr(09)); --Función Insert
    DBMS_OUTPUT.PUT('FUNCTION put'||Initcap('&tabla ('));
    FOR re_col IN cu_col
    LOOP
        IF ctrl THEN
            DBMS_OUTPUT.PUT_LINE(', ');
            DBMS_OUTPUT.PUT(Chr(09)||Chr(09));
        END IF;
        DBMS_OUTPUT.PUT('p_' || Lower(re_col.COLUMN_NAME) || ' IN &tabla' || '.'
        || Lower(re_col.COLUMN_NAME) || '%TYPE');
        ctrl := TRUE;
    END LOOP;
    ctrl := FALSE;
    DBMS_OUTPUT.PUT_LINE(')');
    DBMS_OUTPUT.PUT_LINE(Chr(09)||'RETURN NUMBER');
    DBMS_OUTPUT.PUT_LINE(Chr(09)||'IS');
    DBMS_OUTPUT.PUT_LINE(Chr(09)||'BEGIN');
    DBMS_OUTPUT.PUT_LINE(Chr(09)||Chr(09)||'INSERT INTO '||Initcap('&tabla')||' VALUES (');
    DBMS_OUTPUT.PUT(Chr(09)||Chr(09)||Chr(09));
    FOR re_col IN cu_col
    LOOP
        IF ctrl THEN
            DBMS_OUTPUT.PUT_LINE(', ');
            DBMS_OUTPUT.PUT(Chr(09)||Chr(09)||Chr(09));
        END IF;
        DBMS_OUTPUT.PUT('p_' || Lower(re_col.COLUMN_NAME));
        ctrl := TRUE;
    END LOOP;
    ctrl := FALSE;
    DBMS_OUTPUT.PUT_LINE(');');
    DBMS_OUTPUT.PUT_LINE(Chr(09)||Chr(09)||'RETURN SQL%ROWCOUNT;');
    DBMS_OUTPUT.PUT_LINE(Chr(09)||'EXCEPTION');
    DBMS_OUTPUT.PUT_LINE(Chr(09)||Chr(09)||'WHEN OTHERS THEN');
    DBMS_OUTPUT.PUT(Chr(09)||Chr(09)||Chr(09)||'DBMS_OUTPUT.PUT_LINE(');
    DBMS_OUTPUT.PUT_LINE('SQLCODE || '||Chr(39)||' - '|| Chr(39) ||' || SQLERRM);');
    DBMS_OUTPUT.PUT_LINE(Chr(09)||Chr(09)||Chr(09)||'RETURN -1;');
    DBMS_OUTPUT.PUT_LINE(' ');
    DBMS_OUTPUT.PUT_LINE(Chr(09)||'END put'||Initcap('&tabla')||';'); --Termino funcion INSERT
    DBMS_OUTPUT.PUT_LINE(' ');
    DBMS_OUTPUT.PUT_LINE('-- ------ FUNCION DELETE ------');
    DBMS_OUTPUT.PUT(Chr(09)); --Función Delete
    DBMS_OUTPUT.PUT('FUNCTION del'||Initcap('&tabla')||' (p_'||Initcap(v_pk)||' IN ');
    DBMS_OUTPUT.PUT_LINE('&tabla'||'.'||Lower(v_pk)||'%TYPE)');
    DBMS_OUTPUT.PUT_LINE(Chr(09)||'RETURN NUMBER');
    DBMS_OUTPUT.PUT_LINE(Chr(09)||'IS');
    DBMS_OUTPUT.PUT_LINE(Chr(09)||'BEGIN');
    DBMS_OUTPUT.PUT_LINE(Chr(09)||Chr(09)||'DELETE &tabla');
    DBMS_OUTPUT.PUT(Chr(09)||Chr(09)||'WHERE &tabla'||'.'||Lower(v_pk));
    DBMS_OUTPUT.PUT_LINE(' = '||'p_'||Initcap(v_pk)||';');
    DBMS_OUTPUT.PUT_LINE(Chr(09)||Chr(09)||'RETURN SQL%ROWCOUNT;');
    DBMS_OUTPUT.PUT_LINE(Chr(09)||'EXCEPTION');
    DBMS_OUTPUT.PUT_LINE(Chr(09)||Chr(09)||'WHEN OTHERS THEN');
    DBMS_OUTPUT.PUT(Chr(09)||Chr(09)||Chr(09)||'DBMS_OUTPUT.PUT_LINE(');
    DBMS_OUTPUT.PUT_LINE('SQLCODE || '||Chr(39)||' - '|| Chr(39) ||' || SQLERRM);');
    DBMS_OUTPUT.PUT_LINE(Chr(09)||Chr(09)||Chr(09)||'RETURN -1;');
    DBMS_OUTPUT.PUT_LINE(' ');
    DBMS_OUTPUT.PUT_LINE(Chr(09)||'END del'||Initcap('&tabla')||';'); --Termino funcion DELETE
    DBMS_OUTPUT.PUT_LINE(' ');
    DBMS_OUTPUT.PUT_LINE('-- ------ FUNCION UPDATE ------');
    DBMS_OUTPUT.PUT(Chr(09)); --Función Update
    DBMS_OUTPUT.PUT('FUNCTION upd'||Initcap('&tabla ('));
    FOR re_col IN cu_col
    LOOP
        IF ctrl THEN
            DBMS_OUTPUT.PUT_LINE(', ');
            DBMS_OUTPUT.PUT(Chr(09)||Chr(09));
        END IF;
        DBMS_OUTPUT.PUT('p_' || Lower(re_col.COLUMN_NAME) || ' IN &tabla' || '.'
        || Lower(re_col.COLUMN_NAME) || '%TYPE');
        ctrl := TRUE;
    END LOOP;
    ctrl := FALSE;
    DBMS_OUTPUT.PUT_LINE(')');
    DBMS_OUTPUT.PUT_LINE(Chr(09)||'RETURN NUMBER');
    DBMS_OUTPUT.PUT_LINE(Chr(09)||'IS');
    DBMS_OUTPUT.PUT_LINE(Chr(09)||Chr(09)||'sql_str VARCHAR(1000);');
    DBMS_OUTPUT.PUT_LINE(Chr(09)||'BEGIN');
    DBMS_OUTPUT.PUT(Chr(09)||Chr(09)||'sql_str := '||Chr(39)|| 'UPDATE &tabla SET ');
    DBMS_OUTPUT.PUT_LINE(Chr(39)||'||'||Chr(39));
    DBMS_OUTPUT.PUT(Chr(09)||Chr(09)||Chr(09));
    FOR re_col IN cu_col
    LOOP
        IF ctrl2 THEN
            IF ctrl THEN
                DBMS_OUTPUT.PUT_LINE('||'||Chr(39)||', ');
                DBMS_OUTPUT.PUT(Chr(09)||Chr(09)||Chr(09));
            END IF;
            DBMS_OUTPUT.PUT('&tabla'||'.'||Lower(re_col.COLUMN_NAME));
            DBMS_OUTPUT.PUT(' = '||Chr(39)||'|| p_' || Lower(re_col.COLUMN_NAME));
            ctrl := TRUE;
        END IF;
        ctrl2 := TRUE; 
    END LOOP;
    ctrl := FALSE;
    DBMS_OUTPUT.PUT_LINE(' ');
    DBMS_OUTPUT.PUT(Chr(09)||Chr(09)||'|| '||Chr(39)||' WHERE &tabla'||'.'||Lower(v_pk));
    DBMS_OUTPUT.PUT_LINE(' = '||Chr(39)||'|| p_'||Initcap(v_pk)||';');
    DBMS_OUTPUT.PUT_LINE(Chr(09)||Chr(09)||'EXECUTE IMMEDIATE sql_str;');
    DBMS_OUTPUT.PUT_LINE(Chr(09)||Chr(09)||'RETURN SQL%ROWCOUNT;');
    DBMS_OUTPUT.PUT_LINE(Chr(09)||'EXCEPTION');
    DBMS_OUTPUT.PUT_LINE(Chr(09)||Chr(09)||'WHEN OTHERS THEN');
    DBMS_OUTPUT.PUT(Chr(09)||Chr(09)||Chr(09)||'DBMS_OUTPUT.PUT_LINE(');
    DBMS_OUTPUT.PUT_LINE('SQLCODE || '||Chr(39)||' - '|| Chr(39) ||' || SQLERRM);');
    DBMS_OUTPUT.PUT_LINE(Chr(09)||Chr(09)||Chr(09)||'RETURN -1;');
    DBMS_OUTPUT.PUT_LINE(' ');
    DBMS_OUTPUT.PUT_LINE(Chr(09)||'END upd'||Initcap('&tabla')||';'); --Termina funcion UPDATE
    DBMS_OUTPUT.PUT_LINE('END crud'||Initcap('&tabla')||';');--Termina package body
    DBMS_OUTPUT.PUT_LINE('/');
END;
/
SPOOL OFF
QUIT   