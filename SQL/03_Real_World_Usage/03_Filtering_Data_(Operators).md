### Topic: Comparison Operators
**Companies:** Every company, every day
**Who uses it:** Every Data Analyst, every query
**Real Query:** "Find all orders above ₹5000 from last quarter"
```sql
SELECT * FROM orders WHERE amount > 5000 AND order_date >= '2024-10-01';
```
**Business Impact:** Basic building block for virtually every business report — 
identifying high-value transactions, filtering active vs inactive accounts, etc.

---

### Topic: AND / OR / NOT (Logical Operators)
**Companies:** Amazon, Swiggy, Banking fraud teams
**Who uses it:** Data Analyst, Risk Analyst
**Real Query:** "Flag transactions that are either very large OR from a 
high-risk country, but exclude our verified enterprise clients"
```sql
SELECT * FROM transactions
WHERE (amount > 500000 OR country IN ('high_risk_list'))
  AND NOT client_type = 'verified_enterprise';
```
**Business Impact:** Combines multiple business rules into one precise fraud 
detection query — this exact pattern (combining AND/OR/NOT with parentheses) 
is used daily in risk/compliance analytics.

---

### Topic: BETWEEN
**Companies:** Every e-commerce/retail company
**Who uses it:** Business Analyst, Category Manager, Finance Analyst
**Real Query:** "Find products in our 'mid-range' pricing tier (₹1000-₹5000) 
for a promotional campaign"
```sql
SELECT * FROM products WHERE price BETWEEN 1000 AND 5000;
```
**Business Impact:** Defines pricing segments for targeted promotions — 
BETWEEN is the standard tool for any tiered/bucketed business analysis 
(price tiers, age groups, date ranges).

---

### Topic: IN / NOT IN
**Companies:** Myntra, Nykaa, any multi-region company
**Who uses it:** Marketing Analyst, Regional Manager
**Real Query:** "Target customers in our top 5 priority cities for a flash sale"
```sql
SELECT * FROM customers 
WHERE city IN ('Mumbai', 'Delhi', 'Bangalore', 'Hyderabad', 'Chennai');
```
**Business Impact:** Enables precise geographic/categorical targeting for 
campaigns without writing unwieldy OR chains — a daily-use pattern.

**Data Engineer Example:** IN is frequently used in incremental ETL to 
process only specific partition/batch IDs: `WHERE batch_id IN (12045, 12046, 12047)`.

---

### Topic: LIKE
**Companies:** E-commerce search features, CRM systems (Salesforce-style), 
Support ticket systems
**Who uses it:** Data Analyst (ad-hoc search), Support/CRM teams, Data Quality teams
**Real Query:** "Find all customers whose email looks malformed (missing @ symbol)"
```sql
SELECT * FROM customers WHERE email NOT LIKE '%@%';
```
**Business Impact:** Classic data quality check — flags bad data before it 
breaks email marketing campaigns.

**Another Real Query:** "Find all products with 'wireless' anywhere in the name"
```sql
SELECT * FROM products WHERE product_name LIKE '%wireless%';
```
**Business Impact:** Powers basic search functionality and category discovery 
in the absence of dedicated full-text search infrastructure.

---

### Topic: The NOT IN + NULL Gotcha (Edge Case Awareness)
**Companies:** Any company running critical financial/reporting queries
**Who uses it:** Senior Data Analysts, Data Engineers (this is where 
experience separates people)
**Real Scenario:** An analyst at a fintech company writes a report using 
`NOT IN` against a subquery of "refunded_transaction_ids" — one of those IDs 
was NULL due to a data entry issue — and the ENTIRE report returned zero rows, 
nearly causing a wrong "no fraud detected" conclusion to be reported to leadership.
**Business Impact:** This single gotcha, if undetected, can produce silently 
wrong business-critical reports — this is why experienced analysts specifically 
test for and avoid this pattern.