### Q1: What is the difference between DDL and DML?
**Simple Answer:** DDL changes table structure; DML changes table data.

**Detailed Answer:** DDL (CREATE, ALTER, DROP) defines or modifies the SCHEMA 
of database objects — columns, datatypes, constraints. DML (INSERT, UPDATE, 
DELETE) operates on the actual ROWS of data within that already-defined structure.

**Example:** `ALTER TABLE customers ADD email VARCHAR(50)` (DDL — structure) 
vs `UPDATE customers SET email = 'x@y.com' WHERE id = 1` (DML — data).

**Follow-up:** "Does DDL auto-commit in most databases?" → Yes, in most 
systems DDL statements auto-commit immediately and can't be rolled back like DML can.

**Common Mistake:** Thinking ALTER TABLE affects data — it only affects structure 
(though changing a datatype CAN affect how existing data is interpreted/truncated).

**Difficulty:** ⭐

---

### Q2: What is the difference between DROP, DELETE, and TRUNCATE?
**Simple Answer:** DROP removes the whole table (structure+data); DELETE removes 
rows (can filter with WHERE); TRUNCATE removes all rows fast (no WHERE, resets identity).

**Detailed Answer:**
| Command | Removes | Can use WHERE? | Rollback-able? | Speed |
|---------|---------|-----------------|-----------------|-------|
| DROP | Table structure + all data | No | No (DDL, auto-commits) | N/A |
| DELETE | Rows only | Yes | Yes (DML, transactional) | Slower (logs each row) |
| TRUNCATE | All rows only | No | Limited/varies by DBMS | Faster (minimal logging) |

**Example:** To remove only inactive customers: `DELETE FROM customers WHERE 
status = 'inactive';` — DROP or TRUNCATE would wrongly remove ALL customers.

**Follow-up:** "Which would you use to reset a staging table before a daily 
ETL load?" → TRUNCATE (fast, full reset, keeps structure).

**Common Mistake:** Using DROP when DELETE was intended — losing the entire table.

**Difficulty:** ⭐⭐

---

### Q3: Why does `WHERE column = NULL` not work, and what should you use instead?
**Simple Answer:** NULL means "unknown," and unknown can't be equal to anything — use `IS NULL`.

**Detailed Answer:** NULL is not a value like 0 or empty string — it represents 
the ABSENCE of a value or an unknown value. In SQL's three-valued logic 
(TRUE/FALSE/UNKNOWN), comparing NULL = NULL evaluates to UNKNOWN, not TRUE, 
so rows are never matched. `IS NULL` / `IS NOT NULL` are the correct operators 
specifically designed to test for NULL.

**Example:**
```sql
-- ❌ Never returns matching rows, even if country IS actually null
WHERE country = NULL

-- ✅ Correctly identifies rows with missing country
WHERE country IS NULL
```

**Follow-up:** "How would you count NULL values in a column?" → 
`SELECT COUNT(*) - COUNT(column_name) FROM table;`

**Difficulty:** ⭐⭐⭐

---

### Q4: What happens if you run UPDATE or DELETE without a WHERE clause?
**Simple Answer:** It affects EVERY row in the table.

**Detailed Answer:** Without WHERE, UPDATE applies the SET clause to all rows, 
and DELETE removes all rows (though the table structure remains, unlike DROP). 
This is one of the most catastrophic and common mistakes in SQL — often 
called "the WHERE clause horror story."

**Example:**
```sql
UPDATE customers SET score = 0;  -- ⚠️ Sets EVERY customer's score to 0!
```

**Follow-up:** "How do you protect against this in real work?" → Always run 
the equivalent SELECT with the same WHERE first to preview affected rows; 
use transactions (BEGIN TRANSACTION) so you can ROLLBACK if something looks wrong.

**Common Mistake:** Forgetting WHERE entirely, or writing WHERE with a typo 
that unintentionally matches all rows.

**Difficulty:** ⭐⭐⭐

---

### Q5: What is an IDENTITY column and why use it?
**Simple Answer:** An auto-incrementing column, typically used for primary keys.

**Detailed Answer:** `IDENTITY(1,1)` tells SQL Server to auto-generate a value 
starting at 1, incrementing by 1 for each new row — you never manually insert 
a value into this column. This guarantees uniqueness without manual tracking. 
(MySQL equivalent: `AUTO_INCREMENT`; PostgreSQL: `SERIAL`/`GENERATED AS IDENTITY`.)

**Example:**
```sql
CREATE TABLE sample (id INT PRIMARY KEY IDENTITY(1,1), name VARCHAR(25));
INSERT INTO sample(name) VALUES ('shiva');  -- id auto-assigned as 1
```

**Follow-up:** "Can IDENTITY values have gaps?" → Yes — if an insert fails or 
a transaction rolls back, that identity value is typically NOT reused, 
creating gaps in the sequence.

**Difficulty:** ⭐⭐

---

### Q6: Why should you explicitly name constraints instead of letting the system auto-name them?
**Simple Answer:** Auto-generated names are random/system-specific, making them hard to reference later.

**Detailed Answer:** Without an explicit name, most DBMS auto-generate a 
constraint name (often something cryptic and different per environment). 
If you later need to DROP or ALTER that constraint, you'd have to look up 
this generated name each time. Naming it explicitly (`CONSTRAINT pk_persons 
PRIMARY KEY(id)`) gives you a predictable, memorable reference.

**Example:**
```sql
ALTER TABLE persons DROP CONSTRAINT pk_persons;  -- clean, if named explicitly
```

**Follow-up:** "What naming convention would you use?" → Common pattern: 
`pk_tablename` for primary keys, `fk_table_reftable` for foreign keys.

**Difficulty:** ⭐⭐⭐

---

### Q7: What is the DEFAULT constraint and when would you use it?
**Simple Answer:** Automatically fills a column with a specified value if none is provided on INSERT.

**Detailed Answer:** `DEFAULT(0.00)` on a `balance` column means any INSERT 
that doesn't explicitly provide a balance value will automatically get 0.00 
instead of NULL. This is useful for columns where a sensible baseline value 
makes more sense than NULL (e.g., new account balances, status flags defaulting to 'active').

**Example:**
```sql
CREATE TABLE sample (id INT IDENTITY(1,1), balance DECIMAL(10,2) DEFAULT(0.00));
INSERT INTO sample(id) DEFAULT VALUES;  -- balance becomes 0.00 automatically
```

**Follow-up:** "How do you remove a DEFAULT constraint later?" → Redefine 
the column via ALTER without specifying DEFAULT (syntax varies — in SQL 
Server you typically must DROP the specific default constraint by name).

**Difficulty:** ⭐⭐

---

### Q8: Can you insert values into a table without specifying column names? What's the risk?
**Simple Answer:** Yes, but values must match the table's exact column order — risky if structure changes.

**Detailed Answer:**
```sql
INSERT INTO customers VALUES (9, 'chintu', 'india', 200);
```
This works ONLY if you know the exact column order of the table. If someone 
later adds a new column via ALTER TABLE, this same INSERT statement will now 
fail or insert data into the wrong columns — a fragile, error-prone pattern.

**Follow-up:** "What's the safer alternative?" → Always specify column names: 
`INSERT INTO customers(id, first_name, country, score) VALUES (9, 'chintu', 
'india', 200);` — resilient to future schema changes.

**Common Mistake:** Relying on positional INSERT in production code.

**Difficulty:** ⭐⭐

---

### Q9: What's the difference between altering a column's datatype and adding a new column?
**Simple Answer:** Adding a column extends the table; altering a datatype changes how existing data is interpreted/stored.

**Detailed Answer:** `ALTER TABLE persons ADD email VARCHAR(50);` simply adds 
a new nullable column with no impact on existing rows (they get NULL for the 
new column). `ALTER TABLE persons ALTER COLUMN person_name VARCHAR(25) NOT 
NULL;` changes an EXISTING column's rules — this can FAIL if existing data 
violates the new rule (e.g., existing names longer than 25 characters, or 
existing NULLs when adding NOT NULL).

**Follow-up:** "What would you check before running such an ALTER in production?" 
→ Run a SELECT to check if any existing data would violate the new constraint 
before applying it.

**Difficulty:** ⭐⭐⭐

---

### Q10: Explain the real-world risk of DML operations and how professionals protect against it.
**Simple Answer:** UPDATE/DELETE mistakes can silently corrupt or wipe production data — professionals always verify first.

**Detailed Answer:** In real production environments, an UPDATE/DELETE 
without proper WHERE (or with a wrong WHERE) can affect thousands/millions 
of rows instantly, often irreversibly without backups. Professional practice: 
(1) write the WHERE clause, (2) run it as a SELECT first to preview affected 
rows, (3) only then convert to UPDATE/DELETE, (4) use transactions where 
possible so you can ROLLBACK if the affected row count looks wrong.

**Example workflow:**
```sql
-- Step 1: Preview
SELECT * FROM customers WHERE score = 0;  -- check: does this look right?

-- Step 2: Only then delete
DELETE FROM customers WHERE score = 0;
```

**Follow-up:** "What TCL command would you use as a safety net?" → 
BEGIN TRANSACTION before the DML, then COMMIT if correct or ROLLBACK if not.

**Difficulty:** ⭐⭐⭐

---

### Q11 (Real Company Style): You're asked to remove a column that's no longer needed from a production table with 10M rows. What do you consider?
**Answer:** 
"I'd check if any downstream reports/pipelines still reference this column 
before dropping it (breaking changes). I'd also consider timing — ALTER TABLE 
DROP COLUMN can lock large tables, so I'd schedule it during low-traffic hours, 
and I'd back up the table or at least export that column's data first in case 
it's needed for rollback/audit purposes."

**Interviewer Expectation:** Tests production-awareness, not just syntax knowledge.
**Difficulty:** ⭐⭐⭐⭐

---

### Q12: What's the difference between `ALTER TABLE ... ADD` and `INSERT INTO`?
**Simple Answer:** ADD creates a new column (structure); INSERT creates a new row (data).

**Detailed Answer:** These operate on completely different dimensions of a 
table. ADD is DDL, works on the vertical (column) axis. INSERT is DML, works 
on the horizontal (row) axis.

**Difficulty:** ⭐

---

### Q13: How would you rename a table, and does this affect the data inside it?
**Simple Answer:** `EXEC sp_rename` (SQL Server) — data is unaffected, only the table's name reference changes.

**Detailed Answer:** Renaming is purely a metadata change — no data is moved, 
copied, or altered. However, any external code/reports/views referencing the 
OLD table name will break and need updating.

**Follow-up:** "What should you check before renaming a production table?" 
→ Search codebase/reports for references to the old table name first.

**Difficulty:** ⭐⭐

---

### Q14: What is the purpose of a PRIMARY KEY constraint?
**Simple Answer:** Ensures each row has a unique, non-null identifier.

**Detailed Answer:** PRIMARY KEY combines UNIQUE + NOT NULL enforcement on 
one (or more) columns, guaranteeing no duplicate or missing identifiers exist. 
It's also typically used as the target for FOREIGN KEY relationships from 
other tables.

**Difficulty:** ⭐⭐

---

### Q15: If you need to correct a batch of incorrect NULL values in a column, what's your approach?
**Simple Answer:** Use UPDATE with IS NULL in the WHERE clause to target exactly those rows.

**Detailed Answer:**
```sql
UPDATE customers SET country = 'india' WHERE country IS NULL;
```
This safely targets ONLY rows with missing country values, leaving all other 
rows untouched — precise, safe DML with proper NULL handling.

**Follow-up:** "What if you wanted a different default per row instead of 
one flat value?" → Would need a CASE statement or a lookup/JOIN-based UPDATE 
(more advanced topic).

**Difficulty:** ⭐⭐