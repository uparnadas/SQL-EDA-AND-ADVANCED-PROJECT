/* -------------------------------------------------------------------------
- DATABASE EXPLORATION
- EXPLORE THE STRUCTURE OF THE DATABASE, LIST OF TABLES AND THEIR SCHEMAS
- EXAMINE THE COLUMNS AND METADATA FOR EACH TABLE
-------------------------------------------------------------------------*/

-- Explore All Objetcs in the Database
SELECT * FROM INFORMATION_SCHEMA.TABLES

-- Explore All Columns in the Database
SELECT * FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'dim_customers'