📘 Restaurant Delivery Data Cleaning & Modeling Pipeline
Excel · Python · SQL Server · Power BI · Tableau
<p align="center"> <img src="https://img.shields.io/badge/Excel-217346?style=for-the-badge&logo=microsoft-excel&logoColor=white"/> <img src="https://img.shields.io/badge/Python-3670A0?style=for-the-badge&logo=python&logoColor=yellow"/> <img src="https://img.shields.io/badge/SQL%20Server-CC2927?style=for-the-badge&logo=microsoftsqlserver&logoColor=white"/> <img src="https://img.shields.io/badge/Power%20BI-F2C811?style=for-the-badge&logo=powerbi&logoColor=black"/> <img src="https://img.shields.io/badge/Tableau-E97627?style=for-the-badge&logo=tableau&logoColor=white"/> </p>
📑 Table of Contents

Executive Summary

High-Level Architecture

Business Context & Purpose

Project Objectives

What Was Done (High-Level)

Business Impact

Phase 1 — Excel Preparation

Phase 2 — Python Parsing

Phase 3 — SQL Modeling & Analytical Views

Repository Structure

⚡ Executive Summary

This project transforms raw export data from the Last delivery platform into a clean, structured, analytics-ready dataset using Excel, Python, and SQL Server.

The pipeline:

Anonymizes customers

Parses unstructured product text

Enriches items using official menu metadata

Normalizes the dataset into a relational model

Creates analytical views powering Power BI & Tableau dashboards

Final curated dataset includes:

4184 total orders

1805 anonymized customers

114 enriched menu items

This dataset powers two downstream projects:
(1) Power BI Insight Story and (2) Tableau Interactive Dashboard.

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

Raw exports from Last App contained:

Personal customer data

One long text field storing all products

Missing product granularity

Non-standard timestamps

No standalone customer ID

No product attributes (category, diet type, etc.)

This limited the ability to analyze:

Sales

Customer retention

Discount impact

Menu performance

Behavioral patterns

This project creates a professional-grade analytical foundation across Excel → Python → SQL.

🎯 2. Project Objectives

✔ Transform messy operational exports
✔ Protect customer privacy (anonymization)
✔ Parse unstructured product text
✔ Enrich product attributes
✔ Build a relational SQL model
✔ Create reusable analytical views
✔ Enable BI dashboards with consistent KPIs

🧹 3. What Was Done (High-Level)
1. Excel Cleaning & Anonymization

Removed irrelevant fields

Standardized timestamps

Extracted ZIP codes

Built customer dimension with anonymized customer_id

2. Python Parsing of Product Text

Parsed long product strings

Extracted quantities

Removed modifiers

Cleaned product names

Output a clean table → product per row

3. Excel Enrichment

Merged products with official menu metadata

Added category, diet type, avg price, availability

4. SQL Modeling

Created normalized tables:

orders

customers

products

products_order

zip_code

promos

(ERD stored in /docs/erd.png)

5. Analytical Views

orders_update → enriched order dataset

customers_kpi → aggregated behavioral KPIs

6. Data Limitations

Minor product text truncation

Missing paid modifiers

Expected revenue gap (<10%)

Occasional platform inconsistencies

💼 4. Business Impact
🟦 Reliable Sales Analytics

Day/week/month/shift performance.

🟩 Customer Insights

Retention, lifecycle, frequency, spend.

🟨 Promotion & Discount Effectiveness

Impact on volume & margin.

🟥 Menu Optimization

Category performance & upselling.

🟪 Faster Dashboarding

Semantic layer ensures consistent KPIs across Power BI & Tableau.

📘 Phase 1 — Raw Data Understanding & Excel Preparation

The raw operational export (orders_raw.xlsx) from Last App included:

Order metadata

Customer PII

Financial metrics (total, discount, fees)

Products field: one long unstructured string

Operational details

Additional supporting files:

Product catalog

ZIP → neighborhood mapping

Monthly promotions

Excel Cleaning Steps
✔ Removed irrelevant columns

Dropped static fields (courier name, payment method, etc.).

✔ Selected the correct timestamp

Used activation_time (true kitchen timestamp).

✔ Extracted ZIP codes

Used for neighborhood-based segmentation.

✔ Built anonymized customer table

Deduplicated phone numbers

Assigned new customer_id

Removed all PII
→ Output: excel/customers.xlsx

✔ Prepared product text file

Created orders_with_products_text.xlsx to feed Python.

🐍 Phase 2 — Python Parsing of Product Data

Raw product text example:

"1x PACK PARA 2: 1x Pollo Tikka Masala*, 1x Palak Paneer*; 
2x Coca-Cola Zero.; 1x Naan.; 1x Alitas de Pollo*"


This format prevents product analytics.

Python Script Actions

Read Excel with invoice_no + product text

Split items by ;

Remove modifiers (:)

Extract quantities using regex

Normalize product names

Output normalized structure:

transaction_id | invoice_no | quantity | product


Save → clean_products.csv

🗄️ Phase 3 — SQL Modeling & Analytical Views

SQL Server integrates all cleaned sources and computes business logic.

1. Tables Loaded into SQL Server

dbo.transaction_orders

dbo.customers

dbo.zip_code

Parsed product table

Product catalog

2. orders_update View

Enriched order-level dataset

Adds:

Customer intelligence

First order date

New vs. returning

Time features

order_date, year, month

weekday, weekend flag

hour, shift

first_day_month

Geography

ZIP code

Neighborhood mapping

Financial metrics

gross_total

net_total

discounts_applied & %

discount_usage flag

delivery_fee

refunded_amount

Used as the fact table for BI.

3. customers_kpi View

Customer behavior & retention metrics

Computes:

Order patterns

num_orders

first/last order

type_of_customer

Retention

Active / Recent / Sleeping / Inactive

lifetime_months

active_frequency

Financials

total_spent

avg_order_value

total_discount

Discount behavior

perc_discount

num_discounted_orders

perc_discounted_orders

4. SQL Guardrails & Quality

NULL handling (NULLIF/COALESCE)

Timestamp normalization

Monetary rounding (cents → euros)

Analysis period encapsulated in view