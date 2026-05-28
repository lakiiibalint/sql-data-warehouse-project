-- Primary Key Check

SELECT 
	cst_key
FROM silver.crm_cust_info
WHERE cst_key LIKE 'NAS%'

-- Check Bdate

SELECT DISTINCT 
bdate
FROM bronze.erp_cust_az12
WHERE bdate < '1924-01-01' OR bdate > GETDATE()

-- Data Standardization & Consistency
SELECT DISTINCT gen
FROM silver.erp_cust_az12
