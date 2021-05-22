--
--
-- AUTHOR: JEISON ANDRES FUENTES ORTEGA
-- AUTHOR: JOHAN SEBASTIAN FUENTES ORTEGA
-- DATE: 20/05/21
--
-- ----------------------------------------
CREATE OR REPLACE PACKAGE crudCity
IS
	FUNCTION getCity (p_Id IN city.id%TYPE)
	RETURN city%ROWTYPE;
 
	FUNCTION putCity (p_id IN city.id%TYPE, 
		p_updated_at IN city.updated_at%TYPE, 
		p_created_at IN city.created_at%TYPE, 
		p_state_id IN city.state_id%TYPE, 
		p_name IN city.name%TYPE)
	RETURN NUMBER;
 
	FUNCTION delCity (p_Id IN city.id%TYPE)
	RETURN NUMBER;
 
	FUNCTION updCity (p_id IN city.id%TYPE, 
		p_updated_at IN city.updated_at%TYPE, 
		p_created_at IN city.created_at%TYPE, 
		p_state_id IN city.state_id%TYPE, 
		p_name IN city.name%TYPE)
	RETURN NUMBER;
 
END crudCity;
/
 
--
-- ----------------------------------------
--
CREATE OR REPLACE PACKAGE BODY crudCity
IS
 
-- ------ FUNCION SELECT ------
	FUNCTION getCity (p_Id IN city.id%TYPE)
	RETURN city%ROWTYPE
	IS
		v_city city%ROWTYPE;
	BEGIN
		SELECT * INTO v_city
		FROM city
		WHERE city.id = p_Id;
		RETURN v_city;
 
	EXCEPTION
		WHEN No_Data_Found THEN
			DBMS_OUTPUT.PUT_LINE(SQLCODE || ' - ' || SQLERRM);
			RETURN NULL;
 
		WHEN OTHERS THEN
			DBMS_OUTPUT.PUT_LINE(SQLCODE || ' - ' || SQLERRM);
			RETURN NULL;
 
	END getCity;
 
-- ------ FUNCION INSERT ------
	FUNCTION putCity (p_id IN city.id%TYPE, 
		p_updated_at IN city.updated_at%TYPE, 
		p_created_at IN city.created_at%TYPE, 
		p_state_id IN city.state_id%TYPE, 
		p_name IN city.name%TYPE)
	RETURN NUMBER
	IS
	BEGIN
		INSERT INTO City VALUES (
			p_id, 
			p_updated_at, 
			p_created_at, 
			p_state_id, 
			p_name);
		RETURN SQL%ROWCOUNT;
	EXCEPTION
		WHEN OTHERS THEN
			DBMS_OUTPUT.PUT_LINE(SQLCODE || ' - ' || SQLERRM);
			RETURN -1;
 
	END putCity;
 
-- ------ FUNCION DELETE ------
	FUNCTION delCity (p_Id IN city.id%TYPE)
	RETURN NUMBER
	IS
	BEGIN
		DELETE city
		WHERE city.id = p_Id;
		RETURN SQL%ROWCOUNT;
	EXCEPTION
		WHEN OTHERS THEN
			DBMS_OUTPUT.PUT_LINE(SQLCODE || ' - ' || SQLERRM);
			RETURN -1;
 
	END delCity;
 
-- ------ FUNCION UPDATE ------
	FUNCTION updCity (p_id IN city.id%TYPE, 
		p_updated_at IN city.updated_at%TYPE, 
		p_created_at IN city.created_at%TYPE, 
		p_state_id IN city.state_id%TYPE, 
		p_name IN city.name%TYPE)
	RETURN NUMBER
	IS
		sql_str VARCHAR(1000);
	BEGIN
		sql_str := 'UPDATE city SET '||'
			city.updated_at = '|| p_updated_at||', 
			city.created_at = '|| p_created_at||', 
			city.state_id = '|| p_state_id||', 
			city.name = '|| p_name 
		|| ' WHERE city.id = '|| p_Id;
		EXECUTE IMMEDIATE sql_str;
		RETURN SQL%ROWCOUNT;
	EXCEPTION
		WHEN OTHERS THEN
			DBMS_OUTPUT.PUT_LINE(SQLCODE || ' - ' || SQLERRM);
			RETURN -1;
 
	END updCity;
END crudCity;
/

