--
--
-- AUTHOR: JEISON ANDRES FUENTES ORTEGA
-- AUTHOR: JOHAN SEBASTIAN FUENTES ORTEGA
-- DATE: 20/05/21
--
-- ----------------------------------------
CREATE OR REPLACE PACKAGE crudPlaceamenity
IS
	FUNCTION getPlaceamenity (p_ IN placeamenity.%TYPE)
	RETURN placeamenity%ROWTYPE;
 
	FUNCTION putPlaceamenity (p_amenity_id IN placeamenity.amenity_id%TYPE, 
		p_place_id IN placeamenity.place_id%TYPE)
	RETURN NUMBER;
 
	FUNCTION delPlaceamenity (p_ IN placeamenity.%TYPE)
	RETURN NUMBER;
 
	FUNCTION updPlaceamenity (p_amenity_id IN placeamenity.amenity_id%TYPE, 
		p_place_id IN placeamenity.place_id%TYPE)
	RETURN NUMBER;
 
END crudPlaceamenity;
/
 
--
-- ----------------------------------------
--
CREATE OR REPLACE PACKAGE BODY crudPlaceamenity
IS
 
-- ------ FUNCION SELECT ------
	FUNCTION getPlaceamenity (p_ IN placeamenity.%TYPE)
	RETURN placeamenity%ROWTYPE
	IS
		v_placeamenity placeamenity%ROWTYPE;
	BEGIN
		SELECT * INTO v_placeamenity
		FROM placeamenity
		WHERE placeamenity. = p_;
		RETURN v_placeamenity;
 
	EXCEPTION
		WHEN No_Data_Found THEN
			DBMS_OUTPUT.PUT_LINE(SQLCODE || ' - ' || SQLERRM);
			RETURN NULL;
 
		WHEN OTHERS THEN
			DBMS_OUTPUT.PUT_LINE(SQLCODE || ' - ' || SQLERRM);
			RETURN NULL;
 
	END getPlaceamenity;
 
-- ------ FUNCION INSERT ------
	FUNCTION putPlaceamenity (p_amenity_id IN placeamenity.amenity_id%TYPE, 
		p_place_id IN placeamenity.place_id%TYPE)
	RETURN NUMBER
	IS
	BEGIN
		INSERT INTO Placeamenity VALUES (
			p_amenity_id, 
			p_place_id);
		RETURN SQL%ROWCOUNT;
	EXCEPTION
		WHEN OTHERS THEN
			DBMS_OUTPUT.PUT_LINE(SQLCODE || ' - ' || SQLERRM);
			RETURN -1;
 
	END putPlaceamenity;
 
-- ------ FUNCION DELETE ------
	FUNCTION delPlaceamenity (p_ IN placeamenity.%TYPE)
	RETURN NUMBER
	IS
	BEGIN
		DELETE placeamenity
		WHERE placeamenity. = p_;
		RETURN SQL%ROWCOUNT;
	EXCEPTION
		WHEN OTHERS THEN
			DBMS_OUTPUT.PUT_LINE(SQLCODE || ' - ' || SQLERRM);
			RETURN -1;
 
	END delPlaceamenity;
 
-- ------ FUNCION UPDATE ------
	FUNCTION updPlaceamenity (p_amenity_id IN placeamenity.amenity_id%TYPE, 
		p_place_id IN placeamenity.place_id%TYPE)
	RETURN NUMBER
	IS
		sql_str VARCHAR(1000);
	BEGIN
		sql_str := 'UPDATE placeamenity SET '||'
			placeamenity.place_id = '|| p_place_id 
		|| ' WHERE placeamenity. = '|| p_;
		EXECUTE IMMEDIATE sql_str;
		RETURN SQL%ROWCOUNT;
	EXCEPTION
		WHEN OTHERS THEN
			DBMS_OUTPUT.PUT_LINE(SQLCODE || ' - ' || SQLERRM);
			RETURN -1;
 
	END updPlaceamenity;
END crudPlaceamenity;
/

