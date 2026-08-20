-- ══════════════════════════════════════════════════════════
-- TechStore — Ventas_Tech_DB
-- Checkpoint: Script SQL para esquema normalizado y datos iniciales
-- Curso: Data Analytics - Modulo 3 (Introduccion a SQL y Sublenguajes)
-- Autor: Tomas
-- Fecha: 2026-08-20
-- Compatible con: PostgreSQL y SQL Server
--
-- Este script es la base de datos que se va a usar durante TODO el curso:
-- en el Modulo 6 se conecta Power BI directamente a este esquema, y en el
-- Modulo 8 se construye el modelo analitico y las medidas DAX encima de el.
-- ══════════════════════════════════════════════════════════

-- NOTA: CREATE DATABASE debe ejecutarse como una sentencia aparte (no en la
-- misma transaccion/lote que el resto del script), tanto en PostgreSQL como
-- en SQL Server. Ejecuta esta linea primero, conectate a la base recien
-- creada y despues corre el resto del script contra esa conexion.
CREATE DATABASE Ventas_Tech_DB;

-- ── DROP TABLES ──────────────────────────
-- Se eliminan las tablas si ya existen, respetando el orden INVERSO de las
-- dependencias (primero la tabla de hechos "ventas", al final "categorias")
-- para no violar ninguna Foreign Key durante el borrado.
DROP TABLE IF EXISTS ventas;
DROP TABLE IF EXISTS productos;
DROP TABLE IF EXISTS clientes;
DROP TABLE IF EXISTS categorias;

-- ── CREATE TABLES ──────────────────────────
-- Se crean en orden de dependencia: primero las dimensiones sin FK
-- (categorias, clientes), despues productos (depende de categorias) y por
-- ultimo ventas, la tabla de hechos que depende de clientes y productos.

-- Tabla categorias
CREATE TABLE categorias (
    id_categoria INT PRIMARY KEY,          -- Identificador unico de cada categoria.
    nombre_categoria VARCHAR(50) NOT NULL, -- Texto corto y obligatorio: toda categoria debe tener nombre.
    descripcion VARCHAR(200)               -- Texto opcional, mas largo, para detallar la categoria.
);

-- Tabla clientes
CREATE TABLE clientes (
    id_cliente INT PRIMARY KEY,        -- Identificador unico de cada cliente.
    nombre VARCHAR(100) NOT NULL,      -- El nombre es un dato critico: no puede quedar vacio.
    email VARCHAR(100) UNIQUE,         -- UNIQUE porque no puede haber dos clientes con el mismo email.
    ciudad VARCHAR(50),                -- Dato descriptivo opcional.
    fecha_registro DATE NOT NULL       -- Se usa DATE (no texto) para poder operar con fechas despues
                                        -- en Power BI, y NOT NULL porque todo cliente debe tener alta.
);

-- Tabla productos
CREATE TABLE productos (
    id_producto INT PRIMARY KEY,           -- Identificador unico de cada producto.
    nombre_producto VARCHAR(100) NOT NULL, -- Nombre obligatorio del producto.
    id_categoria INT,                      -- FOREIGN KEY hacia categorias (ver mas abajo).
    precio DECIMAL(10, 2) NOT NULL,        -- DECIMAL y no FLOAT: evita errores de redondeo en dinero.
    stock INT DEFAULT 0,                   -- Si no se especifica, el stock arranca en 0 por defecto.
    activo SMALLINT DEFAULT 1,             -- 1 = activo / 0 = inactivo. La consigna sugiere
                                            -- TINYINT(1) (sintaxis de MySQL), pero se reemplaza por
                                            -- SMALLINT porque es el tipo equivalente compatible con
                                            -- PostgreSQL y SQL Server, cumpliendo el criterio de
                                            -- aceptacion del ejercicio.
    CONSTRAINT fk_productos_categoria
        FOREIGN KEY (id_categoria) REFERENCES categorias (id_categoria)
);

-- Tabla ventas (tabla de hechos)
CREATE TABLE ventas (
    id_venta INT PRIMARY KEY,          -- Identificador unico de cada venta.
    id_cliente INT,                    -- FOREIGN KEY hacia clientes.
    id_producto INT,                   -- FOREIGN KEY hacia productos.
    cantidad INT NOT NULL,             -- Unidades vendidas: obligatorio, siempre un numero entero.
    precio_unitario DECIMAL(10, 2) NOT NULL, -- Precio al momento de la venta (puede diferir del precio
                                              -- actual del producto), por eso se guarda aparte.
    fecha_venta DATE NOT NULL,         -- Fecha de la operacion, obligatoria.
    CONSTRAINT fk_ventas_cliente
        FOREIGN KEY (id_cliente) REFERENCES clientes (id_cliente),
    CONSTRAINT fk_ventas_producto
        FOREIGN KEY (id_producto) REFERENCES productos (id_producto)
);

-- ── INSERT DATA ──────────────────────────
-- Se cargan los datos en el orden correcto: primero las tablas sin
-- dependencias (categorias, clientes), despues las que dependen de ellas
-- (productos, ventas). Este orden evita el error de "el huevo y la gallina"
-- (crear una venta que apunte a un producto o cliente que todavia no existe).

-- categorias — 4 registros
INSERT INTO categorias (id_categoria, nombre_categoria, descripcion) VALUES (1, 'Computacion',    'Laptops, PCs y monitores');
INSERT INTO categorias (id_categoria, nombre_categoria, descripcion) VALUES (2, 'Accesorios',      'Perifericos y complementos');
INSERT INTO categorias (id_categoria, nombre_categoria, descripcion) VALUES (3, 'Audio',           'Auriculares y parlantes');
INSERT INTO categorias (id_categoria, nombre_categoria, descripcion) VALUES (4, 'Almacenamiento',  'Discos y memorias');

-- clientes — 5 registros
INSERT INTO clientes (id_cliente, nombre, email, ciudad, fecha_registro) VALUES (1, 'Maria Lopez',  'maria@mail.com',  'Buenos Aires', '2024-01-05');
INSERT INTO clientes (id_cliente, nombre, email, ciudad, fecha_registro) VALUES (2, 'Carlos Ruiz',  'carlos@mail.com', 'Cordoba',      '2024-01-10');
INSERT INTO clientes (id_cliente, nombre, email, ciudad, fecha_registro) VALUES (3, 'Ana Gomez',    'ana@mail.com',    'Rosario',      '2024-02-01');
INSERT INTO clientes (id_cliente, nombre, email, ciudad, fecha_registro) VALUES (4, 'Pedro Sanz',   'pedro@mail.com',  'Mendoza',      '2024-02-15');
INSERT INTO clientes (id_cliente, nombre, email, ciudad, fecha_registro) VALUES (5, 'Laura Torres', 'laura@mail.com',  'Tucuman',      '2024-03-01');

-- productos — 6 registros
INSERT INTO productos (id_producto, nombre_producto, id_categoria, precio, stock, activo) VALUES (1, 'Laptop Pro 15',      1, 1200.00, 15, 1);
INSERT INTO productos (id_producto, nombre_producto, id_categoria, precio, stock, activo) VALUES (2, 'Mouse Inalambrico',  2,   28.00, 80, 1);
INSERT INTO productos (id_producto, nombre_producto, id_categoria, precio, stock, activo) VALUES (3, 'Monitor 4K 27"',     1,  450.00, 12, 1);
INSERT INTO productos (id_producto, nombre_producto, id_categoria, precio, stock, activo) VALUES (4, 'Auriculares BT Pro', 3,  120.00, 35, 1);
INSERT INTO productos (id_producto, nombre_producto, id_categoria, precio, stock, activo) VALUES (5, 'SSD Externo 1TB',    4,  130.00, 18, 1);
INSERT INTO productos (id_producto, nombre_producto, id_categoria, precio, stock, activo) VALUES (6, 'Teclado Mecanico',   2,   95.00, 40, 1);

-- ventas — 10 registros
INSERT INTO ventas (id_venta, id_cliente, id_producto, cantidad, precio_unitario, fecha_venta) VALUES (1,  1, 1, 2, 1200.00, '2024-03-05');
-- en el enunciado esta venta aparecia con precio_unitario 28.00, pero ese es el precio del
-- Mouse (producto 2), no del SSD Externo 1TB (producto 5) que es lo que realmente se vendio.
-- se decidio usar el precio real del producto (130.00) porque sino después, al sumar ingresos
-- por venta, el total no iba a cerrar con el resto de la tabla.
INSERT INTO ventas (id_venta, id_cliente, id_producto, cantidad, precio_unitario, fecha_venta) VALUES (2,  2, 5, 1,  130.00, '2024-03-06');
INSERT INTO ventas (id_venta, id_cliente, id_producto, cantidad, precio_unitario, fecha_venta) VALUES (3,  3, 3, 1,  450.00, '2024-03-07');
INSERT INTO ventas (id_venta, id_cliente, id_producto, cantidad, precio_unitario, fecha_venta) VALUES (4,  1, 4, 2,  120.00, '2024-03-08');
INSERT INTO ventas (id_venta, id_cliente, id_producto, cantidad, precio_unitario, fecha_venta) VALUES (5,  4, 5, 3,  130.00, '2024-03-10');
INSERT INTO ventas (id_venta, id_cliente, id_producto, cantidad, precio_unitario, fecha_venta) VALUES (6,  2, 6, 4,   95.00, '2024-03-11');
INSERT INTO ventas (id_venta, id_cliente, id_producto, cantidad, precio_unitario, fecha_venta) VALUES (7,  5, 1, 1, 1200.00, '2024-03-12');
INSERT INTO ventas (id_venta, id_cliente, id_producto, cantidad, precio_unitario, fecha_venta) VALUES (8,  3, 2, 8,   28.00, '2024-03-13');
INSERT INTO ventas (id_venta, id_cliente, id_producto, cantidad, precio_unitario, fecha_venta) VALUES (9,  4, 4, 1,  120.00, '2024-03-14');
INSERT INTO ventas (id_venta, id_cliente, id_producto, cantidad, precio_unitario, fecha_venta) VALUES (10, 5, 3, 2,  450.00, '2024-03-15');

-- ── VALIDACION ──────────────────────────
-- Confirma que cada tabla se cargo correctamente.
SELECT * FROM categorias;
SELECT * FROM clientes;
SELECT * FROM productos;
SELECT * FROM ventas;

-- (Mas adelante, en el Modulo 5, vas a poder cruzar estas tablas con JOIN
--  para ver las ventas junto al nombre del cliente y del producto.
--  Por ahora alcanza con confirmar que las 4 tablas tienen sus datos.)
