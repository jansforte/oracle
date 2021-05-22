--
--
-- AUTHOR: JEISON ANDRES FUENTES ORTEGA
-- AUTHOR: JOHAN SEBASTIAN FUENTES ORTEGA
-- DATE: 20/05/21
--
-- ----------------------------------------
CREATE OR REPLACE PACKAGE crudUsuario
IS
	FUNCTION getUsuario (p_Id IN usuario.id%TYPE)
	RETURN usuario%ROWTYPE;
 
	FUNCTION putUsuario (p_id IN usuario.id%TYPE, 
		p_updated_at IN usuario.updated_at%TYPE, 
		p_created_at IN usuario.created_at%TYPE, 
		p_email IN usuario.email%TYPE, 
		p_password IN usuario.password%TYPE, 
		p_first_name IN usuario.first_name%TYPE, 
		p_last_name IN usuario.last_name%TYPE)
	RETURN NUMBER;
 
	FUNCTION delUsuario (p_Id IN usuario.id%TYPE)
	RETURN NUMBER;
 
	FUNCTION updUsuario (p_id IN usuario.id%TYPE, 
		p_updated_at IN usuario.updated_at%TYPE, 
		p_created_at IN usuario.created_at%TYPE, 
		p_email IN usuario.email%TYPE, 
		p_password IN usuario.password%TYPE, 
		p_first_name IN usuario.first_name%TYPE, 
		p_last_name IN usuario.last_name%TYPE)
	RETURN NUMBER;
 
END crudUsuario;
/
 
--
-- ----------------------------------------
--
CREATE OR REPLACE PACKAGE BODY crudUsuario
IS
 
-- ------ FUNCION SELECT ------
	FUNCTION getUsuario (p_Id IN usuario.id%TYPE)
	RETURN usuario%ROWTYPE
	IS
		v_usuario usuario%ROWTYPE;
	BEGIN
		SELECT * INTO v_usuario
		FROM usuario
		WHERE usuario.id = p_Id;
		RETURN v_usuario;
 
	EXCEPTION
		WHEN No_Data_Found THEN
			DBMS_OUTPUT.PUT_LINE(SQLCODE || ' - ' || SQLERRM);
			RETURN NULL;
 
		WHEN OTHERS THEN
			DBMS_OUTPUT.PUT_LINE(SQLCODE || ' - ' || SQLERRM);
			RETURN NULL;
 
	END getUsuario;
 
-- ------ FUNCION INSERT ------
	FUNCTION putUsuario (p_id IN usuario.id%TYPE, 
		p_updated_at IN usuario.updated_at%TYPE, 
		p_created_at IN usuario.created_at%TYPE, 
		p_email IN usuario.email%TYPE, 
		p_password IN usuario.password%TYPE, 
		p_first_name IN usuario.first_name%TYPE, 
		p_last_name IN usuario.last_name%TYPE)
	RETURN NUMBER
	IS
	BEGIN
		INSERT INTO Usuario VALUES (
			p_id, 
			p_updated_at, 
			p_created_at, 
			p_email, 
			p_password, 
			p_first_name, 
			p_last_name);
		RETURN SQL%ROWCOUNT;
	EXCEPTION
		WHEN OTHERS THEN
			DBMS_OUTPUT.PUT_LINE(SQLCODE || ' - ' || SQLERRM);
			RETURN -1;
 
	END putUsuario;
 
-- ------ FUNCION DELETE ------
	FUNCTION delUsuario (p_Id IN usuario.id%TYPE)
	RETURN NUMBER
	IS
	BEGIN
		DELETE usuario
		WHERE usuario.id = p_Id;
		RETURN SQL%ROWCOUNT;
	EXCEPTION
		WHEN OTHERS THEN
			DBMS_OUTPUT.PUT_LINE(SQLCODE || ' - ' || SQLERRM);
			RETURN -1;
 
	END delUsuario;
 
-- ------ FUNCION UPDATE ------
	FUNCTION updUsuario (p_id IN usuario.id%TYPE, 
		p_updated_at IN usuario.updated_at%TYPE, 
		p_created_at IN usuario.created_at%TYPE, 
		p_email IN usuario.email%TYPE, 
		p_password IN usuario.password%TYPE, 
		p_first_name IN usuario.first_name%TYPE, 
		p_last_name IN usuario.last_name%TYPE)
	RETURN NUMBER
	IS
		sql_str VARCHAR(1000);
	BEGIN
		sql_str := 'UPDATE usuario SET '||'
			usuario.updated_at = '|| p_updated_at||', 
			usuario.created_at = '|| p_created_at||', 
			usuario.email = '|| p_email||', 
			usuario.password = '|| p_password||', 
			usuario.first_name = '|| p_first_name||', 
			usuario.last_name = '|| p_last_name 
		|| ' WHERE usuario.id = '|| p_Id;
		EXECUTE IMMEDIATE sql_str;
		RETURN SQL%ROWCOUNT;
	EXCEPTION
		WHEN OTHERS THEN
			DBMS_OUTPUT.PUT_LINE(SQLCODE || ' - ' || SQLERRM);
			RETURN -1;
 
	END updUsuario;
END crudUsuario;
/

