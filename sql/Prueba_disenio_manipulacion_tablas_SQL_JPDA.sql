
-- Script base para la Prueba - Diseño y manipulación de tablas SQL 

-- Eliminar tablas si existen previamente
DROP TABLE IF EXISTS ventas;
DROP TABLE IF EXISTS productos;
DROP TABLE IF EXISTS sucursales;
DROP TABLE IF EXISTS clientes;

-- Crear tabla de clientes
CREATE TABLE clientes (
    id_cliente INT PRIMARY KEY,
    nombre TEXT,
    correo TEXT,
    ciudad TEXT
);

-- Crear tabla de productos
CREATE TABLE productos (
    id_producto INT PRIMARY KEY,
    nombre_producto TEXT,
    categoria TEXT,
    precio NUMERIC
);

-- Crear tabla de sucursales
CREATE TABLE sucursales (
    id_sucursal INT PRIMARY KEY,
    nombre_sucursal TEXT,
    ciudad TEXT
);

-- Crear tabla de ventas
CREATE TABLE ventas (
    id_venta INT PRIMARY KEY,
    id_cliente INT,
    id_producto INT,
    id_sucursal INT,
    fecha DATE,
    cantidad INT,
    total NUMERIC,
    FOREIGN KEY (id_cliente) REFERENCES clientes(id_cliente),
    FOREIGN KEY (id_producto) REFERENCES productos(id_producto),
    FOREIGN KEY (id_sucursal) REFERENCES sucursales(id_sucursal)
);

-- Insertar datos de ejemplo en clientes
INSERT INTO clientes VALUES
(1, 'Camila Rojas', 'camila@mail.com', 'Valparaíso'),
(2, 'Luis Pérez', 'luis@mail.com', 'Santiago'),
(3, 'Daniela Soto', 'daniela@mail.com', 'Concepción');

-- Insertar datos de ejemplo en productos
INSERT INTO productos VALUES
(1, 'Notebook Lenovo', 'Tecnología', 550000),
(2, 'Mouse Inalámbrico', 'Accesorios', 15000),
(3, 'Teclado Mecánico', 'Accesorios', 45000);

-- Insertar datos de ejemplo en sucursales
INSERT INTO sucursales VALUES
(1, 'Tienda Centro', 'Santiago'),
(2, 'Tienda Online', 'Internet'),
(3, 'Tienda Valpo', 'Valparaíso');

-- Insertar datos de ejemplo en ventas
INSERT INTO ventas VALUES
(1, 1, 1, 2, '2024-06-21', 1, 550000),
(2, 2, 2, 1, '2024-06-22', 2, 30000),
(3, 3, 3, 3, '2024-06-23', 1, 45000),
(4, 1, 2, 2, '2024-07-01', 1, 15000);

-- Cambia tipo text a varchar
ALTER TABLE sucursales ALTER COLUMN nombre_sucursal VARCHAR(100);
ALTER TABLE clientes ALTER COLUMN nombre VARCHAR(100);
ALTER TABLE productos ALTER COLUMN nombre_producto VARCHAR(100);
ALTER TABLE sucursales ALTER COLUMN ciudad VARCHAR(100);



-- ═══════════════════════════════════════════════════════════════════════════
-- 1. CREAR ESTRUCTURA DE TABLA CON RESTRICCIONES 
-- ═══════════════════════════════════════════════════════════════════════════


-- Crea una nueva tabla llamada proveedores_capacitaciones, definiendo adecuadamente sus columnas y restricciones.

CREATE TABLE proveedores_capacitaciones (
    id_proveedor INT IDENTITY(1,1) PRIMARY KEY, --Clave primaria que va aumentando con cada registro, identificador único
    razon_social VARCHAR(250) NOT NULL, --Nombre de la razón social del proveedor, obligatorio, max. 250 caracteres según Tu Empresa En Un Día
    rut VARCHAR(12) NOT NULL UNIQUE, --Rol Único Tributario de la razón social del proveedor, obligatorio y único
    categoria VARCHAR (10) NOT NULL CHECK (categoria IN ('Interno', 'Externo')), --Categoría limitada únicamente a 'Interno' o 'Externo', obligatorio
    estado BIT DEFAULT 1 --Estado operativo del proveedor: por defecto activo (TRUE)
);


-- ═══════════════════════════════════════════════════════════════════════════
-- 2. INSERTAR Y VALIDAR REGISTROS
-- ═══════════════════════════════════════════════════════════════════════════


-- CONSULTA 1: Inserta al menos 4 proveedores válidos. 

INSERT INTO proveedores_capacitaciones
VALUES
('Capacitaciones Julio El Bacán SpA', '76123456-1', 'Interno', 1),
('Consultora Perrito Robaempanadas Ltda', '77987654-2', 'Externo', 1),
('Instituto Firulais S.A.', '65111222-K', 'Externo', 1),
('Formación El Negro Matapacos E.I.R.L.', '78333444-5', 'Interno', 0);


-- CONSULTA 2: Realiza 2 inserciones erróneas (una por duplicación de rut, 
--             otra por categoría no válida) y documenta los errores generados.

INSERT INTO proveedores_capacitaciones
VALUES
('Capacitaciones Hackiko SpA', '76123456-1', 'Externo', 1), --Duplicación de rut con Capacitaciones Julio El Bacán SpA
('Doggy Style Chile Ltda', '76688394-3', 'Internacional', 1); --Categoría no válida

-- Error 1: la llave UNIQUE puesta en la línea 89, hizo que SQL Server prohibiera una potencial duplicación de datos
-- Error 2: se truncó el valor 'Internacional' en la columna categoría porque la regla CHECK sólo permite dos registros 'Interno' o 'Externo'


-- ═══════════════════════════════════════════════════════════════════════════
-- 3. ACTUALIZAR INFORMACIÓN
-- ═══════════════════════════════════════════════════════════════════════════


-- CONSULTA 1: Actualiza la categoría de un proveedor de 'Interno' a 'Externo'.

UPDATE proveedores_capacitaciones
SET categoria = 'Externo'
WHERE id_proveedor = 1;


-- CONSULTA 2: Cambia el estado de otro proveedor a FALSE.

UPDATE proveedores_capacitaciones
SET estado = 0
WHERE id_proveedor = 2;

SELECT * FROM proveedores_capacitaciones;


-- ═══════════════════════════════════════════════════════════════════════════
-- 4. ELIMINAR REGISTROS CON CONDICIONES
-- ═══════════════════════════════════════════════════════════════════════════


-- CONSULTA 1: Elimina el proveedor cuyo estado sea FALSE, asegurando el uso de cláusula WHERE.

DELETE FROM proveedores_capacitaciones
WHERE estado = 0;

SELECT * FROM proveedores_capacitaciones;

-- a) Prevención de Pérdida Masiva de Datos:
-- En SQL, la instrucción 'DELETE FROM tabla' sin una cláusula 'WHERE' elimina 
-- TODOS los registros existentes en la tabla de forma inmediata.

-- b) Integridad Operativa y de Negocio:
-- Omitir el filtro en entornos de producción eliminaría la información histórica 
-- de proveedores, rompiendo la continuidad operativa y causando un impacto severo.