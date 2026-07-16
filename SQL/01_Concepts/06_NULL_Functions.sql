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
select * from sales.customers

select (firstname + ' ' + lastname) as fullname, score, (score + 10) as bonus_score from sales.customers
-- o/p:
fullname          score   bonus_score
Jossef Goldberg	   350	    360
Kevin Brown	       900	    910
Mary 	           750	    760
Mark Schwarz	   500	    510
Anna Adams	       NULL	    NULL
-- here we lastname and score have the null values and we can see it because we have small data but in real life
-- the data will be very large and we cannot follow this way so instead
-- we first handle the null values to get correct data

select (isnull(firstname, 'n/a') + ' ' + isnull(lastname, 'n/a')) as fullname, score, coalesce(score, (score + 10), 10) as bonus_score from sales.customers
-- since the isnull() function is available for sql server but if we want to execute in other rdbms like mysql or any other then we need to change the isnull function to the function that mysql supports like ifnull()
-- so instead of this we can use coalesce() 
select (coalesce(firstname, 'n/a') + ' ' + coalesce(lastname, 'n/a')) as fullname, score, coalesce(score, (score + 10), 10) as bonus_score from sales.customers



-- HANDLING NULL VALUES IN JOINS
-- so we have to handle the null values while doing the joins also 
-- because the sql will skip that row if we have the null values so to handle null values 

Table1
Year	Type	Orders
2024	 a	      30
2024	NULL	  40
2025	 b	      50
2025	NULL	  60

Table2
Year	Type	Sales
2024	a	    100
2024	NULL	200
2025	b	    300
2025	NULL	200

-- here we can see that the 2024 have the null values so the sql ignore that row so we need to handle that
select table1.year, table1.type, table1.orders, table1.sales
from table1 
inner join table2 on table1.year = table2.year and table1.type = table2.type
-- o/p:
Year	Type	orders     Sales
2024	 a	      30          100
2024	 b	      50          300

-- so now we handle the null values
select table1.year, table1.type, table1.orders, table1.sales
from table1 
inner join table2 on table1.year = table2.year and isnull(table1.type, '') = isnull(table2.type, '')
-- here in the joins we used the ''  empty string because while comparing it is fast and 
-- if we use the query in the result table in the type column we will be getting the null 
-- because we did not mentioned in select statement that if this type column have null then show something 
-- thats why we see the null in the result table 
-- o/p:
Year	Type	orders     Sales
2024	 a	      30        100
2024	NULL	  40        200
2024	 b	      50        300
2024	NULL      60        200

-- we will replace the nulls with empty string because it is fast
-- IMPORTANT POINT: 
-- here we need to keep in mind that the output table will show the null values in the table 
-- because we handle the null values in the join not on the output table 
-- since we did not mentioned isnull() in the select statement for the type column
-- it is showing null values in the table, and we mentioned it in the joins so for joins it worked



-- SORTING DATA
-- we need to handle the null values before sorting the data
-- ex: table have 3 values 
-- 25
-- NULL
-- 10

-- so if we sort the data then the NULL will appear at the starting it doesnt mean NULL value is lowest but sql show at starting
select score from sales.customers order by score            --  NULL shown at first
-- o/p:
score
NULL
350
500
750
900

select score from sales.customers order by score desc          -- NULL shown at last 
-- o/p:
score
900
750
500
350
NULL

-- Q. sort the customers from lowest to highest scores with NULL values shown at last 
select *, coalesce(score, 99999999) as score_null_to_0 from sales.customers order by coalesce(score, 99999999) 
-- but this is not a good approach because we are mentioning static value 9999999 but infuture we may get the value more than this 

-- CORRECT METHOD TO HANDLE NULLS IN SORTING
-- so we use another method using case when 
-- since we dont know how much big value can be there in the column so we will use another extra static column
-- which will be used for sorting the data so we will mention that if the value is null then replace it will 1 and if not 
-- replace it with 0 so now since this new column only have the two values 0 and 1 
-- it is easier to sort the data now using order by new column 
select customerid, firstname, score, case when score is null then 1 else 0 end flag 
from sales.customers 
order by case when score is null then 1 else 0 end, score     -- here we are sorting via flag column and score to get the null values at last 
-- o/p:
| customerid  | firstname | score | flag |
| ----------- | --------- | ----: | ---: |
| 1           | Jossef    |   350 |    0 |
| 2           | Kevin     |   900 |    0 |
| 3           | Mary      |   750 |    0 |
| 4           | Mark      |   500 |    0 |
| 5           | Anna      |  NULL |    1 |



-- NULLIF(value1, value2)
-- it is used to compare two values and putting the NULL if the values are equal and if they are not equal then it returns the first value
-- and we are checking it for 

-- ex: column1        column2         result 
    -- 10             10         =    NULL         -- if they are equal
    -- 10             25         =    10           -- two values are not equal so we take first value 
    -- null           33         =    NULL         -- two values are not equal so we take first value since the first value is null we dont mind if first value is null or not 

select shipaddress, billaddress, nullif(shipaddress, billaddress) from sales.orders

-- WHERE DO WE USE THIS IN REAL LIFE ? 
-- we can use this in real life like check whether the original price and discounted price are equal or not 
-- if equal then replace it with null because it is an issue because if original price and discounted price are equal
-- then we are selling that product with 0 price means like a free product so we need to handle it 
select price as original_price, 20 as discounted_price, nullif(price, 20) from sales.products



-- NULLIF()   DIVISION BY ZERO
-- preventing the error of dividing by zero

-- Q. find the sales price for each order by dividing the sales by quantity
select quantity, sales from sales.orders      -- it will give error if we have zero in the denominator

select quantity, sales, sales/quantity from sales.orders   -- it will give error because we have zero in the denominator

-- so lets handle this division error
select quantity, sales, sales/nullif(quantity, 0) from sales.orders



-- IS NULL  and     IS NOT NULL 
-- IS NULL is used to return true if the value is null otherwise it return false
-- IS NOT NULL is used to return true if the value is not null otherwise it return false

| OrderID | Price | Price IS NULL | Price IS NOT NULL |
| ------- | ----- | ------------- |  ------------     |
| 1       | 90    | FALSE         | TRUE              |
| 2       | NULL  | TRUE          | FALSE             |


select *, case when score is null then 'TRUE' else 'FALSE' end from sales.customers


-- FILTERING DATA
-- identifying the missing information using the is null or is not null

-- Q. identify the customers who have no scores
select * from sales.customers where score is null 

-- Q. identify the customers who have scores
select * from sales.customers where score is not null




-- ANTI JOINS  
-- find the unmatched rows between two tables
-- to find the unmatched rows which means finding those values having NULL values 
-- so we combine the left join + is null       or we can combine right join + is null 


-- Q. find all the details of the customers who have not placed any orders

select c.customerid, c.firstname, o.orderid,c.customerid, o.sales from sales.customers as c
left join sales.orders as o on c.customerid = o.customerid 
where o.orderid is null




-- NULL     VS   EMPTY    VS   SPACE 
-- null means unknown value we dont know what it is
-- empty string   means it has zero characters
-- space means we for example in the fields we click the space and that field will have the one character value 
/*
| Topic                      | **NULL**                                  | **Empty String ("")**                      | **Blank Space (" ")**                         |
| -------------------------- | ----------------------------------------- | ------------------------------------------ | --------------------------------------------- |
| **Representation**         | NULL                                      | ""                                         | " "                                           |
| **Meaning**                | Unknown / Not available / No value        | Known → value is empty (length = 0)        | Known → contains 1+ space characters          |
| **Data Type**              | No data type (it's a marker)              | String (length 0)                          | String (length ≥1)                            |
| **Storage**                | Very minimal / No storage (depends on DB) | Occupies memory (0-length string metadata) | Occupies memory (space character stored)      |
| **Performance**            | Best (NULL checks are fast)               | Fast                                       | Slowest (extra character stored and compared) |
| **Comparison**             | Use `IS NULL` or `IS NOT NULL`            | `= ''`                                     | `= ' '` (one space)                           |
| **Behavior in Conditions** | Unknown value → cannot use `=`            | Can use `=`                                | Can use `=`                                   |
| **Length**                 | NULL (no length)                          | 0                                          | 1+                                            |
| **Example Usage**          | Missing price, missing name               | User submitted an empty field              | User typed a space instead of real data       |
*/

with orders as (
select 1 as id, 'A' as category union
select 2, NULL union
select 3, '' union
select 4, '  ' 
)
select * from orders
-- o/p:
id   category
1	    A
2	    NULL
3	    
4	     
-- here for id 3, 4 we see that category column is showing empty but id 3 is empty string 
-- and id 4 is having a extra space since in the column we cannot identify that 
-- so we will use the datalength() function to find the length of the category column so that 
-- we can able to know if a empty string then it will show 0
-- if we have extra spaces then we can show length of the spaces

-- DATALENGTH()
-- it is used to calculate the number of characters we have in the column 

with orders as (
select 1 as id, 'A' as category union
select 2, NULL union
select 3,  '' union
select 4, '  '
)
select *, datalength(category) as category_length from orders
-- o/p:
id   category    category_length
1	    A	        1
2	    NULL	    NULL
3	    	        0
4	     	        2                   -- it shows 2 because we have 2 empty spaces


-- DATA POLICIES we can define for ourself in daily work
-- OPTION 1
-- so when we are working with the string values, we never use the empty spaces for displaying 
-- we only use null and empty strings but avoid the empty spaces 

-- so if the table is having empty spaces in the column then we can handle those things with 
-- TRIM()
-- so we can remove the starting and ending empty spaces to empty string 

with orders as (
select 1 as id, 'A' as category union
select 2, NULL union
select 3,  '' union
select 4, '  '
)
select *, datalength(category) as category_length, datalength(trim(category)) as trimmed_category_length from orders
-- o/p:
id      category    category_length     trimmed_category_length
1	        A	            1	                1
2	        NULL           NULL	                NULL
3	        	            0	                0
4	          	            2	                0

-- OPTION 2 (RECOMMENDED)
-- we will use only the nulls and avoiding the empty strings and empty spaces 
with orders as (
select 1 as id, 'A' as category union
select 2, NULL union
select 3,  '' union
select 4, '  '
)
select *, nullif(trim(category), '') as avoiding_empty_strings_and_empty_spaces from orders
-- o/p:
id      category       avoiding_empty_strings_and_empty_spaces
1	        A	                       A
2	        NULL                       NULL
3	        	                       NULL
4	          	                       NULL



-- OPTION 3 (showing default values)
-- using default values instead of using null, empty spaces, and empty strings 
-- so to make the nulls to a default value like "Unknown" 
-- if the data may have the empty strings, empty spaces and nulls so we need to handle this first 
-- which means we need to do the OPTION 2 first 

with orders as (
select 1 as id, 'A' as category union
select 2, NULL union
select 3,  '' union
select 4, '    '
)
select *, nullif(trim(category), '') as avoiding_empty_strings_and_empty_spaces,
isnull(nullif(trim(category), ''), 'Unknown') as default_values  
from orders
-- o/p:
id      category       avoiding_empty_strings_and_empty_spaces      default_values
1	        A	                       A                                  A
2	        NULL                       NULL                               Un
3	        	                       NULL                               Un
4	          	                       NULL                               Un

-- IMPORTANT POINT: 
-- here we got the "Un" instead of showing the "Unknown" value because
-- when using the isnull(), it shows the data based on the first expression length here
-- with orders as (
-- select 1 as id, 'A' as category union
-- select 2, NULL union
-- select 3,  '' union
-- select 4, '  '
-- )
-- we have category column so sql takes the datatype of the column to measure the length lets say country varchar(2) 
-- if the values above the 2 characters then it will cutoff that values and show only the length of the characters that column can store
-- in the id 4 with 2 empty spaces, but it do not count the characters of the id 2 category column length because it is having NULL value 
-- so the output of this column is 2 so even though we mention the default value "Unknown" 
-- isnull() function will take the column datatype like how many we can store and it will remove the other characters to display
-- so in our case we are not using any table and we are using static data,
-- so sql will measure what is the maximum length of characters country column have,
-- so in our static data we have 2 empty spaces and this is the maximum length of characters we have
-- so the country column can store 2 characters thats why we see "Un" in the default_values column

-- so if the country column value have 5 characters length then the country column store the 5 characters 
with orders as (
select 1 as id, 'A' as category union
select 2, NULL union
select 3,  '' union
select 4, '     '
)
select *, nullif(trim(category), '') as avoiding_empty_strings_and_empty_spaces,
isnull(nullif(trim(category), ''), 'Unknown') as default_values  
from orders
-- o/p:
id      category       avoiding_empty_strings_and_empty_spaces      default_values
1	        A	                       A                                  A
2	        NULL                       NULL                               Unkno
3	        	                       NULL                               Unkno
4	          	                       NULL                               Unkno


-- IMPORTANT: USING COALESCE()
-- so if we want to show the exact value and we dont want to remove the other characters then 
-- we can use coalesce() which will show exact thing and do not depend on the length of first expression
with orders as (
select 1 as id, 'A' as category union
select 2, NULL union
select 3,  '' union
select 4, '  '
)
select *, nullif(trim(category), '') as avoiding_empty_strings_and_empty_spaces,
isnull(nullif(trim(category), ''), 'Unknown') as default_values  
from orders
-- o/p:
id      category       avoiding_empty_strings_and_empty_spaces      default_values
1	        A	                       A                                  A
2	        NULL                       NULL                               Unknown
3	        	                       NULL                               Unknown
4	          	                       NULL                               Unknown

-- now we can see the all characters of the value we gave


-- using the isnull() with integers/numbers
with orders as (
select 1 as id, 10.5123 as score union              -- 10.5123 so total numbers are 6 means, sql will show this in 6 numbers - after the decimal we have 4 numbers so 6-4 = 2 which means from a highest 2 digit we can include here which is 99 number 
select 2, NULL union
select 3,  56.6 union
select 4, 23.5 union
select 5, 89.98125 union
select 6, 12.15
)
select *, 
isnull(score, 12345) as default_values  
from orders
-- o/p: Arithmetic overflow error converting int to data type numeric.

-- this means the score column can have the maximum value of 99.99999 
-- how this number 99.99999 came ?
-- 10.5123 so total numbers are 6 means, 
-- sql will show this in 6 numbers - after the decimal we have 4 numbers 
-- so 6-4 = 2 which means from sql takes highest possible 2 digit number we can include here which is 99 number 
-- since the sql converts the int column to numeric() which is decimal values so 
-- we have to take the maximum number of decimals possible in the column so 
-- in our case we have 89.98125 which have 5 decimal number so now the highest possible number
-- can be 99.99999 
with orders as (
select 1 as id, 10.5123 as score union              -- 10.5123 so total numbers are 6 means, sql will show this in 6 numbers - after the decimal we have 4 numbers so 6-4 = 2 which means from a highest 2 digit we can include here which is 99 number 
select 2, NULL union
select 3,  56.6 union
select 4, 23.5 union
select 5, 89.98125 union
select 6, 12.15
)
select *, 
isnull(score, 100) as default_values        -- 100 does not work because it is < 99.99999  
from orders
-- o/p: Arithmetic overflow error converting int to data type numeric.


with orders as (
select 1 as id, 10.5123 as score union              -- 10.5123 so total numbers are 6 means, sql will show this in 6 numbers - after the decimal we have 4 numbers so 6-4 = 2 which means from a highest 2 digit we can include here which is 99 number 
select 2, NULL union
select 3,  56.6 union
select 4, 23.5 union
select 5, 89.98125 union
select 6, 12.15
)
select *, 
isnull(score, 99) as default_values        -- 100 does not work because it is < 99.99999  
from orders
-- o/p:
id     score        default_values 
1	    10.51230	10.51230
2	    NULL	    99.00000        
3	    56.60000	56.60000
4	    23.50000	23.50000
5	    89.98125	89.98125
6	    12.15000	12.15000

