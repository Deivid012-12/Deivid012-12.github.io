-- =====================================================================
-- 01_setup_taller1.sql
-- Taller aplicado 1 - SQL avanzado + Transacciones (ACID) aplicado
-- Docente: Script de preparación del entorno
-- Esquema base esperado: HR
-- =====================================================================

SET SERVEROUTPUT ON
WHENEVER SQLERROR CONTINUE

PROMPT ===== Eliminando objetos previos del taller (si existen) =====

BEGIN EXECUTE IMMEDIATE 'DROP TABLE audit_salary_adjustments_t1 PURGE'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP SEQUENCE audit_salary_adj_t1_seq'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE t1_variants PURGE'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE t1_job_history PURGE'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE t1_employees PURGE'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE t1_departments PURGE'; EXCEPTION WHEN OTHERS THEN NULL; END;
/

PROMPT ===== Creando copias de trabajo del esquema HR =====

CREATE TABLE t1_departments AS
SELECT *
FROM departments;

ALTER TABLE t1_departments
  ADD CONSTRAINT pk_t1_departments PRIMARY KEY (department_id);

CREATE TABLE t1_employees AS
SELECT *
FROM employees;

ALTER TABLE t1_employees
  ADD CONSTRAINT pk_t1_employees PRIMARY KEY (employee_id);

CREATE TABLE t1_job_history AS
SELECT *
FROM job_history;

ALTER TABLE t1_job_history
  ADD CONSTRAINT pk_t1_job_history PRIMARY KEY (employee_id, start_date);

PROMPT ===== Creando tabla de auditoría =====

CREATE TABLE audit_salary_adjustments_t1 (
    audit_id               NUMBER        NOT NULL,
    execution_tag          VARCHAR2(30)  NOT NULL,
    variant_id             NUMBER        NOT NULL,
    employee_id            NUMBER        NOT NULL,
    department_id          NUMBER,
    salary_before          NUMBER(8,2)   NOT NULL,
    salary_after           NUMBER(8,2)   NOT NULL,
    pct_gap_to_avg_before  NUMBER(8,4),
    rule_applied           VARCHAR2(100) NOT NULL,
    executed_by            VARCHAR2(100) DEFAULT USER NOT NULL,
    executed_at            DATE          DEFAULT SYSDATE NOT NULL,
    notes                  VARCHAR2(400)
);

ALTER TABLE audit_salary_adjustments_t1
  ADD CONSTRAINT pk_audit_salary_adjustments_t1 PRIMARY KEY (audit_id);

CREATE SEQUENCE audit_salary_adj_t1_seq
START WITH 1
INCREMENT BY 1
NOCACHE;

PROMPT ===== Creando tabla de variantes =====

CREATE TABLE t1_variants (
    variant_id                    NUMBER       NOT NULL,
    variant_name                  VARCHAR2(80) NOT NULL,
    excluded_department_id        NUMBER,
    min_years_service             NUMBER       NOT NULL,
    recent_job_history_months     NUMBER       NOT NULL,
    gap_high_threshold_pct        NUMBER(6,2)  NOT NULL,
    gap_mid_threshold_pct         NUMBER(6,2)  NOT NULL,
    raise_high_pct                NUMBER(6,2)  NOT NULL,
    raise_mid_pct                 NUMBER(6,2)  NOT NULL,
    raise_low_pct                 NUMBER(6,2)  NOT NULL,
    max_salary_vs_avg_pct         NUMBER(6,2)  NOT NULL,
    notes                         VARCHAR2(300),
    CONSTRAINT pk_t1_variants PRIMARY KEY (variant_id)
);

INSERT INTO t1_variants VALUES
(1, 'Variante A - Operación estándar', 90, 3, 24, 10, 5, 8, 5, 3, 120,
 'Excluir depto 90. Regla base del taller.');

INSERT INTO t1_variants VALUES
(2, 'Variante B - Mayor restricción por historial', 60, 3, 18, 10, 5, 8, 5, 3, 120,
 'Excluir depto 60 y revisar historial de últimos 18 meses.');

INSERT INTO t1_variants VALUES
(3, 'Variante C - Ajuste conservador', 100, 4, 24, 12, 6, 7, 4, 2, 118,
 'Excluir depto 100. Exigir 4 años de antigüedad.');

INSERT INTO t1_variants VALUES
(4, 'Variante D - Ajuste agresivo controlado', 30, 3, 24, 9, 4, 9, 6, 3, 119,
 'Excluir depto 30. Umbrales de brecha diferentes.');

COMMIT;

PROMPT ===== Índices de apoyo para el taller =====

CREATE INDEX ix_t1_emp_dept ON t1_employees(department_id);
CREATE INDEX ix_t1_emp_mgr  ON t1_employees(manager_id);
CREATE INDEX ix_t1_jh_emp   ON t1_job_history(employee_id);

PROMPT ===== Resumen del entorno =====

SELECT 'DEPARTMENTS' objeto, COUNT(*) cantidad FROM t1_departments
UNION ALL
SELECT 'EMPLOYEES', COUNT(*) FROM t1_employees
UNION ALL
SELECT 'JOB_HISTORY', COUNT(*) FROM t1_job_history
UNION ALL
SELECT 'VARIANTS', COUNT(*) FROM t1_variants
UNION ALL
SELECT 'AUDIT_TABLE', COUNT(*) FROM audit_salary_adjustments_t1;

PROMPT ===== Setup finalizado =====
