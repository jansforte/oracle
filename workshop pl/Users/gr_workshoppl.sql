--
-- 
--AUTHOR: JOHAN SEBASTIAN FUENTES ORTEGA
--DATE: 24/04/2021
--
-- ----------------------------------------------------------

/*Dar privilegios como ADMIN PARA MANEJAR LA BASE DE DATOS*/
GRANT 	create session, create table,
		create sequence, create view,
		create procedure, create trigger
TO		ejercicio1
WITH	ADMIN OPTION;

-- ----------------------------------------------------------