# ✅ SQL Layer — Technical Documentation

This file contains the SQL logic used to transform the cleaned datasets into a structured analytical model and create reusable views for BI tools (Power BI & Tableau).

It also includes optional data-quality checks to validate the consistency of the pipeline.

---

## 📂 Files Included

### 01_views.sql

This script contains the two analytical views used throughout the project:

#### 1. orders View (Order-level enriched dataset)

Adds business logic and engineered features, including:
- Temporal features (year, month, weekday, hour, shift, day_type)
- Customer segmentation (new vs. returning)
- Geography (ZIP → neighborhood mapping)
- Standardized financial metrics (gross total, net total, discounts, refund amounts)
- Discount usage & %
- Month-normalized date for joining with promotions table

This view acts as the main fact table for downstream BI and SQL analysis.

---

#### 2. customers_kpi View (Customer-level KPIs)

Aggregates customer behavior for the period 2023–2024, including:
- Order history (first/last order, number of orders)
- Engagement classification (Active / Recent / Sleeping / Inactive)
- Customer lifetime in months
- Frequency metrics (active frequency, lifetime frequency)
- Financial KPIs (total spent, avg order value, total discount)
- Discount adoption (num & % of discounted orders)

This view is the foundation for retention analysis and customer segmentation.

The SQL code is fully documented with inline comments explaining the logic and rationale behind each transformation.

---

## 🔗 Dependencies

Both views rely on the following base tables:
- `dbo.transaction_orders` – Raw order transactions
- `dbo.customers` – Anonymized customer master
- `dbo.zip_code` – ZIP → neighborhood reference

Product-level tables (parsed from Python) are not required for these two views but are used in other analyses.

---

### 02_data_quality_checks.sql

This script includes a set of targeted data-quality checks designed to verify the integrity of the dataset and ensure that the transformation logic applied in the SQL views (`orders` and `customers_kpi`) is reliable.

These checks validate completeness, consistency, referential integrity, and financial correctness.

Each query represents a standard validation process used in real analytics workflows.

---

### ✔️ 1. Validate Date Coverage

Ensures the dataset spans the expected analysis period.

```sql
-- Validate minimum and maximum order dates
SELECT 
    MIN(order_date) AS min_date,
    MAX(order_date) AS max_date
FROM orders;
```

---

### ✔️ 2. Validate Row Count Consistency

Ensures no rows are lost during view transformations.

```sql
-- Compare raw table count with the enriched view
SELECT 
    (SELECT COUNT(*) FROM dbo.transaction_orders) AS raw_orders,
    (SELECT COUNT(*) FROM orders) AS view_orders;
```

---

### ✔️ 3. Validate Financial Consistency

Checks that `gross_total = total + discounts_applied` after normalization.

```sql
-- Identify rows where the financial totals do not reconcile
SELECT *
FROM orders
WHERE ABS(gross_total - (total + discounts_applied)) > 0.01;
```

---

### ✔️ 4. Identify Missing Customer IDs

Validates that all orders are linked to a customer.

```sql
-- Identify orders without a valid customer_id
SELECT *
FROM orders
WHERE customer_id IS NULL OR customer_id = '';
```

---

### ✔️ 5. Identify Orders With Missing Invoice Numbers

Invoice numbers must exist for every transaction.

```sql
-- Identify orders without an invoice number
SELECT *
FROM orders
WHERE invoice_no IS NULL OR invoice_no = '';
```

---

### ✔️ 6. Validate Neighborhood Mapping

Checks for missing ZIP-to-neighborhood joins.

```sql
-- Identify rows without geographic mapping
SELECT *
FROM orders
WHERE neighborhood IS NULL;
```

---

### ✔️ 7. Validate Discount Logic

Ensures discount flags are correctly assigned.

```sql
-- Verify that discount_usage = 'Yes' whenever a discount was applied
SELECT *
FROM orders
WHERE discounts_applied > 0 AND discount_usage <> 'Yes';
```