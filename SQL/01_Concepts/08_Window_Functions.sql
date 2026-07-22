-- WINDOW FUNCTIONS
-- these are very important functions in sql
-- IMPORTANT: 
-- window functions are CALCULATED AFTER WHERE CLAUSE, so if we are using 
-- the where clause in the query and we are performing window functions then it will be executed after the condition that where clause have 
-- we have to be careful if we are using where clause with window functions because we get the wrong results if we are not applying correctly 
-- these are same as group by but the level of calculations grouping the data and we dont lose level of details when performing these functions 
-- that means when we use the group by func we combine all the similar data to one row and we do aggregations 
-- so here when we use group by since it combines them to one row we are missing other rows the number of rows are decreased since we grouped them
-- so to maintain the number of rows even if we group them then we need to use the window functions 
-- so window functions perform the aggregations entirely but we show the data in each row without merging or combining the same data 
-- so it performs same as group by but the aggregations value will be shown to all the rows without missing any number of rows 

-- when to use group by and window functions ?
-- if we want to perform simple aggregations then we use group by
-- if we want to perform aggregations with details then we use the window functions


-- WINDOW FUNCTIONS                                         GROUP BY (only aggregate functions)
-- aggrgations functions (accepts numeric datatypes)        -- aggrgations functions                   
-- COUNT(all data types)                                    -- COUNT(all data types)   
-- SUM()                                                    -- SUM()
-- AVG()                                                    -- AVG()
-- MAX()                                                    -- MAX()
-- MIN()                                                    -- MIN()


-- RANK FUNCTIONS (accepts no datatypes and nothing DOES NOT allow to use FRAME CLAUSE)
-- RANK()
-- DENSE_RANK()
-- ROW_NUMBER()
-- CUME_DIST()
-- PERCENT_RANK()
-- NTILE(n)     ----- but this one accepts numeric datatype ex: ntile(2)


-- VALUE FUNCTIONS (accepts l datatypes)
-- LEAD(expr, offset, default)
-- LAG(expr, offset, default)
-- FIRST_VALUE(expr)
-- LAST_VALUE(expr)
-- NTH_VALUE()




-- WHY DO WE NEED WINDOW FUNCTIONS ? & WHY IN SOME SCENARIOS GROUP BY IS NOT ENOUGH ?
-- lets do some tasks

-- Q. find the total sales across all orders
select sum(sales) as total_sales from sales.orders      -- we can simply use sum()


-- Q. find the total sales across all orders by each product
select productid, sum(sales) as total_sales from sales.orders group by productid 


-- Q. find the total sales across all orders by each product additionally show the orderid, and orderdate
select productid,orderid, orderdate, sum(sales) as total_sales from sales.orders group by productid, orderid, orderdate
-- here we see the total sales are not calculated properly because group by have the other columns also which breaks the total sales calculations
-- we cannot do both the aggregations and the columns to show because it will perform grouping for all the mentioned columns

-- now in this case we need to perform grouping to only the sales column so to do this we need to use the window functions
select orderid, orderdate,productid, sum(sales) over(partition by productid) as total_sales_each_product from sales.orders




-- WINDOW FUNCTON SYNTAX

-- SYNTAX:  window function over(partition clause  order by clause frame clause)

-- window function = aggregate functions, ranking functions, value functions
-- partition clause = similar to group by but without merging the same data  
-- order by clause = column names to order in asc or desc
-- frame clause   = we tell sql to exactly calculate those rows relative to the current row

-- ex: sum(sales) over(partition by productid order by orderdate rows unbounded preceding )




-- OVER() clause 
-- we can leave it as empty in over clause also works 
-- so when we use the over() clause we are saying sql that we need to perform window functions
-- ex: select avg(sales) over() from sales.orders    -- it will give the avg(sales)  and return the same result for all the rows
-- we can use any one cluase or all of them or we can leave over() clause empty also according to the calculations we need
-- ex: select sum(sales) over(partition by productid) from sales.orders 

-- ex: select sum(sales) over(partition by productid order by orderdate) from sales.orders 

select sum(sales) over(partition by productid order by orderdate rows unbounded preceding) from sales.orders 

select orderid, sales, sum(sales) over() from sales.orders


-- Q. find the product prices greater than the avg price including the columns productid, orderid, price,avg price
-- if the product price greater than the avg price show "EXPENSIVE"
-- if it is less than avg price then show 'CHEAP' 
-- if price and avg price are same then show 'NEUTRAL' 

-- here we can solve this using window functions only 
select 
    productid, 
    product, 
    price, 
    avg(price) over() as avg_price,       
    case 
        when price > avg(price) over() then 'EXPENSIVE'
        when price < avg(price) over() then 'CHEAP' 
        when price = avg(price) over() then 'NEUTRAL' 
    end as price_category
from sales.products


-- WITH PARTITION BY CLAUSE
-- it is similar to the group by clause but it will do the grouping by making seperate windows according to the aggregations
-- so if we do the sum(sales) over(partition by productid) then it will create seperate windows for each product id that means 
-- for each product it will have the total sales and that value will be shown to that window only
select orderid, orderdate,productid, sum(sales) over(partition by productid) as total_sales_each_product from sales.orders


-- WITHOUT PARTITION BY CLAUSE
-- so if we dont specify any clause in the over() clause then it will give the entire aggregated column value to all
-- the rows same value to all the rows 
-- in this we have only one window because we did not mentioned in over() clause 
select sum(sales) over() from sales.orders     -- it will give the sum(sales)  and return the same result for all the rows



-- Q. find the total sales of the orders additionally provide details of the orderid and orderdate
select orderid, orderdate, sum(sales) over () as total_sales from sales.orders 


-- Q. find the total sales for each product of the orders additionally provide details of the orderid and orderdate
select orderid, orderdate, productid, sum(sales) over (partition by productid) as total_sales_each_product from sales.orders 
-- here we can see 4 windows so for each product since we have 4 different products so we have 4 windows and each window use seperate aggregations



-- Q. find the total sales for each combination of product and order status 
select * from sales.orders 

select sales, productid, orderstatus, sum(sales) over (partition by productid, orderstatus) as product_wise_orderstatus from sales.orders 
-- here we have total 6 windows 
-- here it is doing the two groupings so one is for productid and other is for orderstatus 
-- which means first it will group all the rows accoring to the productid and then 
-- it will group the rows according to the orderstatus 



-- ORDER BY CLAUSE WITH WINDOW FUNCTIONS
-- order by used to sort the rows in asc or desc according to the partition wise so if we use partition it will 
-- sort them accordingly so that each window is sorted seperately in asc or desc
-- it will do the sorting within the window 
-- so for rank functins and value functions ORDER BY is MANDATORY because without this it doesnt make any sense
select sales, productid, orderstatus, sum(sales) over (partition by productid, orderstatus order by sales) as product_wise_orderstatus from sales.orders 
-- here we have 6 windows so the each window is sorted asc according to productid and orderstatus 


-- Q. rank each order based on the sales from highest to lowest including the details of the orderid, orderdate
-- select orderid, orderdate,sales, rank() over(order by sales desc) from sales.orders

select orderid, orderdate,sales, rank() over (order by sales desc) from sales.orders


-- WINDOW FRAME CLAUSE
-- the partition by creates windows according to the aggregations so in the same way the frame clause will create another window inside a window like nested if we are using the partition by only 
-- if we are not using partition by it will do the aggregations for the entire column so it will assume as one window
-- the frame clause window is based on the conditions like from which row to take or do the calculations of a window
-- it will do the aggregations based on the conditions 
-- it is not used while we are working with the rank functions 
-- we can use it with the aggregate and value functions only 

-- frame clause syntax -  frame type lower value and higher value 
-- frame type = ROWS  and  RANGE 
-- lower value  =  UNBOUNDED PRECEDING, N PRECEDING, CURRENT ROW
-- higer value = CURRENT ROW, N FOLLOWING , UNBOUNDED FOLLOWING

-- UNBOUNDED PRECEDING =  it means start from the first row of the column
-- N PRECEDING  =   N means any number to start from  like   3 preceding means take 3 rows 
-- CURRENT ROW = the current row we are in the calculations we are performing 

-- UNBOUNDED FOLLOWING =  it means goto the last row of the column 
-- N FOLLOWING =  N means any number of rows to take like for 3 following means take 3 rows 
-- CURRENT ROW  =  the current row we are in calculation 

-- COMBINATIONS  WE GET (always we use lower value at the left side and right will be the higher value)

-- ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW 
-- means start from the first row and go till the end of the column calculating the each rows
-- so lets say we start from the first row and initially we are in the first row so the first row and the current row will be same so the value will be same 
-- for next row it will take the first row and now the current row will be the second row so it will do first row + second row = the current row value if we are doing the sum(columnname) 
-- if we are doing min(columnname) then it will compare the both values and return that value to the current row 

create table sales.monthly_sales(id int primary key, month varchar(20), sales int)

INSERT INTO sales.monthly_sales (id, month, sales) VALUES
(1,  'January',   12),
(2,  'February',  24),
(3,  'March',     18),
(4,  'April',     32),
(5,  'May',       44),
(6,  'June',      26),
(7,  'July',      38),
(8,  'August',    40),
(9,  'September', 22),
(10, 'October',   48),
(11, 'November',  36),
(12, 'December',  28);

INSERT INTO sales.monthly_sales (id, month, sales) VALUES
-- January duplicated 3 times
(13, 'January', 18),
(14, 'January', 24),
(15, 'January', 32),

-- March duplicated once
(16, 'March', 20),

-- May duplicated twice
(17, 'May', 28),
(18, 'May', 42),

-- August duplicated 3 times
(19, 'August', 16),
(20, 'August', 22),
(21, 'August', 48),

-- November duplicated once
(22, 'November', 14),

-- December duplicated twice
(23, 'December', 26),
(24, 'December', 38);


select * from sales.monthly_sales

-- since we are not using partition by it will take the entire column as one window and it will do the aggregations
select month, sales, sum(sales) over (order by sales rows between unbounded preceding and current row) from sales.monthly_sales


-- if we use the partition by month then it will create the windows and if we use the frame clause then it will take rows within that window 
select month, sales, sum(sales) over (partition by month order by sales rows between unbounded preceding and current row) from sales.monthly_sales



-- ROWS BETWEEN UNBOUNDED PRECEDING AND 2 FOLLOWING
-- it means from first row to the 2 following means the next two rows from the current row 
-- which means if we are in the first row it will take first row + second row + third row 
-- now we are in the second row so it will take the first row + second row (current row) + third row + fourth row
-- now we are in third row so it will take first row + second row + third row(current row) + fourth row + fifth row
select month, sales, sum(sales) over (order by sales rows between unbounded preceding and 2 FOLLOWING) from sales.monthly_sales


-- ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
-- it means the it will take from the first row to  last row which means all the rows of that column same as doing the simply total sales 
-- select sum(sales) from sales.monthly_sales

select month, sales, sum(sales) over (order by sales rows between unbounded preceding and UNBOUNDED FOLLOWING) from sales.monthly_sales



-- ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW 
-- it means take the current row and take all the rows before the current row 
select month, sales, sum(sales) over (order by sales rows between unbounded preceding and current row) from sales.monthly_sales


-- ROWS BETWEEN 2 PRECEDING AND CURRENT ROW 
-- means how many rows to take before the current row 
-- so first row will be same first row + current row = first row value
-- so now we are in second row so first row + second row (current row) 
-- now we are in third row  so it will take first row + second row + third (current row)
-- now we are in fourth row so it will take second row + third row + fourth row (current row)
select month, sales, sum(sales) over (order by sales rows between 2 preceding and CURRENT ROW) from sales.monthly_sales


-- ROWS BETWEEN 2 PRECEDING AND 2 FOLLOWING 
-- it means take 2 rows before current row and take 2 rows after current row
-- so now we are in first row so it will take first row(current row) + second row + third row  because before first row we dont have any rows so we do from current row which is first row
-- now we are in second row so it will take first row + second row(current row) + third row + fourth row + fifth row
-- now we are in the third row so it will take first + second + third(current) + fourth + fifth 
select month, sales, sum(sales) over (order by sales rows between 2 preceding and 2 FOLLOWING) from sales.monthly_sales




-- ROWS BETWEEN 2 PRECEDING AND UNBOUNDED FOLLOWING    (sql do reverse calculation)
-- it means 2 rows before current row and goto all the rows to the end 
select month, sales, sum(sales) over (order by sales rows between 2 preceding and UNBOUNDED FOLLOWING) from sales.monthly_sales
-- so here the data we get will be in the reverse order like the sales will be arranged in the desc order 
-- because sql takes the optimised calculations so by doing it from the bottom to first row it will be easier and fastest way to do the calculations 
-- so thats why we get the data in the reverse calculation 
-- so get in the proper order like we want the sales to be shown as lower to higher then we use order by sales asc at the end 
-- we dont change inside the over() clause because it is used for the calculation purposes not for ordering the data 
select month, sales, sum(sales) over (order by sales rows between 2 preceding and UNBOUNDED FOLLOWING) from sales.monthly_sales order by sales, month
-- it will do like  last row(current row) + last second row + last third row + .......+ first row 
-- now we are in last second row(current row) so it will do last row + last second row(current) + last third + last fourth + .........+ first row
-- now we are in last third row(current row) so it will do last row + last second row + last third(current) + last fourth + .........+ first row
-- now we are in last fourth row(current row) so it will do last second row + last third + last fourth(current) + .........+ first row
-- now we are in the first row (current row ) so it will take the first row(current) + second row + third row 

 
-- ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING    (sql do reverse calculation)
-- it means current row goto all the rows  
select month, sales, sum(sales) over (order by sales rows between current row and unbounded following) from sales.monthly_sales
-- it do the calculation in reverse and display the data in reverse so to get it properly displayed we use order by at the end
select month, sales, sum(sales) over (order by sales rows between current row and unbounded following) from sales.monthly_sales order by sales


select * from sales.monthly_sales


-- ROWS BETWEEN CURRENT ROW AND THE 2 FOLLOWING 
-- it means take current row and take 2 rows after current row 
select month,sales, sum(sales) over (order by sales rows between current row and 2 following) from sales.monthly_sales
-- it calculates forward does not do the reverse calculation
-- so now we are in first row (current row) + second row + third row
-- now are in second row (current row) it will take second (current) + third + fourth 
-- last row (current row) since we are in last row it does not have any further rows to calculate it show the same value 



-- ROWS BETWEEN CURRENT ROW AND CURRENT ROW
-- it is of no use because it will give the same values that sales have since we are doing the current row itself 
-- so it did not change any value so no use of it
select month,sales, sum(sales) over (order by sales rows between current row and current row) from sales.monthly_sales




-- WINDOW FUNCTIONS 4 RULES 
-- FIRST RULE:  window functions only used in the select and order by we cannot do with other clauses 
-- select month,sales, sum(sales) over (partition by month) from sales.monthly_sales order by sum(sales) over (partition by month)
-- we used window func in the order by clause
-- we cannot do with other clauses like the where, group by, etc

-- SECOND RULE:  nesting window functions is not allowed 
-- we cannot add another window func in one window func 
-- ex: select month,sales, sum(sum(sales) over (partition by month)) over (partition by month) from sales.monthly_sales

-- THIRD RULE: sql window functions execute after where clause 

-- Q. find the total sales for each orderstatus only for two products 101 and 102
select * from sales.orders

select orderid,productid, orderstatus, sum(sales) over(partition by orderstatus) from sales.orders where productid = 101 or productid = 102 


-- FOURTH RULE: window functions can be used with the group by but only when we use the same column 
-- so here we use the same column name inside the over clause also so which means sum(sales) we used for group by 
-- same we use this inside the over() clause
-- not only the sum(sales) column we can use the other columns also which we are using for the group by like customerid also can be used inside the over() clause
-- Q. rank the customers based their total sales 
select customerid, sum(sales) as total_sales, rank() over(order by sum(sales)) from sales.orders group by customerid





-- WINDOW AGGREGATE FUNCTIONS
-- they are sum(), count(), avg(), min(), max()
-- so when we do use this functions it will give the result in one row 
-- count() only accepts all the datatypes remaining accepts only numeric values
-- so window definition over() can be have empty like the partition by, order by, frame clause can be optional for aggregate functions only

-- COUNT()
-- it returns the number of rows within a window like how many rows we have within the window even if we have duplicates also it will count as seperate  
-- and it is mainly used for data quality check that means we can easily know whether the table contains any duplicate values or not 
-- we can use the count() in two ways
-- count(*)        
-- so it will count all the rows including if any column have the null values also it will count that as one row because the other column have the values it just count how many rows are there 
-- count(column)
-- if we use the column then it ignores the null values and count the rows how many we have 
-- 


-- Q. find the total number of orders we have for each product 
-- here we use the group by because it is a simple calculation and we dont want other things or to maintain level of details
select productid, count(sales) as total_orders from sales.orders group by productid

-- but if we use window func it gives each productid seperate row which makes no sense according to the question because it gives level of details which we dont want according to the question 
select productid, count(sales) over(partition by productid) from sales.orders

select * from sales.orders


-- Q. find the total number of orders
select count(*) as total_orders from sales.orders 

select count(sales) as total_orders from sales.orders


-- Q. find the total number of orders additionally provide details orderid, orderdate 
select orderid, orderdate, count(*) over() as total_orders from sales.orders 

-- Q. find the total number of orders, total number of orders for each customer additionally provide details orderid, orderdate 
select customerid, orderid, orderdate,count(*) over() as total_orders, count(*) over(partition by customerid) as orderbycustomers from sales.orders


-- Q. find the total number of customers additionally provide all the customer details 
select *, count(*) over() as total_customers from sales.customers

-- Q. find the total number of scores for the customers additionally provide all the customer details 
-- here we need to find the rows of a specific column score so when we are dealing with the column
-- while using the count() we need to keep in mind that the column may have the null values 
-- to avoid incorrect insights we need to handle the null values so to get the proper insights we need to use the count(column)
-- it will ignore the null values present in the column so we need to remember that count(column) ignores the null rows and counts other rows
select *,count(*) over() as total_customers, count(score) over() as total_scores from sales.customers
-- here the null value row is ignored so we got the result 4 rows instead of 5 
