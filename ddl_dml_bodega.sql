-- ══════════════════════════════════════════
-- BodegaTech — Script de Inventario
-- Autor: Tomas
-- Fecha: 2026-08-17
-- Curso: Data Analytics - Modulo 3 (Introduccion a SQL y Sublenguajes)
-- Compatible con: PostgreSQL y SQL Server
-- ══════════════════════════════════════════

-- ── SECCION DDL ──────────────────────────

-- DROP TABLE
-- Se elimina la tabla si ya existe para poder re-ejecutar el script
-- completo las veces que sea necesario sin que falle por "la tabla ya existe".
DROP TABLE IF EXISTS inventario;

-- CREATE TABLE
CREATE TABLE inventario (
    id_producto INT PRIMARY KEY,        -- Identificador unico del producto. Se usa INT (numero
                                         -- entero) porque es un contador simple y se define como
                                         -- PRIMARY KEY para garantizar que no haya productos
                                         -- duplicados y poder relacionarlo en el futuro con otras
                                         -- tablas (ventas, proveedores, etc.).

    nombre_producto VARCHAR(100),       -- Texto de longitud variable con limite de 100 caracteres,
                                         -- suficiente para nombres comerciales de productos sin
                                         -- desperdiciar espacio de almacenamiento.

    categoria VARCHAR(50),              -- Texto corto y acotado (Computacion, Accesorios, Audio,
                                         -- Almacenamiento). 50 caracteres alcanza de sobra y evita
                                         -- reservar espacio de mas como pasaria con TEXT.

    precio_unitario DECIMAL(10, 2),     -- Se usa DECIMAL y no FLOAT porque FLOAT es de punto
                                         -- flotante y puede generar errores de redondeo en valores
                                         -- monetarios. DECIMAL(10,2) permite hasta 10 digitos en
                                         -- total, con 2 decimales, ideal para precios en USD.

    stock_actual INT,                   -- Cantidad de unidades disponibles: siempre un numero
                                         -- entero, no tiene sentido tener "medias unidades".

    stock_minimo INT,                   -- Umbral de reposicion, tambien un numero entero por la
                                         -- misma razon que stock_actual.

    fecha_ingreso DATE,                 -- Solo interesa el dia en que el producto ingreso al
                                         -- inventario, no una hora exacta. Por eso se usa DATE y
                                         -- no TIMESTAMP/DATETIME, y se guarda como tipo fecha (no
                                         -- texto) para poder usarlo despues en Power BI.

    activo SMALLINT                     -- 1 = disponible, 0 = descontinuado. La consigna sugiere
                                         -- TINYINT(1) (tipo de MySQL), pero se reemplaza por
                                         -- SMALLINT porque TINYINT no es un tipo estandar ni en
                                         -- PostgreSQL ni en SQL Server con esa sintaxis, y
                                         -- SMALLINT si es compatible con ambos motores, cumpliendo
                                         -- el criterio de aceptacion del ejercicio.
);

-- ── SECCION DML ──────────────────────────

-- INSERT INTO
-- Carga de los 10 productos actuales del inventario de BodegaTech.
INSERT INTO inventario
    (id_producto, nombre_producto, categoria, precio_unitario, stock_actual, stock_minimo, fecha_ingreso, activo)
VALUES
    (1,  'Laptop Pro 15',          'Computacion',    1200.00, 15, 3,  '2024-01-10', 1),
    (2,  'Mouse Inalambrico',      'Accesorios',       28.00, 80, 10, '2024-01-10', 1),
    (3,  'Monitor 4K 27"',         'Computacion',     450.00, 12, 2,  '2024-01-15', 1),
    (4,  'Teclado Mecanico',       'Accesorios',       95.00, 40, 5,  '2024-01-15', 1),
    (5,  'Laptop Basic 14',        'Computacion',     650.00, 20, 3,  '2024-02-01', 1),
    (6,  'Auriculares BT Pro',     'Audio',           120.00, 35, 5,  '2024-02-01', 1),
    (7,  'Hub USB-C 7 puertos',    'Accesorios',       45.00, 60, 10, '2024-02-10', 1),
    (8,  'Webcam HD 1080p',        'Accesorios',       85.00, 25, 5,  '2024-02-10', 1),
    (9,  'SSD Externo 1TB',        'Almacenamiento',  130.00, 18, 3,  '2024-03-01', 1),
    (10, 'Parlante Bluetooth',     'Audio',            60.00, 45, 8,  '2024-03-01', 1);

-- UPDATE ventas del dia
-- Se registran las ventas descontando unidades del stock_actual.
-- Cada UPDATE incluye WHERE id_producto = X para no afectar al resto de los productos.
UPDATE inventario SET stock_actual = stock_actual - 3  WHERE id_producto = 1;  -- Laptop Pro 15: 15 - 3 = 12
UPDATE inventario SET stock_actual = stock_actual - 12 WHERE id_producto = 2;  -- Mouse Inalambrico: 80 - 12 = 68
UPDATE inventario SET stock_actual = stock_actual - 5  WHERE id_producto = 6;  -- Auriculares BT Pro: 35 - 5 = 30

-- UPDATE producto descontinuado
-- La Webcam HD 1080p (id 8) fue descontinuada por el proveedor: se marca como inactiva.
UPDATE inventario SET activo = 0 WHERE id_producto = 8;

-- SELECT validaciones
-- Se revisa la tabla completa para confirmar que la carga y las actualizaciones quedaron correctas.
SELECT * FROM inventario;
