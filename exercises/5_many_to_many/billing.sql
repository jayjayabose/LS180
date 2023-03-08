-- table: customers
-- id is a unique numeric customer id that auto-increments and serves as a primary key for this table.
-- name is the customer's name. This value must be present in every record and may contain names of any length.
-- payment_token is a required unique 8-character string that consists of solely uppercase alphabetic letters. 
--   It identifies each customer's payment information with the payment processor the company uses.

CREATE TABLE customers (
  id serial PRIMARY KEY,
  name text NOT NULL,
  payment_token char(8) NOT NULL CHECK (payment_token ~ '[A-Z]{2}')
);


-- The services table should include the following columns:
-- id is a unique numeric service id that auto-increments and serves as a primary key for this table.
-- description is the service description. This value must be present and may contain any text.
-- price is the annual service price. It must be present, must be greater than or equal to 0.00. The data type is numeric(10, 2).

CREATE TABLE services (
  id serial PRIMARY KEY,
  description text NOT NULL,
  price numeric(10, 2) NOT NULL CHECK (price >= 0)
);

-- Data for the customers table
-- id | name          | payment_token
-- --------------------------------
-- 1  | Pat Johnson   | XHGOAHEQ
-- 2  | Nancy Monreal | JKWQPJKL
-- 3  | Lynn Blake    | KLZXWEEE
-- 4  | Chen Ke-Hua   | KWETYCVX
-- 5  | Scott Lakso   | UUEAPQPS
-- 6  | Jim Pornot    | XKJEYAZA

INSERT INTO customers (name, payment_token)
VALUES
  ('Pat Johnson', 'XHGOAHEQ'),
  ('Nancy Monreal', 'JKWQPJKL'),
  ('Lynn Blake', 'KLZXWEEE'),
  ('Chen Ke-Hua', 'KWETYCVX'),
  ('Scott Lakso', 'UUEAPQPS'),
  ('Jim Pornot', 'XKJEYAZA');

  -- Data for the services table
-- id | description         | price
-- ---------------------------------
-- 1  | Unix Hosting        | 5.95
-- 2  | DNS                 | 4.95
-- 3  | Whois Registration  | 1.95
-- 4  | High Bandwidth      | 15.00
-- 5  | Business Support    | 250.00
-- 6  | Dedicated Hosting   | 50.00
-- 7  | Bulk Email          | 250.00
-- 8  | One-to-one Training | 999.00

INSERT INTO services (description, price)
VALUES
  ('Unix Hosting', 5.95),
  ('DNS', 4.95),
  ('Whois Registration', 1.95),
  ('High Bandwidth', 15.00),
  ('Business Support', 250.00),
  ('Dedicated Hosting', 50.00),
  ('Bulk Email', 250.00),
  ('One-to-one Training', 999.00);

--   create join table
--   The join table should have columns for both the 
--   services id and the 
--   customers id, as well as 
--   a primary key named id that auto-increments.

-- The customer id in this table should have the property that deleting the corresponding customer record 
-- from the customers table will automatically delete all rows from the join table that have that customer_id. Do not apply this same property to the service id.

-- Each combination of customer and service in the table should be unique. 
-- In other words, a customer shouldn not be listed as using a particular service more than once.

CREATE TABLE customers_services (
  id serial PRIMARY KEY,
  customer_id integer 
    REFERENCES customers (id) 
    ON DELETE CASCADE
    NOT NULL,
  service_id integer 
    REFERENCES services (id)
    NOT NULL,
  UNIQUE (customer_id, service_id)
);

-- reference; STRING_AGG ( expression, separator [order_by_clause] )
--customer ids
SELECT STRING_AGG( id::text , ', ') from customers;
--  1, 2, 3, 4, 5, 6
SELECT STRING_AGG( id::text , ', ') from services;
-- 1, 2, 3, 4, 5, 6, 7, 8

-- Write a query to retrieve the customer data for every customer who currently subscribes to at least one service.
SELECT DISTINCT c.* FROM customers AS c
  INNER JOIN customers_services as cs 
          ON c.id = cs.customer_id
ORDER BY c.id;

-- Write a query to retrieve the customer data for every customer who does not currently subscribe to any services.
SELECT c.* FROM customers AS c
  LEFT OUTER JOIN customers_services AS cs ON c.id = cs.customer_id
  WHERE cs.customer_id IS NULL;

-- this approoach work as well right?
SELECT customers.* FROM customers
  WHERE id NOT IN (
    SELECT customer_id
    FROM customers_services);

-- Can you write a query that displays all customers with no services and all services that currently don't have any customers? The output should look like this:

SELECT c.*, s.* FROM customers AS c
  FULL OUTER JOIN customers_services AS cs ON c.id = cs.customer_id
  FULL OUTER JOIN services AS s ON cs.service_id = s.id
  WHERE cs.customer_id IS NULL;

-- Using RIGHT OUTER JOIN, write a query to display a list of all services that are not currently in use. Your output should look like this:
--  description
-- -------------
--  One-to-one Training
-- (1 row)

SELECT s.description FROM customers_services AS cs
  RIGHT OUTER JOIN services AS s ON cs.service_id = s.id
  WHERE cs.id IS NULL;

--   Write a query to display a list of all customer names together with a comma-separated list of the services they use. Your output should look like this:

--        name      |                                services
-- ---------------+-------------------------------------------------------------------------
--  Pat Johnson   | Unix Hosting, DNS, Whois Registration
--  Nancy Monreal |
--  Lynn Blake    | DNS, Whois Registration, High Bandwidth, Business Support, Unix Hosting
--  Chen Ke-Hua   | High Bandwidth, Unix Hosting
--  Scott Lakso   | DNS, Dedicated Hosting, Unix Hosting
--  Jim Pornot    | Unix Hosting, Dedicated Hosting, Bulk Email
-- (6 rows)

SELECT * FROM customers AS c
  LEFT JOIN customers_services AS cs ON c.id = cs.customer_id
  LEFT JOIN services AS s ON cs.service_id = s.id;

SELECT c.name, STRING_AGG(s.description, ', ') FROM customers AS c
  LEFT JOIN customers_services AS cs ON c.id = cs.customer_id
  LEFT JOIN services AS s ON cs.service_id = s.id
  GROUP BY c.name;

SELECT c.name, s.description FROM customers AS c
  LEFT JOIN customers_services AS cs ON c.id = cs.customer_id
  LEFT JOIN services AS s ON cs.service_id = s.id
  ORDER bY c.name;  

SELECT c.name, s.description FROM customers AS c
  LEFT JOIN customers_services AS cs ON c.id = cs.customer_id
  LEFT JOIN services AS s ON cs.service_id = s.id
  ORDER bY c.name;  

SELECT c.name,
       lag(c.name)
         OVER (ORDER BY c.name)
         AS previous,
       s.description
  FROM customers AS c
  LEFT JOIN customers_services AS cs ON c.id = cs.customer_id
  LEFT JOIN services AS s ON cs.service_id = s.id;

 SELECT CASE when lag(c.name) 
        OVER (ORDER BY c.name) = c.name THEN ''
        ELSE c.name
        END,
       s.description
  FROM customers AS c
  LEFT JOIN customers_services AS cs ON c.id = cs.customer_id
  LEFT JOIN services AS s ON cs.service_id = s.id;

-- Write a query that displays the description for every service that is subscribed to by at least 3 customers. 
-- Include the customer count for each description in the report. The report should look like this   

--  description  | count
-- --------------+-------
--  DNS          |     3
--  Unix Hosting |     5
-- (2 rows)

SELECT * 
  FROM customers_services AS cs 
  FULL JOIN services AS s ON cs.service_id = s.id;

SELECT s.description, COUNT(cs.customer_id)
FROM customers_services AS cs 
LEFT OUTER JOIN services AS s ON cs.service_id = s.id
GROUP BY s.description
HAVING COUNT(cs.customer_id) >= 3
ORDER BY s.description;

-- Assuming that everybody in our database has a bill coming due, and that all of them will pay on time, 
-- write a query to compute the total gross income we expect to receive.

  gross
 --------
 678.50
(1 row)

SELECT SUM(s.price) as gross 
FROM customers_services AS cs 
INNER JOIN services AS s 
  ON cs.service_id = s.id;