### Scenario 1
**Business Question:** "Exclude our test accounts from this report."
**Beginner thinks:** Writes `WHERE is_test != 1` and moves on.
**Analyst thinks:** "Could `is_test` be NULL for some legitimate rows (maybe 
older records predate this flag)? If so, `!= 1` might unintentionally exclude 
real customers whose flag was never set. Let me check for NULLs in this column first."
```sql
SELECT COUNT(*) FROM customers WHERE is_test IS NULL;
```
**Best Approach:** Before trusting any exclusion filter, verify the column's 
NULL behavior — this single habit prevents silently wrong reports.

---

### Scenario 2
**Business Question:** "Show me customers NOT in our blocked list."
**Beginner thinks:** Immediately writes `WHERE customer_id NOT IN (SELECT 
customer_id FROM blocked_list)`.
**Analyst thinks:** "Is there any chance the blocked_list subquery returns a 
NULL customer_id? If even one row has NULL, this ENTIRE query could return 
zero rows — a silent, dangerous failure. Let me verify first, or use a safer NOT EXISTS pattern."
**Common Mistake:** Trusting NOT IN blindly without considering NULL 
contamination — this is precisely the kind of "when to use what and why" 
thinking that separates confident analysts from syntax-memorizers.

---

### Scenario 3
**Business Question:** "Find customers with names similar to 'Jon' (might be 
typos of 'John')."
**Beginner thinks:** Writes `WHERE first_name = 'Jon'` — misses actual typo variants.
**Analyst thinks:** "The business wants FUZZY matching, not exact matching. 
I should use LIKE with wildcards, or even consider this might need more 
advanced fuzzy-matching techniques (SOUNDEX, Levenshtein distance) beyond 
today's toolkit — but for now, LIKE '%jo_n%' style patterns get me partway there."
**Best Approach:** Recognize when a business request implies "fuzzy" or 
"approximate" needs — this signals moving from `=` toward `LIKE` or beyond.

---

### Scenario 4
**Business Question:** "Give me a report of orders priced 'around' ₹1000."
**Beginner thinks:** Uses `WHERE amount = 1000` — misses everything except exact matches.
**Analyst thinks:** "'Around' is vague — I should clarify or make a reasonable 
assumption, like a ±10% range, and clearly state that assumption in my report."
```sql
SELECT * FROM orders WHERE amount BETWEEN 900 AND 1100;
-- Report note: "Interpreted 'around ₹1000' as a ±10% range (₹900-₹1100)"
```
**Best Approach:** When a request uses vague qualifiers ("around," "roughly," 
"similar to"), either clarify with the stakeholder or make and DOCUMENT a 
reasonable assumption.

---

### Scenario 5
**Business Question:** "Why does my report show fewer results than expected 
after I added a NOT IN filter?"
**Beginner thinks:** Assumes their business logic itself is wrong, starts 
second-guessing the filter criteria.
**Analyst thinks:** "Before questioning my business logic, let me first rule 
out the classic NOT IN + NULL technical gotcha — that's a far more common 
cause of unexpectedly empty/reduced results than incorrect business logic."
**Huge difference:** This is diagnostic thinking — checking the KNOWN 
technical gotcha before assuming a deeper business logic error.

---

### Scenario 6
**Business Question:** "Find high-value AND high-engagement customers OR 
any VIP-flagged customer, regardless of score."
**Beginner thinks:** Writes `WHERE score > 800 AND engagement > 90 OR is_vip = 1` 
without parentheses — doesn't realize operator precedence changes the meaning.
**Analyst thinks:** "This sentence has TWO possible groupings depending on 
intent. Without parentheses, SQL will evaluate AND before OR, which might not 
match what the business actually meant. Let me write it explicitly."
```sql
WHERE (score > 800 AND engagement > 90) OR is_vip = 1
```
**Best Approach:** ALWAYS use parentheses when mixing AND/OR — never rely on 
implicit operator precedence, even if you know the rule, because it's a 
silent bug magnet for anyone maintaining the query later.

---

### Scenario 7 — Beginner vs Analyst Comparison Table

| Situation | Beginner Approach | Analyst Approach |
|-----------|-------------------|-------------------|
| Excluding a list of values | Uses NOT IN blindly | Checks for NULLs in the list first |
| Vague filtering request ("around X") | Uses exact `=` match | Clarifies or documents a reasonable range assumption |
| Mixing AND/OR | Writes them without parentheses | Always adds parentheses to make intent explicit |
| Pattern/typo matching needed | Uses exact `=` and misses variants | Recognizes need for LIKE or flags need for fuzzy matching |
| Unexpectedly empty result set | Assumes business logic is wrong | Checks known technical gotchas (NULL handling) first |

---

### Scenario 8
**Business Question:** "Investigate why our NOT IN exclusion query returns 0 rows."
**Analyst's Diagnostic Checklist:**
```sql
-- Step 1: Check the exclusion list source for NULLs
SELECT COUNT(*) FROM blocked_list WHERE customer_id IS NULL;

-- Step 2: If NULLs exist, fix the subquery
SELECT * FROM customers
WHERE customer_id NOT IN (
    SELECT customer_id FROM blocked_list WHERE customer_id IS NOT NULL
);

-- Step 3: Verify row count now makes sense
SELECT COUNT(*) FROM customers WHERE customer_id NOT IN (...);
```
**Why this matters:** This exact debugging sequence is what separates an 
analyst who can independently resolve a "silently wrong report" bug from one 
who escalates every issue without investigation.