-- COMBINING DATA
-- we can combine the data in two ways row wise and column wise 
-- we have two things here 
-- 1. joins and    2. set operators
-- so for row wise we use the set operators like union, union all, intersect and except
-- so for column wise we use the joins


-- 1. joins
-- what is a join ? 
-- it is used to combine the columns from two or more tables 
-- by default sql uses the inner join if we did not mention any join name and we simply mention just 
-- like this then it uses inner join
select * from customers join orders on customers.id = orders.customer_id
-- o/p:
1	Maria	Germany	350	1001	1	2021-01-11	35
2	 John	USA	900	1002	2	2021-04-05	15
3	Georg	UK	750	1003	3	2021-06-18	20



-- why we use joins ? 
-- we use it because to find or get the information about multiple tables together to get a meaningful data 
-- we use it to get the extra information like finding no.of order by customers it will give a new information about customers
-- filtering purposes i mean if we join the tables it will group them to show whether we have or not 



-- types of joins
-- Basic Joins
-- inner join, 
-- left join, 
-- right join, 
-- self join, 
-- full join

-- Advanced Joins
-- left anti join, 
-- right anti join, 
-- full anti join, 
-- cross join


-- sql task - retrieve all the customers and orders as two seperate results 
select * from customers;
select * from orders;


-- inner join 
-- it only takes the matching rows from two tables
-- so it first checks whether the values in the left table have any matching values in the right table 
-- if yes then it show the data in the table, if not, it will ignore those values
-- we can combine the tables in any way i mean we can mention left table first or right table first the result doesnt change


-- SQL TASK - get all the customers along with their orders, but only the customers who have placed the orders
-- so now lets understand the question what we want 
-- so we want the customers details about orders, so customers who placed the orders means 
-- in the customers table we have customers id and in the orders table we are using the customer_id to store the customers id 
-- so what we want to find if we have the customer id present in the orders table which means 
-- that customer placed an order so we need to join based on the customer id and since we need to find 
-- that customer id to be present in customers and orders table which gives us the customers who placed an order
select * from customers inner join orders on customers.id = orders.customer_id
-- o/p:
id   first_name country   score    order_id    customer_id   order_date    sales 
1       Maria	 Germany   350	    1001	       1	      2021-01-11	35
2	    John	  USA	   900	    1002	       2	      2021-04-05	15
3	    Georg	  UK	   750	    1003	       3	      2021-06-18	20

-- here we can see that id column and the customer_id values are same which means we got the customers who placed orders



-- PROBLEM - if we have the same column names from both the tables we are joining in that case what we do ? 
-- we simply mention the table name followed by the (.) and followed by column name
-- like this tablename.columnname
-- ex: customers.id, orders.customer_id, customers.score, orders.order_date, etc
select customers.id, customers.first_name, orders.order_id, orders.order_date, orders.sales  from customers inner join orders on customers.id = orders.customer_id
-- o/p:
1	Maria	1001	2021-01-11	35
2	 John	1002	2021-04-05	15
3	Georg	1003	2021-06-18	20


-- so mentioning everytime the tablename everytime for the column we can make it simpler in this way
select c.id, c.first_name, o.order_id, o.order_date, o.sales  from customers c inner join orders o on c.id = o.customer_id
-- o/p:
1	Maria	1001	2021-01-11	35
2	 John	1002	2021-04-05	15
3	Georg	1003	2021-06-18	20



-- left join
-- it takes all the data from the left table and the matching data from the right table 
-- and it ignores the right table data 
-- NOTE:  we need to make sure the order we are joining the tables when we are working with the left or right join
-- if we join them in wrong order i mean right table first and left table next and we use left join
-- then it will give the data of the right table data not the left table data because we are starting the right table first


-- get all the customers along with orders and inluding those without orders
-- we want the customers data only and the orders that customers have placed or not placed we dont care 
-- we want to customers data thats it
-- which means all the data of customersand the matching data of customers

select * from customers c left join orders o on c.id = o.customer_id
-- o/p:
| id | first_name | country | score | order_id | customer_id | order_date | sales |
| -: | ---------- | ------- | ----: | -------: | ----------: | ---------- | ----: |
|  1 | Maria      | Germany |   350 |     1001 |           1 | 2021-01-11 |    35 |
|  2 | John       | USA     |   900 |     1002 |           2 | 2021-04-05 |    15 |
|  3 | Georg      | UK      |   750 |     1003 |           3 | 2021-06-18 |    20 |
|  4 | Martin     | Germany |   500 |     NULL |        NULL | NULL       |  NULL |
|  5 | Peter      | USA     |     0 |     NULL |        NULL | NULL       |  NULL |

-- here we see that we also have the null values because those are the customers who did not ordered anything so thats why their orders data is showing null





-- right join 
-- it is same as left join, but it will take all the data from the right table and the matching data from the left table
-- it shows the data from the right table and the matching data from the left table


-- SQL TASK: get all the customers along with the orders including orders but without the customers
-- here we join the right table first and next we join left table 
select * from customers c right join orders o on c.id = o.customer_id

-- instead of this we can get the same result using left join
select * from orders o left join customers c on c.id = o.customer_id




-- full join
-- it returns everything from both the tables the matching or not matching everything shows
-- get all the customers and orders even dont match 

-- SQL TASK: get all the customers and orders, even if there is no match
select * from customers full join orders on customers.id = orders.customer_id




-- ADVANCED SQL JOINS
-- LEFT ANTI JOIN
-- so it takes all the data from the left table and the not matching data from the right table
-- which means all the data in the left table we want but, we will combine the data in the right table whose value is null
-- which will give us the not matching data
-- so we dont have a command like using left anti join 
-- so we will use the left join, for the left anti join also but also with the where clause 


-- SQL TASK: get all the customers who have not placed any orders
-- which means the customers did not placed any orders so the value for that customers in the orders table 
-- will be having a null values so if we use the orders.customer_id null then we get the answer 
-- that those customers did not placed any orders

-- we use left join here because if we find the customers who have ordered then we can easily find
select * from customers left join orders on customers.id = orders.customer_id

-- this will give the left join but we want left anti join so we use where clause
select * from customers left join orders on customers.id = orders.customer_id where orders.customer_id is null

-- o/p:
id | first_name | country | score | order_id | customer_id | order_date | sales
---+------------+---------+-------+----------+-------------+------------+-------
4  | Martin     | Germany | 500   | NULL     | NULL        | NULL       | NULL
5  | Peter      | USA     | 0     | NULL     | NULL        | NULL       | NULL




-- RIGHT ANTI JOIN
-- it is opposite of LEFT ANTI JOIN 
-- so we want all the data from the right table and the not matching data from the left table
-- so here also we dont have any special command for right anti join so we use the right join


-- SQL TASK: get all the orders without matching customers
-- so first we combine the data and then we filter it so we got the right join 
select * from customers right join orders on customers.id = orders.customer_id 

-- now we will use the right join but we want right anti join so we use where clause
select * from customers right join orders on customers.id = orders.customer_id where customers.id is null


-- USING IT WITH LEFT JOIN
select * from orders left join customers on orders.customer_id = customers.id where customers.id is null

-- o/p:
|order_id | customer_id | order_date | sales | id   | first_name | country | score |
| -------: | ----------: | ---------- | ----: | ---- | ---------- | ------- | ----: |
|     1004 |           6 | 2021-08-31 |    10 | NULL | NULL       | NULL    |  NULL |




-- FULL ANTI JOIN
-- it shows only the unmatching rows from both tables
-- it is opposite of inner join
-- so inner join will show the matching data from both tables so now for full anti join we want the unmatching data 
-- so we here we dont have a command like full anti join, instead we will use the full join with where clause
-- so we want to see only the unmatching data 


-- SQL TASK: find all the customers without orders and orders without customers
-- so now first we use the full join and next we use the where clause to get full anti join
select * from customers full join orders on customers.id = orders.customer_id 


-- using where clause with full join to get full anti join 
select * from customers full join orders on customers.id = orders.customer_id where customers.id is null or orders.customer_id is null

-- o/p:
| customers.id | first_name | country | score | order_id | customer_id | order_date | sales |
| ------------ | ---------- | ------- | ----- | -------- | ----------- | ---------- | ----- |
| 4            | Martin     | Germany | 500   | NULL     | NULL        | NULL       | NULL  |
| 5            | Peter      | USA     | 0     | NULL     | NULL        | NULL       | NULL  |
| NULL         | NULL       | NULL    | NULL  | 1004     | 6           | 2021-08-31 | 10    |



-- IMPORTANT QUESTION
-- Q. WHY WE HAVE TO USE OR OPERATOR INSTEAD OF AND OPERATOR ?
-- because of full join, so what full join does get all data from left table and all data from right table
-- and matching data from both tables and it excludes all the unmatching data in the same row 
-- so while using full join we dont have the unmatching rows in the table 
-- so since the and operator only shows the data when both conditions are true which means on both sides the data to be unmatched which is not possible in full join
-- so we will use or operator so that we can get all the unmatching data from both tables but not in the same row 


-- Q. SINCE THE FULL ANTI JOIN IS OPPOSITE TO INNER JOIN WHY CANT WE USE THE WHERE CLAUSE USING INNER JOIN ? 
-- since the inner join removes all the unmatching data from both tables after join so we dont have the data 
-- of unmatching data inside the tables so using where clause with inner join will give us empty data 





-- SQL TASK: get only the customers who have placed the orders without using inner join 
-- so to find the customers who have not placed an order we used where customers.id is null 
-- so to find the customers who placed an order then we use not operator
select * from customers left join orders on customers.id = orders.customer_id where orders.customer_id is not null

-- o/p:
| id | first_name | country | score | order_id | customer_id | order_date | sales |
| -: | ---------- | ------- | ----: | -------: | ----------: | ---------- | ----: |
|  1 | Maria      | Germany |   350 |     1001 |           1 | 2021-01-11 |    35 |
|  2 | John       | USA     |   900 |     1002 |           2 | 2021-04-05 |    15 |
|  3 | Georg      | UK      |   750 |     1003 |           3 | 2021-06-18 |    20 |

-- now we got the customers who placed the orders




-- CROSS JOIN
-- it combines all the left table data with all the right table data each and every row
-- we dont need the condition for this like matching with the column because it combines everything in both side
-- like it shows all possible combinations
-- so one row in the left table will be combined with all rows in the righ table 
-- NOTE: if we have null values in the table then they are ignored, because a null value is unknown value so it cannot be compared with another value 


-- SQL TASK: find all possible combinations from customers and orders
select * from customers cross join orders

-- o/p:
| id | first_name | country | score | order_id | customer_id | order_date | sales |
| -: | ---------- | ------- | ----: | -------: | ----------: | ---------- | ----: |
|  1 | Maria      | Germany |   350 |     1001 |           1 | 2021-01-11 |    35 |
|  2 | John       | USA     |   900 |     1001 |           1 | 2021-01-11 |    35 |
|  3 | Georg      | UK      |   750 |     1001 |           1 | 2021-01-11 |    35 |
|  4 | Martin     | Germany |   500 |     1001 |           1 | 2021-01-11 |    35 |
|  5 | Peter      | USA     |     0 |     1001 |           1 | 2021-01-11 |    35 |
|  1 | Maria      | Germany |   350 |     1002 |           2 | 2021-04-05 |    15 |
|  2 | John       | USA     |   900 |     1002 |           2 | 2021-04-05 |    15 |
|  3 | Georg      | UK      |   750 |     1002 |           2 | 2021-04-05 |    15 |
|  4 | Martin     | Germany |   500 |     1002 |           2 | 2021-04-05 |    15 |
|  5 | Peter      | USA     |     0 |     1002 |           2 | 2021-04-05 |    15 |
|  1 | Maria      | Germany |   350 |     1003 |           3 | 2021-06-18 |    20 |
|  2 | John       | USA     |   900 |     1003 |           3 | 2021-06-18 |    20 |
|  3 | Georg      | UK      |   750 |     1003 |           3 | 2021-06-18 |    20 |
|  4 | Martin     | Germany |   500 |     1003 |           3 | 2021-06-18 |    20 |
|  5 | Peter      | USA     |     0 |     1003 |           3 | 2021-06-18 |    20 |
|  1 | Maria      | Germany |   350 |     1004 |           6 | 2021-08-31 |    10 |
|  2 | John       | USA     |   900 |     1004 |           6 | 2021-08-31 |    10 |
|  3 | Georg      | UK      |   750 |     1004 |           6 | 2021-08-31 |    10 |
|  4 | Martin     | Germany |   500 |     1004 |           6 | 2021-08-31 |    10 |
|  5 | Peter      | USA     |     0 |     1004 |           6 | 2021-08-31 |    10 |


-- How many rows does a CROSS JOIN return?
select (select count(id) from customers) as customers_count , 
       (select count(order_id) from orders) as orders_count,
       ((select count(id) from customers) * (select count(order_id) from orders)) as cross_join_count




-- MULTI TABLE JOINS
-- we can combine multiple tables using multi joins to retrieve the data from multiple tables to get meaningful information and to get extra information
-- so to combine multiple tables we can follow these ways 
-- 1. identifying the main table so that we can connect the other tables to this main table when we want all the data from main table to show without missing anything
-- so we can use left join it will not miss anything from the main table
-- 2. we can combine multiple tables with multiple joins also on the basis of the data we want to find
-- 3. when we are taking about a table we can identify them whether this can be a main table or this data we want to till all the joins then we can treat that table as main table 


-- we are now using the salesDB
use SalesDB;



select * from sales.customers

select * from sales.employees

select * from sales.orders

select * from sales.ordersarchive

select * from sales.products



-- SQL TASK
-- using salesdb retrieve list of orders along with the related customers, product, and employee details
-- for each order display
-- order id
-- customer name
-- product name
-- sales
-- product price
-- salesperson name

-- so here we can treat orders as main table, because we are taking about the orders and we dont want to miss any orders data 
-- then we will use the left join and combine the other tables using left join to the main table which is orders 
select 
orderID, 
c.FirstName as customer_firstname,
c.LastName as customer_lastname,
p.Product as product_name,
o.Sales,
p.Price as product_price,
e.FirstName as emp_firstname,
e.LastName as emp_lastname
from sales.orders as o
left join sales.customers as c on o.CustomerID = c.CustomerID
left join sales.Products as p on o.ProductID = p.ProductID
left join sales.Employees as e on o.SalesPersonID = e.EmployeeID



-- SET operations
-- it combines the tables in row wise while the joins combine the tables in column wise 
-- we can use the set operators with two or more select statements 

-- there are 4 types of set operations
-- 1. union
-- 2. union all
-- 3. intersect 
-- 4. except

-- Rules must to follow while using the set operators
-- 1. order by clause can only be used once at the end of the query to sort the final result, cannot be used in each select query
select firstname, lastname from sales.customers			
union													 
select lastname, firstname from sales.employees	
order by FirstName;     -- so we will use only order by clause and that to at the end of the query not in the middle


-- 2. both select queries need to have same number of columns
select FirstName, LastName from sales.Customers   -- here we have 2 columns
union
select FirstName, LastName from sales.Employees   -- here we have 2 columns


-- 3. both select queries need to have same datatypes columns
select FirstName, LastName from sales.Customers   -- here we have varchar data type
union
select FirstName, LastName from sales.Employees   -- here we have varchar data type

select FirstName from sales.Customers  -- here we have varchar data type
union
select month from sales.monthly_sales  -- here we have varchar data type

-- the below query is wrong, because first select query and second select query datatypes doesnt match
select FirstName, LastName from sales.Customers   -- here we have varchar data type 
union
select BirthDate, Gender from sales.Employees   -- here we have date() and char() data type


-- 4. follow same order of columns and the data types  
-- if we change the order of the columns then it will throw error because 
select FirstName, score from sales.Customers   -- here we have first varchar() and second int() data type 
union
select Salary, LastName from sales.Employees   -- here we have first int() and second varchar() data type

-- so it must follow the same order also 
select FirstName, score from sales.Customers   -- here we have first varchar() and second int() data type 
union
select LastName, Salary from sales.Employees   -- here we have first varchar() and second int() data type 


-- 5. first query have the control of column names so if we want to change/using alias then we do in the first query because the second query is ignored by sql
select FirstName, score from sales.Customers   -- here we have firstname and score columns
union
select LastName, Salary from sales.Employees   -- here we have lastname and salary columns
-- so now sql will take the first select query column names to show in the result table like this 

-- o/p:
| FirstName   | score |      -- here we see that the columns are same as the first select query 
| ------      | ----: |
| NULL        | 75000 |
| Jossef      |   350 |
| Anna        |  NULL |
| Baker       | 55000 |
| Brown       | 65000 |
| Kevin       |   900 |
| Lee         | 55000 |
| Mark        |   500 |
| Mary        |   750 |
| Ray         | 90000 |
| White       |  NULL |

select FirstName as user_name, score as score_details from sales.Customers   -- here we have firstname and score columns
union
select LastName, Salary as emp_salaries from sales.Employees  -- here we mentioned the alias also for salary column

-- o/p: 
| user_name   | score_details |      -- here we see that the columns are using alias now, from first select query 
| ------      | ----:         |      -- since we mentioned alias for salary but that alias is ignored 
| NULL        | 75000         |      -- because sql takes only first select query columnname/alias 
| Jossef      |   350         |      -- and remaining queries columnname/alias will be ignored
| Anna        |  NULL         |
| Baker       | 55000         |
| Brown       | 65000         |
| Kevin       |   900         |
| Lee         | 55000         |
| Mark        |   500         |
| Mary        |   750         |
| Ray         | 90000         |
| White       |  NULL         |



-- 6. we are responsible for proper mapping the columns so for example 
-- we used two columns firstname, lastname from one table and same columns firstname, lastname from another column
-- now we combine them using set operators 

select firstname, lastname from sales.customers			-- here we followed all the rules but the mapping is wrong 
union													-- we combined firstname of customers to lastname of employees so this is wrong mapping 
select lastname, firstname from sales.employees			-- so we are responsible for proper mapping 

-- o/p:
| FirstName | LastName |
| --------- | -------- |
| NULL      | Mary     |
| Jossef    | Goldberg |
| Anna      | Adams    |
| Baker     | Carol    |
| Brown     | Kevin    |
| Kevin     | Brown    |
| Lee       | Frank    |
| Mark      | Schwarz  |
| Mary      | NULL     |
| Ray       | Michael  |
| White     | Kevin    |

-- since we followed all the rules but we mapped them with wrong column so we need to make sure that we are mapping to correct column

select firstname, lastname from sales.customers			-- here we followed all the rules
union													-- we mapped the data correctly 
select firstname, lastname from sales.employees			

-- o/p:
| FirstName | LastName |
| --------- | -------- |
| Jossef    | Goldberg |
| Anna      | Adams    |
| Carol     | Baker    |
| Frank     | Lee      |
| Kevin     | Brown    |
| Kevin     | White    |
| Mark      | Schwarz  |
| Mary      | NULL     |
| Michael   | Ray      |


-- IMPORTANT POINT: if we mention the semicolon(;) at the end of first select query then it wont be able to use the union
-- because sql treats semicolon means it is the end of the sql and when it goes to next then it sees union 
-- so it throws the error because query cannot start with set operators 
select FirstName, LastName from sales.Customers;        -- here we added semicolon
union
select FirstName, LastName from sales.Employees

-- o/p:   Incorrect syntax near the keyword 'union'.

-- so we don't add the semicolon in between set operators in queries 
select FirstName, LastName from sales.Customers        -- here we removed semicolon and it works fine 
union
select FirstName, LastName from sales.Employees



-- UNION
-- it returns all the distinct/unique rows from the both queries
-- it removes duplicates from the result 


-- Q. combine all the data from employees and customers INTO ONE TABLE without duplicates
-- so first we check the tables, so that we can understand that which columns we can combine 
select * from sales.Customers  
select * from sales.Employees
-- here we have the common columns and data types we can combine them
-- firstname, lastname from customers table
-- firstname, lastname from employees table

select FirstName, LastName from sales.Customers
| FirstName | LastName |
| --------- | -------- |
| Jossef    | Goldberg |
| Kevin     | Brown    |
| Mary      | NULL     |
| Mark      | Schwarz  |
| Anna      | Adams    |

select FirstName, LastName from sales.Employees
| FirstName | LastName |
| --------- | -------- |
| Frank     | Lee      |
| Kevin     | Brown    |
| Mary      | NULL     |
| Michael   | Ray      |
| Carol     | Baker    |
| Kevin     | White    |


-- IMPORTANT POINT:
-- SPECIAL RULE FOR SET OPERATORS AND DISTINCT CLAUSE
-- before doing union operation we have a special rule 
-- for the set operations (UNION) and distinct when we have duplicates 
-- so if we have the duplicates with NULL values like
-- ex: 
| FirstName | LastName |
| --------- | -------- | 
| Mary      | NULL     |
-- since the NULL is unknown value, only when we are using comparison operators
-- if we are using DISTINCT & SET OPERATORS(UNION), then NULL is treated as identical value 
-- so if we have multiple NULLs also, with this special rule, they will be treated as one single NULL value
-- so if we have 
| FirstName | LastName |
| --------- | -------- | 
| Mary      | NULL     |
| Mary      | NULL     |
| Mary      | NULL     |
| Frank     | Lee      |
| Kevin     | Brown    |
| Mary      | NULL     |

-- then also it treats them as one identical match and shows single row 
| FirstName | LastName |
| --------- | -------- | 
| Mary      | NULL     |
| Frank     | Lee      |
| Kevin     | Brown    |



select ShipAddress from sales.Orders    -- here we have multiple null values inside the column
-- so if we apply the distinct we will get only one NULL value inside the table instead of multiple null values
select distinct ShipAddress from sales.Orders   -- we got only one null value


-- if we use the set operators also it applies this special rule
select FirstName, LastName from sales.Customers
union
select FirstName, LastName from sales.Employees


-- so lets add the different row firstname same and last name different in the employees
select * from sales.employees
insert into sales.employees(employeeid, firstname, lastname) values (6, 'Kevin', 'White')


-- now the kevin and kevin have same firstnames but the lastname is different so it treated as unique 
select firstname, lastname from sales.employees
union
select firstname, lastname from sales.customers





-- UNION ALL
-- it returns all the data including the duplicates from both tables
-- UNION ALL gives the better performance while compared to UNION because it does not perform additional step like removing the duplicates
-- we use UNION ALL when we have no duplicates there in the table to increase the performance 

-- Q. combine all the data from employees and customers INTO ONE TABLE including the duplicates
select firstname, lastname from sales.employees
union all
select firstname, lastname from sales.customers

-- so now here we got the duplicate values also like
| FirstName | LastName |
| --------- | -------- |
| Frank     | Lee      |
| Kevin     | Brown    |
| Mary      | NULL     |        -- duplicate
| Michael   | Ray      |
| Carol     | Baker    |
| Kevin     | White    |
| Jossef    | Goldberg |
| Kevin     | Brown    |
| Mary      | NULL     |        -- duplicate
| Mark      | Schwarz  |
| Anna      | Adams    |





-- EXCEPT 
-- it returns all the unique rows from the first select query that are not present in the second query  
-- so it will give only values which are in the first query and dont want the common data from two queries
-- and also excludes the common data from both the tables
-- it only returns the data that are not present in the first query

-- Q. find the employees who are not customers at the same time 
select firstname, lastname from sales.employees
except
select firstname, lastname from sales.customers


-- Q. find the customers who are not employees at the same time 
select firstname, lastname from sales.customers
except
select firstname, lastname from sales.employees




-- INTERSECT
-- it is similar concept like inner join
-- it returns the common rows from both the tables


-- Q. find all the customers who are also employees
-- what it mean we have to find all the common data from both the tables
select firstname, lastname from sales.customers
intersect 
select firstname, lastname from sales.employees


-- Q. find all the employees who are customers also 
select firstname, lastname from sales.employees
intersect 
select firstname, lastname from sales.customers




-- how we use set opeartors in real life use cases
-- lets say we have multiple tables of same data 
-- for example customers, employees, suppliers, students so these all are the persons data 
-- so in this case we use the union operator to combine those tables to report analysis as we already did above 

-- 2. for example we have multiple orders table divided them into year wise orders so we have the same data 
-- so in that case if we want to some report we use the set operators 


-- Q. orders data stored in the orders and ordersarchive tables 
-- combine all the orders data into one report without duplicates 

select * from sales.Orders
union
select * from sales.OrdersArchive
-- here both the tables follow the rules of set operators so we used * but this is not a good way to write a query 

-- why we need to mention the column names when we are using set operators ? 
-- if we use * instead of columnnames, in future we may change the columns order in the schema or datatypes, etc 
-- then in that case the result we get is different 
-- so instead we mention all the column names

-- TRICK: 
-- so instead of writing all the column names manually in the query we can use the sql server
-- so right click on the table you want the column names and click "select top 1000 rows" option then it will show a query with the result of top 1000 rows 
-- so in the query it will return all the column names so from that we can copy the column names and use here 

SELECT 
       [OrderID]
      ,[ProductID]
      ,[CustomerID]
      ,[SalesPersonID]
      ,[OrderDate]
      ,[ShipDate]
      ,[OrderStatus]
      ,[ShipAddress]
      ,[BillAddress]
      ,[Quantity]
      ,[Sales]
      ,[CreationTime]
FROM Sales.Orders

UNION

SELECT 
[OrderID]
      ,[ProductID]
      ,[CustomerID]
      ,[SalesPersonID]
      ,[OrderDate]
      ,[ShipDate]
      ,[OrderStatus]
      ,[ShipAddress]
      ,[BillAddress]
      ,[Quantity]
      ,[Sales]
      ,[CreationTime]
  FROM Sales.OrdersArchive



-- now we combined both the tables but in the table we cannot able to see like which row is from which table
-- so we can use a static value to treat that table data is from that particular table

SELECT 'Orders' as SourceTable,
       [OrderID]
      ,[ProductID]
      ,[CustomerID]
      ,[SalesPersonID]
      ,[OrderDate]
      ,[ShipDate]
      ,[OrderStatus]
      ,[ShipAddress]
      ,[BillAddress]
      ,[Quantity]
      ,[Sales]
      ,[CreationTime]
FROM Sales.Orders

UNION

SELECT 'OrdersArchive', 
[OrderID]
      ,[ProductID]
      ,[CustomerID]
      ,[SalesPersonID]
      ,[OrderDate]
      ,[ShipDate]
      ,[OrderStatus]
      ,[ShipAddress]
      ,[BillAddress]
      ,[Quantity]
      ,[Sales]
      ,[CreationTime]
  FROM Sales.OrdersArchive

-- o/p:
| SourceTable   | OrderID | ProductID | CustomerID | SalesPersonID | OrderDate  | ShipDate   | OrderStatus | ShipAddress        | BillAddress    | Quantity | Sales | CreationTime                |
| ------------- | ------: | --------: | ---------: | ------------: | ---------- | ---------- | ----------- | ------------------ | -------------- | -------: | ----: | --------------------------- |
| Orders        |       1 |       101 |          2 |             3 | 2025-01-01 | 2025-01-05 | Delivered   | 9833 Mt. Dias Blv. | 1226 Shoe St.  |        1 |    10 | 2025-01-01 12:34:56.0000000 |
| Orders        |       2 |       102 |          3 |             3 | 2025-01-05 | 2025-01-10 | Shipped     | 250 Race Court     | NULL           |        1 |    15 | 2025-01-05 23:22:04.0000000 |
| Orders        |       3 |       101 |          1 |             5 | 2025-01-10 | 2025-01-25 | Delivered   | 8157 W. Book       | 8157 W. Book   |        2 |    20 | 2025-01-10 18:24:08.0000000 |
| Orders        |       4 |       105 |          1 |             3 | 2025-01-20 | 2025-01-25 | Shipped     | 5724 Victory Lane  | *(empty)*      |        2 |    60 | 2025-01-20 05:50:33.0000000 |
| Orders        |       5 |       104 |          2 |             5 | 2025-02-01 | 2025-02-05 | Delivered   | NULL               | NULL           |        1 |    25 | 2025-02-01 14:02:41.0000000 |
| Orders        |       6 |       104 |          3 |             5 | 2025-02-05 | 2025-02-10 | Delivered   | 1792 Belmont Rd.   | NULL           |        2 |    50 | 2025-02-06 15:34:57.0000000 |
| Orders        |       7 |       102 |          1 |             1 | 2025-02-15 | 2025-02-27 | Delivered   | 136 Balboa Court   | *(empty)*      |        2 |    30 | 2025-02-16 06:22:01.0000000 |
| Orders        |       8 |       101 |          4 |             3 | 2025-02-18 | 2025-02-27 | Shipped     | 2947 Vine Lane     | 4311 Clay Rd   |        3 |    90 | 2025-02-18 10:45:22.0000000 |
| Orders        |       9 |       101 |          2 |             3 | 2025-03-10 | 2025-03-15 | Shipped     | 3768 Door Way      | *(empty)*      |        2 |    20 | 2025-03-10 12:59:04.0000000 |
| Orders        |      10 |       102 |          3 |             5 | 2025-03-15 | 2025-03-20 | Shipped     | NULL               | hyd            |        0 |    60 | 2025-03-16 23:25:15.0000000 |
| OrdersArchive |       1 |       101 |          2 |             3 | 2024-04-01 | 2024-04-05 | Shipped     | 123 Main St        | 456 Billing St |        1 |    10 | 2024-04-01 12:34:56.0000000 |
| OrdersArchive |       2 |       102 |          3 |             3 | 2024-04-05 | 2024-04-10 | Shipped     | 456 Elm St         | 789 Billing St |        1 |    15 | 2024-04-05 23:22:04.0000000 |
| OrdersArchive |       3 |       101 |          1 |             4 | 2024-04-10 | 2024-04-25 | Shipped     | 789 Maple St       | 789 Maple St   |        2 |    20 | 2024-04-10 18:24:08.0000000 |
| OrdersArchive |       4 |       105 |          1 |             3 | 2024-04-20 | 2024-04-25 | Delivered   | 987 Victory Lane   | *(empty)*      |        2 |    60 | 2024-04-20 14:50:33.0000000 |
| OrdersArchive |       4 |       105 |          1 |             3 | 2024-04-20 | 2024-04-25 | Shipped     | 987 Victory Lane   | *(empty)*      |        2 |    60 | 2024-04-20 05:50:33.0000000 |
| OrdersArchive |       5 |       104 |          2 |             5 | 2024-05-01 | 2024-05-05 | Shipped     | 345 Oak St         | 678 Pine St    |        1 |    25 | 2024-05-01 14:02:41.0000000 |
| OrdersArchive |       6 |       101 |          3 |             5 | 2024-05-05 | 2024-05-10 | Delivered   | 543 Belmont Rd.    | 3768 Door Way  |        2 |    50 | 2024-05-12 20:36:55.0000000 |
| OrdersArchive |       6 |       104 |          3 |             5 | 2024-05-05 | 2024-05-10 | Delivered   | 543 Belmont Rd.    | NULL           |        2 |    50 | 2024-05-06 15:34:57.0000000 |
| OrdersArchive |       6 |       104 |          3 |             5 | 2024-05-05 | 2024-05-10 | Delivered   | 543 Belmont Rd.    | 3768 Door Way  |        2 |    50 | 2024-05-07 13:22:05.0000000 |
| OrdersArchive |       7 |       102 |          3 |             5 | 2024-06-15 | 2024-06-20 | Shipped     | 111 Main St        | 222 Billing St |        0 |    60 | 2024-06-16 23:25:15.0000000 |



-- EXCEPT use cases
-- 1. we can use this operator like when we moved some data to a another table from first table to second table
-- but the first table is getting new data everytime so and that data to be added to second table
-- in that case we use the EXCEPT because it validates the data which is present in the first table only 
-- so we can add that data to the second table


-- 2. data complteness 
-- so when we are migrating the data from one database to another database EXCEPT help in identifying
-- the data like both tables have the empty data in result which means the data is migrated completely without missing any values
