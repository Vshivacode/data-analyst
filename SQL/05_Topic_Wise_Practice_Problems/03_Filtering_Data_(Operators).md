### Problem 1
**Difficulty:** Easy
**Problem:** Find all customers with a score not equal to 0.
**Solution:** `SELECT * FROM customers WHERE score != 0;`
**Learning:** Basic not-equal comparison.

---

### Problem 2
**Difficulty:** Easy
**Problem:** Find customers with score greater than or equal to 750.
**Solution:** `SELECT * FROM customers WHERE score >= 750;`
**Learning:** Basic >= comparison.

---

### Problem 3
**Difficulty:** Medium
**Problem:** Find customers from USA with score less than 300.
**Solution:** `SELECT * FROM customers WHERE country = 'usa' AND score < 300;`
**Learning:** Combining comparison with AND.

---

### Problem 4
**Difficulty:** Medium
**Problem:** Find customers who are from Germany OR have a score above 800.
**Solution:** `SELECT * FROM customers WHERE country = 'germany' OR score > 800;`
**Learning:** OR logic — broader result set.

---

### Problem 5
**Difficulty:** Medium
**Problem:** Find customers whose score is NOT between 200 and 600.
**Solution:** 
```sql
SELECT * FROM customers WHERE score NOT BETWEEN 200 AND 600;
```
**Learning:** BETWEEN can also be negated with NOT.

---

### Problem 6
**Difficulty:** Easy
**Problem:** Find customers whose score falls between 400 and 900 (inclusive).
**Solution:** `SELECT * FROM customers WHERE score BETWEEN 400 AND 900;`
**Learning:** Basic inclusive range filtering.

---

### Problem 7
**Difficulty:** Medium
**Problem:** Find customers from USA, Germany, or UK using the cleanest syntax.
**Solution:** `SELECT * FROM customers WHERE country IN ('usa', 'germany', 'uk');`
**Learning:** IN as a clean alternative to multiple ORs.

---

### Problem 8
**Difficulty:** Medium
**Problem:** Find customers who are NOT from USA, Germany, or UK.
**Solution:** `SELECT * FROM customers WHERE country NOT IN ('usa', 'germany', 'uk');`
**Learning:** NOT IN for exclusion lists (remember the NULL gotcha!).

---

### Problem 9
**Difficulty:** Easy
**Problem:** Find all customers whose first name starts with 'A'.
**Solution:** `SELECT * FROM customers WHERE first_name LIKE 'A%';`
**Learning:** Basic LIKE with trailing wildcard.

---

### Problem 10
**Difficulty:** Easy
**Problem:** Find all customers whose first name ends with 'a'.
**Solution:** `SELECT * FROM customers WHERE first_name LIKE '%a';`
**Learning:** Basic LIKE with leading wildcard.

---

### Problem 11
**Difficulty:** Medium
**Problem:** Find all customers whose first name contains 'ar' anywhere.
**Solution:** `SELECT * FROM customers WHERE first_name LIKE '%ar%';`
**Learning:** LIKE with wildcards on both sides.

---

### Problem 12
**Difficulty:** Medium
**Problem:** Find all customers whose first name is exactly 5 characters long.
**Solution:** `SELECT * FROM customers WHERE first_name LIKE '_____';`
**Learning:** Using only underscores to enforce exact length.

---

### Problem 13
**Difficulty:** Medium
**Problem:** Find all customers whose first name has 'e' as the second character.
**Solution:** `SELECT * FROM customers WHERE first_name LIKE '_e%';`
**Learning:** Positional pattern matching with underscore.

---

### Problem 14
**Difficulty:** Hard
**Problem:** Find customers whose score is between 100-500 AND who are from 
USA or Germany, but exclude anyone with a first name starting with 'Z'.
**Solution:**
```sql
SELECT * FROM customers
WHERE score BETWEEN 100 AND 500
  AND country IN ('usa', 'germany')
  AND first_name NOT LIKE 'Z%';
```
**Learning:** Combining BETWEEN + IN + NOT LIKE — realistic multi-condition query.

---

### Problem 15
**Difficulty:** Medium
**Problem:** Find customers where NOT (country = 'usa' AND score > 500) — 
i.e., exclude high-scoring USA customers specifically.
**Solution:**
```sql
SELECT * FROM customers WHERE NOT (country = 'usa' AND score > 500);
```
**Learning:** NOT wrapping a compound AND condition — De Morgan's law in practice.

---

### Problem 16
**Difficulty:** Hard
**Problem:** Rewrite Problem 15 WITHOUT using NOT (apply De Morgan's law manually).
**Solution:**
```sql
SELECT * FROM customers WHERE country != 'usa' OR score <= 500;
```
**Learning:** NOT (A AND B) is logically equivalent to (NOT A) OR (NOT B) — 
understanding this deeply helps debug complex filter logic.

---

### Problem 17
**Difficulty:** Medium
**Problem:** Find all customers whose country is misspelled as exactly 
'usa' or 'u.s.a' or 'USA ' (with trailing space) — write a LIKE-based 
catch-all instead of exact IN matching.
**Solution:**
```sql
SELECT * FROM customers WHERE country LIKE '%usa%' OR country LIKE '%u.s.a%';
```
**Learning:** LIKE as a data-quality catch-all for messy/inconsistent text data.

---

### Problem 18
**Difficulty:** Medium
**Problem:** Find customers with a score that is NOT less than 500 (rewrite 
using both NOT and a direct comparison operator, then explain which is more readable).
**Solution:**
```sql
-- Using NOT
SELECT * FROM customers WHERE NOT score < 500;
-- Direct equivalent (more readable, preferred)
SELECT * FROM customers WHERE score >= 500;
```
**Learning:** Reinforces the readability best practice from concepts file.

---

### Problem 19
**Difficulty:** Hard
**Problem:** A colleague wrote: `WHERE category_id NOT IN (SELECT category_id 
FROM archived_categories)` and it unexpectedly returned 0 rows even though 
they expected results. What's the likely cause, and how would you fix it?
**Solution:**
```sql
-- Likely cause: archived_categories.category_id contains at least one NULL

-- Fix: filter out NULLs from the subquery explicitly
SELECT * FROM products
WHERE category_id NOT IN (
    SELECT category_id FROM archived_categories WHERE category_id IS NOT NULL
);
```
**Learning:** Real debugging scenario applying the NOT IN + NULL gotcha from today's concepts.

---

### Problem 20
**Difficulty:** Hard
**Problem:** Write a single query to find "high-potential leads": score 
between 200-600 (not yet premium), from one of our 5 growth-target countries, 
whose email does NOT look like a disposable/temp email (contains 'temp' or 'fake').
**Solution:**
```sql
SELECT * FROM customers
WHERE score BETWEEN 200 AND 600
  AND country IN ('India', 'Brazil', 'Indonesia', 'Mexico', 'Vietnam')
  AND email NOT LIKE '%temp%'
  AND email NOT LIKE '%fake%';
```
**Learning:** Realistic, business-framed query combining every operator 
category learned today into one cohesive filter — this is what actual 
analyst work looks like.