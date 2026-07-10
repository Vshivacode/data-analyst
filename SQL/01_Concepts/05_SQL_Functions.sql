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
