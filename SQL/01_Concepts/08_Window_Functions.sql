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
