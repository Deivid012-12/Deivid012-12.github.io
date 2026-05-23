
CREATE DATABASE ddeli;

USE ddeli;

SET FOREIGN_KEY_CHECKS = 0;


CREATE TABLE IF NOT EXISTS `usuarios` (
  `id_usuario`              BIGINT        NOT NULL AUTO_INCREMENT,
  `nombre`                  VARCHAR(255)  DEFAULT NULL,
  `correo`                  VARCHAR(255)  DEFAULT NULL UNIQUE,
  `telefono`                VARCHAR(255)  DEFAULT NULL,
  `contrasenia`             VARCHAR(255)  DEFAULT NULL,
  `rol`                     VARCHAR(50)   DEFAULT NULL,
  `verificado`              BIT(1)        NOT NULL DEFAULT b'0',
  `token`                   INT           NOT NULL DEFAULT 0,
  `account_non_expired`     BIT(1)        NOT NULL DEFAULT b'1',
  `account_non_locked`      BIT(1)        NOT NULL DEFAULT b'1',
  `credentials_non_expired` BIT(1)        NOT NULL DEFAULT b'1',
  `enabled`                 BIT(1)        NOT NULL DEFAULT b'1',
  PRIMARY KEY (`id_usuario`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


CREATE TABLE IF NOT EXISTS `categoria` (
  `id_categoria` BIGINT        NOT NULL AUTO_INCREMENT,
  `nombre`       VARCHAR(255)  DEFAULT NULL,
  `descripcion`  VARCHAR(255)  DEFAULT NULL,
  PRIMARY KEY (`id_categoria`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


CREATE TABLE IF NOT EXISTS `producto` (
  `id_producto`   BIGINT          NOT NULL AUTO_INCREMENT,
  `nombre`        VARCHAR(255)    DEFAULT NULL,
  `descripcion`   VARCHAR(255)    DEFAULT NULL,
  `precio_base`   DOUBLE          NOT NULL DEFAULT 0,
  `disponibilidad` BIT(1)         NOT NULL DEFAULT b'1',
  `tipo`          VARCHAR(50)     DEFAULT NULL,
  `imagenurl`     VARCHAR(500)    DEFAULT NULL,
  `id_categoria`  BIGINT          DEFAULT NULL,
  PRIMARY KEY (`id_producto`),
  CONSTRAINT `fk_producto_categoria`
    FOREIGN KEY (`id_categoria`) REFERENCES `categoria` (`id_categoria`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


CREATE TABLE IF NOT EXISTS `tipo_personalizacion` (
  `id_tipo` BIGINT       NOT NULL AUTO_INCREMENT,
  `nombre`  VARCHAR(255) DEFAULT NULL,
  PRIMARY KEY (`id_tipo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


CREATE TABLE IF NOT EXISTS `opcion_personalizacion` (
  `id_opcion`       BIGINT          NOT NULL AUTO_INCREMENT,
  `nombre`          VARCHAR(255)    DEFAULT NULL,
  `costo_adicional` DOUBLE          NOT NULL DEFAULT 0,
  `id_tipo`         BIGINT          DEFAULT NULL,
  PRIMARY KEY (`id_opcion`),
  CONSTRAINT `fk_opcion_tipo`
    FOREIGN KEY (`id_tipo`) REFERENCES `tipo_personalizacion` (`id_tipo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


CREATE TABLE IF NOT EXISTS `carrito` (
  `id_carrito`     BIGINT       NOT NULL AUTO_INCREMENT,
  `estado`         VARCHAR(50)  DEFAULT NULL,
  `fecha_creacion` DATE         DEFAULT NULL,
  `id_usuario`     BIGINT       DEFAULT NULL,
  PRIMARY KEY (`id_carrito`),
  CONSTRAINT `fk_carrito_usuario`
    FOREIGN KEY (`id_usuario`) REFERENCES `usuarios` (`id_usuario`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


CREATE TABLE IF NOT EXISTS `item_carrito` (
  `id_item`         BIGINT  NOT NULL AUTO_INCREMENT,
  `cantidad`        INT     NOT NULL DEFAULT 1,
  `precio_unitario` DOUBLE  NOT NULL DEFAULT 0,
  `subtotal`        DOUBLE  NOT NULL DEFAULT 0,
  `id_carrito`      BIGINT  DEFAULT NULL,
  `id_producto`     BIGINT  DEFAULT NULL,
  PRIMARY KEY (`id_item`),
  CONSTRAINT `fk_item_carrito`
    FOREIGN KEY (`id_carrito`) REFERENCES `carrito` (`id_carrito`),
  CONSTRAINT `fk_item_producto`
    FOREIGN KEY (`id_producto`) REFERENCES `producto` (`id_producto`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


CREATE TABLE IF NOT EXISTS `item_opcion` (
  `id_item`   BIGINT NOT NULL,
  `id_opcion` BIGINT NOT NULL,
  PRIMARY KEY (`id_item`, `id_opcion`),
  CONSTRAINT `fk_item_opcion_item`
    FOREIGN KEY (`id_item`) REFERENCES `item_carrito` (`id_item`),
  CONSTRAINT `fk_item_opcion_opcion`
    FOREIGN KEY (`id_opcion`) REFERENCES `opcion_personalizacion` (`id_opcion`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


CREATE TABLE IF NOT EXISTS `promocion` (
  `id_promocion`         BIGINT          NOT NULL AUTO_INCREMENT,
  `nombre`               VARCHAR(255)    DEFAULT NULL,
  `porcentaje_descuento` DOUBLE          NOT NULL DEFAULT 0,
  `fecha_inicio`         DATE            DEFAULT NULL,
  `fecha_fin`            DATE            DEFAULT NULL,
  PRIMARY KEY (`id_promocion`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


CREATE TABLE IF NOT EXISTS `evento` (
  `id_evento`       BIGINT        NOT NULL AUTO_INCREMENT,
  `fecha_evento`    DATE          DEFAULT NULL,
  `numero_personas` INT           NOT NULL DEFAULT 0,
  `tipo_evento`     VARCHAR(255)  DEFAULT NULL,
  `id_usuario`      BIGINT        DEFAULT NULL,
  PRIMARY KEY (`id_evento`),
  CONSTRAINT `fk_evento_usuario`
    FOREIGN KEY (`id_usuario`) REFERENCES `usuarios` (`id_usuario`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


CREATE TABLE IF NOT EXISTS `pedido` (
  `id_pedido`    BIGINT   NOT NULL AUTO_INCREMENT,
  `fecha_pedido` DATE     DEFAULT NULL,
  `valor_total`  DOUBLE   NOT NULL DEFAULT 0,
  `id_evento`    BIGINT   DEFAULT NULL,
  `id_promocion` BIGINT   DEFAULT NULL,
  `id_usuario`   BIGINT   DEFAULT NULL,
  PRIMARY KEY (`id_pedido`),
  CONSTRAINT `fk_pedido_usuario`
    FOREIGN KEY (`id_usuario`) REFERENCES `usuarios` (`id_usuario`),
  CONSTRAINT `fk_pedido_evento`
    FOREIGN KEY (`id_evento`) REFERENCES `evento` (`id_evento`),
  CONSTRAINT `fk_pedido_promocion`
    FOREIGN KEY (`id_promocion`) REFERENCES `promocion` (`id_promocion`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


CREATE TABLE IF NOT EXISTS `detalle_pedido` (
  `id_detalle`      BIGINT  NOT NULL AUTO_INCREMENT,
  `cantidad`        INT     NOT NULL DEFAULT 1,
  `precio_unitario` DOUBLE  NOT NULL DEFAULT 0,
  `subtotal`        DOUBLE  NOT NULL DEFAULT 0,
  `id_pedido`       BIGINT  DEFAULT NULL,
  `id_producto`     BIGINT  DEFAULT NULL,
  PRIMARY KEY (`id_detalle`),
  CONSTRAINT `fk_detalle_pedido`
    FOREIGN KEY (`id_pedido`) REFERENCES `pedido` (`id_pedido`),
  CONSTRAINT `fk_detalle_producto`
    FOREIGN KEY (`id_producto`) REFERENCES `producto` (`id_producto`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


CREATE TABLE IF NOT EXISTS `detalle_opcion` (
  `id_detalle` BIGINT NOT NULL,
  `id_opcion`  BIGINT NOT NULL,
  PRIMARY KEY (`id_detalle`, `id_opcion`),
  CONSTRAINT `fk_detalle_opcion_detalle`
    FOREIGN KEY (`id_detalle`) REFERENCES `detalle_pedido` (`id_detalle`),
  CONSTRAINT `fk_detalle_opcion_opcion`
    FOREIGN KEY (`id_opcion`) REFERENCES `opcion_personalizacion` (`id_opcion`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


CREATE TABLE IF NOT EXISTS `direccion` (
  `id_direccion` BIGINT        NOT NULL AUTO_INCREMENT,
  `calle`        VARCHAR(255)  DEFAULT NULL,
  `ciudad`       VARCHAR(255)  DEFAULT NULL,
  `codigo_postal` VARCHAR(20)  DEFAULT NULL,
  `departamento` VARCHAR(255)  DEFAULT NULL,
  `indicaciones` VARCHAR(500)  DEFAULT NULL,
  `id_usuario`   BIGINT        DEFAULT NULL,
  PRIMARY KEY (`id_direccion`),
  CONSTRAINT `fk_direccion_usuario`
    FOREIGN KEY (`id_usuario`) REFERENCES `usuarios` (`id_usuario`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `envio` (
  `id_envio`     BIGINT        NOT NULL AUTO_INCREMENT,
  `estado`       VARCHAR(50)   DEFAULT NULL,
  `fecha_envio`  DATE          DEFAULT NULL,
  `tipo_entrega` VARCHAR(50)   DEFAULT NULL,
  `id_direccion` BIGINT        DEFAULT NULL,
  `id_pedido`    BIGINT        DEFAULT NULL UNIQUE,
  PRIMARY KEY (`id_envio`),
  CONSTRAINT `fk_envio_pedido`
    FOREIGN KEY (`id_pedido`) REFERENCES `pedido` (`id_pedido`),
  CONSTRAINT `fk_envio_direccion`
    FOREIGN KEY (`id_direccion`) REFERENCES `direccion` (`id_direccion`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


CREATE TABLE IF NOT EXISTS `pago` (
  `id_pago`            BIGINT          NOT NULL AUTO_INCREMENT,
  `cantidad_pago`      DOUBLE          NOT NULL DEFAULT 0,
  `estado_transaccion` VARCHAR(50)     DEFAULT NULL,
  `fecha_pago`         DATE            DEFAULT NULL,
  `metodo_pago`        VARCHAR(50)     DEFAULT NULL,
  `id_pedido`          BIGINT          DEFAULT NULL UNIQUE,
  PRIMARY KEY (`id_pago`),
  CONSTRAINT `fk_pago_pedido`
    FOREIGN KEY (`id_pedido`) REFERENCES `pedido` (`id_pedido`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


CREATE TABLE IF NOT EXISTS `plan_suscripcion` (
  `id_plan`         BIGINT          NOT NULL AUTO_INCREMENT,
  `nombre`          VARCHAR(255)    DEFAULT NULL,
  `precio_mensual`  DOUBLE          NOT NULL DEFAULT 0,
  `costo_adicional` DOUBLE          NOT NULL DEFAULT 0,
  PRIMARY KEY (`id_plan`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


CREATE TABLE IF NOT EXISTS `suscripcion_seq` (
  `next_val` BIGINT DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


CREATE TABLE IF NOT EXISTS `suscripcion` (
  `id_suscripcion` BIGINT        NOT NULL,
  `fecha_inicio`   DATE          DEFAULT NULL,
  `estado`         VARCHAR(50)   DEFAULT NULL,
  `id_usuario`     BIGINT        DEFAULT NULL,
  `id_plan`        BIGINT        DEFAULT NULL,
  PRIMARY KEY (`id_suscripcion`),
  CONSTRAINT `fk_suscripcion_usuario`
    FOREIGN KEY (`id_usuario`) REFERENCES `usuarios` (`id_usuario`),
  CONSTRAINT `fk_suscripcion_plan`
    FOREIGN KEY (`id_plan`) REFERENCES `plan_suscripcion` (`id_plan`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

SET FOREIGN_KEY_CHECKS = 1;
