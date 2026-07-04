
USE RetailPro;

DROP TABLE IF EXISTS clientes;
CREATE TABLE clientes(
  cliente_id INT NOT NULL PRIMARY KEY,    -- INT porque es un identificador numérico único
  nombre VARCHAR(100) NOT NULL,          -- VARCHAR porque el nombre es texto de longitud acotada
  perfil_bio TEXT NOT NULL,              -- TEXT porque el campo requiere texto largo (no un límite fijo como VARCHAR)
  fecha_registro DATE NOT NULL           -- DATE porque se necesita la fecha (sin hora)
);

DROP TABLE IF EXISTS productos;
CREATE TABLE productos(
  producto_id INT NOT NULL PRIMARY KEY,  -- INT porque es un identificador numérico único
  descripcion VARCHAR(255) NOT NULL,     -- VARCHAR porque la descripción es texto con longitud razonable
  precio DECIMAL(10,2) NOT NULL,        -- DECIMAL con 2 decimales porque se modela dinero con precisión
  esta_activo BIT                        -- BIT porque representa un estado binario (activo/inactivo)
);

SELECT DB_NAME() AS current_database;
