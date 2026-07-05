### Scenario 1
**Business Question:** "Show me our customers."
**What is actually being asked?** This is dangerously vague. A raw dump of all 
customers is rarely the real need.
**Beginner thinks:** `SELECT * FROM customers;` — done.
**Analyst thinks:** "Which customers? All of them? A specific segment? What 
decision will this data support? Are they asking for a report, a dashboard, or 
a one-time list for an email campaign?"
**Assumptions to avoid:** Never assume "show me X" means "return the entire raw table."
**Best Approach:** Ask 1-2 clarifying questions before running anything, even 
something as simple as SELECT *.

---

### Scenario 2
**Business Question:** "Which country has our best customers?"
**Important Metrics:** "Best" is undefined — could mean highest total score, 
highest average score, or most customers.
**Beginner thinks:** Picks one metric arbitrarily and runs with it.
**Analyst thinks:** Presents multiple angles: "By total score, Germany leads. 
But by average score per customer, USA leads. Which matters more for your decision?"
**Best Approach:** When a business term is ambiguous ("best," "top," "engaged"), 
either ask for definition or explicitly state your chosen definition in the output.

---

### Scenario 3
**Business Question:** "Find customers with score > 0."
**Beginner thinks:** Just filters score > 0, moves on.
**Analyst thinks:** "Why would score = 0? Is that a new signup with no activity 
yet, a test account, or a data entry issue?" This curiosity often surfaces real 
data quality problems.
**Common Mistake:** Treating every filter condition as purely mechanical without 
asking why that state exists in the data.

---

### Scenario 4
**Business Question:** "Give me total revenue by country" (using GROUP BY logic).
**Beginner thinks:** Writes the GROUP BY query, delivers the numbers as-is.
**Analyst thinks:** "Before I deliver, does this number look reasonable? Is one 
country wildly higher — maybe a data entry error or maybe a genuine market leader? 
I should sanity-check the results before presenting."
**How Analyst Verifies:** Compares totals against expected ballpark, checks for 
any group with abnormally high/low values.

---

### Scenario 5
**Business Question:** "How many customers do we have?"
**Beginner thinks:** `SELECT COUNT(*) FROM customers;` and reports the number confidently.
**Analyst thinks:** "Does this table have duplicates? Is this COUNT(*) or should 
I use COUNT(DISTINCT customer_id) in case of duplicate entries from data imports?"
**Best Approach:** Always sanity-check whether raw COUNT(*) truly represents 
"unique customers" — these are NOT always the same thing.

---

### Scenario 6
**Business Question:** "Sort customers by importance."
**Beginner thinks:** Picks a random column to ORDER BY.
**Analyst thinks:** "Importance to whom — sales team (score/spend) or support 
team (complaint history)? Different stakeholders define 'important' differently."
**Best Approach:** Always tie sorting logic back to WHO will use the output and WHY.

---

### Scenario 7 — Beginner vs Analyst Comparison Table

| Situation | Beginner Approach | Analyst Approach |
|-----------|-------------------|-------------------|
| "Show me sales" | Runs SELECT * immediately | Asks: sales of what, when, compared to what |
| Sees a weird outlier | Ignores it, reports as-is | Investigates: data error or real signal? |
| Gets a vague request | Guesses and starts coding | Asks 2-3 clarifying questions first |
| Delivers a number | Just states the number | States number + context + comparison |
| Finds NULL values | Deletes rows with NULLs | Investigates WHY nulls exist before deciding |

---

### Scenario 8
**Business Question:** "We have data quality issues in our customer table — investigate."
**Analyst's Investigation Checklist (Day 1 tools only):**
```sql
-- Check total row count
SELECT COUNT(*) FROM customers;

-- Check for missing scores
SELECT COUNT(*) - COUNT(score) as missing_scores FROM customers;

-- Check for duplicate-looking entries per country (proxy check)
SELECT country, COUNT(*) FROM customers GROUP BY country HAVING COUNT(*) > 1;

-- Check unique countries (sanity check for typos like 'usa' vs 'USA')
SELECT DISTINCT country FROM customers;
```
**Why this matters:** This IS the actual first-week job of many analysts — 
auditing data quality before any "real" analysis begins.

---

### Scenario 9
**Business Question:** "Give me the average customer score."
**Beginner thinks:** `SELECT AVG(score) FROM customers;` — single number, done.
**Analyst thinks:** "Is this average skewed by a few very high or very low 
scores? Should I also check the distribution (min, max) to know if 'average' 
is even a meaningful summary here?"
```sql
SELECT AVG(score), MIN(score), MAX(score) FROM customers;
```
**Best Approach:** Never present a single aggregate number without minimal 
context about the distribution's spread.

---

### Scenario 10
**Business Question:** Manager says "Sales decreased" (Classic ambiguous complaint).
**Beginner thinks:** Immediately writes SQL.
**Analyst thinks:** 
- What defines "sales" — revenue? order count? units sold?
- Decreased compared to what — last week, last month, target?
- Which product/region/segment specifically?
**Huge difference:** The beginner might spend an hour producing an answer to 
the wrong question. The analyst spends 5 minutes clarifying and then answers 
the RIGHT question correctly the first time.