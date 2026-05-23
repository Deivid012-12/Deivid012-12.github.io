-- Sentencia para obtener el nombre, apellido, salario, 10% del salario, y el càlculo del salario por la comision
SELECT FIRST_NAME nombre, LAST_NAME AS "Apellido", SALARY AS "Salario", SALARY * 0.10 AS "10% del Salario", SALARY*COMMISSION_PCT "Salario por comision" FROM employees;
-- Asignar alias
SELECT FIRST_NAME AS "Primer Nombre" FROM employees;
-- Concatenaciòn
SELECT FIRST_NAME|| LAST_NAME AS "Employee" FROM EMPLOYEES;
SELECT FIRST_NAME || ' ' || LAST_NAME AS "Employee" FROM EMPLOYEES;
-- Quote
SELECT FIRST_NAME || q'[ ]' || LAST_NAME AS "Employee" FROM EMPLOYEES;
-- Eliminar duplicados
SELECT DISTINCT country_id FROM locations;
-- clausula where
SELECT FIRST_NAME nombre, LAST_NAME AS "Apellido", SALARY AS "Salario", SALARY * 0.10 AS "10% del Salario", SALARY*COMMISSION_PCT "Salario por comision" FROM employees WHERE department_id = '80';
-- Empleados cuyo salario sea menor a 3000

-- Usando comodín
SELECT first_name FROM employees WHERE first_name LIKE '%w%';
SELECT first_name FROM employees WHERE first_name LIKE '__m%';
SELECT * FROM employees WHERE manager_id IS NOT NULL;
SELECT * FROM employees WHERE manager_id IS NULL;

-- Usando operadores logicos 
SELECT first_name, salary FROM employees WHERE first_name = 'A%' AND salary >= '10000';
--Empleados con comision ó ganen menos de 5000 dolares
SELECT first_name, salary, commission_pct FROM employees WHERE commission_pct IS NOT NULL OR salary < '5000';

-- Usando ORDER BY
    SELECT first_name, salary
    FROM employees
    ORDER BY salary DESC;   