# 📊 Excel Cleaning & Transformation
**Raw Export → Analysis-Ready Dataset**

This document explains how messy Last App exports were cleaned in Excel before Python parsing and SQL modeling.

---

## 🎯 Objectives

Transform raw operational exports into structured data by:

| Goal | Method |
|------|--------|
| **Remove noise** | Drop constant/irrelevant columns |
| **Standardize time** | Select correct operational timestamp |
| **Extract geography** | Parse ZIP codes from addresses |
| **Anonymize PII** | Generate synthetic customer IDs |
| **Prepare for parsing** | Create clean input files for Python |

---

## 📸 Before & After

### Raw Export (Before)
![Raw data with PII](01_data_cleaning_pipeline/screenshots/raw_data.png)
*Exposed phone numbers, emails, multiple timestamp fields, unstructured addresses*

### Cleaned Dataset (After)
![Clean data with customer_id](01_data_cleaning_pipeline/screenshots/cleaned_orders_table.png)
*Anonymized IDs, standardized timestamps, extracted ZIP codes, removed PII*

---

## 🧹 Step 1: Column Cleanup

Removed fields that added no analytical value:

<table>
<tr><th>Removed Column</th><th>Reason</th></tr>
<tr><td><code>pickup_type</code></td><td>Constant value (always "Delivery")</td></tr>
<tr><td><code>Location</code></td><td>Single restaurant location</td></tr>
<tr><td><code>Creation_time</code></td><td>Unreliable for scheduled orders</td></tr>
<tr><td><code>estimated_delivery_time</code></td><td>Artificial calculation (+28 min default)</td></tr>
<tr><td><code>courier_name</code></td><td>Not relevant for sales analysis</td></tr>
<tr><td><code>payment_method</code></td><td>Constant (online payment only)</td></tr>
<tr><td><code>virtual_brand</code></td><td>Single brand</td></tr>
</table>

**Result:** Dataset reduced from 20+ columns to 12 essential fields.

---

## ⏰ Step 2: Timestamp Standardization

### The Problem
Raw export contained 3 different timestamps:

```
Creation_time:          30/12/2024 20:05  (user places order - includes scheduled)
Activation_time:        30/12/2024 20:33  (kitchen receives order)
Estimated_delivery_time: 30/12/2024 21:01  (always +28 min artificial)
```

### The Decision
**Selected: `Activation_time`**

✅ Represents actual operational moment (kitchen receipt)  
✅ Accurate for trend analysis (day/hour patterns)  
✅ Avoids misplaced scheduled orders  
❌ `Creation_time` showed orders hours before actual prep  
❌ `Estimated_delivery_time` was not real data  

### Transformation
```excel
// Converted to datetime format
=TEXT(Activation_time, "YYYY-MM-DD HH:MM:SS")

// Extracted date only
=DATE(YEAR(Activation_time), MONTH(Activation_time), DAY(Activation_time))
```

---

## 📍 Step 3: Geographic Extraction

### Challenge
Addresses were unstructured text:

```
"C/ de Mallorca, 08026 Barcelona, España"
"Carrer del Poeta Cabanyes, 08004 Barcelona, Spain"
"Pg. de St. Joan, 08010 Barcelona, Spain"
```

### Solution: Flash Fill
![ZIP extraction using Flash Fill](01_data_cleaning_pipeline/screenshots/zipcode_extraction_flashfill.png)

**Steps:**
1. Typed pattern in first 2 rows: `08026`, `08004`
2. Used Excel Flash Fill (Ctrl+E) to detect pattern
3. Extracted all 5-digit ZIP codes

**Result:**
- ✅ 4,125 / 4,184 orders (98.6%) successfully extracted
- ⚠️ 59 orders had malformed addresses (flagged for review)

---

## 🔒 Step 4: Customer Anonymization

### The Challenge
**No customer ID provided by platform.** Phone number was the only unique identifier.

### Process Flow

```
Raw Data (with PII)
        ↓
1. Extract phone numbers → Separate sheet
2. Remove duplicates → 1,805 unique customers  
3. Generate synthetic IDs → C0001, C0002, C0003...
4. Map back to orders using XLOOKUP
5. Remove all PII columns
        ↓
Clean Data (anonymized)
```

### Excel Formula Used
```excel
// Map customer_id back to orders table
=XLOOKUP([@customer_phone], customers[phone], customers[customer_id], "NOT_FOUND")
```

### Before/After Example

**Before (PII exposed):**
![Customer data with phone](screenshots/intermediate_customers_table.png)

**After (anonymized):**
![Customer data anonymized](screenshots/customers_table.pngg)

### Output Files
- ✅ `customers.csv` → `customer_id` | `customer_name` (no phone/email)
- ✅ `transaction_orders.csv` → includes `customer_id` (no PII)

---

## 🐍 Step 5: Prepare Product Text for Python

Created intermediate file for Python parsing script.

### Why This Step?
- All products were in ONE cell per order
- Excel can corrupt long text fields during export
- Python regex parser needed clean input

### Intermediate Table Created
```
invoice_no | products_raw_text
-----------|-----------------
LS35713    | 1x PACK PARA 2: 1x Pollo Tikka Masala*...
LS35683    | 1x Channa Masala (Vegano).; 1x Arroz...
```

**Saved as:** `orders_with_products_text.csv`  
**Fed into:** `Python/clean_products.py`

---

## 🛒 Step 6: Product Catalog Enrichment

After Python parsed product text, Excel was used to match against official menu.

### Workflow

```
1. Python Output:
   transaction_id | invoice_no | quantity | product_name
   
2. Download Official Catalog from Last:
   product_id | product_name | category | diet_type | price
   
3. Excel: Normalize Product Names
   "Pollo Tikka Masala" → "Pollo Tikka Masala"
   "Pollo Tikka Masala." → "Pollo Tikka Masala"
   (remove dots, standardize spacing)
   
4. Excel: VLOOKUP to Replace Names with IDs
   =VLOOKUP(product_name, catalog[name:id], 2, FALSE)
   
5. Final Table:
   transaction_id | invoice_no | quantity | product_id
```

**Result:** 114 unique products enriched with category and diet type metadata.

---

## ✅ Step 7: Data Quality Validation

### Checks Performed in Excel

| Check | Method | Result |
|-------|--------|--------|
| **Unique invoices** | Remove duplicates on `invoice_no` | ✅ 4,184 unique (100%) |
| **Customer mapping** | Filter for NULL `customer_id` | ✅ 4,184 / 4,184 mapped (100%) |
| **ZIP extraction** | Filter for empty `zip_code` | ⚠️ 59 / 4,184 missing (1.4%) |
| **Financial consistency** | `gross_total ≈ total + discounts` | ✅ <0.5% variance (rounding) |
| **Missing totals** | Filter for NULL `Total` | ✅ 0 missing |

### Issues Documented

```
✅ Invoice uniqueness:     100% (4,184 unique)
✅ Customer mapping:       100% (1,805 customers)
⚠️  ZIP code extraction:   98.6% (59 failed - malformed addresses)
✅ Financial integrity:    99.5% (minor rounding from cents→euros)
```

---

## ⚠️ Known Limitations

Documented for transparency with stakeholders:

### 1. Product Text Truncation
**Issue:** Excel cell limit (32,767 characters) truncated some large orders.  
**Impact:** ~2% of orders may have incomplete product lists.  
**Note:** Platform export limitation, not cleaning error.

### 2. Missing Modifiers
**Issue:** Paid customizations ("extra cheese") not captured in export.  
**Impact:** Cannot analyze upsell effectiveness.  
**Note:** Last App export does not include modifier-level data.

### 3. Revenue Reconciliation Gap
**Issue:** Reconstructed revenue from `price × quantity` differs from platform totals.  
**Magnitude:** €25K difference on €200K gross (12.5% gap).  
**Cause:** Combination of truncated products + missing modifiers + platform rounding.  
**Recommendation:** Use this dataset for trend/pattern analysis, not financial reporting.

### 4. Manual Product Normalization
**Issue:** 14 products (12%) required manual name matching to catalog.  
**Impact:** Minor inconsistencies between parsed names and official menu.  
**Resolution:** Created normalization mapping table in Excel.

---

## 📤 Output Files Created

All files prepared for SQL import:

```
Excel/
├── customers.csv                    ← Anonymized dimension (1,805 records)
├── transaction_orders.csv           ← Cleaned orders (4,184 records)
├── orders_with_products_text.csv    ← Python parser input
├── products_catalog.csv             ← Official menu metadata (114 items)
└── zip_code_neighborhood.csv        ← Geographic reference
```

---

## 🔄 Pipeline Handoff Points

This Excel cleaning feeds downstream processes:

```
📊 Excel Cleaning
   ↓
   ├→ customers.csv ──────────────→ SQL: customers table
   ├→ transaction_orders.csv ─────→ SQL: transaction_orders table
   ├→ orders_with_products_text ──→ 🐍 Python: clean_products.py
   └→ zip_code.csv ───────────────→ SQL: zip_code table
```

---

## 💡 Key Excel Techniques Used

**Functions & Features:**
- `Flash Fill` - Pattern-based ZIP extraction
- `XLOOKUP` - Customer ID mapping
- `Remove Duplicates` - Customer deduplication
- `VLOOKUP` - Product catalog enrichment
- `TEXT` / `DATE` - Timestamp formatting
- `Filters & Pivot Tables` - Data quality validation

**Why Excel for This Step:**
- ✅ Fast exploratory analysis
- ✅ Easy stakeholder review (familiar tool)
- ✅ Visual validation of patterns
- ✅ Quick manual corrections (product names)

---

## 📚 Related Documentation

- **Next step:** [Python/clean_products.py](../Python/clean_products.py) - Product text parsing
- **Final model:** [SQL/01_views.sql](../SQL/01_views.sql) - Analytical views
- **Quality checks:** [SQL/02_data_quality_checks.sql](../SQL/02_data_quality_checks.sql) - Validation queries