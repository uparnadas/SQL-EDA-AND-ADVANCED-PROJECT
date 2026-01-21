/* ------------------------------------------------------------------------
- PERFORMANCE ANALYSIS
- COMPARING THE CURRENT VALUE TO A TARGET VALUE.
- HELPS MEASURE SUCCESS AND COMPARE PERFORMANCE
- TRACK YEARLY TRENDS AND GROWTH

FUNCTIONS
	- LAG(): USED TO ACCESS DATA FROM THE PREVIOUS ROWS
	- AVG() OVER(): CALCULATES AVERAGE VALUES BETWEEN PARTITIONS
	- CASE: DEFINES CONDITIONAL LOGIC FOR TREND ANALYSIS
---------------------------------------------------------------------------- */

/*ANALYZE THE YEARLY PERFORMANCE OF PRODUCTS BY COMPARING THEIR SALES 
TO BOTH THE AVERAGE SALES PERFORMANCE OF THE PRODUCT AND THE PREVIOUS YEAR'S SALES */


WITH yearly_product_sales AS (
SELECT
YEAR(f.order_date) AS Order_Year,
p.product_name,
SUM(f.sales_amount) AS Current_Sales
FROM gold.fact_sales f
left join gold.dim_products p
on f.product_key = p.product_key
WHERE f.order_date IS NOT NULL
GROUP BY
YEAR(f.order_date),
p.product_name
)

SELECT
Order_Year,
product_name,
Current_Sales,
AVG(Current_Sales) OVER (PARTITION BY product_name) Avg_Sales,
Current_Sales - AVG(Current_Sales) OVER (PARTITION BY product_name) AS Diff_Avg,
CASE WHEN Current_Sales - AVG(Current_Sales) OVER (PARTITION BY product_name) > 0 THEN 'Above Avg'
	 WHEN Current_Sales - AVG(Current_Sales) OVER (PARTITION BY product_name) < 0 THEN 'Below Avg'
	 ELSE 'Avg'
END Avg_Change,
LAG(Current_Sales) OVER (PARTITION BY product_name ORDER BY Order_Year) PY_Sales,
Current_Sales - LAG(Current_Sales) OVER (PARTITION BY product_name ORDER BY Order_Year) AS Diff_PY,
CASE WHEN Current_Sales - LAG(Current_Sales) OVER (PARTITION BY product_name ORDER BY Order_Year) > 0 THEN 'Increase'
	 WHEN Current_Sales - LAG(Current_Sales) OVER (PARTITION BY product_name ORDER BY Order_Year) < 0 THEN 'Decrease'
	 ELSE 'No Change'
END PY_Change
FROM yearly_product_sales
ORDER BY product_name, Order_Year