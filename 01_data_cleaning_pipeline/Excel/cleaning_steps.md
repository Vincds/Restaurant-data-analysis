# Excel Cleaning Steps — Technical Documentation

This document describes the full Excel workflow applied before Python parsing and SQL modeling.

It captures the transformations required to standardize raw export files from the Last App delivery platform and prepare them for structured analysis.

---

## 1. Objectives of Excel Pre-Processing

The Excel cleaning step was designed to:

- Remove irrelevant and constant fields
- Standardize timestamps
- Extract geographic information (ZIP → neighborhood)
- Create anonymized customer identifiers
- Prepare intermediate files for Python parsing
- Improve data quality before SQL loading
- Support later feature engineering (temporal, geographic, retention)

---

## 2. Columns Removed or Consolidated

Several fields were dropped because they were constant, duplicated, or irrelevant for analysis:

- `pickup_type` (constant)
- `Location` (constant)
- `Code`
- `Name` (duplicate of customer_name)
- `Source` (constant)
- `Creation_time` (discounted for scheduled orders)
- `courier_name`
- `scheduling_time`
- `payment_method` (constant)
- `virtual_brand` (single brand only)
- `estimated_delivery_time` (always activation_time + 28 min)

This improved dataset clarity and reduced noise for downstream processes.

---

## 3. Timestamp Standardization

**Chosen timestamp:** `Activation_time`

### Reasoning
- Represents when the kitchen actively receives the order
- More accurate for operational analysis
- Avoids issues with scheduled orders
- Estimated delivery time was artificially set (+28 minutes), not real

### Excel Transformation
- Converted to proper Excel datetime format
- Created a clean `order_date` column (date only)

---

## 4. ZIP Code Extraction

**Original address example:**
```
"Nombre Calle 123, 08025 Barcelona, Espagne"
```

### Steps:
1. Extracted ZIP code (08025) using Flash Fill
2. Validated extraction accuracy using filters and unique counts
3. Created a clean `zip_code` column to join with the neighborhood reference table

---

## 5. Customer Table Creation & Anonymization

Because the platform does not provide a stable customer ID, the phone number was used as the primary identifier before anonymization.

### Steps performed:

1. Copied full phone column → new sheet
2. Converted to Text format to preserve structure (e.g. +34…)
3. Removed duplicates to isolate unique customers
4. Generated anonymized IDs:
   - `customer_id` = sequential integer (C0001, C0002, …)
5. Merged `customer_id` back into orders using `XLOOKUP`
6. Removed sensitive data from all tables:
   - Phone number
   - Email
   - Full address (replaced with masked/synthetic equivalents)

**Final Output:**  
✔️ [Customers](customers_sample.csv) — anonymized customer master table

---

## 6. Preparing Product Text for Python Parsing

Since all items ordered were buried inside a long unstructured text field (`products`), an intermediate file was created to isolate this data.

### Intermediate table created:
- `invoice_no`
- `products_raw_text`

### Purpose:
- Provide a clean input to the Python parser
- Remove unrelated columns
- Avoid Excel formatting corruption in long text fields

**Saved as:**  
➡️ [Orders with products text](orders_with_products_text_sample.csv)

---

## 7. Creating the Products Table Using the Product Catalog

After Python parsing, the following workflow was executed:

### Step 1 — Python output

Python created:

**clean_products:**
```
transaction_id | invoice_no | quantity | product_name
```

### Step 2 — Download official product catalog from Last

Catalog included:
```
product_id | product_name | category_name | price_per_unit | (diet_type, etc.)
```

### Step 3 — Normalize mismatched names

- Fixed minor inconsistencies between parsed names and catalog names
- Ensured join compatibility

### Step 4 — Replace product_name with product_id

Performed a lookup:
```
clean_products.product_name → catalog.product_name
```

**Final Products table:**
```
transaction_id | invoice_no | quantity | product_id
```

This normalized table was loaded into SQL Server as Products.

---

## 8. Data Quality Checks Performed in Excel

- Verified all `invoice_no` values were unique
- Ensured every order was mapped to a `customer_id`
- Confirmed >99% success on ZIP extraction
- Identified truncated product strings on some large orders
- Checked for missing totals or discount values
- Validated:
  ```
  gross_total ≈ total + discounts_applied
  ```
  (Minor discrepancies expected due to platform formatting)

---

## 9. Known Data Limitations

Documented issues for transparency:

- A small number of large orders have truncated product text
- Customizations ("modifiers") are inconsistently included
- Minor mismatch between reconstructed product revenue and platform totals (acceptable for exploration)
- Product catalog naming inconsistencies required manual normalization