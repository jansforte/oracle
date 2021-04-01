--
-- 
--AUTHOR: JOHAN SEBASTIAN FUENTES ORTEGA
--DATE: 06/03/2021
--
-- ----------------------------------------------------------

--
-- Creación de la vista Lugares
-- ----------------------------------------------------------
CREATE OR REPLACE VIEW Lugares
AS SELECT place.name as place, city.name as city, state.name as state  
      FROM((city INNER JOIN place ON city.id = place.city_id)
      INNER JOIN state ON city.state_id = state.id)
WITH READ ONLY;