--
-- 
--AUTHOR: JOHAN SEBASTIAN FUENTES ORTEGA
--DATE: 06/03/2021
--
-- ----------------------------------------------------------

--
--Vista de los place x amenity
--
CREATE OR REPLACE VIEW placexamenity
AS SELECT place.*, amenity.* 
      FROM((placeamenity INNER JOIN place ON placeamenity.place_id = place.id)
      INNER JOIN amenity ON placeamenity.amenity_id = amenity.id)
WITH READ ONLY;
