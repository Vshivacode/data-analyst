### Scenario 1
**Business Question:** "Can you just add a new column to the customers table for our new loyalty tier feature?"
**Beginner thinks:** Immediately runs `ALTER TABLE customers ADD loyalty_tier VARCHAR(20);`
**Analyst thinks:** "Is this a production table other systems depend on? Will 
adding a nullable column break any existing INSERT statements that don't 
specify all columns? Should I check with the engineering team before altering 
a live table, or is this my own analytics sandbox copy?"
**Best Approach:** Distinguish between YOUR sandbox/reporting tables (freely 
alterable) vs shared production tables (requires coordination).

---

### Scenario 2
**Business Question:** "Delete all the test customers from the database."
**Beginner thinks:** Writes `DELETE FROM customers WHERE is_test = 1;` and runs it immediately.
**Analyst thinks:** "Let me first SELECT with this same WHERE clause to see 
exactly how many rows this affects and confirm they're truly test records, 
not accidentally including real customers with a similar flag."
```sql
-- Always first:
SELECT COUNT(*) FROM customers WHERE is_test = 1;
-- Only then:
DELETE FROM customers WHERE is_test = 1;
```
**Common Mistake:** Trusting a WHERE clause blindly without previewing impact — 
this single habit prevents most catastrophic DML mistakes in real jobs.

---

### Scenario 3
**Business Question:** "Update everyone's discount tier based on new business rules."
**Beginner thinks:** Runs one big UPDATE with no verification.
**Analyst thinks:** "How many rows should this affect? Let me check the count 
matches my expectation BEFORE and AFTER the update — if I expected 5,000 rows 
affected but the UPDATE reports 50,000, something's wrong with my WHERE logic."
**Best Approach:** SQL Server/most clients report "(N rows affected)" after 
DML — always sanity-check this number against your mental estimate.

---

### Scenario 4
**Business Question:** "A junior teammate accidentally ran DELETE FROM orders; with no WHERE. What do you do?"
**Beginner thinks:** Panics, doesn't know next steps.
**Analyst thinks:** "First: was this run inside a transaction that hasn't 
committed yet? If so, ROLLBACK immediately. If already committed, escalate to 
check for the most recent backup/point-in-time recovery option. Document 
exactly what happened for post-mortem — this is also a process gap (no 
safeguards) worth flagging."
**Huge difference:** This is a "how do you handle failure" thinking pattern — 
interviewers love probing this because it reveals maturity beyond syntax knowledge.

---

### Scenario 5
**Business Question:** "We need a new column but I'm not sure if we should 
make it required (NOT NULL) or optional."
**Beginner thinks:** Picks NOT NULL because it "seems safer."
**Analyst thinks:** "If I make it NOT NULL on an EXISTING table with data, 
every existing row now violates this rule unless I provide a DEFAULT or 
backfill first. I need to ask: do we have historical data for this field? 
If not, it MUST be nullable (or given a DEFAULT) initially."
**Best Approach:** Always consider EXISTING data before adding constraints — 
constraints apply retroactively and can break the ALTER statement itself.

---

### Scenario 6
**Business Question:** "The stakeholder wants a quick temporary analysis table — should you use CREATE TABLE or something else?"
**Beginner thinks:** Creates a permanent table in the main schema without much thought.
**Analyst thinks:** "This is throwaway/exploratory — should this go in a 
separate sandbox/scratch schema so it doesn't clutter production schemas or 
get mistaken for a real business table later? Should I document that it's temporary?"
**Best Approach:** Keep experimental/scratch tables clearly separated 
(naming convention like `_sandbox` or `_temp` suffix, or separate schema) 
from real business tables.

---

### Scenario 7 — Beginner vs Analyst Comparison

| Situation | Beginner Approach | Analyst Approach |
|-----------|-------------------|-------------------|
| Asked to "clean up" data | Runs DELETE immediately | Previews with SELECT first, confirms count, THEN deletes |
| Adding a new column | Just runs ALTER ADD | Checks if it's a shared/production table needing coordination |
| Updating a value | Writes UPDATE and runs it | Verifies WHERE clause row-count matches expectation before AND after |
| NULL data found | Deletes rows with NULLs | Investigates WHY nulls exist, considers UPDATE to fix instead of deleting |
| Told to "reset" a table | Uses DROP or DELETE interchangeably | Chooses correctly: DROP (remove entirely) vs TRUNCATE (fast full reset) vs DELETE (filtered reset) |

---

### Scenario 8
**Business Question:** "How would you verify a bulk INSERT of 50,000 new customer records completed successfully?"
**Analyst's Checklist:**
```sql
-- Check total row count makes sense
SELECT COUNT(*) FROM customers;

-- Check for unexpected NULLs in required fields
SELECT COUNT(*) FROM customers WHERE first_name IS NULL;

-- Spot-check a few known records from the source file
SELECT * FROM customers WHERE id IN (specific_known_ids);
```
**Why this matters:** Verification after bulk DML operations is a standard, 
expected practice — never assume success just because no error was thrown.