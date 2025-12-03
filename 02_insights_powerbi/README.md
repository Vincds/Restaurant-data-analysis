# 📊 Restaurant Sales Intelligence: SQL + Power BI Analysis
**Exploratory Analysis Revealing Critical Retention and Discount Strategy Issues**

---

## 🎯 Project Overview

Conducted comprehensive SQL analysis to uncover insights on sales trends, customer retention, and promotional effectiveness for a Barcelona-based Indian restaurant's delivery operations. Analyzed 24 months of transaction data (4,184 orders, 1,809 customers) from Last App, a delivery platform similar to Uber Eats. Built Power BI performance dashboards to visualize trends across customer lifecycle, operational patterns, and discount performance, delivering actionable recommendations to address a 65% first-order churn crisis and €11.7K in annual margin erosion from over-discounting.

---

## 📍 Client Background

The client is a well-established Indian restaurant in Barcelona, renowned for its authentic cuisine and distinctive ambiance. After years of success as a dine-in destination, the restaurant launched delivery operations in mid-2022 through Last App, a third-party delivery platform that manages order processing and customer data.

**Business Context:**
- **Launch:** Mid-2022 (delivery operations)
- **Analysis Period:** 2023-2024 (first two full years of delivery data)
- **Platform:** Last App (handles order management, customer data, payment processing)
- **Challenge:** Limited analytical capabilities within Last App's native reporting—basic revenue and order counts only, with no visibility into customer behavior, retention patterns, or promotional ROI

This analysis addresses the platform's limitations by transforming raw order exports into a comprehensive business intelligence framework.

---

## 🎯 North Star Metrics

### **Sales Performance & Growth Trends**
Analyzing revenue trajectory, order volume, customer acquisition rates, and average order value to assess business health and identify growth drivers vs. warning signals.

### **Customer Retention & Lifetime Value**
Evaluating first-order retention rates, churn patterns across customer lifecycle stages, and lifetime value gaps between one-time and repeat customers to quantify retention opportunities.

### **Operational Efficiency**
Examining revenue distribution across day-parts (morning/afternoon/night), weekday vs. weekend performance, and seasonal patterns to optimize staffing and promotional timing.

### **Discount Strategy & Promotional Effectiveness**
Assessing promotional ROI across different discount types (percentage-based, BOGO, spend thresholds), measuring impact on basket size and customer behavior, and identifying margin erosion from over-discounting.

---

## 📊 Executive Summary

### **Key Findings**

**The Retention Crisis (Primary Issue)**
- **65% of customers never return after their first order**, representing a critical onboarding failure
- However, customers who make a second order show **60% likelihood of making a third**, indicating the first-order experience is the primary leak
- Repeating customers are worth **4.5x more** than one-timers (€192.86 vs €43.00 lifetime value)
- **85% of the customer base is inactive or sleeping**, requiring immediate intervention

**The Discount Trap (Secondary Issue)**
- Discounts **don't increase basket size**: €41.5 avg ticket with discount vs €41.0 without (1.2% meaningless lift)
- **59% of all orders use discounts**—both new customers (62%) and repeat customers (59%) show identical dependency
- Restaurant is **over-discounting by €11.7K annually** (17.6% rate vs 10-12% industry benchmark)
- **Hidden winner identified:** SXGY promos (Spend €35 Get €5) drive €44-47 average orders with highest adoption rates, outperforming blanket percentage discounts 3:1

**The Acquisition Decline (Emerging Risk)**
- **New customer acquisition dropped 24.7%** (from 1,032 in 2023 to 777 in 2024)
- Revenue growth of +5.4% is **fragile**: driven entirely by €2.10 higher ticket prices, not volume (+4 orders only)
- Revenue mix shifted from 51% new/49% returning (2023) to 36% new/64% returning (2024), creating **future revenue risk** as smaller 2024 cohort matures
- August 2024 crashed -42.5% YoY due to structural seasonality weakness combined with ineffective promotional strategy

 Metric | Value | What It Means |
|--------|-------|---------------|
| **Revenue Growth** | +5.4% YoY | Driven by ticket size (+€2.1), not volume (+4 orders) |
| **First-Order Churn** | 65% | Primary revenue leak—but those who return show 60% retention to order 3 |
| **New Customer Acquisition** | -24.7% YoY | Lost 255 customers in 2024, shrinking future revenue base |
| **Discount Rate** | 17.6% | €11.7K above industry benchmark (10-12%) |
| **Customer Base Health** | 85% inactive/sleeping | Only 15% active/recent—requires immediate intervention |

### **Strategic Recommendations**

**Fix First-Order Retention (Urgent Priority)**
Implement a 30-day automated onboarding program with staged incentives (10-20% off) to convert one-timers into repeat customers. Target: improve retention from 35% to 50%, unlocking €30-40K in annual lifetime value.

**Build a Loyalty Program**
Launch a milestone-based rewards system (e.g., 50% off after 5 orders) to train customers away from discount dependency and toward earning full-price purchase behavior. Replace constant monthly promos with earned rewards.

**Optimize Discount Architecture**
Restructure to a 3-tier model: (1) SXGY promos as permanent fixtures to drive basket growth, (2) 25-30% off for first orders only (acquisition tool, not retention), (3) 2x1 promos deployed tactically on weak days (Wednesdays) and weak seasons (summer) to smooth demand. Eliminate weekend blanket discounts where customers already demonstrate higher willingness to pay.

**Reactivate Dormant Customers**
Launch targeted "We Miss You" campaigns for 255 sleeping customers (60-180 days inactive) with personalized offers referencing their last order, unlocking €7.4K in reactivation potential.

---

## 📖 Analysis Structure

### **Four Core Questions Investigated**

**Chapter 1: Business Health Check**  
*"Is growth real or an illusion?"*  
→ Revenue +5.4%, but volume flat. Growth is ticket-driven, not customer-driven.

**Chapter 2: The Retention Crisis**  
*"Why do 65% of customers never return?"*  
→ Onboarding failure costs €40-50K annually. But survivors show promise.

**Chapter 3: Operational Performance**  
*"Where is the business strongest?"*  
→ Night shift = 47% of revenue. Weekdays drive volume, weekends drive value.

**Chapter 4: Discount Strategy Analysis**  
*"Are promotions helping or hurting?"*  
→ Discounts don't increase spend. SXGY promos outperform blanket discounts 3:1.

---

# 📘 Chapter 1: Business Health Check

## **"Growing Revenue, Shrinking Customer Base"**

### 1.1 Overall Performance (2023-2024)

| Metric | 2-Year Total | 2024 | 2023 | YoY Change |
|--------|--------------|------|------|------------|
| **Net Sales** | €172,703 | €88,609 | €84,093 | +5.4% ✅ |
| **Gross Sales** | €209,511 | €107,252 | €102,259 | +4.9% ✅ |
| **Total Orders** | 4,184 | 2,094 | 2,090 | +0.2% ⚠️ |
| **Unique Customers** | 1,809 | 777 | 1,032 | -24.7% 🔴 |
| **Avg Ticket** | €41.3 | €42.3 | €40.2 | +5.2% ✅ |
| **Discount Rate** | 17.6% | 17.4% | 17.8% | -0.4pp ✅ |

**🔥 Key Finding #1: Fragile Growth Model**

Revenue grew 5.4% but **only 4 additional orders** were placed. Entire growth came from €2.10 higher average ticket, not from more customers or more transactions.

**What This Means:**
- Ticket inflation has limits (price elasticity ceiling)
- No volume growth = no customer base expansion
- One bad quarter could erase all gains
- 2025 revenue at risk if 2024's smaller cohort doesn't mature

**[VIZ: Executive KPI cards showing all metrics with YoY indicators]**

---

### 1.2 Monthly Performance: The August Collapse

**2024 vs 2023 Monthly Trend Overview:**

The year started strong with consistent outperformance through June:
- **Jan-Apr 2024:** Exceptional growth (+32-35% YoY) - strongest period of the entire dataset
- **May-Jun 2024:** Modest gains, staying slightly above 2023 levels
- **July 2024 onwards:** The trend reversed dramatically, with July marking the beginning of sustained underperformance

This shift from consistent growth to decline mid-year signals a fundamental change in business dynamics that requires investigation.

**Best Months:**
- April 2024: €9,687 (+35.3% YoY) ⭐
- March 2024: €8,815 (+34.0% YoY)
- February 2024: €8,136 (+34.7% YoY)
- January 2024: €8,835 (+32.4% YoY)

**Worst Months:**
- August 2024: €3,251 (-42.5% YoY) 🔴
- July 2024: €5,234 (-24.4% YoY)

**[VIZ: Line chart with 2023 vs 2024 monthly sales + reference line at €7.2K avg]**

---
### 1.3 The Revenue Mix Shift

**2023:** 51% new customers / 49% returning (balanced)  
**2024:** 36% new customers / 64% returning (retention-heavy)

**Translation:**
- Lost €10.6K in new customer revenue
- Gained €15.1K in returning customer revenue
- Net gain: +€4.5K (the 5.4% growth)

**The Problem:**  
This looks like retention success but masks an acquisition crisis. Without new customers, the base shrinks in 2025.

**Analogy:** You're keeping current customers happy, but the funnel is drying up. In 12 months, you'll have fewer returning customers from 2024's smaller cohort.

**[VIZ: 100% stacked bar chart showing 2023 vs 2024 revenue composition]**

---
### 1.4 The Acquisition Crisis

| Year | New Customers | Change |
|------|---------------|--------|
| 2023 | 1,032 | - |
| 2024 | 777 | **-24.7%** 🔴 |

**Financial Impact:**
- 255 customers × €43 first order = **€10,965 immediate revenue lost**
- 255 customers × €95.72 avg LTV = **€24,409 lifetime value lost**

**Combined with 35% retention:**
- 2024 acquired 777 customers
- Only 272 will become repeat buyers (35%)
- **505 will churn after first order (65%)**

**The Burning Platform:** Without fixing retention, even strong acquisition only yields 35% efficiency. But acquisition is declining, creating compounding crisis.

---

### 1.5 Margin Pressure

**Discount Rate: 17.6% of gross revenue**
- Total discounts given: €36,808
- Industry benchmark: 10-12%
- **Excess cost: €11,704 annually**

**Positive signal:** Rate improved from 17.8% (2023) to 17.4% (2024), showing restaurant is attempting to reduce dependency. But still 47% above healthy levels.

---

## 🎯 Chapter 1 Takeaways

### ✅ What's Working:
- Revenue grew (+5.4%)
- Avg ticket increased (+€2.1)
- Discount rate improving (-0.4pp)

### 🔴 Critical Issues:
- Order volume flat (+0.2%)
- New customers -24.7%
- August -42.5% YoY
- Excess discounting €11.7K

### 💰 Opportunity:
- Fix August: **€2.4K/year**
- Reduce discount rate to 12%: **€11.7K/year**

---

# 📗 Chapter 2: The Retention Crisis

## **"65% Never Return—But Survivors Show Promise"**

### 2.1 The Retention Disaster

| Metric | Value | Benchmark | Gap |
|--------|-------|-----------|-----|
| **Retention Rate** | 35% | 60-70% | -30pp 🔴 |
| **One-Timers** | 1,170 (65%) | 30-40% | +25pp 🔴 |
| **Avg Lifetime** | 2.82 months | 12-18 months | -10 months |
| **Avg Orders per Customer** | 2.32 | 5-7 | -3 orders |

*Benchmarks: Food delivery industry (DoorDash, Uber Eats studies)*

---

### 2.2 The Churn Cascade

**🔥 Key Finding #5: The First-Order Cliff**

| Order # | Customers | % of Base | Drop from Previous |
|---------|-----------|-----------|-------------------|
| **1** | 1,805 | 100% | - |
| **2** | 635 | 35% | **-65%** 🔴 |
| **3** | 378 | 21% | **-40%** |
| **4-5** | 437 | 24% | -15-25% (stabilizing) |
| **6+** | 353 | 20% | Loyal base |

**The Story:**
1. **65% never return after first order** (the onboarding cliff)
2. **Of the 35% who return, 60% make order 3** (positive signal!)
3. **After order 3, retention stabilizes** (15-25% churn per order)

**Critical Insight:**  
First cliff (65%) is the killer. But customers who cross it are worth targeting—60% make order 3. **Focus: convert one-timers → two-timers.**

**[VIZ: Funnel chart showing 1,805 → 635 → 378 → 146 with drop percentages]**

---

### 2.3 The €30-35K Opportunity

**Lifetime Value Analysis:**

| Segment | Customers | Avg LTV | Avg Orders |
|---------|-----------|---------|------------|
| **One-Timer** | 1,170 (65%) | €43.00 | 1.00 |
| **Repeating** | 639 (35%) | €192.86 | 4.75 |

**Repeating customers worth 4.5x more.**

---

**Realistic Improvement Scenario:**

**Target Improvements (achievable with loyalty program):**
- Retention rate: 35% → **45%** (+10pp)
- Orders per customer: 2.32 → **3.5** (+1.18 orders)

**Financial Impact:**

Based on 777 annual new customers:

**Retention Improvement:**
- Current: 777 × 35% = 272 repeat customers
- Target: 777 × 45% = 350 repeat customers
- **78 additional repeat customers** × €192.86 LTV = **€15,043**

**Frequency Improvement (existing repeat customers):**
- 272 customers × 1.18 additional orders × €41.3 avg ticket = **€13,257**

**Total Annual Opportunity: €28,300**

**Implementation:** Launch milestone-based loyalty program (e.g., 50% off after 5 orders) to drive both retention and frequency improvements.


---



### 2.4 The Discount Trap

**🔥 Key Finding #7: Discounts Don't Create Loyalty**

| Customer Type | Total Orders | % Using Discount |
|---------------|--------------|------------------|
| **One-Timers** | 1,170 | 62% |
| **Repeating** | 3,014 | 59% |
| **Difference** | - | **3pp** (meaningless) |

**What This Proves:**
- Discounts attract first-time customers (62% use them)
- But don't reduce dependency for repeaters (59% still use)
- **We've trained customers to wait for discounts**

**The Loyalty Paradox:**  
We hoped: "Discount → trial → love food → return at full price"  
Reality: "Discount → trial → love food → **wait for next discount**"

---

### 2.5 Customer Base Health

**Retention Status (as of Dec 2024):**

| Status | Customers | % | Days Inactive |
|--------|-----------|---|---------------|
| **Active** | 146 | 8.1% | <30 |
| **Recent** | 126 | 7.0% | 30-60 |
| **Sleeping** | 255 | 14.1% | 60-180 |
| **Inactive** | 1,282 | 70.9% | >180 |

**85% of customers require intervention.** Only 15% are active/recent.

---

**Reactivation Opportunity (5% Target):**

**Sleeping + Inactive Customers:**
- Total dormant: 1,537 customers (255 sleeping + 1,282 inactive)
- 5% reactivation rate: **77 customers**
- 77 × €95.72 avg LTV = **€7,370 potential**

**Strategy:** Personalized "we miss you" campaigns with time-limited offers (15-25% off).

---

## 🎯 Chapter 2 Takeaways

### ✅ What We Know:
- 65% churn after order 1 (onboarding failure)
- 60% who make order 2 make order 3 (positive signal)
- Repeating customers 4.5x more valuable
- 85% of base needs reactivation

### 🔴 Critical Issues:
- First-order experience fails 2/3 customers
- Discounts create dependency, not loyalty
- Customer lifetime only 2.8 months (should be 12-18)

### 💰 Opportunity:
**Total: €25-35K annually**

---

# 📙 Chapter 3: Operational Performance

## **"Night Shift = 47%, Weekdays Drive Volume"**

### 3.1 Revenue by Time of Day

| Shift | Sales | % | Avg Ticket | Orders |
|-------|-------|---|------------|--------|
| **Night (8PM+)** | €80,694 | 46.7% | €39.75 | 2,030 |
| **Afternoon** | €43,043 | 24.9% | €43.74 ⭐ | 984 |
| **Morning** | €48,965 | 28.4% | €41.85 | 1,170 |

**🔥 Key Finding #9:** Night shift is core business (47% of revenue). Afternoon has highest avg ticket (€43.74) = premium ordering window.


---
### 3.2 Day-of-Week Analysis

**Best Performing Days:**
- **Sunday:** Highest revenue (€34,387) and avg ticket (€42) - strongest single day
- **Friday:** Second highest revenue (€29,901), peak dinner demand
- **Saturday:** Strong weekend performance (€26,577)

**Weakest Performing Days:**
- **Wednesday:** Lowest revenue (€19,701) and avg ticket (€40) 🔴
- **Tuesday:** Second weakest (€19,995), tied with Wednesday for mid-week slump
- **Thursday:** Third weakest (€19,794), just below Tuesday

**Strategic Implication:**  
Mid-week (Tuesday-Thursday) shows consistent underperformance with ~€20K revenue vs ~€30K on peak days. **Wednesday represents the clearest opportunity** for tactical promotions (e.g., 2x1 offers) to smooth weekly demand and boost the weakest day by 30-40%, potentially adding €6-8K in weekly revenue.

**[VIZ: Bar chart showing revenue by day of week with Wednesday highlighted as tactical promo opportunity]**
---

### 3.3 Weekday vs Weekend

| Day Type | Sales | % | Avg Ticket | Discount Rate |
|----------|-------|---|------------|---------------|
| **Weekday** | €111,738 | 64.7% | €40.50 | 16.17% |
| **Weekend** | €60,964 | 35.3% | €42.78 | 16.31% |

**🔥 Key Finding #10:** Weekdays drive volume (65%), weekends drive value (+5.6% higher ticket).

**Strategic Insight:**  
Weekend customers willing to pay more BUT discount usage identical (16.3% vs 16.17%). **Missed opportunity to reduce weekend promos.**

**Hypothesis:** Reduce weekend discounts 16% → 10% without losing volume (test recommended).

**[VIZ: Clustered column chart comparing weekday vs weekend metrics]**

---

### 3.3 Seasonality

**Strong:** Oct-May (except Christmas week)  
**Weak:** June-August (summer)

**Insight:** Accept summer decline as structural. Maximize Q1 & Q4 with aggressive acquisition campaigns.

---

## 🎯 Chapter 3 Takeaways

### ✅ Operational Strengths:
- Night shift = 47% of revenue (dinner is core business)
- Weekdays = 65% of total revenue (volume driver)
- Weekend avg ticket +5.6% higher (€42.78 vs €40.50)
- Sunday is strongest single day (€34.4K, highest AOV €42)
- Friday delivers peak volume (€29.9K, strong dinner demand)

---

# 📕 Chapter 4: Discount Strategy Analysis

## **"SXGY Promos Outperform 3:1, Blanket Discounts Fail"**

### 4.1 The Discount Problem

| Metric | Value |
|--------|-------|
| **Orders with discount** | 2,488 (59%) |
| **Avg ticket WITH discount** | €41.5 |
| **Avg ticket WITHOUT discount** | €41.0 |
| **Difference** | €0.5 (1.2%) |

**🔥 Key Finding #11: Discounts Don't Increase Basket Size**

1.2% lift is meaningless. Discounts are pure margin erosion with no behavioral change.

**Industry Context:**
- Healthy rate: 10-12%
- This restaurant: 17.6%
- **Excess cost: €11,704 annually**

---

### 4.2 Promo Performance

**🔥 Key Finding #12: SXGY Promos Are Hidden Winners**

| Promo | Monthly Avg | AOV | Discount % | Revenue/€ Discounted |
|-------|-------------|-----|------------|---------------------|
| **S35G5** | €4,542 | €44.1 | 14% | **€6.3** ⭐⭐⭐ |
| **S40G10** | €5,991 | €46.8 | 18% | **€4.6** ⭐⭐ |
| **25% OFF** | €2,524 | €47.9 | 15% | €5.5 |
| **20% OFF** | €4,596 | €44.6 | 19% | €4.3 |
| **2x1** | €4,926 | €38.7 | 33% | €2.0 |
| **30% OFF** | €5,034 | €42.9 | 25% | €3.0 |
| **Free Delivery** | €480 | €28.3 | 34% | €1.9 🔴 |

**Why SXGY Wins:**
- **S35G5:** Customers spend €44 (€9 above €35 threshold!) with 75.7% adoption
- **S40G10:** Customers spend €46.8 (€6.8 above €40 threshold!) with 73.6% adoption
- Creates upselling motivation (add items to hit threshold)
- Rewards high spenders vs blanket discounts

**The 2x1 Paradox:**
- Most used (9 months), highest volume (€4.9K avg)
- But: Lowest AOV (€38.7), highest discount % (33%), worst ROI (€2.0)
- **Strategic use:** Volume driver for weak days/seasons, NOT margin optimizer

**[VIZ: Table with promo performance ranked by Revenue/€ Discounted]**

---

### 4.3 Discount Dependency

**🔥 Key Finding #13: Both Segments Are Discount Addicts**

One-timers: 62% use discounts  
Repeating: 59% use discounts  
**Difference: 3pp (meaningless)**

We've trained customers to never pay full price.

---

### 4.4 Strategic Promo Framework

**🏆 Tier 1: SXGY (Permanent)**
- Why: Increases AOV naturally (€44-47 vs €41)
- When: Always available
- Goal: Reward high spenders, drive basket growth

**🎯 Tier 2: 25-30% OFF (Acquisition Only)**
- Why: Attracts first-timers (62% use discounts)
- When: First order only
- Goal: Lower CAC, build trial base

**📊 Tier 3: 2x1 (Tactical)**
- Why: Proven volume booster
- When: Weak days (Wednesday) or weak seasons (May-Aug)
- Goal: Smooth demand, maintain kitchen utilization

**❌ Avoid: 35% OFF, Free Delivery**
- Free delivery failed (August: €480 total)
- 35% OFF: No proven advantage over 30%

---

## 🎯 Chapter 4 Takeaways

### ✅ What Works:
- SXGY promos (€44-47 AOV, best ROI)
- 2x1 for tactical volume (when needed)

### 🔴 What Fails:
- 59% discount usage (too high)
- Discounts don't increase spend (1.2% lift)
- Over-discounting by €11.7K

### 💰 Opportunity:
- Make SXGY permanent: **€8-10K**
- Reduce rate 17.6% → 12%: **€11.7K**
- Eliminate weekend blanket promos: **€2-3K**

**Total: €22-25K annually**

---

# 🎯 Strategic Recommendations

## **Priority-Ranked Action Plan**

### 🔴 **Priority 1: Fix First-Order Retention (URGENT)**

**Problem:** 65% never return = €40-50K opportunity

**Solution:** 30-Day Onboarding Program
- Day 3: Feedback survey + €50 prize entry
- Day 7: 10% off second order (7-day expiration)
- Day 14: Menu discovery email + 15% off
- Day 30: Final 20% off "last chance"

**Expected Results:**
- Improve 35% → 50% retention (+15pp)
- 117 additional repeat buyers × €149.86 = **€17,534 value**

**Investment:** €7,412 (email automation + discount cost)  
**Net Gain:** **€10,122 (58% ROI)**

---

### 🟡 **Priority 2: Restructure Discount Strategy (HIGH IMPACT)**

**Problem:** 17.6% rate vs 10-12% benchmark = €11.7K excess

**Solution:** 3-Tier Architecture
1. **SXGY permanent** (always on)
2. **25-30% first order only** (acquisition tool)
3. **2x1 tactical** (weak days/seasons)

**Eliminate:** Weekend blanket promos, 35% OFF, Free Delivery

**Expected Results:**
- Reduce rate 17.6% → 13% = **€9,614 margin recapture**
- SXGY drives +€3-5 AOV = **€8,000 incremental**

**Investment:** €0 (promo restructuring)  
**Net Gain:** **€17,614**

---

### 🟢 **Priority 3: Reactivate Sleeping Customers**

**Problem:** 255 sleeping customers = €7.4K opportunity

**Solution:** "We Miss You" Campaign
- Segmented: 60-90d (40% conversion) vs 91-180d (20%)
- Personalized: Reference last order
- Offer: 15% off (14-day expiration)

**Expected Results:** €6,796 in reactivated LTV

**Investment:** €5,844 (email + discount)  
**Net Gain:** **€952**

---

### 🟠 **Priority 4: Fix August Seasonality (STRATEGIC)**

**Problem:** August -42.5% YoY

**Solution:** "Barcelona Locals" Summer Campaign
- Target: 150 city-center customers
- Offer: 20% off + free drink in August
- Theme: "Beat the heat"

**Expected Results:** €4,428 vs €3,251 baseline = +€1,177

**Investment:** €1,377  
**Net Gain:** **Break-even** (strategic value: operational stability)

---

### 🔵 **Priority 5: Weekend Discount Test (LOW-RISK)**

**Problem:** Weekend +5.6% higher ticket but same discount usage

**Solution:** A/B Test
- Control: Current promo
- Test: SXGY only (no blanket discount)
- Duration: 60 days

**Expected Results (if successful):** €3,841 margin gain

**Investment:** €0  
**Risk:** Low (revert if fails)

---

## 📊 Total Financial Impact

| Initiative | Annual Value | Investment | Net Gain | Priority |
|------------|--------------|------------|----------|----------|
| **Fix retention** | €17.5K | €7.4K | **€10.1K** | 🔴 |
| **Restructure discounts** | €17.6K | €0 | **€17.6K** | 🟡 |
| **Reactivate sleeping** | €6.8K | €5.8K | **€1.0K** | 🟢 |
| **SXGY optimization** | €8-10K | €0 | **€9K** | 🟡 |
| **Fix August** | €4.4K | €4.6K | **-€0.2K** | 🟠 |
| **Weekend test** | €3.8K | €0 | **€3.8K** | 🔵 |
| **TOTAL** | **€58K** | **€18K** | **€40K** | - |

**Recommended Focus:** Priorities 1 & 2 = 75% of value (€27.7K) with lowest complexity.

---

# 📚 Technical Appendix

## SQL Techniques Demonstrated

**Window Functions:**
```sql
-- Churn cascade analysis
ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY order_date)

-- YoY comparison
LAG(revenue) OVER (ORDER BY month)
```

**CTEs:**
```sql
WITH customer_orders AS (...),
     retention_funnel AS (...)
SELECT ...
```

**Conditional Aggregation:**
```sql
SUM(CASE WHEN customer_type = 'New' THEN total ELSE 0 END)
```

**Complex Joins:**
```sql
FROM orders o
LEFT JOIN customers_kpi c ON o.customer_id = c.customer_id
LEFT JOIN promos p ON o.month = p.month
```

---

## Power BI Design Standards

**Dashboard Structure:**
1. Executive Overview (KPIs + key visuals)
2. Customer Intelligence (retention deep-dive)
3. Discount Analysis (promo performance)
4. Operations (shift/day patterns)

**Visual Types:**
- Card visuals with YoY indicators
- Funnel charts for conversion
- Line charts for trends
- Tables with conditional formatting
- Donut charts for composition

**Color Palette:**
- Success: Green (#0A8754)
- Warning: Yellow (#F5A623)
- Danger: Red (#D0021B)
- Primary: Blue (#4A90E2)

---

## Data Limitations

**Known Issues:**
- 12.5% revenue reconciliation gap (product text truncation)
- ~2% of large orders affected by Excel cell limits
- Acceptable for exploratory analysis, not financial reporting

**Assumptions:**
- Customer ID = phone number (no native ID in platform)
- Retention periods: Active <30d, Recent <60d, Sleeping <180d
- LTV = sum of all orders (no time discounting)

**Analysis Scope:**
- Date range: 2023-01-01 to 2024-12-31 (24 months)
- Orders: 4,184 transactions
- Customers: 1,809 unique
- Revenue: €172,703 net (€209,511 gross)

---

## Project Context

**This is Part 2 of a 3-project portfolio:**

**Part 1:** [Data Cleaning Pipeline](../01_data_cleaning_pipeline/)  
- Cleaned 4,184 orders, anonymized 1,805 customers
- Python regex parsing, SQL modeling

**Part 2:** [SQL + Power BI Insights](../02_sql_powerbi_insights/) ← **This Project**  
- Exploratory analysis, business recommendations
- Advanced SQL, Power BI specifications

**Part 3:** [Tableau Dashboard](../03_tableau_dashboard/)  
- Self-service analytics, interactive filtering
- Geographic analysis, time-series

---

## Skills Demonstrated

**SQL Proficiency:**
- Window functions (LAG, ROW_NUMBER)
- CTEs for multi-level aggregation
- Conditional aggregation
- Complex joins

**Business Intelligence:**
- KPI design and metric definition
- Dashboard UX and hierarchy
- DAX measure creation

**Analytical Thinking:**
- Root cause analysis
- Comparative analysis (promo evaluation)
- Trend identification
- Hypothesis generation

**Data Storytelling:**
- Problem → Analysis → Insight → Action
- Stakeholder communication
- Financial modeling (ROI calculation)

---

## 🛠️ Tech Stack

![SQL Server](https://img.shields.io/badge/SQL_Server-CC2927?style=flat&logo=microsoft-sql-server&logoColor=white)
![Power BI](https://img.shields.io/badge/Power_BI-F2C811?style=flat&logo=power-bi&logoColor=black)
![Python](https://img.shields.io/badge/Python-3776AB?style=flat&logo=python&logoColor=white)
![Excel](https://img.shields.io/badge/Excel-217346?style=flat&logo=microsoft-excel&logoColor=white)

---

**Next in Series:**  
→ [Project 3: Tableau Interactive Dashboard](../03_tableau_dashboard/)

---

**End of Document**