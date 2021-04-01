--
-- 
--AUTHOR: JOHAN SEBASTIAN FUENTES ORTEGA
--DATE: 06/03/2021
--
-- ----------------------------------------------------------

--
-- Creación de la vista review_place
-- ----------------------------------------------------------
 CREATE OR REPLACE VIEW review_place
 AS SELECT review.*,place.name as place,usuario.email as usuario_email 
      FROM((review INNER JOIN place ON review.place_id = place.id)
      INNER JOIN usuario ON review.user_id = usuario.id)
 WITH READ ONLY;