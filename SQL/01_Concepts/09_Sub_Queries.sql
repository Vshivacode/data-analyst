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



-- SUBQUERY IN FROM CLAUSE
-- how to use subquery in from clause ?
-- the subquery behaves like a temporary table and we use this table for the main query and it is only usable by main query
-- it creates a derived table means it is a temporary table we use this to perform calculations and aggregations 
-- it is not stored in the database and it is used by main query only 

-- first sql executes the subquery and sql take the values from the subquery and use it in the main query and we show the result 

-- select col1, col2, col3,....
-- from (select column from table2 where condition) as alias


-- find the products that have a price higher than the avg price of all products 
-- it means productprice > avg(product price)

select * from sales.Products

select * from 
(
    select 
    productid, 
    price,
    avg(price) over() as avg_price 
    from sales.products
) t 
where price > avg_price



-- Q. rank customers based on their total amount of sales 

select *, 
rank() over(order by total_sales desc) customers_rank from
(
    select 
    customerid, 
    sum(sales) as total_sales 
    from sales.orders 
    group by customerid
) as t


-- how database executes the subqueries in the backend
-- so user runs the subquery and sql sends the request to the database engine
-- it identifies and retrieve the data and store the data in the cache 
-- now from main query executed so it will take the data from the subquery which we stored in the cache
-- and after taking the data sql will remove the data from the cache memory 



-- SUBQUERY IN SELECT CLAUSE 
-- so we use the subquery inside the select clause as a column not as table as we used earlier for from clause 
-- previously we use the subquery as entire table and we use that table for doing some aggregations and other operations 
-- but in select clause we use subquery as a column so the value will be included to the main query table 
-- so the result of the subquery will be treated as a column and added to the main query table 

-- IMPORTANT: so now the subquery result must be scalar subquery means the result to be one row and one column
-- IMPORTANT: we can also use different tables also in one sql query means we can use different tables in subquery so the main query table can be different and subquery can be different 

-- we can use aggregation functions, constants, anything that results in one row and one column
-- non-aggregates like (select 'ACTIVE') as status 
-- ex: SELECT
--    product,
--    price,
--    (SELECT 'ACTIVE') AS status
-- FROM sales.products;

-- multiple rows and columns are NOT allowed like this 
-- ex: select orderdate, sales, (select column1, column2, column3 from table) as result from sales.orders


-- Q. find productid, names, prices and total no.of orders
select * from sales.orders

select productid, product, price, (select count(*) from sales.orders) as no_of_orders from sales.products 


-- this cannot be done as it throws error because in subquery productid is non aggregated column so it will give multiple rows  
select productid, product, price,(select ProductID from sales.orders) as totalorders 
from sales.products

