USE Ventas_Tech_DB;
GO

-- Consulta 1
SELECT
    MONTH(fecha_venta) AS Mes,
    SUM(cantidad * precio_unitario) AS Total_Facturado,
    COUNT(*) AS Cantidad_Pedidos,
    AVG(cantidad * precio_unitario) AS Ticket_Promedio
FROM ventas
GROUP BY MONTH(fecha_venta)
ORDER BY Mes;


-- Consulta 2
SELECT TOP 5
 id_producto,
 SUM(cantidad) AS Unidades_Vendidas,
 SUM(cantidad*precio_unitario) AS Total_Facturado
 FROM ventas
GROUP BY id_producto
ORDER BY Total_Facturado DESC;

-- Consulta 3

SELECT
    id_cliente,
    COUNT(*) AS Cantidad_Pedidos,
    SUM(cantidad * precio_unitario) AS Total_Gastado
FROM ventas
GROUP BY id_cliente
HAVING COUNT(*) > 1
ORDER BY Total_Gastado DESC;

-- Consulta 4

WITH VentasPorMes AS
(
    SELECT
        MONTH(fecha_venta) AS Mes,
        SUM(cantidad * precio_unitario) AS Total_Facturado
    FROM ventas
    GROUP BY MONTH(fecha_venta)
)

SELECT
    Mes,
    Total_Facturado,
    CASE
        WHEN Total_Facturado >
             (SELECT AVG(Total_Facturado) FROM VentasPorMes)
        THEN 'Por encima'
        ELSE 'Por debajo'
    END AS Comparacion
FROM VentasPorMes
ORDER BY Mes;

-- ==========================================
-- Hallazgos
-- ==========================================

-- 1. El producto con ID 1 fue el de mayor facturación,
--    generando un total de $3.600,00.

-- 2. Todos los clientes realizaron más de un pedido,
--    por lo que el 100% de los clientes registrados son recurrentes.

-- 3. Las ventas registradas corresponden únicamente al mes de marzo de 2024.
--    En la comparación con el promedio mensual, dicho mes fue clasificado como
--    "Por debajo" según la lógica implementada en la consulta.