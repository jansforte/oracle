--
-- 
--AUTHOR: JOHAN SEBASTIAN FUENTES ORTEGA
--DATE: 06/03/2021
--
-- ----------------------------------------------------------

--
-- Dar privilegios a empleado_airbnb para logearse en Airbnb
--
GRANT CREATE SESSION
TO empleado_airbnb;


-------------------------------------------------------------

--
-- Dar privilegios a empleado_airbnb para consultar la tabla usuario
--
GRANT SELECT
ON usuario
TO empleado_airbnb;

-------------------------------------------------------------

--
-- Dar privilegios a empleado_airbnb para consultar la tabla state
--
GRANT SELECT
ON state
TO empleado_airbnb;

-------------------------------------------------------------
--
-- Dar privilegios a empleado_airbnb para consultar la tabla city
--
GRANT SELECT
ON city
TO empleado_airbnb;

-------------------------------------------------------------
--
-- Dar privilegios a empleado_airbnb para consultar la tabla amenity
--
GRANT SELECT
ON amenity
TO empleado_airbnb;

-------------------------------------------------------------

--
-- Dar privilegios a empleado_airbnb para consultar la tabla place
--
GRANT SELECT
ON place
TO empleado_airbnb;

-------------------------------------------------------------

--
-- Dar privilegios a empleado_airbnb para consultar la tabla review
--
GRANT SELECT
ON review
TO empleado_airbnb;

-------------------------------------------------------------

--
-- Dar privilegios a empleado_airbnb para consultar la tabla placeamenity
--
GRANT SELECT
ON placeamenity
TO empleado_airbnb;
-- ----------------------------------------------------------

--
-- Dar privilegios a empleado_airbnb para consultar la vista Lugares
--
GRANT SELECT
ON Lugares
TO empleado_airbnb;
-- ----------------------------------------------------------

--
-- Dar privilegios a empleado_airbnb para consultar la vista review_place
--
GRANT SELECT
ON review_place
TO empleado_airbnb;
-- ----------------------------------------------------------

--
-- Dar privilegios a empleado_airbnb para consultar la vista placexamenity
--
GRANT SELECT
ON placexamenity
TO empleado_airbnb;
-- ----------------------------------------------------------

--
-- Dar privilegios a empleado_airbnb para consultar la vista amenityxplace
--
GRANT SELECT
ON amenityxplace
TO empleado_airbnb;
-- ----------------------------------------------------------