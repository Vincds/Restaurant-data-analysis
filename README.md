# 🍽️ Restaurant Delivery Analytics: End-to-End Portfolio Project
**Complete data pipeline from messy exports to actionable insights**

---

**Created by:** Vincenzo Di Sario  
**Role:** Data Analyst  
**Contact:** [LinkedIn](www.linkedin.com/in/vdisario) | [Email](mailto:vin.disario@gmail.com)

---
## 📊 Project Overview

A well-established Indian restaurant in Barcelona launched delivery operations in 2022 through Last App, a third-party delivery platform. After two years of operation (2023-2024), the business showed modest revenue growth (+5.4%), but the owner had limited visibility into what was driving performance. Last App's native reporting only provided basic sales totals and order counts—no insights into customer behavior, retention patterns, or promotional effectiveness.

This portfolio project demonstrates a complete analytics workflow to transform 4,184 raw delivery orders into actionable business intelligence. The analysis uncovered critical issues: 65% of customers never returned after their first order, new customer acquisition collapsed by 24.7% year-over-year, and excessive discounting (17.6% vs 10-12% industry benchmark) was eroding €11.7K in annual margins without driving basket growth. Despite these challenges, the data revealed clear opportunities—customers who made it past their first order showed 60% likelihood of placing a third, and SXGY threshold promotions (Spend €35, Get €5) outperformed blanket discounts by 3:1 in ROI.

The three-phase approach included: (1) cleaning and anonymizing messy platform exports using Excel, Python, and SQL, (2) conducting exploratory SQL analysis with 19+ queries to surface retention, operational, and discount insights, and (3) building interactive Tableau dashboards for ongoing performance monitoring.

---


## 🗂️ Project Structure

This portfolio consists of three interconnected projects:

### **[Project 1: Data Cleaning & Transformation Pipeline](01_data_cleaning_pipeline/)**
Transformed 4,184 messy delivery orders into analysis-ready datasets.

**Skills:** Excel (anonymization, data quality), Python (regex parsing), SQL (data modeling)  
**Key Output:** Normalized database with `orders` and `customers_kpi` tables  


**[→ View full documentation](01_data_cleaning_pipeline/README.md)**

---

### **[Project 2: Sales Intelligence Analysis](02_sales_intelligence_analysis/)**
Conducted exploratory SQL analysis to uncover retention crisis and discount inefficiencies.

**Skills:** Advanced SQL (window functions, CTEs), business intelligence, data storytelling  
**Key Findings:** 65% first-order churn, €11.7K margin erosion from over-discounting  
**Deliverable:** Strategic recommendations with prioritized ROI

**[→ View full analysis](02_sales_intelligence_analysis/README.md)**

---

### **[Project 3: Interactive Dashboard (Tableau)](03_tableau_dashboard/)**
Built self-service analytics dashboard for ongoing performance monitoring.

**Skills:** Tableau (LOD expressions, parameters), dashboard design, UX  
**Key Features:** Sales trends, customer retention metrics, promotional ROI, geographic analysis  
**Access:** [Live dashboard on Tableau Public](link)

**[→ View documentation](03_tableau_dashboard/README.md)**

---

## 🎯 Key Skills Demonstrated

**Technical Proficiency:**
- SQL (window functions, CTEs, complex joins, conditional aggregation)
- Python (pandas, regex for text parsing)
- Excel (Power Query, data validation, anonymization)
- Tableau (interactive dashboards, LOD expressions)
- Power BI (DAX measures, visual design)

**Business Acumen:**
- KPI design and metric definition
- Root cause analysis (why 65% churn after order 1?)
- Financial modeling (€50K+ opportunity sizing with ROI)
- Strategic recommendation development

**Communication:**
- Data storytelling (problem → insight → action)
- Stakeholder-focused documentation
- Technical documentation for reproducibility

---



## 🚀 How to Explore This Portfolio

**For Hiring Managers (5-minute overview):**
1. Read the [Project 2 Executive Summary](02_sales_intelligence_analysis/README.md#executive-summary)
2. View the [Tableau Dashboard](link) (live interactive)
3. Skim [SQL queries](02_sales_intelligence_analysis/SQL/data_exploration_queries.sql) for technical depth

**For Technical Reviewers:**
1. Start with [Data Cleaning Pipeline](01_data_cleaning_pipeline/) to see data quality handling
2. Review [SQL techniques](02_sales_intelligence_analysis/README.md#sql-techniques-demonstrated)
3. Examine [Tableau data model](03_tableau_dashboard/README.md#data-model-structure)

**For Those With More Time:**
- Read all three project READMEs in sequence
- Explore the [Glossary of Metrics](02_sales_intelligence_analysis/Glossary%20of%20Metrics.md)
- Run SQL queries yourself (requires database setup from Project 1)

---

## 📁 Repository Structure
```
restaurant-delivery-analytics/
│
├── 01_data_cleaning_pipeline/
│   ├── Excel/                    # Anonymization & standardization
│   ├── Python/                   # Text parsing scripts
│   ├── SQL/                      # Data modeling & views
│   └── README.md                 # Full pipeline documentation
│
├── 02_sales_intelligence_analysis/
│   ├── SQL/                      # Exploratory queries
│   ├── Glossary of Metrics.md    # Metric definitions
│   └── README.md                 # Analysis & recommendations
│
├── 03_tableau_dashboard/
│   ├── screenshots/              # Dashboard previews
│   ├── Restaurant_Dashboard.twbx # Tableau workbook
│   └── README.md                 # Dashboard documentation
│
└── README.md                     # ← You are here
```

---

## 🛠️ Technologies Used

![SQL](https://img.shields.io/badge/SQL_Server-CC2927?style=flat&logo=microsoft-sql-server&logoColor=white)
![Python](https://img.shields.io/badge/Python-3776AB?style=flat&logo=python&logoColor=white)
![Tableau](https://img.shields.io/badge/Tableau-E97627?style=flat&logo=tableau&logoColor=white)
![Excel](https://img.shields.io/badge/Excel-217346?style=flat&logo=microsoft-excel&logoColor=white)
![Power BI](https://img.shields.io/badge/Power_BI-F2C811?style=flat&logo=power-bi&logoColor=black)

---

## 📧 Contact

**Vincenzo Di Sario** 
Data Analyst | SQL • Python • Tableau • Power BI

- 💼 [LinkedIn](www.linkedin.com/in/vdisario)
- 📧 [your.email@example.com](mailto:vin.disario@gmail.com)

*Open to data analyst opportunities in Barcelona*

---

## 📝 Notes

**Data Privacy:** All customer data has been anonymized. Sample datasets provided for methodology demonstration only.


**Feedback Welcome:** If you have suggestions or questions about this analysis, feel free to reach out!

---

**Last Updated:** 05/12/2025