# 📊 Restaurant Sales & Customer Intelligence Dashboard (Tableau)

An interactive Tableau dashboard designed to help a restaurant operating through a food-delivery platform understand its sales performance, promotion effectiveness, and customer behavior.

Users can switch seamlessly between **Sales View** and **Customer View** using a built-in navigation button.

This dashboard is the third component of a larger analytics pipeline:
- **Data Cleaning & Structuring** (Excel + Python + SQL) – documented in Project 1
- **Insight Storytelling with SQL + Power BI** – documented in Project 2
- **Interactive BI Dashboard (Tableau)** – this project

The focus here is on visual design, business understanding, and stakeholder-friendly analytics.

---

## 📦 1. Project Background

The restaurant uses the delivery platform **Last App** to manage all online orders.

Management needed a dashboard capable of answering key operational questions:
- How are sales and orders evolving over time?
- Which hours and weekdays drive performance?
- Are promotions profitable or cannibalizing revenue?
- How do customer segments behave (new vs returning)?
- What is the retention level and lifetime value of customers?
- Which neighborhoods generate the highest sales?

All data displayed in the dashboard comes from modeled SQL Server views:
- `orders` → enriched fact table
- `customers_kpi` → aggregated customer metrics

These views were created in the preparation pipeline and consumed directly by Tableau.

---

## 🛠 2. Data Pipeline Summary 

- Raw data exported from Last App (one row per order)
- Cleaned and anonymized in Excel
- Product text parsed into structured tables using Python
- Modeled into analytical views using SQL Server
- Tableau reads directly from the processed SQL tables

Full preparation steps are documented in **01_data_cleaning_pipeline** project of this portfolio.

---

## 📊 3. Dashboard Overview

The dashboard is fully interactive and structured into two analytical views:

### 🔵 Sales View
Focuses on operational revenue performance, promo effectiveness, and product behavior.

### 🟢 Customer View
Focuses on customer acquisition, retention, repeat behavior, and geographic insights.

Users switch between views with a navigation button, maintaining a clean, single-dashboard experience.

**Screenshots:**

[Sales View].(screenshots/sales_view.png) 
[Customers View].(screenshots/customer_view.png) 


---

## ❓ 4. Key Business Questions Answered

### 🔵 Sales Analytics
- How much revenue, orders, and discount volume does the restaurant generate monthly?
- What are the highest-performing hours, weekdays, and shifts?
- Does discount usage correlate with higher ticket size or lower margin?
- How do monthly promotions perform?
- Which products contribute most to overall sales?
- How is order value distributed among customers?

### 🟢 Customer Analytics
- What percentage of customers return after their first purchase?
- How much does an average customer spend across their lifetime?
- How many orders do customers typically place before dropping off?
- What is the retention distribution (active / recent / sleeping / inactive)?
- Which neighborhoods generate the highest sales volume?
- How many new customers are acquired each month and how fast is the customer base growing?

---

## 📈 5. Metrics & Visuals Included

### KPI Cards (Sales View)
- Total Sales
- Total Orders
- Average Ticket
- Total Discount (%)

### Sales Visuals
- **Line chart:** monthly trends (selectable metric: sales, orders, avg ticket, avg discount)
- **Heatmap:** weekday × hour/shift (same metric selector)
- **Histogram:** order value distribution (5€ bins)
- **Promo performance table:** usage, revenue, avg ticket, avg monthly revenue, avg discount, avg orders
- **Product ranking table:** category, revenue, quantity, % of total

---

### KPI Cards (Customer View)
- Total Customers
- Retention Rate (repeating customers %)
- Lifetime Value (avg total spent per customer)
- Avg Orders per Customer
- Avg Customer Lifetime (months)

### Customer Visuals
- **100% stacked column:** new vs repeating customers per month
- **Area + line combo:** new customers per month + cumulative customer base
- **Histogram:** repeat purchase distribution (1–6 orders)
- **Bar chart:** retention status distribution
- **Map:** sales by neighborhood

---

## 🎨 6. Dashboard Features & UX Decisions

- Navigation button to switch between Sales ↔ Customer view while keeping one dashboard
- Metric selector to avoid duplicating charts
- Clean color palette: blue for sales, green for customers
- Filters grouped on the left to free visual space
- Tooltips designed for quick operational insight
- All charts optimized for non-technical stakeholders (restaurant owner / manager)

---

## 🔗 7. How to Use the Dashboard

👉 **Open the dashboard on Tableau Public:**  
https://public.tableau.com/app/profile/vincenzo.di.sario/viz/RestaurantShopDashboard/CustomersDashboard

### Instructions:
1. Select a date range using the filter
2. Choose the desired metric in sales charts
3. Switch between Sales and Customer view using the button
4. Hover over any visual for detailed tooltips
5. Use filters to explore promotional periods, customer types, or neighborhoods
