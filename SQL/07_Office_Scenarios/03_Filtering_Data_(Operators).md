## Scenario 1: The Silently Empty Report
**Setting:** You built a churn report using `WHERE customer_id NOT IN 
(SELECT customer_id FROM active_subscriptions)`. Your manager says "This 
report shows 0 churned customers — that can't be right, we know we've lost people."

**Your Responsibility:** Debug the discrepancy, not just report "0 rows" as fact.

**Step-by-Step Investigation:**
1. Check if `active_subscriptions.customer_id` contains any NULLs:
```sql
SELECT COUNT(*) FROM active_subscriptions WHERE customer_id IS NULL;
```
2. Found: 3 NULL rows (data entry gaps). This is silently breaking your NOT IN.
3. Fix:
```sql
WHERE customer_id NOT IN (
    SELECT customer_id FROM active_subscriptions WHERE customer_id IS NOT NULL
)
```
4. Re-run and verify results now make sense.

**Communication with Team:** "Found the issue — our active_subscriptions 
table had a few NULL customer_ids which broke the NOT IN filter completely. 
Fixed it, and now the churn report correctly shows 47 churned customers this month."

**Lessons Learned:** This EXACT bug pattern is common enough that experienced 
analysts check for it BY DEFAULT whenever a NOT IN query looks suspiciously wrong.

---

## Scenario 2: The Ambiguous Filter Request
**Setting:** Sales manager says: "Show me our 'big' customers."

**Your Responsibility:** Don't guess — clarify before writing any SQL.

**Step-by-Step:**
1. Ask: "Big by total spend, order frequency, or account size (number of 
   seats/users)? And what threshold counts as 'big' in your mind?"
2. Manager clarifies: "Total spend above ₹1 lakh this year."
3. Write precisely:
```sql
SELECT * FROM customers WHERE annual_spend > 100000;
```

**Communication with Team:** Confirm your interpretation before sending 
final results: "Just confirming — 'big' means total annual spend over ₹1 lakh, 
correct? Here's that list of 234 customers."

**Lessons Learned:** 30 seconds of clarification prevents delivering the 
wrong analysis and having to redo work.

---

## Scenario 3: Explaining Why a Query Was Slow
**Setting:** Your query using `WHERE product_name LIKE '%wireless%'` on a 
5-million row table takes 45 seconds, and your manager asks why it's so slow.

**Your Responsibility:** Explain the technical cause in accessible terms and 
propose next steps.

**Your Explanation:** "This search pattern needs to check every single row 
individually because we're searching for 'wireless' that could appear 
ANYWHERE in the product name — the database can't use its normal shortcuts 
(indexes) for this kind of search. If this becomes a frequent need, I'd 
recommend we look into a proper search feature designed for this, rather than 
running this pattern against the full table each time."

**Lessons Learned:** Being able to explain WHY something is slow (not just 
that it is) builds credibility and sets realistic expectations.

---

## Scenario 4: Catching a Logic Bug Before It Ships
**Setting:** You're reviewing a teammate's query before it goes into a 
scheduled daily report:
```sql
WHERE country = 'usa' OR country = 'uk' AND score > 500
```

**Your Responsibility:** Spot the operator precedence issue during review.

**Your Feedback:** "Quick catch — this currently means 'usa customers 
regardless of score, OR uk customers with score > 500' because AND evaluates 
before OR. If you meant 'usa or uk customers, both needing score > 500,' you'll 
need parentheses: `(country = 'usa' OR country = 'uk') AND score > 500`. 
Which did you intend?"

**Lessons Learned:** Peer review of filter logic (especially mixed AND/OR) 
catches silent bugs before they reach production reports — a genuinely 
valuable skill to develop and offer to teammates.

---

## Scenario 5: The "Quick Search" That Wasn't So Quick
**Setting:** Support team asks: "Can you quickly find any customer whose 
email might be fake or a typo (like missing the @ symbol)?"

**Your Responsibility:** Deliver a reasonable first pass while being clear 
about limitations.

**Step-by-Step:**
```sql
SELECT * FROM customers WHERE email NOT LIKE '%@%';
```
**Communication with Team:** "Here's a quick first-pass list of emails missing 
the @ symbol entirely (23 records) — this catches obvious errors, but won't 
catch more subtle typos like 'gmial.com' instead of 'gmail.com'. Let me know 
if you want a more thorough check."

**Lessons Learned:** Deliver value quickly, but be transparent about what your 
quick solution does and doesn't cover — manages expectations honestly.