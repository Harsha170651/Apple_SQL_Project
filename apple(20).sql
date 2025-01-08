-- 20) Analyze sales trends of product over time, segmented into key time periods: from launch to 6 months, 6-12 months, 12-18 months, and beyond 18 months?

SELECT 
    p.product_name,
    CASE
        WHEN
            s.sale_date BETWEEN p.launch_date AND DATE_ADD(p.launch_date,
                INTERVAL 6 MONTH)
        THEN
            '0-6 month'
        WHEN
            s.sale_date BETWEEN DATE_ADD(p.launch_date,
                INTERVAL 6 MONTH) AND DATE_ADD(p.launch_date,
                INTERVAL 12 MONTH)
        THEN
            '6-12 month'
        WHEN
            s.sale_date BETWEEN DATE_ADD(p.launch_date,
                INTERVAL 12 MONTH) AND DATE_ADD(p.launch_date,
                INTERVAL 18 MONTH)
        THEN
            '12-18 month'
        ELSE '18+ month'
    END AS plc,
    SUM(s.quantity) AS total_qty_sale
FROM
    sales AS s
        JOIN
    products AS p ON s.product_id = p.product_id
GROUP BY p.product_name , plc
ORDER BY p.product_name , total_qty_sale DESC;
