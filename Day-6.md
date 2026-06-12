-- Customers and warehouses in same city
-- NATURAL JOIN will join on column(s) with same name: city
SELECT
  customer_name, segment, warehouse_name, city
FROM ds_retail_gds.customers
NATURAL JOIN ds_inventory_gds.warehouses;

-- Filter to show only Mumbai matches
-- Same natural join but with filter
SELECT
  customer_name, warehouse_name, city
FROM ds_retail_gds.customers
NATURAL JOIN ds_inventory_gds.warehouses
WHERE city = 'Mumbai';

-- Employee → Manager mapping
-- Self join to show reporting hierarchy
SELECT
  e.emp_name AS employee,
  m.emp_name AS manager,
  e.dept
FROM ds_hr_gds.employees e
LEFT JOIN ds_hr_gds.employees m
  ON e.manager_id = m.emp_id
ORDER BY e.emp_id;

-- Find all employees reporting to “Meera (Eng Manager)”
-- Filter using manager name (classic interview)
SELECT
  e.emp_name AS reportee,
  m.emp_name AS manager
FROM ds_hr_gds.employees e
JOIN ds_hr_gds.employees m
  ON e.manager_id = m.emp_id
WHERE m.emp_name = 'Meera (Eng Manager)';

-- Show delivered orders from customers in cities where a warehouse exists, and also show warehouse name.
-- 3-table join (orders + customers + warehouses)
-- Business meaning: Orders delivered in serviceable cities (where warehouses exist)
SELECT
  o.order_id, o.order_date, o.order_total,
  c.customer_name, c.city,
  w.warehouse_name
FROM ds_retail_gds.orders o
JOIN ds_retail_gds.customers c
  ON o.customer_id = c.customer_id
JOIN ds_inventory_gds.warehouses w
  ON c.city = w.city
WHERE o.status = 'DELIVERED'
ORDER BY o.order_date;


-----------------

CREATE SCHEMA IF NOT EXISTS ds_banking_gds;

CREATE TABLE ds_banking_gds.customers (
  customer_id INT PRIMARY KEY,
  customer_name TEXT,
  city TEXT,
  customer_type TEXT  -- RETAIL / CORPORATE
);

CREATE TABLE ds_banking_gds.accounts (
  account_id INT PRIMARY KEY,
  customer_id INT,
  account_type TEXT,   -- SAVINGS / CURRENT
  balance NUMERIC(12,2)
);

CREATE TABLE ds_banking_gds.transactions (
  txn_id INT PRIMARY KEY,
  account_id INT,
  txn_date DATE,
  txn_amount NUMERIC(12,2),
  txn_type TEXT       -- CREDIT / DEBIT
);

INSERT INTO ds_banking_gds.customers VALUES
(1,'Amit Sharma','Delhi','RETAIL'),
(2,'Neha Verma','Mumbai','RETAIL'),
(3,'Rahul Iyer','Bengaluru','CORPORATE'),
(4,'Sneha Patil','Pune','RETAIL'),
(5,'Zoya Khan','Delhi','CORPORATE');

INSERT INTO ds_banking_gds.accounts VALUES
(101,1,'SAVINGS',120000),
(102,1,'CURRENT',450000),
(103,2,'SAVINGS',80000),
(104,3,'CURRENT',900000),
(105,4,'SAVINGS',30000),
(106,5,'CURRENT',1500000);

INSERT INTO ds_banking_gds.transactions VALUES
(1001,101,'2025-01-10',15000,'DEBIT'),
(1002,101,'2025-01-15',50000,'CREDIT'),
(1003,102,'2025-02-01',200000,'DEBIT'),
(1004,103,'2025-02-10',30000,'DEBIT'),
(1005,104,'2025-03-05',500000,'CREDIT'),
(1006,104,'2025-03-18',100000,'DEBIT'),
(1007,106,'2025-02-20',400000,'DEBIT'),
(1008, 101, '2025-03-25', 90000, 'DEBIT'),
(1009, 101, '2025-03-28', 70000, 'DEBIT');

-- Scalar Subquery
-- Customers whose balance is above average balance
-- Scalar subquery returns single value (average balance)
SELECT
  account_id,
  balance
FROM ds_banking_gds.accounts
WHERE balance >
      (SELECT AVG(balance) FROM ds_banking_gds.accounts);

-- Multi-Row Subquery (IN)
-- Customers who have at least one CURRENT account
-- Subquery returns multiple customer_ids
SELECT
  customer_id,
  customer_name
FROM ds_banking_gds.customers
WHERE customer_id IN (
  SELECT customer_id
  FROM ds_banking_gds.accounts
  WHERE account_type = 'CURRENT'
);

-- CORRELATED SUBQUERY (Important)
-- Customers whose total transaction amount > account balance
-- Subquery depends on outer query row (correlated)
SELECT
  a.account_id,
  a.balance
FROM ds_banking_gds.accounts a
WHERE a.balance <
      (
        SELECT SUM(t.txn_amount)
        FROM ds_banking_gds.transactions t
        WHERE t.account_id = a.account_id
      );

-- Customers with no transaction
-- NOT IN example
SELECT
  customer_id,
  customer_name
FROM ds_banking_gds.customers
WHERE customer_id NOT IN (
  SELECT DISTINCT customer_id
  FROM ds_banking_gds.accounts a
  JOIN ds_banking_gds.transactions t
    ON a.account_id = t.account_id
);
