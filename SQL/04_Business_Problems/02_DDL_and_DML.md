## Problem 1: "We're launching a new referral program — we need to track referrals"
**Business Goal:** Product team needs a new table to track who referred whom.
**Questions to Ask:**
- What fields matter? Referrer ID, referred customer ID, referral date, reward status?
- Should referral_id be auto-generated?

**SQL Concepts Needed:** CREATE TABLE, IDENTITY, PRIMARY KEY

**Possible Solution:**
```sql
CREATE TABLE referrals
(
    referral_id INT NOT NULL IDENTITY(1,1),
    referrer_customer_id INT NOT NULL,
    referred_customer_id INT NOT NULL,
    referral_date DATE DEFAULT GETDATE(),
    reward_status VARCHAR(20) DEFAULT('pending'),
    CONSTRAINT pk_referrals PRIMARY KEY (referral_id)
);
```
**Business Impact:** Enables tracking and rewarding a new growth channel (referrals).

---

## Problem 2: "Marketing wants to capture customer birthdays for birthday discount campaigns"
**Business Goal:** Add a new field to existing customer table without disrupting current operations.
**Questions to Ask:** Should this be optional (nullable) since we don't have 
historical birthday data for existing customers?

**SQL Concepts Needed:** ALTER TABLE ADD

**Possible Solution:**
```sql
ALTER TABLE customers ADD birth_date DATE;
```
**Business Impact:** Enables future birthday-based marketing automation; 
existing customers simply have NULL until they update their profile.

---

## Problem 3: "We're deprecating the fax_number field — nobody uses fax anymore"
**Business Goal:** Clean up unused schema clutter.
**Questions to Ask:** Does any report or downstream system still reference 
this column? (Critical check before dropping!)

**SQL Concepts Needed:** ALTER TABLE DROP COLUMN

**Possible Solution:**
```sql
-- First: verify no dependencies
-- Then:
ALTER TABLE customers DROP COLUMN fax_number;
```
**Business Impact:** Reduces schema clutter and confusion for future analysts/engineers.

---

## Problem 4: "A batch import accidentally left 500 customer records with NULL country — fix them"
**Business Goal:** Data quality cleanup before a regional marketing campaign.
**Questions to Ask:** What should NULL be replaced with — a specific known 
country, or a placeholder like 'Unknown'?

**SQL Concepts Needed:** UPDATE + IS NULL

**Possible Solution:**
```sql
UPDATE customers SET country = 'Unknown' WHERE country IS NULL;
```
**Business Impact:** Prevents these 500 customers from being silently excluded 
from country-based reports/campaigns due to NULL grouping issues.

---

## Problem 5: "An order was mistakenly marked as 'cancelled' — customer says they still want it"
**Business Goal:** Correct a single erroneous status.
**Questions to Ask:** What's the correct status to revert it to? Just this 
one order, or check if similar batch errors happened?

**SQL Concepts Needed:** UPDATE with precise WHERE

**Possible Solution:**
```sql
-- Preview first!
SELECT * FROM orders WHERE order_id = 78234;
-- Then update
UPDATE orders SET status = 'processing' WHERE order_id = 78234;
```
**Business Impact:** Prevents lost revenue/customer dissatisfaction from an 
incorrect status; precise targeting (single order_id) avoids affecting other orders.

---

## Problem 6: "GDPR request: a customer wants all their data deleted"
**Business Goal:** Legal compliance — remove one customer's data completely.
**Questions to Ask:** Which tables contain this customer's data (customers, 
orders, support_tickets)? Do we need to anonymize instead of hard-delete for 
audit/financial record purposes?

**SQL Concepts Needed:** DELETE with precise WHERE (across multiple tables)

**Possible Solution:**
```sql
DELETE FROM support_tickets WHERE customer_id = 5521;
DELETE FROM orders WHERE customer_id = 5521;
DELETE FROM customers WHERE customer_id = 5521;
```
**Business Impact:** Legal compliance (avoiding GDPR fines), but requires 
careful ORDER of deletion (child records before parent, to avoid foreign key 
violations — foreshadows constraints/relationships topic).

---

## Problem 7: "We need a temporary table to test a new pricing model before rolling out"
**Business Goal:** Safe experimentation without touching production data.
**SQL Concepts Needed:** CREATE TABLE (as a scratch/sandbox table)

**Possible Solution:**
```sql
CREATE TABLE pricing_test_sandbox
(
    product_id INT,
    test_price DECIMAL(10,2)
);
```
**Business Impact:** Enables safe "what-if" analysis without any risk to 
live pricing data.

---

## Problem 8: "New account signups should start with a ₹0 balance automatically"
**Business Goal:** Ensure consistent default behavior without relying on 
every application/insert to manually specify it.
**SQL Concepts Needed:** DEFAULT constraint

**Possible Solution:**
```sql
ALTER TABLE accounts ADD balance DECIMAL(10,2) DEFAULT(0.00);
```
**Business Impact:** Prevents NULL balance errors in downstream calculations 
(e.g., a NULL balance breaking a SUM() aggregation).

---

## Problem 9: "We renamed our 'customers' concept to 'clients' company-wide — update the table name"
**Business Goal:** Align database naming with new company terminology.
**Questions to Ask:** What reports/dashboards/queries reference the old 
table name and need updating too?

**SQL Concepts Needed:** sp_rename

**Possible Solution:**
```sql
EXEC sp_rename 'customers', 'clients';
```
**Business Impact:** Consistency across systems, but requires coordinated 
updates to all dependent queries/reports — a good example of why renaming 
production objects needs careful planning.

---

## Problem 10: "Clean up all test/dummy records before go-live (score = 0, from testing phase)"
**Business Goal:** Ensure production launch starts with clean, real data only.
**SQL Concepts Needed:** DELETE with WHERE, verified with SELECT first

**Possible Solution:**
```sql
-- Step 1: ALWAYS preview first
SELECT * FROM customers WHERE score = 0;
-- Step 2: Confirm count looks right, then delete
DELETE FROM customers WHERE score = 0;
```
**Business Impact:** Prevents test/dummy data from polluting real analytics 
and customer-facing reports post-launch.