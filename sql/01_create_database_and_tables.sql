# Create the database
CREATE DATABASE walmart_inventory_project;
USE walmart_inventory_project;

# Create the raw table
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

# Create the staging table
DROP TABLE IF EXISTS stg_sales;

CREATE TABLE stg_sales AS
SELECT
    store_id,
    STR_TO_DATE(sale_date, '%d-%m-%Y') AS sale_date,
    weekly_sales,
    holiday_flag,
    temperature,
    fuel_price,
    cpi,
    unemployment
FROM raw_walmart_sales;

# Validate the data
select * from stg_sales;

SELECT COUNT(*) AS null_dates
FROM stg_sales
WHERE sale_date IS NULL;

# Create dimensions tables
DROP TABLE IF EXISTS dim_store;

CREATE TABLE dim_store AS
SELECT DISTINCT
    store_id
FROM stg_sales
ORDER BY store_id;

select * from dim_store;

DROP TABLE IF EXISTS dim_date;

CREATE TABLE dim_date AS
SELECT DISTINCT
    sale_date AS full_date,
    YEAR(sale_date) AS year,
    MONTH(sale_date) AS month_number,
    MONTHNAME(sale_date) AS month_name,
    QUARTER(sale_date) AS quarter_number,
    WEEK(sale_date, 1) AS week_number
FROM stg_sales
ORDER BY full_date;

select * from dim_date;

# Create fact sales table
DROP TABLE IF EXISTS fact_sales;

CREATE TABLE fact_sales AS
SELECT
    store_id,
    sale_date,
    weekly_sales,
    holiday_flag,
    temperature,
    fuel_price,
    cpi,
    unemployment
FROM stg_sales;