-----------------------------------------
--
--UNIDA CENTRAL DEL VALLE
--Author: Johan Sebastian Fuentes Ortega
--Date: 27-03-2021
--
-----------------------------------------

/*Se hace consulta de los datos de todas las columnas de la tabla empleados*/
SELECT * FROM employees;

/*Hacemos consulta de los empleados ordenados por nombre*/
SELECT * FROM employees 
					ORDER BY first_name, last_name;

/*Hacemos consulta de los empleados cuyo primer nombre empieza por K */
SELECT * FROM employees WHERE first_name LIKE 'K%';

/*Hacemos consulta de los empleados cuyo primer nombre empieza por K y ordenados por nombre*/
SELECT * FROM employees WHERE first_name LIKE 'K%'
					ORDER BY first_name;

/*Hacemos consulta del codigo de departamento con la cantidad de empleados que traban allí.
  el comando COUNT(*) permite que se cuente los campos que son null también*/
SELECT department_id ,COUNT(*) AS cant_employee FROM employees 
					GROUP BY department_id ORDER BY department_id;

/*HAcemos consulta para obtener el maximo numero de empleados del departamento
 con mas empleados*/
SELECT MAX(COUNT(*)) AS max_employee FROM employees 
					GROUP BY department_id;

/*obtenemos el numero y nombre del empleado y el nombre del departamento en el que trabaja*/
SELECT e.employee_id, e.first_name, d.department_name 
                FROM employees e NATURAL JOIN departments d;

/*obtenemos el numero, nombre y salario del empleado que trabaja en el departamento Sales*/
SELECT e.employee_id, e.first_name, e.salary 
                FROM employees e NATURAL JOIN departments d 
                WHERE d.department_name = 'Sales';

/*obtenemos el numero, nombre y salario del empleado que trabaja en el departamento Sales
 ordenados de mayor a menor por salario*/
SELECT e.employee_id, e.first_name, e.salary 
                FROM employees e NATURAL JOIN departments d 
                WHERE d.department_name = 'Sales' ORDER BY e.salary DESC;

------------------------------------Grado Salarial----------------------------------------
/*Como los trabajos no tienen grado salarial asignado, agrego un campo a jobs
 definiendo salary_grade tipo number y mayor que 0*/
ALTER TABLE jobs ADD salary_grade NUMBER(2) CHECK (salary_grade>0);

/*Nota: La asignación de los grados salariales que hare son ajustados al máximo
 salario que una persona puede ganar en su cargo. por ello al grado salarial 
 2021 americano le resté 14000.*/

--ASIGNACIÓN DE GRADOS SALARIALES
 UPDATE jobs SET salary_grade=1  WHERE max_salary < 5738;
 UPDATE jobs SET salary_grade=2  WHERE max_salary BETWEEN 5738 AND 8194;
 UPDATE jobs SET salary_grade=3  WHERE max_salary BETWEEN 8194 AND 10216;
 UPDATE jobs SET salary_grade=4  WHERE max_salary BETWEEN 10216 AND 13184;
 UPDATE jobs SET salary_grade=5  WHERE max_salary BETWEEN 13184 AND 16414;
 UPDATE jobs SET salary_grade=6  WHERE max_salary BETWEEN 16414 AND 19903;
 UPDATE jobs SET salary_grade=7  WHERE max_salary BETWEEN 19903 AND 23674;
 UPDATE jobs SET salary_grade=8  WHERE max_salary BETWEEN 23674 AND 27723;
 UPDATE jobs SET salary_grade=9  WHERE max_salary BETWEEN 27723 AND 32083;
 UPDATE jobs SET salary_grade=10 WHERE max_salary BETWEEN 32083 AND 36748;
 UPDATE jobs SET salary_grade=11 WHERE max_salary BETWEEN 36748 AND 41756;
 UPDATE jobs SET salary_grade=12 WHERE max_salary BETWEEN 41756 AND 52829;
 UPDATE jobs SET salary_grade=13 WHERE max_salary BETWEEN 52829 AND 65468;
 UPDATE jobs SET salary_grade=14 WHERE max_salary BETWEEN 65468 AND 79907;
 UPDATE jobs SET salary_grade=15 WHERE max_salary BETWEEN 79907 AND 96460;

 ----------------------------------------------------------------------------------------

/*obtenemos el numero, nombre, salario y grado salarial del empleado.
el campo grado_salarial, contiene los datos concatenados
del minimo y maximo salario que un empleado puede tener en su cargo*/
SELECT e.employee_id,e.first_name,e.salary,j.salary_grade 
                    FROM employees e NATURAL JOIN jobs j;

/*Obtener el codigo de departamento y el promedio del salario ordenado de mayor 
 a menor.*/
SELECT department_id, ROUND(AVG(salary),2) as promedio FROM employees 
                        GROUP BY department_id ORDER BY promedio DESC;

/*Obetener el nombre del departamento y su promedio del salario ordenado de mayor
 a menor*/
SELECT d.department_name, ROUND(AVG(e.salary),2) as promedio FROM employees e
                        INNER JOIN departments d
                        ON e.department_id = d.department_id
                        GROUP BY d.department_name ORDER BY promedio DESC;

/*Obtenemos el codigo del departamento con más empleados y su cantidad.
el having es como un where donde le digo a count(*) que sea igual
al numero maximo de empleados que puede tener algun departamento*/
SELECT department_id ,COUNT(*) AS cant_employee FROM employees 
					GROUP BY department_id 
                    HAVING COUNT(*) = 
                    (SELECT MAX(COUNT(*)) FROM employees 
                                GROUP BY department_id);

/*Obtenemos el codigo de jefe, id, nombre y nombre del departamento de los 
empleados que son jefes*/
SELECT DISTINCT jefe.employee_id, jefe.first_name, d.department_name
    FROM employees jefe, departments d
    WHERE jefe.department_id = d.department_id
    AND  jefe.employee_id IN
        (SELECT DISTINCT jefes.manager_id
         FROM employees jefes);

/*Obtenemos los empleados y la diferencia de grado salarial con respecto a su jefe*/
SELECT DISTINCT employees.employee_id, employees.first_name, jefe_grad,jobs.salary_grade, jefe_grad - jobs.salary_grade FROM employees
INNER JOIN jobs ON employees.job_id = jobs.job_id
INNER JOIN (SELECT employees.employee_id as jefe_id, employees.department_id as jefe_dep, employees.manager_id as jefe_mana, jobs.salary_grade as jefe_grad
FROM employees
INNER JOIN jobs ON employees.job_id = jobs.job_id
INNER JOIN departments ON departments.manager_id = employees.manager_id) ON employees.employee_id <> jefe_id
WHERE employees.department_id = jefe_dep and employees.manager_id <> jefe_mana ORDER BY employees.employee_id asc;

/*obtenemos el codigo y nombre del departamento sin repetirsen donde
el empleado gana mas de 3000*/
SELECT DISTINCT d.department_id, d.department_name
    FROM departments d INNER JOIN employees e
    ON d.department_id=e.department_id
    WHERE e.salary>3000 ORDER BY d.department_id;    

/*Obtener el codigo y nombre del departamento donde al menos 2 de sus
empleados ganan mas de 2500*/
SELECT DISTINCT d.department_id, d.department_name
    FROM departments d INNER JOIN (SELECT department_id as departamento 
                                   FROM employees 
                                   GROUP BY department_id 
                                   HAVING COUNT(employee_id)>2)
    ON d.department_id=departamento
    INNER JOIN employees e
    ON d.department_id=e.department_id WHERE e.salary>2500;

/*Obtenemos los empleados que ganan más que sus jefes de departamento*/
SELECT DISTINCT e1.employee_id, e1.first_name FROM employees e1 
        INNER JOIN (SELECT e.employee_id as jefe_id,
                       e.department_id as jefe_dep,
                       e.salary as jefe_salary,
                       e.manager_id as jefe_man
                     FROM employees e, departments d
				     WHERE jefe.department_id = d.department_id
				     AND  jefe.employee_id IN
				        (SELECT DISTINCT jefes.manager_id
				         FROM employees jefes))
        ON e1.employee_id <> jefe_id
        WHERE e1.department_id = jefe_dep AND e1.salary > jefe_salary AND e1.manager_id <>jefe_man
        ORDER BY e1.employee_id;

/*Obtener el numero, nombre y cantidad de empleados del departamento donde almenos
un empleado gana más de 3000*/
 SELECT d.department_id, d.department_name,cant_employee FROM departments d
 INNER JOIN (SELECT department_id as id_depart, COUNT(*) AS cant_employee FROM employees 
 NATURAL JOIN departments
 WHERE employees.salary>3000
 GROUP BY department_id) ON id_depart = d.department_id;


/*Obtenemos los departamentos todos los empleados ganan mas de 3000*/
SELECT de.department_id, de.department_name FROM departments de
 WHERE de.department_id IN
    ((SELECT DISTINCT e.department_id as departamento
        FROM employees e WHERE e.department_id IS NOT NULL) 
     MINUS   
    (SELECT DISTINCT e.department_id as departamento
        FROM employees e WHERE salary<3000));

/*Obtener los codigos y nombres de los departamentos donde todos 
los empleados ganan más de 3000 y existe almenos un jefe que gana 
más de 5000
*/
SELECT d.department_id, d.department_name
    FROM employees e, employees m, departments d
    WHERE e.department_id = d.department_id
      AND e.manager_id = m.employee_id
      AND d.department_id IN (SELECT DISTINCT jefe.department_id
                                FROM employees jefe
                                WHERE jefe.salary > 5000
                                  AND jefe.employee_id IN
                                    (SELECT DISTINCT jefes.manager_id
                                     FROM employees jefes))
     AND d.department_id IN 
                        ((SELECT DISTINCT e.department_id as departamento
                            FROM employees e WHERE e.department_id IS NOT NULL) 
                         MINUS   
                        (SELECT DISTINCT e.department_id as departamento
                            FROM employees e WHERE salary<3000))
    GROUP BY d.department_id, d.department_name;


/*Obtenemos los empleados que no trabajan en el departamento 80
 pero su salario es mayor que cualquiera de los que trabajan
 en el departamento 80, por ende se entiende como
 ningun empleado del departamento 80 gana más que ellos*/
 SELECT DISTINCT e1.employee_id, e1.first_name 
    FROM employees e1,
    (SELECT MAX(e2.salary) as salario 
        FROM employees e2 WHERE e2.department_id = 80) 
    WHERE e1.department_id <> 80 AND salario<e1.salary;