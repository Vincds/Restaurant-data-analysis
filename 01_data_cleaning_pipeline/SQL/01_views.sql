USE [restaurant_shop]

/*
ORDERS VIEW
Purpose:
Transforms raw order data into a curated dataset with temporal, geographic, and behavioral features.

Business Value:
- Distinguishes new vs. returning customers for acquisition analysis.
- Enables time-pattern insights (e.g. best days/hours for sales).
- Provides geographic segmentation for performance tracking.
- Supports discount effectiveness and margin analysis.
- Establishes the foundation for customer lifetime value (CLV) metrics.
- Simplifies monthly and daily operational performance analysis.

Features and Metrics Added:
1. Customer Identification
   - customer_id: Unique customer identifier.
   - new_customer: Flag ('Yes'/'No') showing if it’s the customer’s first purchase.

2. Temporal Features
   - order_date: Date portion of order timestamp.
   - first_day_month: Normalized date (first of the month) for monthly grouping in order to create a column to join promos table
   - year, month, weekday, hour: Time components for trend analysis.
   - day_type: Weekday/Weekend classification.
   - shift: Business period segmentation ('Morning', 'Afternoon', 'Night').

3. Geographic Context
   - zip_code: Customer location identifier.
   - neighborhood: Area name retrieved from zip_code reference table.

4. Financial Metrics
   - gross_total: Total amount including discounts.
   - total: Net order value (after discounts).
   - discounts_applied: Absolute discount value.
   - perc_discount: Discount percentage of gross total.
   - discount_usage: Flag ('Yes'/'No') for discount application.
   - refunded_amount: Refunded order amount (NULL if 0).
   - delivery_fee: Delivery or shipping cost.
*/

DROP VIEW IF EXISTS orders;
GO

CREATE VIEW orders AS

/*
    CTE: min_order_date
    Retrieves the first recorded order date per customer.
    When joined to the main order dataset, it allows accurate identification of first-time buyers.
    This method ensures better precision than simple aggregate counts, especially for multi-order customers within the same month.
*/
WITH min_order_date AS (
    SELECT 
        customer_id, 
        MIN(CAST(Activation_time AS DATE)) AS first_order_date
    FROM dbo.transaction_orders
    GROUP BY customer_id
)

SELECT 
    o.customer_id,
    invoice_nº AS invoice_no,
	CAST(Activation_time AS DATE) AS order_date,

	-- Normalized first day of each month for monthly joins and aggregation.
	DATEFROMPARTS(YEAR(Activation_time), MONTH(Activation_time), 1) AS first_day_month,
	
    -- Identifies if the order is the customer’s first purchase.
    CASE 
        WHEN CAST(Activation_time AS DATE) = first_order_date THEN 'Yes'
        ELSE 'No'
    END AS new_customer,

    -- Temporal breakdown for trend and seasonality analysis.
    DATEPART(YEAR, Activation_time) AS year,
    DATEPART(MONTH, Activation_time) AS month,
    DATEPART(WEEKDAY, Activation_time) AS weekday,
	CASE	
		WHEN DATEPART(WEEKDAY, Activation_time) IN (6, 7) THEN 'Weekend'
		ELSE 'Weekday'
	END AS day_type,
    DATEPART(HOUR, Activation_time) AS hour,
    CASE 
        WHEN DATEPART(HOUR, Activation_time) < 16 THEN 'Morning'
        WHEN DATEPART(HOUR, Activation_time) < 20 THEN 'Afternoon'
        ELSE 'Night'
    END AS shift,

    -- Geographic context.
    o.Zip_Code AS zip_code,
    z.neighborhood AS neighborhood,

	-- Financial metrics.
    ROUND((Total + Discounts_applied)/100, 2) AS gross_total,
    ROUND(Total / 100, 2) AS total,
    ROUND(Discounts_applied / 100, 2) AS discounts_applied,

    -- Discount percentage (avoids division by zero).
    ROUND(
        COALESCE(
            NULLIF(Discounts_applied/100, 0) /
            NULLIF((Total + Discounts_applied)/100, 0) * 100, 
        0), 
    2) AS perc_discount,

    -- Discount usage indicator.
    CASE 
        WHEN Discounts_applied > 0 THEN 'Yes'
        ELSE 'No'
    END AS discount_usage,

    NULLIF(Refunded_amount/100, 0) AS refunded_amount,
    ROUND(Delivery_fee / 100, 2) AS delivery_fee

FROM dbo.transaction_orders o
LEFT JOIN min_order_date m
    ON m.customer_id = o.customer_id
LEFT JOIN dbo.zip_code z
    ON o.Zip_code = z.zip_code;




/*
CUSTOMERS_KPI VIEW
Purpose:
Aggregates customer-level KPIs to evaluate purchasing behavior and engagement during 2023–2024.

Business Value:
- Distinguishes customer segments (one-timers vs. repeat buyers).
- Tracks engagement and retention across time.
- Reveals spending and discount patterns by customer.
- Supports lifetime value and churn risk analysis.

Metrics and Dimensions:
1. Customer Profile
   - customer_id: Unique identifier.
   - customer_name: Name of the customer.

2. Order Patterns  
   - num_orders: Total number of orders placed.
   - type_of_customer: 'One-Timer' or 'Repeating' based on number of orders.
   - first_order_date / last_order_date: Range of customer activity.

3. Engagement Metrics
   - retention_status: Activity classification ('Active', 'Recent', 'Sleeping', 'Inactive').
   - customer_lifetime_months: Months between first and last order.
   - active_frequency: Average orders per active month.
   - lifetime_frequency: Orders per month since first order (historical view).

4. Financial KPIs
   - total_spent: Total lifetime spend.
   - avg_order_value: Average order value (AOV).
   - spending_range: (optional bucket for segmentation).

5. Discount Behavior
   - total_discount: Total value of discounts received.
   - perc_discount: Discount % of total spend.
   - num_discounted_orders: Count of orders with discount.
   - perc_discounted_orders: Share of orders using discount.
*/

DROP VIEW IF EXISTS customers_kpi;
GO

CREATE OR ALTER VIEW customers_kpi AS

WITH analysis_period AS (
    SELECT 
        o.customer_id,
        COALESCE(c.customer_name, 'Unknown') AS customer_name,
        COUNT(o.customer_id) AS num_orders,
        MIN(order_date) AS first_order_date,
        MAX(order_date) AS last_order_date,
        SUM(total) AS total_spent_raw,
        SUM(discounts_applied) AS total_discount_raw,
        SUM(CASE WHEN discount_usage = 'Yes' THEN 1 ELSE 0 END) AS num_discounted_orders
    FROM orders o
    LEFT JOIN dbo.customers c
        ON o.Customer_Id = c.Customer_Id
    WHERE order_date BETWEEN '2023-01-01' AND '2024-12-31'
    GROUP BY o.customer_id, c.customer_name
)

SELECT 
    customer_id,
    customer_name,
    num_orders,

    CASE 
        WHEN num_orders = 1 THEN 'One-Timer'
        ELSE 'Repeating'
    END AS type_of_customer,

    first_order_date,
    last_order_date,

    -- Classifies retention status based on recency relative to end of 2024.
    CASE 
        WHEN DATEDIFF(DAY, last_order_date, '2024-12-31') <= 30 THEN 'Active'
        WHEN DATEDIFF(DAY, last_order_date, '2024-12-31') <= 60 THEN 'Recent'
        WHEN DATEDIFF(DAY, last_order_date, '2024-12-31') <= 180 THEN 'Sleeping'
        ELSE 'Inactive'
    END AS retention_status,

    -- Customer lifetime in months (duration between first and last purchase).
    ROUND(CAST(DATEDIFF(DAY, first_order_date, last_order_date) AS FLOAT) / 30, 1) AS customer_lifetime_months,

    -- Orders per active month (between first and last order).
    ROUND(
        num_orders / NULLIF(
            ROUND(CAST(DATEDIFF(DAY, first_order_date, last_order_date) AS FLOAT) / 30, 1),
        0),
    1) AS active_frequency,

    -- Spending KPIs.
    ROUND(CAST(total_spent_raw AS FLOAT), 0) AS total_spent,
    ROUND(CAST(total_discount_raw AS FLOAT), 0) AS total_discount,
    ROUND(NULLIF(CAST(total_spent_raw AS FLOAT), 0) / num_orders, 0) AS avg_order_value,

    -- Discount percentage relative to gross spending.
    COALESCE(
        ROUND(
            NULLIF(CAST(total_discount_raw AS FLOAT), 0) /
            (CAST(total_discount_raw + total_spent_raw AS FLOAT)) * 100,
        0), 0
    ) AS perc_discount,

    -- Discount adoption rate.
    num_discounted_orders,
    ROUND(num_discounted_orders / CAST(num_orders AS FLOAT) * 100, 0) AS perc_discounted_orders

FROM analysis_period;
