/* ------------------------------------------------------------------------
- DATA SEGMENTATION
- GROUP THE DATA BASED ON A SPECIFIC RANGE
- HELPS UNDERSTAND THE CORRELATION BETWEEN TWO MEASURES

FUNCTION
	- CASE: DEFINES CUSTOM SEGMENTATION LOGIC
	- GROUP BY
---------------------------------------------------------------------------- */

-- SEGMENT PRODUCTS INTO COST RANGES AND COUNT HOW MANY PRODUCTS FALL INTO EACH SEGMENT

WITH product_segments AS (
SELECT
product_key,
product_name,
cost,
CASE WHEN cost < 100 THEN 'Below 100'
	 WHEN cost BETWEEN 100 AND 500 THEN '100-500'
	 WHEN cost BETWEEN 500 AND 1000 THEN '500-1000'
	 ELSE 'Above 1000'
END cost_range
FROM gold.dim_products)

SELECT
cost_range,
COUNT(product_key) AS Total_Products
FROM product_segments
GROUP BY cost_range
ORDER BY Total_Products DESC

/* GROUP CUSTOMERS INTO THREE SEGMENTS BASED ON THEIR SPENDING BEHAVIOUR:
	- VIP: CUSTOMERS WITH AT LEAST 12 MONTHS OF HISTORY AND SPENDING MORE THAT €5,000.
	- REGULAR: CUSTOMERS WITH AT LEAST 12 MONTHS OF HISTORY BUT SPENDING €5,000 OR LESS.
	- NEW: CUSTOMERS WITH A LIFESPAN LESS THAN 12 MONTHS.
AND FIND THE TOTAL NUMBER OF CUSTOMERS BY EACH GROUP */

WITH customer_spending AS (
SELECT
c.customer_key,
SUM(f.sales_amount) AS Total_Spending,
MIN(order_date) AS First_Order,
MAX(order_date) AS Last_Order,
DATEDIFF(month, MIN(order_date), MAX(order_date)) AS Lifespan
FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c
ON c.customer_key = f.customer_key
GROUP BY c.customer_key
)
SELECT
customer_segment,
COUNT(customer_key) AS Total_Customers
FROM (
SELECT
customer_key,
Total_Spending,
Lifespan,
CASE WHEN Lifespan >= 12 AND Total_Spending > 5000 THEN 'VIP'
	 WHEN Lifespan >= 12 AND Total_Spending <= 5000 THEN 'REGULAR'
	 ELSE 'NEW'
END customer_segment
FROM customer_spending) t
GROUP BY customer_segment
ORDER BY Total_Customers DESC