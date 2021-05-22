--
--
-- AUTHOR: JEISON ANDRES FUENTES ORTEGA
-- AUTHOR: JOHAN SEBASTIAN FUENTES ORTEGA
-- DATE: 20/05/21
--
-- ----------------------------------------
CREATE OR REPLACE PACKAGE crudReview
IS
	FUNCTION getReview (p_Id IN review.id%TYPE)
	RETURN review%ROWTYPE;
 
	FUNCTION putReview (p_id IN review.id%TYPE, 
		p_updated_at IN review.updated_at%TYPE, 
		p_created_at IN review.created_at%TYPE, 
		p_user_id IN review.user_id%TYPE, 
		p_place_id IN review.place_id%TYPE, 
		p_text IN review.text%TYPE)
	RETURN NUMBER;
 
	FUNCTION delReview (p_Id IN review.id%TYPE)
	RETURN NUMBER;
 
	FUNCTION updReview (p_id IN review.id%TYPE, 
		p_updated_at IN review.updated_at%TYPE, 
		p_created_at IN review.created_at%TYPE, 
		p_user_id IN review.user_id%TYPE, 
		p_place_id IN review.place_id%TYPE, 
		p_text IN review.text%TYPE)
	RETURN NUMBER;
 
END crudReview;
/
 
--
-- ----------------------------------------
--
CREATE OR REPLACE PACKAGE BODY crudReview
IS
 
-- ------ FUNCION SELECT ------
	FUNCTION getReview (p_Id IN review.id%TYPE)
	RETURN review%ROWTYPE
	IS
		v_review review%ROWTYPE;
	BEGIN
		SELECT * INTO v_review
		FROM review
		WHERE review.id = p_Id;
		RETURN v_review;
 
	EXCEPTION
		WHEN No_Data_Found THEN
			DBMS_OUTPUT.PUT_LINE(SQLCODE || ' - ' || SQLERRM);
			RETURN NULL;
 
		WHEN OTHERS THEN
			DBMS_OUTPUT.PUT_LINE(SQLCODE || ' - ' || SQLERRM);
			RETURN NULL;
 
	END getReview;
 
-- ------ FUNCION INSERT ------
	FUNCTION putReview (p_id IN review.id%TYPE, 
		p_updated_at IN review.updated_at%TYPE, 
		p_created_at IN review.created_at%TYPE, 
		p_user_id IN review.user_id%TYPE, 
		p_place_id IN review.place_id%TYPE, 
		p_text IN review.text%TYPE)
	RETURN NUMBER
	IS
	BEGIN
		INSERT INTO Review VALUES (
			p_id, 
			p_updated_at, 
			p_created_at, 
			p_user_id, 
			p_place_id, 
			p_text);
		RETURN SQL%ROWCOUNT;
	EXCEPTION
		WHEN OTHERS THEN
			DBMS_OUTPUT.PUT_LINE(SQLCODE || ' - ' || SQLERRM);
			RETURN -1;
 
	END putReview;
 
-- ------ FUNCION DELETE ------
	FUNCTION delReview (p_Id IN review.id%TYPE)
	RETURN NUMBER
	IS
	BEGIN
		DELETE review
		WHERE review.id = p_Id;
		RETURN SQL%ROWCOUNT;
	EXCEPTION
		WHEN OTHERS THEN
			DBMS_OUTPUT.PUT_LINE(SQLCODE || ' - ' || SQLERRM);
			RETURN -1;
 
	END delReview;
 
-- ------ FUNCION UPDATE ------
	FUNCTION updReview (p_id IN review.id%TYPE, 
		p_updated_at IN review.updated_at%TYPE, 
		p_created_at IN review.created_at%TYPE, 
		p_user_id IN review.user_id%TYPE, 
		p_place_id IN review.place_id%TYPE, 
		p_text IN review.text%TYPE)
	RETURN NUMBER
	IS
		sql_str VARCHAR(1000);
	BEGIN
		sql_str := 'UPDATE review SET '||'
			review.updated_at = '|| p_updated_at||', 
			review.created_at = '|| p_created_at||', 
			review.user_id = '|| p_user_id||', 
			review.place_id = '|| p_place_id||', 
			review.text = '|| p_text 
		|| ' WHERE review.id = '|| p_Id;
		EXECUTE IMMEDIATE sql_str;
		RETURN SQL%ROWCOUNT;
	EXCEPTION
		WHEN OTHERS THEN
			DBMS_OUTPUT.PUT_LINE(SQLCODE || ' - ' || SQLERRM);
			RETURN -1;
 
	END updReview;
END crudReview;
/

