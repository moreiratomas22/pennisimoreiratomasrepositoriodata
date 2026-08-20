-- =====================================================================
-- Curso: Data Analytics
-- Modulo: Modelos y Disenos de Bases de Datos
-- Ejercicio: Diseno y creacion de tablas SQL - Sistema de Gestion de Ventas
-- Archivo entregable: quizz1M3.sql
-- Compatible con: PostgreSQL y SQL Server
-- =====================================================================

-- -----------------------------------------------------------------
-- 1. TABLA DE CLIENTES
-- -----------------------------------------------------------------
CREATE TABLE clientes (
    id_cliente INT,                    -- Identificador numerico entero, unico por cliente.
                                        -- No requiere decimales ni texto, por eso se usa INT.

    nombre VARCHAR(100),                -- Texto de longitud variable con un limite razonable (100
                                        -- caracteres) para nombres y apellidos. No usamos TEXT aqui
                                        -- porque el nombre tiene un tamano acotado y previsible,
                                        -- lo que hace mas eficiente el almacenamiento y la busqueda.

    perfil_bio TEXT,                    -- Texto largo y de extension variable (biografia o notas
                                        -- del cliente). Se usa TEXT en lugar de VARCHAR porque no
                                        -- conviene fijar un limite de caracteres para este campo.

    fecha_registro DATE                 -- Solo interesa el dia en que el cliente se registro, no la
                                        -- hora exacta. Por eso se usa DATE y no TIMESTAMP/DATETIME.
                                        -- Ademas, guardarlo como tipo fecha (y no como texto) permite
                                        -- que herramientas como Power BI reconozcan el campo como
                                        -- fecha y habiliten funciones de tiempo automaticamente.
);

-- -----------------------------------------------------------------
-- 2. TABLA DE PRODUCTOS
-- -----------------------------------------------------------------
CREATE TABLE productos (
    id_producto INT,                    -- Identificador numerico entero, unico por producto.

    descripcion VARCHAR(255),           -- Texto de longitud variable con un limite mayor (255
                                        -- caracteres) porque una descripcion de producto suele ser
                                        -- mas extensa que un nombre de cliente, pero sigue siendo
                                        -- acotada, por lo que no hace falta usar TEXT.

    precio DECIMAL(10, 2),              -- Se usa DECIMAL (y no FLOAT) porque FLOAT es un tipo de
                                        -- punto flotante que puede introducir errores de redondeo
                                        -- en calculos monetarios. DECIMAL(10, 2) permite hasta 10
                                        -- digitos en total, con 2 despues del punto decimal,
                                        -- suficiente para representar precios con exactitud.

    esta_activo SMALLINT                -- Indica si el producto esta a la venta (1) o no (0).
                                        -- Se elige SMALLINT en lugar de BOOLEAN porque BOOLEAN no
                                        -- esta soportado de forma nativa en SQL Server, mientras que
                                        -- SMALLINT (0/1) funciona igual en PostgreSQL y en SQL
                                        -- Server, garantizando la compatibilidad pedida en el
                                        -- ejercicio. Un numero entero pequeno es mas eficiente que
                                        -- guardar 'true'/'false' como texto.
);
