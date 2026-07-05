## Problem 1: "Show me our high-value customers"
**Business Goal:** Marketing wants to launch a loyalty program for top spenders.
**Business Understanding:** "High-value" is undefined — need to clarify.
**Questions to Ask:**
- High-value based on what? Total spend? Order frequency? Recency?
- Over what time period? All-time or last 12 months?
- What threshold counts as "high-value"?

**Available Tables:** `customers`, `orders`
**Columns Required:** customer_id, order_amount
**SQL Concepts Needed:** GROUP BY, SUM, HAVING (or ORDER BY + LIMIT)

**Possible Solution:**
```sql
SELECT customer_id, SUM(order_amount) as total_spend
FROM orders
GROUP BY customer_id
HAVING SUM(order_amount) > 50000
ORDER BY total_spend DESC;
```
**Alternative Solution:** Use ORDER BY + LIMIT for "Top N" instead of a fixed threshold.
**Business Impact:** Enables targeted loyalty campaign, reduces churn risk of best customers.
**Future Improvements:** Add recency (RFM analysis) once JOINs/window functions are learned.

---

## Problem 2: "Our German customer base — how engaged are they?"
**Business Goal:** Regional manager wants to assess Germany market health.
**Questions to Ask:**
- Engaged = order frequency? Total spend? Recent activity?
- Compare against which other country as benchmark?

**Available Tables:** `customers`
**SQL Concepts Needed:** WHERE, aggregate functions

**Possible Solution:**
```sql
SELECT COUNT(*) as german_customers, AVG(score) as avg_score
FROM customers
WHERE country = 'Germany';
```
**Business Impact:** Informs whether to invest more marketing budget in Germany.

---

## Problem 3: "Which countries have data quality issues (duplicate customers)?"
**Business Goal:** Data team wants to clean the customer database before a big campaign.
**Questions to Ask:**
- What defines a duplicate? Same email? Same name + country?

**SQL Concepts Needed:** GROUP BY, HAVING, COUNT

**Possible Solution:**
```sql
SELECT country, COUNT(*) as customer_count
FROM customers
GROUP BY country
HAVING COUNT(*) > 1;
```
Note: In Day 1's simple context this just counts customers per country — real 
duplicate detection would group by a unique identifier like email.
**Business Impact:** Prevents sending duplicate marketing emails, ensures accurate 
customer counts for reporting.

---

## Problem 4: "CEO asks: What's our total customer base and how much do we not know about them?"
**Business Goal:** Understand data completeness before a board presentation.
**Questions to Ask:** Which fields matter most for completeness (phone? email? score?)

**SQL Concepts Needed:** COUNT(*), COUNT(column)

**Possible Solution:**
```sql
SELECT 
    COUNT(*) as total_customers,
    COUNT(score) as customers_with_score,
    COUNT(*) - COUNT(score) as missing_score_count
FROM customers;
```
**Business Impact:** Reveals data collection gaps — maybe onboarding form doesn't 
always capture a required field.

---

## Problem 5: "Show me the top 3 and bottom 2 customers by score"
**Business Goal:** Customer success wants to reward top performers and investigate 
at-risk bottom performers.
**SQL Concepts Needed:** ORDER BY, LIMIT/TOP

**Possible Solution:**
```sql
-- Top 3
SELECT * FROM customers ORDER BY score DESC LIMIT 3;
-- Bottom 2
SELECT * FROM customers ORDER BY score ASC LIMIT 2;
```
**Business Impact:** Targeted retention outreach for at-risk (low score) customers, 
recognition program for top scorers.

---

## Problem 6: "Revenue dropped — CEO wants answers" (Classic Scenario)
**Business Goal:** Understand revenue decline before making budget decisions.
**Business Understanding:** Never start writing SQL immediately for a vague statement.
**Questions to Ask:**
- Dropped compared to what? Last month? Last year?
- Which product/region/country?
- Gross or net revenue?

**Note:** This requires JOINs and time-based analysis (Week 2+), but the THINKING 
starts Day 1: always clarify before querying.
**Business Impact:** Prevents wasted analysis on the wrong question.

---

## Problem 7: "List unique countries where we have any customers"
**Business Goal:** Expansion team assessing current geographic footprint.
**SQL Concepts Needed:** DISTINCT

**Possible Solution:**
```sql
SELECT DISTINCT country FROM customers;
```
**Business Impact:** Quick footprint check before deciding next expansion market.

---

## Problem 8: "Find countries where total customer score exceeds a threshold, but exclude zero-score (fraud/test) accounts"
**Business Goal:** Filter out test/fraud accounts before country performance ranking.
**SQL Concepts Needed:** WHERE + GROUP BY + HAVING together

**Possible Solution:**
```sql
SELECT country, AVG(score) as avg_score
FROM customers
WHERE score != 0
GROUP BY country
HAVING AVG(score) > 430;
```
**Business Impact:** Cleaner performance ranking, avoids test accounts skewing 
country-level decisions.

---

## Problem 9: "Sort our customer list for a sales call sheet — by country, then highest scorers first within each country"
**Business Goal:** Sales team wants an organized call list, prioritizing best 
customers within each region they're calling.
**SQL Concepts Needed:** Nested ORDER BY

**Possible Solution:**
```sql
SELECT * FROM customers ORDER BY country ASC, score DESC;
```
**Business Impact:** Sales reps call highest-value customers first within their 
assigned region.

---

## Problem 10: "How many customers do we have, and are there any with a currency preference not equal to standard 3-letter codes?"
**Business Goal:** Data quality check before international payment integration.
**Questions to Ask:** What table stores currency preference? What format is expected 
(CHAR(3) like 'USD')?
**SQL Concepts Needed:** Understanding CHAR datatype constraints, WHERE with LENGTH-type checks (preview of Week 2 string functions)
**Business Impact:** Prevents payment processing errors from malformed currency codes.