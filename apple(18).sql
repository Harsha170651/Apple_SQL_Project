-- 18.	What is the correlation between product price and warranty claims for products sold in the last five years? (Segment based on diff price)

SELECT 
    CASE
        WHEN p.price < 500 THEN 'Less Expensive Product'
        WHEN p.price BETWEEN 500 AND 1000 THEN 'Mid-Range Product'
        ELSE 'Expensive Product'
    END AS price_segment,
    COUNT(w.claim_id) AS total_claim
FROM
    warranty AS w
        LEFT JOIN
    sales AS s ON w.sale_id = s.sale_id
        JOIN
    products AS p ON p.product_id = s.product_id
WHERE
    w.claim_date >= DATE_SUB(CURDATE(), INTERVAL 5 YEAR)
GROUP BY price_segment;
