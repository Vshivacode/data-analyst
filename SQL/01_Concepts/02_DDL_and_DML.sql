-- DDL (DATA DEFINITION LANGUAGE)
-- these are like creating or managing the structure of the table 
-- so we use create, alter and drop


-- sql task - create a table called persons with columns id, person_name, birth_date and phone
create table persons
(
    id int not null, 
    person_name varchar(255) not null,
    birth_date date,
    phone varchar(15) not null,
    constraint pk_persons primary key (id)        -- its better to use constraint and the name of the constraint so that later if we want to delete the primary key then we can easily able to do without mentioning the name it will take some random name and each server it will be different name so it is difficult to manage 
);

drop table persons




-- alter
-- it is used to manage or edit the table of an existing table without deleting or losing the data inside the table

-- sql task - add a new column email to the table 
alter table persons add email varchar(50)

select * from persons;

-- sql task - remove phone column from table
alter table persons drop column phone


exec sp_help persons -- in mysql we use desc tablename but in sql server we use exec sp_help tablename 


-- changing the data type of the existing column
alter table persons alter column person_name varchar(25) not null


alter table persons add constraint pk_persons primary key (id)


exec sp_rename persons, persons_tb -- alter table persons rename to persons_table



select * from persons_tb



drop table persons_tb



-- DML - Data Manipulation Language 
-- it is used to manage the data in the table
select * from customers

-- inserting single value to a single column 
-- insert - insert into tablename(col1) values (val1)

-- inserting multiple values to multiple columns, so we can insert multiple values by using a comma as a seperator
-- insert - insert into tablename(col1, col2) values (val1, val2), (val1, val2), (val1, val2);

-- inserting all values to all the columns we can do this in two ways 
-- without mentioning the column names but we need to follow exact order that table is created 
-- insert - insert into tablename values (val1, val2)

-- mentioning the column names, with this we can follow the exact order of the mention column names 
-- insert - insert into tablename(col1, col2) values (val1, val2)
-- we cannot do like this 
-- insert - insert into tablename(col2, col3, col1) values (val1, val2)   -- it will fail because we are putting the values to the wrong columns 

insert into customers(id, first_name, score) values (6,'shiva', 200)
-- here if we did not mention the remaining columns then those columns values can be inserted NULL values

-- we can also insert NULL values manually 
insert into customers(id, first_name, score) values (7,'shiva', NULL)


select * from customers

insert into customers values (9, 'chintu', 'india', 200)



create table sample(id int not null primary key identity(1,1), name varchar(25), balance decimal(10,2) default(0.00))


insert into sample values ('shiva', 200), ('hari', 12939)


select * from sample 


-- remove default constraint
alter table sample alter column balance decimal(10,2)


exec sp_help sample 


delete from sample 

drop table sample 



update sample set balance = 0


select * from customers;


update customers set score = 0 where id = 6

insert into customers values (10,'ram', 'india', 839)

update customers set score = 0 where id = 10


update customers set country = 'UK' where id = 10


-- country = null does not work because null is unknown we cannot able to compare with another null value so we use is null it is used to check whether the value is missing 
update customers set country = 'india' where country is null -- we are telling sql to check whether this row have any missing value





delete from customers where score = 0 


select * from customers where id > 5

delete from customers where id > 5 


select * from customers 










--------- FORMATED NOTES ---------

# Day 2: DDL & DML (CREATE, ALTER, DROP, INSERT, UPDATE, DELETE)

## Definition
DDL (Data Definition Language) manages the STRUCTURE of database objects 
(CREATE, ALTER, DROP). DML (Data Manipulation Language) manages the DATA 
inside tables (INSERT, UPDATE, DELETE) without changing structure.

## What is it?
- **CREATE**: Builds a new table/database/object
- **ALTER**: Modifies an existing table's structure (add/remove/modify columns, constraints)
- **DROP**: Permanently deletes a table/object (structure AND data)
- **INSERT**: Adds new rows of data
- **UPDATE**: Modifies existing row values
- **DELETE**: Removes rows (data only, structure remains)

## Why do we need it?
Once a database is designed, requirements evolve — new columns are needed, 
constraints change, data needs correcting. DDL lets you evolve structure 
safely; DML lets you manage the actual data flowing through that structure 
without rebuilding tables from scratch.

## Problem it solves
- Need to define a table's shape/rules upfront (DDL) → prevents invalid data from entering
- Need to change that shape later without losing existing data (ALTER vs DROP+CREATE)
- Need to add/modify/remove actual records as business operations happen (DML)

## How does it work? (Internal Working)

### CREATE TABLE with Constraints
```sql
CREATE TABLE persons
(
    id INT NOT NULL,
    person_name VARCHAR(255) NOT NULL,
    birth_date DATE,
    phone VARCHAR(15) NOT NULL,
    CONSTRAINT pk_persons PRIMARY KEY (id)
);
```
**Why name the constraint (`pk_persons`)?** Without an explicit name, the 
DBMS auto-generates a random system name that differs per server/environment. 
Naming it explicitly makes it easy to reference later (e.g., to drop it) 
without hunting for the system-generated name.

### ALTER TABLE Operations
```sql
-- Add a column
ALTER TABLE persons ADD email VARCHAR(50);

-- Remove a column
ALTER TABLE persons DROP COLUMN phone;

-- Change a column's datatype/constraint
ALTER TABLE persons ALTER COLUMN person_name VARCHAR(25) NOT NULL;

-- Add a constraint after table creation
ALTER TABLE persons ADD CONSTRAINT pk_persons PRIMARY KEY (id);
```
**Key point:** ALTER preserves existing data. Dropping and recreating a 
table destroys all data — ALTER is the safe evolution path.

### Renaming Objects (SQL Server specific)
```sql
EXEC sp_rename 'persons', 'persons_tb';
```
Note: In MySQL, the equivalent is `ALTER TABLE persons RENAME TO persons_table;` 
— syntax differs by DBMS vendor even though the underlying language is "SQL."

### Inspecting Table Structure
```sql
EXEC sp_help persons;   -- SQL Server
DESC persons;            -- MySQL
```
Both return column names, datatypes, constraints — essential for understanding 
a table you didn't create yourself (very common in real jobs).

### IDENTITY (Auto-increment) + DEFAULT Constraint
```sql
CREATE TABLE sample
(
    id INT NOT NULL PRIMARY KEY IDENTITY(1,1),
    name VARCHAR(25),
    balance DECIMAL(10,2) DEFAULT(0.00)
);
```
- `IDENTITY(1,1)` → auto-generates IDs starting at 1, incrementing by 1 — 
  you never manually insert this column
- `DEFAULT(0.00)` → if no value is provided on INSERT, this value is used automatically

**Removing a DEFAULT constraint:**
```sql
ALTER TABLE sample ALTER COLUMN balance DECIMAL(10,2);  -- redefining without DEFAULT removes it
```

### INSERT Variations
```sql
-- Specific columns, specific values (safest — always recommended)
INSERT INTO customers(id, first_name, score) VALUES (6, 'shiva', 200);

-- Explicit NULL
INSERT INTO customers(id, first_name, score) VALUES (7, 'shiva', NULL);

-- All columns, no column names (must match EXACT table column order)
INSERT INTO customers VALUES (9, 'chintu', 'india', 200);

-- Multiple rows in one statement
INSERT INTO sample VALUES ('shiva', 200), ('hari', 12939);
```
**Critical rule:** If you provide column names in a different order than the 
table's actual structure but match VALUES to your custom order, it works 
correctly. But you can NEVER scramble which value maps to which named column — 
`INSERT INTO t(col2, col3, col1) VALUES (val1, val2)` fails because you're 
missing a value for one of your three named columns.

### UPDATE
```sql
UPDATE customers SET score = 0 WHERE id = 6;
UPDATE customers SET country = 'UK' WHERE id = 10;

-- Fixing NULL values
UPDATE customers SET country = 'india' WHERE country IS NULL;
```
**Critical rule:** `WHERE country = NULL` NEVER works — NULL represents 
"unknown," and unknown can't be compared/equal to anything, even another 
NULL. You MUST use `IS NULL` / `IS NOT NULL`.

**DANGER:** `UPDATE customers SET score = 0;` with NO WHERE clause updates 
EVERY row in the table. Always double-check your WHERE clause before running UPDATE.

### DELETE
```sql
DELETE FROM sample;                    -- deletes ALL rows (structure remains)
DELETE FROM customers WHERE score = 0; -- deletes only matching rows
```
**DELETE vs DROP:**
- `DELETE FROM table` → removes rows, table structure stays, can be rolled back (with TCL)
- `DROP TABLE table` → removes the ENTIRE table (structure + data), cannot be undone easily

## Advantages
- DDL allows safe, incremental schema evolution without data loss
- DML provides precise, targeted control over which rows are affected
- Constraints (PRIMARY KEY, NOT NULL, DEFAULT) enforce data integrity automatically

## Disadvantages
- ALTER on very large production tables can lock the table and cause downtime
- UPDATE/DELETE without WHERE is one of the most common catastrophic mistakes in SQL
- IDENTITY columns can create gaps in sequence if inserts fail (not always sequential in practice)

## Alternatives
- For structure changes in large-scale systems, some teams use migration tools 
  (Flyway, Liquibase) instead of raw ALTER statements for version control
- For bulk data changes, `TRUNCATE TABLE` is faster than `DELETE FROM table` 
  (no WHERE, resets identity, minimal logging) — but cannot be selectively filtered

## Best Practices
- Always name your constraints explicitly (`CONSTRAINT pk_name PRIMARY KEY(...)`)
- Always write and verify your WHERE clause BEFORE running UPDATE/DELETE — 
  run a SELECT with the same WHERE first to preview affected rows
- Specify column names explicitly in INSERT (avoid relying on positional order)
- Use transactions (BEGIN TRANSACTION / COMMIT / ROLLBACK) for risky DML in production

## Performance Notes
- ALTER TABLE on large tables can be slow/blocking — often scheduled during low-traffic windows
- Bulk INSERTs are faster with multi-row VALUES syntax vs one INSERT per row

## Common Mistakes
- Running `UPDATE`/`DELETE` without a WHERE clause (affects ALL rows)
- Using `= NULL` instead of `IS NULL`
- Forgetting column order must match VALUES order in unqualified INSERT
- Assuming DROP can be undone like DELETE (it generally cannot without backups)
- Confusing ALTER (structure) with UPDATE (data) — common beginner mix-up

## When NOT to Use
- Don't use DROP when you meant DELETE (you'll lose your table structure entirely)
- Don't run bulk UPDATE/DELETE directly on production without testing the 
  WHERE clause with SELECT first
- Don't use ALTER to change datatypes on columns with incompatible existing 
  data (e.g., VARCHAR with text → INT) without a data migration plan

## Future Related Topics
Transactions (COMMIT/ROLLBACK/SAVEPOINT) as a safety net for DML, Joins, Constraints deep-dive (FOREIGN KEY)

## Data Engineering Connection
- **DDL (CREATE/ALTER)** → Data Engineers define warehouse schemas this way 
  before any pipeline loads data — schema design is literally DDL work
- **DEFAULT/IDENTITY constraints** → Common in staging tables in ETL pipelines 
  to auto-generate surrogate keys
- **DML (INSERT/UPDATE/DELETE)** → In Data Engineering, these become part of 
  ETL/ELT jobs — e.g., an Airflow job running scheduled INSERTs into a warehouse 
  fact table, or UPSERT logic (INSERT + UPDATE combined) in incremental loads
- **TRUNCATE vs DELETE** → Data Engineers often TRUNCATE staging tables between 
  pipeline runs for a clean slate, since it's faster than DELETE

## Summary
DDL defines and evolves table STRUCTURE (CREATE, ALTER, DROP) — changes are 
structural and often affect the whole table. DML manages the DATA within that 
structure (INSERT, UPDATE, DELETE) — changes are row-level and controlled by 
WHERE clauses. The single most dangerous mistake in DML is forgetting WHERE — 
always preview with SELECT first.
