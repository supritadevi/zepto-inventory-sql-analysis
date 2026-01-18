
# Zepto Inventory & Pricing Analysis (SQL)

## Project Overview
This project analyzes inventory availability and pricing patterns for a quick-commerce company (Zepto-like) using SQL.  
The objective is to identify inventory risks and pricing inefficiencies that can help category managers improve revenue and product availability.

---

## Dataset
- Source: Kaggle – Zepto Inventory Dataset - https://www.kaggle.com/datasets/palvinder2006/zepto-inventory-dataset/data
- Includes product category, MRP, discounts, stock availability, and product weight

---

## Business Questions Answered
- Which high-value products are currently out of stock?
- Which categories show high inventory risk?
- Which categories rely heavily on discounts?
- Which products offer poor value based on price per gram?

---

## Key Insights
- Certain categories show disproportionately high stock-out counts, indicating inventory risk.
- Several high-MRP products are unavailable, representing potential revenue loss.
- Some categories consistently rely on higher discounts, suggesting margin pressure.
- A subset of products offers poor unit value despite discounts, which may impact customer trust.

---

## Recommended Actions
- Prioritize restocking of high-MRP out-of-stock products.
- Review pricing strategy for discount-heavy categories.
- Audit poor value products for repricing or repackaging.
- Improve category-level inventory monitoring.

---


---

## Tools Used
- MySQL
- SQL (aggregations, filtering, CASE expressions, views)
