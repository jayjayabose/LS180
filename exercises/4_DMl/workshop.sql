-- One table should be called devices. 

-- Includes a primary key called id that is auto-incrementing.
-- A column called name, that can contain a String. It cannot be NULL.
-- A column called created_at that lists the date this device was created. 
--   It should be of type timestamp and 
--   it should also have a default value related to when a device is created.

CREATE TABLE devices (
  id serial PRIMARY KEY,
  name text NOT NULL,
  created_at timestamp DEFAULT CURRENT_TIMESTAMP
);

-- Table parts
-- An id which auto-increments and acts as the primary key
-- A part_number. This column should be unique and not null.
-- A foreign key column called device_id. This will be used to associate various parts with a device.

CREATE TABLE parts (
  id serial PRIMARY KEY,
  part_number integer UNIQUE NOT NULL,
  device_id integer REFERENCES devices (id)
);

-- add two devices
-- "Accelerometer".  3 parts
-- "Gyroscope".  5 partss

-- The part numbers may be any number between 1 and 10000. 
-- There should also be 3 parts that don't belong to any device yet.

INSERT INTO devices (name) 
VALUES 
  ('Accelerometer'), 
  ('Gyroscope');

INSERT INTO parts (part_number, device_id) 
VALUES 
  (12, 1),
  (14, 1),
  (16, 1),
  (31, 2),
  (33, 2),
  (35, 2),
  (37, 2),
  (39, 2);

INSERT INTO parts (part_number) 
VALUES 
  (50),
  (54), 
  (58);

-- display all devices along with all the parts that make them up. 
-- We only want to display the name of the devices. Its parts should only display the part_number.

SELECT devices.name, parts.part_number
FROM devices
INNER JOIN parts ON devices.id = parts.device_id;

-- We want to grab all parts that have a part_number that starts with 3. 
-- Write a SELECT query to get this information. This table may show all attributes of the parts table.

-- SELECT * FROM parts WHERE part_number / 10 = 3; -- only works for current data set
SELECT * FROM parts WHERE part_number::text LIKE '3%';  -- works for all values 1  to 10,000
SELECT * FROM parts WHERE CAST (part_number AS text) LIKE '3%'; --- also works


-- Write an SQL query that returns a result table with the name of each device in our database together with the number of parts for that device.

SELECT devices.name, count(parts.device_id) AS number_of_parts
FROM devices
LEFT OUTER JOIN parts
ON devices.id = parts.device_id
GROUP BY devices.name
ORDER BY devices.name DESC;


-- Write two SQL queries:

-- One that generates a listing of parts that currently belong to a device.
-- One that generates a listing of parts that don't belong to a device.
-- Do not include the id column in your queries

SELECT part_number, device_id
FROM parts
WHERE device_id IS NOT NULL;

SELECT part_number, device_id
FROM parts
WHERE device_id IS NULL;

-- Assuming nothing about the existing order of the records in the database, 
-- write an SQL statement that will return the name of the oldest device from our devices table.
INSERT INTO devices (name) VALUES ('Magnetometer');
INSERT INTO parts (part_number, device_id) VALUES (42, 3);

SELECT name AS oldest_device
FROM devices
ORDER BY created_at DESC
LIMIT 1;

-- We've realized that the last two parts we're using for device number 2, "Gyroscope", actually belong to an "Accelerometer". 
-- Write an SQL statement that will associate the last two parts from our parts table with an "Accelerometer" instead of a "Gyroscope".

UPDATE parts
SET device_id = 1
WHERE id = 38 or id = 39;

UPDATE parts
SET device_id = 1
WHERE part_number in (
  SELECT part_number
  FROM parts
  ORDER BY part_number
  LIMIT 1
);

-- Our workshop has decided to not make an Accelerometer after all.
--  Delete any data related to "Accelerometer", this includes the parts associated with an Accelerometer.

DELETE 
FROM parts
WHERE device_id = 1;

DELETE 
FROM devices
WHERE name = 'Accelerometer';