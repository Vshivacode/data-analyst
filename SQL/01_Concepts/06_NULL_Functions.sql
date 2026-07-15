-- NULL FUNCTIONS
-- null means nothing, unknown value, and it not equal to zero or anything  or even with another null value also
-- null functions for replacing the values with null
-- isnull()        coalesce()           nullif()
-- is null   and is not null  are used for checking the values 

-- ISNULL(value, replacement_value)
-- it is used to replace the null values with the specific values
-- ex:  isnull(shipping_address, 'unknown')     -- here we are replacing the shipping address null values to unknown value

select isnull(billaddress, 'unknown') from sales.orders

-- we can also replace the values with another column values also 
select isnull(shipaddress, billaddress) from sales.orders    -- it will replace the null with the billaddress values of that row 

-- so isnull() accepts only two arguments one is value and other is replacement_value 
-- so if both the value and replacement_value is null then in the result we get the null
-- so if we dont want to show the null then in that case we need to another function called coalesce()


-- COALESCE()
-- it is same as the isnull() but the power of coalesce is when we give the two arguments and like isnull()
-- but the two arguments have the null values and we dont want to show the null values then in that case we use this coelesce 
-- because coalesce(value1, value2, value3, value4,.....)   it does not have any fixed arguments 
-- we can specify as many we want it will check all the values and if all the values have the null values
-- we can give the custom value to replace the null

-- Q. replace the null values of shipaddress with the billingaddress and if the billingaddress have null values replace it with custom value
-- ex:   isnull(shipaddress, billingaddress)       -- here we have a problem so if both values have the null value then we dont have another arguments to put using isnull()

-- so here we use the coalesce()
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



-- DATA AGGREGATION 
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
-- o/p: 625

-- so before doing the aggregations we handle null values
-- since it is a two arguments only so we can use the isnull(), if we want more arguments then we can use coalesce()
select score, isnull(score, 0) as null_to_0 from sales.customers 
-- o/p:
score   null_to_0
350	        350
900	        900
750	        750
500	        500
NULL	     0          -- changed null to 0

-- now lets find the avg of scores
select avg(isnull(score, 0)) from sales.customers
-- or 
select avg(coalesce(score, 0)) as null_to_0 from sales.customers
-- o/p: 500




-- HANDLING MATHEMATICAL OPERATIONS
-- so we need to handle the null values while performing the concatenations also 
-- ex:  0 + 5 = 5, 1 + 5 = 6, but NULL + 5 = NULL 
-- ex:  'a' + 'b' = ab,  '' + 'b' = b,   but NULL + 'b' = NULL, 

-- so we first handle the null values and then we do the mathematical operations or any other


-- Q.  display full name of customers in one field by merging their first and last name
-- and add 10 points to the each customers score

-- before doing any operations we handle null values
select coalesce(firstname + ' '+ lastname, firstname, lastname, 'unknown'),score, coalesce(score + 10, 10) from sales.customers 
