-- filtering data 
-- comparison operators 
-- =
-- >
-- <
-- >=
-- <=
-- != 


-- logical operators
-- and
-- or
-- not

-- range operators 
-- between 


-- membership operators 
-- in 
-- not in 

-- search operator 
-- like 


-- comparison operatos
-- it is used to compare the two values and the operators are used with the where clause
-- syntax - expression operator expression
-- here expression can be:
-- column1 = column2,  ex: firstname = lastname
-- column1 = 'value',  ex: firstname = 'john'
-- function = value,  ex: sum(score) = 1000
-- expression = value,  ex: price * quantity = 1000
-- subquery = value,  ex: select sum(score) from customers = 1000




-- = operator
-- it checks whether two values are equal 
select * from customers where country = 'germany'  -- does not follow case sensitive

-- != or <>  both symbols works 
-- it checks whether two values are not equal 
select * from customers where country != 'Germany'  -- shows all the data excluding the germany
select * from customers where country <> 'Germany'


-- > greater than 
-- it checks whether the value is greater than another value
select * from customers where score > 400

-- < 
-- it checks whether the value is less than another value
select * from customers where score < 400


-- >=
-- it checks whether the value is greater or equal to than another value
select * from customers where score >= 500

-- <=
-- it checks whether the value is less than or equal to than another value
select * from customers where score <= 500



-- logical operators 
-- and -  all the conditions must be true

-- sql task - retrieve all customers whose score is greater than 500 and country is usa
select * from customers where country = 'usa' and score > 500

-- or    atleast one of the condition must true 
-- sql task - retrieve all customers whose score is greater than 500 or country is usa
select * from customers where country = 'usa' or score > 500


-- not it excludes the matching values, so it will not show the values which is fulfilling the condition

-- sql task - retrieve all the customers whose score not < 500
select * from customers where not score < 500  -- we prefer to use this 
-- or we can do this 
select * from customers where score !< 500


-- between 
-- it checks whether the value is inside the range or outside the range and it includes the values mentioned in the range

-- sql task - retrieve all the customers whose score range between 100 and 500
select * from customers where score between 100 and 500
-- or we can do this 
select * from customers where score >= 100 and score <=1000   -- we prefer this



-- in   
-- same as or operator, so it checks whether the values are present in the list or not

-- sql task - retreive all the customers whose countries are usa or germany
-- previously we did like this 
select * from customers where country = 'germany' or country = 'usa'
-- but we can do this in simpler version using 'in' operator 
select * from customers where country in ('usa', 'germany')


-- not in  so it checks whether the values are not present in the list
select * from customers where country not in ('germany', 'usa')

select * from customers where country != 'germany' and country != 'usa'




-- like 
-- % means many characters will come 
-- _ underscore means only one character will come 
-- %a  means starts with any characters or many characters but needs to end with the letter 'a'
-- _a means only one character will come at starting of the word and ends with letter 'a'
-- _a% so start with any one letter but the second letter to be 'a' and after that any characters can come
-- %s%  means anything comes before and after dont care s needs to be present so 
-- ex:  sam,  mas,  asm,   s ,   all are true even before and after dont have the letters 
-- but _s_  this means one letter must be included at starting and ending so asm, msa will be true and other are false  
-- so many combinations we can do 

-- name starts with 'm'
select * from customers where first_name like 'm%'

-- name ends with 'm'
select * from customers where first_name like '%n'

-- name contains 'r'
select * from customers where first_name like '%r%'

-- name has 'r' in third position
select * from customers where first_name like '__r%'

