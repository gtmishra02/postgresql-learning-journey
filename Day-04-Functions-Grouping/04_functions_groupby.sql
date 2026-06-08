create table ecomm_gds.customer_accounts (
	customer_id 	int,
	customer_name 	varchar(100),
	email			varchar(100),
	city 			varchar(50),
	account_number 	varchar(30)
	);

INSERT INTO ecomm_gds.customer_accounts VALUES
(1, 'Rahul Sharma',     'rahul.sharma@gmail.com',     'Delhi',     'ACC-DEL-001'),
(2, 'Rohit Verma',      'rohit_v@outlook.com',        'Mumbai',    'ACC-MUM-023'),
(3, 'Anita Singh',      'anita.singh@yahoo.com',      'Bangalore', 'ACC-BLR-045'),
(4, 'Amit Kumar',       'amit.k@company.in',          'Delhi',     'ACC-DEL-078'),
(5, 'Sneha Patil',      'sneha.patil@gmail.com',      'Pune',      'ACC-PUN-009'),
(6, 'Suresh Reddy',     's.reddy@enterprise.com',     'Hyderabad', 'ACC-HYD-120'),
(7, 'Ritika Malhotra',  'ritika.m@startup.io',        'Delhi',     'ACC-DEL-211'),
(8, 'Arjun Mehta',      'arjun.mehta@gmail.com',      'Mumbai',    'ACC-MUM-305'),
(9, 'Neha Jain',        'neha_jain@company.in',       'Jaipur',    'ACC-JAI-018'),
(10,'Vikram Rao',       'vikram.rao@yahoo.com',       'Bangalore', 'ACC-BLR-999');

select * from ecomm_gds.customer_accounts;

----- Like operation
-- Wild card characters
-- % --> it means zero, one or more than one charachter 
-- _ --> it means olny one charachter 

-- Names starting with 'A'
SELECT customer_id, customer_name
FROM ecomm_gds.customer_accounts
WHERE customer_name LIKE 'A%';

-- Emails ending with gmail.com
select email, customer_id 
from ecomm_gds.customer_accounts
where email like '%@gmail.com'; 

-- Emails containing 'company'
select email, customer_id 
from ecomm_gds.customer_accounts
where email like '%company%';

-- Match account numbers with exactly 3-letter city codes
SELECT customer_id, account_number
FROM ecomm_gds.customer_accounts
WHERE account_number LIKE 'ACC-___-%';


-- Delhi accounts with 3-digit sequence
SELECT customer_id, account_number
FROM ecomm_gds.customer_accounts
WHERE account_number LIKE 'ACC-DEL-%';

-- Exclude gmail users
SELECT customer_id, email
FROM ecomm_gds.customer_accounts
WHERE email NOT LIKE '%@gmail.com';

-- Case-insensitive search
SELECT customer_id, customer_name
FROM ecomm_gds.customer_accounts
WHERE customer_name ILIKE '%rahul%';


-- Date & String Functions
CREATE TABLE ecomm_gds.customer_orders (
    order_id        VARCHAR(30),
    customer_name   VARCHAR(100),
    order_date      DATE,
    order_status    VARCHAR(30),
    city            VARCHAR(50),
    order_amount    DECIMAL(10,2)
);

INSERT INTO ecomm_gds.customer_orders VALUES
('ORD-2025-DEL-001', '  rahul sharma ', '2025-01-15', 'order_placed',   'Delhi',      1200.50),
('ORD-2025-MUM-002', 'Neha Verma',      '2025-01-20', 'ORDER_SHIPPED',  'Mumbai',     3400.75),
('ORD-2025-BLR-003', 'amit kumar',      '2025-02-05', 'order_delivered','Bangalore',  899.99),
('ORD-2025-DEL-004', 'Sneha Patil',     '2025-02-18', 'Order_Placed',   'Delhi',      450.00),
('ORD-2025-HYD-005', 'Rohit Reddy',     '2025-03-02', 'ORDER_CANCELLED','Hyderabad',  7800.10),
('ORD-2025-MUM-006', 'Anita Singh',     '2025-03-10', 'order_delivered','Mumbai',     2100.00),
('ORD-2025-BLR-007', ' vikram rao ',    '2025-03-15', 'ORDER_SHIPPED',  'Bangalore',  1500.25);

select * from ecomm_gds.customer_orders;

-- Extract function 
select *, 
	extract (year from order_date) as order_year,
	extract (month from order_date) as order_month,
	extract (day from order_date) as order_day
from ecomm_gds.customer_orders;

-- Truncate Bucket
select *, 
	date_trunc ('Month', order_date) as order_month_bucket
from ecomm_gds.customer_orders;

select *, 
	date_trunc ('year', order_date) as order_year_bucket
from ecomm_gds.customer_orders;

-- adding/substracting days into date
 select *, 
	order_date + interval '7 days' as expected_delivery_date,
	order_date - interval '2 days' as order_processing_start
from ecomm_gds.customer_orders;

-- Order age
select *,
	age(current_date, order_date) as order_age
from ecomm_gds.customer_orders;

-- Date format 
select *,
	to_char( order_date, 'DD-Mon-YYYY') as formatted_date,
	to_char(order_date, 'YYYY-MM') as year_month
from ecomm_gds.customer_orders;

-- Trim 
select *,
	trim(customer_name) as trimmed_customer_name
from ecomm_gds.customer_orders;

-- Initcap function
select *,
	initcap(trim(customer_name)) as cleaned_name
from ecomm_gds.customer_orders;

--- Lower/upper
select *,
	upper(order_status) as upper_case_orders,
	lower (order_status) as lower_case_orders
from ecomm_gds.customer_orders;

-- Length of characters
select *,
	LENGTH(order_id) as id_lenght
from ecomm_gds.customer_orders;

--SPLIT 
-- ORDER_ID
-- 	1 	2 	3 	4
-- ORD 2025 DEL 001
SELECT
    order_id,
    SPLIT_PART(order_id, '-', 2) AS order_year,
    SPLIT_PART(order_id, '-', 3) AS city_code,
    SPLIT_PART(order_id, '-', 4) AS sequence_number
FROM ecomm_gds.customer_orders;

-- Substring from 10th index for 3 indexes so it will give city 
select *,
	substring(order_id from 10 for 3) as city_code_substr 
FROM ecomm_gds.customer_orders;

--REPLACE
select *,
	replace(order_status, '_', ' ') as readable_status
FROM ecomm_gds.customer_orders;

-- CONCAT 
SELECT
    order_id,
    CONCAT('Order ', order_id, ' placed by ', INITCAP(TRIM(customer_name))) AS order_summary_1,
FROM ecomm_gds.customer_orders;

--CONCAT 
SELECT
    order_id,
	'Order ' || order_id || ' amount ₹' || order_amount AS order_summary_2
FROM ecomm_gds.customer_orders; 

-------------------------
-------- Group By

CREATE TABLE ecomm_gds.card_transactions (
    txn_id        INT,
    customer_id   INT,
    card_type     VARCHAR(10),   -- TC / TD
    region        VARCHAR(20),
    amount        NUMERIC(12,2),
    txn_date      DATE
);

CREATE TABLE ecomm_gds.upi_transactions (
    txn_id        INT,
    customer_id   INT,
    region        VARCHAR(20),
    amount        NUMERIC(12,2),
    txn_date      DATE
);

INSERT INTO ecomm_gds.card_transactions VALUES
(1,101,'TC','NORTH',1200,'2025-01-02'),
(2,101,'TC','NORTH',800,'2025-01-10'),
(3,101,'TD','NORTH',500,'2025-02-05'),
(4,102,'TD','WEST',300,'2025-01-07'),
(5,102,'TC','WEST',700,'2025-02-11'),
(6,103,'TC','SOUTH',1500,'2025-01-15'),
(7,103,'TC','SOUTH',2200,'2025-02-20'),
(8,104,'TD','EAST',400,'2025-01-18'),
(9,104,'TD','EAST',600,'2025-02-22'),
(10,105,'TC','NORTH',5000,'2025-02-01'),
(11,106,'TD','WEST',200,'2025-01-05'),
(12,106,'TD','WEST',300,'2025-01-25'),
(13,107,'TC','SOUTH',1800,'2025-02-10'),
(14,108,'TC','NORTH',900,'2025-01-30'),
(15,108,'TC','NORTH',1100,'2025-02-14'),
(16,109,'TD','EAST',750,'2025-01-12'),
(17,109,'TD','EAST',1250,'2025-02-18'),
(18,110,'TC','WEST',3500,'2025-02-05'),
(19,111,'TC','SOUTH',600,'2025-01-08'),
(20,111,'TC','SOUTH',700,'2025-02-08'),
(21,112,'TD','NORTH',450,'2025-01-19'),
(22,113,'TC','EAST',2600,'2025-02-25'),
(23,114,'TD','WEST',800,'2025-01-28'),
(24,115,'TC','NORTH',3200,'2025-02-27'),
(25,116,'TD','SOUTH',900,'2025-02-03');

INSERT INTO ecomm_gds.upi_transactions VALUES
(201,101,'NORTH',300,'2025-01-03'),
(202,101,'NORTH',400,'2025-02-06'),
(203,102,'WEST',200,'2025-01-09'),
(204,103,'SOUTH',500,'2025-01-20'),
(205,103,'SOUTH',700,'2025-02-21'),
(206,104,'EAST',350,'2025-02-01'),
(207,105,'NORTH',1200,'2025-01-15'),
(208,105,'NORTH',1800,'2025-02-16'),
(209,106,'WEST',150,'2025-01-06'),
(210,107,'SOUTH',900,'2025-02-12'),
(211,108,'NORTH',600,'2025-01-31'),
(212,109,'EAST',400,'2025-01-14'),
(213,110,'WEST',1300,'2025-02-06'),
(214,111,'SOUTH',300,'2025-01-10'),
(215,112,'NORTH',500,'2025-02-02'),
(216,113,'EAST',900,'2025-02-26'),
(217,114,'WEST',700,'2025-01-29'),
(218,115,'NORTH',1500,'2025-02-28'),
(219,116,'SOUTH',400,'2025-02-04'),
(220,117,'EAST',2500,'2025-02-10'),
(221,118,'WEST',1000,'2025-01-22'),
(222,119,'NORTH',200,'2025-01-17'),
(223,120,'SOUTH',1800,'2025-02-19'),
(224,121,'EAST',600,'2025-01-26'),
(225,122,'WEST',2200,'2025-02-23');

select * from ecomm_gds.card_transactions;

--- Group By
--- Toral txns, txn amount, avg amount by each cusotmer
SELECT
  customer_id,
  COUNT(*) AS txn_count,
  SUM(amount) AS total_spend,
  AVG(amount) AS avg_txn_value
FROM ecomm_gds.card_transactions
GROUP BY customer_id
order by customer_id;

SELECT
  city
FROM ecomm_gds.customers
GROUP BY city;

-- Toral txn amount for each type of card per region
select 
	region, card_type,
	COUNT(*) AS txn_count,
  	SUM(amount) AS total_spend,
  	AVG(amount) AS avg_txn_value
FROM ecomm_gds.card_transactions
GROUP BY region, card_type 
ORDER BY region, card_type;
SSSSSS
-- Toral txn amount per region in a year for every month 
select 
	region, 
	extract (year from txn_date) as txn_year,
	extract (month from txn_date) as txn_month,
  	count(*) as txn_count,
  	SUM(amount) AS total_spend
FROM ecomm_gds.card_transactions
GROUP BY region, extract (year from txn_date), extract (month from txn_date)
order by region, txn_year, txn_month;

--- Filter out all such regions where at least 6 transactions were made 
select 
	region,
	count(*) total_txn
from ecomm_gds.card_transactions
group by region
having count(*) >= 6 ;

-- Regions where:
-- Total spend > ₹8,000
-- AND average transaction value > ₹1,500
SELECT
  region,
  COUNT(*) AS txn_count,
  SUM(amount) AS total_spend,
  AVG(amount) AS avg_txn_value
FROM ecomm_gds.card_transactions
GROUP BY region
HAVING
  SUM(amount) > 8000
  AND AVG(amount) > 1500;


-- For 2025 data only, find regions with high spend
-- threshold for high spend is 7000 Rs
SELECT
  region,
  COUNT(*) AS txn_count,
  SUM(amount) AS total_spend
FROM ecomm_gds.card_transactions
where txn_date between '2025-01-01' and '2025-12-31'
GROUP BY region
having SUM(amount) > 7000;
