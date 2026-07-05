### Q1: What is the difference between SQL and MySQL?
**Simple Answer:** SQL is a language; MySQL is software (a DBMS) that uses SQL.

**Detailed Answer:** SQL (Structured Query Language) is a standardized language 
for querying relational databases. MySQL, PostgreSQL, SQL Server, and Oracle are 
DBMS software products that implement SQL (with slight syntax variations) to 
manage actual databases.

**Example:** You write SQL code; MySQL is the engine that executes it.

**Follow-up:** "Name other DBMS software." → PostgreSQL, SQL Server, Oracle, SQLite

**Common Mistake:** Calling MySQL "a type of SQL" — it's software, not a language variant.

**Difficulty:** ⭐

---

### Q2: What is a DBMS and why do we need it?
**Simple Answer:** Software that manages access to a database.

**Detailed Answer:** DBMS acts as a mediator between users/applications and the 
database. When multiple sources (websites, BI tools, developers) send SQL requests 
simultaneously, DBMS manages execution order, ensures data integrity, handles 
security/permissions, and returns results — so the database itself is never 
directly exposed to chaos of concurrent raw access.

**Example:** PostgreSQL managing 100 simultaneous dashboard queries from Power BI.

**Follow-up:** "What happens without a DBMS?" → No concurrency control, no security, 
no standardized query interface — direct file access chaos.

**Common Mistake:** Thinking DBMS and Database are the same thing.

**Difficulty:** ⭐⭐

---

### Q3: Explain the difference between WHERE and HAVING.
**Simple Answer:** WHERE filters rows before grouping; HAVING filters after grouping.

**Detailed Answer:** WHERE operates on individual rows before any aggregation occurs 
and cannot reference aggregate functions. HAVING operates on the grouped/aggregated 
results and is specifically designed to filter based on aggregate conditions like 
SUM, COUNT, AVG.

**Example:**
```sql
SELECT country, SUM(score) as total_score
FROM customers
WHERE score != 0                    -- row-level filter first
GROUP BY country
HAVING SUM(score) > 750;            -- group-level filter after
```

**Follow-up:** "Can you use HAVING without GROUP BY?" → Technically yes in some 
DBMS if treating whole result as one group, but it's non-standard practice.

**Common Mistake:** Writing `WHERE SUM(score) > 750` — causes an error because 
WHERE executes before aggregation exists.

**Difficulty:** ⭐⭐

---

### Q4: What's the difference between CHAR and VARCHAR?
**Simple Answer:** CHAR is fixed-length (padded with spaces); VARCHAR is variable-length.

**Detailed Answer:** CHAR(n) always allocates n bytes regardless of actual content 
length — padding with spaces. VARCHAR(n) allocates only the space needed for actual 
content, plus 1-2 bytes to store the length marker. VARCHAR is more storage-efficient 
for variable text; CHAR can be marginally faster for truly fixed-length data.

**Example:** CHAR(3) storing 'US' still uses 3 bytes ('US '). VARCHAR(3) storing 
'US' uses only 2 bytes + overhead.

**Follow-up:** "When would you use CHAR over VARCHAR?" → Fixed codes: gender (M/F), 
currency codes (USD, INR), Yes/No flags.

**Common Mistake:** Using CHAR for names/emails (wastes space with padding).

**Difficulty:** ⭐⭐

---

### Q5: Explain COUNT(*) vs COUNT(column_name) vs COUNT(DISTINCT column_name).
**Simple Answer:** COUNT(*) counts all rows; COUNT(column) skips NULLs; COUNT(DISTINCT) counts unique non-null values.

**Detailed Answer:** 
- `COUNT(*)` counts every row regardless of NULL values in any column
- `COUNT(column_name)` counts only rows where that specific column is not NULL
- `COUNT(DISTINCT column_name)` counts unique values, excluding NULLs and duplicates

**Example:**
```sql
-- 10 total rows, 2 have NULL email, 3 emails are duplicates
COUNT(*)                → 10
COUNT(email)            → 8
COUNT(DISTINCT email)   → 6 (assuming duplicates among the 8)
```

**Follow-up:** "Which would you use to count 'active users who signed up'?" → 
COUNT(signup_date) if some users have NULL signup dates that shouldn't count.

**Common Mistake:** Assuming COUNT(*) and COUNT(column) always give same result.

**Difficulty:** ⭐⭐

---

### Q6: What is the SQL execution order and why does it matter?
**Simple Answer:** SQL executes FROM → WHERE → GROUP BY → HAVING → SELECT → ORDER BY → LIMIT, not in written order.

**Detailed Answer:** Even though we WRITE `SELECT...FROM...WHERE...GROUP BY...HAVING...ORDER BY`, 
the database engine actually EXECUTES it starting from FROM. This explains why you 
can't use a SELECT alias in a WHERE clause (WHERE runs before SELECT is resolved), 
but you CAN use an alias in ORDER BY (it runs after SELECT).

**Example:**
```sql
SELECT score * 2 as double_score
FROM customers
WHERE double_score > 100   -- ❌ ERROR: double_score doesn't exist yet
ORDER BY double_score;     -- ✅ WORKS: SELECT has already executed
```

**Follow-up:** "Why can ORDER BY use the alias but WHERE can't?"

**Common Mistake:** Assuming SQL runs top-to-bottom like a script.

**Difficulty:** ⭐⭐⭐

---

### Q7: Why do relational databases split data into multiple tables instead of one big table?
**Simple Answer:** To avoid data redundancy and make data manageable (normalization).

**Detailed Answer:** If you stored a customer's info repeated in every one of their 
100 orders in a single table, you'd have massive redundancy, update anomalies (change 
address in 100 places), and poor performance. Splitting into `customers` and `orders` 
tables linked by `customer_id` (a foreign key) keeps data consistent and efficient — 
this is the core RDBMS principle of normalization.

**Example:** Amazon doesn't store your full address in every order record — it stores 
a `customer_id` reference to your `customers` table.

**Follow-up:** "What problem occurs if you don't normalize?" → Update anomalies, 
insert anomalies, delete anomalies, wasted storage.

**Common Mistake:** Believing "one big table" is simpler and therefore better.

**Difficulty:** ⭐⭐⭐

---

### Q8: What does DISTINCT do, and how is it different from GROUP BY?
**Simple Answer:** DISTINCT removes duplicate rows; GROUP BY groups rows for aggregation.

**Detailed Answer:** DISTINCT is used purely to return unique values/rows with no 
calculation. GROUP BY is used when you want to perform aggregate calculations 
(SUM, COUNT, AVG) per group. You CAN use GROUP BY to get unique values (grouping 
with no aggregate), but DISTINCT is simpler and clearer in intent when no 
aggregation is needed.

**Example:**
```sql
SELECT DISTINCT country FROM customers;          -- unique countries only
SELECT country, COUNT(*) FROM customers GROUP BY country;  -- unique + count
```

**Follow-up:** "Is DISTINCT faster than GROUP BY for just getting unique values?" 
→ Generally similar performance in modern optimizers, but DISTINCT communicates 
intent more clearly.

**Common Mistake:** Using GROUP BY unnecessarily when DISTINCT would be clearer.

**Difficulty:** ⭐⭐

---

### Q9: Why is VARCHAR(255) so commonly used as a default?
**Simple Answer:** It's a practical size limit that fits most text fields and aligns with 1-byte storage overhead.

**Detailed Answer:** 255 is the maximum value representable in 1 byte (2^8 - 1). 
Using VARCHAR(255) means the length-prefix overhead is exactly 1 byte per row. 
Going to VARCHAR(256) pushes the length prefix to 2 bytes for EVERY row, even 
though you rarely need that much text for names/emails/most fields — hence 255 
became the historical "sweet spot" default.

**Example:** Legacy MySQL systems often defaulted text fields to VARCHAR(255) 
for this exact reason.

**Follow-up:** "Is this still relevant with modern databases?" → Less critical 
now with modern storage, but still good practice to size columns intentionally.

**Common Mistake:** Blindly using VARCHAR(255) for everything without thinking 
about actual data needs (e.g., a "bio" field might need VARCHAR(2000) or TEXT).

**Difficulty:** ⭐⭐⭐

---

### Q10: How does nested ORDER BY actually work?
**Simple Answer:** The second column only sorts within duplicate groups of the first column.

**Detailed Answer:** `ORDER BY col1, col2` first sorts everything by col1. Then, 
for col2, sorting is applied ONLY among rows that have identical (duplicate) col1 
values. If col1 has no duplicates for a given row, that row's position isn't 
affected by col2 at all.

**Example:**
```sql
SELECT * FROM customers ORDER BY country ASC, score DESC;
-- Germany appears twice (350, 500) → sorted 500, 350 (DESC) within Germany group
-- USA appears twice (0, 900) → sorted 900, 0 (DESC) within USA group
-- UK appears once → score sort has no effect (no duplicates to sort)
```

**Follow-up:** "What if I swap the order to `score, country`?" → Now sorting 
happens primarily by score; country sort only kicks in for duplicate score values 
(which is rare with continuous numeric data).

**Common Mistake:** Assuming nested ORDER BY sorts col2 globally regardless of col1.

**Difficulty:** ⭐⭐⭐

---

### Q11 (Real Company Style — Amazon/Flipkart): Write a query to find countries with more than 1 customer.
**Answer:**
```sql
SELECT country, COUNT(*) as customer_count
FROM customers
GROUP BY country
HAVING COUNT(*) > 1;
```
**Interviewer Expectation:** Tests GROUP BY + HAVING understanding in one shot.
**Confidence Tip:** Say the logic out loud: "Group by country, count rows per group, keep only groups where count exceeds 1."

**Difficulty:** ⭐⭐

---

### Q12: What is the difference between DDL, DML, DCL, and TCL?
**Simple Answer:** DDL = structure, DML = data, DCL = permissions, TCL = transaction safety.

**Detailed Answer:**
- DDL (CREATE, ALTER, DROP): Changes database/table STRUCTURE
- DML (INSERT, UPDATE, DELETE): Changes DATA inside tables
- DCL (GRANT, REVOKE): Manages user PERMISSIONS
- TCL (COMMIT, ROLLBACK, SAVEPOINT): Manages DML operations as safe transactions

**Example:** `ALTER TABLE` (DDL) adds a column; `UPDATE` (DML) changes a value in 
that column; `GRANT SELECT` (DCL) lets a user read the table; `ROLLBACK` (TCL) 
undoes an accidental DELETE before COMMIT.

**Follow-up:** "Why do we need TCL if DML already works?" → Safety — mistakes in 
DML (like DELETE without WHERE) can be undone before commit.

**Difficulty:** ⭐⭐

---

### Q13: What happens if you SELECT a column that's not in GROUP BY and not aggregated?
**Simple Answer:** SQL throws an error (in strict mode) because it's ambiguous which value to show.

**Detailed Answer:** If you group by `country` but also SELECT `first_name` without 
aggregating it, SQL doesn't know WHICH first_name to display for a country with 
multiple customers — so it errors out (in PostgreSQL/strict MySQL) or gives 
unpredictable results (in lenient MySQL modes).

**Example:**
```sql
-- ❌ Error: which first_name for Germany (Maria or Martin)?
SELECT first_name, country, SUM(score) FROM customers GROUP BY country;
```

**Follow-up:** "How would you fix this if you wanted to show one representative name?" 
→ Use MIN(first_name), MAX(first_name), or a window function like FIRST_VALUE.

**Common Mistake:** Not understanding WHY this fails — thinking it's just a syntax rule.

**Difficulty:** ⭐⭐⭐

---

### Q14: What is a Schema in a database?
**Simple Answer:** A logical grouping/namespace for tables within a database.

**Detailed Answer:** Schema sits between Database and Table in the hierarchy 
(Server → Database → Schema → Table). It's used to organize related tables 
together, like a folder structure — e.g., a "sales" schema containing customers, 
orders, products tables, separate from an "hr" schema containing employees, payroll.

**Example:** `sales.customers` vs `hr.employees` — same database, different schemas.

**Follow-up:** "Why not just use one schema for everything?" → Organization, 
security (permission by schema), avoiding naming collisions.

**Difficulty:** ⭐⭐

---

### Q15: How would you find duplicate records in a table?
**Simple Answer:** GROUP BY the column(s) that should be unique, then use HAVING COUNT(*) > 1.

**Detailed Answer:**
```sql
SELECT email, COUNT(*) as occurrence_count
FROM customers
GROUP BY email
HAVING COUNT(*) > 1;
```
This groups all rows by email and returns only the emails that appear more than once.

**Follow-up:** "How would you then delete the duplicates, keeping only one?" 
→ Requires window functions (ROW_NUMBER) — a Week 2+ topic.

**Common Mistake:** Trying `WHERE COUNT(*) > 1` instead of HAVING.

**Difficulty:** ⭐⭐