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



-- SUBQUERY IN JOIN CLAUSE
-- when we want to perform some aggregations on a table and then we combine the aggregated result to another table to get meaningful information using  
-- subquery with join will be useful 

-- Q. show all the customer details and find the total no.of orders for each customer 

select * from sales.customers

select customerid, count(*) as totalorders from sales.orders group by customerid
-- here we are getting multiple rows and multiple columns so now we use the joins here 

-- we use left join so that we wont miss any customer details present in customer table

select c.*, o.totalorders from sales.customers as c
left join (
    select customerid, count(*) as totalorders 
    from sales.orders group by customerid
) as o 
on c.customerid = o.customerid 




-- SUBQUERY IN WHERE CLAUSE
-- we are using the subquery for filtering for main query

-- Q. find the products that price is higher than the avg prices of products 

select productid, product, price,
(select avg(price) from sales.products) as avg_price, 
-- avg(price) over() as avg_price  
from sales.products 
where price >  
(
    select avg(price) from sales.products
)
-- CHECK THIS 
-- here avg(price) over() as avg_price VS (select avg(price) from sales.products) as avg_price result are different
-- (select avg(price) from sales.products) as avg_price  it will give the avg price of all prices
-- but avg(price) over() as avg_price  this will give the result different we get the avg price of the condition 
-- so it will calculate the avg prices of the where clause condition 
-- so prices > avg(price)   values are calculated by this avg(price) over() as avg_price
-- instead of the actual prices because WINDOW FUNCTIONS ARE CALCULATED AFTER WHERE CLAUSE means after the condition they do calculations on the condition 



-- subquery with IN operator
-- so using the in operator main advantage is that it shows multiple rows and one column with the subquery 
-- it is like checking from the list of items

-- Q. show the details of the orders made by customers in germany
select * from sales.orders

select * from sales.customers where country = 'germany'    -- now we use this result in the main query

-- here we use the in operator and checking the customerid so that we can get all the customers with germany 
select * from sales.orders where customerid in 
(
select customerid from sales.customers where country = 'germany'
)


-- Q. show the details of the orders made by customers NOT IN germany
-- we have to find the customers orders except germany so we dont want germany country
-- we use NOT IN OPERATOR 
select * from sales.orders where customerid not in  
(
select customerid from sales.customers where country = 'germany'
)


-- SUBQUERY WITH ANY
-- it checks if atleast one value matches from any values within a list
-- same as in but the advantage of ANY is we can COMBINE it with COMPARISON OPERATORS like =, =>, <=, >, < 
-- ex: where id = any (),   where id >= any (), .... etc
-- so when we want to perform the conditions using where clause for the subquery which gives multiple rows 
-- then we can use the  ANY so it allow the subquery can have multiple rows and we can do the where conditions inside the subquery


-- Q. find the female employees whose salaries are greater than any of male employees salary 
select * from sales.employees

select FirstName, gender, salary 
from sales.employees 
where gender =  'f' and salary > any (select salary from sales.employees where gender =  'm')
-- here the subquery have multiple rows so since we are using the ANY we can do now without any errors

-- When to Use ANY
-- When subquery returns multiple rows
-- When you need comparison logic, not just equality
-- When IN is too limited


-- SUBQUERY WITH ALL 
-- it checks if all the values are matching to the all the rows if all the conditions are true
-- if any one value are not matching then the entire result will be false 
-- if we have 5 rows and one row is not mathching then it wont display any rows it show empty table because one value is not matching

-- Q. find the female employees whose salaries are greater than all male employees salary
-- we need to check whether female employees salary greater than all the male employees 
select FirstName, gender, salary 
from sales.employees 
where gender =  'f' and salary > all (select salary from sales.employees where gender =  'm')



-- DEPENDANCY SUBQUERIES
-- 1. NON-CORRELATED SUBQUERY            2. CORRELATED SUBQUERY

-- 1. NON-CORRELATED SUBQUERY
-- what we did with subqueries previously all comes in the non-correlated subquery
-- so the subqueries are independent from the main query
-- so this is how the sql executes while using the independent subquery
-- so first sql executes the subquery and from that we use it in the main query to show the data 
-- so the subquery can be anything we are just using that in the main query 


-- 2. CORRELATED SUBQUERY 
-- so when it comes to this correlated subquery it is dependent on the main query
-- so this is how sql executes
-- so first it will execute the main query then from that main query the subquery will be executed
-- so in the result we see the data from the subquery
-- and it is completely dependent on the main query 


-- Q. show all the customer details and find the total orders for each customer 
-- previously we did it as non-correlated subquery
select c.*,total_orders 
from sales.customers c 
left join 
(select customerid, count(*) as total_orders from sales.orders group by customerid) as o 
on c.customerid = o.customerid

-- now we do it as correlated subquery 
select *, 
(select count(*) from sales.orders o where c.customerid = o.customerid) as total_orders
from sales.customers c
-- here we are connecting the main query table inside the subquery using where
-- now the subquery is dependent on the main query 



-- EXISTS WITH SUBQUERY 
-- exists are same as IN operator in functionality wise but in it will execute differently
-- so it checks values that are present in other or not 
-- so if we are working with large data sets then we can use exists instead of IN 
-- the performance is fast then compared with IN because EXISTS stops as soon as a value is found
-- and it can be useful when we are working with null values with correlated subquery 
-- because it executes row by row so the other rows are not effected if any of them have null values 
-- but when we are using the IN then it will run and if we have nulls then it dont return any rows and no stops so performance 
-- exists are mainly used for the correlated subqueries 


-- Q. show the details of the orders where country is germany
-- we can do like this non-correlated subquery 
select * from sales.orders o where customerid in (select customerid from sales.customers c where country = 'germany')

-- we can do with correlated subquery 
select * from sales.orders o where exists (select customerid from sales.customers c where country = 'germany' and c.customerid = o.customerid)

-- we can also use 1 instead of mentioning the column name or * because exists check the existence of the values instead of actual dataselect * from sales.orders o where exists (select customerid from sales.customers c where country = 'germany' and c.customerid = o.customerid)
select * from sales.orders o where exists (select 1 from sales.customers c where country = 'germany' and c.customerid = o.customerid)
-- not only 1 we can use any value 


-- we can also find the customers who are not germany 
-- we use NOT operator 
select * from sales.orders o where not exists (select 1 from sales.customers c where country = 'germany' and c.customerid = o.customerid)

