-- 17) Analyze the year-by-year growth ratio for each store.

WITH yearly_sales AS (
    SELECT 
        s.store_id,
        st.store_name,
        YEAR(s.sale_date) AS year,
        SUM(s.quantity * p.price) AS total_sale
    FROM sales AS s
    JOIN products AS p
        ON s.product_id = p.product_id
    JOIN stores AS st
        ON st.store_id = s.store_id
    GROUP BY s.store_id, st.store_name, year
    ORDER BY st.store_name, year
),
growth_ratio AS (
    SELECT 
        store_name,
        year,
        LAG(total_sale) OVER (PARTITION BY store_name ORDER BY year) AS last_year_sale,
        total_sale AS current_year_sale
    FROM yearly_sales
)
SELECT 
    store_name,
    year,
    last_year_sale,
    current_year_sale,
    ROUND(((current_year_sale - last_year_sale) / last_year_sale) * 100, 3) AS growth_ratio
FROM growth_ratio
WHERE 
    last_year_sale IS NOT NULL
    AND year <> YEAR(CURDATE());
