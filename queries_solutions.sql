-- How many albums are in the database? Tracks?
SELECT COUNT(*) FROM albums;
SELECT COUNT(*) FROM tracks;

SELECT 
	COUNT(DISTINCT(a.albumid)) AS album_count, 
	COUNT(t.trackid) AS track_count
FROM 
	albums a 
	JOIN tracks t 
		ON a.albumid = t.albumid;

-- Find all artists that start with "J"
SELECT name FROM artists WHERE name LIKE 'j%';

-- Find the title of every Blues track
SELECT genreid FROM genres WHERE name = 'Blues';
SELECT name FROM tracks WHERE genreid = 8;

SELECT name FROM tracks WHERE genreid = (
    SELECT genreid FROM genres WHERE name = 'Blues');
	
    -- ambiguous "name." Won't work!
SELECT name
FROM tracks JOIN genres
    ON tracks.genreid = genres.genreid
WHERE name = 'Blues';

SELECT tracks.name
FROM tracks JOIN genres
    ON tracks.genreid = genres.genreid
WHERE genres.name = 'Blues';

-- Add yourself (or someone else) as a new customer
INSERT INTO customers (FirstName, LastName, Email, City, State)
VALUES ('Joshua', 'Sacher', 'joshuasacher@g.harvard.edu', 'Cambridge', 'MA');


-- Change the new entry's phone number to 617-555-1212 (or the like)
UPDATE customers
SET Phone = '617-555-1212'
WHERE FirstName = 'Joshua' AND LastName = 'Sacher';

-- DELETE FROM customers WHERE FirstName = 'Joshua' AND LastName = 'Sacher';

-- What was the total for the largest invoice?
SELECT MAX(total) FROM invoices;

-- Which customer placed that order and what country are they from?
SELECT firstname,lastname, country 
FROM customers 
WHERE customerid = (
    SELECT customerid 
	FROM invoices 
	WHERE total = (
        SELECT MAX(total) FROM invoices));

SELECT firstname, lastname, country
FROM customers
    JOIN invoices ON customers.customerid = invoices.customerid
WHERE total = (
    SELECT MAX(total) FROM invoices);

-- What are the names of the tracks they purchased?
SELECT name 
FROM tracks 
WHERE trackid IN (
    SELECT trackid 
	FROM invoice_items 
	WHERE invoiceid = (
        SELECT invoiceid 
		FROM invoices 
		WHERE total = (
            SELECT MAX(total) FROM invoices
		)
	)
);

SELECT t.name 
FROM tracks t
    JOIN invoice_items ii ON t.trackid = ii.trackid
    JOIN invoices i ON ii.invoiceid = i.invoiceid
WHERE i.total = (SELECT MAX(total) FROM invoices);
