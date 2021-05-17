CREATE OR REPLACE PACKAGE crud_placeamenity
IS

  FUNCTION fGetPlace(cod_place place.id%TYPE)
    RETURN place%ROWTYPE;

  FUNCTION fPutPlace(cod_place place.id%TYPE,
                    place_updated place.updated_at%TYPE,
                    place_created place.created_at%TYPE,
                    place_user    place.user_id%TYPE,
                    place_name  place.name%TYPE,
                    place_city  place.city_id%TYPE,
                    place_descrip place.description%TYPE,
                    place_numberom  place.number_rooms%TYPE,
                    place_numbath   place.number_bathrooms%TYPE,
                    place_maxgues   place.max_guest%TYPE,
                    place_price  place.price_by_night%TYPE)
    RETURN NUMBER;

  FUNCTION fDelPlace(cod_place place.id%TYPE)
    RETURN NUMBER;

  FUNCTION fUpdPlace(cod_place place.id%TYPE,
                    place_name  place.name%TYPE)
    RETURN NUMBER;



END crud_placeamenity;
/

CREATE OR REPLACE PACKAGE BODY crud_placeamenity
IS

  FUNCTION fGetPlace(cod_place place.id%TYPE)
  RETURN place%ROWTYPE
  IS
    v_place place%ROWTYPE;

  BEGIN
    SELECT * INTO v_place
    FROM   place u
    WHERE  u.id = cod_place;

    RETURN v_place;
  EXCEPTION
    WHEN No_Data_Found THEN
      Dbms_Output.put_line(SQLCODE || ' - ' || SQLERRM);
      RETURN NULL;

    WHEN OTHERS THEN
      Dbms_Output.put_line(SQLCODE || ' - ' || SQLERRM);
      RETURN NULL;

  END fGetPlace;

  FUNCTION fPutPlace(cod_place place.id%TYPE,
                    place_updated place.updated_at%TYPE,
                    place_created place.created_at%TYPE,
                    place_user    place.user_id%TYPE,
                    place_name  place.name%TYPE,
                    place_city  place.city_id%TYPE,
                    place_descrip place.description%TYPE,
                    place_numberom  place.number_rooms%TYPE,
                    place_numbath   place.number_bathrooms%TYPE,
                    place_maxgues   place.max_guest%TYPE,
                    place_price  place.price_by_night%TYPE)
  RETURN NUMBER
  IS
  BEGIN
    INSERT INTO place (id,updated_at,created_at, user_id,name,city_id,description,number_rooms,number_bathrooms,max_guest,price_by_night)
           VALUES (cod_place, place_updated, place_created,place_user,place_name,place_city,place_descrip,place_numberom,place_numbath,place_maxgues,place_price);
           
    RETURN SQL%ROWCOUNT;      
  EXCEPTION
    WHEN OTHERS THEN
      Dbms_Output.put_line(SQLCODE || ' - ' || SQLERRM);
      RETURN -1;

  END fPutPlace;

  FUNCTION fDelPlace(cod_place place.id%TYPE)
  RETURN NUMBER
  IS
  BEGIN
    DELETE place
    WHERE  id = cod_place;
           
    RETURN SQL%ROWCOUNT;      
  EXCEPTION
    WHEN OTHERS THEN
      Dbms_Output.put_line(SQLCODE || ' - ' || SQLERRM);
      RETURN -1;

  END fDelPlace;

  FUNCTION fUpdPlace(cod_place place.id%TYPE,
                    place_name  place.name%TYPE)
  RETURN NUMBER
  IS
    sql_str VARCHAR2(1000);

  BEGIN
    sql_str := 'UPDATE place SET name = '||place_name||' WHERE id = '|| cod_place;
    
    EXECUTE IMMEDIATE sql_str;
     
    RETURN SQL%ROWCOUNT;    
  EXCEPTION
    WHEN OTHERS THEN
      Dbms_Output.put_line(SQLCODE || ' - ' || SQLERRM);
      RETURN -1;

  END fUpdPlace;

END crud_placeamenity;

--Oracle Version 12.2
SELECT json_object(
    'order_id' VALUE om.user_data.order_id,
    'product_code' VALUE om.user_data.Product_code,
    'customer_id' VALUE om.user_data.Customer_id,
    'order_details' VALUE om.user_data.order_details,
    'price' VALUE om.user_data.price, 
    'region_code' VALUE om.user_data.region_code
FORMAT JSON) 
FROM orders_msg_qt om;