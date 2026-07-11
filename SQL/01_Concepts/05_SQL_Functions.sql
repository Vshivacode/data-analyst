-- SQL FUNCTIONS
-- funtions are the built in code blocks which are used to perform some operations
-- we have two types of functions 
-- 1. single row functions          2. Multi row functions
-- we have 4 types                  -- aggregate functions
-- string functions                 -- window functions
-- numeric functions
-- date time functions
-- null functions


-- 1. single row functions
-- we give single input and it gives single output
-- ex: lower('ABCD') = abcd


-- NESTED FUNCTIONS
-- so we can multiple functions inside another functions
-- so the inner function will be executed first, and the result of the inner query is the value for next outer function 
-- ex:  len((lower(left('ABCDE', 2)), 5)    so on 


-- TYPES OF SQL FUNCTIONS

-- 1. string functions
-- types 
-- 1. Manipulation          2. Calculation          3. string extraction    
-- concat()                  -- len()                  -- left()
-- upper()                                             -- right()
-- lower()                                             -- substr()
-- trim()
-- replace()


-- first start with manipulation string functions
-- CONCAT():  it is used to combine multiple string values into one value 
-- ex: firstname, lastname combined as fullname

-- Q. concatenate the first name and country into one column 
select firstname, country, concat(firstname,' ', country) as name_country from sales.customers


-- LOWER() and UPPER()
-- lower() is used to convert all the characters to lowercase and upper is used to convert into uppercase

-- Q. convert the firstname to lowercase
select firstname, lower(firstname) as lcase_firstname from sales.customers

-- Q. convert the firstname to uppercase
select firstname, upper(firstname) as ucase_firstname from sales.customers 


-- TRIM()
-- it is used to remove the empty spaces(leading and trailing spaces) in the column at the starting and the ending
-- ex:  "shiva ", " shvia",   "  shiva  ", "     shiva    "    
-- we can remove the empty spaces by using the trim()

-- Q. find the customers whose firstname contains the leading and trailing spaces 

-- lets evaluate first
-- select firstname, len(firstname) as length_firstname from sales.customers 

select firstname from sales.customers 

select len(firstname) from sales.customers

select len(trim(firstname)) from sales.customers

-- if both the values match then there are no empty spaces available at starting and ending of the values
-- IMPORTANT POINT: where clause, can able to use the scalar functions like concat(), lower, upper, replace, trim, len(), round(), year()
-- so except aggregate functions and window functions we can use other functions in where clause 
-- because those functions come after the where clause in sql execution order 

select firstname from sales.customers
where  firstname != trim(firstname)

-- lets find how many characters difference in customers firstname
select firstname,  (len(firstname) - len(trim(firstname))) as char_diff  from sales.customers
where  firstname != trim(firstname)



-- REPLACE()
-- it is used to replace the data with some other value
-- we can also remove the things we want like removing the spaces or anything with the empty string ('')
-- ex: we want to replace the spaces with underscore then we use it

-- Q. remove dashes(-) from ph no

select '123-456-7890', replace('123-456-7890', '-', '')       -- removed the dashes with empty string

select '123-456-7890', replace('123-456-7890', '-', '_')        -- replaced dashes with underscore

-- Q. replace the file extension name from .txt to .csv

select 'file.txt' as old_file, replace('file.txt', '.txt', '.csv') as new_file



-- calculation functions
-- LEN()
-- it is used to count the characters there in the value 
-- it also count the empty spaces as single character and we can also count the date also 
-- the special characters and normal characters all can be calculated 
-- ex:  shiva == 5, 123e4 = 5, gdrg__ wewet = 12,  2020-10-23 = 10

--  Q. calculate length of each customers firstname



-- string extraction
-- LEFT()
-- it is used to extract the characters from the left side and we can specify the length of the characters we want to show
-- we can give more then the existing characters length also fine it works 
-- ex: shiva  -->  left('shiva', 2) =  o/p: sh 
-- ex: shiva -->  left('shiva', 5) = o/p:  shiva
select len('shiva'), left('shiva', 6), len(left('shiva', 6))

-- Q. retrieve first two characters for each customer
select firstname, left(firstname, 2) as first_2_char from sales.customers


-- RIGHT()
-- it is used to extract the characters from the right side of the name and we specify the length of the character we want to show-- ex: shiva  -->  left('shiva', 2) =  o/p: sh 
-- we can give more then the existing characters length also fine it works 
-- ex: shiva  -->  right('shiva', 2) =  o/p: va 
-- ex: shiva -->  right('shiva', 5) = o/p:  shiva
select len('shiva'), right('shiva', 6), len(right('shiva', 6))

-- Q. retrieve last two characters for each customer
select firstname, right(firstname, 2) as first_2_char from sales.customers


-- Q. retrieve the first 2 characters of fistname from customers
select firstname, left(firstname, 2) as first_2_char from sales.customers 


-- Q. retrieve the first 3 characters of firstname from customers without any leading and trailing spaces 
select firstname, trim(left(firstname, 3)) as first_3_char from sales.customers

-- Q. retrieve the last 3 characters of firstname from customers without any empty spaces
select firstname, replace(right(firstname, 3), ' ', '') as last_3_char_nospace from sales.customers




-- SUBSTR()
-- it is used to extract the specific part of the string 
-- we can specify the start and length of the characters to show 
-- so that it returns only that characters 
-- ex: "john doe"   we want from 3rd character to 7th characters only 
-- then in this case we use the substr()
select substring('john doe', 3, 4)        -- 3 is the starting point and 3rd character is included
                                          -- 4 is the length of characters to show 
   
   
-- Q. retrive the list of customers firstname removing the first character
-- it means remove the first character and print all the characters
-- remove first character from firstname and return all characters firstname 
select firstname, substring(trim(firstname), 2, len(firstname)) as remove_first_char from sales.customers





-- Numeric/Number Functions
-- ROUND()
-- it is used to roundup the numeric values and also we can specify the length of the decimals we want to show
-- ex:  3.516  --> round(3.516, 2) then it means we are rounding up to 2 decimals = 3.51 here 3.516 here 6 is above the 5 
-- so we round the value of 3.516 to 3.52
-- so round(), if the last number have =5 or >5 then we rounded it to next number so thats why we got 3.52 
select round(3.516, 2)       -- o/p: 3.52   -- so it will check after 2 decimals whether to rounded or not

select round(3.516, 1)     -- o/p:  3.5  -- after 1 decimal we have 1 which is below 5 so 3.5 
-- why because we are rounding to 1 decimal so after decimal 5 is there so equal to 5 so there will be no change 

select round(3.516, 0)    -- o/p: 4.0   -- we are rounding to 0 decimals which means it will check the first decimal whether to rounded or not 
-- so here after decimal, the first number is 5 which the round() will change the number 3.5 to next numbers which is 4.0

select round(4.245, 2)  -- o/p: 4.25  


-- ABS()
-- it is used to convert the negative signs to positive signs like it removes the negative signs
select abs(-1234)

select abs(1234)




-- DATE TIME FUNCTIONS
-- date():    it is in the format of 'yyyy-mm'dd'  = year-month-day
-- time():    it is in the format of '23:10:45'   = 'hours:minutes:seconds'
-- timestamp() or datetime():   it is the combination of the date and time and it is in the format of "yyyy-mm-dd hh:mm:ss"


select * from sales.orders

select orderdate, shipdate, creationtime from sales.orders


-- we can show the static date or time or datetime also to the table 
select orderdate, shipdate, creationtime, '2025-01-20' as hardcoded from sales.orders    -- it is not stored in db we are just displaying it


-- GETDATE()
-- to know the current date time we use this
select getdate() as current_date_time  -- current datetime


-- types of date time functions
-- 1. part extraction        2. format & casting        3. calculations         4. validation
-- day                         -- format                -- dateadd              -- isdate
-- month                       -- convert               -- datediff
-- year                        -- cast
-- datepart
-- datename
-- datetrunc
-- eomonth


-- day()
-- it is used to return the day from the date and it accepts only one argument
select day(getdate())

select day(orderdate) day_of_date from sales.orders


-- month()
-- it is used to return the month from the date and it accepts only one argument
select month(getdate())

-- year()
-- it is used to return the year from the date and it accepts only one argument
select year(getdate())

select year(orderdate) from sales.orders




select day(creationtime) as dayname, month(creationtime) as monthname, year(creationtime) as yearname from sales.orders



-- datepart(part, date)
-- it is used to return the specific part of the date and the result will be stored in integer format
-- lets say we want the week of that date, quarter of the date, weekday, or we can perform date related things like filtering to show specific date or time

select creationtime, datepart(month, creationtime) from sales.orders

select creationtime, datepart(day, creationtime) from sales.orders

select creationtime, datepart(year, creationtime) from sales.orders

select creationtime, datepart(week, creationtime) from sales.orders


-- sunday = 1, monday = 2,......saturday = 7   when we are using the weekday
select datepart(weekday, getdate())   -- finds the weekday of currentdate

select creationtime, datepart(quarter, creationtime) from sales.orders


-- lets find the time also 
    select datepart(minute, getdate())

select creationtime, datepart(minute, creationtime) from sales.orders


-- Q. find all the customers ordered in february month
select * from sales.orders where datepart(month, creationtime) = 2

-- Q. find the sales according to the year how many sales we got in the years
select datepart(year, creationtime) as year_sales, sum(sales) as total_sales from sales.orders group by datepart(year, creationtime)

-- Q. find the products purchased between 8am to 11am
select customerid, orderid, productid, creationtime from sales.orders where datepart(hour, creationtime) between 8 and 11 
-- or 
select productid from sales.orders where datepart(hour, creationtime) >= 8 and datepart(hour, creationtime) <= 11

select * from sales.orders where datepart(hour, creationtime) >=8 and datepart(hour, creationtime) <= 11

-- Q. find the products does not purchased between 8am to 11am
select customerid, orderid, productid, creationtime from sales.orders where not datepart(hour, creationtime) between 8 and 11 
