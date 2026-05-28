-- Primary key check

SELECT 
	cid,
	cntry
FROM silver.erp_loc_a101
WHERE cid NOT IN (SELECT cst_key FROM silver.crm_cust_info)


-- Check Data Standardiztaion & Consistency

SELECT DISTINCT cntry 
FROM silver.erp_loc_a101
ORDER BY cntry
