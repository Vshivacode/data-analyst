## Scenario 1: The "Quick Add a Column" Request
**Setting:** Product manager Slacks: "Hey, can you add a 'preferred_language' 
column to the customers table? Need it by EOD."

**Your Responsibility:** Execute safely and confirm.

**Step-by-Step Investigation:**
1. Ask: "Is this for the production customers table, or should I add it to a 
   reporting copy?" (assume they say production, but coordinate with engineering)
2. Check current row count and whether NOT NULL would cause issues:
```sql
SELECT COUNT(*) FROM customers;
```
3. Add nullable to avoid breaking anything:
```sql
ALTER TABLE customers ADD preferred_language VARCHAR(20);
```
4. Verify:
```sql
EXEC sp_help customers;
```

**Communication with Team:** "Added `preferred_language` (nullable VARCHAR(20)) 
to customers table. Existing rows will show NULL until populated — let me 
know if you want a default value instead."

**Lessons Learned:** Always default to non-breaking changes (nullable columns) 
unless explicitly required otherwise.

---

## Scenario 2: The Accidental Mass Update Near-Miss
**Setting:** You're about to run:
```sql
UPDATE customers SET status = 'inactive' WHERE last_login < '2023-01-01'
```
But you notice you forgot to add the date filter and almost ran it without WHERE.

**Your Responsibility:** Catch this BEFORE execution, not after.

**Step-by-Step Investigation:**
1. Before running ANY UPDATE/DELETE, re-read your own query out loud.
2. Run the SELECT version first:
```sql
SELECT COUNT(*) FROM customers WHERE last_login < '2023-01-01';
```
3. Sanity check: "Does this number (e.g., 340 customers) match what I'd expect 
   for inactive users?" If it returns the ENTIRE customer count, something's wrong.
4. Only then run the UPDATE.

**Lessons Learned:** This "SELECT before UPDATE/DELETE" habit should become 
automatic — treat it as a non-negotiable checklist item, every single time.

---

## Scenario 3: Explaining a Data Correction to a Stakeholder
**Setting:** You find 200 customer records with incorrect country values 
(data entry error from an old import) and need to fix them.

**Your Responsibility:** Fix the data AND communicate transparently.

**Step-by-Step:**
1. Investigate scope:
```sql
SELECT country, COUNT(*) FROM customers WHERE country = 'Unknown' GROUP BY country;
```
2. Fix with precise UPDATE:
```sql
UPDATE customers SET country = 'India' WHERE country IS NULL AND phone LIKE '+91%';
```
3. Communicate: "I found and corrected 200 customer records where country 
   was missing but could be inferred from their phone number's country code. 
   These are now properly categorized under India."

**Lessons Learned:** Data corrections should always be explained with WHAT 
was wrong, HOW you fixed it, and HOW MANY records were affected — builds trust.

---

## Scenario 4: Being Asked "Can You Just Delete These Old Records?"
**Setting:** Manager says: "We don't need orders older than 2020 anymore, 
just delete them."

**Your Responsibility:** Push back appropriately before executing something irreversible.

**Step-by-Step:**
1. Ask clarifying/protective questions: "Before I delete — do we need these 
   for any compliance/audit/tax purposes? Should I archive them to a backup 
   table first instead of permanently deleting?"
2. Propose safer alternative:
```sql
-- Archive first
SELECT * INTO orders_archive_pre2020 FROM orders WHERE order_date < '2020-01-01';
-- Then delete from main table
DELETE FROM orders WHERE order_date < '2020-01-01';
```
3. Get explicit confirmation before running the DELETE.

**Communication with Team:** "I've archived the pre-2020 orders to a backup 
table (`orders_archive_pre2020`) before deleting them from the main table — 
just in case we need them for compliance later. Let me know if that approach works."

**Lessons Learned:** Good analysts push back (respectfully) on irreversible 
requests and suggest safer alternatives — this is expected professional behavior, not overstepping.

---

## Scenario 5: Debugging Why an INSERT Failed
**Setting:** Your INSERT statement throws an error: "Cannot insert the value 
NULL into column 'phone', table 'persons'; column does not allow nulls."

**Your Responsibility:** Debug independently.

**Step-by-Step Investigation:**
1. Read the error message carefully — it tells you EXACTLY which column and 
   why (`phone` doesn't allow NULL).
2. Check your INSERT statement — did you forget to provide a phone value?
3. Fix: either provide a valid phone value, or reconsider if `phone` should 
   really be NOT NULL for this use case.

**Lessons Learned:** SQL error messages are usually precise and instructive — 
read them fully before asking for help or guessing at random fixes.