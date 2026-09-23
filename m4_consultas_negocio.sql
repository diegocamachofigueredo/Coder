-- ============================================================
-- PRE-ENTREGA M4 - CONSULTAS SQL DE NEGOCIO
-- Base de datos: Ventas_Tech_DB
-- Tabla utilizada: ventas
-- ============================================================

-- ============================================================
-- CONSULTA 1 - RESUMEN EJECUTIVO MENSUAL
-- Total facturado, cantidad de pedidos y ticket promedio
-- agrupados por mes.
-- ============================================================

SELECT
    EXTRACT(MONTH FROM fecha_venta) AS mes,
    SUM(cantidad * precio_unitario) AS total_facturado,
    COUNT(*) AS cantidad_pedidos,
    AVG(cantidad * precio_unitario) AS ticket_promedio
FROM ventas
GROUP BY EXTRACT(MONTH FROM fecha_venta)
ORDER BY mes;

-- ============================================================
-- CONSULTA 2 - RANKING DE PRODUCTOS
-- Top 5 de productos según total facturado.
-- ============================================================

SELECT
    id_producto,
    SUM(cantidad) AS unidades_vendidas,
    SUM(cantidad * precio_unitario) AS total_facturado
FROM ventas
GROUP BY id_producto
ORDER BY total_facturado DESC
LIMIT 5;

-- ============================================================
-- CONSULTA 3 - CLIENTES RECURRENTES
-- Clientes que realizaron más de un pedido.
-- ============================================================

SELECT
    id_cliente,
    COUNT(*) AS cantidad_pedidos,
    SUM(cantidad * precio_unitario) AS total_gastado
FROM ventas
GROUP BY id_cliente
HAVING COUNT(*) > 1
ORDER BY total_gastado DESC;

-- ============================================================
-- CONSULTA 4 - MESES POR ENCIMA/POR DEBAJO DEL PROMEDIO
-- Compara la facturación mensual contra el promedio
-- mensual general.
-- ============================================================

WITH facturacion_mensual AS (
    SELECT
        EXTRACT(MONTH FROM fecha_venta) AS mes,
        SUM(cantidad * precio_unitario) AS total_facturado
    FROM ventas
    GROUP BY EXTRACT(MONTH FROM fecha_venta)
)

SELECT
    mes,
    total_facturado,
    CASE
        WHEN total_facturado > (
            SELECT AVG(total_facturado)
            FROM facturacion_mensual
        )
        THEN 'Por encima'
        ELSE 'Por debajo'
    END AS comparacion_promedio
FROM facturacion_mensual
ORDER BY mes;


-- ============================================================
-- HALLAZGOS
-- ============================================================

-- 1. El mes 3 fue el de mayor facturación del período analizado.
-- 2. El producto 4 lideró el ranking tanto en unidades vendidas
--    como en facturación.
-- 3. El cliente 7 fue el cliente recurrente con mayor gasto total.