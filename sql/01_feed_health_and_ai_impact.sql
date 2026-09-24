/* 
=============================================================================
Query 1: Feed Sync Health & AI Enrichment Impact
Business Question: Does AI data enrichment reduce the error rate in Google 
Merchant Center? Which categories generate the most rejection errors?
=============================================================================
*/

WITH LatestSyncs AS (
    -- Get the most recent sync status for each product and channel
    SELECT 
        sku,
        sales_channel,
        sync_status,
        error_reason,
        ROW_NUMBER() OVER(PARTITION BY sku, sales_channel ORDER BY sync_timestamp DESC) as rn
    FROM 
        feed_sync_logs
    WHERE 
        sync_timestamp >= CURRENT_DATE - INTERVAL '30 days'
),
ProductHealth AS (
    -- Join with the PIM catalog to analyze by category and AI flag
    SELECT 
        p.category,
        p.ai_enriched_flag,
        ls.sales_channel,
        ls.sync_status
    FROM 
        products_pim p
    JOIN 
        LatestSyncs ls ON p.sku = ls.sku
    WHERE 
        ls.rn = 1 -- Only look at the latest attempt
)

-- Final Aggregation: Calculate Error Rate by Category and AI Status
SELECT 
    category,
    ai_enriched_flag,
    COUNT(*) AS total_products_synced,
    SUM(CASE WHEN sync_status = 'FAILED' THEN 1 ELSE 0 END) AS failed_syncs,
    ROUND(
        (SUM(CASE WHEN sync_status = 'FAILED' THEN 1 ELSE 0 END) * 100.0) / COUNT(*), 
    2) AS error_rate_percentage
FROM 
    ProductHealth
WHERE 
    sales_channel = 'Google MC'
GROUP BY 
    category, 
    ai_enriched_flag
ORDER BY 
    error_rate_percentage DESC;
