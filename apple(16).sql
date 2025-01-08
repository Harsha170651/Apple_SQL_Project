-- 16) Determine the percentage chance of receiving warranty claims after each purchase for each country!

SELECT 
    country,
    total_unit_sold,
    total_claim,
    COALESCE((total_claim * 100.0) / total_unit_sold,
            0) AS risk
FROM
    (SELECT 
        st.country,
            SUM(s.quantity) AS total_unit_sold,
            COUNT(w.claim_id) AS total_claim
    FROM
        sales AS s
    JOIN stores AS st ON s.store_id = st.store_id
    LEFT JOIN warranty AS w ON w.sale_id = s.sale_id
    GROUP BY st.country) AS t1
ORDER BY risk DESC;
