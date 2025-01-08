-- 12)How many warranty claims were filed within 180 days of a product sale?

SELECT 
    COUNT(*) AS total_claims
FROM
    warranty AS w
        LEFT JOIN
    sales AS s ON s.sale_id = w.sale_id
WHERE
    w.claim_date - sale_date <= 180;