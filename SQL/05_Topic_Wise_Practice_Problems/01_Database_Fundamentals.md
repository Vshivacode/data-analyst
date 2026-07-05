(Assume `customers(id, first_name, country, score)` and `orders(order_id, customer_id, order_date, amount)`)

---

### Problem 1
**Company:** Generic | **Difficulty:** Easy | **Platform:** Self-practice
**Problem:** Retrieve all columns from the customers table.
**Hint:** SELECT *
**Solution:**
```sql
SELECT * FROM customers;
```
**Learning:** Basic full-table retrieval.

---

### Problem 2
**Company:** Amazon-style | **Difficulty:** Easy
**Problem:** Retrieve only first_name and country columns.
**Solution:**
```sql
SELECT first_name, country FROM customers;
```
**Learning:** Column-specific selection is more efficient and professional than SELECT *.

---

### Problem 3
**Company:** Generic | **Difficulty:** Easy
**Problem:** Find all customers with a score greater than 500.
**Solution:**
```sql
SELECT * FROM customers WHERE score > 500;
```
**Learning:** Basic WHERE filtering with comparison operator.

---

### Problem 4
**Company:** Fintech-style | **Difficulty:** Easy
**Problem:** Find all customers whose score is NOT zero.
**Solution:**
```sql
SELECT * FROM customers WHERE score != 0;
```
**Learning:** Not-equal operator; relevant for excluding test/inactive accounts.

---

### Problem 5
**Company:** Generic | **Difficulty:** Easy
**Problem:** Find all customers from Germany.
**Solution:**
```sql
SELECT * FROM customers WHERE country = 'Germany';
```
**Learning:** Exact string match filtering (case sensitivity depends on DBMS).

---

### Problem 6
**Company:** Generic | **Difficulty:** Easy-Medium
**Problem:** Show customers sorted by score, highest first.
**Solution:**
```sql
SELECT * FROM customers ORDER BY score DESC;
```
**Learning:** ORDER BY with DESC for descending sort.

---

### Problem 7
**Company:** Sales Ops style | **Difficulty:** Medium
**Problem:** Show customers sorted by country (A-Z), and within each country, 
highest score first.
**Solution:**
```sql
SELECT * FROM customers ORDER BY country ASC, score DESC;
```
**Learning:** Nested ORDER BY — second column sorts only within tie groups of first column.

---

### Problem 8
**Company:** Finance-style | **Difficulty:** Medium
**Problem:** Find total score per country.
**Solution:**
```sql
SELECT country, SUM(score) as total_score
FROM customers
GROUP BY country;
```
**Learning:** Basic GROUP BY with aggregate function.

---

### Problem 9
**Company:** Retail-style | **Difficulty:** Medium
**Problem:** Find total score AND number of customers per country.
**Solution:**
```sql
SELECT country, SUM(score) as total_score, COUNT(*) as total_customers
FROM customers
GROUP BY country;
```
**Learning:** Multiple aggregates in a single GROUP BY query.

---

### Problem 10
**Company:** Generic | **Difficulty:** Medium
**Problem:** Find countries where total score exceeds 750.
**Solution:**
```sql
SELECT country, SUM(score) as total_score
FROM customers
GROUP BY country
HAVING SUM(score) > 750;
```
**Learning:** HAVING filters aggregated groups — cannot use WHERE for this.

---

### Problem 11
**Company:** SaaS-style | **Difficulty:** Medium
**Problem:** Find average score per country, excluding zero-score accounts, 
only show countries with avg score above 430.
**Solution:**
```sql
SELECT country, AVG(score) as avg_score
FROM customers
WHERE score != 0
GROUP BY country
HAVING AVG(score) > 430;
```
**Learning:** Combining WHERE (row filter) + GROUP BY + HAVING (group filter) 
in correct execution logic.

---

### Problem 12
**Company:** Generic | **Difficulty:** Easy
**Problem:** List all unique countries in the customers table.
**Solution:**
```sql
SELECT DISTINCT country FROM customers;
```
**Learning:** DISTINCT for unique value extraction.

---

### Problem 13
**Company:** Ops-style | **Difficulty:** Medium
**Problem:** Find countries that have more than 1 customer.
**Solution:**
```sql
SELECT country, COUNT(*) as customer_count
FROM customers
GROUP BY country
HAVING COUNT(*) > 1;
```
**Learning:** Classic duplicate/frequency detection pattern with GROUP BY + HAVING.

---

### Problem 14
**Company:** Generic | **Difficulty:** Easy
**Problem:** Show the top 3 customers by score.
**Solution:**
```sql
SELECT * FROM customers ORDER BY score DESC LIMIT 3;
-- SQL Server: SELECT TOP 3 * FROM customers ORDER BY score DESC;
```
**Learning:** Combining ORDER BY + LIMIT for "Top N" pattern — extremely common in business reporting.

---

### Problem 15
**Company:** Generic | **Difficulty:** Easy
**Problem:** Show the 2 lowest-scoring customers.
**Solution:**
```sql
SELECT * FROM customers ORDER BY score ASC LIMIT 2;
```
**Learning:** "Bottom N" pattern — useful for at-risk customer identification.

---

### Problem 16
**Company:** E-commerce | **Difficulty:** Medium
**Problem:** Get the 2 most recent orders.
**Solution:**
```sql
SELECT * FROM orders ORDER BY order_date DESC LIMIT 2;
```
**Learning:** Recency-based sorting — foundational for "latest activity" reports.

---

### Problem 17
**Company:** Generic | **Difficulty:** Medium
**Problem:** Count total customers, and separately count how many have a 
non-null score.
**Solution:**
```sql
SELECT 
    COUNT(*) as total_customers,
    COUNT(score) as customers_with_score
FROM customers;
```
**Learning:** Difference between COUNT(*) and COUNT(column) for data quality checks.

---

### Problem 18
**Company:** Generic | **Difficulty:** Medium
**Problem:** Find the count of DISTINCT countries with more than one customer 
each (i.e., how many countries have duplicates).
**Solution:**
```sql
SELECT country, COUNT(country) as no_of_duplicates
FROM customers
GROUP BY country
HAVING COUNT(country) > 1;
```
**Learning:** Reinforces GROUP BY + HAVING pattern from a slightly different angle.

---

### Problem 19
**Company:** Generic | **Difficulty:** Easy
**Problem:** Display a static label column alongside real customer data 
(e.g., tag every row with your name or a batch label).
**Solution:**
```sql
SELECT first_name, country, 'ProcessedByShiva' as batch_tag
FROM customers;
```
**Learning:** Static values can be selected alongside table columns — useful 
for tagging/batch processing in ETL contexts.

---

### Problem 20
**Company:** Generic | **Difficulty:** Medium
**Problem:** Find countries where total score is between 300 and 800 
(inclusive) — think ahead to how you'd approach this with only Day 1 concepts.
**Solution:**
```sql
SELECT country, SUM(score) as total_score
FROM customers
GROUP BY country
HAVING SUM(score) >= 300 AND SUM(score) <= 800;
```
**Learning:** HAVING supports multiple AND conditions just like WHERE — 
foreshadows the BETWEEN operator you'll learn next.