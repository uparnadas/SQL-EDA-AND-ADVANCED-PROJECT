/* ------------------------------------------------------------------------
- MEASURES EXPLORATION
- CALCULATE SUMMARY METRICS (SUCH AS TOTALS AND AVERAGES) FOR QUICK INSIGHTS
- FIND OVERALL TRENDS AND SPOT ANOMALIES

FUNCTIONS USED
	- COUNT()
	- SUM()
	- AVG()
---------------------------------------------------------------------------- */

-- Find the Total Sales
SELECT SUM(sales_amount) AS total_sales FROM gold.fact_sales

-- Find how many times items are sold
SELECT SUM(quantity) AS total_quantity FROM gold.fact_sales

-- Find the average selling price
SELECT AVG(price) AS average_price FROM gold.fact_sales

-- Find the Total Number of Orders
SELECT COUNT(order_number) AS total_orders FROM gold.fact_sales
SELECT COUNT(DISTINCT order_number) AS total_orders FROM gold.fact_saless

-- Find the Total Number of Products
SELECT COUNT(product_id) AS total_products FROM gold.dim_products
SELECT COUNT(DISTINCT product_id) AS total_products FROM gold.dim_products

-- Find the Total Number of Customers
SELECT COUNT(customer_key) AS total_customers FROM gold.dim_customers

-- Find the Total Number of Customers that has placed an order
SELECT COUNT(DISTINCT customer_key) AS total_customers FROM gold.fact_sales

SELECT 'Total Sales' AS Measure_Name, SUM(sales_amount) AS Measure_Value FROM gold.fact_sales
UNION ALL
SELECT 'Total Quantity', SUM(quantity) FROM gold.fact_sales
UNION ALL
SELECT 'Average Price', AVG(price) FROM gold.fact_sales
UNION ALL
SELECT 'Total Nr. Orders', COUNT(DISTINCT order_number) FROM gold.fact_sales
UNION ALL
SELECT 'Total Nr. Products', COUNT(DISTINCT product_name) FROM gold.dim_products
UNION ALL
SELECT 'Total Nr. Customers', COUNT(customer_key) FROM gold.dim_customers