-- 7)Count the number of unique products sold in the last year.

SELECT DISTINCT
    COUNT(s.product_id) AS total_product, p.product_name
FROM
    sales AS s
        JOIN
    products AS p ON p.product_id = s.product_id
WHERE
    sale_date >= CURDATE() - INTERVAL 1 YEAR
GROUP BY product_name
ORDER BY COUNT(s.product_id) DESC
lIMIT 1;