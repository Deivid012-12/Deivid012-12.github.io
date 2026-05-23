-- =====================================================================
-- 02_datos_taller1.sql
-- Taller aplicado 1 - SQL avanzado + Transacciones (ACID) aplicado
-- Docente: Datos y casos borde para endurecer el escenario
-- Requiere ejecutar previamente 01_setup_taller1.sql
-- =====================================================================

SET SERVEROUTPUT ON
WHENEVER SQLERROR EXIT SQL.SQLCODE

PROMPT ===== Ajustando datos de trabajo para el escenario del taller =====

-- 1) Departamentos adicionales para crear casos borde
INSERT INTO t1_departments (department_id, department_name, manager_id, location_id)
VALUES (280, 'Innovation Lab', 145, 1700);

INSERT INTO t1_departments (department_id, department_name, manager_id, location_id)
VALUES (290, 'Compliance Cell', 149, 1700);

-- 2) Empleados en departamento con menos de 3 activos (debe ser excluido)
INSERT INTO t1_employees (
    employee_id, first_name, last_name, email, phone_number, hire_date,
    job_id, salary, commission_pct, manager_id, department_id
) VALUES (
    301, 'Nora', 'Quintana', 'NQUINTAN', '515.123.9001', ADD_MONTHS(TRUNC(SYSDATE), -70),
    'SA_REP', 5200, .15, 149, 280
);

INSERT INTO t1_employees (
    employee_id, first_name, last_name, email, phone_number, hire_date,
    job_id, salary, commission_pct, manager_id, department_id
) VALUES (
    302, 'Pablo', 'Mena', 'PMENA', '515.123.9002', ADD_MONTHS(TRUNC(SYSDATE), -62),
    'SA_REP', 5400, .10, 149, 280
);

-- 3) Empleados en departamento de cumplimiento para crear mezcla de elegibles/no elegibles
INSERT INTO t1_employees (
    employee_id, first_name, last_name, email, phone_number, hire_date,
    job_id, salary, commission_pct, manager_id, department_id
) VALUES (
    303, 'Sara', 'Luna', 'SLUNA', '515.123.9003', ADD_MONTHS(TRUNC(SYSDATE), -85),
    'ST_CLERK', 3100, NULL, 124, 290
);

INSERT INTO t1_employees (
    employee_id, first_name, last_name, email, phone_number, hire_date,
    job_id, salary, commission_pct, manager_id, department_id
) VALUES (
    304, 'Tomas', 'Rueda', 'TRUEDA', '515.123.9004', ADD_MONTHS(TRUNC(SYSDATE), -55),
    'ST_CLERK', 3300, NULL, 124, 290
);

INSERT INTO t1_employees (
    employee_id, first_name, last_name, email, phone_number, hire_date,
    job_id, salary, commission_pct, manager_id, department_id
) VALUES (
    305, 'Valeria', 'Nieto', 'VNIETO', '515.123.9005', ADD_MONTHS(TRUNC(SYSDATE), -92),
    'ST_CLERK', 3500, NULL, 124, 290
);

INSERT INTO t1_employees (
    employee_id, first_name, last_name, email, phone_number, hire_date,
    job_id, salary, commission_pct, manager_id, department_id
) VALUES (
    306, 'Yuri', 'Mora', 'YMORA', '515.123.9006', ADD_MONTHS(TRUNC(SYSDATE), -15),
    'ST_CLERK', 2900, NULL, 124, 290
);

-- 4) Ajustes finos a salarios para construir brechas, topes y falsos positivos
UPDATE t1_employees
   SET salary = 7200
 WHERE employee_id = 176;

UPDATE t1_employees
   SET salary = 6800
 WHERE employee_id = 177;

UPDATE t1_employees
   SET salary = 6100
 WHERE employee_id = 179;

UPDATE t1_employees
   SET salary = 5900
 WHERE employee_id = 180;

UPDATE t1_employees
   SET salary = 5600
 WHERE employee_id = 181;

UPDATE t1_employees
   SET salary = 15800
 WHERE employee_id = 108;

UPDATE t1_employees
   SET salary = 16100
 WHERE employee_id = 109;

UPDATE t1_employees
   SET salary = 11800
 WHERE employee_id = 110;

UPDATE t1_employees
   SET salary = 11750
 WHERE employee_id = 111;

UPDATE t1_employees
   SET salary = 6200
 WHERE employee_id = 112;

UPDATE t1_employees
   SET salary = 6500
 WHERE employee_id = 113;

-- 5) Historial reciente para excluir empleados aunque parezcan elegibles
INSERT INTO t1_job_history (employee_id, start_date, end_date, job_id, department_id)
VALUES (176, ADD_MONTHS(TRUNC(SYSDATE), -14), ADD_MONTHS(TRUNC(SYSDATE), -8), 'SA_REP', 80);

INSERT INTO t1_job_history (employee_id, start_date, end_date, job_id, department_id)
VALUES (304, ADD_MONTHS(TRUNC(SYSDATE), -10), ADD_MONTHS(TRUNC(SYSDATE), -6), 'ST_CLERK', 290);

-- 6) Empleado sin departamento: debe descartarse
INSERT INTO t1_employees (
    employee_id, first_name, last_name, email, phone_number, hire_date,
    job_id, salary, commission_pct, manager_id, department_id
) VALUES (
    307, 'Carla', 'SinDepto', 'CSINDEP', '515.123.9007', ADD_MONTHS(TRUNC(SYSDATE), -100),
    'SA_REP', 4100, NULL, 149, NULL
);

-- 7) Manager principal con salario bajo, para que no sea seleccionado por error
UPDATE t1_employees
   SET salary = 6000
 WHERE employee_id = 149;

-- 8) Un salario muy cercano al máximo del departamento para forzar validación de tope
UPDATE t1_employees
   SET salary = 7700
 WHERE employee_id = 174;

COMMIT;

PROMPT ===== Validaciones rápidas del escenario =====

PROMPT -- Departamentos de prueba agregados
SELECT department_id, department_name
FROM t1_departments
WHERE department_id IN (280, 290)
ORDER BY department_id;

PROMPT -- Conteo por departamento de prueba
SELECT department_id, COUNT(*) total_emp
FROM t1_employees
WHERE department_id IN (280, 290)
GROUP BY department_id
ORDER BY department_id;

PROMPT -- Empleados con historial reciente sembrado
SELECT employee_id, start_date, end_date, department_id
FROM t1_job_history
WHERE employee_id IN (176, 304)
ORDER BY employee_id, start_date;

PROMPT -- Empleado sin departamento
SELECT employee_id, first_name, last_name, department_id
FROM t1_employees
WHERE employee_id = 307;

PROMPT ===== Datos del taller cargados correctamente =====
