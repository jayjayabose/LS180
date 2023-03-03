CREATE DATABASE animals;

-- Make a table called birds. 
-- It should have the following fields:

-- id (a primary key)
-- name (string with space for up to 25 characters)
-- age (integer)
-- species (a string with room for no more than 15 characters)

CREATE TABLE birds(
  id serial PRIMARY KEY,
  name varchar(25),
  age integer,
  species varchar(15)
);

-- For this exercise, we'll add some data to our birds table. Add five records to this database so that our data looks like:
--  id |   name   | age | species
-- ----+----------+-----+---------
--   1 | Charlie  |   3 | Finch
--   2 | Allie    |   5 | Owl
--   3 | Jennifer |   3 | Magpie
--   4 | Jamie    |   4 | Owl
--   5 | Roy      |   8 | Crow
-- (5 rows)

INSERT INTO birds (name, age, species)
VALUES ('Charlie', 3, 'Finch'),
  ('Allie', 5, 'Owl'),
  ('Jennifer', 3, 'Magpie'),
  ('Jamie', 4, 'Owl'),
  ('Roy', 8, 'Crow');

-- Write an SQL statement to query all data that is currently in our birds table.
-- SELECT * from birds;

--  Using a WHERE clause, SELECT records for birds under the age of 5.
-- SELECT * from birds
-- WHERE age < 5;

-- Update the birds table so that the rows with a species of 'Crow' now read 'Raven'.

UPDATE birds SET species = 'Raven'
  WHERE species = 'Crow';

-- Oops. Jamie isn't an Owl - he's a Hawk. Correct his information.
UPDATE birds SET species = 'Hawk'
  WHERE id = 4;

-- Write an SQL statement that deletes the record that describes a 3 year-old finch.
DELETE FROM birds
WHERE species = 'Finch' and age = 3;

-- For this exercise, write some code that ensures that only birds with a positive age may be added to the database. 
-- Then write and execute an SQL statement to check that this new constraint works correctly.

ALTER TABLE birds
ADD CONSTRAINT check_age
CHECK (age > 0);

-- Write an SQL statement that will drop the birds table and all its data from the animals database.
-- DROP TABLE birds;

--  Write a SQL statement or PostgreSQL command to drop the animals database.
-- DROP DATABASE animals
-- $ dropdb animals




CREATE TABLE flights (
  id serial,
  flight_code varchar(8) NOT NULL,
  departure_airport varchar(40),
  arrival_airport varchar(40),
  departure_date date,
  arrival_date date,
  departure_time time,
  arrival_time time,
  airline_id int
);

ALTER TABLE flights
ADD PRIMARY KEY (id);