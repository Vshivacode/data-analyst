### Problem 1
**Difficulty:** Easy
**Problem:** Create a table `employees` with columns: id (int, primary key), 
name (varchar 100, not null), salary (decimal).
**Solution:**
```sql
CREATE TABLE employees
(
    id INT NOT NULL,
    name VARCHAR(100) NOT NULL,
    salary DECIMAL(10,2),
    CONSTRAINT pk_employees PRIMARY KEY (id)
);
```
**Learning:** Basic CREATE TABLE with named PRIMARY KEY constraint.

---

### Problem 2
**Difficulty:** Easy
**Problem:** Add a new column `department` (varchar 50) to the employees table.
**Solution:**
```sql
ALTER TABLE employees ADD department VARCHAR(50);
```
**Learning:** ALTER TABLE ADD for schema evolution.

---

### Problem 3
**Difficulty:** Easy
**Problem:** Remove the `department` column from employees.
**Solution:**
```sql
ALTER TABLE employees DROP COLUMN department;
```
**Learning:** ALTER TABLE DROP COLUMN.

---

### Problem 4
**Difficulty:** Medium
**Problem:** Change the `name` column to VARCHAR(150) and make it NOT NULL.
**Solution:**
```sql
ALTER TABLE employees ALTER COLUMN name VARCHAR(150) NOT NULL;
```
**Learning:** ALTER COLUMN to change datatype/constraint together.

---

### Problem 5
**Difficulty:** Easy
**Problem:** Insert a new employee: id=1, name='Ravi', salary=50000.
**Solution:**
```sql
INSERT INTO employees(id, name, salary) VALUES (1, 'Ravi', 50000);
```
**Learning:** Basic INSERT with explicit column names (best practice).

---

### Problem 6
**Difficulty:** Medium
**Problem:** Insert 3 employees in a single statement: (2,'Anita',60000), 
(3,'Kiran',45000), (4,'Divya',NULL).
**Solution:**
```sql
INSERT INTO employees(id, name, salary) VALUES 
(2, 'Anita', 60000),
(3, 'Kiran', 45000),
(4, 'Divya', NULL);
```
**Learning:** Multi-row INSERT syntax, explicit NULL insertion.

---

### Problem 7
**Difficulty:** Medium
**Problem:** Create a table `accounts` with id as auto-incrementing primary 
key starting at 100, name varchar(50), and balance defaulting to 0.00.
**Solution:**
```sql
CREATE TABLE accounts
(
    id INT NOT NULL PRIMARY KEY IDENTITY(100,1),
    name VARCHAR(50),
    balance DECIMAL(10,2) DEFAULT(0.00)
);
```
**Learning:** IDENTITY with custom seed value + DEFAULT constraint together.

---

### Problem 8
**Difficulty:** Easy
**Problem:** Insert a new account with only a name ('Suresh') — let id and 
balance use their defaults.
**Solution:**
```sql
INSERT INTO accounts(name) VALUES ('Suresh');
```
**Learning:** Relying on IDENTITY and DEFAULT to auto-populate unspecified columns.

---

### Problem 9
**Difficulty:** Medium
**Problem:** Update Ravi's salary (id=1) to 55000.
**Solution:**
```sql
UPDATE employees SET salary = 55000 WHERE id = 1;
```
**Learning:** Precise, targeted UPDATE using WHERE.

---

### Problem 10
**Difficulty:** Medium
**Problem:** Find and fix all employees with NULL salary — set them to 30000.
**Solution:**
```sql
UPDATE employees SET salary = 30000 WHERE salary IS NULL;
```
**Learning:** Correct NULL handling in WHERE (IS NULL, not = NULL).

---

### Problem 11
**Difficulty:** Medium
**Problem:** Delete the employee with id = 4.
**Solution:**
```sql
DELETE FROM employees WHERE id = 4;
```
**Learning:** Targeted DELETE with WHERE.

---

### Problem 12
**Difficulty:** Hard (Danger Awareness)
**Problem:** Explain what happens if you run `DELETE FROM employees;` with no 
WHERE clause, and rewrite it to safely delete only employees with salary < 40000.
**Solution:**
```sql
-- DANGEROUS (deletes everyone):
-- DELETE FROM employees;

-- SAFE version:
SELECT * FROM employees WHERE salary < 40000;  -- preview first
DELETE FROM employees WHERE salary < 40000;    -- then delete
```
**Learning:** The single most important DML safety habit — preview before delete.

---

### Problem 13
**Difficulty:** Medium
**Problem:** Rename the `employees` table to `staff`.
**Solution:**
```sql
EXEC sp_rename 'employees', 'staff';
```
**Learning:** Renaming tables (SQL Server syntax).

---

### Problem 14
**Difficulty:** Easy
**Problem:** View the structure (columns, types) of the `staff` table.
**Solution:**
```sql
EXEC sp_help staff;   -- SQL Server
-- DESC staff;         -- MySQL equivalent
```
**Learning:** Inspecting table metadata — essential when working with 
unfamiliar tables.

---

### Problem 15
**Difficulty:** Medium
**Problem:** Add a PRIMARY KEY constraint named `pk_staff` on the `id` column 
of `staff` (assume it wasn't defined at creation).
**Solution:**
```sql
ALTER TABLE staff ADD CONSTRAINT pk_staff PRIMARY KEY (id);
```
**Learning:** Adding constraints after table creation via ALTER.

---

### Problem 16
**Difficulty:** Medium
**Problem:** Create a `products` table where every new product's `status` 
column defaults to 'active' if not specified.
**Solution:**
```sql
CREATE TABLE products
(
    product_id INT NOT NULL PRIMARY KEY IDENTITY(1,1),
    product_name VARCHAR(100),
    status VARCHAR(20) DEFAULT('active')
);
```
**Learning:** Using DEFAULT for sensible baseline values on new records.

---

### Problem 17
**Difficulty:** Hard
**Problem:** Drop the entire `staff` table permanently.
**Solution:**
```sql
DROP TABLE staff;
```
**Learning:** DROP removes structure AND data — irreversible without backups.

---

### Problem 18
**Difficulty:** Medium
**Problem:** Update all products with NULL status to 'active' (simulate a 
data cleanup after a bulk import).
**Solution:**
```sql
UPDATE products SET status = 'active' WHERE status IS NULL;
```
**Learning:** Reinforcing IS NULL usage in a data cleanup context.

---

### Problem 19
**Difficulty:** Medium
**Problem:** Insert a product with all columns except id (let IDENTITY 
handle it) — product_name = 'Notebook', status left as default.
**Solution:**
```sql
INSERT INTO products(product_name) VALUES ('Notebook');
```
**Learning:** Combining IDENTITY (auto id) + DEFAULT (auto status) in one clean insert.

---

### Problem 20
**Difficulty:** Hard
**Problem:** You need to permanently remove ALL rows from a `daily_logs` 
staging table before tonight's ETL run, but keep the table structure for 
tomorrow's load. Which command do you use and why (compare 2 options)?
**Solution:**
```sql
-- Option A: DELETE (slower, fully logged, resets nothing)
DELETE FROM daily_logs;

-- Option B: TRUNCATE (faster, minimal logging, resets identity)
TRUNCATE TABLE daily_logs;
```
**Learning:** For a full staging table reset with no filtering needed, 
TRUNCATE is the better choice — faster, resets IDENTITY back to seed, 
purpose-built for this exact ETL pattern.