create database de_learning_test;

create schema de_gds;

create table if not exists de_gds.employees(
	emp_id int,
	emp_name varchar(100),
	salary numeric(12,2),
	hiring_date date
	);

insert into de_gds.employees values (1,'Shashank', 1000, '2025-09-15');

insert into de_gds.employees (salary,emp_name,emp_id)CO 2C
values (2000, 'Rahul', 2);

select * from de_gds.employees;

insert into de_gds.employees values
(3,'Amit',5000,'2025-10-28'),
(4,'Nitin',3500,'2025-09-16'),
(5,'Kajal',4000,'2025-09-20'); 

select * from de_gds.employees; commit;

select 
	emp_name,
	salary
from de_gds.employees;

select 
	emp_name as employee_name,
	salary as employee_salary
from de_gds.employees;

-- Increment salary of each employee by 20% and display final result with new salary
select 
	emp_id,
	emp_name,
	salary as old_salary,
	(salary * 1.2) as new_salary
from de_gds.employees;

select * from de_gds.employees limit 2;

-- update the salary of employee after giving 20% increment
update de_gds.employees set salary = salary * 1.2;

select * from de_gds.employees;

-- update command for multiple columns at once
-- new salary will be 20% incremented salary
-- name of employees should be in the capital letters 
update de_gds.employees 
set salary = salary * 1.2, emp_name = upper (emp_name); 

select * from de_gds.employees;


-- Insert few more records to showcase update
INSERT INTO de_gds.employees VALUES
(6, 'Rohit', 4500, '2025-09-16'),
(7, 'Sneha', 5200, '2025-10-28'),
(8, 'Pooja', 3800, '2025-09-20'),
(9, 'Vikas', 6000, '2025-08-05'),
(10, 'Anjali', 4200, '2025-08-05');
select * from de_gds.employees;

-- get emloyee records who joined company on 2025-08-05
-- where clause 
select * from de_gds.employees where hiring_date = '2025-08-05';

-- update employee salaries to exact 10000
-- who joined the company on '2025-08-05'
 update de_gds.employees set salary = 10000
 where hiring_date = '2025-08-05';
select * from de_gds.employees;

delete from de_gds.employees where hiring_date =  '2025-08-05';

rollback;
select * from de_gds.employees;

-- create new user
create user de_intern with password 'deintern123';
grant usage on schema de_gds to de_intern;
grant select on table de_gds.employees to de_intern;

revoke select on table de_gds.employees from de_intern;

CREATE TABLE de_gds.salary_data (
    emp_id INT,
    emp_name VARCHAR(50),
    salary INT
);

INSERT INTO de_gds.salary_data VALUES
(1, 'Amit', 5000),
(2, 'Nitin', 3500),
(3, 'Kajal', 4000);

-- SAVEPOINT allows partial rollback inside a transaction without 
-- cancelling the entire transaction.

select * from de_gds.salary_data;

begin;
INSERT INTO de_gds.salary_data VALUES (10, 'Rohit', 6000);
INSERT INTO de_gds.salary_data VALUES (11, 'Ankit', 7000);
savepoint sp_till_ankit;

INSERT INTO de_gds.salary_data VALUES (12, 'Ramesh', -8000);

rollback to savepoint sp_till_ankit;
