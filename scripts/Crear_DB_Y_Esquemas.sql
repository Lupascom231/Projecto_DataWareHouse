/*
El script crea la base de datos
Advertencia:
Si la base de datos existe este la va borrar y recrear de 0 con los esquemas correspondientes
*/

USE master;
GO

-- 
IF EXISTS (SELECT 1 FROM sys.databases WHERE name = 'DataWareHouse')
BEGIN
    ALTER DATABASE DataWareHouse SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE DataWareHouse;
END;
GO

-- Crear la base de datos 'DataWareHouse'
CREATE DATABASE DataWareHouse;
GO

USE DataWarehouse;
go
--- if OBJECT_ID()
CREATE SCHEMA bronze;
go
CREATE SCHEMA silver;
go
CREATE SCHEMA gold;
