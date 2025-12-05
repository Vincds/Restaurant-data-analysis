/* ============================================================
📊 RESTAURANT DELIVERY INTELLIGENCE: SQL ANALYSIS
Complete query collection supporting insights in README.md

Analysis Period: 2023-01-01 to 2024-12-31
Total Orders: 4,184 | Total Customers: 1,809
============================================================ */

/* ============================================================
📘 CHAPTER 1: BUSINESS HEALTH CHECK
Queries: Overall performance, revenue trends, acquisition analysis
============================================================ */

-- 1.1 Overall Performance Metrics
-- PURPOSE: Foundation metrics (sales, customers, orders, AOV, discount rate)

WITH base AS (
    SELECT 
        total,
        gross_total,
        customer_id,
        discounts_applied,
        discount_usage,
        PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY total) OVER () AS median_order_total
    FROM orders
)
SELECT 'total_sales' AS measure_name, ROUND(SUM(total), 0) AS measure_value FROM base
UNION ALL
SELECT 'num_customers', COUNT(DISTINCT customer_id) FROM base
UNION ALL
SELECT 'num_orders', COUNT(*) FROM base
UNION ALL
SELECT 'avg_ticket', ROUND(AVG(total), 1) FROM base
UNION ALL
SELECT 'median_order_total', MAX(median_order_total) FROM base
UNION ALL
SELECT 'gross_sales', ROUND(SUM(gross_total), 0) FROM base
UNION ALL
SELECT 'total_discount', ROUND(SUM(discounts_applied), 0) FROM base
UNION ALL
SELECT 'perc_of_discount', ROUND(SUM(discounts_applied) / SUM(gross_total) * 100, 1) FROM base;


-- 1.2 Year-over-Year Performance
-- PURPOSE: Compare 2023 vs 2024 across all key metrics


SELECT
	year,
	ROUND(SUM(gross_total), 0) AS gross_sales,
	ROUND((SUM(gross_total) - LAG(SUM(gross_total)) OVER(ORDER BY year)) / CAST(LAG(SUM(gross_total)) OVER(ORDER BY year) AS FLOAT) * 100, 1) AS gross_sales_YoY,
	ROUND(SUM(total), 0) AS sales,
	ROUND((SUM(total) - LAG(SUM(total)) OVER(ORDER BY year)) / CAST(LAG(SUM(total)) OVER(ORDER BY year) AS FLOAT) * 100, 1) AS sales_YoY,
	SUM(CASE WHEN new_customer = 'Yes' THEN 1 ELSE 0 END) AS customers,
	ROUND((CAST(SUM(CASE WHEN new_customer = 'Yes' THEN 1 ELSE 0 END) AS FLOAT) - LAG(SUM(CASE WHEN new_customer = 'Yes' THEN 1 ELSE 0 END)) OVER(ORDER BY year)) / NULLIF(LAG(SUM(CASE WHEN new_customer = 'Yes' THEN 1 ELSE 0 END)) OVER(ORDER BY year), 0) * 100, 1) AS customers_YoY,
	COUNT(invoice_no) AS orders,
	ROUND((CAST(COUNT(invoice_no) AS FLOAT) - LAG(COUNT(invoice_no)) OVER(ORDER BY year)) / CAST(LAG(COUNT(invoice_no)) OVER(ORDER BY year) AS FLOAT) * 100, 1) AS orders_YoY,
	ROUND(AVG(total), 0) AS avg_ticket,
	ROUND((AVG(total) - LAG(AVG(total)) OVER(ORDER BY year)) / CAST(LAG(AVG(total)) OVER(ORDER BY year) AS FLOAT) * 100, 1) AS avg_ticket_YoY,
	ROUND(SUM(discounts_applied), 0) AS discount,
	ROUND(SUM(discounts_applied) / SUM(gross_total), 2) AS perc_discount,
	ROUND((SUM(discounts_applied) / SUM(gross_total) - LAG(SUM(discounts_applied) / SUM(gross_total)) OVER(ORDER BY year)) / CAST(LAG(SUM(discounts_applied) / SUM(gross_total)) OVER(ORDER BY year) AS FLOAT) * 100, 1) AS perc_discount_YoY
FROM orders 
GROUP BY year
ORDER BY year;




-- ===============================================
-- 1.3: Year-over-Year (YoY) comparison of monthly sales between 2023 and 2024.
-- PURPOSE: Quantifies growth or decline and helps measure long-term performance.
-- ===============================================
WITH f_sales AS (
    SELECT month, ROUND(SUM(total), 0) AS sales
    FROM orders
    WHERE year = 2023
    GROUP BY month
),
l_sales AS (
    SELECT month, ROUND(SUM(total), 0) AS sales
    FROM orders
    WHERE year = 2024
    GROUP BY month
)
SELECT 
    a.month,
    a.sales AS sales2023,
    b.sales AS sales2024,
    ROUND((b.sales -a.sales ) / a.sales * 100, 1) AS yoy_growth
FROM f_sales a
INNER JOIN l_sales b ON a.month = b.month
ORDER BY a.month;


-- 1.4 Monthly Variance from Baseline
-- PURPOSE: Show which months over/underperform vs €7.2K avg

WITH monthly_sales AS (
    SELECT 
        year,
		month,
        COUNT(*) AS num_orders,
        ROUND(AVG(total), 1) AS avg_ticket,
        ROUND(SUM(total), 0) AS total_sales
    FROM orders
    GROUP BY year, month
)
SELECT 
    year,
	month,
    num_orders,
    avg_ticket,
    total_sales,
    ROUND(AVG(total_sales) OVER(), 0) AS avg_sales,
    ROUND((total_sales - AVG(total_sales) OVER()) / total_sales * 100, 1) AS perc_diff
FROM monthly_sales
ORDER BY year, month
;


-- 1.5 New Customer Acquisition Trend
-- PURPOSE: Track new customer decline (-24.7% YoY)

SELECT
	year,
	month,
	COUNT(customer_id) AS customers
FROM orders
WHERE new_customer = 'Yes'
GROUP BY year, month
ORDER BY year, month




/* ============================================================
📗 CHAPTER 2: THE RETENTION CRISIS
Queries: Churn analysis, LTV, retention status, loyalty patterns
============================================================ */

-- 2.1 Customer Retention Rate
-- PURPOSE: Calculate overall retention (35%)
SELECT 
    ROUND(SUM(CASE WHEN type_of_customer = 'Repeating' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 1) AS retention_rate,
	ROUND(AVG(CAST(num_orders AS FLOAT)), 1) AS avg_orders,
	ROUND(AVG(CAST(customer_lifetime_months AS FLOAT)), 1) AS customer_lifetime_months,
	ROUND(AVG(CAST(total_spent AS FLOAT)),1) AS LTV
FROM customers_kpi;


-- 2.2 Churn Cascade (Order Frequency Distribution)
-- PURPOSE: Track drop-off from order 1 → 2 → 3 (65% churn)

-- 1) Define the bins: minimum number of orders (1 to 10)
WITH bins AS (
    SELECT 1 AS min_orders
    UNION ALL SELECT 2
    UNION ALL SELECT 3
    UNION ALL SELECT 4
    UNION ALL SELECT 5
    UNION ALL SELECT 6
    UNION ALL SELECT 7
    UNION ALL SELECT 8
    UNION ALL SELECT 9
    UNION ALL SELECT 10
)

-- 2) For each bin, count customers with num_orders >= that bin
SELECT
    b.min_orders,                                           -- 1,2,3,...,10
    COUNT(*) AS customers_ge_min_orders,                    -- e.g. 1805, 635...
    ROUND(
        CAST(COUNT(*) AS FLOAT) / (SELECT COUNT(*) FROM customers_kpi) * 100,
        1
    ) AS perc_of_customers                                  -- e.g. 35.0%
FROM bins b
JOIN customers_kpi c
    ON c.num_orders >= b.min_orders
GROUP BY b.min_orders
ORDER BY b.min_orders;


-- 2.3 Lifetime Value by Segment
-- PURPOSE: Compare one-timer vs repeating customer LTV (€43 vs €192.86)
SELECT 
    type_of_customer,
    COUNT(DISTINCT customer_id) AS num_customers,
    ROUND(CAST(COUNT(DISTINCT customer_id) AS FLOAT) / (SELECT COUNT(*) FROM customers_kpi)* 100 , 0)  AS perc_of_total,
    ROUND(SUM(total_spent), 0) AS total_sales,
    ROUND(SUM(total_spent) / (SELECT SUM(total) FROM orders) * 100, 0) AS perc_of_sales,
	ROUND(AVG(CAST(num_orders AS FLOAT)), 1) AS avg_orders,
	ROUND(AVG(CAST(customer_lifetime_months AS FLOAT)), 1) AS customer_lifetime_months,
	ROUND(AVG(CAST(total_spent AS FLOAT)),1) AS LTV	
FROM customers_kpi
GROUP BY type_of_customer


-- 2.5 Retention Status Distribution
-- PURPOSE: Segment by Active/Recent/Sleeping/Inactive (85% dormant)
SELECT 
    retention_status,
    CASE 
        WHEN retention_status = 'Active' THEN '<30 days'
        WHEN retention_status = 'Recent' THEN '<60 days'
        WHEN retention_status = 'Sleeping' THEN '<180 days'
        ELSE '>180 days' 
    END AS recency_group,
    COUNT(*) AS num_customers,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM customers_kpi), 1) AS perc_of_total
FROM customers_kpi
GROUP BY retention_status
ORDER BY num_customers DESC;


-- 2.6 Revenue Mix Shift (New vs Returning)
-- PURPOSE: Track 51%/49% → 36%/64% revenue composition change
SELECT 
    year,
    month,
    ROUND(SUM(CASE WHEN new_customer = 'Yes' THEN total ELSE 0 END), 0) AS new_customers_sales,
    ROUND(SUM(CASE WHEN new_customer = 'No' THEN total ELSE 0 END), 0) AS returning_customers_sales,
    ROUND(SUM(CASE WHEN new_customer = 'Yes' THEN total ELSE 0 END) * 100.0 / SUM(total), 1) AS perc_new_sales,
    ROUND(SUM(CASE WHEN new_customer = 'No' THEN total ELSE 0 END) * 100.0 / SUM(total), 1) AS perc_returning_sales
FROM orders
GROUP BY year, month
ORDER BY year, month;



-- 2.7 Order Frequency Distribution
-- PURPOSE: Reveals distribution of repeat purchase frequency
SELECT 
    num_orders AS number_of_orders,
    COUNT(*) AS number_of_customers,
	ROUND( COUNT(*) / CAST((SELECT COUNT(DISTINCT customer_id) FROM orders) AS FLOAT) * 100, 1) AS perc_of_total
FROM (
    SELECT 
        customer_id,
        COUNT(DISTINCT invoice_no) AS num_orders
    FROM orders
    GROUP BY customer_id
) AS order_counts
GROUP BY num_orders
ORDER BY num_orders;



/* ============================================================
📙 CHAPTER 3: OPERATIONAL PERFORMANCE
Queries: Shift analysis, day-part patterns, weekday/weekend comparison
============================================================ */


-- 3.1 Shift Performance (Morning/Afternoon/Night)
-- PURPOSE: Identify night shift dominance (46.7% of revenue)

WITH total AS (
    SELECT SUM(total) AS total_sales
    FROM orders
)
SELECT
    shift,
	ROUND(SUM(total), 0) AS sales,
	ROUND(SUM(total) / total_sales, 2) * 100 AS perc_of_total,
    ROUND(AVG(total), 1) AS avg_ticket,
    COUNT(*) AS orders
FROM orders
CROSS JOIN total
GROUP BY shift, total_sales
ORDER BY sales DESC;


-- 3.2 Weekday vs Weekend Analysis
-- PURPOSE: Compare volume (weekday 65%) vs value (weekend +5.6% ticket)

WITH daily_sales AS(
	SELECT 
		order_date,
		day_type,
		SUM(total) AS sales
	FROM orders
	GROUP BY order_date, day_type
	)
SELECT
    ds.day_type,
    ROUND(SUM(total), 0) AS sales,
    ROUND(AVG(total), 1) AS avg_ticket,
	ROUND(AVG(sales), 1) AS avg_daily_sales
FROM orders o
LEFT JOIN daily_sales  ds ON o.order_date= ds.order_Date
GROUP BY ds.day_type;


-- 3.3 Revenue by Day of Week
-- PURPOSE: Identify Sunday peak (€34.4K) and Wednesday trough (€19.7K)
SELECT
    weekday,
    CASE 
        WHEN weekday = 1 THEN 'Monday'
        WHEN weekday = 2 THEN 'Tuesday'
        WHEN weekday = 3 THEN 'Wednesday'
        WHEN weekday = 4 THEN 'Thursday'
        WHEN weekday = 5 THEN 'Friday'
        WHEN weekday = 6 THEN 'Saturday'
        WHEN weekday = 7 THEN 'Sunday'
    END AS day_name,
    ROUND(SUM(total), 0) AS total_sales,
    ROUND(AVG(total), 0) AS avg_ticket,
    COUNT(*) AS num_orders
FROM orders
GROUP BY weekday
ORDER BY total_sales DESC;


-- 3.4 Hour × Weekday Heatmap
-- PURPOSE: Detailed pattern analysis for operational planning

SELECT 
    hour,
    ROUND(SUM(CASE WHEN weekday = 1 THEN total ELSE 0 END), 0) AS Monday,
    ROUND(SUM(CASE WHEN weekday = 2 THEN total ELSE 0 END), 0) AS Tuesday,
    ROUND(SUM(CASE WHEN weekday = 3 THEN total ELSE 0 END), 0) AS Wednesday,
    ROUND(SUM(CASE WHEN weekday = 4 THEN total ELSE 0 END), 0) AS Thursday,
    ROUND(SUM(CASE WHEN weekday = 5 THEN total ELSE 0 END), 0) AS Friday,
    ROUND(SUM(CASE WHEN weekday = 6 THEN total ELSE 0 END), 0) AS Saturday,
    ROUND(SUM(CASE WHEN weekday = 7 THEN total ELSE 0 END), 0) AS Sunday
FROM orders
GROUP BY hour
ORDER BY hour;



/* ============================================================
📕 CHAPTER 4: DISCOUNT STRATEGY ANALYSIS
Queries: Promo ROI, discount impact, SXGY vs blanket discounts
============================================================ */

-- 4.1 Discount Impact on Basket Size
-- PURPOSE: Prove discounts don't increase AOV (€41.5 vs €41.0 = 1.2%)

SELECT
	discount_usage,
	round(avg(total), 1) as avg_ticket,
	round(avg(gross_total),1) avg_gross_total,
	round(avg(perc_discount), 1) as avg_perc_discount
FROM orders
GROUP BY discount_usage
ORDER BY discount_usage 

-- Discount-Sales Correlation
-- PURPOSE: Statistical relationship between discount and total

SELECT 
    ROUND(
        (AVG(perc_discount * total) - AVG(perc_discount) * AVG(total)) /
        (STDEV(perc_discount) * STDEV(total))
    , 3) AS corr_discount_sales
FROM orders;


-- 4.2 Promo Performance Comparison
-- PURPOSE: Rank promos by revenue per € discounted (SXGY wins)

SELECT 
    o.first_day_month,
    p.promo,
    COUNT(o.invoice_no) AS orders,
    ROUND(SUM(o.total), 0) AS net_revenue,
    ROUND(SUM(o.discounts_applied), 0) AS discount_cost,
    ROUND(AVG(o.perc_discount), 1) AS avg_discount_pct,
    ROUND(SUM(o.total) / NULLIF(SUM(o.discounts_applied), 0), 2) AS revenue_per_euro_discounted
FROM orders o
LEFT JOIN promos p ON o.first_day_month = p.month
WHERE o.discount_usage = 'Yes'
GROUP BY o.first_day_month, p.promo
ORDER BY promo;


-- 4.3 Summarize performance of each promotion.
-- PURPOSE: Identify which promos generate the highest revenue and customer value.


WITH promo_monthly AS (
      --Compute revenue & avg ticket for each promo in each month.
      --Use LEFT JOIN so months with zero orders still appear (month_revenue = 0).
    SELECT
        p.promo,
        p.month,
        SUM(o.total) AS month_revenue,         -- revenue during that promo month
        COUNT(o.invoice_no) AS month_orders,   -- number of orders in that promo month
        AVG(o.total) AS month_avg_ticket       -- avg order value during that promo month
    FROM promos p
    LEFT JOIN orders o
      ON p.month = o.first_day_month
    GROUP BY p.promo, p.month
)

SELECT
    pm.promo,
    COUNT(*) AS usage_count,                              -- number of months the promo was active
    ROUND(SUM(pm.month_revenue), 0) AS total_revenue,     -- total revenue across all active months
    ROUND(AVG(pm.month_revenue), 0) AS avg_revenue_per_month, -- average monthly revenue (total / usage_count)
    ROUND(AVG(pm.month_avg_ticket), 2) AS avg_ticket_by_month -- simple average of monthly avg tickets
FROM promo_monthly pm
GROUP BY pm.promo
ORDER BY total_revenue DESC;



-- 4.4 Discount Usage by Customer Type
-- PURPOSE: Show both segments equally discount-dependent (59% vs 62%)
SELECT 
    type_of_customer,
    COUNT(*) AS num_orders,
    SUM(CASE WHEN discount_usage = 'Yes' THEN 1 ELSE 0 END) AS orders_with_discount,
    ROUND(CAST(SUM(CASE WHEN discount_usage = 'Yes' THEN 1 ELSE 0 END) AS FLOAT) / COUNT(*) * 100, 1) AS perc_discounted_orders
FROM orders o
LEFT JOIN customers_kpi c ON o.customer_id = c.customer_id
GROUP BY type_of_customer;











