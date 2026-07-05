-- what is data ? so data is everything our name, ph no, email etc everything of information we call as data 

-- so where do we store this data ? personally we store this in a txt file, excel, documents, etc.
-- and this is a bad idea of storing because lets say if i want some data like expenses of a month or the how many orders we got ?
-- then we open each and every file we calculate it will be hard to do this 
-- so now we store this in a database
-- what is data base so a database is a container which stores the data 
-- so now if we want to find something in the database we cannot directly talk to database so to talk to database we need to use a language called sql
-- so what is sql sql is a structured query language used to talk to the database
-- so now lets say we are not only the person who is accessing the database but also many people can access 
-- and send requests via websites, powerbi, or developers then all these requests to be managed 
-- so to manage the database we need a software called dbms database management system 
-- it is used to manage all requests that are coming from various sources and so it acts like a mediator between the sql and the database
-- so user sends the sql to dbms then dbms manages which sql to execute first if we have multiple requests and it sends that request to database and it db sends the output to dbms and then it sends to the user
-- so now the database we cannot run it in our local machine so we place these database in the server a place where the database lives and this server make the database available 24/7 
-- and in dbms we have the softwares like postgresql, mysql, sql server, oracle all these are the softwares not a language or database 
-- in the dbms we have two types relational and non-relational
-- so relational dbms stores the data in the database in a organised way in the form of tables 
-- so the name relational means each and every table will be in relationship with another tables 
-- why cannot we store all the data in a single table ? because if we place all data in single table lets say orders then a customer orders 100 plus orders then 
-- we store that 100 rows for a single customer and if we want to manage the data of it or make any requirements then it is hard to manage 
-- so if we store them in multiple tables in relations then it is easy to manage them 
-- we also have non-relational dbms they store the data in different formats like graphs, column-based, files, key-value pairs for each type we have a different software to manage the data
-- database structure ? how we have ?
-- first we have server > database > schema > tables 
-- so schema is like a category of something like sales can be a schema and inside this schema we can have multiple tables like customers, orders, etc
-- and table contains rows and columns, so a column is a main category or the datatype which stores the data depending on column type
-- so ex: column name = firstname and we set the data type to varchar then it stores the data of string values only it cannot store another datatype
-- so what are the datatypes 
-- numeric we can have int, decimal
-- string we have char and varchar 
-- difference between char and varchar so if we say char(4) then it store the memory size of 4 even if you store a 2 values in it and the remaining will be stored as empty spaces
-- but varchar(4) then it stores the data in variable so if we give 2 values then it uses that 2 values length 
-- so when to use char and when to use varchar ? so if we know the like exact character length of the data lets say gender we can have m or f so a single character or we can use currency codes which have 3 characters so we can use char(3) or in y or n case we can use char(1)
-- so varchar is flexible so it stores the character length and takes 1 or 2 bytes 
-- why this extra 1 or 2 bytes took by system because this extra bytes tells the system like when to stop and when to begin the storing the data 
-- why we use varchar(255) number why not any other number ? because it is a sweet spot mostly the characters or the fields like name, email address, they will be below 255 characters only
-- and also in the memory terms 255 takes 8 bits of memory which means for that column it takes extra only 1 byte and if we take varchar(256) then for that column it takes 2 bytes for each row not 1 byte 
-- dates we have date(), now(), datetime()


-- sql commands 
-- dql, ddl, dml, dcl, tcl
-- we have dql data query language in this we have only one command which is "select" so it is used like show me the data so select is like asking for the data
-- ddl data definition language - it is used to control the structure of the database so in this we have create, alter, drop these are used to control the structure not the data inside them 
-- dml data manipulation language - so it is used to control or manage the data inside the table so it have insert, update, delete these are used to manipulate manage the data but these commands dont change the structure
-- dcl data control language - it is used for granting the permissions and revoking the granted permissions we have grant and revoke manage the permissions of the users
-- tcl transaction control language -  commit, rollback and savepoint these commands are used to manage the dml commands so whatever dml commands we perform we use these tcl commands so that these will act as a safety net so that if something goes wrong then we can restore them 




-- how can we query data ? we can use the select command to retrieve the data from the database and this select command is just for showing the data and it does not make any changes to the existing tables

-- sql clauses: query order  
-- select
-- distinct
-- top
-- from
-- join
-- where
-- group by
-- having
-- order by
-- limit


--select is used to selet the data  
-- from is used to 
-- telling that which table to choose

-- first we connect the database which we want to use
-- so we use the command use databasename
use MyDatabase;    -- now we have connected to MyDatabase 


-- so what it means select * means get all the columns everything from the table 
-- from tells the database to take this table i want the data to be shown 
-- so syntax will be like select * from tablename

-- so now sql task to retrieve all the data from the customers table so now we use this 
select * from customers;

select * from orders



-- so now using the * is not a good habit in the real life instead we will use specific columns or the required columns we need to see then 
-- we can mention the column names which we want to show we can mention the column names and we use the comma for seperating the columns
-- select columnname1, columnname2 from tablename

-- sql task - retrieve the customers name, country and score
select
    first_name, 
    country,
    score
from customers

select * from customers

select country, first_name, score from customers


-- where is used for telling the database to show me a particular data from the data so it will be condition 
-- so the condition can be anything like get all the customers age greater than 30 etc
-- where condition  so the execution order 
-- select * from customers where condition 
-- so first from --> where --> select 

-- sql task - so get all the customers whose score is greater than 500
select * from customers where score > 500

-- sql task - retrieve all the customers whose score not equal to 0
select * from customers where score != 0


select * from customers where country = 'germany'

select first_name, country from customers where country = 'germany'



-- order by - is used to sort the data in ascending or descending order 
-- syntax is like order by columnname asc or order by columnname desc
-- so if we dont mention the asc or desc, sql by default it sorts the data in ascending order 
/*
sql order with order by 
from --> orderby --> select
*/

-- sql task - show me the customers based on highest score first 
select * from customers order by score desc;


-- Nested orderby 
/*
lets say we are sorted the country but if we have the same name/value then the sorting may not be clear
i mean the other columns values like for example the score can be show in the desc/asc 
*/

-- sql task - show me all the data arrange them in country asc and highest score 
select * from customers order by country asc;
1	Maria	Germany	350
4	Martin	Germany	500
3	Georg	UK	750
5	Peter	USA	0
2	 John	USA	900
-- we see that the score is not arraged in order they are like desc order they are in asc order 
-- so now we use the nested order by 

select * from customers order by first_name desc, country asc, score desc;
-- now the score is in desc order and the country is in asc order 

-- how the nested order by works ?
1	Maria	Germany	350
2	 John	USA	900
3	Georg	UK	750
4	Martin	Germany	500
5	Peter	USA	0
-- it works based on the duplicates of the rows we have in the order by column mentioned
-- so order by country, score means sql first sorts the data in the mentioned order next if we given another column score 
-- then sql first checks whether do we have any duplicate rows are there or not in the first order by column 
-- so in country column we have the germany, usa duplicates repeating two times so its a tie 
-- so now sql take those duplicate rows which are id 1, 2, 4, 5 so now in the second order by sql perform sorting for these 4 rows only the unique or differnt rows did not perform sorting
-- because it only takes the duplicates so now in the second order by it perform sorting so the score of these rows will be sorted in mentioned order 
-- so the sorting will be done for the matching records so in our case germany is two times and have the score 350 and 500 so 
-- so the scores will be sorted only for these two germany rows so the output will be 500 350 desc order 
-- it will not combine all the duplicates and sort them all it will take the grouping of the matching records and then apply sorting for those matching records
select * from customers order by country asc, score desc

-- output:
4	Martin	Germany	500
1	Maria	Germany	350
3	Georg	UK	750
2	 John	USA	900
5	Peter	USA	0

-- so lets say if we switch the order of sorting of columns
select * from customers order by score desc, country asc
-- output:
2	 John	USA	900
3	Georg	UK	750
4	Martin	Germany	500
1	Maria	Germany	350
5	Peter	USA	0

-- so now here the only the score will apply the sorting, it will not apply the sorting for the country column 
-- why because in the score column we dont have any duplicate values so because of this
-- sql will bypass or ignore the sorting for the country column 






-- Group by
-- it is used to combine the matching rows to a one single
-- we can use this group by with the aggregation operations when we want like find the customers and their total orders they made or some calculation related
-- so main point we need to remember is when we are working with the group by we must need to use the columns which we are using in the group by or the non-aggregate columns 
-- here is the example question
-- sql task - find the total score for each country
-- here we want to group the countries and we need to calculate the total score of that country

select country, sum(score) as total_scores from customers group by country
-- this will work but now if you add one more column which is not using in the aggregation and in the group by, then it will throw error
select first_name, country, sum(score) as total_score from customers group by country  -- this will throw error here first_name is not used in the aggregation and group by
-- and another one 
select country, score, sum(score) as total_scores from customers group by country -- this will also not work even though we mentioned the score in the aggregate it fails because sql assumes "score" column is a non-aggregate column and we are not using this in the group by also and that you are asking individual value of the score column so it confuses sql since we are not grouping it
-- so to work this we need to mention the column in the group by 

-- nested group by 
select country, score, sum(score) as total_scores from customers group by country, score
-- how group by nesting works ?
-- so group by combines country and score, so it treats both as one value and it checks whether any row matches to this or not if it matches then it combines them to a single row 
-- if not it treats as a seperate row 
-- so country + score which means  germany + 350 it checks which row have this same data 
USA	0	0
Germany	350	350
Germany	500	500
UK	750	750
USA	900	900  
-- since we dont have any matching rows it will show them seperately


-- select first_name, country, sum(score) as total_score from customers group by country -- gives error because we are not using first_name in the aggregation or in the group by

select country,first_name, sum(score) as 'total score' from customers group by country, first_name



-- sql task - find the total no.of customers and total score for each country
select country, sum(score) as total_score, count(*) as total_customers from customers group by country

-- count(*) vs count(columnname) vs count(distinct columnname)
-- so count() is an aggregate function used for counting the number of rows we have in the table
-- so count(*) counts the no of rows including the null values 
-- so count(columnname) counts no.of rows excluding null values, it doesnt include the null values in the count
-- so count(distinct columnname) first it excludes the null values and counts the unique rows only without including duplicate rows

-- so we mostly use the count(*) to find all no.of rows but count(columnname) is used specifically for finding the no.of rows where we need to count the actual data 
-- so lets say how many customers signed in then in this case we can use count(customers) then we get the actual count excluding null values 


--having clause
-- it is used for filtering the data only after grouping the data 
-- so it is used with the group by clause and it is helpful for applying the conditions for the aggregation functions
-- lets say we want to find total score > 750 for each country
select country, sum(score) as total_score from customers group by country having sum(score) > 750
-- here the where clause will not work because the conditions are aggregate functions and where clause does not allow it so we use the having clause


-- sql task - find the avg score for each country considering only customers whose score not equal to 0 and avg score greater than 430
select country, avg(score) as avg_score from customers where score ! = 0 group by country having avg(score) > 430



-- distinct()
-- it is used for removing the duplicates and shows the unique values only of the column
-- get unique values from the table
select distinct country from customers

-- sql task - find the count of the countries who have their total count greater than 1  
select country, count(country) as no_of_duplicates from customers group by country having count(country) > 1;



-- top(limit)
-- it is used for telling the sql how many rows we want to show 
-- it does not do any operations or calculations it just show number of rows we want to see

-- so lets say we want the starting 3 rows only to show then we use like this
select top 3(score) from customers -- shows only score column with top 3 rows 

select top 3 * from customers;   -- shows all the colums with top 3 rows  


-- sql task - top 3 customers with highest scores 
select top 3 * from customers order by score desc

-- top 2 lowest scores 
select top 2 * from customers order by score

-- get the 2 most recent orders 
-- to get the most recent orders which means the date will be latest which means we need to use order by desc so that we get the recent dates
select * from orders;

select top 2 * from orders order by order_date desc


-- execution order |  coding order
/*
from						select top 3 col1, distinct col2,... 
where						from table 
group by						where condition
having 						group by col1
distinct						having aggr_func
order by						order by col1
top 
*/


-- static values without using the tables we can show the static data in table 

select 123 as static_num

select 'shiva' as static_value


-- we can combine static and the table columns also 

select first_name, country, 'shiva' from customers -- we see that 'shiva' value is shown for all the rows






------------ FORMATED NOTES ------------------ 
# Day 1 – SQL Fundamentals

## Learning Objectives

After completing this chapter, you should understand:

- What Data is
- What a Database is
- What DBMS is
- Difference between Database and DBMS
- Relational vs Non-Relational Databases
- Database Structure
- Datatypes
- SQL Command Categories
- SQL Query Execution Order
- SELECT
- WHERE
- ORDER BY
- GROUP BY
- HAVING
- DISTINCT
- TOP / LIMIT
- Aggregate Functions

---

# 1. What is Data?

## Definition

Data is any piece of information that can be stored and processed.

Examples:

- Customer Name
- Phone Number
- Email Address
- Salary
- Product Price
- Order Date

Everything that represents information is called **Data**.

---

## Why is Data Important?

Every company makes decisions based on data.

Examples:

- Amazon stores customer orders.
- Netflix stores watch history.
- Swiggy stores delivery information.
- Banks store transaction history.

Without data, businesses cannot operate effectively.

---

# 2. What is a Database?

## Definition

A Database is an organized collection of data that allows information to be stored, managed and retrieved efficiently.

Instead of storing information in multiple Excel files or text documents, companies store it inside databases.

---

## Why Do We Need Databases?

Imagine an online shopping company with:

- 20 million customers
- 500 million orders
- Thousands of products

Searching through Excel files would be extremely slow.

Databases solve this problem by organizing data for fast retrieval and management.

---

## Real World Example

Amazon cannot store millions of customer orders in Excel files.

Instead, customer information, products and orders are stored inside databases where they can be searched within milliseconds.

---

# 3. What is DBMS?

## Definition

DBMS (Database Management System) is software that manages communication between users/applications and the database.

Examples:

- PostgreSQL
- MySQL
- SQL Server
- Oracle Database

A DBMS is **not** the database itself.

It is the software that controls the database.

---

## Why Do We Need a DBMS?

Many users may access the database simultaneously.

For example:

- Website
- Mobile App
- Power BI Dashboard
- Data Analyst
- Backend Developers

The DBMS manages all incoming requests and safely communicates with the database.

---

## How DBMS Works

```
User
      │
      ▼
SQL Query
      │
      ▼
DBMS
      │
      ▼
Database
      │
      ▼
Results
```

---

## Business Perspective

Without a DBMS:

- Multiple users could overwrite each other's data.
- Requests would conflict.
- Data consistency would be difficult to maintain.

The DBMS ensures reliable and secure access to data.

---

# 4. Database vs DBMS

| Database | DBMS |
|------------|----------------------------|
| Stores data | Manages the stored data |
| Passive storage | Active software |
| Contains tables | Executes SQL queries |
| Cannot manage users | Handles users and permissions |

---

# 5. Relational Database (RDBMS)

## Definition

A Relational Database stores information in multiple related tables.

Instead of storing everything in one large table, data is divided into logical tables.

Example:

Customer Table

| CustomerID | Name |
|------------|------|

Orders Table

| OrderID | CustomerID |

The CustomerID creates the relationship.

---

## Why Multiple Tables?

Suppose one customer places 500 orders.

If customer details are repeated in every row:

- Storage increases
- Updates become difficult
- Duplicate information grows

Using relationships avoids redundancy and keeps the database organized.

---

# 6. Database Structure

```
Server
   │
Database
   │
Schema
   │
Tables
   │
Rows & Columns
```

### Server

The physical or cloud machine where databases are stored.

### Database

A collection of related data.

### Schema

A logical grouping of related tables.

Example:

Sales Schema

- Customers
- Orders
- Products

### Table

Stores related information.

### Row

One complete record.

### Column

One attribute of the record.

---

# 7. Datatypes

| Datatype | Purpose | Example |
|------------|----------------|----------------|
| INT | Whole Numbers | 25 |
| DECIMAL | Decimal Numbers | 99.99 |
| CHAR | Fixed Length Text | M, F, USD |
| VARCHAR | Variable Length Text | Customer Name |
| DATE | Date | 2026-07-05 |
| DATETIME | Date & Time | 2026-07-05 10:30 |

---

## CHAR vs VARCHAR

### CHAR

Stores fixed-length values.

Example

```
CHAR(3)

IND
USA
```

Always reserves space for three characters.

Best for:

- Gender
- Country Code
- Currency Code

---

### VARCHAR

Stores only the required number of characters.

Best for:

- Names
- Addresses
- Emails

Because different values have different lengths.

---

## Best Practice

Use CHAR only when the length is always fixed.

Use VARCHAR for most text columns.

---

# 8. SQL Command Categories

| Category | Commands | Purpose |
|-----------|----------|----------|
| DQL | SELECT | Retrieve Data |
| DDL | CREATE ALTER DROP | Structure |
| DML | INSERT UPDATE DELETE | Data Manipulation |
| DCL | GRANT REVOKE | Permissions |
| TCL | COMMIT ROLLBACK SAVEPOINT | Transactions |

---

# 9. SQL Query Execution Order

Although SQL is written like this:

```
SELECT
FROM
WHERE
GROUP BY
HAVING
ORDER BY
LIMIT
```

Internally SQL executes like this:

```
FROM

↓

WHERE

↓

GROUP BY

↓

HAVING

↓

SELECT

↓

DISTINCT

↓

ORDER BY

↓

LIMIT
```

Understanding this order explains many SQL errors.

---

# 10. SELECT

## Purpose

Retrieves data from a table.

Example

```sql
SELECT *
FROM customers;
```

---

## Best Practice

Avoid

```sql
SELECT *
```

Instead

```sql
SELECT
customer_name,
country
FROM customers;
```

Selecting only required columns improves readability and performance.

---

## Business Example

Marketing wants only customer names and countries.

There is no reason to retrieve every column from the table.

---

# 11. WHERE

## Purpose

Filters rows before any grouping happens.

Example

```sql
SELECT *
FROM customers
WHERE country = 'Germany';
```

---

## Business Example

A manager asks:

"Show only German customers."

WHERE filters the dataset before analysis begins.

---

# 12. ORDER BY

## Purpose

Sorts the final output.

```sql
SELECT *
FROM customers
ORDER BY score DESC;
```

---

## Multiple ORDER BY

```sql
ORDER BY country ASC,
         score DESC;
```

SQL sorts by Country first.

Within each country it sorts by Score.

---

## Business Example

Top customers by revenue.

Newest orders.

Highest sales.

Lowest inventory.

---

# 13. GROUP BY

## Purpose

Groups similar rows together so aggregate calculations can be performed.

Example

```sql
SELECT
country,
SUM(score)
FROM customers
GROUP BY country;
```

---

## Business Thinking

Managers rarely need every individual transaction.

They usually ask:

- Revenue by Country
- Revenue by Month
- Orders by Product
- Customers by City

GROUP BY converts raw data into business summaries.

---

## Rule

Every selected column must either:

- appear inside GROUP BY

OR

- be used inside an aggregate function.

---

# 14. Aggregate Functions

Common aggregate functions

```
COUNT()

SUM()

AVG()

MAX()

MIN()
```

These calculate values for each group.

---

# 15. HAVING

## Purpose

Filters grouped results.

Example

```sql
SELECT
country,
SUM(score)
FROM customers
GROUP BY country
HAVING SUM(score) > 700;
```

---

## WHERE vs HAVING

WHERE

↓

Filters individual rows

HAVING

↓

Filters grouped results

---

# 16. DISTINCT

Removes duplicate values.

```sql
SELECT DISTINCT country
FROM customers;
```

Useful when only unique values are required.

---

# 17. TOP / LIMIT

Restricts the number of rows returned.

SQL Server

```sql
SELECT TOP 5 *
FROM customers;
```

PostgreSQL / MySQL

```sql
SELECT *
FROM customers
LIMIT 5;
```

---

# 18. Professional Best Practices

✅ Avoid SELECT *

✅ Write readable SQL

✅ Use aliases

✅ Select only required columns

✅ Format SQL consistently

✅ Understand execution order

---

# 19. Common Beginner Mistakes

❌ Using HAVING instead of WHERE

❌ Forgetting GROUP BY rules

❌ Using SELECT *

❌ Confusing Database with DBMS

❌ Not understanding SQL execution order

---

# 20. Interview Tips

Be prepared to answer:

- What is SQL?
- Difference between Database and DBMS?
- Difference between WHERE and HAVING?
- Difference between CHAR and VARCHAR?
- Why do companies use databases?
- Why should SELECT * be avoided?
- Explain GROUP BY with an example.

---

# 21. Key Takeaways

- Data is raw information.
- Databases organize and store data.
- DBMS manages access to databases.
- SQL communicates with databases.
- RDBMS stores data in related tables.
- SELECT retrieves data.
- WHERE filters rows.
- GROUP BY summarizes data.
- HAVING filters grouped results.
- ORDER BY sorts data.
- DISTINCT removes duplicates.
- LIMIT/TOP restricts returned rows.

