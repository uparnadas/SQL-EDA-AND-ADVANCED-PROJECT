/* ------------------------------------------------------------------------
- CUMMULATIVE ANALYSIS
- AGGREGATE THE DATA PROGRESSIVELY OVER TIME
- HELPS TO UNDERSTAND WHETHER OUR BUSINESS IS GROWING OR DECLINING
- USED FOR GROWTH ANALYSIS AND IDENTIFYING LONG TERM TRENDS

FUNCTIONS
	- WINDOW FUNCTIONS: SUM() OVER(), AVG() OVER()
---------------------------------------------------------------------------- */

/* CALCULATE THE TOTAL SALES PER MONTH
AND THE RUNNING TOTAL SALES OVER TIME */


SELECT
Order_Date,
Total_Sales,
SUM(Total_Sales) OVER (PARTITION BY Order_Date ORDER BY order_date) AS Running_Total_Sales
FROM
(
SELECT
DATETRUNC(month, order_date) AS Order_Date,
SUM(sales_amount) AS Total_Sales
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY DATETRUNC(month, order_date)
) t

SELECT
Order_Date,
Total_Sales,
SUM(Total_Sales) OVER (ORDER BY order_date) AS Running_Total_Sales
FROM
(
SELECT
DATETRUNC(year, order_date) AS Order_Date,
SUM(sales_amount) AS Total_Sales
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY DATETRUNC(year, order_date)
) t

-- CALCULATE THE MOVING AVERAGE OF SALES BY YEAR

SELECT
Order_Date,
Total_Sales,
SUM(Total_Sales) OVER (ORDER BY order_date) AS Running_Total_Sales,
AVG(Avg_Price) OVER (ORDER BY order_date) AS Moving_Average_Price
FROM
(
SELECT
DATETRUNC(year, order_date) AS Order_Date,
SUM(sales_amount) AS Total_Sales,
AVG(price) AS Avg_Price
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY DATETRUNC(year, order_date)
) t