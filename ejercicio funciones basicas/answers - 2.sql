-----------------------------------------
--
--UNIDA CENTRAL DEL VALLE
--Author: Johan Sebastian Fuentes Ortega
--Date: 10-04-2021
--
-----------------------------------------

/*Hacemos consulta del codigo de departamento con la cantidad de empleados que traban allí.
  el comando COUNT(*) permite que se cuente los campos que son null también*/
SELECT department_id ,COUNT(*) AS cant_employee FROM employees 
					GROUP BY department_id ORDER BY department_id;

/*Obtenemos el codigo del departamento con más empleados y su cantidad.
el having es como un where donde le digo a count(*) que sea igual
al numero maximo de empleados que puede tener algun departamento*/
SELECT department_id ,COUNT(*) AS cant_employee FROM employees 
					GROUP BY department_id 
                    HAVING COUNT(*) = 
                    (SELECT MAX(COUNT(*)) FROM employees 
                                GROUP BY department_id);

/*Proyecto los departamentos con la lista de los meses en que los empleados 
cumplen aniversario de contratación.*/
SELECT DISTINCT TO_CHAR(hire_date,'Month') || ', ' ||department_id as Aniversario FROM employees;

/*Selecciono los empleados que cumplen aniversario de trabajo en el mes de mayo 
y proyecto su email, nombre, día y mes de ingreso a trabajar.*/
SELECT email, first_name, TO_CHAR(hire_date,'fmDD Month') FROM employees 
WHERE TO_CHAR(hire_date, 'MM')=03;

/*Selecciono los empleados cuyo nombre y apellido inicien por la misma 
letra y proyecto el ID, nombre y apellido todo en mayúsculas.*/
SELECT Upper(employee_id), Upper(first_name), Upper(last_name) 
FROM employees 
WHERE SUBSTR(Upper(first_name),1,1)=SUBSTR(Upper(last_name),1,1);

/*Selecciono los empleados que ingresaron a trabajar en el mismo mes del mes actual y 
proyecto un saludo*/
SELECT 'Estimado ' || Upper(first_name) || ', es para nosotros un gusto que 
hayas compartido con nosotros durante los últimos ' || TRUNC(SYSDATE-hire_date,0) 
|| ' días. Queremos expresarte que puedes contar con nosotros y que 
contamos contigo. Por favor pasa el '|| TO_CHAR(LAST_DAY(SYSDATE),'DD') || 
' por el salón principal para la reunión de celebración' as Saludo
FROM employees 
WHERE TO_CHAR(SYSDATE,'MM')=TO_CHAR(hire_date,'MM');

/*ProyectO el ID, nombre, apellido, salario y experiencia. 
La experiencia se determina en 1, 2, 3 o 4 así:
Antigüedad	Rango
[0, 5) años	1
[5, 10) años	2
[10,15) años	3
[15, ∞) años	4*/
SELECT employee_id, first_name, last_name, salary,
CASE
    WHEN TRUNC(((SYSDATE-hire_date)/360),0)<5 THEN 1
    WHEN TRUNC(((SYSDATE-hire_date)/360),0)<10 THEN 2
    WHEN TRUNC(((SYSDATE-hire_date)/360),0)<15 THEN 3
    ELSE 4
END "Experiencia"
FROM employees;

/*Determino las fechas de cumplimiento de aniversario de contratación de cada uno de los 
funcionarios. Con estas fechas presente en un listado de fechas de aniversarios de los 
empleados a ocurrir en el año inmediatamente siguiente. mostrando el ID, el nombre, 
la fecha de ingreso, la fecha en que cumplirá años y la fecha del viernes 
inmediatamente siguiente, que es el día de la celebración.*/
SELECT employee_id, first_name, hire_date, 
ADD_MONTHS(hire_date,(TO_CHAR(SYSDATE,'YYYY')-TO_CHAR(hire_date,'YYYY')+1)*12) as Next_aniv,
NEXT_DAY(
ADD_MONTHS(hire_date,(TO_CHAR(SYSDATE,'YYYY')-TO_CHAR(hire_date,'YYYY')+1)*12),
'VIERNES') as Celebracion
FROM employees;

/* Determino, para un año completo, el calendario mensual de pagos de bonificaciones por 
antigüedad a los empleados, por mes vencido.*/
SELECT *
FROM (
    SELECT
      COALESCE(TO_CHAR(dep), 'Total') dep,
      COALESCE(mes, 'Total') mes,
      sal
    FROM (
      SELECT
       Nvl(department_id,0) dep,
       to_char(ADD_MONTHS(hire_date,1), 'mm') mes,
       Sum(salary) sal
      FROM employees
      GROUP BY CUBE (Nvl(department_id,0), to_char(ADD_MONTHS(hire_date,1), 'mm'))
    )
) t
PIVOT (Sum(sal)
        FOR mes In ('01' as "01", '02' as "02", '03' as "03", '04' as "04",
                    '05' as "05", '06' as "06", '07' as "07", '08' as "08",
                    '05' as "09", '06' as "10", '07' as "11", '08' as "12"))
ORDER BY CASE dep WHEN 'Total' THEN 1 ELSE 0 END,
         CASE dep WHEN 'Total' THEN 0 ELSE To_Number(dep) END;

/*Esta consulta muestra el calendario mensual de pagos por cada departamento,
se asigna en las columnas las fechas de enero a diciembre, y en las filas los
departamentos, se hace una consulta para obtener los departamentos y los meses
y se agrupan por departamentos y meses sumando el salario de acuerdo al mes y 
al final se suma el salario por mes
*/
SELECT *
FROM (
    SELECT
      COALESCE(TO_CHAR(dep), 'Total') dep,
      COALESCE(mes, 'Total') mes,
      sal
    FROM (
      SELECT
       Nvl(department_id,0) dep,
       to_char(hire_date, 'mm') mes,
       Sum(salary) sal
      FROM employees
      GROUP BY CUBE (Nvl(department_id,0), to_char(hire_date, 'mm'))
    )
) t
PIVOT (Sum(sal)
        FOR mes In ('01' as "01", '02' as "02", '03' as "03", '04' as "04",
                    '05' as "05", '06' as "06", '07' as "07", '08' as "08",
                    '05' as "09", '06' as "10", '07' as "11", '08' as "12"))
ORDER BY CASE dep WHEN 'Total' THEN 1 ELSE 0 END,
         CASE dep WHEN 'Total' THEN 0 ELSE To_Number(dep) END;

/*Lista los empleados que trabajan en cada departamento pero los lista por apellido*/
SELECT department_id "Dept.",
       LISTAGG(last_name, ';')
       WITHIN GROUP (ORDER BY hire_date) "Employees"
FROM employees
GROUP BY department_id
ORDER BY department_id;

/*Me en listará los nombres de los empleados que trabajan en el departamento
80 y muestra su orden jerarquico respecto a su jefe, la seleccion la hace en terminos
del where y la proyección en el select */
SELECT first_name || ' ' || last_name "Employee",
    LEVEL, SYS_CONNECT_BY_PATH(last_name, '/') "Path"
FROM employees
WHERE level <= 3 AND department_id = 80
START WITH last_name = 'King'
CONNECT BY PRIOR employee_id = manager_id AND LEVEL <= 4;