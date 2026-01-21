/* ------------------------------------------------------------------------
- PART TO WHOLE ANALYSIS
- PROPORTIONAL ANALYSIS - CCOMPARE PERFORMANCE METRICS ACROSS DIMENSIONS	
- ANALYZE HOW AN INDIVIDUAL PART IS PERFORMING COMPARED TO THE OVERALL
- ALLOWING US TO UNDERSTAND WHICH CATEGORY HAS THE GREATEST IMPACT ON THE BUSINESS

FUNCTIONS
	- SUM(), AVG(): AGGREGATES VALUES FOR COMPARISION
	- WINDOW FUNCTION: SUM() OVER() FOR TOTAL CALCULATIONS
---------------------------------------------------------------------------- */

-- WHICH CATEGORIES CONTRIBUTE THE MOST TO THE OVERALL SALES?

WITH category_sales AS ( 
SELECT
category,
sum(sales_amount) Total_Sales
FROM gold.fact_sales F
LEFT JOIN gold.dim_products p
ON p.product_key = f.product_key
GROUP BY category)

SELECT
category,
Total_Sales,
SUM(Total_Sales) OVER () Overall_Sales,
CONCAT(ROUND((CAST (Total_Sales AS FLOAT) / SUM(Total_Sales) OVER ()) * 100, 2), '%') AS Percentage_Of_Total
FROM category_sales
ORDER BY Total_Sales DESC