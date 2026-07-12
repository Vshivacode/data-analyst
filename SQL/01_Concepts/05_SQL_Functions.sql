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



-- datename(part, date)
-- it returns the name of the date means the dayname, monthname and result will be in string format 
select datename(month, getdate()) -- returns the month name

select sql_variant_property(datename(week, getdate()), 'basetype') -- we can check the datatype with this



datetrunc(part, value)
-- it truncates specific part of the date or time so it means we show only that part which are needed accordingly 
-- for time if we truncate then the truncated time will be reset to '00'
-- for date if we truncate then the truncated date will be reset to '01'  because we dont have a day or something start with 00 
-- ex: datetrunc(month, getdate())     o/p:  2025-11-01 00:00:00.000   after month the day is changed to 01 and time also changed to 00 
select datetrunc(month, getdate())


select datetrunc(year, creationtime) as year_trunc from sales.orders 



-- EOMONTH(date)
-- it returns the end of the month means if the date have month march then it changes the day to the 31 because march month contains the last day 31


select eomonth(getdate())

select eomonth(creationtime) from sales.orders


-- To get the start day of month we combine it with the datetrunc to show the start day of month
select datetrunc(month,creationtime) from sales.orders




-- Q. How many orders placed each year
select year(orderdate) as year, count(*) as no_of_orders from sales.orders group by datepart(year, orderdate)


-- Q. how many orders placed each month
select datename(month, orderdate) as month, count(*) as no_of_orders from sales.orders group by datename(month, orderdate)



-- Q. show all the orders that were placed in the month of february 
select * from sales.orders where month(orderdate) = 2




-- date format
-- format(value, format)
-- it is used to change the format of the value, so we can format not only date we can also do numbers
-- format are case sensitive while using the format()
-- yyyy  = year
-- MM  = month
-- dd = day
-- HH = hour is for 24 hours,  hh = hour for 12 hours 
-- mm = minute
-- ss = second
-- why we use the format real life example
-- we will get the data from random sources like apis, website, databases,etc so all are having
-- the data lets say date so they are in different format so we cannot use that all types of date format
-- instead we format them to one format and we use it 
select 
    creationtime,
    format(creationtime, 'yyyy/mm/dd' ) as date, 
    format(creationtime, 'dd') as daynumber,
    format(creationtime, 'ddd') as daynameshort, 
    format(creationtime, 'dddd') as dayname, 
    format(creationtime, 'MM') as monthnumber,
    format(creationtime, 'MMM') as monthnameshort, 
    format(creationtime, 'MMMM') as monthname,
    format(creationtime, 'yyyy') as year,
    format(creationtime, 'HH') as '24hour',          -- 24 hours
    format(creationtime, 'hh') as '12hour',          -- 12 hours
    format(creationtime, 'mm') as minute,          
    format(creationtime, 'ss') as second          

from sales.orders


-- Q. show creation time using this format " day wed jan Q1 2025 12:34:56 pm "

select 
    creationtime, 
    concat_ws(
    ' ',
    format(creationtime, 'dd ddd MMM'),
    concat('Q', datepart(quarter, creationtime)),
    format(creationtime, 'yyyy HH:mm:ss tt')
    ) 
from sales.orders 

-- or we can simply do this 
select 
    creationtime, 
    format(creationtime, 'dd ddd MMM') + ' ' +
    'Q' + datename(quarter, creationtime) + ' ' +
    format(creationtime, 'yyyy HH:mm:ss tt') 
from sales.orders




-- find sales by month
select format(orderdate, 'MMM yyyy'), count(*) from sales.orders group by format(orderdate, 'MMM yyyy')



-- so using the numbers with format()
-- number default value
select format(sales, 'N') from sales.orders      -- 'N' is used to format it to number default

-- percentage
select format(sales, 'p') from sales.orders      -- 'p' is used to format it to percentage

-- CURRENCY
select format(sales, 'c') from sales.orders      -- 'c' is used to format it to currency in dollars by default

-- if we want in indian rupees then we need to use the culture codes 
-- so for indian rupees we use 'hi-in' so it is like the national language spoken and the india country in two letters

select format(sales, 'c', 'hi-in') from sales.orders      -- 'c' is used to format it to currency and  'hi-in' is used for indian rupees

select format(sales, 'c', 'zh-cn') from sales.orders      -- 'c' is used to format it to currency and  'zh-cn' is used for china 

-- DECIMALS 
select format(sales, 'N1') from sales.orders      -- 'N1' is used to format it to one decimal

select format(sales, 'N2') from sales.orders      -- 'N2' is used to format it to two decimals

select format(sales, 'N99') from sales.orders      -- 'N2' is used to format it to two decimals

-- upto 99 we can use any number of decimals we want because after that if we do N100 then it wont work




-- CONVERT(data_type, value,)
-- it is used to convert the date and time value to a different data type and also formats the value
-- so converting the int value to varchar or vice versa or any other 
select convert(int, '123') as varchar_to_int   -- converting the varchar to int value


select convert(varchar, 123) as int_to_varchar   -- converting the int to varchar value
-- lets check datatype
select sql_variant_property(convert(varchar, 123), 'basetype') as int_to_varchar 


select convert(date, '2025-01-23') as varchar_to_date    

-- lets convert the creationtime to date 
select convert(date, creationtime) from sales.orders    
-- lets check the datatype of the value
select convert(date, creationtime), sql_variant_property(convert(date, creationtime), 'basetype') as datatype from sales.orders    



-- CAST(value as datatype)
-- converts a value to a specific data type and we use this only for changing the datatype
-- we give the value and we tell the datatype we want to convert it
select cast(234 as varchar), SQL_VARIANT_PROPERTY(cast(234 as varchar), 'basetype')    -- converting it to varchar





--  difference between FORMAT() VS CONVERT() VS CAST()
-- FORMAT()
-- it is used to convert any type to string and can format the datetime and numbers also


-- CONVERT()
-- it is used to convert the data types and only formats the datetime


-- CAST()
-- it is used to convert only the datatypes NO Formating 



-- DATE CALCULATIONS
-- types of date calcualtions
-- 1. DATEADD()      2. DATEDIFF()

-- DATEADD(part, interval, date)
-- these are used to add or subtract the date or time interval like adding the years to the date or subtract to the months or adding some hours minutes seconds of time
-- ex: adding 5 years to the year,     subtract 3 months from month,       add 30 minutes to minutes for time

select creationtime, dateadd(hour, 2, creationtime) from sales.orders    -- we added 2 hours to the creationtime
select creationtime, dateadd(minute, 40, creationtime) from sales.orders    -- we added 40 minutes to the creationtime
select creationtime, dateadd(second, 19, creationtime) from sales.orders    -- we added 19 seconds to the creationtime

select orderdate, dateadd(year, -5, orderdate) from sales.orders       -- we subtracted 5 years from year
select orderdate, dateadd(month, 10, orderdate) from sales.orders       -- we added 10 months from months
select orderdate, dateadd(day, 23, orderdate) from sales.orders       -- we added 23 days from days



-- DATEDIFF(part, start_date, end_date)
-- it is used to calculate the difference between two dates

select orderdate, creationtime, datediff(month, orderdate, getdate()) as month_diff from sales.orders

select orderdate, creationtime, datediff(minute, orderdate, getdate()) as month_diff from sales.orders



-- calcualte the age of the employees
select *, datediff(year, birthdate, getdate()) as age from sales.employees


-- find the average shipping duration in days for each month
select * from sales.orders

select month(orderdate) as orderdate, avg(datediff(day, orderdate, shipdate)) as avgship from sales.orders group by month(orderdate) 



-- find the number of days between each order and the previous order
select * from sales.orders

select orderid, orderdate as current_order_date,
lag(orderdate) over (order by orderdate) as previous_order_date,
datediff(day, lag(orderdate) over (order by orderdate), orderdate)
from sales.orders order by orderdate asc




-- ISDATE(value)
-- it is used to check the value is a valid date or not
-- if it is valid date it returns 1 
-- if date is invalid then it returns 0
select isdate('2025-10-100')    -- returns 0 because it is invalid

select isdate('2025-10-10')     -- returns 1 date is valid


select isdate('123')

select isdate('1800')       -- returns 1 because it treats as a year

select isdate('20')         -- it returns 0 not a month or day or year 

