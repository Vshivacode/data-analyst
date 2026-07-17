-- CASE STATEMENTS
-- this is like when we want to check for specific conditions we use this like if the condition is met then it returns a value 
-- it executes one by one condition and if the condition is met then it stops checking other conditions
-- CASE STATEMENTS mainly used for DATA TRANSFORMATION, we can retrive the new data from the existing data 
-- case 
--   when condition1 then result1
--   when condition2 then result2
--   .......
--   else result
-- end 


-- IMP POINT:  when using case statements we need to use the same datatype in the condition values 
 case 
     when sales > 50 then 'High'
     when sales > 20 then 'Medium'
     else 'Low'
 end as category
-- like this so here we are using same datatype string for high, medium and low 

-- so if we use different datatype then it throws the error
 case 
     when sales > 50 then 'High'
     when sales > 20 then 9999
     else 'Low'
 end as category
-- o/p: Conversion failed when converting the varchar value 'Low' to data type int.


-- if we dont specify else condition sql will return the NULL value because we are not telling sql that if all conditions fail what to do so sql by default returns NULL value
-- but if we specify the else then we dont get any NULL values even if the value is null that means if the condition is null then it returns the mentioned in else value instead of null 

-- the data types must be same for the values and also we can use this in anywhere in the statements like select, where, group by, order by
-- we can also use case statements in (DATA TRANSFORMATION) to transform one values to another value like transforming the stored values 1 and 0 to the active and inactive 


-- Q. create a report of showing the total sales for each following categories 
-- sales over 50 then (high),  sales between 21 and 50 then (medium), sales 20 or less then (low)
-- sort the categories from highest to lowest 

select 
category, sum(sales) as total_sales
from (
    select orderid, sales, 
    case 
     when sales > 50 then 'High'
     when sales > 20 then 9999
     else 'Low'
    end as category
    from sales.orders
) as nested_table
group by category 
order by total_sales desc
-- o/p: 
category        total_sales
High	            210
Medium	            105
Low	                65

-- here we used subquery for this so first we will add a column of category
-- so here we are taking id, sales, category so these columns will be a temporary table
-- so now we use this temporary table as a main table and we show the data 
-- so inside the subquery we have the category column also, but in original main table we dont have it because it is temporary table



-- Q. retrieve the employee details gender displayed with full text
select * from sales.employees

select employeeid, firstname, lastname, gender, 
case 
when gender = 'M' then 'MALE' 
when gender = 'F' then 'FEMALE'
else 'n/a'
end as gender_full_name
from sales.employees 
-- NOTE: we have not used the else after one condition because we may have the null values so to avoid mistakes we use the correct conditions 



-- Q. retrieve the customer details abbreviated country code
-- so to check the country or to show the abbrevated we need to see how many types countries are there in table and 
-- then we can do the conditions for each country 
select distinct country from sales.customers
-- o/p:
country
-------
Germany
USA

-- so we have two countries so we use that two countries abbreviations
select firstname, lastname, country, 
case 
when country = 'Germany' then 'DE' 
when country = 'USA' then 'US' 
else 'n/a'
end as country_abbrevated 
from sales.customers

-- IMPORTANT POINT:
-- WE CAN MAKE THE QUERY SIMPLE IF WE ARE WORKING ON THE SAME COLUMN FOR DIFFERENT CONDITIONS 
-- normal query here we are taking country column and using it for all the conditions
-- so here we are working with same column then we can make it simpler version
CASE
WHEN Country = 'Germany' THEN 'DE'
WHEN Country = 'India'  THEN 'IN'
WHEN Country = 'United States' THEN 'US'
WHEN Country = 'France' THEN 'FR'
WHEN Country = 'Italy' THEN 'IT'
ELSE 'n/a'
end as country_name

-- we can make it simpler in this way, so we add the column name after the case
-- and we can directly use the values for conditions instead of adding everytime for each conditions
CASE Country
WHEN 'Germany' THEN 'DE'
WHEN 'India' THEN 'IN'
WHEN 'United States' THEN 'US'
WHEN 'France' THEN 'FR'
WHEN 'Italy' THEN 'IT'
ELSE 'n/a'
end as country_name


-- handling null values while using the case statements  
-- Q. find the avg score of customers and treat null to 0
select * from sales.customers

select *, 
case when score is null then 0 else score end as null_to_0, 
avg(score) over () as avg_score_without_handling_null_values,  
avg(case when score is null then 0 else score end) over() as avg_score_handled_null_values 
from sales.customers


-- Q. count how many times each customer made an order with sales greater than 30 

select * from sales.orders

select customerid, sum(sales), count(*) from sales.orders where sales > 30 group by customerid   -- this will also give the same result but if we want to find the total orders we cannot able to do

-- so we use this 
select customerid, sum(case when sales > 30 then 1 else 0 end) as sales_30_above, count(*) as totalorders from sales.orders where sales > 30 group by customerid 







-- AGGREGATE FUNCTIONS
-- 1. COUNT(*)     2. SUM()     3. AVG()        4. MAX()         5. MIN()

-- Q. find the total number of orders
select count(*) as total_orders from sales.orders

-- Q. find the total sales of all orders
select sum(sales) as total_sales from sales.orders 

-- Q. find the avg sales of all orders
select avg(sales) as avg_sales from sales.orders


-- Q. find the highest sales of all orders
select max(sales) from sales.orders


-- Q. find the lowest sales of all orders
select min(sales) from sales.orders
