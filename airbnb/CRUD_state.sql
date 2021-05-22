--
--
-- AUTHOR: JEISON ANDRES FUENTES ORTEGA
-- AUTHOR: JOHAN SEBASTIAN FUENTES ORTEGA
-- DATE: 20/05/21
--
-- ----------------------------------------
CREATE OR REPLACE PACKAGE crudState
IS
	FUNCTION getState (p_Id IN state.id%TYPE)
	RETURN state%ROWTYPE;
 
	FUNCTION putState (p_id IN state.id%TYPE, 
		p_updated_at IN state.updated_at%TYPE, 
		p_created_at IN state.created_at%TYPE, 
		p_name IN state.name%TYPE)
	RETURN NUMBER;
 
	FUNCTION delState (p_Id IN state.id%TYPE)
	RETURN NUMBER;
 
	FUNCTION updState (p_id IN state.id%TYPE, 
		p_updated_at IN state.updated_at%TYPE, 
		p_created_at IN state.created_at%TYPE, 
		p_name IN state.name%TYPE)
	RETURN NUMBER;
 
END crudState;
/
 
--
-- ----------------------------------------
--
CREATE OR REPLACE PACKAGE BODY crudState
IS
 
-- ------ FUNCION SELECT ------
	FUNCTION getState (p_Id IN state.id%TYPE)
	RETURN state%ROWTYPE
	IS
		v_state state%ROWTYPE;
	BEGIN
		SELECT * INTO v_state
		FROM state
		WHERE state.id = p_Id;
		RETURN v_state;
 
	EXCEPTION
		WHEN No_Data_Found THEN
			DBMS_OUTPUT.PUT_LINE(SQLCODE || ' - ' || SQLERRM);
			RETURN NULL;
 
		WHEN OTHERS THEN
			DBMS_OUTPUT.PUT_LINE(SQLCODE || ' - ' || SQLERRM);
			RETURN NULL;
 
	END getState;
 
-- ------ FUNCION INSERT ------
	FUNCTION putState (p_id IN state.id%TYPE, 
		p_updated_at IN state.updated_at%TYPE, 
		p_created_at IN state.created_at%TYPE, 
		p_name IN state.name%TYPE)
	RETURN NUMBER
	IS
	BEGIN
		INSERT INTO State VALUES (
			p_id, 
			p_updated_at, 
			p_created_at, 
			p_name);
		RETURN SQL%ROWCOUNT;
	EXCEPTION
		WHEN OTHERS THEN
			DBMS_OUTPUT.PUT_LINE(SQLCODE || ' - ' || SQLERRM);
			RETURN -1;
 
	END putState;
 
-- ------ FUNCION DELETE ------
	FUNCTION delState (p_Id IN state.id%TYPE)
	RETURN NUMBER
	IS
	BEGIN
		DELETE state
		WHERE state.id = p_Id;
		RETURN SQL%ROWCOUNT;
	EXCEPTION
		WHEN OTHERS THEN
			DBMS_OUTPUT.PUT_LINE(SQLCODE || ' - ' || SQLERRM);
			RETURN -1;
 
	END delState;
 
-- ------ FUNCION UPDATE ------
	FUNCTION updState (p_id IN state.id%TYPE, 
		p_updated_at IN state.updated_at%TYPE, 
		p_created_at IN state.created_at%TYPE, 
		p_name IN state.name%TYPE)
	RETURN NUMBER
	IS
		sql_str VARCHAR(1000);
	BEGIN
		sql_str := 'UPDATE state SET '||'
			state.updated_at = '|| p_updated_at||', 
			state.created_at = '|| p_created_at||', 
			state.name = '|| p_name 
		|| ' WHERE state.id = '|| p_Id;
		EXECUTE IMMEDIATE sql_str;
		RETURN SQL%ROWCOUNT;
	EXCEPTION
		WHEN OTHERS THEN
			DBMS_OUTPUT.PUT_LINE(SQLCODE || ' - ' || SQLERRM);
			RETURN -1;
 
	END updState;
END crudState;
/

