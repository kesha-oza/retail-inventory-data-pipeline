USE walmart_inventory_project;

# STEP 1: Create raw table
DROP TABLE IF EXISTS raw_walmart_sales;

CREATE TABLE raw_walmart_sales (
    store_id INT,
    sale_date VARCHAR(20),
    weekly_sales DECIMAL(15,2),
    holiday_flag INT,
    temperature DECIMAL(10,2),
    fuel_price DECIMAL(10,3),
    cpi DECIMAL(12,6),
    unemployment DECIMAL(10,3)
);

# STEP 2: Load data
-- Data was imported using MySQL Workbench "Table Data Import Wizard"
-- Source file: Walmart_Sales_Data.xlsx
-- Excel file was converted via MySQL Workbench import process
-- The Excel file was automatically parsed and loaded into raw_walmart_sales

# STEP 3: Validate data load
SELECT COUNT(*) AS total_rows
FROM raw_walmart_sales;

SELECT *
FROM raw_walmart_sales
LIMIT 10;