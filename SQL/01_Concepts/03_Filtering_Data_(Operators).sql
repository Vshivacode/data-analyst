-- filtering data 
-- comparison operators 
-- =
-- >
-- <
-- >=
-- <=
-- != 


-- logical operators
-- and
-- or
-- not

-- range operators 
-- between 


-- membership operators 
-- in 
-- not in 

-- search operator 
-- like 


-- comparison operatos
-- it is used to compare the two values and the operators are used with the where clause
-- syntax - expression operator expression
-- here expression can be:
-- column1 = column2,  ex: firstname = lastname
-- column1 = 'value',  ex: firstname = 'john'
-- function = value,  ex: sum(score) = 1000
-- expression = value,  ex: price * quantity = 1000
-- subquery = value,  ex: select sum(score) from customers = 1000




-- = operator
-- it checks whether two values are equal 
select * from customers where country = 'germany'  -- does not follow case sensitive

-- != or <>  both symbols works 
-- it checks whether two values are not equal 
select * from customers where country != 'Germany'  -- shows all the data excluding the germany
select * from customers where country <> 'Germany'


-- > greater than 
-- it checks whether the value is greater than another value
select * from customers where score > 400

-- < 
-- it checks whether the value is less than another value
select * from customers where score < 400


-- >=
-- it checks whether the value is greater or equal to than another value
select * from customers where score >= 500

-- <=
-- it checks whether the value is less than or equal to than another value
select * from customers where score <= 500



-- logical operators 
-- and -  all the conditions must be true

-- sql task - retrieve all customers whose score is greater than 500 and country is usa
select * from customers where country = 'usa' and score > 500

-- or    atleast one of the condition must true 
-- sql task - retrieve all customers whose score is greater than 500 or country is usa
select * from customers where country = 'usa' or score > 500


-- not it excludes the matching values, so it will not show the values which is fulfilling the condition

-- sql task - retrieve all the customers whose score not < 500
select * from customers where not score < 500  -- we prefer to use this 
-- or we can do this 
select * from customers where score !< 500


-- between 
-- it checks whether the value is inside the range or outside the range and it includes the values mentioned in the range

-- sql task - retrieve all the customers whose score range between 100 and 500
select * from customers where score between 100 and 500
-- or we can do this 
select * from customers where score >= 100 and score <=1000   -- we prefer this



-- in   
-- same as or operator, so it checks whether the values are present in the list or not

-- sql task - retreive all the customers whose countries are usa or germany
-- previously we did like this 
select * from customers where country = 'germany' or country = 'usa'
-- but we can do this in simpler version using 'in' operator 
select * from customers where country in ('usa', 'germany')


-- not in  so it checks whether the values are not present in the list
select * from customers where country not in ('germany', 'usa')

select * from customers where country != 'germany' and country != 'usa'





-- like 
-- % means many characters will come, and it will treat empty spaces as characters so if we have any empty space that will be treated as one character 
-- _ underscore means only one character will come, and we can use multiple underscores to specify the position and it will treat empty spaces as characters so if we have any empty space that will be treated as one character  
-- %a  means starts with any characters or many characters but needs to end with the letter 'a'
-- _a means only one character will come at starting of the word and ends with letter 'a'
-- _a% so start with any one letter but the second letter to be 'a' and after that any characters can come
-- %s%  means anything comes before and after dont care s needs to be present so 
-- ex:  sam,  mas,  asm,   s ,   all are true even before and after dont have the letters 
-- but _s_  this means one letter must be included at starting and ending so asm, msa will be true and other are false  
-- so many combinations we can do 

-- name starts with 'm'
select * from customers where first_name like 'm%'

-- name ends with 'n'
select * from customers where first_name like '%n'

-- name contains 'r'
select * from customers where first_name like '%r%'

-- find all the customers whose firstname has 'r' in the third position
select * from customers where first_name like '__r%'   -- we can use multiple underscore to find the matching patterns 






-----------------    FORMATED NOTES ----------

## Definition
Filtering operators are the building blocks placed inside a WHERE (or HAVING) 
clause to determine exactly which rows qualify for a result set. They fall 
into 5 categories: Comparison, Logical, Range, Membership, and Search operators.

## What is it?
- **Comparison:** `=`, `!=`/`<>`, `>`, `<`, `>=`, `<=` — compare two expressions
- **Logical:** `AND`, `OR`, `NOT` — combine or negate conditions
- **Range:** `BETWEEN...AND` — checks if a value falls inside a range (inclusive)
- **Membership:** `IN`, `NOT IN` — checks if a value exists in a list
- **Search:** `LIKE` — pattern matching using wildcards (`%`, `_`)

## Why do we need it?
Raw data is rarely useful in full. Every real business question ("customers 
from USA," "orders above ₹500," "products starting with 'Sam'") requires 
precise filtering. These operators are the vocabulary for expressing 
"which rows matter" in every possible way a business question can be phrased.

## Problem it solves
- Comparing exact/relative values (comparison operators)
- Combining multiple business conditions at once (logical operators)
- Expressing "within a range" cleanly instead of two separate conditions (BETWEEN)
- Avoiding long chains of OR when checking multiple exact values (IN)
- Searching for partial/pattern matches when exact values aren't known (LIKE)

## How does it work? (Internal Working)

### Comparison Operators
```sql
SELECT * FROM customers WHERE country = 'germany';   -- NOT case-sensitive by default (collation-dependent)
SELECT * FROM customers WHERE country != 'Germany';  -- or <>
SELECT * FROM customers WHERE score > 400;
SELECT * FROM customers WHERE score >= 500;
```
**Important nuance:** Case sensitivity in string comparison depends on the 
database's **collation** setting — SQL Server default collations are usually 
case-insensitive, but PostgreSQL is case-sensitive by default. Never assume — verify per environment.

### Logical Operators
```sql
-- AND: ALL conditions must be true
SELECT * FROM customers WHERE country = 'usa' AND score > 500;

-- OR: AT LEAST ONE condition must be true
SELECT * FROM customers WHERE country = 'usa' OR score > 500;

-- NOT: negates/excludes the matching condition
SELECT * FROM customers WHERE NOT score < 500;
-- Equivalent to score >= 500, but NOT can wrap ANY condition, not just comparisons
```
**Why prefer `NOT score < 500` readability discussion:** Some prefer explicit 
positive logic (`score >= 500`) over negation (`NOT score < 500`) because 
negated conditions are harder to read at a glance — this is a code-readability 
best practice, not a functional difference.

### BETWEEN (Range Operator)
```sql
SELECT * FROM customers WHERE score BETWEEN 100 AND 500;
-- Equivalent, more explicit version:
SELECT * FROM customers WHERE score >= 100 AND score <= 500;
```
**Critical fact:** BETWEEN is **inclusive** on both ends — 100 and 500 themselves 
ARE included in the result.

### IN / NOT IN (Membership Operators)
```sql
-- Cleaner alternative to multiple ORs
SELECT * FROM customers WHERE country IN ('usa', 'germany');
-- Equivalent to:
SELECT * FROM customers WHERE country = 'usa' OR country = 'germany';

-- NOT IN excludes all listed values
SELECT * FROM customers WHERE country NOT IN ('germany', 'usa');
-- Equivalent to:
SELECT * FROM customers WHERE country != 'germany' AND country != 'usa';
```
**Key mental model:** IN chains are OR logic; NOT IN chains are AND logic 
(when expanded manually) — this trips up many beginners.

**⚠️ NOT IN + NULL danger (critical, often missed on Day 3):** If the list or 
column involved contains a NULL, `NOT IN` can silently return ZERO rows 
unexpectedly, because comparing anything to NULL yields UNKNOWN, not TRUE/FALSE. 
Always be cautious using NOT IN on columns that might contain NULLs.

### LIKE (Search/Pattern Operator)
```sql
-- % = zero or more characters (any length, including empty)
SELECT * FROM customers WHERE first_name LIKE 'm%';   -- starts with 'm'
SELECT * FROM customers WHERE first_name LIKE '%n';   -- ends with 'n'
SELECT * FROM customers WHERE first_name LIKE '%r%';  -- contains 'r' anywhere

-- _ = exactly one character
SELECT * FROM customers WHERE first_name LIKE '__r%'; -- 'r' is the 3rd character
```

**Wildcard reference table:**
| Pattern | Meaning |
|---------|---------|
| `m%` | Starts with 'm' |
| `%n` | Ends with 'n' |
| `%r%` | Contains 'r' anywhere |
| `_a` | Exactly 2 characters, 2nd is 'a' |
| `_a%` | 2nd character is 'a', any length after |
| `%s%` | Contains 's' anywhere (before/after can be empty) |
| `_s_` | Exactly 3 characters, middle is 's' |
| `__r%` | 'r' is exactly the 3rd character, any length after |

**Important nuance:** `%` and `_` treat literal spaces as real characters — 
a trailing space in stored data can cause a pattern like `'john'` (exact match) 
to fail while `'john%'` succeeds, since `%` absorbs the extra space.

## Advantages
- Highly expressive — nearly any business filtering logic can be built from 
  these 5 operator categories combined
- IN and BETWEEN significantly improve readability over long OR/AND chains
- LIKE enables flexible search without needing exact string matches

## Disadvantages
- LIKE with a leading `%` (e.g., `'%son'`) often can't use indexes efficiently 
  — can be slow on very large tables
- NOT IN with NULLs in the list silently returns no rows — a common, dangerous gotcha
- Overusing NOT/negation can make queries harder to read and maintain

## Alternatives
- For complex pattern matching beyond LIKE's capability, some DBMS support 
  regular expressions (`~` in PostgreSQL, `REGEXP` in MySQL)
- `IN` with a subquery (Week 4+ topic) is often preferable to a long hardcoded IN list

## Best Practices
- Prefer `IN` over multiple chained `OR` conditions on the same column
- Be explicit with BETWEEN boundaries — double check inclusive behavior 
  matches your intent (especially with dates/timestamps)
- Avoid `NOT IN` on nullable columns; consider `NOT EXISTS` (later topic) as a safer alternative
- Use LIKE only when you genuinely need pattern matching — exact `=` is 
  faster when you know the precise value

## Performance Notes
- `LIKE 'value%'` (leading characters known) CAN use an index efficiently
- `LIKE '%value'` or `LIKE '%value%'` (leading wildcard) generally CANNOT use 
  an index — causes a full table scan on large tables
- `IN` with a huge list (thousands of values) can degrade performance — 
  consider a JOIN against a lookup table instead at scale

## Common Mistakes
- Assuming `NOT IN` behaves safely with NULLs (it doesn't — can silently 
  return zero rows)
- Forgetting `LIKE` wildcards treat spaces as literal characters
- Using `= 'Germany'` expecting case-sensitivity guarantees across all environments
- Confusing `BETWEEN` as exclusive when it's actually inclusive

## When NOT to Use
- Don't use `LIKE '%text%'` on huge tables as your primary filter if 
  performance matters — consider full-text search alternatives at scale
- Don't use `NOT IN` when the list source might contain NULLs — use `NOT EXISTS` instead
- Don't use BETWEEN for timestamp ranges without being explicit about 
  time boundaries (e.g., BETWEEN '2024-01-01' AND '2024-01-31' may exclude 
  time-of-day entries on Jan 31 depending on datatype)

## Future Related Topics
Subqueries (safer IN/NOT IN alternatives), JOINs, String functions (deeper 
pattern manipulation), Regular expressions

## Data Engineering Connection
- **LIKE patterns** → Common in data quality/validation scripts in ETL 
  pipelines (e.g., flagging malformed emails not matching `%@%.%`)
- **IN operator** → Used heavily in incremental ETL to filter specific 
  batch IDs or partition keys during processing
- **NOT IN / NULL gotcha** → A classic bug source in Data Engineering pipelines; 
  senior engineers specifically test for NULL-safety in filter logic
- **BETWEEN for date ranges** → Directly maps to how Data Engineers partition 
  and filter data loads by date ranges in Spark/SQL-based pipelines

## Summary
Filtering operators are the vocabulary of the WHERE clause. Comparison 
operators handle exact/relative checks, logical operators combine conditions, 
BETWEEN handles inclusive ranges, IN/NOT IN handle list membership (with a 
critical NULL gotcha on NOT IN), and LIKE handles pattern-based text search 
using `%` and `_` wildcards. Mastering these transforms vague business 
requests into precise, correct SQL.