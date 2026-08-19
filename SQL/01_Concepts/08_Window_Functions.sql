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
-- ex: 
id    name    sales
1    john      20
2    sam       10
3    jason     5
4    john      8
5    sam       15

-- so now if we use the group by the result will be look like this 
john    28
sam     25
jason   5
-- so here we are not getting other rows and not getting all the columns and also we cannot able to use other columns which are not aggregated or group by

-- so if we use the window function here we will get all the details without losing anything 
-- o/p:
id    name    sales
1    john      28       -- got aggregated value same for id 4 also 
2    sam       25       -- got aggregated value same for id 5 also 
3    jason     5        -- we dont have another value so we got the same thing 
4    john      28
5    sam       25



-- when to use group by and window functions ?
-- if we want to perform simple aggregations then we use group by
-- if we want to perform aggregations with details then we use the window functions


-- WINDOW FUNCTIONS                                         GROUP BY (only aggregate functions)
-- aggrgations functions (accepts expressions)              -- aggregations functions                   
-- COUNT(all data types)                                    -- COUNT(all data types)   
-- SUM()                                                    -- SUM()
-- AVG()                                                    -- AVG()
-- MAX()                                                    -- MAX()
-- MIN()                                                    -- MIN()


-- RANK FUNCTIONS (accepts no datatypes or expressions and nothing DOES NOT allow to use FRAME CLAUSE)
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
select * from sales.orders 

select sum(sales) as total_sales from sales.orders      -- we can simply use sum()


-- Q. find the total sales across all orders by each product
select productid, sum(sales) as total_sales from sales.orders group by productid 
-- o/p:
productid	total_sales
101	            140
102	            105
104	            75
105	            60

-- Q. find the total sales across all orders by each product additionally show the orderid, and orderdate
-- lets say we want to see the order details also in the table like order id and order date when it is ordered or like for that day how many sales 
select productid,orderid, sum(sales) as total_sales from sales.orders group by productid, orderid
-- o/p:
productid	orderid	total_sales
101	            1	    10
102	            2	    15
101	            3	    20
105	            4	    60
104	            5	    25
104	            6	    50
102	            7	    30
101	            8	    90
101	            9	    20
102	            10  	60

-- so it combines productid + orderid means it treats both as one single value and if we have any rows
-- where both column values match then that will be grouped as one row if not it treats as seperate 
-- so now we need to use the window functions here
select productid,orderid, sum(sales) over(partition by productid) as total_sales from sales.orders
-- o/p: 
productid	orderid	total_sales
101	            1	    140
101	            3	    140
101	            8	    140
101	            9	    140
102	            10  	105
102	            2	    105
102	            7	    105
104	            5	    75
104	            6	    75
105	            4	    60

select productid,orderid, orderdate, sum(sales) as total_sales from sales.orders group by productid, orderid, orderdate
-- here we see the total sales are not calculated properly because group by have the other columns also which breaks the total sales calculations
-- we cannot do both the aggregations and the columns to show because it will perform grouping for all the mentioned columns
--o/p:
productid	orderid	orderdate	total_sales
101	            1	2025-01-01	    10
102	            2	2025-01-05	    15
101	            3	2025-01-10	    20
105	            4	2025-01-20	    60
104	            5	2025-02-01	    25
104	            6	2025-02-05	    50
102	            7	2025-02-15	    30
101	            8	2025-02-18	    90
101	            9	2025-03-10	    20
102	            10	2025-03-15  	60

-- now in this case we need to perform grouping to only the sales column so to do this we need to use the window functions
select orderid, orderdate,productid, sum(sales) over(partition by productid) as total_sales_each_product from sales.orders
-- o/p:
orderid	orderdate	productid	total_sales_each_product
1	    2025-01-01	    101	            140
3	    2025-01-10	    101	            140
8	    2025-02-18	    101	            140
9	    2025-03-10	    101	            140
10	    2025-03-15	    102	            105
2	    2025-01-05	    102	            105
7	    2025-02-15	    102	            105
5	    2025-02-01	    104	            75
6	    2025-02-05	    104	            75
4	    2025-01-20	    105	            60



-- WINDOW FUNCTON SYNTAX

-- SYNTAX:  window function over(partition clause  order by clause frame clause)

-- window function = aggregate functions, ranking functions, value functions
-- partition clause = similar to group by but without merging the same data  
-- order by clause = column names to order in asc or desc
-- frame clause   = we tell sql to exactly calculate those rows relative to the current row

-- ex: sum(sales) over(partition by productid order by orderdate rows unbounded preceding )

-- we can also use case statements with the aggregate functions like 
-- sum(case when score > 100 and score < 150 then sales end) it means we are calculation only those values 

select sales from sales.orders order by sales

select sum(case when sales > 10 and sales < 25 then sales end ) as segment_sales from sales.orders
-- o/p:
segment_sales
55


-- we can also use the where clause instead of this 
select sum(sales) as segment_sales from sales.orders where sales > 10 and sales < 25
-- o/p:
segment_sales
55



-- OVER() clause 
-- we can leave it as empty in over clause also works 
-- so when we use the over() clause we are saying sql that we need to perform window functions
-- ex: select avg(sales) over() from sales.orders    -- it will give the avg(sales)  and return the same result for all the rows
-- we can use any one cluase or all of them or we can leave over() clause empty also according to the calculations we need
-- ex: select sum(sales) over(partition by productid) from sales.orders 

-- ex: select sum(sales) over(partition by productid order by orderdate) from sales.orders 

select sum(sales) over(partition by productid order by orderdate rows unbounded preceding) from sales.orders 

select orderid, sales, sum(sales) over() from sales.orders
-- o/p:
orderid	sales	(No column name)
1	      10	        380
2	      15	        380
3	      20	        380
4	      60	        380
5	      25	        380
6	      50	        380
7	      30	        380
8	      90	        380
9	      20	        380
10	      60	        380

-- Q. find the product prices greater than the avg price including the columns productid, orderid, price,avg price
-- if the product price greater than the avg price show "EXPENSIVE"
-- if it is less than avg price then show 'CHEAP' 
-- if price and avg price are same then show 'NEUTRAL' 

select productid, avg(price) as avg_price from sales.products group by productid
-- so here in this we cannot add the extra columns so we need to use the window functions here 

-- here we can solve this using window functions only 
select 
    productid, 
    product, 
    price, 
    avg(price) over() as avg_price,       
    case 
        when price > avg(price) over() then 'EXPENSIVE'
        when price < avg(price) over() then 'CHEAP' 
        when price = avg(price) over() then 'NEUTRAL' 
    end as price_category
from sales.products
-- o/p:
productid	product	price	avg_price	price_category
101	        Bottle	  10	    20	        CHEAP
102	        Tire	  15	    20	        CHEAP
103	        Socks	  20	    20	        NEUTRAL
104	        Caps	  25	    20	        EXPENSIVE
105	        Gloves	  30	    20	        EXPENSIVE



-- WITH PARTITION BY CLAUSE
-- it is similar to the group by clause but it will do the grouping by making seperate windows according to the aggregations
-- so if we do the sum(sales) over(partition by productid) then it will create seperate windows for each product id that means 
-- for each product it will have the total sales and that value will be shown to that window only
select orderid, orderdate,productid, sum(sales) over(partition by productid) as total_sales_each_product from sales.orders
-- o/p:
orderid	orderdate	productid	total_sales_each_product
1	    2025-01-01	    101	                140
3	    2025-01-10	    101	                140
8	    2025-02-18	    101	                140
9	    2025-03-10	    101	                140
10	    2025-03-15	    102	                105
2	    2025-01-05	    102	                105
7	    2025-02-15	    102	                105
5	    2025-02-01	    104	                75
6	    2025-02-05	    104	                75
4	    2025-01-20	    105	                60

-- WITHOUT PARTITION BY CLAUSE
-- so if we dont specify any clause in the over() clause then it will give the entire aggregated column value to all
-- the rows same value to all the rows 
-- in this we have only one window because we did not mentioned in over() clause 
select sum(sales) over() from sales.orders     -- it will give the sum(sales)  and return the same result for all the rows
-- o/p:
(No column name)
380
380
380
380
380
380
380
380
380
380


-- Q. find the total sales of the orders additionally provide details of the orderid and orderdate
select orderid, orderdate, sum(sales) over () as total_sales from sales.orders 
-- o/p:
orderid	orderdate	total_sales
1	    2025-01-01	    380
2	    2025-01-05	    380
3	    2025-01-10	    380
4	    2025-01-20	    380
5	    2025-02-01	    380
6	    2025-02-05	    380
7	    2025-02-15	    380
8	    2025-02-18	    380
9	    2025-03-10	    380
10	    2025-03-15	    380

-- Q. find the total sales for each product of the orders additionally provide details of the orderid and orderdate
select orderid, orderdate, productid, sum(sales) over (partition by productid) as total_sales_each_product from sales.orders 
-- here we can see 4 windows so for each product since we have 4 different products so we have 4 windows and each window use seperate aggregations
-- o/p:
orderid	orderdate	productid	total_sales_each_product
1	    2025-01-01	    101	                140
3	    2025-01-10	    101	                140
8	    2025-02-18	    101	                140
9	    2025-03-10	    101	                140
10	    2025-03-15	    102	                105
2	    2025-01-05	    102	                105
7	    2025-02-15	    102	                105
5	    2025-02-01	    104	                75
6	    2025-02-05	    104	                75
4	    2025-01-20	    105	                60


-- Q. find the total sales for each combination of product and order status 
select * from sales.orders 

select sales, productid, orderstatus, sum(sales) over (partition by productid, orderstatus) as product_wise_orderstatus from sales.orders 
-- here we have total 6 windows 
-- here it is doing the two groupings so one is for productid and other is for orderstatus 
-- which means first it will group all the rows accoring to the productid and then 
-- it will group the rows according to the orderstatus 
-- o/p:
sales	productid	orderstatus	  product_wise_orderstatus
10	        101	     Delivered	            30
20	        101	     Delivered	            30
90	        101	     Shipped	            110
20	        101	     Shipped	            110
30	        102	     Delivered	            30
60	        102	     Shipped	            75
15	        102	     Shipped	            75
25	        104	     Delivered	            75
50	        104	     Delivered	            75
60	        105	     Shipped	            60


-- ORDER BY CLAUSE WITH WINDOW FUNCTIONS
-- IMPORTANT NOTE: ORDER BY uses a default frame, so if we dont mention the frame clause,it uses this "unbounded preceding and current row" as default frame
-- ex: select orderid, productid, sum(sales) over(partition by productid order by sales) from sales.orders
-- here we did not mentioned the frame clause but sql still uses the default frame clause unbounded preceding and current row 

-- order by used to sort the rows in asc or desc according to the partition wise so if we use partition it will 
-- sort them accordingly so that each window is sorted seperately in asc or desc
-- it will do the sorting within the window 
-- so for rank functins and value functions ORDER BY is MANDATORY because without this it doesnt make any sense
select sales, productid, orderstatus, sum(sales) over (partition by productid, orderstatus order by sales) as product_wise_orderstatus from sales.orders 
-- here we have 6 windows so the each window is sorted asc according to productid and orderstatus 
-- o/p: 
sales	productid	orderstatus	product_wise_orderstatus
10	        101	     Delivered	        10
20	        101	     Delivered	        30
20	        101	     Shipped	        20
90	        101	     Shipped	        110
30	        102	     Delivered	        30
15	        102	     Shipped	        15
60	        102	     Shipped	        75
25	        104	     Delivered	        25
50	        104	     Delivered	        75
60	        105	     Shipped	        60

-- Q. rank each order based on the sales from highest to lowest including the details of the orderid, orderdate
-- select orderid, orderdate,sales, rank() over(order by sales desc) from sales.orders

select orderid, orderdate,sales, rank() over (order by sales desc) from sales.orders
-- o/p:
orderid	orderdate	sales	(No column name)
8	    2025-02-18	  90	        1
4	    2025-01-20	  60	        2
10	    2025-03-15	  60	        2
6	    2025-02-05	  50	        4
7	    2025-02-15	  30	        5
5	    2025-02-01	  25	        6
9	    2025-03-10	  20	        7
3	    2025-01-10	  20	        7
2	    2025-01-05	  15	        9
1	    2025-01-01	  10	        10

-- WINDOW FRAME CLAUSE
-- the partition by creates windows according to the aggregations so in the same way the frame clause will create another window inside a window like nested if we are using the partition by only 
-- if we are not using partition by it will do the aggregations for the entire column so it will assume as one window
-- the frame clause window is based on the conditions like from which row to take or do the calculations of a window
-- it will do the aggregations based on the conditions 
-- it is not used while we are working with the rank functions 
-- we can use it with the aggregate and value functions only 

-- frame clause syntax -  frame type lower value and higher value 
-- frame type = ROWS  and  RANGE 
-- lower value  =  UNBOUNDED PRECEDING, N PRECEDING, CURRENT ROW
-- higer value = CURRENT ROW, N FOLLOWING , UNBOUNDED FOLLOWING

-- UNBOUNDED PRECEDING =  it means start from the first row of the column
-- N PRECEDING  =   N means any number to start from  like   3 preceding means take 3 rows 
-- CURRENT ROW = the current row we are in the calculations we are performing 

-- UNBOUNDED FOLLOWING =  it means goto the last row of the column 
-- N FOLLOWING =  N means any number of rows to take like for 3 following means take 3 rows 
-- CURRENT ROW  =  the current row we are in calculation 

-- COMBINATIONS  WE GET (always we use lower value at the left side and right will be the higher value)

-- ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW 
-- means start from the first row and go till the end of the column calculating the each rows
-- so lets say we start from the first row and initially we are in the first row so the first row and the current row will be same so the value will be same 
-- for next row it will take the first row and now the current row will be the second row so it will do first row + second row = the current row value if we are doing the sum(columnname) 
-- if we are doing min(columnname) then it will compare the both values and return that value to the current row 

create table sales.monthly_sales(id int primary key, month varchar(20), sales int)

INSERT INTO sales.monthly_sales (id, month, sales) VALUES
(1,  'January',   12),
(2,  'February',  24),
(3,  'March',     18),
(4,  'April',     32),
(5,  'May',       44),
(6,  'June',      26),
(7,  'July',      38),
(8,  'August',    40),
(9,  'September', 22),
(10, 'October',   48),
(11, 'November',  36),
(12, 'December',  28);

INSERT INTO sales.monthly_sales (id, month, sales) VALUES
-- January duplicated 3 times
(13, 'January', 18),
(14, 'January', 24),
(15, 'January', 32),

-- March duplicated once
(16, 'March', 20),

-- May duplicated twice
(17, 'May', 28),
(18, 'May', 42),

-- August duplicated 3 times
(19, 'August', 16),
(20, 'August', 22),
(21, 'August', 48),

-- November duplicated once
(22, 'November', 14),

-- December duplicated twice
(23, 'December', 26),
(24, 'December', 38);


select * from sales.monthly_sales
-- o/p:
id	month	sales
1	January	12
2	February	24
3	March	18
4	April	32
5	May	44
6	June	26
7	July	38
8	August	40
9	September	22
10	October	48
11	November	36
12	December	28
13	January	18
14	January	24
15	January	32
16	March	20
17	May	28
18	May	42
19	August	16
20	August	22
21	August	48
22	November	14
23	December	26
24	December	38

-- since we are not using partition by it will take the entire column as one window and it will do the aggregations
select month, sales, sum(sales) over (order by sales rows between unbounded preceding and current row) from sales.monthly_sales
-- o/p:
month	sales	(No column name)
January	12	12
November	14	26
August	16	42
January	18	60
March	18	78
March	20	98
August	22	120
September	22	142
February	24	166
January	24	190
June	26	216
December	26	242
December	28	270
May	28	298
January	32	330
April	32	362
November	36	398
July	38	436
December	38	474
August	40	514
May	42	556
May	44	600
October	48	648
August	48	696

-- if we use the partition by month then it will create the windows and if we use the frame clause then it will take rows within that window 
select month, sales, sum(sales) over (partition by month order by sales rows between unbounded preceding and current row) from sales.monthly_sales
-- o/p:
month	sales	(No column name)
April	32	32
August	16	16
August	22	38
August	40	78
August	48	126
December	26	26
December	28	54
December	38	92
February	24	24
January	12	12
January	18	30
January	24	54
January	32	86
July	38	38
June	26	26
March	18	18
March	20	38
May	28	28
May	42	70
May	44	114
November	14	14
November	36	50
October	48	48
September	22	22


-- ROWS BETWEEN UNBOUNDED PRECEDING AND 2 FOLLOWING
-- it means from first row to the 2 following means the next two rows from the current row 
-- which means if we are in the first row it will take first row + second row + third row 
-- now we are in the second row so it will take the first row + second row (current row) + third row + fourth row
-- now we are in third row so it will take first row + second row + third row(current row) + fourth row + fifth row
select month, sales, sum(sales) over (order by sales rows between unbounded preceding and 2 FOLLOWING) from sales.monthly_sales
-- o/p:
month	sales	(No column name)
January	12	42
November	14	60
August	16	78
January	18	98
March	18	120
March	20	142
August	22	166
September	22	190
February	24	216
January	24	242
June	26	270
December	26	298
December	28	330
May	28	362
January	32	398
April	32	436
November	36	474
July	38	514
December	38	556
August	40	600
May	42	648
May	44	696
October	48	696
August	48	696

-- ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
-- it means the it will take from the first row to  last row which means all the rows of that column same as doing the simply total sales 
-- select sum(sales) from sales.monthly_sales

select month, sales, sum(sales) over (order by sales rows between unbounded preceding and UNBOUNDED FOLLOWING) from sales.monthly_sales
-- o/p:
month	sales	(No column name)
January	12	696
February	24	696
March	18	696
April	32	696
May	44	696
June	26	696
July	38	696
August	40	696
September	22	696
October	48	696
November	36	696
December	28	696
January	18	696
January	24	696
January	32	696
March	20	696
May	28	696
May	42	696
August	16	696
August	22	696
August	48	696
November	14	696
December	26	696
December	38	696


-- ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW 
-- it means take the current row and take all the rows before the current row 
select month, sales, sum(sales) over (order by sales rows between unbounded preceding and current row) from sales.monthly_sales
-- o/p:
month	sales	(No column name)
January	12	12
November	14	26
August	16	42
January	18	60
March	18	78
March	20	98
August	22	120
September	22	142
February	24	166
January	24	190
June	26	216
December	26	242
December	28	270
May	28	298
January	32	330
April	32	362
November	36	398
July	38	436
December	38	474
August	40	514
May	42	556
May	44	600
October	48	648
August	48	696


-- ROWS BETWEEN 2 PRECEDING AND CURRENT ROW 
-- means how many rows to take before the current row 
-- so first row will be same first row + current row = first row value
-- so now we are in second row so first row + second row (current row) 
-- now we are in third row  so it will take first row + second row + third (current row)
-- now we are in fourth row so it will take second row + third row + fourth row (current row)
select month, sales, sum(sales) over (order by sales rows between 2 preceding and CURRENT ROW) from sales.monthly_sales
-- o/p:
month	sales	(No column name)
January	12	12
November	14	26
August	16	42
January	18	48
March	18	52
March	20	56
August	22	60
September	22	64
February	24	68
January	24	70
June	26	74
December	26	76
December	28	80
May	28	82
January	32	88
April	32	92
November	36	100
July	38	106
December	38	112
August	40	116
May	42	120
May	44	126
October	48	134
August	48	140

-- ROWS BETWEEN 2 PRECEDING AND 2 FOLLOWING 
-- it means take 2 rows before current row and take 2 rows after current row
-- so now we are in first row so it will take first row(current row) + second row + third row  because before first row we dont have any rows so we do from current row which is first row
-- now we are in second row so it will take first row + second row(current row) + third row + fourth row + fifth row
-- now we are in the third row so it will take first + second + third(current) + fourth + fifth 
select month, sales, sum(sales) over (order by sales rows between 2 preceding and 2 FOLLOWING) from sales.monthly_sales
-- o/p:
month	sales	(No column name)
January	12	42
November	14	60
August	16	78
January	18	86
March	18	94
March	20	100
August	22	106
September	22	112
February	24	118
January	24	122
June	26	128
December	26	132
December	28	140
May	28	146
January	32	156
April	32	166
November	36	176
July	38	184
December	38	194
August	40	202
May	42	212
May	44	222
October	48	182
August	48	140


-- ROWS BETWEEN 2 PRECEDING AND UNBOUNDED FOLLOWING    (sql do reverse calculation)
-- it means 2 rows before current row and goto all the rows to the end 
select month, sales, sum(sales) over (order by sales rows between 2 preceding and UNBOUNDED FOLLOWING) from sales.monthly_sales
-- o/p:
month	sales	(No column name)
October	   48	        140
August	   48	        182
May	       44	        222
May	       42	        260
August	   40	        298
July	   38	        334
December   38	        366
November   36	        398
January	   32	        426
April	   32	        454
December   28	        480
May	       28	        506
December   26	        530
June	   26	        554
February   24	        576
January	   24	        598
September  22      	    618
August	   22	        636
March	   20	        654
January	   18	        670
March	   18	        684
August	   16	        696
November   14	        696
January	   12	        696

-- so here the data we get will be in the reverse order like the sales will be arranged in the desc order 
-- because sql takes the optimised calculations so by doing it from the bottom to first row it will be easier and fastest way to do the calculations 
-- so thats why we get the data in the reverse calculation 
-- so get in the proper order like we want the sales to be shown as lower to higher then we use order by sales asc at the end 
-- we dont change inside the over() clause because it is used for the calculation purposes not for ordering the data 
select month, sales, sum(sales) over (order by sales rows between 2 preceding and UNBOUNDED FOLLOWING) from sales.monthly_sales order by sales, month
-- o/p:
month	sales	(No column name)
January	12	696
November	14	696
August	16	696
January	18	670
March	18	684
March	20	654
August	22	636
September	22	618
February	24	576
January	24	598
December	26	530
June	26	554
December	28	480
May	28	506
April	32	454
January	32	426
November	36	398
December	38	366
July	38	334
August	40	298
May	42	260
May	44	222
August	48	182
October	48	140

-- it will do like  last row(current row) + last second row + last third row + .......+ first row 
-- now we are in last second row(current row) so it will do last row + last second row(current) + last third + last fourth + .........+ first row
-- now we are in last third row(current row) so it will do last row + last second row + last third(current) + last fourth + .........+ first row
-- now we are in last fourth row(current row) so it will do last second row + last third + last fourth(current) + .........+ first row
-- now we are in the first row (current row ) so it will take the first row(current) + second row + third row 

 
-- ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING    (sql do reverse calculation)
-- it means current row goto all the rows  
select month, sales, sum(sales) over (order by sales rows between current row and unbounded following) from sales.monthly_sales
-- o/p:
month	sales	(No column name)
October	48	48
August	48	96
May	44	140
May	42	182
August	40	222
July	38	260
December	38	298
November	36	334
January	32	366
April	32	398
December	28	426
May	28	454
December	26	480
June	26	506
February	24	530
January	24	554
September	22	576
August	22	598
March	20	618
January	18	636
March	18	654
August	16	670
November	14	684
January	12	696

-- it do the calculation in reverse and display the data in reverse so to get it properly displayed we use order by at the end
select month, sales, sum(sales) over (order by sales rows between current row and unbounded following) from sales.monthly_sales order by sales
-- o/p:
month	sales	(No column name)
January	12	696
November	14	684
August	16	670
January	18	636
March	18	654
March	20	618
September	22	576
August	22	598
February	24	530
January	24	554
December	26	480
June	26	506
December	28	426
May	28	454
January	32	366
April	32	398
November	36	334
July	38	260
December	38	298
August	40	222
May	42	182
May	44	140
October	48	48
August	48	96

select * from sales.monthly_sales


-- ROWS BETWEEN CURRENT ROW AND THE 2 FOLLOWING 
-- it means take current row and take 2 rows after current row 
select month,sales, sum(sales) over (order by sales rows between current row and 2 following) from sales.monthly_sales
-- o/p:
month	sales	(No column name)
January	12	42
November	14	48
August	16	52
January	18	56
March	18	60
March	20	64
August	22	68
September	22	70
February	24	74
January	24	76
June	26	80
December	26	82
December	28	88
May	28	92
January	32	100
April	32	106
November	36	112
July	38	116
December	38	120
August	40	126
May	42	134
May	44	140
October	48	96
August	48	48

-- it calculates forward does not do the reverse calculation
-- so now we are in first row (current row) + second row + third row
-- now are in second row (current row) it will take second (current) + third + fourth 
-- last row (current row) since we are in last row it does not have any further rows to calculate it show the same value 



-- ROWS BETWEEN CURRENT ROW AND CURRENT ROW
-- it is of no use because it will give the same values that sales have since we are doing the current row itself 
-- so it did not change any value so no use of it
select month,sales, sum(sales) over (order by sales rows between current row and current row) from sales.monthly_sales
-- o/p:
month	sales	(No column name)
January	12	12
November	14	14
August	16	16
January	18	18
March	18	18
March	20	20
August	22	22
September	22	22
February	24	24
January	24	24
June	26	26
December	26	26
December	28	28
May	28	28
January	32	32
April	32	32
November	36	36
July	38	38
December	38	38
August	40	40
May	42	42
May	44	44
October	48	48
August	48	48



-- WINDOW FUNCTIONS 4 RULES 
-- FIRST RULE:  
-- window functions only used in the select and order by we cannot use with other clauses like group by or where clause or any other 
-- we can use like this 
-- ex: select month,sales, sum(sales) over (partition by month) from sales.monthly_sales order by sum(sales) over (partition by month)


-- SECOND RULE: 
-- we cannot do nesting in window functions is not allowed 
-- we cannot add another window func in one window func 
-- ex: select month,sales, sum(sum(sales) over (partition by month)) over (partition by month) from sales.monthly_sales


-- THIRD RULE: 
-- sql window functions execute after where clause, so first sql do filtering and next it apply window functions

-- Q. find the total sales for each orderstatus only for two products 101 and 102
select * from sales.orders

select orderid,productid, orderstatus, sum(sales) over(partition by orderstatus) from sales.orders where productid = 101 or productid = 102 
-- o/p:
orderid	productid	orderstatus	(No column name)
3	       101	     Delivered	       60
7	       102	     Delivered	       60
1	       101	     Delivered	       60
2	       102	     Shipped	       185
8	       101	     Shipped	       185
9	       101	     Shipped	       185
10	       102	     Shipped	       185



-- FOURTH RULE: 
-- window functions can be used with the group by also, but only when we use the same columns in group by and window functions 
-- so here we use the same column name inside the over clause also so which means sum(sales) we used for group by 
-- same we use this inside the over() clause
-- not only the sum(sales) column we can use the other columns also which we are using for the group by like customerid also can be used inside the over() clause

-- Q. rank the customers based their total sales 
select customerid, sum(sales) as total_sales, rank() over(order by sum(sales)) from sales.orders group by customerid
-- o/p:
customerid	total_sales	(No column name)
2	            55	            1
4	            90	            2
1	            110         	3
3	            125         	4




-- WINDOW AGGREGATE FUNCTIONS
-- they are sum(), count(), avg(), min(), max()
-- so when we do use this functions it will give the result in one row 
-- count() only accepts all the datatypes remaining accepts only numeric values
-- so window definition over() can be have empty like the partition by, order by, frame clause can be optional for aggregate functions only

-- COUNT()
-- it returns the number of rows within a window like how many rows we have within the window even if we have duplicates also it will count as seperate  
-- and it is mainly used for data quality check that means we can easily know whether the table contains any duplicate values or not 
-- we can use the count() in two ways
-- count(*)        
-- so it will count all the rows including if any column have the null values also it will count that as one row because the other column have the values it just count how many rows are there 
-- count(column)
-- if we use the column then it ignores the null values and count the rows how many we have 
-- 


-- Q. find the total number of orders we have for each product 
-- here we use the group by because it is a simple calculation and we dont want other things or to maintain level of details
select productid, count(sales) as total_orders from sales.orders group by productid
-- o/p:
productid	total_orders
101	            4
102	            3
104	            2
105	            1


-- but if we use window func it gives each productid seperate row which makes no sense according to the question because it gives level of details which we dont want according to the question 
select productid, count(sales) over(partition by productid) from sales.orders
-- o/p:
productid	(No column name)
101	                4
101	                4
101	                4
101	                4
102	                3
102	                3
102	                3
104	                2
104	                2
105	                1

select * from sales.orders


-- Q. find the total number of orders
select count(*) as total_orders from sales.orders 
-- o/p:
total_orders
10                  -- it includes the null values 

select count(sales) as total_orders from sales.orders
-- o/p:
total_orders
10                  -- it does not include null values


-- Q. find the total number of orders additionally provide details orderid, orderdate 
select orderid, orderdate, count(*) over() as total_orders from sales.orders 
-- o/p:
orderid	orderdate	total_orders
1	    2025-01-01	        10
2	    2025-01-05	        10
3	    2025-01-10	        10
4	    2025-01-20	        10
5	    2025-02-01	        10
6	    2025-02-05	        10
7	    2025-02-15	        10
8	    2025-02-18	        10
9	    2025-03-10	        10
10	    2025-03-15	        10

-- Q. find the total number of orders, total number of orders for each customer additionally provide details orderid, orderdate 
select customerid, orderid, orderdate,count(*) over() as total_orders, count(*) over(partition by customerid) as orderbycustomers from sales.orders
-- o/p:
customerid	orderid	orderdate	total_orders	orderbycustomers
1	            3	2025-01-10	    10	                3
1	            4	2025-01-20	    10	                3
1	            7	2025-02-15	    10	                3
2	            1	2025-01-01	    10	                3
2	            5	2025-02-01	    10	                3
2	            9	2025-03-10	    10	                3
3	            10	2025-03-15  	10              	3
3	            6	2025-02-05	    10	                3
3	            2	2025-01-05	    10	                3
4	            8	2025-02-18	    10	                1

-- Q. find the total number of customers additionally provide all the customer details 
select *, count(*) over() as total_customers from sales.customers
-- o/p:
CustomerID	FirstName	LastName	Country	    Score	total_customers
1	        Jossef	    Goldberg	Germany	    350	            5
2	        Kevin	    Brown	    USA	        900	            5
3	        Mary	    NULL	    USA	        750	            5
4	        Mark	    Schwarz	    Germany	    500	            5
5	        Anna	    Adams	    USA	        NULL	        5

-- Q. find the total number of scores for the customers additionally provide all the customer details 
-- here we need to find the rows of a specific column score so when we are dealing with the column
-- while using the count() we need to keep in mind that the column may have the null values 
-- to avoid incorrect insights we need to handle the null values so to get the proper insights we need to use the count(column)
-- it will ignore the null values present in the column so we need to remember that count(column) ignores the null rows and counts other rows
select *,count(*) over() as total_customers, count(score) over() as total_scores from sales.customers
-- o/p:
CustomerID	FirstName	LastName	Country	    Score	total_customers	  total_scores
1	         Jossef	    Goldberg	Germany	    350	            5	          4
2	         Kevin	    Brown	    USA	        900	            5	          4
3	         Mary	    NULL	    USA	        750	            5	          4
4	         Mark	    Schwarz	    Germany	    500	            5	          4
5	         Anna	    Adams	    USA	        NULL            5	          4
-- here the null value row is ignored so we got the result 4 rows instead of 5 


-- DATA QUALITY CHECK 
-- we can use the count() to know whether it has any duplicates values or not 

-- Q. check whether the table orders contain any duplicate values 
-- since we need to find the duplicates present or not we simply do the count() for the primary key in the table 
-- since the primary does not have any duplicates but in some cases we take the data from multiple sources so in that 
-- they may have the duplicate values so to check that we use the count(column) for primary key 
select orderid,count(orderid) over(partition by orderid) as duplicate_values from sales.orders     -- here the orders table dont have any duplicate values 
-- o/p:
orderid	duplicate_values
1	            1
2	            1
3	            1
4	            1
5	            1
6	            1
7	            1
8	            1
9	            1
10	            1
-- so here the value is 1 which means we dont have any duplicate values if the value is >1 means that orderid have duplicates

-- so for table sales.ordersarchive lets check does it have or not
select orderid,count(orderid) over(partition by orderid) as duplicate_values from sales.ordersarchive     
-- o/p:
orderid	duplicate_values
1	            1
2	            1
3	            1
4	            2
4	            2
5	            1
6	            3
6	            3
6	            3
7	            1
-- here the value is greater than 1 and some of them have value 1 so to get only the duplicate values we use the sub query 

select * from (select orderid,count(orderid) over(partition by orderid) as duplicate_values from sales.ordersarchive) as t where duplicate_values > 1     
-- o/p:
orderid	duplicate_values
4	        2
4	        2
6	        3
6	        3
6	        3
-- now we got the duplicate values 




-- SUM()
-- it is used to do the addition of all the values within a window and it ignores the null values and only accepts the numeric values


-- Q. find the total sales across all orders, find total sales for each product, additionally provide details such as orderid, orderdate
select orderid, orderdate,productid,sales, sum(sales) over() as total_sales, sum(sales) over(partition by productid) as total_sales_by_product from sales.orders
-- o/p:
orderid	orderdate	productid	sales	total_sales	total_sales_by_product
1	2025-01-01	101	10	380	140
3	2025-01-10	101	20	380	140
8	2025-02-18	101	90	380	140
9	2025-03-10	101	20	380	140
10	2025-03-15	102	60	380	105
2	2025-01-05	102	15	380	105
7	2025-02-15	102	30	380	105
5	2025-02-01	104	25	380	75
6	2025-02-05	104	50	380	75
4	2025-01-20	105	60	380	60

-- Q. find the percentage contribution of each product sales to the total sales 
-- percentage contribution = product sales / total sales * 100
select orderid, orderdate, sales, sum(sales) over() as total_sales, sales / sum(sales) over() * 100 as percentage from sales.orders
-- o/p:
orderid	orderdate	sales	total_sales	percentage
1	2025-01-01	10	380	0
2	2025-01-05	15	380	0
3	2025-01-10	20	380	0
4	2025-01-20	60	380	0
5	2025-02-01	25	380	0
6	2025-02-05	50	380	0
7	2025-02-15	30	380	0
8	2025-02-18	90	380	0
9	2025-03-10	20	380	0
10	2025-03-15	60	380	0

-- we got "zero" in the value because the data type is integer so to get the float or decimal values we change the data type using cast() and to get two decimals we use round to avoid more decimals
select orderid, orderdate, sales, sum(sales) over() as total_sales, round(cast(sales as float) / sum(sales) over() * 100, 2) as percentage from sales.orders
-- o/p:
orderid	orderdate	sales	total_sales	percentage
1	2025-01-01	10	380	2.63
2	2025-01-05	15	380	3.95
3	2025-01-10	20	380	5.26
4	2025-01-20	60	380	15.79
5	2025-02-01	25	380	6.58
6	2025-02-05	50	380	13.16
7	2025-02-15	30	380	7.89
8	2025-02-18	90	380	23.68
9	2025-03-10	20	380	5.26
10	2025-03-15	60	380	15.79



-- AVG()
-- it is used to perform avg within a window 
-- so while working with the null values first we need to change the null value to zero to avoid incorrect insights
-- because if null values are avoided then the avg will be incorrect 
-- so we change the null to zero to do this we use the coalesce() 

-- Q. find the avg sales across all the orders, 
select avg(sales) as avg_sales from sales.orders

-- Q. find the avg sales for each product additionally provide details such as orderid, orderdate 
select orderid, orderdate, productid,sales, avg(sales) over(partition by productid) as avg_sales_by_product from sales.orders
-- o/p:
orderid	orderdate	productid	sales	avg_sales_by_product
1	2025-01-01	101	10	35
3	2025-01-10	101	20	35
8	2025-02-18	101	90	35
9	2025-03-10	101	20	35
10	2025-03-15	102	60	35
2	2025-01-05	102	15	35
7	2025-02-15	102	30	35
5	2025-02-01	104	25	37
6	2025-02-05	104	50	37
4	2025-01-20	105	60	60


-- Q. find avg scores of customers additionally provide details such as customerid, lastname 
select customerid, lastname, score,avg(score) over() as scorewithnull, avg(coalesce(score, 0)) over() as scorewithoutnull from sales.customers
-- o/p:
customerid	lastname	score	scorewithnull	scorewithoutnull
1	Goldberg	350	625	500
2	Brown	900	625	500
3	NULL	750	625	500
4	Schwarz	500	625	500
5	Adams	NULL	625	500

-- Q. find all orders where sales are higher than avg sales across all the orders 
select * from (
select orderid, sales, avg(sales) over() as avg_sales from sales.orders 
) as t where sales > avg_sales
-- o/p:
orderid	sales	avg_sales
4	60	38
6	50	38
8	90	38
10	60	38


-- MIN() AND MAX()
-- MIN() returns the lowest value within a window
-- MAX() returns the highest value within a window 
-- MIN AND MAX() ignores the null values 
-- so to handle null values we replace it with zero but 
-- for MAX() we dont get any issues because zero is not maximum value
-- but for MIN() we get the 0 will be the minimum value which we changed the null to zero 

-- Q. find the highest and the lowest sales across all the orders additionally provide details such as orderid, orderdate
select orderid, orderdate,sales, max(sales) over() as max_sales, min(sales) over() as min_sales from sales.orders
-- o/p:
orderid	orderdate	sales	max_sales	min_sales
1	2025-01-01	10	90	10
2	2025-01-05	15	90	10
3	2025-01-10	20	90	10
4	2025-01-20	60	90	10
5	2025-02-01	25	90	10
6	2025-02-05	50	90	10
7	2025-02-15	30	90	10
8	2025-02-18	90	90	10
9	2025-03-10	20	90	10
10	2025-03-15	60	90	10

-- Q. find the highest and the lowest sales across all the orders for each product additionally provide details such as orderid, orderdate
select orderid, orderdate,productid, sales, max(sales) over(partition by productid) as max_sales, min(sales) over(partition by productid) as min_sales from sales.orders
-- o/p:
orderid	orderdate	productid	sales	max_sales	min_sales
1	2025-01-01	101	10	90	10
3	2025-01-10	101	20	90	10
8	2025-02-18	101	90	90	10
9	2025-03-10	101	20	90	10
10	2025-03-15	102	60	60	15
2	2025-01-05	102	15	60	15
7	2025-02-15	102	30	60	15
5	2025-02-01	104	25	50	25
6	2025-02-05	104	50	50	25
4	2025-01-20	105	60	60	60

-- Q. show the employee who have the highest salaries
select * from sales.employees

select * from (select *, max(salary) over() as max_salary from sales.employees) as t where salary = max_salary
-- o/p:
EmployeeID	FirstName	LastName	Department	BirthDate	Gender	Salary	ManagerID	max_salary
4	Michael	Ray	Sales	1977-02-10	M	90000	2	90000


-- Q. calculate the deviation of the each sale from both min and max sales amounts from orders 
-- deviation means the sales - min(sales) and max(sales) - sales 

select orderid, orderdate, sales, min(sales) over() as min_sales, max(sales) over() as max_sales,
sales - min(sales) over() as deviationMin, max(sales) over() - sales as deviationMax
from sales.orders 
-- o/p:
orderid	orderdate	sales	min_sales	max_sales	deviationMin	deviationMax
1	2025-01-01	10	10	90	0	80
2	2025-01-05	15	10	90	5	75
3	2025-01-10	20	10	90	10	70
4	2025-01-20	60	10	90	50	30
5	2025-02-01	25	10	90	15	65
6	2025-02-05	50	10	90	40	40
7	2025-02-15	30	10	90	20	60
8	2025-02-18	90	10	90	80	0
9	2025-03-10	20	10	90	10	70
10	2025-03-15	60	10	90	50	30


-- Q. calculate the moving average sales for each product over time 
select orderid, orderdate,productid, sales, avg(sales) over (partition by productid order by orderdate) as mvgtime from sales.orders
-- o/p:
orderid	orderdate	productid	sales	mvgtime
1	2025-01-01	101	10	10
3	2025-01-10	101	20	15
8	2025-02-18	101	90	40
9	2025-03-10	101	20	35
2	2025-01-05	102	15	15
7	2025-02-15	102	30	22
10	2025-03-15	102	60	35
5	2025-02-01	104	25	25
6	2025-02-05	104	50	37
4	2025-01-20	105	60	60

-- Q. calculate the moving average sales for each product over time, including only next order 
-- which means each window will have two rows current row and the next row
select orderid, orderdate,productid, sales, avg(sales) over (partition by productid order by orderdate rows between current row and 1 following) as mvgtime from sales.orders
-- o/p;
orderid	orderdate	productid	sales	mvgtime
1	2025-01-01	101	10	15
3	2025-01-10	101	20	55
8	2025-02-18	101	90	55
9	2025-03-10	101	20	20
2	2025-01-05	102	15	22
7	2025-02-15	102	30	45
10	2025-03-15	102	60	60
5	2025-02-01	104	25	37
6	2025-02-05	104	50	50
4	2025-01-20	105	60	60




-- RANKING WINDOW FUNCTIONS
-- the ORDER BY is MANDATORY when we are working with ranking functions 
-- the FRAME CLAUSE is NOT ALLOWED in the ranking functions 

-- to rank the data we first sort the data and we have two types of ranking 
-- 1. integer based ranking                -- 2. percentage based ranking 
-- rank()                                   -- cume_dist()
-- dense_rank()                             -- percent_rank()
-- row_number()
-- ntile()


-- 1. integer based ranking is used when we wank to find like the top 3 ranks or the integer value results
-- ROW_NUMBER()
-- assigns a unique number to each row 
-- it doesn't handle ties means if we have the same value that means the duplicate then it cannot rank the same number for that values instead it gives seperate rank 
-- it does not have gaps like skipping the ranks it gives continuous ranks 

-- Q. find the orders based on their sales from highest to lowest 
select orderid, sales, row_number() over (order by sales desc) from sales.orders
-- o/p:
orderid	sales	(No column name)
8	90	1
4	60	2
10	60	3
6	50	4
7	30	5
5	25	6
9	20	7
3	20	8
2	15	9
1	10	10


-- RANK()
-- assign a rank to each row
-- it handle the ties means if the two rows or more having the same value then it assign the same rank to those rows 
-- it assigns with gaps that means it skips the rank number if we have the same values
-- like the first row and second row have the same value they both will rank as 1 
-- now the third row is different value and now the rank number will be 3 because the second row is assigned with 1 value
-- so the rank 2 is skipped so if have same values it takes the same rank and the next rank will be the number of same rows + current rank 
-- ex: 
-- id   sales   rank 
-- 8	90	    1
-- 4	90	    1
-- 10	60	    2
-- number of same rows excluding the current rank = 1 and current rank = 1   so return 1 + 1 = 2 will be the third row 

-- Q. find the orders based on their sales from highest to lowest 
select orderid, sales, rank() over (order by sales desc) from sales.orders
-- o/p:
orderid	sales	(No column name)
8	90	1
4	60	2
10	60	2
6	50	4
7	30	5
5	25	6
9	20	7
3	20	7
2	15	9
1	10	10


-- DENSE_RANK()
-- it assign rank for each row 
-- it handle same values and assign them same rank 
-- it assigns the rank without gaps which means if we have the same values then the next row will be the next rank instead of same rank
-- it donot skip the ranks it go in the sequence wise 

-- Q. find the orders based on their sales from highest to lowest 
select orderid, sales, dense_rank() over (order by sales desc) from sales.orders
-- o/p:
orderid	sales	(No column name)
8	90	1
4	60	2
10	60	2
6	50	3
7	30	4
5	25	5
9	20	6
3	20	6
2	15	7
1	10	8


-- Q. select the top highest sales for each product
select * from (
select orderid,productid, sales, row_number() over(partition by productid order by sales desc) as top_rank 
from sales.orders) as t where top_rank = 1 
-- o/p:
orderid	productid	sales	top_rank
8	101	90	1
10	102	60	1
6	104	50	1
4	105	60	1


-- Q. find the lowest two customers based on their total sales 
select * from (
select customerid, sum(sales) as total_sales, row_number() over(order by sum(sales)) as ranked_sales
from sales.orders group by customerid) as t where ranked_sales <= 2



-- Q. assign unique ids to the rows of the tables orders Archive table
-- lets say we have a table that dont have any primary key and to make the table to use we create a column that has unique values 
-- so in this case we can use the row_number() 
select * from sales.OrdersArchive
-- her the orderid have the duplicate values so we use the row_number() to have a unique values column
select row_number() over(order by orderid) as unq_id, * from sales.OrdersArchive
-- o/p:
unq_id	OrderID	ProductID	CustomerID	SalesPersonID	OrderDate	ShipDate	OrderStatus	ShipAddress	        BillAddress	        Quantity	Sales	CreationTime
2	        2	    102	        3	            3	    2024-04-05	2024-04-10	Shipped	    456 Elm St	        789 Billing St	        1	      15	2024-04-05 23:22:04.0000000
3	        3	    101	        1	            4	    2024-04-10	2024-04-25	Shipped	    789 Maple St	    789 Maple St	        2	      20	2024-04-10 18:24:08.0000000
4	        4	    105	        1	            3	    2024-04-20	2024-04-25	Shipped	    987 Victory Lane		                    2	      60	2024-04-20 05:50:33.0000000
5	        4	    105	        1	            3	    2024-04-20	2024-04-25	Delivered	987 Victory Lane		                    2	      60	2024-04-20 14:50:33.0000000
6	        5	    104	        2	            5	    2024-05-01	2024-05-05	Shipped	    345 Oak St	        678 Pine St	            1	      25	2024-05-01 14:02:41.0000000
7	        6	    104	        3	            5	    2024-05-05	2024-05-10	Delivered	543 Belmont Rd.	    NULL	                2	      50	2024-05-06 15:34:57.0000000
8	        6	    104	        3	            5	    2024-05-05	2024-05-10	Delivered	543 Belmont Rd.	    3768 Door Way	        2	      50	2024-05-07 13:22:05.0000000
1	        1	    101	        2	            3	    2024-04-01	2024-04-05	Shipped	    123 Main St	        456 Billing St	        1	      10	2024-04-01 12:34:56.0000000
9	        6	    101	        3	            5	    2024-05-05	2024-05-10	Delivered	543 Belmont Rd.	    3768 Door Way	        2	      50	2024-05-12 20:36:55.0000000
10	        7	    102	        3	            5	    2024-06-15	2024-06-20	Shipped	    111 Main St	        222 Billing St	        0	      60	2024-06-16 23:25:15.0000000


-- we can also use row_number for identifying the duplicate values
-- Q. identify duplicate rows in the orderarchive table and return a clean result without duplicates
select * from (
select row_number() over(partition by orderid order by creationtime desc) as unq_data, * 
from sales.OrdersArchive) as t where unq_data = 1
-- o/p:
unq_data	OrderID	ProductID	CustomerID	SalesPersonID	OrderDate	ShipDate	OrderStatus	ShipAddress	BillAddress	Quantity	Sales	CreationTime
1	1	101	2	3	2024-04-01	2024-04-05	Shipped	123 Main St	456 Billing St	1	10	2024-04-01 12:34:56.0000000
1	2	102	3	3	2024-04-05	2024-04-10	Shipped	456 Elm St	789 Billing St	1	15	2024-04-05 23:22:04.0000000
1	3	101	1	4	2024-04-10	2024-04-25	Shipped	789 Maple St	789 Maple St	2	20	2024-04-10 18:24:08.0000000
1	4	105	1	3	2024-04-20	2024-04-25	Delivered	987 Victory Lane		2	60	2024-04-20 14:50:33.0000000
1	5	104	2	5	2024-05-01	2024-05-05	Shipped	345 Oak St	678 Pine St	1	25	2024-05-01 14:02:41.0000000
1	6	101	3	5	2024-05-05	2024-05-10	Delivered	543 Belmont Rd.	3768 Door Way	2	50	2024-05-12 20:36:55.0000000
1	7	102	3	5	2024-06-15	2024-06-20	Shipped	111 Main St	222 Billing St	0	60	2024-06-16 23:25:15.0000000


-- if we want to find those duplicate values then we use > 1 it will show all the duplicate values
select * from (
select row_number() over(partition by orderid order by creationtime desc) as unq_data, * 
from sales.OrdersArchive) as t where unq_data > 1
-- o/p:
unq_data	OrderID	ProductID	CustomerID	SalesPersonID	OrderDate	ShipDate	OrderStatus	ShipAddress	BillAddress	Quantity	Sales	CreationTime
2	4	105	1	3	2024-04-20	2024-04-25	Shipped	987 Victory Lane		2	60	2024-04-20 05:50:33.0000000
2	6	104	3	5	2024-05-05	2024-05-10	Delivered	543 Belmont Rd.	3768 Door Way	2	50	2024-05-07 13:22:05.0000000
3	6	104	3	5	2024-05-05	2024-05-10	Delivered	543 Belmont Rd.	NULL	2	50	2024-05-06 15:34:57.0000000


-- NTILE()
-- it is used to divide the rows into buckets and also it accepts numeric value which decides how many buckets we want
-- buckets = no.of rows/no.of buckets 
-- each bucket needs to have atleast 2 rows to call it as one bucket
-- ex: we want to divide the rows into two buckets then we can use ntile like this NTILE(2) here 2 says the no.of buckets we want
-- so if we have the even no.of rows in the table we can easily calculate but
-- when we have the odd no.of rows in the table sql calculates like take the large no.of rows as one bucket and other will be another bucket 
-- ex: we have 5 rows in a table we do like ntile(2) then 
-- no.of rows = 5 and no.of buckets = 2 we want so 5/2 = 2.5 so now the sql takes 3 rows as one bucket and 2 rows as another bucket
select sales,ntile(2) over(order by sales) as two_buckets from sales.orders 
-- o/p:
sales	two_buckets
10	1
15	1
20	1
20	1
25	1
30	2
50	2
60	2
60	2
90	2

select sales,ntile(2) over(order by sales) as two_buckets,ntile(3) over(order by sales) as three_buckets  from sales.orders 
-- here no.of rows = 10 and no.of buckets = 3   so 10/3 = 3.3 so first bucket will have 4 rows and remainig will have 3 rows each
-- o/p:
sales	two_buckets	three_buckets
10	1	1
15	1	1
20	1	1
20	1	1
25	1	2
30	2	2
50	2	2
60	2	3
60	2	3
90	2	3


select sales,ntile(2) over(order by sales) as two_buckets,ntile(3) over(order by sales) as three_buckets, ntile(4) over(order by sales) as four_buckets  from sales.orders 
-- here no.of rows = 10 and no.of buckets = 3   so 10/4 = 2.5 
-- so first, second buckets will have 3 rows and third and fourth buckets will have 2 rows 
-- it did not taken the 3 rows for third bucket because the fourth bucket will have only one row left and we dont call it as a bucket if we have < 2 rows so thats why the third bucket taken 2 rows and fourth bucket have 2 rows 
-- o/p:
sales	two_buckets	three_buckets	four_buckets
10	1	1	1
15	1	1	1
20	1	1	1
20	1	1	2
25	1	2	2
30	2	2	2
50	2	2	3
60	2	3	3
60	2	3	4
90	2	3	4

-- why do we use ntile() what is the use case ?
-- 1. data segmetation                  2. data equalizing 

-- 1. data segmentation 
-- we divide the values in buckets to create the categories for the table like high, medium, low sales 

-- Q. segment all the orders in 3 categories: high, medium, low
select *, case when buckets = 1 then 'High'
when buckets = 2 then 'Medium'
when buckets = 3 then 'Low'
end as categories
from (
select orderid, customerid, sales, ntile(3) over(order by sales) as buckets from sales.orders) as t
-- o/p:
orderid	customerid	sales	buckets	categories
1	2	10	1	High
2	3	15	1	High
3	1	20	1	High
9	2	20	1	High
5	2	25	2	Medium
7	1	30	2	Medium
6	3	50	2	Medium
4	1	60	3	Low
10	3	60	3	Low
8	4	90	3	Low


-- 2. data equalizing
-- we can use it in while transfering the data from one database to another if we transfer the entire data at once then
-- it  may break or fail and it takes so much time to transfer instead we divide the data into small groups and we transfer it 
-- and after transfer we can use the union to combine the data 
select orderid, productid, sales, ntile(3) over(order by sales) from sales.orders 
-- o/p:
orderid	productid	sales	(No column name)
1	101	10	1
2	102	15	1
3	101	20	1
9	101	20	1
5	104	25	2
7	102	30	2
6	104	50	2
4	105	60	3
10	102	60	3
8	101	90	3



-- PERCENTAGE BASED RANKING FUNCTIONS
-- 1. CUME_DIST()                2. PERCENT_RANK()

-- 1. CUME_DIST() - cumulative_distribution()
-- formula = current row position number/ no.of rows
-- ex: we are in the first row and the table have 5 rows total 
-- so the calculation will be current row position number so since we start from first row so the value = 1
-- no.of rows = 5 
-- so the calculation = 1/5 = 0.2
-- so now we are in the second row so calculation = 2/5 =>  0.4
-- and if we have the same values in the rows then it will take the below row of current row that means
-- lets say we have 30 in third row and 30 in the fourth row also so 
-- now we are in the 3rd row since we have the same values in the third and fourth sql takes the position number value to be 4 instead of 3 
-- so for third row the calculation = 4/5 => 0.8 
-- and for fourth it checks if the value is duplicated in next row then it takes the next value if not it will take that position number 
-- so it takes the last occurrence of the same value 



-- PERCENT_RANK()
-- formula = current row position number - 1/ no.of rows - 1
-- it is same as cume_dist() but it will take the first occurrence of the same value 
-- so we are in first row 1 - 1 / 5 - 1 =  0/4   =>  0
-- now we are in second row so the second row so 2-1 / 5-1 = 1/4 => 0.25
-- now for third and fourth have same value so now it will take first occurrence position number 
-- so we get 3 - 1/ 5-1 = 2/4 = 0.5   and for fourth we get same   3-1/5-1 = 2/4 = 0.25 because it takes first occurrence 


-- find the products that fall within highest 40% of prices
select * from (
    select productid, price, cume_dist() over(order by price desc) as dist_rank 
    from sales.products
    )as t 
where dist_rank <= 0.4

-- we can format it to percentage 
select *, concat(dist_rank * 100, '%')
from (
    select productid, price, cume_dist() over(order by price desc) as dist_rank 
    from sales.products
    )as t 
where dist_rank <= 0.4



-- VALUE WINDOW FUNCTIONS
-- these are used to access values from another rows from the current row in a window without aggregating or reducing the rows 
-- lag(expr, offset, default)  
-- lead(expr, offset, default)
-- first_value(expr)
-- last_value(expr)
-- nth_value(expr)
-- order by is mandatory for value functions
-- partition by is optional 
-- frame clause is not allowed for lead() and lag() functions
-- frame clause is optional for first_value()
-- frame clause is recommended to use for last_value()


-- LAG()
-- returns the value from the previous row within a window
-- ex: 
-- | month    | sales | prev_sales |
-- | -------- | ----- | ---------- |
-- | January  | 12    | NULL       |
-- | February | 24    | 12         |
-- | March    | 18    | 24         |
-- | April    | 32    | 18         |
-- LAG(columnname, offset, default)
-- columnname is required we cannot leave empty
-- offset is optional and it means we tell sql, how many rows it needs to jump like if we set offset = 2 then it takes every second row and 
-- if we dont set any offset then by default it will jump one row that means continuos without skipping any row
-- default is optional and it means if we dont set any value then it will show the NULL value
-- if we set default = 20 or no_value or any datatype then that will be shown in that row  
-- select lag(sales) over (order by month) from table 
-- so it will take the value from the previous row if we dont have the previous row then by default it returns the NULL value because we did not mentioned the default value

-- ex: if we mention the the offset and default value then we get
-- select lag(sales, 2, 0) over(order by month) from table
-- | month    | sales | prev_sales |
-- | -------- | ----- | ---------- |
-- | January  | 12    | 0          |
-- | February | 24    | 0          |
-- | March    | 18    | 12         |
-- | April    | 32    | 24         |
-- here it will take jump to two rows and take that value, so for first row we dont have previous rows so by default it will get null value but since we mentioned the default value = 0 so it will return this 
-- so for the third row we have a value which is the first row so it return the 12 value 



-- LEAD() 
-- returns the value from the next row within a window
-- ex: 
-- | month    | sales | prev_sales |
-- | -------- | ----- | ---------- |
-- | January  | 12    | NULL       |
-- | February | 24    | 12         |
-- | March    | 18    | 24         |
-- | April    | 32    | 18         |
-- LAG(columnname, offset, default)
-- columnname is required we cannot leave empty
-- offset is optional and it means we tell sql, how many rows it needs to jump like if we set offset = 2 then it takes every second row and 
-- if we dont set any offset then by default it will jump one row that means continuos without skipping any row
-- default is optional and it means if we dont set any value then it will show the NULL value
-- if we set default = 20 or no_value or any datatype then that will be shown in that row  
-- select lead(sales) over (order by month) from table 
-- so it will take the value from the next row if we dont have the previous row then by default it returns the NULL value because we did not mentioned the default value

-- ex: if we mention the the offset and default value then we get
-- select lead(sales, 2, 0) over(order by month) from table
-- | month    | sales | prev_sales |
-- | -------- | ----- | ---------- |
-- | January  | 12    | 18         |
-- | February | 24    | 32         |
-- | March    | 18    | 0          |
-- | April    | 32    | 0          | 
-- here it will take jump to two rows and take that value, so for first row we dont have next rows so by default it will get null value but since we mentioned the default value = 0 so it will return this 
-- so for the third row we dont have next rows so it will take 0 value because we mentioned the default value = 0
-- and for last row also same we dont any next rows so it return 0 value



-- Q. analyse month over month performance by finding the percentage change in the sales between current and previous month

-- means
-- year over year = analysing the business growth increased or declined performance over time
-- month over month = analysing the short term trends and patterns 

select * from sales.orders

select month(orderdate) as month, sum(sales) - lag(sum(sales)) over(order by month(orderdate)) as previous_sales from sales.orders group by month(orderdate)



select *, total_current_month_sales - total_prev_month_sales as mom_sales,
concat(round(cast((total_current_month_sales - total_prev_month_sales) as float)/total_prev_month_sales * 100, 1), '%') as mom_sales_in_percentage
from 
(
select month(orderdate) as month_name, 
sum(sales) as total_current_month_sales, 
lag(sum(sales)) over(order by month(orderdate)) as total_prev_month_sales 
from sales.orders group by month(orderdate)
) t 



-- Q. in order to analyse the customers loyalty, rank customers based on their average days between their orders 
select day(orderdate), sum(sales) as current_day_sales, sum(sales) from sales.orders group by day(orderdate)


-- customer retention analysis 
-- it measures the customer behaviour and loyalty of the customers to the business and helps in building strong relationship with customers

-- Q. find the customers loyalty by ranking the customers and finding the avg no.of orders made in between the orders 
-- to analyse the customer loyalty we need to rank the customers and find out the average days between orders

select * from sales.orders


select 
customerid, 
avg(no_of_days_next_order) avg_orders, 
rank() over(order by avg(no_of_days_next_order)) as rank_avg_orders
from 
(
select 
customerid, 
orderdate as current_order,  
lead(orderdate) over(partition by customerid order by orderdate) as next_order,
datediff(day, orderdate, lead(orderdate) over(partition by customerid order by orderdate)) as no_of_days_next_order
from sales.orders
) t
group by customerid   




-- FIRST_VALUE() and LAST_VALUE()
-- FIRST_VALUE():  access value from the first row within a window
-- SECOND_VALUE(): access value from the last row within a window 
-- ex:  first_value(sales) over (order by sales)
-- | month    | sales | FIRST_VALUE() |
-- | -------- | ----- | ---------- |
-- | January  | 12    | 12         |        --  this is the first value of the table 
-- | February | 24    | 12         |
-- | March    | 18    | 12         |
-- | April    | 32    | 12         |

-- it gives the first_value for all the rows so by default it uses the frame clause to calculate 
-- default frame clause is  rows between unbounded preceding and current_row

-- ex: last_value(sales) over(order by sales)
-- | month    | sales | LAST_VALUE() |
-- | -------- | ----- | ---------- |
-- | January  | 12    | 12         |
-- | February | 24    | 24         |
-- | March    | 18    | 18         |
-- | April    | 32    | 32         |    -- we got wrong results because we need to get the last value for all the rows 

-- when we are working with the last_value by default it takes the frame clause so the result will be wrong
-- so this last_value() func does not do the proper calculation with the default frame cluase
-- we need to specify the frame clause to get the correct results 
-- default frame clause is  rows between unbounded preceding and current_row but 
-- we are using last_value so the frame clause will be "rows between current row and unbounded following "
-- here we are doing reverse to get the correct results 

-- ex: last_value(sales) over(order by sales rows between unbounded following and current row)
-- | month    | sales | LAST_VALUE() |
-- | -------- | ----- | ---------- |
-- | January  | 12    | 32         |
-- | February | 24    | 32         |
-- | March    | 18    | 32         |
-- | April    | 32    | 32         |        --  this is the last value of the table 

-- now we get the correct results last_value to all the rows from the table 
-- or we can use the sort them in desc order it will also give the last_value result
-- first_value(sales) over(order by sales desc)  this will give the same result as last_value(sales) over(order by sales rows between unbounded following and current row)
-- we simple change the order then we get the same result as with frame clause 

-- Q. find the lowest and highest sales for each product 
select productid, sales,
first_value(sales) over(partition by productid order by sales) as lowest_sales,
last_value(sales) over(partition by productid order by sales rows between current row and unbounded following) as highest_sales_using_frame_clause,
first_value(sales) over(partition by productid order by sales desc) as highest_sales_using_desc_order
from sales.orders

-- or we can simply use like this also without first and last value 
select productid, 
min(sales) over(partition by productid) as lowest_sales, 
max(sales) over(partition by productid) as highest_sales 
from sales.orders


-- Q. find the difference between the current sales and the lowest sales for each product 
select productid, sales,
first_value(sales) over(partition by productid order by sales) as lowest_sales,
last_value(sales) over(partition by productid order by sales rows between current row and unbounded following) as highest_sales_using_frame_clause,
first_value(sales) over(partition by productid order by sales desc) as highest_sales_using_desc_order,
sales - first_value(sales) over(partition by productid order by sales) as diff_sales
from sales.orders