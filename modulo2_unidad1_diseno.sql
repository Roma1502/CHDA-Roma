
USE RetailPro;
DROP TABLE IF EXISTS Clientes;
CREATE TABLE clientes(
id_cliente int NOT NULL PRIMARY KEY, 
nombre varchar(100) NOT NULL,
perfil_bio varchar(255) NOT NULL,
fecha_registro date NOT NULL,
);

DROP TABLE IF EXISTS Productos;
CREATE TABLE productos(
id_producto int NOT NULL PRIMARY KEY,
descripcion  varchar(255) NOT NULL, 
precio DECIMAL(10,2) NOT NULL, 
esta_activo BIT,
);
SELECT DB_NAME() AS CurrentDatabase;