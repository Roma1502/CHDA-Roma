SELECT COUNT(*) AS categorias
FROM dbo.categorias;

SELECT COUNT(*) AS clientes
FROM dbo.clientes;

SELECT COUNT(*) AS productos
FROM dbo.productos;

SELECT COUNT(*) AS ventas
FROM dbo.ventas;
INSERT INTO ventas (id_venta, id_producto, id_cliente, fecha_venta, cantidad)
VALUES
SELECT COUNT(*) AS categorias FROM categorias;
SELECT COUNT(*) AS clientes FROM clientes;
SELECT COUNT(*) AS productos FROM productos;
SELECT COUNT(*) AS ventas FROM ventas;

INSERT INTO ventas (id_venta, id_cliente, id_producto, cantidad, precio_unitario, fecha_venta) VALUES
  ( 1, 1, 1, 2, 1200.00, '2024-03-05'),
  ( 2, 2, 2, 5,   28.00, '2024-03-06'),
  ( 3, 3, 3, 1,  450.00, '2024-03-07'),
  ( 4, 1, 4, 2,  120.00, '2024-03-08'),
  ( 5, 4, 5, 3,  130.00, '2024-03-10'),
  ( 6, 2, 6, 4,   95.00, '2024-03-11'),
  ( 7, 5, 1, 1, 1200.00, '2024-03-12'),
  ( 8, 3, 2, 8,   28.00, '2024-03-13'),
  ( 9, 4, 4, 1,  120.00, '2024-03-14'),
  (10, 5, 3, 2,  450.00, '2024-03-15');
GO