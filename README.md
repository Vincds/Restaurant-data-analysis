📘 Restaurant Delivery Data Cleaning & Modeling Pipeline
Excel · Python · SQL Server
________________________________________
⚡ Executive Summary
This project transforms raw operational export data from the Last delivery platform into a clean, structured, and analysis-ready data model using Excel, Python, and SQL Server.
The pipeline standardizes timestamps, anonymizes customers, parses unstructured product text, enriches products with official menu metadata, and engineers complete order- and customer-level KPIs.
The final curated dataset contains:
•	Total orders processed: 4184
•	Unique customers identified & anonymized: 1805
•	Menu items enriched with category & diet type: 114
This cleaned dataset is the foundation for two downstream projects:
(1) SQL + Power BI Insight Story and (2) Tableau Interactive Dashboard.
________________________________________
🔍 High-Level Architecture
A simple overview of how raw operational data becomes a trusted analytical dataset:
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
________________________________________
🧩 1. Business Context & Purpose
The restaurant operates a delivery e-commerce powered by Last App.
The raw exports, however, contain several issues:
•	Customer phone numbers and personal data
•	One text field listing all products ordered
•	Repeated irrelevant operational fields
•	Missing product granularity
•	Non-standard timestamps
•	No customer ID
•	No product attributes (category, diet type, etc.)
These limitations prevent meaningful analysis of:
•	Sales performance
•	Customer retention
•	Discount effectiveness
•	Menu performance
•	Behavioral patterns across time/segments
This project creates a professional-grade data foundation that solves these issues and prepares the dataset for analytical use across BI tools.
________________________________________
🎯 2. Project Objectives
The goal is to reconstruct an end-to-end data cleaning and modeling pipeline that:
✔ Transforms messy operational exports
✔ Anonymizes sensitive customer data
✔ Parses unstructured product descriptions
✔ Enriches items with official attributes
✔ Normalizes the dataset into a relational model
✔ Creates an analytical semantic layer (views)
✔ Supports reliable business insights and dashboards
By the end, the dataset behaves like a proper analytics-ready warehouse.
________________________________________
🧹 3. What Was Done (High-Level)
1. Excel Cleaning & Anonymization
•	Removed irrelevant fields
•	Standardized date fields
•	Extracted ZIP codes
•	Created a customer dimension
•	Generated unique customer_id to anonymize PII
2. Python Parsing of Product Text
•	Split long product strings
•	Extracted quantity (2x) and product names
•	Normalized text (remove modifiers, punctuation, trailing symbols)
•	Created a clean products_order mapping table
3. Excel Enrichment with Official Menu
•	Merged parsed product names with official menu metadata
•	Added category, diet type, stock status, avg price
•	Created final products dimension
4. SQL Server Data Modeling
Structured the cleaned files into normalized tables:
•	orders
•	products
•	products_order
•	customers
•	zip_code
•	promos
Created an ER diagram to illustrate the data relationships.
5. Analytical Views (Semantic Layer)
Engineered two views for BI analysis:
orders_update
•	Customer status (new / returning)
•	Time attributes (year, month, weekday, shift)
•	Geographic mapping (ZIP → neighborhood)
•	Financials (gross total, discount %, net total, delivery fee)
customers_kpi
•	Frequency metrics
•	Lifetime metrics
•	Retention classification
•	Total spent & AOV
•	Discount behavior
These views eliminate repetitive cleaning in BI tools and ensure consistent KPIs.
6. Data Limitations Documented
•	Product text truncation
•	Missing paid modifiers
•	Revenue reconstruction gap (expected <10%)
•	Irregularities from platform export
All limitations are quantified and explained.
________________________________________
💼 4. Business Impact
This cleaned and structured dataset enables:
🟦 Reliable Sales Trend Analysis
Day, week, month, shift, weekday/weekend performance.
🟩 Customer Behavior Insights
Retention, repeat behavior, frequency, lifetime activity.
🟨 Discount Effectiveness
Impact of promotions on order volume, margins, and customer habits.
🟥 Product & Menu Optimization
Most ordered items, category performance, upsell opportunities.
🟪 Faster Dashboarding & Reusable Metrics
Semantic layer → all KPIs consistent across Power BI and Tableau.
This transforms raw operational exports into a strategic analytics asset.

📘 Phase 1 — Raw Data Understanding & Excel Preparation
This phase documents how the raw operational files exported from the Last App delivery platform were transformed into structured, analysis-ready tables.
The goal was to create a robust foundation for downstream processing in Python and SQL, while protecting customer privacy and preserving business-critical fields.
________________________________________
1. Raw Data Sources
The primary dataset was an Excel export from Last App containing one row per order, with the following types of information:
1.1. orders_raw.xlsx (Main Source File)
Included:
•	Order metadata
(invoice_no, activation_time, payment method, virtual brand, pickup type)
•	Customer details
(full name, address, phone number, email)
•	Financial fields
(total, discounts applied, delivery fee, refunded amount)
•	Products field
A long unstructured text string concatenating all items within the order
(e.g., "1x Naan.; 2x Coca-Cola Zero, lata 0.33L.; 1x Arroz Basmati...")
•	Operational details
(assigned courier, scheduling time, estimated delivery time)
1.2. Additional Data Files Used
To enrich the dataset and enable geographic, product-level, and promotional insights:
•	Official product list (menu) → includes category, diet type, avg price
•	Barcelona ZIP → neighborhood mapping
•	Monthly promotions applied by the restaurant
These files support normalization and the enrichment process performed later in SQL.
________________________________________
2. Excel Cleaning & Standardization
This step focused on removing noise, protecting privacy, and preparing intermediate files for Python parsing and SQL modeling.
✔️ 2.1 Remove Irrelevant or Constant Columns
Dropped fields such as pickup type, courier name, or payment method when they contained no variation or business value.
✔️ 2.2 Select the Correct Operational Timestamp
The dataset contained multiple timestamps.
Activation_time was selected because:
•	It marks when the kitchen receives the order
•	Estimated delivery time was artificially set (+28 min by default)
•	Creation_time included scheduled orders misplaced in time
✔️ 2.3 Extract the ZIP Code
The customer address was processed to extract the 080xx ZIP code for geographic segmentation.
This enabled joining the data to the neighborhood table.
✔️ 2.4 Build an Anonymized customers Table
Since phone number was the only reliable unique identifier:
1.	Extracted all phone numbers
2.	Removed duplicates
3.	Assigned a new customer_id
4.	Joined customer_id back into the orders file
5.	Dropped all sensitive fields (phone, email)
Resulting file:
➡️ excel/customers.xlsx
✔️ 2.5 Prepare Intermediate Product Table
To feed the Python parsing script:
•	Extracted invoice_no + full products text
•	Saved the intermediate file as:
➡️ orders_with_products_text.xlsx
This file was later used to generate the normalized product-order table.


🐍 Phase 2 — Python Parsing of Product Data
The raw export from Last App contains all ordered items inside a single unstructured text field per order.
This format is not suitable for product-level analytics.
To accurately analyze item performance, category mixes, and order composition, a Python script was created to:
•	Parse the long text field (e.g., "1x Naan; 2x Coca-Cola Zero...")
•	Extract each product name and quantity
•	Remove modifiers and noise
•	Normalize formatting
•	Output a clean, tabular dataset with one product per row
________________________________________
1. Why This Step Was Necessary
The platform stores products like this:
"1x PACK PARA 2: 1x Pollo Tikka Masala*, 1x Palak Paneer Vegetariano*;
 2x Coca-Cola Zero, lata 0.33l.; 1x Naan.; 1x Alitas de Pollo*"
This structure makes it impossible to:
•	Count item-level sales
•	Analyze product mix
•	Calculate quantities sold
•	Link products to official menu attributes
•	Build product dashboards
The Python parser turns this into analysis-ready data.
________________________________________
2. What the Script Does
The Python script:
1.	Reads the Excel file containing invoice_no + raw product text
2.	Splits items by ;
3.	Removes modifiers after :
4.	Extracts quantity using regex (e.g., "2x")
5.	Cleans product names (remove dots, asterisks, quotes, formatting artifacts)
6.	Creates a normalized table:
7.	transaction_id | invoice_no | quantity | product
8.	Saves output as:
➡️ clean_products.csv
This dataset is then imported into SQL to merge with the official product catalog.
________________________________________
3. Output of Phase 2
Generated file:
python/
└── clean_products.csv    # one row per product per invoice
This file is used in Phase 3 (SQL Modeling) to build:
•	The final products_order table
•	Enriched products table
•	Product KPIs
(Optional) Insert a screenshot showing “before vs after” of raw text → parsed products.

Phase 3 — SQL Modeling & Analytical Views
After cleaning the raw Excel files (Phase 1) and parsing the product text with Python (Phase 2), the next step was to structure everything in SQL Server and create curated analytical views.
These views act as a semantic layer: they standardize key metrics and business logic so that Power BI and Tableau can connect directly, without repeating calculations or cleaning steps in each report.
________________________________________
1. From Tables to Analytical Model
The following tables were loaded into SQL Server:
•	dbo.transaction_orders → raw order transactions (amounts in cents, timestamps, ZIP codes, discounts)
•	dbo.customers → anonymized customer master (customer_id, customer_name)
•	dbo.zip_code → ZIP → neighborhood mapping
•	Parsed products & catalog (from previous phases, used in other analysis)
On top of these base tables, I created two main analytical views:
1.	orders → enriched order-level dataset
2.	customers_kpi → aggregated customer-level KPIs
These are the primary entry points for all BI tools.
________________________________________
2. orders View — Enriched Order-Level Dataset
This view transforms each raw order into a report-ready record, adding time, geographic, and discount features.
Key Business Questions it supports:
•	When do we sell the most? (by day, month, hour, shift, weekday/weekend)
•	How many orders come from new vs. returning customers?
•	How much do we discount and how often?
•	Which neighborhoods generate more revenue?
•	How much revenue is refunded or paid in delivery fees?
What the view does:
•	Identifies first-time vs. returning customers
o	Using a CTE (min_order_date) to find each customer’s first purchase date
•	Adds temporal features:
o	order_date, year, month, weekday, day_type (Weekday/Weekend), hour, shift (Morning/Afternoon/Night)
o	first_day_month to easily join with the promos table and group by month
•	Adds geographic context:
o	zip_code, neighborhood from dbo.zip_code
•	Standardizes financial metrics (converting cents to euros):
o	gross_total = (Total + Discounts_applied) / 100
o	total = net order value / 100
o	discounts_applied = absolute value / 100
o	perc_discount = % of gross total
o	discount_usage = Yes/No
o	refunded_amount, delivery_fee
This view is used as the main fact table for sales and operations analysis in Power BI and Tableau.
________________________________________
3. customers_kpi View — Customer Behavior & Retention
This view aggregates order data at the customer level over a defined analysis period (2023–2024).
Key Business Questions it supports:
•	What share of customers are one-timers vs. repeat buyers?
•	Who are our most valuable customers (by total spend, frequency, discounts)?
•	What is the distribution of customer recency and retention status?
•	How often do customers order, and how much do they spend per order?
•	How heavily do customers rely on discounts?
What the view does:
Using an internal CTE analysis_period, it:
•	Filters orders between 2023-01-01 and 2024-12-31
•	Groups by customer_id and customer_name
•	Computes:
Order patterns
o	num_orders
o	first_order_date / last_order_date
o	type_of_customer = One-Timer / Repeating
Engagement & retention
o	retention_status based on recency vs. '2024-12-31'
	Active (≤ 30 days)
	Recent (≤ 60 days)
	Sleeping (≤ 180 days)
	Inactive (> 180 days)
o	customer_lifetime_months = months between first and last order
o	active_frequency = orders per active month
Financial KPIs
o	total_spent (rounded)
o	total_discount
o	avg_order_value
Discount behavior
o	perc_discount = percentage of gross value represented by discounts
o	num_discounted_orders
o	perc_discounted_orders = % of orders with discount
This view serves as the starting point for customer segmentation, retention analysis, and CLV-oriented work.
________________________________________
4. Guardrails & Data Quality in SQL
To maintain robustness, the SQL logic:
•	Uses NULLIF and COALESCE to avoid division by zero
•	Rounds monetary values appropriately (cents → euros)
•	Normalizes timestamps and reduces noise at the view level
•	Encapsulates the analysis period inside the view definition, making it easy to reuse consistently
All of this ensures that stakeholders see consistent metrics, no matter which BI tool or query they use.


