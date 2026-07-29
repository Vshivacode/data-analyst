-- SUBQUERIES
-- a query inside a query and we can create multiple queries inside another query 
-- so the sub query works like first it will execute the inside query but we dont see that data 
-- now we use another query outside the query we call it as main query so this query uses the 
-- data from the inside query to display the data from that query and we can also do some operations for inside query

-- IMPORTANT POINT: we cannot use the inside query with other tables means we cannot combine 
-- inside table data with another table using joins or any other operations 
-- it is only available for main query we cannot do with other tables 

-- when to use the sub query ?
-- 1. when we are working with complex problem instead of writing a single query will be hard to read and understand 
-- so if we divide the problem into small steps and for each step we create a query and
-- we use that query for another query it will be easy and clear 

-- 2. when we want to retrieve the same data from the same table we take as input and performing some calculations or to filter, 



-- sub queries categories
-- dependency 
-- 1. non-correlated subqueries             2. correlated sub queries

-- result type 
-- 1. scalar subquery       2. row subquery         3. table subquery

-- location clauses
-- select from join where 
--                    |   
--             1. comparison operators        2. logical operators



-- Result Types
-- 1. scalar subquery
-- it returns only one value like one column and one row 
-- ex: select avg(sales) from sales.orders    o/p:  1234        -- so we get only one value as result

-- row subquery
-- single row subquery :  it returns single row multiple columns as result
-- ex: select * from sales.orders where orderid = 1
-- multi row subquery:  it returns multiple rows with one column as result
-- ex: select orderdate from sales.orders

-- table subquery
-- it returns multiple rows with multiple columns as a result
-- ex: select * from sales.orders
