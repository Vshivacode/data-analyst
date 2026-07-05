### Q1: What's the difference between `=` and `LIKE`?
**Simple Answer:** `=` requires an exact match; `LIKE` allows pattern matching with wildcards.

**Detailed Answer:** `=` compares two values for exact equality — the entire 
string must match precisely. `LIKE` allows partial matching using `%` 
(any number of characters) and `_` (exactly one character), making it suitable 
for searches where you don't know the exact full value.

**Example:** `WHERE name = 'John'` matches only exactly "John". `WHERE name 
LIKE 'Jo%'` matches "John", "Joseph", "Jordan", etc.

**Follow-up:** "Is LIKE always slower than =?" → Generally yes, especially 
with leading wildcards (`%value`), since it often can't use an index efficiently.

**Common Mistake:** Using LIKE without wildcards (`LIKE 'John'`) — this 
behaves identically to `=` but is misleading/less efficient in some engines.

**Difficulty:** ⭐

---

### Q2: Explain the danger of using `NOT IN` with a list or column that might contain NULL.
**Simple Answer:** If any value in the comparison list is NULL, `NOT IN` can silently return zero rows.

**Detailed Answer:** SQL uses three-valued logic (TRUE/FALSE/UNKNOWN). When 
evaluating `NOT IN (1, 2, NULL)`, for any row not equal to 1 or 2, SQL must 
also evaluate `<> NULL`, which returns UNKNOWN — and UNKNOWN combined with AND 
logic (which is how NOT IN expands internally) causes the entire row to be 
excluded, even if it logically shouldn't be.

**Example:**
```sql
-- If category_id column contains a NULL anywhere in this subquery's result,
-- this ENTIRE query can return 0 rows unexpectedly:
SELECT * FROM products WHERE category_id NOT IN (SELECT category_id FROM discontinued);
```

**Follow-up:** "What's the safer alternative?" → Use `NOT EXISTS` with a 
correlated subquery, which handles NULLs correctly.

**Common Mistake:** Not knowing this gotcha exists until debugging a 
"mysteriously empty result set" in production.

**Difficulty:** ⭐⭐⭐⭐ (This is a classic senior-level gotcha question)

---

### Q3: What does BETWEEN include — is it inclusive or exclusive?
**Simple Answer:** Inclusive on both ends.

**Detailed Answer:** `WHERE score BETWEEN 100 AND 500` includes rows where 
score is exactly 100 AND exactly 500, plus everything in between. This is 
functionally identical to `score >= 100 AND score <= 500`.

**Example:** A customer with score=500 IS included in `BETWEEN 100 AND 500`.

**Follow-up:** "How would you write an EXCLUSIVE range (100 to 500, not 
including either endpoint)?" → `WHERE score > 100 AND score < 500` (can't use 
BETWEEN directly for exclusive ranges).

**Difficulty:** ⭐⭐

---

### Q4: What's the difference between `IN` and multiple `OR` conditions?
**Simple Answer:** They're functionally equivalent, but IN is cleaner and more readable.

**Detailed Answer:** `WHERE country IN ('usa', 'germany')` produces the same 
result as `WHERE country = 'usa' OR country = 'germany'`. IN is preferred for 
readability, especially with longer lists, and most query optimizers treat 
them similarly in terms of performance for small-to-medium lists.

**Follow-up:** "At what point might IN with a huge list become a performance concern?" 
→ With thousands of hardcoded values, consider using a JOIN against a lookup 
table instead.

**Difficulty:** ⭐⭐

---

### Q5: Explain each LIKE wildcard and give an example of combining them.
**Simple Answer:** `%` matches any number of characters (including zero); `_` matches exactly one character.

**Detailed Answer:**
```sql
'%a'    -- ends with 'a', any length before
'a%'    -- starts with 'a', any length after
'%a%'   -- contains 'a' anywhere
'_a'    -- exactly 2 chars, 2nd is 'a'
'_a%'   -- 2nd char is 'a', any length after (min 2 chars total)
'__r%'  -- 3rd character is 'r', any length after (min 3 chars total)
```

**Follow-up:** "How would you find names exactly 5 characters long?" → 
`WHERE name LIKE '_____'` (five underscores, no percent sign).

**Common Mistake:** Confusing `_` (single character) with `%` (any number 
of characters) — a very common Day 1 SQL mixup.

**Difficulty:** ⭐⭐

---

### Q6: Why might `LIKE '%value%'` be slow on a large table, and what would you do about it?
**Simple Answer:** Leading wildcards prevent index usage, forcing a full table scan.

**Detailed Answer:** B-tree indexes (the standard index type) work by 
sorting/organizing data based on the beginning of a string. A pattern like 
`'%value'` or `'%value%'` requires scanning every row because the match could 
start anywhere — the index can't help "jump" to the right starting point.

**Example:** `LIKE 'John%'` (no leading wildcard) CAN use an index. `LIKE 
'%John'` cannot.

**Follow-up:** "What alternative exists for large-scale text search?" → 
Full-text search indexes (a more advanced database feature) designed 
specifically for this use case.

**Difficulty:** ⭐⭐⭐⭐

---

### Q7: What is the logical difference between AND and OR, and how do they affect result set size?
**Simple Answer:** AND narrows results (all conditions must match); OR broadens results (any condition matches).

**Detailed Answer:** Adding more AND conditions typically returns fewer or 
equal rows (stricter filtering). Adding more OR conditions typically returns 
more or equal rows (broader matching).

**Example:**
```sql
WHERE country = 'usa' AND score > 500   -- fewer rows (both must be true)
WHERE country = 'usa' OR score > 500    -- more rows (either can be true)
```

**Follow-up:** "What happens if you mix AND and OR without parentheses?" → 
SQL follows operator precedence (AND evaluates before OR), which can produce 
unexpected results — always use parentheses to make intent explicit.

**Difficulty:** ⭐⭐⭐

---

### Q8: How would you write a query using NOT that's equivalent to a comparison operator, and why might you prefer one over the other?
**Simple Answer:** `NOT score < 500` is equivalent to `score >= 500` — prefer the positive form for readability.

**Detailed Answer:** Both are functionally identical, but negated conditions 
(`NOT ... <`) require an extra mental "flip" to understand, while direct 
positive comparisons (`>=`) are immediately clear. Professional SQL style 
generally favors direct comparisons over NOT-wrapped ones when a direct 
equivalent exists.

**Follow-up:** "When would NOT be necessary (no direct equivalent exists)?" 
→ When negating complex expressions or subqueries where there's no simple 
inverse operator, e.g., `WHERE NOT (country = 'usa' AND score > 500)`.

**Difficulty:** ⭐⭐

---

### Q9: A junior analyst writes `WHERE country != 'Germany' AND country != 'USA'` to exclude two countries. Rewrite this more cleanly, and explain why the original works.
**Simple Answer:** Rewrite using `NOT IN ('Germany', 'USA')` — cleaner and equivalent (assuming no NULLs).

**Detailed Answer:**
```sql
-- Original (verbose but correct if country is never NULL):
WHERE country != 'Germany' AND country != 'USA'

-- Cleaner equivalent:
WHERE country NOT IN ('Germany', 'USA')
```
Both work identically here because AND-chained `!=` conditions are exactly 
what NOT IN expands into internally.

**Follow-up:** "Would you recommend either version if `country` could be NULL?" 
→ Neither NOT IN nor chained != correctly includes/excludes NULL rows as 
you might expect — NULL rows are dropped from the result in both cases 
because comparing to NULL yields UNKNOWN.

**Difficulty:** ⭐⭐⭐

---

### Q10: Write a query to find customers whose first name has exactly 4 characters and starts with 'J'.
**Answer:**
```sql
SELECT * FROM customers WHERE first_name LIKE 'J___';
```
**Explanation:** One `J` character followed by exactly 3 underscores (each 
representing exactly one more character) = exactly 4 characters total, 
starting with J.

**Follow-up:** "How would you modify this for 'starts with J, any length'?" 
→ `LIKE 'J%'`

**Difficulty:** ⭐⭐

---

### Q11 (Real Company Style — Fintech): Find all transactions where the amount is between ₹1000 and ₹50000, EXCLUDING transactions from 'blocked_country_list'.
**Answer:**
```sql
SELECT * FROM transactions
WHERE amount BETWEEN 1000 AND 50000
  AND country NOT IN (SELECT country FROM blocked_country_list);
```
**Interviewer Expectation:** Tests combining BETWEEN + NOT IN with subquery 
awareness (and potentially probes if candidate knows the NULL risk in NOT IN).
**Confidence Tip:** Proactively mention: "I'd also verify the blocked_country_list 
subquery never returns NULL values, since that could cause this to silently 
return zero rows."

**Difficulty:** ⭐⭐⭐⭐

---

### Q12: What's the operator precedence issue with mixing AND/OR, and how do you avoid it?
**Simple Answer:** AND binds tighter than OR — always use parentheses when mixing them.

**Detailed Answer:**
```sql
-- Ambiguous intent, relies on precedence:
WHERE country = 'usa' OR country = 'uk' AND score > 500
-- SQL evaluates AND first:
-- = country = 'usa' OR (country = 'uk' AND score > 500)
-- This means ALL usa customers qualify regardless of score!

-- Explicit, safer:
WHERE (country = 'usa' OR country = 'uk') AND score > 500
```

**Follow-up:** "Why does this matter in real business logic?" → Silent 
incorrect results are worse than errors — this bug could inflate/deflate a 
report without anyone noticing until numbers look "off."

**Difficulty:** ⭐⭐⭐⭐

---

### Q13: How do you find records with a NULL value using comparison operators — does `= NULL` work here too?
**Simple Answer:** No — `= NULL` never works; always use `IS NULL`.

**Detailed Answer:** This applies universally across ALL operators discussed 
today — comparison operators, IN lists, everything. NULL represents "unknown," 
and no comparison operator can evaluate equality against an unknown value as TRUE.

**Difficulty:** ⭐⭐ (Reinforcement from Day 2)

---

### Q14: Explain how you'd search for a phone number pattern like "starts with +91, followed by exactly 10 digits" using LIKE.
**Simple Answer:** `LIKE '+91__________'` (+91 followed by 10 underscores).

**Detailed Answer:** Since `_` represents exactly one character, chaining 
10 underscores after the literal `+91` prefix ensures exactly 10 characters 
follow — useful for basic format validation (though LIKE can't verify they're 
digits specifically — that would need a different function or regex).

**Follow-up:** "What's a limitation of this approach?" → LIKE with `_` 
confirms character COUNT and position but not character TYPE (could still 
match letters, not just digits).

**Difficulty:** ⭐⭐⭐

---

### Q15: When would you choose BETWEEN over separate >= and <= conditions, if they're functionally identical?
**Simple Answer:** BETWEEN is purely a readability/style choice — pick one convention and be consistent.

**Detailed Answer:** There's no meaningful performance difference between the 
two in modern query optimizers. Team code style guides often mandate one over 
the other. Some argue explicit `>=` / `<=` is clearer especially for date 
ranges where inclusivity assumptions can be tricky.

**Follow-up:** "Is there a case where they're NOT equivalent?" → With certain 
datetime edge cases where BETWEEN's inclusive upper bound may unexpectedly 
include/exclude time-of-day components — always test datetime BETWEEN carefully.

**Difficulty:** ⭐⭐⭐