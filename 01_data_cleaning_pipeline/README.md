📘 Data Cleaning & Modeling Pipeline
Phase 1 of the Restaurant Delivery Analytics Project

Excel · Python · SQL Server

⚡ Executive Summary

This pipeline transforms raw operational exports from the Last delivery platform into a clean, structured, and analytics-ready dataset.

It standardizes timestamps, anonymizes customers, parses unstructured product text, enriches items with official menu metadata, and produces order- and customer-level KPIs.

Final dataset includes:

4184 processed orders

1805 anonymized customers

114 enriched menu items

This cleaned dataset powers:

SQL + Power BI Insight Story

Tableau Interactive Dashboard

🔍 High-Level Architecture

Raw Excel Export (Last App)
        ↓
Excel Cleaning & Anonymization
        ↓
Python Parsing of Product Text
        ↓
Excel Enrichment with Official Menu Data
        ↓
SQL Server Data Modeling (Fact & Dimensions)
        ↓
Analytical Views (orders_update & customers_kpi)
        ↓
Used in Power BI & Tableau Projects


🧩 1. Business Context & Purpose

Raw exports from Last App contain structural and analytical limitations:

Customer personal data (phone, email, address)

One long text field storing all products

No product-level granularity

Non-standard timestamps

No unique customer ID

No product attributes

Repeated irrelevant operational fields

These limitations prevent reliable analysis of:

Sales performance

Customer retention

Menu performance

Discount effectiveness

Behavior patterns

This pipeline builds a trustworthy data foundation for BI tools.

🎯 2. Project Objectives

The pipeline was designed to:

✔ Transform messy operational exports
✔ Protect customer privacy through anonymization
✔ Parse unstructured product descriptions
✔ Enrich items with official attributes
✔ Normalize data into a proper relational model
✔ Create an analytical semantic layer (SQL views)
✔ Support reliable insights across Power BI & Tableau

🧹 3. What Was Done (High-Level Overview)
1. Excel Cleaning & Anonymization

Removed irrelevant fields

Standardized and validated timestamps

Extracted ZIP codes for geographic analysis

Built a complete anonymized customer table

Generated unique customer_id to remove PII

2. Python Parsing of Product Text

Split long product strings

Extracted quantities (e.g., 2x)

Cleaned modifiers, punctuation, formatting noise

Normalized product names

Produced the products_order mapping table

3. Excel Enrichment with Official Menu Data

Merged extracted products with validated restaurant menu

Added category, diet type, stock status, average price

Created final products dimension

4. SQL Server Data Modeling

Normalized tables created:

orders

products

products_order

customers

zip_code

promos

An ER diagram was created to map relationships. (Located in docs/erd.png.)

5. Analytical Views (Semantic Layer)
orders_update

Adds:

new vs. returning customers

time intelligence: year, month, weekday, shift, day_type

ZIP → neighborhood mapping

financials: gross, net, discount %, delivery fee

customers_kpi

Computes:

frequency & lifetime metrics

retention status

total spent, AOV

discount behavior

These views ensure consistent KPIs across BI tools.

6. Data Limitations (Documented)

Product text truncation in some rows

Missing paid modifiers

Revenue reconstruction gap (expected <10%)

Inconsistencies from platform export

📘 Phase 1 — Raw Data Understanding & Excel Preparation

This phase prepares the raw operational files into structured, privacy-safe Excel datasets.

1. Raw Data Sources
1.1. orders_raw.xlsx

Included:

Order metadata (invoice_no, activation_time, pickup type…)

Customer details (name, address, phone, email)

Financials (total, discounts, delivery fee, refund)

Product text (all items concatenated in one field)

Operational settings (courier, scheduling, estimated delivery)

1.2. Additional Data Files

Official product list (category, diet type, avg price)

Barcelona ZIP → neighborhood mapping

Monthly promotions applied

These support enrichment and SQL modeling.

2. Excel Cleaning & Standardization
✔ 2.1 Remove Irrelevant Columns

Dropped fields providing no business value.

✔ 2.2 Select the Correct Timestamp

activation_time used as the business timestamp (accurate kitchen start time).

✔ 2.3 Extract ZIP Code

Pulled from address → used for geographic segmentation.

✔ 2.4 Build Anonymized Customer Table

Steps:

Extract phone numbers

Remove duplicates

Assign a new customer_id

Join back into orders

Remove PII fields

→ Output: excel/customers.xlsx

✔ 2.5 Prepare Product Text Table

Created intermediate file:

→ orders_with_products_text.xlsx

This feeds Python parsing in Phase 2.

🐍 Phase 2 — Python Parsing of Product Data

Last App stores products like:

"1x PACK PARA 2: 1x Pollo Tikka Masala*, 1x Palak Paneer*;
 2x Coca-Cola Zero.; 1x Naan.; 1x Alitas de Pollo*"


This structure makes product analytics impossible.

1. Why Parsing Was Needed

Raw text prevents:

Counting items sold

Category analysis

Quantity calculations

Linking to official menu

Product KPIs

Parsing solves this.

2. What the Script Does

Reads Excel with invoice_no + raw text

Splits items by ;

Removes modifiers (:)

Extracts quantity (regex (\d+)x)

Normalizes product names

Outputs normalized table:

transaction_id | invoice_no | quantity | product


Saves → clean_products.csv

3. Output Files
python/
└── clean_products.csv


This is used in SQL to build:

products_order

Enriched products dimension

Product KPIs

(You may insert “before vs after” screenshots.)

🗄️ Phase 3 — SQL Modeling & Analytical Views

SQL Server integrates Excel + Python outputs and computes business logic.

1. Base Tables Loaded into SQL

dbo.transaction_orders

dbo.customers

dbo.zip_code

parsed product table

product catalog

Two main views were created:

orders

customers_kpi

2. orders View — Enriched Order-Level Dataset

Answers:

When do we sell the most?

Who is new vs. returning?

How often do discounts appear?

Which neighborhoods generate more revenue?

How much revenue is refunded?

Adds:

Temporal attributes (year, month, weekday, shift)

Customer status

ZIP → neighborhood mapping

Monetary standardization (cents → euros)

Financials: discount %, delivery fee, refund

This view is the main fact table for BI dashboards.

3. customers_kpi View — Customer Behavior & Retention

Supports:

One-timer vs. repeat segmentation

Customer value analysis

Discount behavior

Retention & recency

Metrics include:

num_orders

first/last order date

retention_status (Active/Recent/Sleeping/Inactive)

customer_lifetime_months

active_frequency

total_spent, avg_order_value

discount_usage metrics

This view drives customer segmentation & LTV analysis.

4. Data Quality & Guardrails in SQL

NULLIF + COALESCE to prevent division errors

Timestamp normalization

Rounding cents to euros

Analysis period encapsulated in the view

Consistent KPIs across all BI tools.