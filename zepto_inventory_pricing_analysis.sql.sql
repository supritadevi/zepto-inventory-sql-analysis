/* =====================================================
   PROJECT: Zepto Inventory & Pricing Analysis (SQL)
   PURPOSE: Identify pricing inefficiencies and inventory risks
   ===================================================== */


/* =====================================================
   1. DATABASE & SCHEMA SETUP
   ===================================================== */

CREATE DATABASE IF NOT EXISTS db;
USE db;

DROP TABLE IF EXISTS zepto;

CREATE TABLE zepto (
    sku_id SERIAL PRIMARY KEY,
    category VARCHAR(120),
    name VARCHAR(150) NOT NULL,
    mrp NUMERIC(8,2),
    discountPercent NUMERIC(5,2),
    availableQuantity INTEGER,
    discountedSellingPrice NUMERIC(8,2),
    weightInGms INTEGER,
    outOfStock BOOLEAN,
    quantity INTEGER
);


/* =====================================================
   2. DATA CLEANING & PREPARATION
   ===================================================== */

SET SQL_SAFE_UPDATES = 0;

/* Convert prices from paise to rupees and derive stock flag */
UPDATE zepto
SET
    mrp = mrp / 100,
    discountedSellingPrice = discountedSellingPrice / 100,
    outOfStock = CASE
        WHEN availableQuantity = 0 THEN 1
        ELSE 0
    END;

/* Remove invalid pricing records */
DELETE FROM zepto
WHERE mrp <= 0;


/* =====================================================
   3. ANALYTICAL VIEW (DERIVED METRICS)
   ===================================================== */

CREATE OR REPLACE VIEW zepto_analytics AS
SELECT
    sku_id,
    name,
    category,
    mrp,
    discountedSellingPrice,
    discountPercent,
    weightInGms,
    quantity,
    availableQuantity,
    outOfStock,

    /* Absolute discount */
    (mrp - discountedSellingPrice) AS absoluteDiscount,

    /* Computed discount percentage */
    CASE
        WHEN mrp > 0
        THEN (mrp - discountedSellingPrice) / mrp * 100
        ELSE NULL
    END AS computedDiscountPercent,

    /* Value metric */
    CASE
        WHEN weightInGms > 0
        THEN discountedSellingPrice / weightInGms
        ELSE NULL
    END AS pricePerGram

FROM zepto;


/* =====================================================
   4. BUSINESS ANALYSIS QUERIES
   ===================================================== */

-- 4.1 Inventory risk by category
SELECT category, COUNT(*) AS total_skus, SUM(outOfStock) AS out_of_stock_skus
FROM zepto_analytics
GROUP BY category
ORDER BY total_skus DESC;

-- 4.2 High-value products currently out of stock
SELECT DISTINCT name, mrp
FROM zepto_analytics
WHERE outOfStock = 1 AND mrp > 300;

-- 4.3 Discount dependency by category
SELECT category, ROUND(AVG(discountPercent),2) AS avg_discount
FROM zepto_analytics
GROUP BY category
ORDER BY avg_discount DESC;

-- 4.4 Poor value products (high price per gram)
SELECT name, category, pricePerGram
FROM zepto_analytics
ORDER BY pricePerGram DESC
LIMIT 10;
