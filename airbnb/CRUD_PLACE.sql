--
--
-- AUTHOR: JEISON ANDRES FUENTES ORTEGA
-- AUTHOR: JOHAN SEBASTIAN FUENTES ORTEGA
-- DATE: 20/05/21
--
-- ----------------------------------------
CREATE OR REPLACE PACKAGE crudPlace
IS
	FUNCTION getPlace (p_Id IN place.id%TYPE)
	RETURN place%ROWTYPE;
 
	FUNCTION putPlace (p_id IN place.id%TYPE, 
		p_updated_at IN place.updated_at%TYPE, 
		p_created_at IN place.created_at%TYPE, 
		p_user_id IN place.user_id%TYPE, 
		p_name IN place.name%TYPE, 
		p_city_id IN place.city_id%TYPE, 
		p_description IN place.description%TYPE, 
		p_number_rooms IN place.number_rooms%TYPE, 
		p_number_bathrooms IN place.number_bathrooms%TYPE, 
		p_max_guest IN place.max_guest%TYPE, 
		p_price_by_night IN place.price_by_night%TYPE, 
		p_latitud IN place.latitud%TYPE, 
		p_longitude IN place.longitude%TYPE)
	RETURN NUMBER;
 
	FUNCTION delPlace (p_Id IN place.id%TYPE)
	RETURN NUMBER;
 
	FUNCTION updPlace (p_id IN place.id%TYPE, 
		p_updated_at IN place.updated_at%TYPE, 
		p_created_at IN place.created_at%TYPE, 
		p_user_id IN place.user_id%TYPE, 
		p_name IN place.name%TYPE, 
		p_city_id IN place.city_id%TYPE, 
		p_description IN place.description%TYPE, 
		p_number_rooms IN place.number_rooms%TYPE, 
		p_number_bathrooms IN place.number_bathrooms%TYPE, 
		p_max_guest IN place.max_guest%TYPE, 
		p_price_by_night IN place.price_by_night%TYPE, 
		p_latitud IN place.latitud%TYPE, 
		p_longitude IN place.longitude%TYPE)
	RETURN NUMBER;
 
END crudPlace;
/
 
--
-- ----------------------------------------
--
CREATE OR REPLACE PACKAGE BODY crudPlace
IS
 
-- ------ FUNCION SELECT ------
	FUNCTION getPlace (p_Id IN place.id%TYPE)
	RETURN place%ROWTYPE
	IS
		v_place place%ROWTYPE;
	BEGIN
		SELECT * INTO v_place
		FROM place
		WHERE place.id = p_Id;
		RETURN v_place;
 
	EXCEPTION
		WHEN No_Data_Found THEN
			DBMS_OUTPUT.PUT_LINE(SQLCODE || ' - ' || SQLERRM);
			RETURN NULL;
 
		WHEN OTHERS THEN
			DBMS_OUTPUT.PUT_LINE(SQLCODE || ' - ' || SQLERRM);
			RETURN NULL;
 
	END getPlace;
 
-- ------ FUNCION INSERT ------
	FUNCTION putPlace (p_id IN place.id%TYPE, 
		p_updated_at IN place.updated_at%TYPE, 
		p_created_at IN place.created_at%TYPE, 
		p_user_id IN place.user_id%TYPE, 
		p_name IN place.name%TYPE, 
		p_city_id IN place.city_id%TYPE, 
		p_description IN place.description%TYPE, 
		p_number_rooms IN place.number_rooms%TYPE, 
		p_number_bathrooms IN place.number_bathrooms%TYPE, 
		p_max_guest IN place.max_guest%TYPE, 
		p_price_by_night IN place.price_by_night%TYPE, 
		p_latitud IN place.latitud%TYPE, 
		p_longitude IN place.longitude%TYPE)
	RETURN NUMBER
	IS
	BEGIN
		INSERT INTO Place VALUES (
			p_id, 
			p_updated_at, 
			p_created_at, 
			p_user_id, 
			p_name, 
			p_city_id, 
			p_description, 
			p_number_rooms, 
			p_number_bathrooms, 
			p_max_guest, 
			p_price_by_night, 
			p_latitud, 
			p_longitude);
		RETURN SQL%ROWCOUNT;
	EXCEPTION
		WHEN OTHERS THEN
			DBMS_OUTPUT.PUT_LINE(SQLCODE || ' - ' || SQLERRM);
			RETURN -1;
 
	END putPlace;
 
-- ------ FUNCION DELETE ------
	FUNCTION delPlace (p_Id IN place.id%TYPE)
	RETURN NUMBER
	IS
	BEGIN
		DELETE place
		WHERE place.id = p_Id;
		RETURN SQL%ROWCOUNT;
	EXCEPTION
		WHEN OTHERS THEN
			DBMS_OUTPUT.PUT_LINE(SQLCODE || ' - ' || SQLERRM);
			RETURN -1;
 
	END delPlace;
 
-- ------ FUNCION UPDATE ------
	FUNCTION updPlace (p_id IN place.id%TYPE, 
		p_updated_at IN place.updated_at%TYPE, 
		p_created_at IN place.created_at%TYPE, 
		p_user_id IN place.user_id%TYPE, 
		p_name IN place.name%TYPE, 
		p_city_id IN place.city_id%TYPE, 
		p_description IN place.description%TYPE, 
		p_number_rooms IN place.number_rooms%TYPE, 
		p_number_bathrooms IN place.number_bathrooms%TYPE, 
		p_max_guest IN place.max_guest%TYPE, 
		p_price_by_night IN place.price_by_night%TYPE, 
		p_latitud IN place.latitud%TYPE, 
		p_longitude IN place.longitude%TYPE)
	RETURN NUMBER
	IS
		sql_str VARCHAR(1000);
	BEGIN
		sql_str := 'UPDATE place SET '||'
			place.updated_at = '|| p_updated_at||', 
			place.created_at = '|| p_created_at||', 
			place.user_id = '|| p_user_id||', 
			place.name = '|| p_name||', 
			place.city_id = '|| p_city_id||', 
			place.description = '|| p_description||', 
			place.number_rooms = '|| p_number_rooms||', 
			place.number_bathrooms = '|| p_number_bathrooms||', 
			place.max_guest = '|| p_max_guest||', 
			place.price_by_night = '|| p_price_by_night||', 
			place.latitud = '|| p_latitud||', 
			place.longitude = '|| p_longitude 
		|| ' WHERE place.id = '|| p_Id;
		EXECUTE IMMEDIATE sql_str;
		RETURN SQL%ROWCOUNT;
	EXCEPTION
		WHEN OTHERS THEN
			DBMS_OUTPUT.PUT_LINE(SQLCODE || ' - ' || SQLERRM);
			RETURN -1;
 
	END updPlace;
END crudPlace;
/

