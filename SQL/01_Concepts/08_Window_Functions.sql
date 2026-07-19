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
