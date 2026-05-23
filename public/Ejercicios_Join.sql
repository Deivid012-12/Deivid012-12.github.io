SELECT COUNT(*) AS total_registros FROM EMPLOYEES;
SELECT COUNT(*) AS total_registros FROM DEPARTMENTS;

-- INNER JOIN
-- Retorna únicamente las filas que tienen coincidencia en ambas tablas. Si un empleado no tiene departamento asignado, 
-- o un departamento no tiene empleados, esas filas no aparecen.
-- ¿Cuándo usarlo? Cuando solo te interesan los registros que existen en ambas tablas.
-- Muestra solo los empleados que tienen departamento asignado.
SELECT e.first_name, e.last_name, d.department_name
FROM employees e
INNER JOIN departments d ON e.department_id = d.department_id;

-- LEFT JOIN (= LEFT OUTER JOIN)
-- Retorna todas las filas de la tabla izquierda (la que está antes del JOIN), y las coincidencias de la derecha. 
-- Si no hay coincidencia, las columnas de la tabla derecha aparecen como NULL.
-- ¿Cuándo usarlo? Cuando quieres todos los registros de la tabla principal sin importar si tienen o no relación con la otra.
-- Muestra todos los empleados. Los que no tienen departamento tendrán NULL en department_name.
SELECT e.first_name, e.last_name, d.department_name
FROM employees e
LEFT JOIN departments d ON e.department_id = d.department_id;



--  RIGHT JOIN (= RIGHT OUTER JOIN)
-- Es el espejo del LEFT JOIN. Retorna todas las filas de la tabla derecha y las coincidencias de la izquierda. 
-- Las columnas de la tabla izquierda sin coincidencia aparecen como NULL.
-- ¿Cuándo usarlo? Mismo concepto que LEFT JOIN pero priorizando la tabla de la derecha. En la práctica, se prefiere reescribir como LEFT JOIN invirtiendo el orden de las tablas.
-- Muestra todos los departamentos. Los que no tienen empleados tendrán NULL en first_name y last_name.
SELECT e.first_name, e.last_name, d.department_name
FROM employees e
RIGHT JOIN departments d ON e.department_id = d.department_id;

-- FULL OUTER JOIN (= FULL JOIN)
-- Combina LEFT y RIGHT JOIN. Retorna todas las filas de ambas tablas. Donde no hay coincidencia, pone NULL en las columnas que faltan.
-- ¿Cuándo usarlo? Cuando quieres ver todos los registros de ambas tablas, incluyendo los "huérfanos" de cada lado.
-- Muestra todos los empleados Y todos los departamentos, con NULL donde no haya coincidencia.
SELECT e.first_name, e.last_name, d.department_name
FROM employees e
FULL OUTER JOIN departments d ON e.department_id = d.department_id;

-- CROSS JOIN
-- Genera el producto cartesiano: cada fila de la tabla A se combina con cada fila de la tabla B. Si A tiene 10 filas y B tiene 5, el resultado tiene 50 filas.
-- ¿Cuándo usarlo? Casos específicos como generar combinaciones, calendarios, o matrices de prueba. Raramente se usa en producción sin un WHERE que lo filtre.
-- Genera todas las combinaciones posibles de empleados con todos los tipos de trabajo (107 empleados × 19 jobs = 2,033 filas).
SELECT e.first_name, j.job_title
FROM employees e
CROSS JOIN jobs j;

-- NATURAL JOIN
-- Es un INNER JOIN automático: Oracle busca por su cuenta todas las columnas que tienen el mismo nombre 
--en ambas tablas y las usa como condición de unión. No necesitas escribir el ON.
-- ¿Cuándo usarlo? Solo cuando las tablas están bien diseñadas y las columnas compartidas son exactamente las que quieres unir. 
-- En la práctica se evita porque es frágil — si alguien agrega una columna con el mismo nombre en ambas tablas, el JOIN cambia de comportamiento sin advertencia.
-- Oracle detecta automáticamente que department_id existe en ambas tablas y lo usa como condición de unión.
SELECT first_name, last_name, department_name
FROM employees
NATURAL JOIN departments;

-- Traer nombre del empleado, y traer nombre del departamento, cuando es el departamento 80
SELECT *
FROM EMPLOYEES INNER JOIN DEPARTMENTS 
ON EMPLOYEES.department_id=DEPARTMENTS.department_id
WHERE DEPARTMENTS.department_id = 80;

-- Traer todos los empleados y todos los departamentos
SELECT first_name, department_name
FROM EMPLOYEES LEFT JOIN DEPARTMENTS 
ON EMPLOYEES.department_id=DEPARTMENTS.department_id AND EMPLOYEES.department_id IS NULL;


SELECT first_name, department_name
FROM EMPLOYEES FULL OUTER JOIN DEPARTMENTS 
ON EMPLOYEES.department_id=DEPARTMENTS.department_id;

