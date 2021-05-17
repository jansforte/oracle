--
-- 
--JOHAN SEBASTIAN FUENTES ORTEGA
--DATE: 24/04/2021
--

-- ----------------------------------------------------------
/*Paquete de servicios – actualización de salario*/
CREATE OR REPLACE PACKAGE servicios
IS

/*
  En el paquete como tal podemos definir las variables publicas y funciones
  que queremos llamar que estan en el cuerpo del paquete
  */

  PROCEDURE pActSal (p_deptno emp.deptno%TYPE,
                     p_incremento NUMBER);
END servicios;
/

CREATE OR REPLACE PACKAGE BODY servicios
IS

  /*
  en el cuerpo del paquete definimos variables y funciones privados
  */
  PROCEDURE pActSal(p_deptno emp.deptno%TYPE,
                    p_incremento NUMBER)
  IS
    CURSOR cu_emp (v_deptno emp.deptno%TYPE)
    IS
      SELECT *
      FROM   emp e
      WHERE  e.deptno = v_deptno;

    rango NUMBER;

  BEGIN
    FOR recu_emp IN cu_emp(p_deptno) LOOP

      SELECT sg.grade INTO rango
      FROM   salgrade sg
      WHERE  recu_emp.sal >= sg.losal AND recu_emp.sal <= sg.hisal;

      IF rango <> 2 THEN
        UPDATE emp
        SET    sal = sal * (1 + p_incremento)
        WHERE  empno = recu_emp.empno;
      END IF;

    END LOOP;
    
  END;
END servicios;
/