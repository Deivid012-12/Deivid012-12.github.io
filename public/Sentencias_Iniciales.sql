-- SENTENCIAS INICIALES

-- Creación de tabla SELECCION
CREATE TABLE SELECCION (
    CODIGO_SELECCION NUMBER PRIMARY KEY,
    NOMBRE_SELECCION VARCHAR2(50)
);

-- Creación de tabla JUGADOR
CREATE TABLE JUGADOR (
    CODIGO_JUGADOR NUMBER,
    NOMBRE_JUGADOR VARCHAR2(50),
    POSICION       VARCHAR2(50),
    COD_SELECCION  NUMBER
);

--Inserción de datos--
BEGIN
    INSERT INTO JUGADOR VALUES (1,  'Adrianshow',             'Delantero', 1);
    INSERT INTO JUGADOR VALUES (2,  'Camilo Vargas',          'Guardameta', 1);
    INSERT INTO JUGADOR VALUES (3,  'David Ospina',           'Guardameta', 1);
    INSERT INTO JUGADOR VALUES (4,  'Dávinson Sánchez',       'Defensa',    1);
    INSERT INTO JUGADOR VALUES (5,  'Yerry Mina',             'Defensa',    1);
    INSERT INTO JUGADOR VALUES (6,  'Jhon Lucumí',            'Defensa',    1);
    INSERT INTO JUGADOR VALUES (7,  'Daniel Muñoz',           'Defensa',    1);
    INSERT INTO JUGADOR VALUES (8,  'Johan Mojica',           'Defensa',    1);
    INSERT INTO JUGADOR VALUES (9,  'Santiago Arias',         'Defensa',    1);
    INSERT INTO JUGADOR VALUES (10, 'Jéfferson Lerma',        'Volante',    1);
    INSERT INTO JUGADOR VALUES (11, 'Kevin Castaño',          'Volante',    1);
    INSERT INTO JUGADOR VALUES (12, 'Richard Ríos',           'Volante',    1);
    INSERT INTO JUGADOR VALUES (13, 'James Rodríguez',        'Volante',    1);
    INSERT INTO JUGADOR VALUES (14, 'Juan Fernando Quintero', 'Volante',    1);
    INSERT INTO JUGADOR VALUES (15, 'Jorge Carrascal',        'Volante',    1);
    INSERT INTO JUGADOR VALUES (16, 'Jhon Arias',             'Volante',    1);
    INSERT INTO JUGADOR VALUES (17, 'Jhon Córdoba',           'Delantero',  1);
    INSERT INTO JUGADOR VALUES (18, 'Luis Díaz',              'Delantero',  1);
    INSERT INTO JUGADOR VALUES (19, 'Luis Suárez',            'Delantero',  1);
    INSERT INTO JUGADOR VALUES (20, 'Dairo Moreno',           'Delantero',  1);
END;

--Llaves en caso tal de que no se hayan ubicado al crear la tabla--

-- Añadir llave primaria a JUGADOR
ALTER TABLE JUGADOR
ADD CONSTRAINT pk_codigoJugador
PRIMARY KEY (CODIGO_JUGADOR);

-- Añadir llave foránea a JUGADOR referenciando SELECCION
ALTER TABLE JUGADOR
ADD CONSTRAINT fk_jugador_seleccion
FOREIGN KEY (COD_SELECCION)
REFERENCES SELECCION (CODIGO_SELECCION);
