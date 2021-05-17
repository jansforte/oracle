CREATE OR REPLACE PACKAGE crud_state
IS

  FUNCTION fGetState(cod_state state.id%TYPE)
    RETURN state%ROWTYPE;

  FUNCTION fPutState(cod_state state.id%TYPE,
                    state_updated state.updated_at%TYPE,
                    state_created state.created_at%TYPE,
                    state_name  state.name%TYPE)
    RETURN NUMBER;

  FUNCTION fDelState(cod_state state.id%TYPE)
    RETURN NUMBER;

  FUNCTION fUpdState(cod_state state.id%TYPE,
                    state_name  state.name%TYPE)
    RETURN NUMBER;



END crud_state;
/

CREATE OR REPLACE PACKAGE BODY crud_state
IS

  FUNCTION fGetState(cod_state state.id%TYPE)
  RETURN state%ROWTYPE
  IS
    v_state state%ROWTYPE;

  BEGIN
    SELECT * INTO v_state
    FROM   state u
    WHERE  u.id = cod_state;

    RETURN v_state;
  EXCEPTION
    WHEN No_Data_Found THEN
      Dbms_Output.put_line(SQLCODE || ' - ' || SQLERRM);
      RETURN NULL;

    WHEN OTHERS THEN
      Dbms_Output.put_line(SQLCODE || ' - ' || SQLERRM);
      RETURN NULL;

  END fGetState;

  FUNCTION fPutState(cod_state state.id%TYPE,
                    state_updated state.updated_at%TYPE,
                    state_created state.created_at%TYPE,
                    state_name  state.name%TYPE)
  RETURN NUMBER
  IS
  BEGIN
    INSERT INTO state (id,updated_at,created_at, name)
           VALUES (cod_state, state_updated, state_created,state_name);
           
    RETURN SQL%ROWCOUNT;      
  EXCEPTION
    WHEN OTHERS THEN
      Dbms_Output.put_line(SQLCODE || ' - ' || SQLERRM);
      RETURN -1;

  END fPutState;

  FUNCTION fDelState(cod_state state.id%TYPE)
  RETURN NUMBER
  IS
  BEGIN
    DELETE state
    WHERE  id = cod_state;
           
    RETURN SQL%ROWCOUNT;      
  EXCEPTION
    WHEN OTHERS THEN
      Dbms_Output.put_line(SQLCODE || ' - ' || SQLERRM);
      RETURN -1;

  END fDelState;

  FUNCTION fUpdState(cod_state state.id%TYPE,
                    state_name  state.name%TYPE)
  RETURN NUMBER
  IS
    sql_str VARCHAR2(1000);

  BEGIN
    sql_str := 'UPDATE state SET name = '||state_name||' WHERE id = '|| cod_state;
    
    EXECUTE IMMEDIATE sql_str;
     
    RETURN SQL%ROWCOUNT;    
  EXCEPTION
    WHEN OTHERS THEN
      Dbms_Output.put_line(SQLCODE || ' - ' || SQLERRM);
      RETURN -1;

  END fUpdState;

END crud_state;