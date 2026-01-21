/* ------------------------------------------------------------------------
- CHANGES OVER TIME
- ANALYZE HOW A MEASURE EVOLVES OVER TIME
- HELPS TRACK TRENDS AND IDENTIFY SEASONALITY IN OUR DATA
- TO MEASURE INCREASES AND DECLINES ACROSS DEFINED TIME PERIODS

FUNCTIONS
	- DATE FUNCTIONS: DATETRUNC(), DATEPART(), FORMAT()
	- AGGREGATE FUNCTIONS: SUM(), COUNT(), AVG()
---------------------------------------------------------------------------- */

SELECT
DATETRUNC(MONTH, order_date) as Order_Date,
SUM(sales_amount) AS Total_Sales,
COUNT(DISTINCT customer_key) AS Total_Customers,
SUM(quantity) AS Total_Quantity
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY DATETRUNC(MONTH, order_date)
ORDER BY DATETRUNC(MONTH, order_date)