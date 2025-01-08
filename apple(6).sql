-- 6)Which store had the highest total units sold in the last year?

SELECT 
    sa.store_id, st.store_name, SUM(sa.quantity) AS total_sales
FROM
    sales AS sa
        JOIN
    stores AS st ON st.store_id = sa.store_id
WHERE
    sale_date >= CURDATE() - INTERVAL 1 YEAR
GROUP BY sa.store_id , st.store_name
ORDER BY SUM(sa.quantity) DESC
LIMIT 1;