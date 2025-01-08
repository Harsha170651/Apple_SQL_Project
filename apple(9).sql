-- 9)How many warranty claims were filed in 2020?

SELECT 
    COUNT(claim_id) AS warranty_claims
FROM
    warranty
WHERE
    YEAR(claim_date) = 2020;