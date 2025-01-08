-- 15) Which product category had the most warranty claims filed in the last 2 years?

SELECT 
    c.category_name, COUNT(w.claim_id) AS total_claims
FROM
    warranty AS w
        LEFT JOIN
    sales AS s ON w.sale_id = s.sale_id
        JOIN
    products AS p ON p.product_id = s.product_id
        JOIN
    category AS c ON c.category_id = p.category_id
WHERE
    w.claim_date >= DATE_SUB(CURDATE(), INTERVAL 2 YEAR)
GROUP BY c.category_name;
