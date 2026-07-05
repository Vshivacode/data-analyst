## Problem 1: "Find all customers from our top 3 revenue countries, excluding test accounts"
**Business Goal:** Marketing wants a clean targeting list for a global campaign.
**Questions to Ask:** Which 3 countries specifically? How do we identify "test accounts" (flag column? specific ID range?)

**SQL Concepts Needed:** IN, NOT (or !=)

**Possible Solution:**
```sql
SELECT * FROM customers
WHERE country IN ('USA', 'Germany', 'India')
  AND is_test_account = 0;
```
**Business Impact:** Clean, precise campaign targeting list without polluting 
metrics with internal test data.

---

## Problem 2: "Identify mid-tier customers (score between 300-700) for a targeted upgrade offer"
**Business Goal:** Growth team wants to nudge mid-tier customers toward premium tier.
**Questions to Ask:** Is 300-700 inclusive on both ends? Any existing premium 
customers to exclude?

**SQL Concepts Needed:** BETWEEN, NOT IN

**Possible Solution:**
```sql
SELECT * FROM customers
WHERE score BETWEEN 300 AND 700
  AND customer_id NOT IN (SELECT customer_id FROM premium_members);
```
**Business Impact:** Precisely targets the "in-between" segment most likely 
to convert with a nudge — too low and they're not ready, too high and 
they're already premium.

---

## Problem 3: "Find potentially fraudulent email signups (email pattern looks suspicious)"
**Business Goal:** Trust & Safety team wants to flag low-quality/bot signups.
**Questions to Ask:** What patterns indicate suspicion — no @ symbol? 
Random character strings? Disposable email domains?

**SQL Concepts Needed:** LIKE, NOT LIKE

**Possible Solution:**
```sql
SELECT * FROM customers
WHERE email NOT LIKE '%@%.%'    -- missing basic email structure
   OR email LIKE '%@tempmail%'; -- known disposable domain pattern
```
**Business Impact:** Proactive fraud/spam prevention before these accounts 
pollute engagement metrics or abuse promotional offers.

---

## Problem 4: "Show all orders EXCEPT from cancelled or refunded status, for our monthly revenue report"
**Business Goal:** Finance needs accurate revenue figures excluding non-revenue-generating orders.
**Questions to Ask:** Are there other statuses that shouldn't count as revenue 
(e.g., 'pending')?

**SQL Concepts Needed:** NOT IN

**Possible Solution:**
```sql
SELECT * FROM orders
WHERE status NOT IN ('cancelled', 'refunded');
```
**⚠️ Analyst's proactive check:** "Let me first verify the `status` column 
has no NULL values, since NOT IN would silently misbehave if it did."
```sql
SELECT COUNT(*) FROM orders WHERE status IS NULL;
```
**Business Impact:** Accurate revenue reporting — including cancelled/refunded 
orders would overstate actual business performance.

---

## Problem 5: "Find customers whose names might have data entry errors (names shorter than 2 characters, or containing unexpected patterns)"
**Business Goal:** Data quality audit before a major mail campaign.
**Questions to Ask:** What counts as "too short"? Should we also check for 
names with only special characters/numbers?

**SQL Concepts Needed:** LIKE with underscore patterns

**Possible Solution:**
```sql
SELECT * FROM customers WHERE first_name LIKE '_';  -- exactly 1 character (likely error)
```
**Business Impact:** Catches data entry errors before they result in poorly 
personalized ("Dear X,") marketing emails — protects brand quality.

---

## Problem 6: "CFO wants: revenue from orders priced between ₹10,000-₹50,000, but only from our 4 key markets, excluding any test/internal orders"
**Business Goal:** Complex, multi-condition executive reporting request.
**Questions to Ask:** Which 4 markets exactly? How is "test/internal" flagged?

**SQL Concepts Needed:** BETWEEN + IN + NOT (combining everything from today)

**Possible Solution:**
```sql
SELECT * FROM orders
WHERE amount BETWEEN 10000 AND 50000
  AND country IN ('USA', 'India', 'Germany', 'UK')
  AND is_internal_order = 0;
```
**Business Impact:** This is a realistic example of how a SINGLE executive 
request often requires combining 3-4 different filtering operators together — 
exactly the kind of query a ₹8+ LPA analyst writes daily.

---

## Problem 7: "Find all support tickets with 'urgent' or 'critical' anywhere in the description, but exclude resolved ones"
**Business Goal:** Support team wants a live dashboard of unresolved high-priority issues.
**SQL Concepts Needed:** LIKE with OR, NOT

**Possible Solution:**
```sql
SELECT * FROM support_tickets
WHERE (description LIKE '%urgent%' OR description LIKE '%critical%')
  AND status != 'resolved';
```
**Business Impact:** Real-time triage tool preventing critical issues from 
being buried in a general ticket queue.

---

## Problem 8: "Which product SKUs don't follow our standard naming format (should start with 3 letters + 4 digits)?"
**Business Goal:** Data governance audit of product catalog.
**SQL Concepts Needed:** LIKE with underscore pattern, NOT LIKE

**Possible Solution:**
```sql
SELECT * FROM products 
WHERE sku NOT LIKE '[A-Za-z][A-Za-z][A-Za-z][0-9][0-9][0-9][0-9]';
-- Simpler underscore-only version (checks length/position but not letter/digit type):
SELECT * FROM products WHERE sku NOT LIKE '___####';
```
**Business Impact:** Identifies catalog inconsistencies before they cause 
issues in inventory/warehouse systems that expect standardized SKU formats.

---

## Problem 9: "Regional manager: show me customers NOT in our currently active markets (potential expansion targets)"
**Business Goal:** Expansion strategy — identify where we have customer 
interest but no active operations.
**SQL Concepts Needed:** NOT IN

**Possible Solution:**
```sql
SELECT DISTINCT country FROM customers
WHERE country NOT IN (SELECT country FROM active_markets);
```
**Business Impact:** Surfaces organic demand signals in unserved markets — 
directly informs expansion strategy discussions.

---

## Problem 10: "Find all transactions that are suspiciously round numbers (potential manual/fraudulent entry) — e.g., exactly 10000, 20000, 50000"
**Business Goal:** Fraud team hypothesis: genuine transactions rarely land 
on perfectly round numbers.
**SQL Concepts Needed:** IN

**Possible Solution:**
```sql
SELECT * FROM transactions 
WHERE amount IN (10000, 20000, 50000, 100000);
```
**Business Impact:** A real fraud-detection heuristic used in practice — 
round-number transactions are statistically more likely to be manually 
entered/fabricated than organic customer purchases.