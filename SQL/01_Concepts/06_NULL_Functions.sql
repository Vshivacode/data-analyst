-- NULL FUNCTIONS
-- null means nothing, unknown value, and it not equal to zero or anything  or even with another null value also
-- null functions for replacing the values with null
-- isnull()        coalesce()           nullif()
-- is null   and is not null  are used for checking the values 

-- ISNULL(value, replacement_value)
-- it is used to replace the null values with the specific values
-- ex:  isnull(shipping_address, 'unknown')     -- here we are replacing the shipping address null values to unknown value



-- COALESCE()
-- it is same as the isnull() but the power of coalesce is when we give the two arguments and like isnull()
-- but the two arguments have the null values and we dont want to show the null values then in that case we use this coelesce 
-- because coalesce(value1, value2, value3, value4,.....)   it does not have any fixed arguments 
-- we can specify as many we want it will check all the values and if all the values have the null values
-- we can give the custom value to replace the null

-- Q. replace the null values of shipaddress with the billingaddress and if the billingaddress have null values replace it wiht custom value
-- ex:   isnull(shipaddress, billingaddress)       -- here we have a problem so if both values have the null value then we dont have another arguments to put using isnull()

-- so here we  use the coalesce()

select shipaddress, billaddress, coalesce(shipaddress, billaddress, 'unknown') as replaced_values from sales.orders

-- we cannot do like this with isnull() because it only accepts 2 arguments 
-- select shipaddress, billaddress, isnull(shipaddress, billaddress, 'unknown') as replaced_values from sales.orders



-- ISNULL()                          VS       COALESCE()
-- 1. only accepts 2 arguments              -- unlimited arguments
-- 2. fast                                  -- slow
-- 3. we have different func names          -- in every database is same func coalesce()
-- but have works same like 
-- isnull() func in sql server,
-- ifnull() in mysql
-- 4. because of this different             -- since the func is same we can migrate easily without any changes in func
-- func we have to change the 
-- func names while migration




-- IMPORTANT:   HANDLING NULL VALUES WHILE PERFORMING DATA AGGREGATIONS
-- so when are performing some calculations with the aggregate functions like sum(), avg(), min(), max(), count()
-- the NULL values are ignored by sql but when it comes to COUNT(*) 
-- it counts all the rows including the null values so this results in wrong results 
-- ex:   we have 3 rows in the table, and we have 2 values and 1 null value 
-- so avg() will be (x + y)/2   but when it comes to count(*) we have 3 rows 
-- so data need to be handled before performing any data aggregations
-- so first we replace the null value with the ZERO  then we can calculate now so (x+y+0)/3 now we get correct results  


-- Q.  Find the avg scores of the customers 
-- we can directly do this 
select avg(score) from sales.customers      -- but this is wrong because we may have some null values in this 

-- so before doing the aggregations we handle null values by using the coalesce()
select score, coalesce(score, 0) as null_to_0 from sales.customers

select avg(coalesce(score, 0)) as null_to_0 from sales.customers




-- HANDLING MATHEMATICAL OPERATIONS
-- so we need to handle the null values while performing the concatenations also 
-- ex:  0 + 5 = 5, 1 + 5 = 6, but NULL + 5 = NULL 
-- ex:  'a' + 'b' = ab,  '' + 'b' = b,   but NULL + 'b' = NULL, 

-- so we first handle the null values and then we do the mathematical operations or any other


-- Q.  display full name of customers in one field by merging their first and last name
-- and add 10 points to the each customers score

-- before doing any operations we handle null values
select coalesce(firstname + ' '+ lastname, firstname, lastname, 'unknown'),score, coalesce(score + 10, 10) from sales.customers 




-- HANDLING NULL VALUES IN JOINS
-- so we have to handle the null values while doing the joins also 
-- because the sql will skip that row if we have the null values so to handle null values 

Table1
Year	Type	Orders
2024	NULL	30
2024	b	40
2025	NULL	50
2025	b	60

Table2
Year	Type	Sales
2024	a	100
2024	NULL	200
2025	b	300
2025	NULL	200

-- here we can see that the 2024 have the null values so the sql ignore that row so we need to handle that
select table1.year, table1.type, table1.orders, table1.sales
from table1 
inner join table2 on table1.year = table2.year and table1.type = table2.type


-- so now we handle the null values
select table1.year, table1.type, table1.orders, table1.sales
from table1 
inner join table2 on table1.year = table2.year and isnull(table1.type, '') = isnull(table2.type, '')

-- IMP POINT: here we need to keep in mind that the output table will show the null values in the table 
-- because we handle the null values in the join not on the output table 




-- SORTING DATA
-- we need to handle the null values before sorting the data
-- ex: table have 3 values 
-- 25
-- NULL
-- 10

-- so if we sort the data then the NULL will appear at the starting it doesnt mean NULL value is lowest but sql show at starting
select score from sales.customers order by score            --  NULL shown at first

select score from sales.orders order by score desc          -- NULL shown at last 


-- Q. sort the customers from lowest to highest scores with NULL values shown at last 
select *, coalesce(score, 99999999) as score_null_to_0 from sales.customers order by coalesce(score, 99999999) 
-- but this is not a good approach because we are mentioning static value 9999999 but infuture we may get the value more than this 

-- so we use another method using case when 
select *, case when score is null then 1 else 0 end flag 
from sales.customers 
order by case when score is null then 1 else 0 end, score     -- here we are sorting via flag column and score to get the null values at last 
