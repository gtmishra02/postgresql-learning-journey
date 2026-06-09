---------------------------
------- String Agg

CREATE TABLE ecomm_gds.orders_data (
    order_id  INT,
    country   VARCHAR(50),
    state     VARCHAR(50)
);


INSERT INTO ecomm_gds.orders_data VALUES
(1, 'India', 'Maharashtra'),
(2, 'India', 'Karnataka'),
(3, 'India', 'Maharashtra'),
(4, 'India', 'Delhi'),
(5, 'India', 'Karnataka'),
(6, 'USA',  'California'),
(7, 'USA',  'Texas'),
(8, 'USA',  'California'),
(9, 'USA',  'New York'),
(10,'UK',   'England'),
(11,'UK',   'Scotland'),
(12,'UK',   'England');

SELECT
  country,
  STRING_AGG(state, ', ') AS states_in_country
FROM ecomm_gds.orders_data
GROUP BY country;

SELECT
  country,
  STRING_AGG(DISTINCT state, ', ') AS states_in_country
FROM ecomm_gds.orders_data
GROUP BY country;

SELECT
  country,
  STRING_AGG(DISTINCT state, ', ' ORDER BY state DESC) AS states_in_country
FROM ecomm_gds.orders_data
GROUP BY country;

SELECT
  country,
  STRING_AGG(DISTINCT state, ' -> ' ORDER BY state DESC) AS states_in_country
FROM ecomm_gds.orders_data
GROUP BY country;

SELECT
  country,
  COUNT(DISTINCT state) AS total_states,
  STRING_AGG(DISTINCT state, ' | ' ORDER BY state) AS states_in_country
FROM ecomm_gds.orders_data
GROUP BY country
ORDER BY country;

----- Group By Roll Up

CREATE TABLE ecomm_gds.payment (
    payment_amount DECIMAL(8,2),
    payment_date   DATE,
    store_id       INT
);

INSERT INTO ecomm_gds.payment VALUES
(1200.99, '2018-01-18', 1),
(189.23,  '2018-02-15', 1),
(33.43,   '2018-03-03', 3),
(3002.43, '2018-02-25', 2),

(7382.10, '2019-01-11', 2),
(382.92,  '2019-02-18', 1),
(322.34,  '2019-03-29', 2),
(100.99,  '2019-03-07', 1),

(2929.14, '2020-01-03', 2),
(499.02,  '2020-02-19', 3),
(211.65,  '2020-02-02', 1),
(994.11,  '2020-03-14', 1),

(394.93,  '2021-01-22', 2),
(500.73,  '2021-01-06', 3),
(3332.23, '2021-02-23', 3),
(9499.49, '2021-03-10', 3);

-- total revenue, per year & per store
-- with basic group by

SELECT
    EXTRACT(YEAR FROM payment_date) AS payment_year,
    store_id,
    SUM(payment_amount) AS total_revenue
FROM ecomm_gds.payment
GROUP BY
    EXTRACT(YEAR FROM payment_date),
    store_id
ORDER BY
    payment_year,
    store_id;

-- Revenue per store, per year + yearly totals + grand total
SELECT
    EXTRACT(YEAR FROM payment_date) AS payment_year,
    store_id,
    SUM(payment_amount) AS total_revenue
FROM ecomm_gds.payment
GROUP BY
    ROLLUP (EXTRACT(YEAR FROM payment_date), store_id)
ORDER BY
    payment_year,
    store_id;

-- Grand Total Revenue (All Years, All Stores)

SELECT
    total_revenue
FROM (
    SELECT
        EXTRACT(YEAR FROM payment_date) AS payment_year,
        store_id,
        SUM(payment_amount) AS total_revenue
    FROM ecomm_gds.payment
    GROUP BY
        ROLLUP (EXTRACT(YEAR FROM payment_date), store_id)
) t
WHERE payment_year IS NULL
  AND store_id IS NULL;

-- Total Revenue per Year (All Stores)
SELECT
    payment_year,
    total_revenue
FROM (
    SELECT
        EXTRACT(YEAR FROM payment_date) AS payment_year,
        store_id,
        SUM(payment_amount) AS total_revenue
    FROM ecomm_gds.payment
    GROUP BY
        ROLLUP (EXTRACT(YEAR FROM payment_date), store_id)
) t
WHERE payment_year IS NOT NULL
  AND store_id IS NULL
ORDER BY payment_year;

-- Revenue per Year per Store (Detail Level)
SELECT
    payment_year,
    store_id,
    total_revenue
FROM (
    SELECT
        EXTRACT(YEAR FROM payment_date) AS payment_year,
        store_id,
        SUM(payment_amount) AS total_revenue
    FROM ecomm_gds.payment
    GROUP BY
        ROLLUP (EXTRACT(YEAR FROM payment_date), store_id)
) t
WHERE payment_year IS NOT NULL
  AND store_id IS NOT NULL
ORDER BY payment_year, store_id;

-------------------------------------

CREATE SCHEMA IF NOT EXISTS ds_retail_gds;
CREATE SCHEMA IF NOT EXISTS ds_inventory_ds;
CREATE SCHEMA IF NOT EXISTS ds_hr_ds;

CREATE TABLE IF NOT EXISTS ds_retail_gds.customers (
  customer_id INT PRIMARY KEY,
  customer_name TEXT NOT NULL,
  city TEXT NOT NULL,
  segment TEXT NOT NULL -- e.g., Retail / Corporate
);

CREATE TABLE IF NOT EXISTS ds_retail_gds.orders (
  order_id INT PRIMARY KEY,
  customer_id INT,
  order_date DATE NOT NULL,
  status TEXT NOT NULL,        -- PLACED / SHIPPED / DELIVERED / CANCELLED
  order_total NUMERIC(12,2) NOT NULL
);

INSERT INTO ds_retail_gds.customers VALUES
(101,'Amit Sharma','Delhi','Retail'),
(102,'Neha Verma','Mumbai','Corporate'),
(103,'Rahul Iyer','Bengaluru','Retail'),
(104,'Sneha Patil','Pune','Corporate'),
(105,'Zoya Khan','Delhi','Retail'),
(106,'Kunal Mehta','Hyderabad','Retail'),
(107,'Isha Jain','Mumbai','Corporate'),
(108,'Vikram Singh','Chennai','Retail');

INSERT INTO ds_retail_gds.orders VALUES
(1001,101,'2025-01-10','DELIVERED', 5400.00),
(1002,101,'2025-02-15','CANCELLED', 1200.00),
(1003,102,'2025-02-20','DELIVERED', 9800.00),
(1004,103,'2025-03-05','SHIPPED',   2300.00),
(1005,105,'2025-03-18','PLACED',    6700.00),
(1006,999,'2025-03-22','DELIVERED', 4000.00),  
(1007,NULL,'2025-04-01','PLACED',   1500.00), 
(1008,104,'2025-04-10','DELIVERED', 8200.00);

CREATE TABLE IF NOT EXISTS ds_inventory_gds.products (
  product_id INT PRIMARY KEY,
  product_name TEXT NOT NULL,
  category TEXT NOT NULL,
  unit_price NUMERIC(10,2) NOT NULL
);

CREATE TABLE IF NOT EXISTS ds_inventory_gds.warehouses (
  warehouse_id INT PRIMARY KEY,
  warehouse_name TEXT NOT NULL,
  city TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS ds_inventory_gds.stock (
  warehouse_id INT,
  product_id INT,
  qty_on_hand INT NOT NULL,
  last_restock_date DATE NOT NULL,
  PRIMARY KEY (warehouse_id, product_id)
);


INSERT INTO ds_inventory_gds.products VALUES
(1,'iPhone 15','Electronics',80000),
(2,'AirPods Pro','Electronics',22000),
(3,'Office Chair','Furniture',15000),
(4,'Standing Desk','Furniture',32000),
(5,'Coffee Machine','Appliances',12000),
(6,'Monitor 27inch','Electronics',18000);

INSERT INTO ds_inventory_gds.warehouses VALUES
(10,'WH_North_Delhi','Delhi'),
(11,'WH_West_Mumbai','Mumbai'),
(12,'WH_South_Blr','Bengaluru');

INSERT INTO ds_inventory_gds.stock VALUES
(10,1, 12,'2025-02-01'),
(10,2, 25,'2025-02-10'),
(10,6,  5,'2025-03-10'),
(11,3, 14,'2025-01-20'),
(11,4,  2,'2025-03-15'),
(12,5,  0,'2025-02-25'),
(12,6,  9,'2025-03-05');

CREATE TABLE IF NOT EXISTS ds_hr_gds.employees (
  emp_id INT PRIMARY KEY,
  emp_name TEXT NOT NULL,
  dept TEXT NOT NULL,
  manager_id INT NULL,
  join_date DATE NOT NULL
);

INSERT INTO ds_hr_gds.employees VALUES
(1,'Ananya (CEO)','Leadership',NULL,'2020-01-01'),
(2,'Rohit (CTO)','Tech',1,'2020-06-10'),
(3,'Meera (Eng Manager)','Tech',2,'2021-03-15'),
(4,'Arjun (Senior DE)','Tech',3,'2022-08-01'),
(5,'Priya (DE)','Tech',3,'2023-04-12'),
(6,'Kabir (HR Head)','HR',1,'2021-01-10'),
(7,'Nisha (HR Exec)','HR',6,'2024-02-20');

-- Delivered orders with customer details
-- INNER JOIN keeps only matching customers + orders
SELECT
  o.order_id, o.order_date, o.status, o.order_total,
  c.customer_name, c.city, c.segment
FROM ds_retail_gds.orders o
INNER JOIN ds_retail_gds.customers c
  ON o.customer_id = c.customer_id
WHERE o.status = 'DELIVERED';

-- Another optimized query with Subquery
SELECT
  o.order_id, o.order_date, o.status, o.order_total,
  c.customer_name, c.city, c.segment
FROM (select * from ds_retail_gds.orders where status = 'DELIVERED') o
INNER JOIN ds_retail_gds.customers c
  ON o.customer_id = c.customer_id;

-- Customers who have at least 2 orders
-- INNER JOIN + aggregation to find repeat customers
SELECT
  c.customer_id, c.customer_name,
  COUNT(o.order_id) AS total_orders
FROM ds_retail_gds.customers c
INNER JOIN ds_retail_gds.orders o
  ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.customer_name
HAVING COUNT(o.order_id) >= 2;

-- Customers with or without orders (find “no orders” too)
-- LEFT JOIN keeps all customers; orders may be NULL
SELECT
  c.customer_id, c.customer_name,
  o.order_id, o.status, o.order_date
FROM ds_retail_gds.customers c
LEFT JOIN ds_retail_gds.orders o
  ON c.customer_id = o.customer_id
ORDER BY c.customer_id, o.order_date;

-- Customers who never ordered (anti-pattern done via LEFT JOIN)
-- Customers with no orders -> order_id will be NULL
SELECT
  c.customer_id, c.customer_name
FROM ds_retail_gds.customers c
LEFT JOIN ds_retail_gds.orders o
  ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL;

-- All orders even if customer missing (data quality check)
-- RIGHT JOIN keeps all orders; customer may be NULL
SELECT
  o.order_id, o.customer_id,
  c.customer_name
FROM ds_retail_gds.customers c
RIGHT JOIN ds_retail_gds.orders o
  ON c.customer_id = o.customer_id
ORDER BY o.order_id;

-- Orders with missing customer master (only broken ones)
-- Focus only on problematic orders where customer is missing
SELECT
  o.order_id, o.customer_id, o.order_date, o.status
FROM ds_retail_gds.customers c
RIGHT JOIN ds_retail_gds.orders o
  ON c.customer_id = o.customer_id
WHERE c.customer_id IS NULL;

-- Full reconciliation view (customers + orders)
-- FULL JOIN returns all customers + all orders (even unmatched ones)
SELECT
  c.customer_id, c.customer_name,
  o.order_id, o.customer_id AS order_customer_id,
  o.status
FROM ds_retail_gds.customers c
FULL OUTER JOIN ds_retail_gds.orders o
  ON c.customer_id = o.customer_id
ORDER BY c.customer_id NULLS LAST, o.order_id NULLS LAST;

-- Only unmatched records from both sides
-- Unmatched = either customer has no orders OR order has no customer
SELECT
  c.customer_id, c.customer_name,
  o.order_id, o.customer_id AS order_customer_id
FROM ds_retail_gds.customers c
FULL OUTER JOIN ds_retail_gds.orders o
  ON c.customer_id = o.customer_id
WHERE c.customer_id IS NULL OR o.order_id IS NULL;

-- Stock availability matrix for each warehouse-product (simulation)
-- CROSS JOIN generates all combinations (warehouse x product)
SELECT
  w.warehouse_name,
  p.product_name
FROM ds_inventory_gds.warehouses w
CROSS JOIN ds_inventory_gds.products p
ORDER BY w.warehouse_name, p.product_name;

-- Warehouse-product matrix with actual stock (CROSS + LEFT)
-- CROSS gives full grid, LEFT JOIN fills actual qty if exists
SELECT
  w.warehouse_name,
  p.product_name,
  COALESCE(s.qty_on_hand, 0) AS qty_on_hand
FROM ds_inventory_gds.warehouses w
CROSS JOIN ds_inventory_gds.products p
LEFT JOIN ds_inventory_gds.stock s
  ON s.warehouse_id = w.warehouse_id
 AND s.product_id = p.product_id
ORDER BY w.warehouse_name, p.product_name;
