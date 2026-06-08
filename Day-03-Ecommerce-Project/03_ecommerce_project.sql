create schema ecomm_gds;
create table if not exists ecomm_gds.customers (
	customer_id	serial primary key,
	full_name varchar (80)not null,
	city varchar (40) not null,
	tier varchar (15) not null check (tier in ('Bronze','Silver','Gold')),
	created_at Date not null,
	is_active boolean not null default true 
	);


create table ecomm_gds.products (
	product_id serial primary key,
	product_name varchar(80) not null,
	category varchar(30)not null,
	unit_price numeric (10,2) not null check (unit_price >= 0),
	gst_percent numeric (5,2) not null check(gst_percent in (0,5,12,18)),
	stock_qty int not null check (stock_qty>= 0),
	is_discontinued Boolean not null default false
	);

CREATE TABLE ecomm_gds.orders (
  order_id      SERIAL PRIMARY KEY,
  customer_id   INT NOT NULL REFERENCES ecomm_gds.customers(customer_id),
  order_date    DATE NOT NULL,
  status        VARCHAR(15) NOT NULL CHECK (status IN ('PLACED','PAID','CANCELLED','RETURNED')),
  coupon_percent INT,  -- can be NULL
  shipping_fee  NUMERIC(10,2) NOT NULL DEFAULT 0
);

CREATE TABLE ecomm_gds.order_items (
  order_item_id SERIAL PRIMARY KEY,
  order_id      INT NOT NULL REFERENCES ecomm_gds.orders(order_id),
  product_id    INT NOT NULL REFERENCES ecomm_gds.products(product_id),
  qty           INT NOT NULL CHECK (qty > 0),
  discount_percent INT NOT NULL DEFAULT 0 CHECK (discount_percent BETWEEN 0 AND 80)
);


INSERT INTO ecomm_gds.customers (full_name, city, tier, created_at, is_active) VALUES
('Aarav Mehta',     'Mumbai',     'Gold',   '2024-01-10', TRUE),
('Neha Sharma',     'Delhi',      'Silver', '2024-03-05', TRUE),
('Rohan Gupta',     'Bengaluru',  'Bronze', '2023-12-20', TRUE),
('Isha Verma',      'Pune',       'Silver', '2024-07-12', TRUE),
('Kabir Singh',     'Mumbai',     'Bronze', '2024-09-01', FALSE),
('Ananya Iyer',     'Chennai',    'Gold',   '2023-11-15', TRUE),
('Vikram Rao',      'Hyderabad',  'Silver', '2024-02-18', TRUE),
('Pooja Nair',      'Bengaluru',  'Gold',   '2024-05-22', TRUE);

select * from ecomm_gds.customers; 

INSERT INTO ecomm_gds.products (product_name, category, unit_price, gst_percent, stock_qty, is_discontinued) VALUES
('USB-C Cable',        'Accessories', 399.00, 18, 120, FALSE),
('Wireless Mouse',     'Accessories', 999.00, 18,  45, FALSE),
('Mechanical Keyboard', 'Accessories', 3499.00, 18,  15, FALSE),
('Coffee Beans 1kg',   'Grocery',     799.00,  5,  60, FALSE),
('Green Tea 100g',     'Grocery',     249.00,  5,  0,  FALSE),
('Notebook A5',        'Stationery',   99.00, 12, 300, FALSE),
('Pen Pack',           'Stationery',  149.00, 12,  80, FALSE),
('Old Model Charger',  'Accessories', 599.00, 18,   5,  TRUE);

select * from ecomm_gds.products;

INSERT INTO ecomm_gds.orders (customer_id, order_date, status, coupon_percent, shipping_fee) VALUES
(1, '2025-12-01', 'PAID',      10, 49),
(2, '2025-12-02', 'PLACED',    NULL, 0),
(3, '2025-12-02', 'CANCELLED', 15, 49),
(4, '2025-11-28', 'PAID',       5, 0),
(6, '2025-12-03', 'PAID',      NULL, 99),
(7, '2025-12-03', 'RETURNED',  20, 0),
(8, '2025-12-04', 'PAID',       0, 49);

SELECT customer_id, full_name
FROM ecomm_gds.customers;

select * from ecomm_gds.customers;

INSERT INTO ecomm_gds.customers
(customer_id, full_name, city, tier, created_at)
VALUES
(1, 'Test Customer', 'Delhi', 'Silver', '2025-10-10');

INSERT INTO ecomm_gds.order_items (order_id, product_id, qty, discount_percent) VALUES
(43, 1, 2,  0),   -- USB-C Cable
(44, 2, 1, 10),   -- Mouse
(45, 6, 5,  0),   -- Notebook
(46, 7, 2,  5),   -- Pen pack
(47, 3, 1,  0),   -- Keyboard (cancelled order)
(48, 4, 1,  0),   -- Coffee beans
(43, 1, 1,  0),   -- USB-C Cable
(44, 2, 2, 15);   -- Mouse


select * from ecomm_gds.orders

-- unique cities where our customers belong to 
select distinct city from ecomm_gds.customers;

select * from ecomm_gds.products;

--unique product categories 
select distinct category from ecomm_gds.products; 

-- total customers in our databse 
select count(*) as total_customers from ecomm_gds.customers;

-- total count of active customers 
select count(*) as total_customers from ecomm_gds.customers
where is_active = true; 

select * from ecomm_gds.customers;

-- count of unique cities 
select count (distinct city) from ecomm_gds.customers;

select * from ecomm_gds.orders;

-- how many orders have coupons 
select count(coupon_percent) from ecomm_gds.orders;

select * from ecomm_gds.orders;

-- add Rs 10 as additional shipping fee (after handling charges)
select 
	order_id,
	shipping_fee as current_shipping_fee,
	(shipping_fee + 10) as shipping_fee_afterhandling_charges
from ecomm_gds.orders;

select * from ecomm_gds.products;

-- what will be total amount of a product if
-- customer has placed 3 units of it 
select 
	product_name,
	(unit_price * 3) as pricr_for_3_units
from ecomm_gds.products;

--- conditional operators
-- = Equaity
select * from ecomm_gds.orders;

-- get all paid orders date
select * from ecomm_gds.orders where status = 'PAID';

-- get all unpaid orders data
select * from ecomm_gds.orders where status != 'PAID';
-- ASLO
select * from ecomm_gds.orders where status <> 'PAID';

-- products which are cheaper than 300
select * from ecomm_gds.products
where unit_price < 300;

-- list down products which are havig 
-- at max 10 units in the stock
select * from ecomm_gds.products
where stock_qty <= 10;

--list down products of value more than 1000
select * from ecomm_gds.products
where unit_price > 1000;

-- get the list of customers
-- whcih onboarded on or after 2024-05-01
select * from ecomm_gds.customers
where created_at >= '2024-05-01';

-- all orders which are paid and charged some shipping fee
select * from ecomm_gds.orders 
where status = 'PAID' and shipping_fee > 0;

-- get all customers who are from mumbai or bangaluru
select * from ecomm_gds.customers
where city = 'Mumbai' or city = 'Bengaluru';

-- show customers who are not active 
select * from ecomm_gds.customers
where is_active = false;
-- ALSO
select * from ecomm_gds.customers
where not (is_active = true);

-- get me the list of all gold tier customers 
-- who are from mumbai/delhi
select * from ecomm_gds.customers
where tier = 'Gold' and (city = 'Mumbai' or city = 'Delhi');

-- list down only those proucts which are between 200 and 1200
select * from ecomm_gds.products
where unit_price >=200 and unit_price <=1200;
-- better way
select * from ecomm_gds.products
where unit_price between 200 and 1200;

-- the list of orders which were
-- placed between 2025-12-01 to 2025-12-03
select * from ecomm_gds.orders
where order_date between '2025-12-01' and '2025-12-03';

-- all the orders with some coupons
select * from ecomm_gds.orders
where coupon_percent is not null;

-- all the orders where no coupon applied
select * from ecomm_gds.orders
where coupon_percent is null;

-- ORDER BY SINGLE COLUMN (default nature is ascending)
select * from ecomm_gds.products
	order by unit_price;

select * from ecomm_gds.products
	order by stock_qty desc;

-- display data in the ascending order of category and
-- then price high to low
select * from ecomm_gds.products
	order by category asc, unit_price desc;

-- order by where there is null value (null gets treated as highest)
select * from ecomm_gds.orders
	order by coupon_percent desc;

-- if nulls needed in last 
select * from ecomm_gds.orders
	order by coupon_percent desc nulls last;
