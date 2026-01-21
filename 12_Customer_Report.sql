-- BUILD CUSTOMER REPORT
/*
=============================================================
CUSTOMER REPORT
=============================================================
PURPOSE:
	- THIS REPORT CONSOLIDATES KEY CUSTOMER METRICS AND BEHAVIOURS

HIGHLIGHTS:
	1. GATHERS ESSENTIAL FIELDS SUCH AS NAMES, AGES, AND TRANSACTIONAL DETAILS.
	2. SEGMENTS CUSTOMERS INTO CATEGORIES (VIP, REGULAR, NEW) AND AGE GROUPS.
	3. AGGREGATES CUSTOMER-LEVEL METRICS:
		- TOTAL ORDERS
		- TOTAL SALES
		- TOTAL QUANTITY PURCHASED
		- TOTAL PRODUCTS
		- LIFESPAN (IN MONTHS)
	4. CALCULATES VALUABLE KPIS:
		- RECENCY (MONTHS SINCE LAST ORDER)
		- AVERAGE ORDER VALUE
		- AVERAGE MONTHLY SPEND
=============================================================
*/

CREATE VIEW gold.report_customers AS
WITH base_query AS (
/*-----------------------------------------------------------
1) BASE QUERY: RETRIEVE CORE COLUMNS FROM TABLES
-----------------------------------------------------------*/
SELECT
f.order_number,
f.product_key,
f.order_date,
f.sales_amount,
f.quantity,
c.customer_key,
c.customer_number,
CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
DATEDIFF(year, c.birthdate, GETDATE()) age
FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c
ON c.customer_key = f.customer_key
WHERE order_date IS NOT NULL)

, customer_aggregation AS (
/*--------------------------------------------------------------------
2) CUSTOMER AGGREGATIONS: SUMMARIZES KEY METRICS AT THE CUSTOMER LEVEL
---------------------------------------------------------------------*/
SELECT
customer_key,
customer_number,
customer_name,
age,
COUNT(DISTINCT order_number) AS total_orders,
SUM(sales_amount) AS total_sales,
SUM(quantity) AS total_quantity,
COUNT(DISTINCT product_key) AS total_product,
MAX(order_date) AS last_order_date,
DATEDIFF(month, MIN(order_date), MAX(order_date)) AS lifespan
FROM base_query
GROUP BY 
customer_key,
customer_number,
customer_name,
age
)

SELECT
customer_key,
customer_number,
customer_name,
age,
CASE WHEN age < 20 THEN 'Under 20'
	 WHEN age between 20 AND 29 THEN '20-29'
	 WHEN age between 30 AND 39 THEN '30-39'
	 WHEN age between 40 AND 49 THEN '40-49'
	 ELSE '50 and above'
END AS age_group,
CASE WHEN lifespan >= 12 AND total_sales > 5000 THEN 'VIP'
	 WHEN lifespan >= 12 AND total_sales <= 5000 THEN 'REGULAR'
	 ELSE 'NEW'
END customer_segment,
DATEDIFF(month, last_order_date, GETDATE()) AS recency,
total_orders,
total_sales,
total_quantity,
total_product,
last_order_date,
lifespan,

-- COMPUTE AVERAGE ORDER VALUE (AVO)
CASE WHEN total_orders = 0 THEN 0
	 ELSE total_sales / total_orders 
END AS avg_order_value,

-- COMPUTE AVERAGE MONTHLY SPEND
CASE WHEN lifespan = 0 THEN total_sales
	 ELSE total_sales / lifespan
END AS avg_monthly_spend
FROM customer_aggregation

SELECT 
customer_segment,
COUNT(customer_number) AS total_customers,
SUM(total_sales) total_sales
FROM gold.report_customers
GROUP BY customer_segment

SELECT * FROM gold.report_customers