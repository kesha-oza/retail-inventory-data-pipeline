
USE walmart_inventory_project;

# Create staging table
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

# Validation checks
SELECT COUNT(*) AS total_rows
FROM stg_sales;

SELECT COUNT(*) AS null_dates
FROM stg_sales
WHERE sale_date IS NULL;

# Database cleanup
DELETE FROM stg_sales
WHERE sale_date IS NULL;

# Create dimension tables
DROP TABLE IF EXISTS dim_store;

CREATE TABLE dim_store AS
SELECT DISTINCT
    store_id
FROM stg_sales
ORDER BY store_id;

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

# Create fact table
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

# Add keys and indexes
ALTER TABLE dim_store
ADD PRIMARY KEY (store_id);

ALTER TABLE dim_date
ADD PRIMARY KEY (full_date);

ALTER TABLE fact_sales
ADD INDEX idx_store_id (store_id),
ADD INDEX idx_sale_date (sale_date);

# Add foreign keys
ALTER TABLE fact_sales
ADD CONSTRAINT fk_fact_store
FOREIGN KEY (store_id) REFERENCES dim_store(store_id);

ALTER TABLE fact_sales
ADD CONSTRAINT fk_fact_date
FOREIGN KEY (sale_date) REFERENCES dim_date(full_date);