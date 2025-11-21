-------------------------------------------------------------
-- 1. Validate Date Coverage
-- Confirms the dataset contains orders in the expected range
-------------------------------------------------------------
SELECT 
    MIN(order_date) AS min_date,
    MAX(order_date) AS max_date
FROM orders;


-------------------------------------------------------------
-- 2. Validate Row Count Consistency
-- Ensures no rows were lost or duplicated in the view creation
-------------------------------------------------------------
SELECT 
    (SELECT COUNT(*) FROM dbo.transaction_orders) AS raw_orders,
    (SELECT COUNT(*) FROM orders) AS view_orders;


-------------------------------------------------------------
-- 3. Financial Consistency Check
-- Ensures gross_total = total + discounts_applied (within rounding)
-------------------------------------------------------------
SELECT *
FROM orders
WHERE ABS(gross_total - (total + discounts_applied)) > 0.01;


-------------------------------------------------------------
-- 4. Missing Customer IDs
-- Identifies orders that failed to map to a customer record
-------------------------------------------------------------
SELECT *
FROM orders
WHERE customer_id IS NULL OR customer_id = '';


-------------------------------------------------------------
-- 5. Missing Invoice Numbers
-- Validates referential integrity for the primary transaction key
-------------------------------------------------------------
SELECT *
FROM orders
WHERE invoice_no IS NULL OR invoice_no = '';


-------------------------------------------------------------
-- 6. Missing Neighborhood Mapping
-- Detects ZIP codes not matched to a neighborhood
-------------------------------------------------------------
SELECT *
FROM orders
WHERE neighborhood IS NULL;


-------------------------------------------------------------
-- 7. Discount Logic Validation
-- Ensures discount_usage flag is consistent with applied values
-------------------------------------------------------------
SELECT *
FROM orders
WHERE discounts_applied > 0 AND discount_usage <> 'Yes';
