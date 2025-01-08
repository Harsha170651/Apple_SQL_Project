-- 13)How many warranty claims have been filed for products launched in the last two years?

SELECT 
    p.product_name,
    COUNT(w.claim_id) AS no_claim,
    COUNT(s.sale_id) AS no_sales
FROM
    warranty AS w
        RIGHT JOIN
    sales AS s ON s.sale_id = w.sale_id
        JOIN
    products AS p ON p.product_id = s.product_id
WHERE
    p.launch_date >= DATE_SUB(CURDATE(), INTERVAL 2 YEAR)
GROUP BY p.product_name
HAVING COUNT(w.claim_id) > 0;
