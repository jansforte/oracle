--
--
-- AUTHOR: JEISON ANDRES FUENTES ORTEGA
-- AUTHOR: JOHAN SEBASTIAN FUENTES ORTEGA
-- DATE: 20/05/21
--
-- ----------------------------------------
CREATE OR REPLACE PACKAGE crudAmenity
IS
	FUNCTION getAmenity (p_Id IN amenity.id%TYPE)
	RETURN amenity%ROWTYPE;
 
	FUNCTION putAmenity (p_id IN amenity.id%TYPE, 
		p_updated_at IN amenity.updated_at%TYPE, 
		p_created_at IN amenity.created_at%TYPE, 
		p_name IN amenity.name%TYPE)
	RETURN NUMBER;
 
	FUNCTION delAmenity (p_Id IN amenity.id%TYPE)
	RETURN NUMBER;
 
	FUNCTION updAmenity (p_id IN amenity.id%TYPE, 
		p_updated_at IN amenity.updated_at%TYPE, 
		p_created_at IN amenity.created_at%TYPE, 
		p_name IN amenity.name%TYPE)
	RETURN NUMBER;
 
END crudAmenity;
/
 
--
-- ----------------------------------------
--
CREATE OR REPLACE PACKAGE BODY crudAmenity
IS
 
-- ------ FUNCION SELECT ------
	FUNCTION getAmenity (p_Id IN amenity.id%TYPE)
	RETURN amenity%ROWTYPE
	IS
		v_amenity amenity%ROWTYPE;
	BEGIN
		SELECT * INTO v_amenity
		FROM amenity
		WHERE amenity.id = p_Id;
		RETURN v_amenity;
 
	EXCEPTION
		WHEN No_Data_Found THEN
			DBMS_OUTPUT.PUT_LINE(SQLCODE || ' - ' || SQLERRM);
			RETURN NULL;
 
		WHEN OTHERS THEN
			DBMS_OUTPUT.PUT_LINE(SQLCODE || ' - ' || SQLERRM);
			RETURN NULL;
 
	END getAmenity;
 
-- ------ FUNCION INSERT ------
	FUNCTION putAmenity (p_id IN amenity.id%TYPE, 
		p_updated_at IN amenity.updated_at%TYPE, 
		p_created_at IN amenity.created_at%TYPE, 
		p_name IN amenity.name%TYPE)
	RETURN NUMBER
	IS
	BEGIN
		INSERT INTO Amenity VALUES (
			p_id, 
			p_updated_at, 
			p_created_at, 
			p_name);
		RETURN SQL%ROWCOUNT;
	EXCEPTION
		WHEN OTHERS THEN
			DBMS_OUTPUT.PUT_LINE(SQLCODE || ' - ' || SQLERRM);
			RETURN -1;
 
	END putAmenity;
 
-- ------ FUNCION DELETE ------
	FUNCTION delAmenity (p_Id IN amenity.id%TYPE)
	RETURN NUMBER
	IS
	BEGIN
		DELETE amenity
		WHERE amenity.id = p_Id;
		RETURN SQL%ROWCOUNT;
	EXCEPTION
		WHEN OTHERS THEN
			DBMS_OUTPUT.PUT_LINE(SQLCODE || ' - ' || SQLERRM);
			RETURN -1;
 
	END delAmenity;
 
-- ------ FUNCION UPDATE ------
	FUNCTION updAmenity (p_id IN amenity.id%TYPE, 
		p_updated_at IN amenity.updated_at%TYPE, 
		p_created_at IN amenity.created_at%TYPE, 
		p_name IN amenity.name%TYPE)
	RETURN NUMBER
	IS
		sql_str VARCHAR(1000);
	BEGIN
		sql_str := 'UPDATE amenity SET '||'
			amenity.updated_at = '|| p_updated_at||', 
			amenity.created_at = '|| p_created_at||', 
			amenity.name = '|| p_name 
		|| ' WHERE amenity.id = '|| p_Id;
		EXECUTE IMMEDIATE sql_str;
		RETURN SQL%ROWCOUNT;
	EXCEPTION
		WHEN OTHERS THEN
			DBMS_OUTPUT.PUT_LINE(SQLCODE || ' - ' || SQLERRM);
			RETURN -1;
 
	END updAmenity;
END crudAmenity;
/

