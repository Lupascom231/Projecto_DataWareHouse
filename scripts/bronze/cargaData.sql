/*
Carga de datos: Este Script carga los datos pero no guarda historial
por ende cada que se ejecuta este borra los datos existentes y carga los datos del
ERP y CRM
USO: Cambiar los FROM con la direccion de tus datos
Ejemplo mio: C:\Users\gaelo\Downloads\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_crm\cust_info.csv
*/

CREATE OR ALTER PROCEDURE bronze.load_bronze AS
BEGIN
	DECLARE @start_time DATETIME, @end_time DATETIME, @batch_start_time DATETIME, @batch_end_time DATETIME;
	BEGIN TRY
		SET @batch_start_time = GETDATE();
		PRINT '====================================';
		PRINT 'Cargando Bronze Layer';
		PRINT '====================================';

		PRINT '-------------------------'
		PRINT 'CARGANDO CRM TABLE'
		PRINT '-------------------------'
		SET @start_time = GETDATE();
		PRINT '>> Truncando tabla: bronze.crm_cust_info'
		TRUNCATE TABLE bronze.crm_cust_info
		PRINT '>>Insertando datos en la tabla: bronze.crm_cust_info'
	
		BULK INSERT bronze.crm_cust_info
		FROM 'C:\Users\gaelo\Downloads\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_crm\cust_info.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();

		PRINT '>> Tiempo de Carga: ' + CAST(DATEDIFF(MILLISECOND, @start_time,@end_time) AS NVARCHAR) + ' MiliSegundos';
		SELECT COUNT(*) FROM bronze.crm_cust_info;

		PRINT '>> Truncando tabla: bronze.crm_prd_info'
		TRUNCATE TABLE bronze.crm_prd_info
		PRINT '>> Insertando datos en la tabla: bronze.crm_prd_info'
		BULK INSERT bronze.crm_prd_info
		FROM 'C:\Users\gaelo\Downloads\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_crm\prd_info.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);

		SELECT COUNT(*) FROM bronze.crm_prd_info

		PRINT '>> Truncando tabla: bronze.crm_sales_details'
		TRUNCATE TABLE bronze.crm_sales_details
		PRINT '>> Insertando datos en tabla: bronze.crm_sales_details'

		BULK INSERT bronze.crm_sales_details
		FROM 'C:\Users\gaelo\Downloads\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_crm\sales_details.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);

		SELECT COUNT(*) FROM bronze.crm_sales_details

		PRINT '-------------------------'
		PRINT 'CARGANDO ERP TABLE'
		PRINT '-------------------------'

		PRINT '>> Truncando tabla: bronze.erp_cust_az12'
		TRUNCATE TABLE bronze.erp_cust_az12
		PRINT '>> Insertando datos en tabla: bronze.erp_cust_az12'
		BULK INSERT bronze.erp_cust_az12
		FROM 'C:\Users\gaelo\Downloads\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_erp\CUST_AZ12.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);

		SELECT COUNT(*) FROM bronze.erp_cust_az12

		PRINT '>> Truncando tabla: bronze.erp_loc_a101'
		TRUNCATE TABLE bronze.erp_loc_a101
		PRINT '>> Insertando datos en tabla: bronze.erp_loc_a101'
		BULK INSERT bronze.erp_loc_a101
		FROM 'C:\Users\gaelo\Downloads\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_erp\LOC_A101.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);

		SELECT COUNT(*) FROM bronze.erp_loc_a101

		PRINT '>> Truncando tabla: bronze.erp_px_cat_g1v2'
		TRUNCATE TABLE bronze.erp_px_cat_g1v2
		PRINT '>> Insertando datos en tabla: bronze.erp_px_cat_g1v2'
		BULK INSERT bronze.erp_px_cat_g1v2
		FROM 'C:\Users\gaelo\Downloads\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_erp\PX_CAT_G1V2.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @batch_end_time = GETDATE()

		PRINT '>> TIEMPO TOTAL DE CARGA: ' + CAST(DATEDIFF(MILLISECOND, @batch_start_time,@batch_end_time) AS NVARCHAR) + ' MiliSegundos';
		SELECT COUNT(*) FROM bronze.erp_px_cat_g1v2
		END TRY
		BEGIN CATCH
		PRINT '============================='
		PRINT 'OCURRIO UN ERROR DURANTE LA CARGA A LA BRONZE LAYER'
		PRINT 'ERROR: ' + ERROR_MESSAGE();
		PRINT 'ERROR: ' + CAST(ERROR_NUMBER() AS NVARCHAR);
		PRINT 'ERROR: ' + CAST(ERROR_STATE() AS NVARCHAR);
		PRINT '============================='
		END CATCH
END
