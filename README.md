# PostgreSQL Learning Journey

This repository contains my PostgreSQL practice as I work towards becoming a Data Analyst.

## Topics Covered

- Database Creation
- Tables & Schemas
- CRUD Operations
- Constraints
- Transactions
- User Management
- Date Functions
- String Functions
- GROUP BY
- HAVING

## Projects

### Employee Management Database

Practiced:
- CRUD Operations
- Constraints
- Transactions

### E-Commerce Database

Practiced:
- Customer Management
- Product Management
- Orders & Order Items
- Business Queries

## Tools

- PostgreSQL
- DBeaver

## Day 5: Joins and Aggregations

### Topics Covered
- STRING_AGG()
- GROUP BY ROLLUP
- LEFT JOIN
- RIGHT JOIN
- FULL OUTER JOIN
- CROSS JOIN


# Day 6 - Advanced SQL Joins and Subqueries

## Topics Covered

### 1. NATURAL JOIN

* Automatically joins tables based on columns with the same name.
* Reduces the need to explicitly specify join conditions.
* Useful when related tables share common column names.

### 2. SELF JOIN

* A table is joined with itself.
* Helpful for comparing rows within the same table.
* Commonly used for hierarchical relationships such as employee-manager structures.

### 3. Subqueries

* Queries nested inside another SQL query.
* Used to break complex problems into smaller and manageable parts.
* Can be placed in SELECT, FROM, or WHERE clauses.

### 4. Scalar Subquery

* Returns a single value.
* Can be used wherever a single value or expression is expected.
* Often used for comparisons and calculations.

### 5. Multi-row Subquery

* Returns multiple rows.
* Commonly used with operators such as IN, ANY, and ALL.
* Helps filter data based on a set of returned values.

### 6. Correlated Subquery

* Depends on values from the outer query.
* Executes once for each row processed by the outer query.
* Useful for row-by-row comparisons and advanced filtering.

### 7. IN and NOT IN Operations

* IN checks whether a value exists in a specified list or subquery result.
* NOT IN excludes matching values.
* Simplifies filtering conditions involving multiple values.

## Key Takeaway

Advanced joins and subqueries provide powerful ways to retrieve, filter, and analyze data. These concepts are essential for solving real-world business problems and writing efficient SQL queries.

## Tools Used

* PostgreSQL
* DBeaver

## Progress Update

Completed Day 6 of my SQL learning journey and strengthened my understanding of advanced joins, nested queries, and data filtering techniques.

### Skills Gained
- Data aggregation
- Revenue summarization
- Table relationships
- Data reconciliation
- Inventory analysis
- SQL reporting
