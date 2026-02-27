# E-commerce Sales Funnel Analysis

**SQL analysis of user conversion behavior across the purchase journey**

## 📊 Project Overview

This project analyzes e-commerce user behavior to identify conversion bottlenecks and optimize the purchase funnel. Using BigQuery SQL, I tracked users across 5 stages from initial page view to completed purchase.

## 💡 Business Questions Answered

- What is the overall conversion rate from visitor to buyer?
- Where do users drop off most in the funnel?  
- Which marketing channels perform best?
- How long does the average purchase journey take?
- What is our average order value and revenue per visitor?

## 🔍 Analysis Structure

### 1. **Funnel Stage Definition**
Defined 5 key stages in the user journey:
- Stage 1: Page View
- Stage 2: Add to Cart
- Stage 3: Checkout Start
- Stage 4: Payment Info Entered
- Stage 5: Purchase Complete

### 2. **Conversion Rate Analysis**
Calculated conversion rates between each stage:
- View → Cart conversion
- Cart → Checkout conversion
- Checkout → Payment conversion
- Payment → Purchase conversion
- Overall view → Purchase conversion

### 3. **Traffic Source Analysis**
Compared performance across marketing channels:
- Analyzed views, carts, and purchases by traffic source
- Calculated conversion rates per channel
- Identified best-performing acquisition channels

### 4. **Time-to-Conversion Analysis**
Measured user journey duration:
- Time from first view to cart add
- Time from cart to purchase
- Total journey length from first view to purchase

### 5. **Revenue Metrics**
Computed key business metrics:
- Total revenue in analysis period
- Average Order Value (AOV)
- Revenue per buyer
- Revenue per visitor

## 🛠️ Technical Skills Demonstrated

- **BigQuery SQL** - Cloud data warehouse querying
- **Common Table Expressions (CTEs)** - Query organization and readability
- **Window Functions** - Time-based analysis using MIN, TIMESTAMP_DIFF
- **Conditional Aggregations** - CASE statements with COUNT DISTINCT
- **Date Filtering** - Rolling 30-day window analysis
- **Percentage Calculations** - Conversion rate computation
- **JOIN Operations** - Combining user events across stages

## 📈 Key SQL Techniques Used

### CTEs for Query Organization
```sql
WITH funnel_stages AS (
  SELECT 
    COUNT(DISTINCT CASE WHEN event_type='page_view' THEN user_id END) AS stage1_views,
    COUNT(DISTINCT CASE WHEN event_type='purchase' THEN user_id END) AS stage5_purchase
  FROM user_events
  WHERE event_date >= TIMESTAMP(DATE_SUB(CURRENT_DATE(), INTERVAL 30 DAY))
)
```

### Conditional Aggregations
```sql
COUNT(DISTINCT CASE WHEN event_type='page_view' THEN user_id END) AS views
```

### Time-Based Window Functions
```sql
MIN(CASE WHEN event_type='page_view' THEN event_date END) AS view_time,
TIMESTAMP_DIFF(purchase_time, view_time, MINUTE) AS journey_minutes
```

### Conversion Rate Calculations
```sql
ROUND(stage2_cart * 100 / stage1_views) AS view_to_cart_rate
```

## 📁 Files

- `ecommerce_funnel_analysis.sql` - Complete SQL analysis with comments

## 🎯 Potential Business Actions

Based on this analysis structure, businesses could:
- Identify and fix the stage with highest drop-off
- Allocate marketing budget to best-performing channels
- Optimize user experience for stages with low conversion
- Set benchmarks for average purchase journey time
- Calculate customer acquisition cost vs. revenue metrics

## 🎓 Learning Context

This project was completed as part of my data analytics learning journey. I followed a structured tutorial to understand funnel analysis methodology, then documented and explained each component to demonstrate comprehension. This represents practical SQL skills applicable to real-world e-commerce analytics.

## 🚀 Skills Applied

**SQL Concepts:**
- Subqueries and CTEs
- Aggregate functions (COUNT, SUM, AVG, ROUND)
- Conditional logic (CASE statements)
- Window functions (MIN, TIMESTAMP_DIFF)
- Date/time manipulation
- GROUP BY and filtering
- Joins (implicit through WHERE clauses)

**Business Intelligence:**
- Funnel analysis methodology
- Conversion rate optimization
- Marketing attribution
- Customer journey mapping
- Revenue metrics calculation

**Data Analysis:**
- Problem decomposition
- Metric definition
- Performance comparison
- Time-series analysis
- Insight generation

---

**Built with:** Google BigQuery SQL  
**Dataset:** User events data (30-day rolling window)  
**Analysis Period:** Last 30 days from query execution  
**Date Created:** February 2026

---

## 💬 About This Project

This is one of several projects in my data analytics portfolio. I'm actively seeking data analyst roles where I can apply SQL, Python, and visualization skills to solve business problems.

**Portfolio:** [Add your portfolio link here]  
**LinkedIn:** [Add your LinkedIn here]  
**Email:** [Add your email here]

---

## 📝 How to Use This Code

1. This SQL is written for Google BigQuery
2. You'll need a dataset with these columns:
   - `event_date` (TIMESTAMP)
   - `user_id` (STRING)
   - `event_type` (STRING) - values: 'page_view', 'add_to_cart', 'checkout_start', 'payment_info', 'purchase'
   - `amount` (FLOAT) - for revenue analysis
   - `traffic_source` (STRING) - for channel analysis
3. Update the table name in FROM clauses to match your dataset
4. Run each query section separately to see results

---

*This README demonstrates documentation skills - an important part of being a data professional!*
