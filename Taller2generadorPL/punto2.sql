--
--
-- AUTHOR: JOHAN SEBASTIAN FUENTES ORTEGA
-- DATE: 16/05/21
--
-- ----------------------------------------
CREATE OR REPLACE PACKAGE padDepartments
IS
	FUNCTION getDepartment_Id (p_Department_Id IN departments.department_id%TYPE)
	RETURN departments.department_id%TYPE;
 
	FUNCTION getDepartment_Name (p_Department_Id IN departments.department_id%TYPE)
	RETURN departments.department_name%TYPE;
 
	FUNCTION getManager_Id (p_Department_Id IN departments.department_id%TYPE)
	RETURN departments.manager_id%TYPE;
 
	FUNCTION getLocation_Id (p_Department_Id IN departments.department_id%TYPE)
	RETURN departments.location_id%TYPE;
 
END padDepartments;

