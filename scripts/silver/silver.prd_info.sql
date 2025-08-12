INSERT INTO silver.crm_prd_info(
prd_id,
cat_id,
prd_key,
prd_nm,
prd_cost,
prd_line,
prd_start_dt,
prd_end_dt
)
SELECT
prd_id,
--prd_key,
REPLACE(SUBSTRING(prd_key, 1, 5), '-', '_') as cat_id, -- extraer categorias
SUBSTRING(prd_key, 7, LEN(prd_key)) AS prd_key, --Extraer los id de llabe
prd_nm,
ISNULL(prd_cost, 0) as prd_cost, -- si es nullo pasa a 0 
CASE UPPER(TRIM(prd_line)) 
	 WHEN 'M' THEN 'Mountain'
	 WHEN 'R' THEN 'Road'
	 WHEN 'S' THEN 'Other Sales'
	 WHEN 'T' THEN 'Touring'
	 ELSE 'n/a'
end as prd_line, -- Mapeo de datos
CAST(prd_start_dt AS DATE)AS prd_start_dt, -- Conversion de datos
CAST(LEAD(prd_start_dt) OVER (PARTITION BY prd_key ORDER BY prd_start_dt) -1 AS DATE) as prd_end_dt_test -- Calcula la fecha final un dia antes del siguiente start_date
FROM bronze.crm_prd_info

--SELECT id FROM bronze.erp_px_cat_g1v2 

--SELECT sls_prd_key FROM bronze.crm_sales_details WHERE sls_prd_key LIKE 'FK'