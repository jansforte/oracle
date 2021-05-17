CREATE OR REPLACE PACKAGE crud_usuario
IS

  FUNCTION fGetUsuario(cod_user usuario.id%TYPE)
    RETURN usuario%ROWTYPE;

  FUNCTION fPutUsauario(cod_user usuario.id%TYPE,
                    usuario_updated usuario.updated_at%TYPE,
                    usuario_created usuario.created_at%TYPE,
                    usuario_email  usuario.email%TYPE,
                    usuario_pass    usuario.password%TYPE)
    RETURN NUMBER;

  FUNCTION fDelUsuario(cod_user usuario.id%TYPE)
    RETURN NUMBER;

  FUNCTION fUpdUsuario(cod_user usuario.id%TYPE,
                    usuario_email  usuario.email%TYPE,
                    usuario_pass    usuario.password%TYPE)
    RETURN NUMBER;



END crud_usuario;
/

CREATE OR REPLACE PACKAGE BODY crud_usuario
IS

  FUNCTION fGetUsuario(cod_user usuario.id%TYPE)
  RETURN usuario%ROWTYPE
  IS
    v_usuario usuario%ROWTYPE;

  BEGIN
    SELECT * INTO v_usuario
    FROM   usuario u
    WHERE  u.id = cod_user;

    RETURN v_usuario;
  EXCEPTION
    WHEN No_Data_Found THEN
      Dbms_Output.put_line(SQLCODE || ' - ' || SQLERRM);
      RETURN NULL;

    WHEN OTHERS THEN
      Dbms_Output.put_line(SQLCODE || ' - ' || SQLERRM);
      RETURN NULL;

  END fGetUsuario;

  FUNCTION fPutUsauario(cod_user usuario.id%TYPE,
                    usuario_updated usuario.updated_at%TYPE,
                    usuario_created usuario.created_at%TYPE,
                    usuario_email  usuario.email%TYPE,
                    usuario_pass    usuario.password%TYPE)
  RETURN NUMBER
  IS
  BEGIN
    INSERT INTO usuario (id,updated_at,created_at, email, password)
           VALUES (cod_user, usuario_updated, usuario_created,usuario_email, usuario_pass);
           
    RETURN SQL%ROWCOUNT;      
  EXCEPTION
    WHEN OTHERS THEN
      Dbms_Output.put_line(SQLCODE || ' - ' || SQLERRM);
      RETURN -1;

  END fPutUsauario;

  FUNCTION fDelUsuario(cod_user usuario.id%TYPE)
  RETURN NUMBER
  IS
  BEGIN
    DELETE usuario
    WHERE  id = cod_user;
           
    RETURN SQL%ROWCOUNT;      
  EXCEPTION
    WHEN OTHERS THEN
      Dbms_Output.put_line(SQLCODE || ' - ' || SQLERRM);
      RETURN -1;

  END fDelUsuario;

  FUNCTION fUpdUsuario(cod_user usuario.id%TYPE,
                    usuario_email  usuario.email%TYPE,
                    usuario_pass    usuario.password%TYPE)
  RETURN NUMBER
  IS
    sql_str VARCHAR2(1000);

  BEGIN
    sql_str := 'UPDATE usuario SET email = '||usuario_email||', password = '||usuario_pass||
               ' WHERE id = '|| cod_user;
    
    EXECUTE IMMEDIATE sql_str;
     
    RETURN SQL%ROWCOUNT;    
  EXCEPTION
    WHEN OTHERS THEN
      Dbms_Output.put_line(SQLCODE || ' - ' || SQLERRM);
      RETURN -1;

  END fUpdUsuario;

END crud_usuario;