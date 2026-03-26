# Total sales summary
SELECT
    ROUND(SUM(weekly_sales), 2) AS total_sales,
    ROUND(AVG(weekly_sales), 2) AS avg_weekly_sales,
    ROUND(MIN(weekly_sales), 2) AS min_weekly_sales,
    ROUND(MAX(weekly_sales), 2) AS max_weekly_sales
FROM fact_sales;

# Top 10 stores by total sales
SELECT
    store_id,
    ROUND(SUM(weekly_sales), 2) AS total_sales
FROM fact_sales
GROUP BY store_id
ORDER BY total_sales DESC
LIMIT 10;

# Top 10 stores by lost sales
SELECT
    store_id,
    ROUND(SUM(lost_sales), 2) AS total_lost_sales
FROM vw_store_year_inventory_analysis
GROUP BY store_id
ORDER BY total_lost_sales DESC
LIMIT 10;

# Yearly performance summary
SELECT
    year,
    ROUND(SUM(total_sales), 2) AS total_sales,
    ROUND(SUM(lost_sales), 2) AS total_lost_sales,
    ROUND((SUM(lost_sales) / SUM(total_sales)) * 100, 2) AS lost_sales_pct
FROM vw_store_year_inventory_analysis
GROUP BY year
ORDER BY year;

# Store year stockout analysis
SELECT
    store_id,
    year,
    ROUND(total_sales, 2) AS total_sales,
    ROUND(avg_weekly_sales, 2) AS avg_weekly_sales,
    ROUND(starting_inventory, 2) AS starting_inventory,
    ROUND(simulated_inventory, 2) AS simulated_inventory,
    stockout_flag,
    ROUND(lost_sales, 2) AS lost_sales
FROM vw_store_year_inventory_analysis
ORDER BY store_id, year;

# Monthly sales trend
SELECT
    YEAR(sale_date) AS year,
    MONTH(sale_date) AS month_number,
    MONTHNAME(sale_date) AS month_name,
    ROUND(SUM(weekly_sales), 2) AS total_sales
FROM fact_sales
GROUP BY
    YEAR(sale_date),
    MONTH(sale_date),
    MONTHNAME(sale_date)
ORDER BY
    year,
    month_number;

# Holiday vs non-holiday sales
SELECT
    holiday_flag,
    ROUND(SUM(weekly_sales), 2) AS total_sales,
    ROUND(AVG(weekly_sales), 2) AS avg_weekly_sales
FROM fact_sales
GROUP BY holiday_flag;

# Best and Worst performing stores
# Top 5 by sales
SELECT
    store_id,
    ROUND(SUM(weekly_sales), 2) AS total_sales
FROM fact_sales
GROUP BY store_id
ORDER BY total_sales DESC
LIMIT 5;

# Bottom 5 by sales
SELECT
    store_id,
    ROUND(SUM(weekly_sales), 2) AS total_sales
FROM fact_sales
GROUP BY store_id
ORDER BY total_sales ASC
LIMIT 5;


