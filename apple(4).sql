/* 4)How many stores have never had a warranty claim filed against any of their products?*/
SELECT 
    COUNT(*) AS total_stores
FROM
    stores
WHERE
    store_id NOT IN (SELECT DISTINCT
            store_id
        FROM
            sales AS s
                RIGHT JOIN
            warranty AS w ON w.sale_id = s.sale_id)
