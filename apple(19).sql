-- 19)Write SQL query to calculate the monthly running total of sales for each store over the past four years and compare the trends across this period?

WITH monthly_sales AS (
    SELECT 
        s.store_id,
        YEAR(s.sale_date) AS year,
        MONTH(s.sale_date) AS month,
        SUM(p.price * s.quantity) AS total_revenue
    FROM sales AS s
    JOIN products AS p
        ON s.product_id = p.product_id
    WHERE s.sale_date >= DATE_SUB(CURDATE(), INTERVAL 4 YEAR) -- Filter for the past 4 years
    GROUP BY s.store_id, year, month
    ORDER BY s.store_id, year, month
)
SELECT 
    store_id,
    month,
    year,
    total_revenue,
    SUM(total_revenue) OVER (PARTITION BY store_id ORDER BY year, month) AS running_total
FROM monthly_sales;



