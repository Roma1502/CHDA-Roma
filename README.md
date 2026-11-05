RetailPro — Proyecto Analista de Datos | Coderhouse

Proyecto de análisis de ventas para RetailPro, construido en el curso de Analista de Datos de Coderhouse.

El objetivo es que cualquier analista nuevo pueda entender el proyecto, reproducir los resultados y continuarlo sin depender de quien lo creó.

Autora: Romina Rossi (Roma1502)
Base de datos: Ventas_Tech_DB
Motor SQL: Microsoft SQL Server (SSMS)
Modelo analítico: Power BI, sobre el dataset Pipeline_ETL_Dataset.xlsx (ver sección Power BI)
Herramientas usadas
SQL Server (SSMS): consultas, JOINs, agregaciones, vistas.
Power BI: Power Query (ETL), modelo de datos con relaciones, tabla calendario y medidas DAX.
Excel: fuente del dataset de Power BI y controles manuales.
IA (versiones gratuitas): Claude, Meta, ChatGPT. Se usó para borradores de documentación y revisión de SQL. Todos los resultados fueron verificados manualmente.
No se usaron modelos predictivos ni Machine Learning: están fuera del alcance del curso.

Estructura del repositorio
Pre-entrega 4: consultas SQL de negocio (Entrega_4_Romina_Rossi.sql)
Pre-entrega 5: consultas con JOINs (Entrega_5_Romina_Rossi.sql)
Power BI: Pipeline_ETL_Rossi_Romina.pbix (ETL) y Rossi_Romina_Checkpoint2.pbix (modelo y medidas)
Pre-entrega 9: documentación y trazabilidad

Cómo ejecutar los scripts SQL
1. Preparar la base

Abrí SQL Server Management Studio (SSMS) y seleccioná la base:

sql
USE Ventas_Tech_DB;
GO
2. Ejecutar en orden

Ejecutá cada archivo por separado, sin mezclar sus consultas (ver la sección Importante más abajo).

Pre-entrega 4 — Consultas SQL de negocio

Resumen ejecutivo mensual
Ranking de productos (TOP 5)
Clientes recurrentes
Meses por encima / por debajo del promedio

Pre-entrega 5 — Consultas con JOINs

Consulta 1: vista base del proyecto (INNER JOIN): ventas + clientes + productos + categorías
Consulta 2: clientes sin ventas (LEFT JOIN)
Consulta 3: productos sin ventas (LEFT JOIN)
Consulta 4: consolidado por período (UNION ALL)
Vista base validada

Pre-entrega 5, Consulta 1, revisada en la Pre-entrega 9 (Tarea 1):

sql
WITH ventas_enriquecidas AS (
    SELECT
        v.fecha_venta,
        c.id_cliente,
        c.nombre AS nombre_cliente,
        c.ciudad,
        p.nombre_producto,
        cat.nombre_categoria AS categoria,
        v.cantidad,
        v.precio_unitario,
        v.cantidad * v.precio_unitario AS total_venta
    FROM dbo.ventas AS v
    INNER JOIN dbo.clientes AS c
        ON v.id_cliente = c.id_cliente
    INNER JOIN dbo.productos AS p
        ON v.id_producto = p.id_producto
    INNER JOIN dbo.categorias AS cat
        ON p.id_categoria = cat.id_categoria
)
SELECT * FROM ventas_enriquecidas;
Importante — inconsistencia de nombres a tener en cuenta

La Pre-entrega 4 usa FechaCompra / MontoTotal / ProductID / CustomerID / Cantidad, y la Pre-entrega 5 usa fecha_venta / cantidad / precio_unitario / id_producto / id_cliente.

Antes de unir ambos resultados, estandarizar los nombres en una vista o CTE. No ejecutar los scripts mezclados tal cual, porque van a fallar por los nombres de columnas distintos.

Power BI (módulos 6 a 8)

Fuente de datos: Pipeline_ETL_Dataset.xlsx (50 ventas, de enero de 2023 a julio de 2024). Es un dataset distinto de Ventas_Tech_DB, por lo que sus montos no son comparables con los de las consultas SQL.

ETL en Power Query (Pipeline_ETL_Rossi_Romina.pbix)
Tabla	Filas finales	Decisiones principales
Dim_Clientes	11	Duplicado eliminado por id_cliente. Nulos de email y ciudad reemplazados por "Sin datos" para no perder ventas asociadas.
Dim_Productos	12	Duplicado eliminado por id_producto (103). Precio nulo del producto 109 reemplazado por 130, el precio_unitario de sus 5 ventas. Categoría nula del producto 111 asignada a "Computación", por su subcategoría "Laptops".
Dim_Categorias	4	Sin cambios de calidad. Solo tipado de columnas.
Fact_Ventas	50	Merge con Dim_Productos por id_producto para incorporar nombre_producto y categoria.
Modelo y medidas (Rossi_Romina_Checkpoint2.pbix)

Esquema en estrella con filtro en una sola dirección (de la dimensión hacia los hechos):

Dim_Clientes[id_cliente] → Fact_Ventas[id_cliente]
Dim_Productos[id_producto] → Fact_Ventas[id_producto]
Dim_Fechas[Date] → Fact_Ventas[fecha_venta] (marcada como tabla de fechas)
Dim_Categorias[nombre_categoria] → Dim_Productos[categoria]

Las medidas están en la tabla _Medidas: Total Ventas, Ventas Online, Ventas YTD, Ventas LY y % Crecimiento Anual.

Cómo abrirlo

Abrí el archivo .pbix con Power BI Desktop. El archivo guarda la ruta local del Excel: si lo movés, actualizala desde Inicio → Transformar datos → Configuración de origen de datos.

Resultados principales verificados (Pre-entrega 4)

Todos los números de esta sección fueron verificados manualmente en SSMS. Fuente: scripts de la Pre-entrega 4.

Mes de mayor facturación: mes 8 — $128.471,18 (por encima del promedio mensual).
Mes de menor facturación: mes 11 — $82.598,56 (por debajo del promedio mensual).
Promedio mensual: $104.135,34.
Producto TOP 1: [COMPLETAR: id_producto, total facturado y unidades vendidas] — concentra [COMPLETAR: % de la facturación total] de la facturación con [COMPLETAR: % de las unidades].
Clientes recurrentes: [COMPLETAR: cantidad de clientes con más de un pedido] clientes concentran [COMPLETAR: % de la facturación total].

Pre-entrega 5 — consolidado por período:

Período 1 (antes del 2024-03-10): $3.230,00
Período 2 (desde el 2024-03-10): $3.214,00

Los montos de la Pre-entrega 4 y de la Pre-entrega 5 no son comparables entre sí.

Interpretación con criterio analítico:

El TOP 1 no es solo una "estrella": también es un riesgo de concentración. Si ese producto falla, se cae buena parte de la facturación.
Los clientes recurrentes son el segmento más accionable para CRM y fidelización.
Comparar solo el mes máximo con el mínimo no es una tendencia. Para hablar de tendencia se necesita la serie completa.
Uso de IA en este proyecto (Pre-entrega 9)

Se usó IA para generar borradores de:

Optimización de la Consulta 1 (vista base).
Hallazgos comerciales del resumen mensual y el ranking.
Este README.

Decisiones finales:

Se aceptó parcialmente la idea de centralizar total_venta en una vista o CTE.
Se rechazó cambiar INNER JOIN por LEFT JOIN en la vista base, porque toda venta debe tener cliente y producto.
Se rechazó una inferencia de "tendencia de caída del 55%" hecha por la IA, porque comparaba solo dos meses aislados.
Se corrigieron cifras y herramientas inventadas por la IA en el borrador del README.

Regla aplicada: ningún número que no pueda rastrearse hasta su fuente aparece en un reporte que firma mi nombre.

Limitaciones conocidas
Las consultas de la Pre-entrega 4 y de la Pre-entrega 5 usan nombres de columnas distintos (ver sección Importante).
Las consultas mensuales agrupan solo con MONTH(). Si la tabla abarca más de un año, hay que agrupar también por año; si no, se mezclan los mismos meses de años distintos.
El modelo de Power BI no incluye la hoja territorios del Excel. Para analizar por territorio hay que cargarla y relacionarla con Dim_Clientes por ciudad.
