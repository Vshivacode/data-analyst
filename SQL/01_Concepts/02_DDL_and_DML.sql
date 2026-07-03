-- DDL (DATA DEFINITION LANGUAGE)
-- these are like creating or managing the structure of the table 
-- so we use create, alter and drop


-- sql task - create a table called persons with columns id, person_name, birth_date and phone
create table persons
(
    id int not null, 
    person_name varchar(255) not null,
    birth_date date,
    phone varchar(15) not null,
    constraint pk_persons primary key (id)        -- its better to use constraint and the name of the constraint so that later if we want to delete the primary key then we can easily able to do without mentioning the name it will take some random name and each server it will be different name so it is difficult to manage 
);

drop table persons




-- alter
-- it is used to manage or edit the table of an existing table without deleting or losing the data inside the table

-- sql task - add a new column email to the table 
alter table persons add email varchar(50)

select * from persons;

-- sql task - remove phone column from table
alter table persons drop column phone


exec sp_help persons -- in mysql we use desc tablename but in sql server we use exec sp_help tablename 


-- changing the data type of the existing column
alter table persons alter column person_name varchar(25) not null


alter table persons add constraint pk_persons primary key (id)


exec sp_rename persons, persons_tb -- alter table persons rename to persons_table



select * from persons_tb



drop table persons_tb



-- DML - Data Manipulation Language 
-- it is used to manage the data in the table
select * from customers

-- inserting single value to a single column 
-- insert - insert into tablename(col1) values (val1)

-- inserting multiple values to multiple columns, so we can insert multiple values by using a comma as a seperator
-- insert - insert into tablename(col1, col2) values (val1, val2), (val1, val2), (val1, val2);

-- inserting all values to all the columns we can do this in two ways 
-- without mentioning the column names but we need to follow exact order that table is created 
-- insert - insert into tablename values (val1, val2)

-- mentioning the column names, with this we can follow the exact order of the mention column names 
-- insert - insert into tablename(col1, col2) values (val1, val2)
-- we cannot do like this 
-- insert - insert into tablename(col2, col3, col1) values (val1, val2)   -- it will fail because we are putting the values to the wrong columns 

insert into customers(id, first_name, score) values (6,'shiva', 200)
-- here if we did not mention the remaining columns then those columns values can be inserted NULL values

-- we can also insert NULL values manually 
insert into customers(id, first_name, score) values (7,'shiva', NULL)


select * from customers

insert into customers values (9, 'chintu', 'india', 200)



create table sample(id int not null primary key identity(1,1), name varchar(25), balance decimal(10,2) default(0.00))


insert into sample values ('shiva', 200), ('hari', 12939)


select * from sample 


-- remove default constraint
alter table sample alter column balance decimal(10,2)


exec sp_help sample 


delete from sample 

drop table sample 



update sample set balance = 0


select * from customers;


update customers set score = 0 where id = 6

insert into customers values (10,'ram', 'india', 839)

update customers set score = 0 where id = 10


update customers set country = 'UK' where id = 10


-- country = null does not work because null is unknown we cannot able to compare with another null value so we use is null it is used to check whether the value is missing 
update customers set country = 'india' where country is null -- we are telling sql to check whether this row have any missing value





delete from customers where score = 0 


select * from customers where id > 5

delete from customers where id > 5 


select * from customers 
