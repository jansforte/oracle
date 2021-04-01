--
-- 
--AUTHOR: JOHAN SEBASTIAN FUENTES ORTEGA
--DATE: 06/03/2021
--
-- ----------------------------------------------------------

/*Dar privilegios como ADMIN PARA MANEJAR LA BASE DE DATOS*/
GRANT 	create session, create table,
		create sequence, create view
TO		airbnb
WITH	ADMIN OPTION;

-- ----------------------------------------------------------