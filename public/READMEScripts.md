# DDeLI Postres — Scripts de Base de Datos

## Descripción

Scripts SQL para la implementación del modelo físico de la base de datos del sistema DDeLiPostres



## Requisitos 

- **MySQL 8.0** o superior
- Cliente MySQL: MySQL Workbench, DBeaver, HeidiSQL o terminal
- Usuario con permisos `CREATE`, `INSERT`, `SELECT`, `ALTER`

---

## Guia

1. Abrir MySQL Workbench y conectarse al servidor
2. Ir a **File → Open SQL Script**
3. Ejecutar en orden:
   - `01_ddeli_creacion_estructura.sql`
   - `02_ddeli_insercion_registros.sql`
   - `03_ddeli_scripts_varios.sql`


Crear base de datos con las tablas (relaciones)

| Tabla                   | Descripción                                              |
|-------------------------|----------------------------------------------------------|
| `usuarios`              | Clientes y administradores del sistema                   |
| `categoria`             | Categorías de postres (Brownies, Cheesecakes, Tortas)    |
| `producto`              | Postres predeterminados y base para postres personalizados |
| `tipo_personalizacion`  | Tipos de personalización (Sabor, Topping, Decoración, Tamaño) |
| `opcion_personalizacion`| Opciones disponibles por tipo con costo adicional        |
| `carrito`               | Carrito de compras activo de cada usuario                |
| `item_carrito`          | Productos dentro del carrito                             |
| `item_opcion`           | Opciones de personalización por ítem del carrito (M:N)   |
| `promocion`             | Promociones con porcentaje de descuento                  |
| `evento`                | Eventos organizados por usuarios                         |
| `pedido`                | Pedidos realizados por los usuarios                      |
| `detalle_pedido`        | Detalle de productos incluidos en cada pedido            |
| `detalle_opcion`        | Opciones de personalización por detalle del pedido (M:N) |
| `direccion`             | Direcciones de entrega de los usuarios                   |
| `envio`                 | Información de envío asociada a cada pedido              |
| `pago`                  | Información de pago asociada a cada pedido               |
| `plan_suscripcion`      | Planes de suscripción disponibles                        |
| `suscripcion_seq`       | Secuencia para IDs de suscripción                        |
| `suscripcion`           | Suscripciones de usuarios a planes                       |

### 02 — Registros ejemplos

Insertar posibles datos

| Datos                        | Cantidad | Descripción                              |
|------------------------------|----------|------------------------------------------|
| Usuarios                     | 2        | Admin y cliente de prueba                |
| Categorías                   | 3        | Brownies, Cheesecakes, Tortas            |
| Productos                    | 15       | 14 postres + 1 base para personalización |
| Tipos de personalización     | 4        | Sabor, Topping, Decoración, Tamaño       |
| Opciones de personalización  | 15       | Distribuidas en los 4 tipos              |
| Planes de suscripción        | 3        | Básico, Estándar, Premium                |
| Promociones                  | 3        | Promociones activas de ejemplo           |

**Credenciales de prueba precargadas

| Usuario | Correo              | Contraseña  | Rol    |
|---------|---------------------|-------------|--------|
| admin   | admin@ddeli.com     | 1234567890  | ADMIN  |
| cliente | cliente@ddeli.com   | 1234567890  | CLIENTE|

### 03 — Scripts varios

Algunos SCRIPTS

**Vistas:**

| Vista                          | Descripción                                               |
|--------------------------------|-----------------------------------------------------------|
| `vista_pedidos_usuario`        | Pedidos con usuario, pago, envío y dirección              |
| `vista_carrito_activo`         | Ítems del carrito activo de cada usuario                  |
| `vista_detalle_pedido_completo`| Detalles del pedido con opciones de personalización        |
| `vista_ventas_por_producto`    | Resumen de ventas e ingresos por producto                 |

**Procedimientos almacenados:**

| Procedimiento               | Parámetros                        | Descripción                          |
|-----------------------------|-----------------------------------|--------------------------------------|
| `sp_pedidos_por_usuario`    | `correo VARCHAR`                  | Lista pedidos de un usuario           |
| `sp_productos_disponibles`  | `categoria VARCHAR` (NULL = todos)| Lista productos disponibles           |
| `sp_resumen_ventas_periodo` | `fecha_inicio DATE, fecha_fin DATE`| Resumen de ventas en un período      |

**Consultas útiles** (comentadas, listas para ejecutar):
- Carritos activos con ítems
- Pedidos pendientes de envío
- Opciones de personalización
- Ingresos por método de pago
- Productos más vendidos
- Pedidos sin pago 
- Usuarios con suscripción activa


### Principales relaciones

```
USUARIO ──1:M──> CARRITO ──1:M──> ITEM_CARRITO ──M:N──> OPCION_PERSONALIZACION
USUARIO ──1:M──> PEDIDO  ──1:M──> DETALLE_PEDIDO ──M:N──> OPCION_PERSONALIZACION
PEDIDO  ──1:1──> PAGO
PEDIDO  ──1:1──> ENVIO ──M:1──> DIRECCION
PEDIDO  ──M:1──> PROMOCION
PEDIDO  ──M:1──> EVENTO
USUARIO ──1:M──> SUSCRIPCION ──M:1──> PLAN_SUSCRIPCION
PRODUCTO ──M:1──> CATEGORIA
OPCION_PERSONALIZACION ──M:1──> TIPO_PERSONALIZACION
```

---

## Datos proyecto

| Capa       | Tecnología              |
|------------|-------------------------|
| Base de datos | MySQL 8.0            |
| Backend    | Spring Boot 3 + JPA/Hibernate |
| Frontend   | Angular 17 (standalone) |
| Seguridad  | Spring Security + JWT   |

