# RetailPro — Proyecto Analista de Datos | Coderhouse

Proyecto de análisis de ventas para RetailPro, construido en el curso de Analista de Datos de Coderhouse.

El objetivo es que cualquier analista nuevo pueda entender el proyecto, reproducir los resultados y continuarlo sin depender de quien lo creó.

- **Autora:** Romina Rossi (Roma1502)
- **Bases de datos:** `Retailpro` (Pre-entrega 4) y `Ventas_Tech_DB` (Pre-entrega 5)
- **Motor SQL:** Microsoft SQL Server (SSMS)
- **Modelo analítico:** Power BI, sobre el dataset `Pipeline_ETL_Dataset.xlsx` (ver sección *Power BI*)

## Herramientas usadas

- **SQL Server (SSMS):** consultas, JOINs, agregaciones, vistas.
- **Power BI:** Power Query (ETL), modelo de datos con relaciones, tabla calendario y medidas DAX.
- **Excel:** fuente del dataset de Power BI y controles manuales.
- **IA (versiones gratuitas):** [COMPLETAR: herramientas de IA que realmente usaste]. Se usó para borradores de documentación y revisión de SQL. Todos los resultados fueron verificados manualmente.
- No se usaron modelos predictivos ni Machine Learning: están fuera del alcance del curso.

## Estructura del repositorio

- **Pre-entrega 4:** consultas SQL de negocio (`Entrega_4_Romina_Rossi.sql`)
- **Pre-entrega 5:** consultas con JOINs (`Entrega_5_Romina_Rossi.sql`)
- **Power BI:** `Pipeline_ETL_Rossi_Romina.pbix` (ETL) y `Rossi_Romina_Checkpoint2.pbix` (modelo y medidas)
- **Pre-entrega 9:** documentación y trazabilidad

## Cómo ejecutar los scripts SQL

### 1. Preparar la base

Abrí SQL Server Management Studio (SSMS) y seleccioná la base que corresponde a cada archivo:

```sql
-- Pre-entrega 4
USE Retailpro;
GO

-- Pre-entrega 5
USE Ventas_Tech_DB;
GO
```

### 2. Ejecutar en orden

Ejecutá cada archivo por separado, sin mezclar sus consultas (ver la sección *Importante* más abajo).

**Pre-entrega 4 — Consultas SQL de negocio**

1. Resumen ejecutivo mensual
2. Ranking de productos (TOP 5)
3. Clientes recurrentes
4. Meses por encima / por debajo del promedio

**Pre-entrega 5 — Consultas con JOINs**

1. Consulta 1: vista base del proyecto (INNER JOIN): ventas + clientes + productos + categorías
2. Consulta 2: clientes sin ventas (LEFT JOIN)
3. Consulta 3: productos sin ventas (LEFT JOIN)
4. Consulta 4: consolidado por período (UNION ALL)

### Vista base validada

Pre-entrega 5, Consulta 1 (base `Ventas_Tech_DB`), revisada en la Pre-entrega 9 (Tarea 1):

```sql
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
```

## Importante — dos bases de datos distintas

La Pre-entrega 4 se ejecuta sobre la base `Retailpro` (tabla `dbo.Ventas`, con columnas `FechaCompra` / `MontoTotal` / `ProductID` / `CustomerID` / `Cantidad`).

La Pre-entrega 5 se ejecuta sobre `Ventas_Tech_DB` (tablas `dbo.ventas`, `dbo.clientes`, `dbo.productos` y `dbo.categorias`, con columnas `fecha_venta` / `precio_unitario` / `id_producto` / `id_cliente`).

Son datos distintos, así que los montos de una y otra no son comparables. Ejecutar un script sobre la base equivocada falla por objetos o columnas inexistentes. Antes de unir resultados, estandarizar los nombres en una vista o CTE.

## Power BI (módulos 6 a 8)

**Fuente de datos:** `Pipeline_ETL_Dataset.xlsx` (50 ventas, de enero de 2023 a julio de 2024). Es un dataset distinto de `Ventas_Tech_DB`, por lo que **sus montos no son comparables con los de las consultas SQL**.

### ETL en Power Query (`Pipeline_ETL_Rossi_Romina.pbix`)

| Tabla | Filas finales | Decisiones principales |
|---|---|---|
| `Dim_Clientes` | 11 | Duplicado eliminado por `id_cliente`. Nulos de `email` y `ciudad` reemplazados por "Sin datos" para no perder ventas asociadas. |
| `Dim_Productos` | 12 | Duplicado eliminado por `id_producto` (103). Precio nulo del producto 109 reemplazado por 130, el `precio_unitario` de sus 5 ventas. Categoría nula del producto 111 asignada a "Computación", por su subcategoría "Laptops". |
| `Dim_Categorias` | 4 | Sin cambios de calidad. Solo tipado de columnas. |
| `Fact_Ventas` | 50 | Merge con `Dim_Productos` por `id_producto` para incorporar `nombre_producto` y `categoria`. |

### Modelo y medidas (`Rossi_Romina_Checkpoint2.pbix`)

Esquema en estrella con filtro en una sola dirección (de la dimensión hacia los hechos):

- `Dim_Clientes[id_cliente]` → `Fact_Ventas[id_cliente]`
- `Dim_Productos[id_producto]` → `Fact_Ventas[id_producto]`
- `Dim_Fechas[Date]` → `Fact_Ventas[fecha_venta]` (marcada como tabla de fechas)
- `Dim_Categorias[nombre_categoria]` → `Dim_Productos[categoria]`

Las medidas están en la tabla `_Medidas`: `Total Ventas`, `Ventas Online`, `Ventas YTD`, `Ventas LY` y `% Crecimiento Anual`.

### Cómo abrirlo

Abrí el archivo `.pbix` con Power BI Desktop. El archivo guarda la ruta local del Excel: si lo movés, actualizala desde *Inicio → Transformar datos → Configuración de origen de datos*.

## Resultados principales verificados (Pre-entrega 4)

Todos los números de esta sección fueron verificados manualmente en SSMS. Fuente: scripts de la Pre-entrega 4, base `Retailpro`. Los datos van de 2024-04-05 a 2025-04-07.

- **Mes de mayor facturación:** mes 8 (agosto de 2024) — $128.471,18, por encima del promedio mensual.
- **Mes de menor facturación:** mes 11 (noviembre de 2024) — $82.598,56, por debajo del promedio mensual.
- **Promedio mensual:** $104.135,34.
- **Producto TOP 1:** `PRD-001` — $435.496,65 en 330 unidades. Concentra el 34,8 % de la facturación con el 4,6 % de las unidades.
- **Clientes recurrentes:** los 200 clientes de la base hicieron más de un pedido, así que el 100 % de la facturación proviene de clientes recurrentes. Por eso el criterio no segmenta.

**Ranking de productos (Top 5 por facturación):**

| Producto | Unidades | Total facturado | % de la facturación | % de las unidades |
|---|---|---|---|---|
| `PRD-001` | 330 | $435.496,65 | 34,8 % | 4,6 % |
| `PRD-002` | 306 | $213.496,95 | 17,1 % | 4,3 % |
| `PRD-005` | 228 | $104.397,68 | 8,4 % | 3,2 % |
| `PRD-006` | 350 | $87.496,50 | 7,0 % | 4,9 % |
| `PRD-016` | 221 | $67.497,75 | 5,4 % | 3,1 % |

**Pre-entrega 5 — consolidado por período (base `Ventas_Tech_DB`):**

- Período 1 (antes del 2024-03-10): $3.230,00
- Período 2 (desde el 2024-03-10): $3.214,00

Los montos de la Pre-entrega 4 y de la Pre-entrega 5 no son comparables entre sí.

**Interpretación con criterio analítico:**

- El TOP 1 no es solo una "estrella": también es un riesgo de concentración. Si `PRD-001` falla, se cae cerca de un tercio de la facturación (34,8 %).
- Como todos los clientes son recurrentes, para fidelización conviene segmentar por gasto (por ejemplo, el 10 % de clientes que más gasta) y no por cantidad de pedidos.
- Comparar solo el mes máximo con el mínimo no es una tendencia. Para hablar de tendencia se necesita la serie completa.

## Uso de IA en este proyecto (Pre-entrega 9)

Se usó IA para generar borradores de:

- Optimización de la Consulta 1 (vista base).
- Hallazgos comerciales del resumen mensual y el ranking.
- Este README.

**Decisiones finales:**

- Se aceptó parcialmente la idea de centralizar `total_venta` en una vista o CTE.
- Se rechazó cambiar INNER JOIN por LEFT JOIN en la vista base, porque toda venta debe tener cliente y producto.
- Se rechazó una inferencia de "tendencia de caída del 55%" hecha por la IA, porque comparaba solo dos meses aislados.
- Se corrigieron cifras y herramientas inventadas por la IA en el borrador del README.

**Regla aplicada:** ningún número que no pueda rastrearse hasta su fuente aparece en un reporte que firma mi nombre.

## Limitaciones conocidas

- Las consultas de la Pre-entrega 4 y de la Pre-entrega 5 usan bases distintas, con nombres de columnas distintos (ver sección *Importante*).
- Las consultas mensuales de la Pre-entrega 4 agrupan solo con `MONTH()`. Los datos van de abril de 2024 a abril de 2025, así que el mes 4 mezcla del 2024-04-05 al 2024-04-30 con del 2025-04-01 al 2025-04-07. Los demás meses aparecen una sola vez.
- El modelo de Power BI no incluye la hoja `territorios` del Excel. Para analizar por territorio hay que cargarla y relacionarla con `Dim_Clientes` por `ciudad`.

## Cómo continuar el proyecto

- Estandarizar nombres de columnas entre la Pre-entrega 4 y la 5 en una capa de vista.
- Agrupar los análisis mensuales por año y mes.
- Cargar `territorios` en el modelo de Power BI.
- Agregar margen o costo por producto para pasar de facturación a rentabilidad.
- Construir el dashboard en Power BI siguiendo el boceto de la Pre-entrega 7.
- Documentar cada nuevo cálculo con su fuente.
