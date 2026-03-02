# 🍕 Pizza Sales & Operational Analytics Project

**Source: Maven Analytics Challenge – Pizza Dataset**

Project Context – Maven Analytics Challenge

This project consolidates transactional, product, and order-level data from the Maven Analytics Pizza Challenge dataset to produce actionable insights on sales performance, product mix, and temporal ordering patterns.

Why it matters / So What:

Revenue drivers: Reveals which pizzas drive revenue and which are underperforming → helps optimize product mix.

Temporal trends: Shows ordering patterns by time → informs staffing, promotions, and operational planning.

Concentration risks: Highlights dependency on top SKUs → supports risk mitigation and diversification.

Audience

Franchise managers, operations analysts, and business decision-makers seeking actionable, data-driven insights.

## 📊 Topline Metrics

| Metric                   | Value                                                                                                  | So What?                                                                           |
| ------------------------ | ------------------------------------------------------------------------------------------------------ | ---------------------------------------------------------------------------------- |
| Total Orders             | 21,350                                                                                                 | Dataset is large enough to produce statistically meaningful insights.              |
| Total Revenue            | $817,860.05                                                                                            | Sets the baseline for understanding revenue contribution by SKU.                   |
| Most Expensive Pizza     | `The Greek XXL` – $35.95                                                                               | High-ticket items can drive margins if promoted strategically.                     |
| Most Common Pizza Size   | Small (S) – 32                                                                                         | Majority of orders are small—operations should prioritize high-volume small sizes. |
| Top 5 Pizzas by Quantity | Classic Deluxe (2,453), BBQ Chicken (2,432), Hawaiian (2,422), Pepperoni (2,418), Thai Chicken (2,371) | Revenue and volume are heavily skewed toward a few SKUs—risk of over-dependence.   |

---

## 🍗 Category & Temporal Analytics

**Total Quantity by Category**

| Category | Quantity | So What?                                                                        |
| -------- | -------- | ------------------------------------------------------------------------------- |
| Classic  | 14,888   | Classic pizzas dominate demand—inventory should prioritize these ingredients.   |
| Chicken  | 11,050   | Chicken-based products are high performers—menu strategy should highlight them. |
| Supreme  | 11,987   | Moderate sales—opportunity to push promotions for lower-selling items.          |
| Veggie   | 11,649   | Veggie pizzas perform consistently—maintain availability but adjust marketing.  |

**Temporal Distribution of Orders**

| Hour of Day           | Orders | So What?                                                                       |
| --------------------- | ------ | ------------------------------------------------------------------------------ |
| Peak: 12–19           | 14,809 | Most orders occur during lunch and dinner—staffing and prep should focus here. |
| Off-Peak: 9–11, 20–23 | 1,740  | Minimal off-peak demand—use for targeted discounts or delivery incentives.     |

**Average Pizzas per Day**
Daily averages: 77–264 pizzas/day. **So What?** Understand daily operational load and plan inventory and labor accordingly.

---

## 💰 Revenue & Performance Insights

**Top 3 Pizza Types by Revenue**

| Pizza Type               | Revenue    | Contribution % | So What?                                                                          |
| ------------------------ | ---------- | -------------- | --------------------------------------------------------------------------------- |
| Thai Chicken Pizza       | $43,434.25 | 5.31%          | Small set of SKUs dominate revenue—promote top performers for maximum impact.     |
| BBQ Chicken Pizza        | $42,768.00 | 5.23%          | Focus marketing and inventory on high-revenue SKUs to protect sales.              |
| California Chicken Pizza | $41,409.50 | 5.06%          | Revenue sensitivity is high for these products—monitor stock and pricing closely. |

**Revenue Contribution Distribution:**
Top 10 SKUs = ~44% of total revenue. **So What?** Over-reliance on a few SKUs increases business risk—consider diversification strategies.

**Cumulative Revenue Over Time:**
Daily revenue shows steady growth with periodic spikes. **So What?** Spikes likely correlate with promotions or events—identify causes to replicate positive effects.

---

## 🔍 Analytical Highlights (“So What?”)

1. **SKU Concentration Risk**: Few SKUs drive most revenue. **So What?** Diversify promotions and menu options to reduce dependency.
2. **Time-of-Day Optimization**: Orders peak 12–19. **So What?** Align staffing and prep schedules to peak hours to reduce waste and improve service.
3. **Pricing & Margin Opportunities**: Premium pizzas exist. **So What?** Use upselling strategies to increase overall margins.
4. **Seasonality & Event Effects**: Daily sales vary widely. **So What?** Anticipate high-demand days to optimize inventory and staffing.
5. **Pareto Principle in Action**: 20% of SKUs generate >50% of revenue. **So What?** Focus business strategy on top SKUs but also explore growth opportunities in the long tail.

---

## 🛠️ Technical Notes & SQL Techniques (Merged)

Temporal Peak Analysis: Used DATEPART(HOUR, time) to bucket 21,000+ orders into hourly slots, identifying a 74% concentration of sales between 12:00 and 19:00. Learned the SSMS syntax (DATEPART) as opposed to HOUR() in MySQL.

Menu vs. Sales Metrics: COUNT(*) on pizzas counts menu SKUs; for sold quantities, aggregation must occur on order_details. Clarifies what “Most Common Pizza Size” really measures.

Financial Growth Tracking: Implemented Common Table Expressions (CTEs) and Window Functions (SUM() OVER) to calculate cumulative daily revenue efficiently without self-joins. Learned how CTEs simplify multi-step queries.

Top-N Analysis: Used TOP N (SQL Server equivalent of LIMIT) to get highest revenue or quantity SKUs. Learned the SSMS-specific syntax for quick top-N queries.

Revenue Partitioning by Category: ROW_NUMBER() OVER (PARTITION BY pt.category ORDER BY SUM(od.quantity * p.price) DESC) to rank pizzas per category, enabling top 3 insights. Learned ranking within partitions for granular insights.

Date Aggregation: CAST(date AS DATE) ensures proper grouping by day in SSMS, replacing MySQL-style DATE(). Critical for temporal trends.

JOINs & Aggregations: Multi-table joins (orders → order_details → pizzas → pizza_types) allow precise revenue and quantity aggregation without double-counting. Reinforced careful join order and groupings.

Key Takeaway: Each SQL technique was chosen not just to produce the metric but to add clarity, accuracy, and analytical depth, demonstrating practical SSMS expertise in real-world data.
---
## How to Run SQL Analysis

1. Open `sql/sql_analysis.sql` in SQL Server Management Studio (SSMS).  
2. Import the Maven Analytics Dataset `.xlsx` files into your database.  
3. Execute the queries sequentially to reproduce the insights presented in this README.

---
**Conclusion:**
Revenue and volume are heavily concentrated in a few SKUs and peak hours. **So What?** Operational focus on top performers, staff alignment, and SKU diversification will improve stability, margin, and growth. SQL techniques like CTEs, window functions, and TOP helped structure these insights efficiently.

---

