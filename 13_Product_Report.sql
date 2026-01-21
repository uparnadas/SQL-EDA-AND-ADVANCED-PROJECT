/*
===============================================================================
PRODUCT REPORT
===============================================================================
PURPOSE:
	- THIS REPORT CONSOLIDATES KEY PRODUCT METRICS AND BEHAVIOURS
HIGHLIGHTS:
	1. GATHERS ESSENTIAL FIELDS SUCH AS PRODUCT NAME, CATEGORY, SUBCATEGORY, AND COST
	2. SEGMENTS PRODUCT BY REVENUE TO IDENTIFY HIGH-PERFORMERS, MID-RANGE AND LOW-PERFORMERS
	3. AGGREGATES PRODUCT-LEVEL METRICS:
		- TOTAL ORDERS
		- TOTAL SALES
		- TOTAL QUANTITY SOLD
		- TOTAL CUSTOMERS(UNIQUE)
		- LIFESPAN(IN MONTHS)
	4. CALCULATES VALUABLE KPIS:
		- RECENCY (MONTHS SINCE LAST SALE)
		- AVERAGE ORDER REVENUE
		- AVERAGE MONTHLY REVENUE
===============================================================================
*/
-- =============================================================================
CREATE VIEW gold.report_products AS

WITH base_query AS (
/*---------------------------------------------------------------------------
1) BASE QUERY: RETRIEVES CORE COLUMNS FROM FACT_SALES AND DIM_PRODUCTS
---------------------------------------------------------------------------*/
    SELECT
	    f.order_number,
        f.order_date,
		f.customer_key,
        f.sales_amount,
        f.quantity,
        p.product_key,
        p.product_name,
        p.category,
        p.subcategory,
        p.cost
    FROM gold.fact_sales f
    LEFT JOIN gold.dim_products p
        ON f.product_key = p.product_key
    WHERE order_date IS NOT NULL 
),

product_aggregations AS (
/*---------------------------------------------------------------------------
2) PRODUCT AGGREGATIONS: SUMMARIZES KEY METRICS AT THE PRODUCT LEVEL
---------------------------------------------------------------------------*/
SELECT
    product_key,
    product_name,
    category,
    subcategory,
    cost,
    DATEDIFF(MONTH, MIN(order_date), MAX(order_date)) AS lifespan,
    MAX(order_date) AS last_sale_date,
    COUNT(DISTINCT order_number) AS total_orders,
	COUNT(DISTINCT customer_key) AS total_customers,
    SUM(sales_amount) AS total_sales,
    SUM(quantity) AS total_quantity,
	ROUND(AVG(CAST(sales_amount AS FLOAT) / NULLIF(quantity, 0)),1) AS avg_selling_price
FROM base_query

GROUP BY
    product_key,
    product_name,
    category,
    subcategory,
    cost
)

/*---------------------------------------------------------------------------
  3) FINAL QUERY: COMBINES ALL PRODUCT RESULTS INTO ONE OUTPUT
---------------------------------------------------------------------------*/
SELECT 
	product_key,
	product_name,
	category,
	subcategory,
	cost,
	last_sale_date,
	DATEDIFF(MONTH, last_sale_date, GETDATE()) AS recency_in_months,
	CASE
		WHEN total_sales > 50000 THEN 'High-Performer'
		WHEN total_sales >= 10000 THEN 'Mid-Range'
		ELSE 'Low-Performer'
	END AS product_segment,
	lifespan,
	total_orders,
	total_sales,
	total_quantity,
	total_customers,
	avg_selling_price,
	-- AVERAGE ORDER REVENUE (AOR)
	CASE 
		WHEN total_orders = 0 THEN 0
		ELSE total_sales / total_orders
	END AS avg_order_revenue,

	-- AVERAGE MONTHLY REVENUE
	CASE
		WHEN lifespan = 0 THEN total_sales
		ELSE total_sales / lifespan
	END AS avg_monthly_revenue

FROM product_aggregations