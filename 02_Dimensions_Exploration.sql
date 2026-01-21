/* -----------------------------------------------------
- DIMENSIONS EXPLORATION
- EXPLORE THE STRUCTURE OF THE TABLES

FUNCTIONS USED
	- DISTINCT
	- ORDER BY
----------------------------------------------------- */

-- Explore All Countries our customers come from 
SELECT DISTINCT country FROM gold.dim_customers

-- Explore All categories "The major Divisions"
SELECT DISTINCT category, subcategory, product_name from gold.dim_products
ORDER BY 1,2,3
