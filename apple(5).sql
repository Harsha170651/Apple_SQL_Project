-- 5)What percentage of warranty claims are marked as "Warranty Void"?

SELECT 
    ROUND(COUNT(claim_id)/ (select count(*) from warranty) *  100, 1) AS warranty_void_percentage
FROM
    warranty
WHERE
    repair_status = 'warranty void'
