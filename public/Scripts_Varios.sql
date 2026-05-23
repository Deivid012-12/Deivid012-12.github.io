
USE ddeli;

CREATE OR REPLACE VIEW `vista_pedidos_usuario` AS
SELECT
  p.id_pedido,
  p.fecha_pedido,
  p.valor_total,
  u.nombre         AS nombre_usuario,
  u.correo         AS correo_usuario,
  pg.metodo_pago,
  pg.estado_transaccion,
  pg.cantidad_pago,
  e.tipo_entrega,
  e.estado         AS estado_envio,
  d.calle,
  d.ciudad,
  d.departamento,
  pr.nombre        AS nombre_promocion,
  pr.porcentaje_descuento
FROM pedido p
JOIN usuarios u        ON p.id_usuario   = u.id_usuario
LEFT JOIN pago pg      ON pg.id_pedido   = p.id_pedido
LEFT JOIN envio e      ON e.id_pedido    = p.id_pedido
LEFT JOIN direccion d  ON e.id_direccion = d.id_direccion
LEFT JOIN promocion pr ON p.id_promocion = pr.id_promocion;


CREATE OR REPLACE VIEW `vista_carrito_activo` AS
SELECT
  c.id_carrito,
  u.nombre           AS nombre_usuario,
  u.correo,
  p.nombre           AS nombre_producto,
  ic.cantidad,
  ic.precio_unitario,
  ic.subtotal,
  c.estado           AS estado_carrito,
  c.fecha_creacion
FROM carrito c
JOIN usuarios u    ON c.id_usuario  = u.id_usuario
JOIN item_carrito ic ON ic.id_carrito = c.id_carrito
JOIN producto p    ON ic.id_producto = p.id_producto
WHERE c.estado = 'ACTIVO';


CREATE OR REPLACE VIEW `vista_detalle_pedido_completo` AS
SELECT
  dp.id_detalle,
  p.id_pedido,
  p.fecha_pedido,
  u.nombre           AS nombre_usuario,
  pr.nombre          AS nombre_producto,
  dp.cantidad,
  dp.precio_unitario,
  dp.subtotal,
  GROUP_CONCAT(op.nombre ORDER BY op.nombre SEPARATOR ', ') AS opciones_personalizacion
FROM detalle_pedido dp
JOIN pedido p       ON dp.id_pedido   = p.id_pedido
JOIN usuarios u     ON p.id_usuario   = u.id_usuario
JOIN producto pr    ON dp.id_producto = pr.id_producto
LEFT JOIN detalle_opcion dop ON dp.id_detalle = dop.id_detalle
LEFT JOIN opcion_personalizacion op ON dop.id_opcion = op.id_opcion
GROUP BY dp.id_detalle, p.id_pedido, p.fecha_pedido,
         u.nombre, pr.nombre, dp.cantidad, dp.precio_unitario, dp.subtotal;


CREATE OR REPLACE VIEW `vista_ventas_por_producto` AS
SELECT
  pr.id_producto,
  pr.nombre          AS nombre_producto,
  pr.tipo,
  COUNT(dp.id_detalle)    AS total_pedidos,
  SUM(dp.cantidad)        AS unidades_vendidas,
  SUM(dp.subtotal)        AS ingresos_totales
FROM producto pr
LEFT JOIN detalle_pedido dp ON pr.id_producto = dp.id_producto
GROUP BY pr.id_producto, pr.nombre, pr.tipo
ORDER BY ingresos_totales DESC;


DROP PROCEDURE IF EXISTS `sp_pedidos_por_usuario` $$
CREATE PROCEDURE `sp_pedidos_por_usuario`(IN p_correo VARCHAR(255))
BEGIN
  SELECT
    p.id_pedido,
    p.fecha_pedido,
    p.valor_total,
    pg.metodo_pago,
    pg.estado_transaccion,
    e.tipo_entrega,
    e.estado AS estado_envio
  FROM pedido p
  JOIN usuarios u     ON p.id_usuario = u.id_usuario
  LEFT JOIN pago pg   ON pg.id_pedido = p.id_pedido
  LEFT JOIN envio e   ON e.id_pedido  = p.id_pedido
  WHERE u.correo = p_correo
  ORDER BY p.fecha_pedido DESC;
END $$


DROP PROCEDURE IF EXISTS `sp_productos_disponibles` $$
CREATE PROCEDURE `sp_productos_disponibles`(IN p_categoria VARCHAR(255))
BEGIN
  SELECT
    pr.id_producto,
    pr.nombre,
    pr.descripcion,
    pr.precio_base,
    pr.imagenurl,
    c.nombre AS categoria
  FROM producto pr
  LEFT JOIN categoria c ON pr.id_categoria = c.id_categoria
  WHERE pr.disponibilidad = 1
    AND pr.tipo = 'POSTRE'
    AND (p_categoria IS NULL OR c.nombre = p_categoria)
  ORDER BY pr.precio_base ASC;
END $$


DROP PROCEDURE IF EXISTS `sp_resumen_ventas_periodo` $$
CREATE PROCEDURE `sp_resumen_ventas_periodo`(
  IN p_fecha_inicio DATE,
  IN p_fecha_fin    DATE
)
BEGIN
  SELECT
    COUNT(p.id_pedido)   AS total_pedidos,
    SUM(p.valor_total)   AS ingresos_totales,
    AVG(p.valor_total)   AS ticket_promedio,
    MIN(p.valor_total)   AS pedido_minimo,
    MAX(p.valor_total)   AS pedido_maximo
  FROM pedido p
  WHERE p.fecha_pedido BETWEEN p_fecha_inicio AND p_fecha_fin;
END $$

DELIMITER ;


SELECT
u.id_usuario, u.nombre, u.correo,
COUNT(p.id_pedido)  AS total_pedidos,
SUM(p.valor_total)  AS total_gastado
FROM usuarios u
LEFT JOIN pedido p ON p.id_usuario = u.id_usuario
GROUP BY u.id_usuario, u.nombre, u.correo
ORDER BY total_gastado DESC;

SELECT * FROM vista_carrito_activo;


SELECT vp.*
FROM vista_pedidos_usuario vp
WHERE vp.estado_envio = 'PENDIENTE';


SELECT
op.nombre AS opcion,
tp.nombre AS tipo,
COUNT(io.id_item) AS veces_seleccionada
FROM opcion_personalizacion op
JOIN tipo_personalizacion tp ON op.id_tipo = tp.id_tipo
LEFT JOIN item_opcion io ON op.id_opcion = io.id_opcion
GROUP BY op.id_opcion, op.nombre, tp.nombre
ORDER BY veces_seleccionada DESC;


SELECT
pg.metodo_pago,
 COUNT(pg.id_pago)     AS total_transacciones,
UM(pg.cantidad_pago) AS total_ingresos
FROM pago pg
WHERE pg.estado_transaccion = 'aprobado'
GROUP BY pg.metodo_pago;


SELECT * FROM vista_ventas_por_producto LIMIT 10;


SELECT p.id_pedido, p.fecha_pedido, p.valor_total, u.nombre
FROM pedido p
JOIN usuarios u ON p.id_usuario = u.id_usuario
 LEFT JOIN pago pg ON pg.id_pedido = p.id_pedido
WHERE pg.id_pago IS NULL;

SELECT
 u.nombre, u.correo,
   pl.nombre AS plan,
 pl.precio_mensual,
  s.fecha_inicio, s.estado
 FROM suscripcion s
JOIN usuarios u        ON s.id_usuario = u.id_usuario
JOIN plan_suscripcion pl ON s.id_plan   = pl.id_plan
 WHERE s.estado = 'ACTIVA';
