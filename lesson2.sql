-- 7. Write a query to print out a report of 
-- all tickets purchased by the customer with the email address 'gennaro.rath@mcdermott.co'. 
-- The report should include the 
--   event name and 
--   starts_at and 
--   the seat's section name, row, and seat number.


SELECT events.name, events.starts_at,  sections.name, seats.row, seats.number
  FROM customers
  INNER JOIN tickets
    ON customers.id = tickets.customer_id
  INNER JOIN events
    ON tickets.event_id = events.id
  INNER JOIN seats
    ON tickets.seat_id = seats.id
  INNER JOIN sections
    ON seats.section_id = sections.id
  WHERE customers.email = 'gennaro.rath@mcdermott.co';


--                                Table "public.tickets"
--    Column    |  Type   | Collation | Nullable |               Default
-- -------------+---------+-----------+----------+-------------------------------------
--  id          | integer |           | not null | nextval('tickets_id_seq'::regclass)
--  event_id    | integer |           | not null |
--  seat_id     | integer |           | not null |
--  customer_id | integer |           | not null |
-- Indexes:
--     "tickets_pkey" PRIMARY KEY, btree (id)
--     "tickets_event_id_seat_id_unique" UNIQUE CONSTRAINT, btree (event_id, seat_id)
-- Foreign-key constraints:
--     "tickets_customer_id_fkey" FOREIGN KEY (customer_id) REFERENCES customers(id)
--     "tickets_event_id_fkey" FOREIGN KEY (event_id) REFERENCES events(id)
--     "tickets_seat_id_fkey" FOREIGN KEY (seat_id) REFERENCES seats(id)

-- ---    

--                                         Table "public.events"
--    Column   |            Type             | Collation | Nullable |              Default
-- ------------+-----------------------------+-----------+----------+------------------------------------
--  id         | integer                     |           | not null | nextval('events_id_seq'::regclass)
--  name       | text                        |           | not null |
--  starts_at  | timestamp without time zone |           | not null |
--  base_price | numeric(4,2)                |           | not null |
-- Indexes:
--     "events_pkey" PRIMARY KEY, btree (id)
--     "events_date_key" UNIQUE CONSTRAINT, btree (starts_at)
-- Referenced by:
--     TABLE "tickets" CONSTRAINT "tickets_event_id_fkey" FOREIGN KEY (event_id) REFERENCES events(id)

-- 6. Write a query that returns the 
  -- user id, email address, and number of events 
        # customers, tickets
        # customers.id, customers.email, customers.phone, 
        # tickets.customer_id
  -- for all customers that have purchased tickets to three events.

  SELECT customers.id, customers.email, COUNT(DISTINCT tickets.event_id)
    FROM customers
    INNER JOIN tickets
      ON customers.id = tickets.customer_id
    GROUP BY customers.id
  HAVING COUNT(DISTINCT tickets.event_id) = 3
  ORDER BY COUNT(DISTINCT tickets.event_id) DESC;


-- -- 5 Write a query that returns 
--   the name of each event and   # event.name, distinct
--   how many tickets were sold for it,   # tickets
--   in order from most popular to least popular.

SELECT events.name, tickets.id
FROM tickets
LEFT OUTER JOIN events
ON tickets.event_id = events.id
LIMIT 10;

SELECT events.name AS event, COUNT(tickets.id) AS tickets
FROM tickets
LEFT OUTER JOIN events
ON tickets.event_id = events.id
GROUP BY event
ORDER BY tickets DESC;






-- 4 Write a query that determines what percentage of the customers in the database have purchased a ticket to one or more of the events.

distinct ticket buyers (1652) /  customers (10,000)

SELECT COUNT(DISTINCT customer_id) AS total_orders, COUNT(DISTINCT customers.id) AS total_customers
FROM customers
LEFT OUTER JOIN tickets ON customers.id = tickets.customer_id;

-- final
SELECT ROUND( COUNT(DISTINCT customer_id) 
            / COUNT(DISTINCT customers.id)::decimal * 100, 
            2) 
        AS percent
FROM customers
LEFT OUTER JOIN tickets 
  ON customers.id = tickets.customer_id;




-- total customer records: 10,000
SELECT COUNT(id) FROM customers;

How many different customers purchased tickets to at least one event.

SELECT COUNT(DISTINCT customer_id) FROM tickets; -- 1652


Write a query that determines how many tickets have been sold.


SELECT COUNT(id) FROM tickets;  -- 3783