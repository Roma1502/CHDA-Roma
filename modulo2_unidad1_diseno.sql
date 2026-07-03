
USE RetailPro;
DROP TABLE IF EXISTS Clientes;
CREATE TABLE Clientes(
ID_Cliente int NOT NULL PRIMARY KEY, 
Nombre varchar(100) NOT NULL,
Perfil_Bio varchar(255) NOT NULL,
Fecha_Registro date NOT NULL,

CREATE TABLE Productos(
ID_Producto int NOT NULL PRIMARY KEY,
Descripcion  varchar(255) NOT NULL, 
Precio DECIMAL(10,2) NOT NULL, 
esta_activo BIT,
);
SELECT DB_NAME() AS CurrentDatabase;