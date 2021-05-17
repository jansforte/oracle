--
--
-- AUTHOR: JOHAN SEBASTIAN FUENTES ORTEGA
-- DATE: 16/05/21
--
-- ----------------------------------------
CREATE OR REPLACE PACKAGE BODY padDepartments
IS
	FUNCTION getDepartment_Id (p_Department_Id IN departments.department_id%TYPE)
	RETURN departments.department_id%TYPE
	IS
		v_DEPARTMENT_ID departments.department_id%TYPE;
 
	BEGIN
		SELECT departments.department_id INTO v_DEPARTMENT_ID
		FROM departments
		WHERE departments.department_id = p_Department_Id;
 
		RETURN v_DEPARTMENT_ID;
	EXCEPTION
		WHEN No_Data_Found THEN
			DBMS_OUTPUT.PUT_LINE(SQLCODE || ' - ' || SQLERRM);
			RETURN NULL;
 
		WHEN OTHERS THEN
			DBMS_OUTPUT.PUT_LINE(SQLCODE || ' - ' || SQLERRM);
			RETURN NULL;
 
	END getDepartment_Id;
 
	FUNCTION getDepartment_Name (p_Department_Id IN departments.department_id%TYPE)
	RETURN departments.department_name%TYPE
	IS
		v_DEPARTMENT_NAME departments.department_name%TYPE;
 
	BEGIN
		SELECT departments.department_name INTO v_DEPARTMENT_NAME
		FROM departments
		WHERE departments.department_id = p_Department_Id;
 
		RETURN v_DEPARTMENT_NAME;
	EXCEPTION
		WHEN No_Data_Found THEN
			DBMS_OUTPUT.PUT_LINE(SQLCODE || ' - ' || SQLERRM);
			RETURN NULL;
 
		WHEN OTHERS THEN
			DBMS_OUTPUT.PUT_LINE(SQLCODE || ' - ' || SQLERRM);
			RETURN NULL;
 
	END getDepartment_Name;
 
	FUNCTION getManager_Id (p_Department_Id IN departments.department_id%TYPE)
	RETURN departments.manager_id%TYPE
	IS
		v_MANAGER_ID departments.manager_id%TYPE;
 
	BEGIN
		SELECT departments.manager_id INTO v_MANAGER_ID
		FROM departments
		WHERE departments.department_id = p_Department_Id;
 
		RETURN v_MANAGER_ID;
	EXCEPTION
		WHEN No_Data_Found THEN
			DBMS_OUTPUT.PUT_LINE(SQLCODE || ' - ' || SQLERRM);
			RETURN NULL;
 
		WHEN OTHERS THEN
			DBMS_OUTPUT.PUT_LINE(SQLCODE || ' - ' || SQLERRM);
			RETURN NULL;
 
	END getManager_Id;
 
	FUNCTION getLocation_Id (p_Department_Id IN departments.department_id%TYPE)
	RETURN departments.location_id%TYPE
	IS
		v_LOCATION_ID departments.location_id%TYPE;
 
	BEGIN
		SELECT departments.location_id INTO v_LOCATION_ID
		FROM departments
		WHERE departments.department_id = p_Department_Id;
 
		RETURN v_LOCATION_ID;
	EXCEPTION
		WHEN No_Data_Found THEN
			DBMS_OUTPUT.PUT_LINE(SQLCODE || ' - ' || SQLERRM);
			RETURN NULL;
 
		WHEN OTHERS THEN
			DBMS_OUTPUT.PUT_LINE(SQLCODE || ' - ' || SQLERRM);
			RETURN NULL;
 
	END getLocation_Id;
 
END padDepartments;

