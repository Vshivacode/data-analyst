## Scenario 1: The First Data Pull Request
**Setting:** Your manager Slacks you: "Hey, can you pull a list of all our 
Germany customers? Need it for a call in 20 mins."

**Problem:** Time pressure + vague scope ("all customers" — active? all-time?)

**Your Responsibility:** Deliver fast AND correct.

**Step-by-Step Investigation:**
1. Quick clarifying Slack: "All Germany customers, or active ones only? 
   Need any specific columns?"
2. Manager replies: "Just names and scores, all of them, quickly."
3. Write and run:
```sql
SELECT first_name, score FROM customers WHERE country = 'Germany';
```
4. Sanity check row count before sending (`SELECT COUNT(*) FROM customers 
   WHERE country = 'Germany';`) — if it returns 0 or an unexpectedly huge 
   number, investigate before sending.

**Communication with Team:** Reply in Slack: "Here's the list — 45 customers 
from Germany with names and scores. Let me know if you need more fields."

**Final Report:** Attach as CSV/screenshot, not raw terminal output.

**Lessons Learned:** Even a "quick" request deserves a 10-second sanity check 
before sending — wrong data delivered fast is worse than correct data delivered 
2 minutes later.

---

## Scenario 2: The "Why Doesn't My Query Work" Debug Session
**Setting:** You write this query and get an error:
```sql
SELECT first_name, country, SUM(score) as total_score
FROM customers
GROUP BY country;
```
**Problem:** Error: "column customers.first_name must appear in GROUP BY clause 
or be used in an aggregate function"

**Your Responsibility:** Debug independently before asking for help.

**Step-by-Step Investigation:**
1. Recall the GROUP BY rule: every SELECT column must be aggregated or grouped.
2. Recognize `first_name` is neither.
3. Decide: Do I need first_name per row (then don't GROUP BY), or do I need it 
   removed (then it's a clean country-level summary)?
4. Fix:
```sql
SELECT country, SUM(score) as total_score
FROM customers
GROUP BY country;
```

**Communication with Team:** If still stuck after 10 minutes, ask a senior 
analyst with the SPECIFIC error message and what you've already tried — not 
just "my query doesn't work."

**Lessons Learned:** Reading the actual error message carefully (not panicking) 
solves 80% of beginner SQL errors.

---

## Scenario 3: Data Looks Wrong — Who Do You Tell?
**Setting:** You run `SELECT COUNT(*) FROM customers;` and get 5 rows, but 
your manager mentioned "we have thousands of customers."

**Problem:** Discrepancy between expected and actual results.

**Your Responsibility:** Investigate before assuming either the data or the 
manager is "wrong."

**Step-by-Step Investigation:**
1. Confirm you're connected to the right database/schema (`USE correct_db;`)
2. Check if this is a sample/test table vs production table
3. Check with a teammate: "Is `customers` in this schema the full production 
   table, or a sample dataset?"

**Communication with Team:** "I'm seeing only 5 rows in the customers table — 
is this the right table, or should I be looking at a different schema/database?"

**Final Report:** Once resolved, document which database/schema is correct 
for future reference (add to your own notes).

**Lessons Learned:** Always validate you're querying the RIGHT source before 
assuming data itself is broken.

---

## Scenario 4: Being Asked to Explain Your Query to a Non-Technical Manager
**Setting:** You send this query's results to your manager, who asks 
"How did you get these numbers?"

**Your Responsibility:** Explain SQL logic in plain English.

**Grandma/Manager-Friendly Explanation:**
"I asked the database to group all customers by their country, then add up 
all their scores within each group, and only show me the countries where that 
total was above 750 — think of it like sorting a big pile of receipts into 
country-labeled bins, then adding up each bin, and keeping only the big bins."

**Lessons Learned:** Being able to explain SQL logic WITHOUT saying "GROUP BY" 
or "HAVING" is a critical communication skill that differentiates analysts.

---

## Scenario 5: Conflicting Priorities
**Setting:** Marketing asks for the German customer list (Scenario 1) at the 
same time Finance asks for total revenue by country.

**Your Responsibility:** Prioritize and communicate timeline transparently.

**Step-by-Step:**
1. Assess effort: German list = 2 min query. Revenue by country = need to 
   check if you even have access to a revenue/orders table yet.
2. Do the quick win first (German list), then tell Finance: "I can get you 
   revenue by country in 15 minutes."

**Communication with Team:** "I'll get the Germany list to Marketing right 
now (quick), then start on the revenue analysis for Finance — expect that 
in about 15 minutes."

**Lessons Learned:** Communicate sequencing and timing proactively — 
stakeholders hate silence more than a short wait.