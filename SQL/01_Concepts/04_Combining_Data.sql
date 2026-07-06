-- COMBINING DATA
-- we can combine the data in two ways row wise and column wise 
-- we have two things here 
-- 1. joins and    2. set operators
-- so for row wise we use the set operators like union, union all, intersect and except
-- so for column wise we use the joins


-- 1. joins
-- what is a join ? 
-- it is used to combine the columns from two or more tables 
-- by default sql uses the inner join if we did not mention any join name and we simply mention just 
-- like this then it uses inner join
select * from customers join orders on customers.id = orders.customer_id
-- o/p:
1	Maria	Germany	350	1001	1	2021-01-11	35
2	 John	USA	900	1002	2	2021-04-05	15
3	Georg	UK	750	1003	3	2021-06-18	20



-- why we use joins ? 
-- we use it because to find or get the information about multiple tables together to get a meaningful data 
-- we use it to get the extra information like finding no.of order by customers it will give a new information about customers
-- filtering purposes i mean if we join the tables it will group them to show whether we have or not 



-- types of joins
-- Basic Joins
-- inner join, 
-- left join, 
-- right join, 
-- self join, 
-- full join

-- Advanced Joins
-- left anti join, 
-- right anti join, 
-- full anti join, 
-- cross join


-- sql task - retrieve all the customers and orders as two seperate results 
select * from customers;
select * from orders;


-- inner join 
-- it only takes the matching rows from two tables
-- so it first checks whether the values in the left table have any matching values in the right table 
-- if yes then it show the data in the table, if not, it will ignore those values
-- we can combine the tables in any way i mean we can mention left table first or right table first the result doesnt change


-- SQL TASK - get all the customers along with their orders, but only the customers who have placed the orders
-- so now lets understand the question what we want 
-- so we want the customers details about orders, so customers who placed the orders means 
-- in the customers table we have customers id and in the orders table we are using the customer_id to store the customers id 
-- so what we want to find if we have the customer id present in the orders table which means 
-- that customer placed an order so we need to join based on the customer id and since we need to find 
-- that customer id to be present in customers and orders table which gives us the customers who placed an order
select * from customers inner join orders on customers.id = orders.customer_id
-- o/p:
id   first_name country   score    order_id    customer_id   order_date    sales 
1       Maria	 Germany   350	    1001	       1	      2021-01-11	35
2	    John	  USA	   900	    1002	       2	      2021-04-05	15
3	    Georg	  UK	   750	    1003	       3	      2021-06-18	20

-- here we can see that id column and the customer_id values are same which means we got the customers who placed orders



-- PROBLEM - if we have the same column names from both the tables we are joining in that case what we do ? 
-- we simply mention the table name followed by the (.) and followed by column name
-- like this tablename.columnname
-- ex: customers.id, orders.customer_id, customers.score, orders.order_date, etc
select customers.id, customers.first_name, orders.order_id, orders.order_date, orders.sales  from customers inner join orders on customers.id = orders.customer_id
-- o/p:
1	Maria	1001	2021-01-11	35
2	 John	1002	2021-04-05	15
3	Georg	1003	2021-06-18	20


-- so mentioning everytime the tablename everytime for the column we can make it simpler in this way
select c.id, c.first_name, o.order_id, o.order_date, o.sales  from customers c inner join orders o on c.id = o.customer_id
-- o/p:
1	Maria	1001	2021-01-11	35
2	 John	1002	2021-04-05	15
3	Georg	1003	2021-06-18	20



-- left join
-- it takes all the data from the left table and the matching data from the right table 
-- and it ignores the right table data 
-- NOTE:  we need to make sure the order we are joining the tables when we are working with the left or right join
-- if we join them in wrong order i mean right table first and left table next and we use left join
-- then it will give the data of the right table data not the left table data because we are starting the right table first


-- get all the customers along with orders and inluding those without orders
-- we want the customers data only and the orders that customers have placed or not placed we dont care 
-- we want to customers data thats it
-- which means all the data of customersand the matching data of customers

select * from customers c left join orders o on c.id = o.customer_id
-- o/p:
| id | first_name | country | score | order_id | customer_id | order_date | sales |
| -: | ---------- | ------- | ----: | -------: | ----------: | ---------- | ----: |
|  1 | Maria      | Germany |   350 |     1001 |           1 | 2021-01-11 |    35 |
|  2 | John       | USA     |   900 |     1002 |           2 | 2021-04-05 |    15 |
|  3 | Georg      | UK      |   750 |     1003 |           3 | 2021-06-18 |    20 |
|  4 | Martin     | Germany |   500 |     NULL |        NULL | NULL       |  NULL |
|  5 | Peter      | USA     |     0 |     NULL |        NULL | NULL       |  NULL |

-- here we see that we also have the null values because those are the customers who did not ordered anything so thats why their orders data is showing null





-- right join 
-- it is same as left join, but it will take all the data from the right table and the matching data from the left table
-- it shows the data from the right table and the matching data from the left table


-- SQL TASK: get all the customers along with the orders including orders but without the customers
-- here we join the right table first and next we join left table 
select * from customers c right join orders o on c.id = o.customer_id

-- instead of this we can get the same result using left join
select * from orders o left join customers c on c.id = o.customer_id




-- full join
-- it returns everything from both the tables the matching or not matching everything shows
-- get all the customers and orders even dont match 

-- SQL TASK: get all the customers and orders, even if there is no match
select * from customers full join orders on customers.id = orders.customer_id




-- ADVANCED SQL JOINS
-- LEFT ANTI JOIN
-- so it takes all the data from the left table and the not matching data from the right table
-- which means all the data in the left table we want but, we will combine the data in the right table whose value is null
-- which will give us the not matching data
-- so we dont have a command like using left anti join 
-- so we will use the left join, for the left anti join also but also with the where clause 


-- SQL TASK: get all the customers who have not placed any orders
-- which means the customers did not placed any orders so the value for that customers in the orders table 
-- will be having a null values so if we use the orders.customer_id null then we get the answer 
-- that those customers did not placed any orders

-- we use left join here because if we find the customers who have ordered then we can easily find
select * from customers left join orders on customers.id = orders.customer_id

-- this will give the left join but we want left anti join so we use where clause
select * from customers left join orders on customers.id = orders.customer_id where orders.customer_id is null

-- o/p:
id | first_name | country | score | order_id | customer_id | order_date | sales
---+------------+---------+-------+----------+-------------+------------+-------
4  | Martin     | Germany | 500   | NULL     | NULL        | NULL       | NULL
5  | Peter      | USA     | 0     | NULL     | NULL        | NULL       | NULL




-- RIGHT ANTI JOIN
-- it is opposite of LEFT ANTI JOIN 
-- so we want all the data from the right table and the not matching data from the left table
-- so here also we dont have any special command for right anti join so we use the right join


-- get all the orders without matching customers
select * from orders left join customers on orders.customer_id = customers.id 

-- this will give the right join but we want right anti join so we use where clause
 select * from orders left join customers on orders.customer_id = customers.id where customers.id is null
