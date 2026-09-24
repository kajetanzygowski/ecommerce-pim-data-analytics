/* 
=============================================================================
Query 2: Identifying Chronic Sync Failures (Anomaly Detection)
Business Question: Which products have failed to sync more than 5 times 
consecutively in the last week without a single success?
=============================================================================
*/

WITH SyncHistory AS (
    SELECT 
        sku,
        sync_status,
        sync_timestamp,
        -- Group consecutive statuses together
        LAG(sync_status) OVER(PARTITION BY sku ORDER BY sync_timestamp) as prev_status
    FROM 
        feed_sync_logs
    WHERE 
        sync_timestamp >= CURRENT_DATE - INTERVAL '7 days'
),
FailureCounts AS (
    SELECT 
        sku,
        COUNT(*) AS total_attempts,
        SUM(CASE WHEN sync_status = 'FAILED' THEN 1 ELSE 0 END) AS failed_attempts
    FROM 
        SyncHistory
    GROUP BY 
        sku
)

-- Select only products that fail 100% of the time with high volume
SELECT 
    f.sku,
    p.category,
    f.total_attempts,
    f.failed_attempts
FROM 
    FailureCounts f
JOIN 
    products_pim p ON f.sku = p.sku
WHERE 
    f.failed_attempts >= 5 
    AND f.total_attempts = f.failed_attempts -- 100% failure rate
ORDER BY 
    f.failed_attempts DESC;
