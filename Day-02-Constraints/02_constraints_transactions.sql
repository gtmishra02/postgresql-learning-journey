-- integrity constraints 
1.) not null
2.) unique
3.) check 
4.) default  
5.) primary key  
6.) foreign key  

create table if not exists de_gds.employees_with_constraints
(
	id INT,
	name VARCHAR(50) not null,
	salary int,
	hiring_date date default '2025-01-01',
	unique (id),
	check (salary > 1000)
);

insert into de_gds.employees_with_constraints values (1, null, 3000, '2025-11-20');

-- SQL Error [23502]: ERROR: null value in column "name" of relation "employees_with_constraints" violates not-null constraint

insert into de_gds.employees_with_constraints values (1,'Shashank',3000,'2025-11-20');

select * from de_gds.employees_with_constraints; 

insert into de_gds.employees_with_constraints values (1,'Rahul',5000,'2025-10-23');

-- SQL Error [23505]: ERROR: duplicate key value violates unique constraint "employees_with_constraints_id_key"
   Detail: Key (id)=(1) already exists.

insert into de_gds.employees_with_constraints values (null,'Rahul',5000,'2025-10-23');
insert into de_gds.employees_with_constraints values (null,'Rajat',2000,'2025-09-20');
select * from de_gds.employees_with_constraints; 

-- primary key -> can not have null value whether 'unique' can have null values

insert into de_gds.employees_with_constraints values (5,'Amit',500,'2025-10-24');
-- SQL ERROR: new row for relation "employees_with_constraints" violates check constraint 
 "employees_with_constraints_salary_check"

insert into de_gds.employees_with_constraints(id,name,salary) 
values (7,'Neeraj',3000);
select * from de_gds.employees_with_constraints; 

-- Named intigrity constraint 
CREATE TABLE IF NOT EXISTS de_gds.employee_with_constraints_tmp (
    id INT,
    name VARCHAR(50) NOT NULL,
    salary NUMERIC(10,2),
    hiring_date DATE DEFAULT DATE '2021-01-01',
    CONSTRAINT unique_emp_id UNIQUE (id),
    CONSTRAINT salary_check CHECK (salary > 1000)
);

insert into de_gds.employee_with_constraints_tmp values (5,'Amit',500,'2023-10-24'); 
-- ERROR: new row for relation "employee_with_constraints_tmp" violates check constraint "salary_check"
   Detail: Failing row contains (5, Amit, 500.00, 2023-10-24).
   
   
-- Temp table to showcase Alter command
create table if not exists de_gds.employees_temp(
    emp_id int,
    emp_name VARCHAR(50),
    address VARCHAR(50),
    city VARCHAR(50)
);

insert into de_gds.employees_temp values(1,'Shashank', 'RJPM', 'Lucknow');
select * from de_gds.employees_temp;

-- add a new column in existing table
alter table de_gds.employees_temp add DOB date;

-- change the data type of existing column
alter table de_gds.employees_temp alter column emp_name type varchar (100);

-- Delete existing column from a table
alter table de_gds.employees_temp drop column city;

-- Rename any existing column 
alter table de_gds.employees_temp rename column emp_name to full_name;

--- Table for named constraints through alter command
create table if not exists de_gds.employees_test(
    id int,
    name VARCHAR(50),
    age int,
    hiring_date date,
    salary int,
    city varchar(50)
);

insert into de_gds.employees_test values(1,'Shashank', 24, '2025-08-10', 10000, 'Lucknow'),
(2,'Rahul', 25, '2025-08-10', 20000, 'Khajuraho'),
(3,'Sunny', 22, '2025-08-11', 11000, 'Banaglore'),
(5,'Amit', 25, '2025-08-11', 12000, 'Noida'),
(6,'Puneet', 26, '2025-08-12', 50000, 'Gurgaon');

select * from de_gds.employees_test;

--- add unique integrity constraint on id COLUMN

ALTER TABLE de_gds.employees_test
ADD CONSTRAINT unique_id UNIQUE (id);

insert into de_gds.employees_test values(1,'Akshay', 25, '2025-08-10', 50000, 'Gurgaon');
-- ERROR: duplicate key value violates unique constraint "unique_id"
   Detail: Key (id)=(1) already exists.
   
--- drop constraint from existing TABLE
alter table de_gds.employees_test drop constraint unique_id;   

--- create table with Primary_Key
Create table de_gds.guests
(
    id int, 
    name varchar(50), 
    age int,
    constraint g_pk Primary Key (id) 
);

insert into de_gds.guests values(1,'Shashank',29);
insert into de_gds.guests values(1,'Rahul',28);
-- ERROR: duplicate key value violates unique constraint "g_pk"
  Detail: Key (id)=(1) already exists.
-- Primary key can not be duplicate or null
  
-- Tables for referntial integrity constraint
create table de_gds.customer
(
    cust_id int,
    name VARCHAR(50), 
    age int,
    constraint cust_pk Primary Key (cust_id) 
);

create table de_gds.orders
(
    order_id int,
    amount int,
    customer_id int,
    constraint ord_pk Primary Key (order_id),
    constraint cust_fk Foreign Key (customer_id) REFERENCES de_gds.customer(cust_id)
);

insert into de_gds.customer values(1,'Shashank',29);
insert into de_gds.customer values(2,'Rahul',30);

select * from de_gds.customer;

insert into de_gds.orders values(1001, 20, 1);
insert into de_gds.orders values(1002, 30, 2);

select * from de_gds.orders;

insert into de_gds.orders values(1004, 35, 5);
-- ERROR: insert or update on table "orders" violates foreign key constraint "cust_fk"
   Detail: Key (customer_id)=(5) is not present in table "customer".

select * from de_gds.orders;
truncate table de_gds.orders; 
drop table de_gds.orders;

create table de_gds.orders
(
    order_id int,
    amount int,
    customer_id int,
    constraint ord_pk Primary Key (order_id),
    constraint cust_fk Foreign Key (customer_id) REFERENCES de_gds.customer(cust_id)
);

insert into de_gds.orders values(1001, 20, 1);
insert into de_gds.orders values(1002, 30, 2);

select * from de_gds.orders;
