-- id: a unique serial number that auto-increments and serves as a primary key for this table.
-- name: the name of the star,e,g., "Alpha Centauri A". Allow room for 25 characters. Must be unique and non-null.
-- distance: the distance in light years from Earth. Define this as a whole number (e.g., 1, 2, 3, etc) that must be non-null and greater than 0.
-- spectral_type: the spectral type of the star: O, B, A, F, G, K, and M. Use a one character string.
-- companions: how many companion stars does the star have? A whole number will do. Must be non-null and non-negative.
CREATE TABLE stars (
  id serial PRIMARY KEY, 
  name varchar(25) UNIQUE NOT NULL, 
  distance integer NOT NULL CHECK (distance > 0), 
  spectral_type char(1),
  companions integer NOT NULL CHECK (companions >= 0)
);

-- planets table
-- id: a unique serial number that auto-increments and serves as a primary key for this table.
-- designation: a single alphabetic character that uniquely identifies the planet in its star system ('a', 'b', 'c', etc.)
-- mass: estimated mass in terms of Jupiter masses; use an integer for this value.

CREATE TABLE planets(
  id serial PRIMARY KEY,
  designation char(1) UNIQUE,
  mass integer
);

--  add a star_id column to the planets table; 
-- this column will be used to relate each planet in the planets table to its home star in the stars 

ALTER TABLE planets
ADD COLUMN star_id integer NOT NULL REFERENCES stars (id);

-- ALTER TABLE planets
-- ADD FOREIGN KEY (star_id) REFERENCES stars(id);

-- ALTER TABLE planets
-- DROP COLUMN star_id;


-- Hmm... it turns out that 25 characters isn't enough room to store a star's complete name. 
-- Modify the column so that it allows star names as long as 50 characters.

ALTER TABLE stars
ALTER COLUMN name TYPE varchar(50);

-- Modify the distance column in the stars table so that 
-- it allows fractional light years to any degree of precision required.

ALTER TABLE stars
ALTER COLUMN distance TYPE numeric;

-- Add a constraint to the table stars that will enforce the requirement that 
--   a row must hold one of the 7 listed values above.
--   'O', 'B', 'A', 'F', 'G', 'K', and 'M'.
-- Also, make sure that a value is required for this column.

ALTER TABLE stars
ALTER COLUMN spectral_type SET NOT NULL,
ADD CHECK (spectral_type IN ('O', 'B', 'A', 'F', 'G', 'K', 'M'));


-- Modify the stars table to 
--   remove the CHECK constraint on the spectral_type column, and 
-- modify the spectral_type column so it becomes an enumerated type 
--   that restricts it to one of the following 7 values: 'O', 'B', 'A', 'F', 'G', 'K', and 'M'.

CREATE TYPE spectral_type_enum AS ENUM ('O', 'B', 'A', 'F', 'G', 'K', 'M');

ALTER TABLE stars
DROP CONSTRAINT stars_spectral_type_check, 
ALTER COLUMN spectral_type TYPE spectral_type_enum USING spectral_type::spectral_type_enum;


-- Modify the mass column in the planets table so that it allows fractional masses to any degree of precision required. 
-- In addition, make sure the mass is required and positive.
-- While we're at it, also make the designation column required.

ALTER TABLE planets
ALTER COLUMN mass TYPE numeric,
ALTER COLUMN mass SET NOT NULL,
ALTER COLUMN designation SET NOT NULL,
ADD CHECK (mass > 0);


-- Add a semi_major_axis column to planets
-- Use a data type of numeric, 
-- require that each planet have a value for the semi_major_axis.

ALTER TABLE planets
ADD COLUMN semi_major_axis numeric NOT NULL;


-- add table: moons
-- id: a unique serial number that auto-increments and serves as a primary key for this table.
-- designation:  moon designations will be numbers, with the first moon discovered for each planet being moon 1, the second moon being moon 2, etc. The designation is required.
-- semi_major_axis: This field must be a number greater than 0, but is not required; it may take some time before we are able to measure moon-to-planet distances in extrasolar systems.
-- mass: This field must be a numeric value greater than 0, but is not required.
-- Make sure you also specify any foreign keys necessary to tie each moon to other rows in the database.

CREATE TABLE moons (
  id serial PRIMARY KEY, 
  designation integer NOT NULL CHECK (designation > 0),
  semi_major_axis numeric CHECK (semi_major_axis > 0),
  mass numeric CHECK (mass > 0),
  planet_id integer NOT NULL REFERENCES planets (id)
);

