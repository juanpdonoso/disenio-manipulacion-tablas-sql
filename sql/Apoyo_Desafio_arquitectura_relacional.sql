
-- Script base para el desafío: Arquitectura relacional y consultas básicas en SQL

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
-- 1. APLICACIÓN DE COMBINACIONES ENTRE TABLAS (JOIN)
-- ═══════════════════════════════════════════════════════════════════════════

-- CONSULTA 1: Genera una consulta que muestre el nombre del cliente, producto 
-- comprado y nombre de la tienda, solo para ventas realizadas en julio. 

SELECT
    c.nombre AS cliente,
    p.nombre_producto AS producto,
    s.nombre_sucursal AS tienda,
    v.fecha
FROM ventas AS v
JOIN clientes AS c ON v.id_cliente = c.id_cliente
JOIN productos AS p ON v.id_producto = p.id_producto
JOIN sucursales AS s ON v.id_sucursal = s.id_sucursal
WHERE v.fecha BETWEEN '2024-07-01' AND '2024-07-31';


-- CONSULTA 2: Genera una consulta que indique el total de ventas (suma de montos) por ciudad de tienda.

SELECT
    s.ciudad AS ciudad_tienda,
    SUM(v.total) AS total_venta
FROM ventas AS v
JOIN sucursales AS s ON v.id_sucursal = s.id_sucursal
GROUP BY s.ciudad;


-- ═══════════════════════════════════════════════════════════════════════════
-- 2. USO DE FUNCIONES DE AGREGACIÓN Y CLÁUSULA HAVING 
-- ═══════════════════════════════════════════════════════════════════════════

-- CONSULTA 1: Consulta que muestre el nombre de producto y cantidad total 
-- vendida, pero solo para productos con más de 1 unidad vendida.

SELECT
    p.nombre_producto AS producto,
    SUM(v.cantidad) AS cantidad_total_vendida
FROM ventas AS v
JOIN productos AS p ON v.id_producto = p.id_producto
GROUP BY p.id_producto, p.nombre_producto
HAVING SUM(v.cantidad)>1;


-- CONSULTA 2: Consulta que indique cuántas ventas realizó cada sucursal y el 
-- promedio de total vendido por venta.

SELECT
    s.nombre_sucursal AS tienda,
    COUNT(v.id_venta) AS cantidad_ventas,
    AVG(v.total) AS promedio_por_venta
FROM ventas AS v
JOIN sucursales AS s ON v.id_sucursal = s.id_sucursal
GROUP BY s.id_sucursal, s.nombre_sucursal;


-- ═══════════════════════════════════════════════════════════════════════════
-- 3. SUBCONSULTAS PARA ANÁLISIS ESPECÍFICO
-- ═══════════════════════════════════════════════════════════════════════════

-- CONSULTA 1: Escribe una subconsulta que liste los clientes que han realizado 
-- compras mayores al promedio general de ventas.

SELECT DISTINCT
    c.nombre AS cliente,
    v.total AS monto_venta,
    v.fecha
FROM ventas AS v
JOIN clientes AS c ON v.id_cliente = c.id_cliente
WHERE v.total>(SELECT AVG(total) FROM ventas);


-- CONSULTA 2: Escribe una subconsulta que muestre el nombre de producto más caro vendido.

SELECT DISTINCT
    p.nombre_producto,
    p.precio
FROM productos AS p
WHERE p.id_producto IN (SELECT id_producto FROM ventas)
AND p.precio = (SELECT MAX(p2.precio) 
FROM productos AS p2 
JOIN ventas AS v2 ON p2.id_producto = v2.id_producto);