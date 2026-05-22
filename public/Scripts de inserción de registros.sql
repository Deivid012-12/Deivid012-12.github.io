

USE ddeli;

SET FOREIGN_KEY_CHECKS = 0;


INSERT INTO `suscripcion_seq` VALUES (1);


INSERT INTO `usuarios`
  (id_usuario, account_non_expired, account_non_locked, contrasenia, correo,
   credentials_non_expired, enabled, nombre, rol, telefono, token, verificado)
VALUES
  (1, b'1', b'1', '$2a$10$VqkxcjolmFhTe/7YzZ8TcuzhpSzSZm4rTkxkwNkSqUnV3Y7NmIbmy',
   'admin@ddeli.com', b'1', b'1', 'admin', 'ADMIN', '3000000000', 0, b'1'),
  (2, b'1', b'1', '$2a$10$oAu9ElN6iO3t18bBB6bJgu0b3HBHnK0eSAO.tSWhyn7AW34H1YS6a',
   'cliente@ddeli.com', b'1', b'1', 'cliente', 'CLIENTE', '3111111111', 0, b'1');

INSERT INTO `categoria` (id_categoria, descripcion, nombre) VALUES
  (1, 'Brownies artesanales', 'Brownies'),
  (2, 'Cheesecakes cremosos',  'Cheesecakes'),
  (3, 'Tortas especiales',     'Tortas');


INSERT INTO `producto`
  (id_producto, descripcion, disponibilidad, imagenurl, nombre, precio_base, tipo, id_categoria)
VALUES
  (1,  'Brownie artesanal de chocolate',         b'1', 'assets/brownie.jpg',       'Brownie de Chocolate',           15000, 'POSTRE', 1),
  (2,  'Cheesecake cremoso con frutos rojos',     b'1', 'assets/cheesecake.jpg',    'Cheesecake de Frutos Rojos',     25000, 'POSTRE', 2),
  (3,  'Torta suave Red Velvet',                  b'1', 'assets/redvelvet.jpg',     'Torta Red Velvet',               45000, 'POSTRE', 3),
  (4,  'Postre italiano con café y cacao',        b'1', 'assets/tiramisu.jpg',      'Tiramisú Clásico',               28000, 'POSTRE', 2),
  (5,  'Flan tradicional con caramelo casero',    b'1', 'assets/flan.jpg',          'Flan de Caramelo',               12000, 'POSTRE', 2),
  (6,  'Bizcocho suave con mezcla de tres leches',b'1', 'assets/tresleches.jpg',   'Torta Tres Leches',              30000, 'POSTRE', 3),
  (7,  'Galletas caseras con chispas de chocolate',b'1','assets/galletas.jpg',     'Galletas con Chips de Chocolate', 8000, 'POSTRE', 1),
  (8,  'Postre ligero y cremoso de chocolate',    b'1', 'assets/mousse.jpg',        'Mousse de Chocolate',            20000, 'POSTRE', 2),
  (9,  'Postre cítrico con base crocante',        b'1', 'assets/pielimon.jpg',      'Pie de Limón',                   22000, 'POSTRE', 3),
  (10, 'Brownie clásico con trozos de nuez',      b'1', 'assets/browniemz.jpg',     'Brownie con Nueces',             17000, 'POSTRE', 1),
  (11, 'Cupcake suave con crema de vainilla',     b'1', 'assets/cupcake.jpg',       'Cupcake de Vainilla',             9000, 'POSTRE', 3),
  (12, 'Dulce relleno de arequipe y coco',        b'1', 'assets/alfajor.jpg',       'Alfajor Artesanal',               6000, 'POSTRE', 1),
  (13, 'Postre tradicional con canela',           b'1', 'assets/arrozleche.jpg',    'Arroz con Leche',                10000, 'POSTRE', 2),
  (14, 'Torta de chocolate con cerezas',          b'1', 'assets/selvanegra.jpg',    'Torta Selva Negra',              38000, 'POSTRE', 3),
  (16, 'Postre artesanal personalizado a tu gusto',b'1','assets/postrePersonalizado.jpg','Postre Personalizado',     25000, 'PERSONALIZADO', NULL);

INSERT INTO `tipo_personalizacion` (id_tipo, nombre) VALUES
  (1, 'Sabor'),
  (2, 'Topping'),
  (3, 'Decoración'),
  (4, 'Tamaño');


INSERT INTO `opcion_personalizacion` (id_opcion, costo_adicional, nombre, id_tipo) VALUES
  -- Sabor
  (1,     0, 'Fresa',                 1),
  (2,     0, 'Chocolate',             1),
  (3,     0, 'Vainilla',              1),
  (4,  2000, 'Maracuyá',              1),
  -- Topping
  (5,  1500, 'Chispas de chocolate',  2),
  (6,  2000, 'Frutas',                2),
  (7,  1000, 'Caramelo',              2),
  (8,  1500, 'Oreo',                  2),
  -- Decoración
  (9,     0, 'Sin decoración',        3),
  (10, 3000, 'Flores',                3),
  (11, 2000, 'Mensaje personalizado', 3),
  (12, 5000, 'Temática especial',     3),
  -- Tamaño
  (13,    0, 'Pequeño',               4),
  (14, 5000, 'Mediano',               4),
  (15,10000, 'Grande',                4);


INSERT INTO `plan_suscripcion` (id_plan, costo_adicional, nombre, precio_mensual) VALUES
  (1,    0, 'Básico',    15000),
  (2, 5000, 'Estándar',  25000),
  (3,    0, 'Premium',   40000);

INSERT INTO `promocion` (id_promocion, fecha_fin, fecha_inicio, nombre, porcentaje_descuento) VALUES
  (1, '2026-12-31', '2026-01-01', 'Promo Verano',       20),
  (2, '2026-06-30', '2026-05-01', '2x1 Postres',        15),
  (3, '2026-05-31', '2026-05-15', 'Descuento Especial', 30);

SET FOREIGN_KEY_CHECKS = 1;
INSERT INTO tipo_personalizacion (nombre) VALUES ('Sabor');
INSERT INTO tipo_personalizacion (nombre) VALUES ('Topping');
INSERT INTO tipo_personalizacion (nombre) VALUES ('Decoración');
INSERT INTO tipo_personalizacion (nombre) VALUES ('Tamaño');


INSERT INTO opcion_personalizacion (nombre, costo_adicional, id_tipo) VALUES ('Fresa', 0, 1);
INSERT INTO opcion_personalizacion (nombre, costo_adicional, id_tipo) VALUES ('Chocolate', 0, 1);
INSERT INTO opcion_personalizacion (nombre, costo_adicional, id_tipo) VALUES ('Vainilla', 0, 1);
INSERT INTO opcion_personalizacion (nombre, costo_adicional, id_tipo) VALUES ('Maracuyá', 2000, 1);


INSERT INTO opcion_personalizacion (nombre, costo_adicional, id_tipo) VALUES ('Chispas de chocolate', 1500, 2);
INSERT INTO opcion_personalizacion (nombre, costo_adicional, id_tipo) VALUES ('Frutas', 2000, 2);
INSERT INTO opcion_personalizacion (nombre, costo_adicional, id_tipo) VALUES ('Caramelo', 1000, 2);
INSERT INTO opcion_personalizacion (nombre, costo_adicional, id_tipo) VALUES ('Oreo', 1500, 2);


INSERT INTO opcion_personalizacion (nombre, costo_adicional, id_tipo) VALUES ('Sin decoración', 0, 3);
INSERT INTO opcion_personalizacion (nombre, costo_adicional, id_tipo) VALUES ('Flores', 3000, 3);
INSERT INTO opcion_personalizacion (nombre, costo_adicional, id_tipo) VALUES ('Mensaje personalizado', 2000, 3);
INSERT INTO opcion_personalizacion (nombre, costo_adicional, id_tipo) VALUES ('Temática especial', 5000, 3);


INSERT INTO opcion_personalizacion (nombre, costo_adicional, id_tipo) VALUES ('Pequeño', 0, 4);
INSERT INTO opcion_personalizacion (nombre, costo_adicional, id_tipo) VALUES ('Mediano', 5000, 4);
INSERT INTO opcion_personalizacion (nombre, costo_adicional, id_tipo) VALUES ('Grande', 10000, 4);
