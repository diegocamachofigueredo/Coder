-- ============================================================
-- PRE-ENTREGA M5 - CONSULTAS CON JOINS PARA EL PROYECTO
-- Base de datos: Ventas_Tech_DB
-- ============================================================

USE Ventas_Tech_DB;


-- ============================================================
-- CONSULTA 1 - VISTA BASE DEL PROYECTO
-- INNER JOIN
--
-- Combina ventas, clientes, productos y categorías para
-- obtener una vista enriquecida que podrá utilizarse como
-- fuente de datos para Power BI.
-- ============================================================

SELECT
    v.id_venta,
    v.fecha_venta,
    c.id_cliente,
    c.nombre AS nombre_cliente,
    c.ciudad,
    p.id_producto,
    p.nombre_producto,
    cat.nombre_categoria,
    v.cantidad,
    v.precio_unitario,
    (v.cantidad * v.precio_unitario) AS total_venta
FROM ventas v
INNER JOIN clientes c
    ON v.id_cliente = c.id_cliente
INNER JOIN productos p
    ON v.id_producto = p.id_producto
INNER JOIN categorias cat
    ON p.id_categoria = cat.id_categoria
ORDER BY v.fecha_venta;


-- ============================================================
-- CONSULTA 2 - CLIENTES SIN VENTAS
-- LEFT JOIN
--
-- Identifica clientes registrados que todavía no realizaron
-- ninguna compra.
-- ============================================================

SELECT
    c.nombre AS nombre_cliente,
    c.email,
    c.fecha_registro
FROM clientes c
LEFT JOIN ventas v
    ON c.id_cliente = v.id_cliente
WHERE v.id_venta IS NULL
ORDER BY c.nombre;


-- ============================================================
-- CONSULTA 3 - PRODUCTOS SIN VENTAS
-- LEFT JOIN
--
-- Identifica productos del catálogo que no poseen ventas
-- registradas.
-- ============================================================

SELECT
    p.nombre_producto,
    cat.nombre_categoria,
    p.precio
FROM productos p
INNER JOIN categorias cat
    ON p.id_categoria = cat.id_categoria
LEFT JOIN ventas v
    ON p.id_producto = v.id_producto
WHERE v.id_venta IS NULL
ORDER BY p.nombre_producto;


-- ============================================================
-- CONSULTA 4 - CONSOLIDADO POR CANAL
-- UNION ALL
--
-- La columna "canal" se genera como un valor literal.
-- Para este proyecto se separan las ventas según ciudad:
-- Buenos Aires y Otras Ciudades.
-- ============================================================

SELECT
    canal,
    SUM(total) AS total_ventas
FROM (

    SELECT
        v.fecha_venta AS fecha,
        (v.cantidad * v.precio_unitario) AS total,
        'Buenos Aires' AS canal
    FROM ventas v
    INNER JOIN clientes c
        ON v.id_cliente = c.id_cliente
    WHERE c.ciudad = 'Buenos Aires'

    UNION ALL

    SELECT
        v.fecha_venta AS fecha,
        (v.cantidad * v.precio_unitario) AS total,
        'Otras Ciudades' AS canal
    FROM ventas v
    INNER JOIN clientes c
        ON v.id_cliente = c.id_cliente
    WHERE c.ciudad <> 'Buenos Aires'

) AS ventas_consolidadas
GROUP BY canal
ORDER BY canal;