-- Check For Nulls or Duplicates in Primary Key
-- Expec : No result
SELECT
	prd_id,
	COUNT(*)
FROM silver.crm_prd_info
GROUP BY prd_id
HAVING COUNT(*) > 1 OR prd_id IS NULL

-- Check for unwanted Spaces
SELECT 
	prd_nm
FROM silver.crm_prd_info
WHERE prd_nm != TRIM(prd_nm)

--Check for NULLS or negatives 
SELECT prd_cost
FROM silver.crm_prd_info
WHERE prd_cost < 0 OR prd_cost IS NULL

-- Data Standardization & Consistency 
SELECT DISTINCT 
prd_line
FROM silver.crm_prd_info

-- Check for Invalid Date Orders

SELECT *
FROM silver.crm_prd_info
WHERE prd_key = 'HL-U509-R'

SELECT *
FROM silver.crm_prd_info