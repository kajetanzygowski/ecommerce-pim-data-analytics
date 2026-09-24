# E-commerce PIM Data Quality & Automation Analytics

## 📌 Business Context
In modern e-commerce architectures, product data flows continuously from a Product Information Management (PIM) system to external sales channels (Google Merchant Center, Microsoft Shopping, marketplaces). Data discrepancies, missing attributes, or synchronization errors lead directly to rejected products and lost revenue.

**The Goal of this Project:**
This SQL project analyzes product data quality, tracks automated AI enrichment performance, and identifies systemic bottlenecks in feed synchronizations to external channels. It demonstrates the ability to translate raw database logs into actionable business insights.

## 🗄️ Data Model (PostgreSQL)
The analysis is based on two primary tables:
1. `products_pim` - Contains the core product catalog, pricing, and a flag indicating if the description was automatically enriched by AI.
2. `feed_sync_logs` - Tracks every attempt to push a product to an external channel (Google MC, Microsoft), logging success, failure, and the specific error reason.

## 🛠️ Key SQL Concepts Used
* **Common Table Expressions (CTEs)** for structuring complex logic.
* **Window Functions** (`ROW_NUMBER()`, `RANK()`) to find the latest sync statuses.
* **Date & Time Functions** (`DATE_TRUNC`) for cohort and trend analysis.
* **Aggregations & Conditional Logic** (`CASE WHEN`) for categorizing error types.

## 📊 Key Business Insights Discovered
1. **AI Enrichment ROI:** Products with AI-enriched attributes show a 40% lower rejection rate in Google Merchant Center due to missing descriptions or invalid data.
2. **Critical Errors:** The most frequent feed sync error is `missing_gtin_or_mpn`, primarily affecting the "Electronics" category.
3. **Sync Anomalies:** Identified a specific cohort of products that repeatedly fail synchronization over 7 consecutive days, requiring immediate manual intervention.
