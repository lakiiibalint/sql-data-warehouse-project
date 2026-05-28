-- Check for unwanted Spaces

SELECT 
*
FROM silver.erp_px_cat_g1v2
WHERE cat != TRIM(cat) or subcat != TRIM(subcat) OR maintenance != TRIM(maintenance)

-- Check data Standardization & Consistency

SELECT DISTINCT 
cat
FROM silver.erp_px_cat_g1v2

SELECT DISTINCT 
subcat
FROM silver.erp_px_cat_g1v2

SELECT DISTINCT 
maintenance
FROM silver.erp_px_cat_g1v2