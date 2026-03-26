# Create a main analysis view
DROP VIEW IF EXISTS vw_store_year_inventory_analysis;

CREATE VIEW vw_store_year_inventory_analysis AS
SELECT
    f.store_id,
    YEAR(f.sale_date) AS year,
    SUM(f.weekly_sales) AS total_sales,
    AVG(f.weekly_sales) AS avg_weekly_sales,
    AVG(f.weekly_sales) * 4 AS starting_inventory,
    (AVG(f.weekly_sales) * 4) - SUM(f.weekly_sales) AS simulated_inventory,
    CASE
        WHEN ((AVG(f.weekly_sales) * 4) - SUM(f.weekly_sales)) <= 0 THEN 1
        ELSE 0
    END AS stockout_flag,
    CASE
        WHEN ((AVG(f.weekly_sales) * 4) - SUM(f.weekly_sales)) <= 0
            THEN ABS((AVG(f.weekly_sales) * 4) - SUM(f.weekly_sales))
        ELSE 0
    END AS lost_sales,
    CASE
        WHEN SUM(f.weekly_sales) = 0 THEN 0
        ELSE
            CASE
                WHEN ((AVG(f.weekly_sales) * 4) - SUM(f.weekly_sales)) <= 0
                    THEN ABS((AVG(f.weekly_sales) * 4) - SUM(f.weekly_sales)) / SUM(f.weekly_sales)
                ELSE 0
            END
    END AS lost_sales_pct
FROM fact_sales f
GROUP BY
    f.store_id,
    YEAR(f.sale_date);

# Create a Monthly Trend View
DROP VIEW IF EXISTS vw_monthly_sales_trend;

CREATE VIEW vw_monthly_sales_trend AS
SELECT
    YEAR(sale_date) AS year,
    MONTH(sale_date) AS month_number,
    MONTHNAME(sale_date) AS month_name,
    SUM(weekly_sales) AS total_sales
FROM fact_sales
GROUP BY
    YEAR(sale_date),
    MONTH(sale_date),
    MONTHNAME(sale_date)
ORDER BY
    year,
    month_number;

CREATE VIEW vw_store_year_inventory_dynamic AS
SELECT
    f.store_id,
    YEAR(f.sale_date) AS year,
    SUM(f.weekly_sales) AS total_sales,
    AVG(f.weekly_sales) AS avg_weekly_sales,
    AVG(f.weekly_sales) * p.weeks_cover_start AS starting_inventory,
    (AVG(f.weekly_sales) * p.weeks_cover_start) - SUM(f.weekly_sales) AS simulated_inventory,
    CASE
        WHEN ((AVG(f.weekly_sales) * p.weeks_cover_start) - SUM(f.weekly_sales)) <= 0 THEN 1
        ELSE 0
    END AS stockout_flag,
    CASE
        WHEN ((AVG(f.weekly_sales) * p.weeks_cover_start) - SUM(f.weekly_sales)) <= 0
            THEN ABS((AVG(f.weekly_sales) * p.weeks_cover_start) - SUM(f.weekly_sales))
        ELSE 0
    END AS lost_sales
FROM fact_sales f
CROSS JOIN inventory_parameter p
GROUP BY
    f.store_id,
    YEAR(f.sale_date),
    p.weeks_cover_start;