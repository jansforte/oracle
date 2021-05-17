--
--
-- AUTHOR: JOHAN SEBASTIAN FUENTES ORTEGA
-- DATE: 16/05/21
--
-- ----------------------------------------
CREATE OR REPLACE FUNCTION inDepartments (p_department_id IN departments.department_id%TYPE, 
	p_department_name IN departments.department_name%TYPE, 
	p_manager_id IN departments.manager_id%TYPE, 
	p_location_id IN departments.location_id%TYPE)
RETURN NUMBER
IS
	nuRetorno := 0;
BEGIN
	INSERT INTO departments
	VALUES (p_department_id, 
		p_department_name, 
		p_manager_id, 
		p_location_id);
	nuRetorno := SQL%ROWCOUNT;
	RETURN nuRetorno;
END inDepartments;

