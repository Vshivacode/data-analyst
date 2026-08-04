-- CTE (COMMON TABLE EXPRESSION)
-- cte is a temporary named result like a virtuual table that can be used multiple times within a query to simplify and organize the complex queries 
-- so we can use the cte subquery in the main query so many times and also we can also take the data from the database table also when we are using non-correlated subquery 
-- so here we can combine the cte table with the another table outside but we cannot join the outside table with the cte table 
-- the cte query (virtual table) is only available to the main query not for all 
-- it stores the virtual table in the cache memory 


-- DIFFERENCE BETWEEN CTE VS SUBQUERY
--  CTE                                                              --   SUBQUERY
-- so in cte we write the query from top to bottom means         -- but for subquery first we write the subquery 
-- first we write the cte and next we write the subquery            and next we write the main query to use the subquery

-- it can be reusable so we can use it multiple times           -- it executes only once


