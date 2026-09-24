-- DDL: Table creation for the PIM and Feed Logs analytics project

CREATE TABLE products_pim (
    product_id SERIAL PRIMARY KEY,
    sku VARCHAR(50) UNIQUE NOT NULL,
    category VARCHAR(100),
    price DECIMAL(10, 2),
    stock_level INT,
    has_gtin BOOLEAN DEFAULT FALSE,
    ai_enriched_flag BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE feed_sync_logs (
    log_id SERIAL PRIMARY KEY,
    sku VARCHAR(50) REFERENCES products_pim(sku),
    sales_channel VARCHAR(50), -- e.g., 'Google MC', 'Microsoft'
    sync_status VARCHAR(20),   -- 'SUCCESS', 'FAILED'
    error_reason VARCHAR(255),
    sync_timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
