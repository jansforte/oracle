--
-- 
--JOHAN SEBASTIAN FUENTES ORTEGA
--DATE: 24/04/2021
--

-- ----------------------------------------------------------
/*ACTUALIZAR NOMBRE*/
-- Modo 1
DECLARE
 filas NUMBER;
 FUNCTION actualizador_nombre(nombre VARCHAR2, codigo NUMBER) 
 RETURN NUMBER IS 
 	sentencia_sql VARCHAR2(1000);
 	BEGIN
 		sentencia_sql := 'UPDATE emp SET ename = '||''''||nombre||''' WHERE empno = '||codigo;
 		EXECUTE IMMEDIATE sentencia_sql;
 		RETURN SQL%ROWCOUNT;
 	END actualizador_nombre;
BEGIN
	filas := actualizador_nombre('Oracio',7876);
	dbms_output.put_line(TO_CHAR(filas));
END;

--Modo 2
DECLARE
 filas NUMBER;
 FUNCTION actualizador_nombre(nombre VARCHAR2, codigo NUMBER) 
 RETURN NUMBER IS 
 	sentencia_sql VARCHAR2(1000);
 	BEGIN
 		sentencia_sql := 'UPDATE emp SET ename = :nuevo_nombre WHERE empno = :nuevo_codigo';
 		EXECUTE IMMEDIATE sentencia_sql USING nombre, codigo;
 		RETURN SQL%ROWCOUNT;
 	END actualizador_nombre;
BEGIN
	filas := actualizador_nombre('Jordan',7876);
	dbms_output.put_line(TO_CHAR(filas));
END;