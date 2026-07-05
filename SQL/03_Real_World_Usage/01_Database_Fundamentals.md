### Topic: SELECT + WHERE
**Companies:** Amazon, Flipkart, Swiggy, HDFC Bank, Netflix
**Who uses it:** Data Analyst, BI Analyst, Product Analyst, Support teams
**Real Query:** "Show me all customers from Germany with score > 500"
```sql
SELECT * FROM customers WHERE country = 'Germany' AND score > 500;
```
**Business Impact:** Marketing wants to target high-value German customers for a 
loyalty campaign — this query produces that exact list in seconds vs manually 
filtering an Excel sheet.
**Performance Consideration:** Without an index on `country`, this scans every row 
(fine for 10K rows, painful for 500M rows).

---

### Topic: GROUP BY
**Companies:** Amazon, Flipkart, Netflix, Swiggy, Banking, Healthcare
**Who uses it:** Data Analyst, BI Analyst, Data Scientist, Finance Analyst, Product Analyst
**Real Query:** "Find revenue by country/region"
```sql
SELECT country, SUM(revenue) as total_revenue
FROM orders
GROUP BY country;
```
**Business Impact:** Finance team decides next quarter's regional marketing budget 
based on which countries generate the most revenue.
**Data Engineer Example:** This same GROUP BY logic scales to billions of transaction 
rows inside Spark before being loaded into a data warehouse fact table.

---

### Topic: HAVING
**Companies:** Swiggy, Zomato, Banking fraud teams
**Who uses it:** Data Analyst, Risk Analyst
**Real Query:** "Which restaurant partners have more than 1000 orders this month?"
```sql
SELECT restaurant_id, COUNT(*) as order_count
FROM orders
GROUP BY restaurant_id
HAVING COUNT(*) > 1000;
```
**Business Impact:** Operations team identifies top-performing partners for 
priority support or renegotiated commission rates.

---

### Topic: ORDER BY + LIMIT/TOP
**Companies:** Myntra, Amazon, Nykaa
**Who uses it:** Business Analyst, Category Manager
**Real Query:** "Top 10 highest-value customers this year"
```sql
SELECT customer_id, SUM(order_amount) as total_spend
FROM orders
GROUP BY customer_id
ORDER BY total_spend DESC
LIMIT 10;
```
**Business Impact:** VIP relationship managers get assigned to these top 10 
customers to prevent churn — losing even one could mean lakhs in lost revenue.

---

### Topic: DISTINCT
**Companies:** Any company with a customer/product database
**Who uses it:** Data Analyst, Marketing Analyst
**Real Query:** "How many unique countries do we operate in?"
```sql
SELECT DISTINCT country FROM customers;
```
**Business Impact:** Expansion team uses this to understand current market 
footprint before deciding where to expand next.

---

### Topic: COUNT(*), COUNT(column), COUNT(DISTINCT column)
**Companies:** SaaS companies (Freshworks, Chargebee), Banking
**Who uses it:** Product Analyst, Customer Success Analyst
**Real Query:** "How many customers have provided a phone number vs total customers?"
```sql
SELECT 
    COUNT(*) as total_customers,
    COUNT(phone_number) as customers_with_phone,
    COUNT(DISTINCT phone_number) as unique_phone_numbers
FROM customers;
```
**Business Impact:** Customer success team identifies data completeness gaps 
before launching an SMS campaign.

---

### Topic: DBMS / Database Fundamentals
**Companies:** Every tech company (this is infrastructure knowledge)
**Who uses it:** Data Analyst (to understand where data lives), Data Engineer 
(to design it), Backend Developer (to build on it)
**Real Scenario:** New analyst joins Flipkart, needs to understand that customer 
data lives in a PostgreSQL RDBMS with separate `customers`, `orders`, `products` 
tables connected via foreign keys — not one giant spreadsheet.
**Business Impact:** Understanding this structure is prerequisite to writing any 
correct query — without it, an analyst can't even know which tables to JOIN.

---

### Topic: CHAR vs VARCHAR (Data Modeling Awareness)
**Companies:** Any company designing new data pipelines (Fintech especially)
**Who uses it:** Data Engineer primarily; Data Analyst benefits from understanding it
**Real Scenario:** A fintech company designs a new `transactions` table. The 
`currency_code` column uses CHAR(3) (always exactly 'USD', 'INR', 'EUR') while 
`merchant_name` uses VARCHAR(255) (variable length).
**Business Impact:** Correct datatype choices reduce storage costs at scale 
(billions of transaction rows) and prevent data entry errors.

---

### Topic: SQL Execution Order
**Companies:** Any company — this is core to writing ANY correct query
**Who uses it:** Every Data Analyst, every day
**Real Scenario:** A junior analyst at Razorpay tries to filter using a calculated 
alias in WHERE and gets a confusing error. Understanding execution order 
(FROM→WHERE→GROUP BY→HAVING→SELECT→ORDER BY) immediately explains why and how to fix it.
**Business Impact:** Saves hours of debugging confusion; senior analysts are 
distinguished by understanding WHY queries behave the way they do, not just 
memorizing syntax.