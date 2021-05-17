CREATE OR REPLACE PACKAGE crud_review
IS

  FUNCTION fGetReview(cod_review review.id%TYPE)
    RETURN review%ROWTYPE;

  FUNCTION fPutReview(cod_review review.id%TYPE,
                    review_updated review.updated_at%TYPE,
                    review_created review.created_at%TYPE,
                    review_user  review.user_id%TYPE,
                    review_place  review.place_id%TYPE,
                    review_text  review.text%TYPE)
    RETURN NUMBER;

  FUNCTION fDelReview(cod_review review.id%TYPE)
    RETURN NUMBER;

  FUNCTION fUpdReview(cod_review review.id%TYPE,
                    review_text  review.text%TYPE)
    RETURN NUMBER;



END crud_review;
/

CREATE OR REPLACE PACKAGE BODY crud_review
IS

  FUNCTION fGetReview(cod_review review.id%TYPE)
  RETURN review%ROWTYPE
  IS
    v_review review%ROWTYPE;

  BEGIN
    SELECT * INTO v_review
    FROM   review u
    WHERE  u.id = cod_review;

    RETURN v_review;
  EXCEPTION
    WHEN No_Data_Found THEN
      Dbms_Output.put_line(SQLCODE || ' - ' || SQLERRM);
      RETURN NULL;

    WHEN OTHERS THEN
      Dbms_Output.put_line(SQLCODE || ' - ' || SQLERRM);
      RETURN NULL;

  END fGetReview;

  FUNCTION fPutReview(cod_review review.id%TYPE,
                    review_updated review.updated_at%TYPE,
                    review_created review.created_at%TYPE,
                    review_user  review.user_id%TYPE,
                    review_place  review.place_id%TYPE,
                    review_text  review.text%TYPE)
  RETURN NUMBER
  IS
  BEGIN
    INSERT INTO review (id,updated_at,created_at, user_id,place_id,text)
           VALUES (cod_state, review_updated, review_created,review_user,review_place,review_text);
           
    RETURN SQL%ROWCOUNT;      
  EXCEPTION
    WHEN OTHERS THEN
      Dbms_Output.put_line(SQLCODE || ' - ' || SQLERRM);
      RETURN -1;

  END fPutReview;

  FUNCTION fDelReview(cod_review review.id%TYPE)
  RETURN NUMBER
  IS
  BEGIN
    DELETE review
    WHERE  id = cod_review;
           
    RETURN SQL%ROWCOUNT;      
  EXCEPTION
    WHEN OTHERS THEN
      Dbms_Output.put_line(SQLCODE || ' - ' || SQLERRM);
      RETURN -1;

  END fDelReview;

  FUNCTION fUpdReview(cod_review review.id%TYPE,
                    review_text  review.text%TYPE)
  RETURN NUMBER
  IS
    sql_str VARCHAR2(1000);

  BEGIN
    sql_str := 'UPDATE review SET text = '||review_text||' WHERE id = '|| cod_review;
    
    EXECUTE IMMEDIATE sql_str;
     
    RETURN SQL%ROWCOUNT;    
  EXCEPTION
    WHEN OTHERS THEN
      Dbms_Output.put_line(SQLCODE || ' - ' || SQLERRM);
      RETURN -1;

  END fUpdReview;

END crud_review;