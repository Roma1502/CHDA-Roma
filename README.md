# RetailPro — Proyecto Analista de Datos | Coderhouse

Proyecto de análisis de ventas para RetailPro, construido en el curso de Analista de Datos de Coderhouse.

El objetivo es que cualquier analista nuevo pueda entender el proyecto, reproducir los resultados y continuarlo sin depender de quien lo creó.

Autora: Roma (Roma1502) - Romina Rossi
Base de datos: Ventas_Tech_DB
Motor: Microsoft SQL Server (SSMS)

## Herramientas usadas

- SQL Server (SSMS) — consultas, JOINs, agregaciones, vistas
- Power BI — dashboards y visualización
- Excel — revisión de datos y controles manuales
- ChatGPT-META-Claude (versiones gratuitas) — asistencia para borradores de documentación y revisión de SQL. Todos los resultados fueron verificados manualmente en SSMS.
- No se usaron modelos predictivos / Machine Learning en este proyecto.(basicamente porque no programo codigo y no sabria como hacerlo)

## Estructura del repositorio

- Pre-entrega 4 — Consultas SQL de negocio
- Pre-entrega 5 — Consultas con JOINs
- Pre-entrega 9 — Documentación y trazabilidad

## Cómo ejecutar los scripts SQL

### 1. Preparar la base

Abrí SQL Server Management Studio (SSMS) y usá la base:
USE Ventas_Tech_DB;
GO

### 2. Ejecutar en orden

Pre-entrega 4 — Consultas SQL de negocio
- Resumen ejecutivo mensual
- Ranking de productos (TOP 5)
- Clientes recurrentes
- Meses por encima / por debajo del promedio

Pre-entrega 5 — Consultas con JOINs
- Consulta 1: Vista base del proyecto (INNER JOIN) — ventas + clientes + productos + categorías
- Consulta 2: Clientes sin ventas (LEFT JOIN)
- Consulta 3: Productos sin ventas (LEFT JOIN)
- Consulta 4: Consolidado por período (UNION ALL)

### Abrir en Power BI

Conectar a Ventas_Tech_DB o importar la vista base de la Pre-entrega 5.

## Importante — Inconsistencia de nombres a tener en cuenta

La Pre-entrega 4 usa FechaCompra / MontoTotal / ProductID / CustomerID / Cantidad y la Pre-entrega 5 usa fecha_venta / cantidad / precio_unitario / id_producto / id_cliente.

Antes de unir ambos resultados en Power BI, estandarizar los nombres en una vista / CTE. No ejecutar los scripts mezclados tal cual, porque van a fallar por nombres de columnas distintos.

Ejemplo de vista validada (Pre-entrega 5, Tarea 1 de Pre-entrega 9):

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
  INNER JOIN dbo.clientes AS c ON v.id_cliente = c.id_cliente
  INNER JOIN dbo.productos AS p ON v.id_producto = p.id_producto
  INNER JOIN dbo.categorias AS cat ON p.id_categoria = cat.id_categoria
)
SELECT * FROM ventas_enriquecidas;

## Resultados principales verificados (Pre-entrega 4)

Todos los números de esta sección fueron verificados manualmente en SSMS. Fuente: scripts de Pre-entrega 4.

Nota: Pre-entrega 4 y Pre-entrega 5 usan cortes distintos del dataset, por eso los montos no son comparables entre sí.

- Mes de mayor facturación: Mes 8 — $128.471,18 (por encima del promedio mensual)
- Mes de menor facturación: Mes 11 — $82.598,56 (por debajo del promedio mensual)
- Promedio mensual: $104.135,34
- Producto TOP 1: Concentra ~40% de la facturación total con menos del 25% de las unidades
- Clientes recurrentes: Concentran más del 60% de la facturación total

Pre-entrega 5 — Consolidado por período:
- Periodo 1 (antes del 2024-03-10): $3.230,00
- Periodo 2 (desde el 2024-03-10): $3.214,00

Interpretación con criterio analítico:
- El TOP 1 no es solo una “estrella”, también es un riesgo de concentración: si ese producto falla, se cae ~40% de la facturación.
- Los clientes recurrentes son el segmento más accionable para CRM / fidelización.
- Comparar solo el mes máximo con el mínimo no es una tendencia. Para hablar de tendencia se necesita la serie completa.

## Uso de IA en este proyecto (Pre-entrega 9)

Se usó IA para generar borradores de:
- Optimización de la Consulta 1 (vista base)
- Hallazgos comerciales del resumen mensual + ranking
- Este README

Decisiones finales:
- Se aceptó parcialmente la idea de centralizar total_venta en una vista / CTE.
- Se rechazó cambiar INNER JOIN por LEFT JOIN en la vista base, porque toda venta debe tener cliente y producto.
- Se rechazó una inferencia de “tendencia de caída del 55%” hecha por la IA, porque comparaba solo dos meses aislados.
- Se corrigieron cifras y herramientas inventadas por la IA en el borrador del README.

Regla aplicada: ningún número que no pueda rastrearse hasta su fuente aparece en un reporte que firma mi nombre.

## Cómo continuar el proyecto

- Estandarizar nombres de columnas entre Pre-entrega 4 y 5 en una capa de vista.
- Agregar margen / costo por producto para pasar de facturación a rentabilidad.
- Construir el dashboard en Power BI sobre la vista base ya validada.
- Documentar cada nuevo cálculo con su fuente en SSMS.
