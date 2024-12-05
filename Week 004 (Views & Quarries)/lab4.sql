--create a view that displays movies with a rating greater than 9 and lists then from lowest to highest rating
CREATE VIEW high_rated_movies AS
SELECT movieName, movieRating, moviePrice
FROM movie
WHERE movieRating >= 9
ORDER BY movieRating ASC;

SELECT * FROM high_rated_movies;

--create a view that displays customer info from customer table and payment info from payment table
CREATE VIEW customer_payment_info AS
SELECT c.customerID, c.firstName, c.lastName, p.billingAddress, p.cardHolderName
FROM customer c
JOIN payment p ON c.customerID = p.customerID;

SELECT * FROM customer_payment_info; 



--create a view that collects all movies with a price less than $12
CREATE VIEW movies_under_12 AS
SELECT movieID, movieName, moviePrice
FROM movie
WHERE moviePrice < 12;

SELECT * FROM movies_under_12;


--create a view that sorts movies based on price in ascending order
CREATE VIEW movies_price_ascending AS
SELECT movieID, movieName, moviePrice
FROM movie
ORDER BY moviePrice ASC;

SELECT * FROM movies_price_ascending;



--select distinct movie genres without repeating
SELECT DISTINCT movieGenre
FROM movie
ORDER BY movieGenre;

--create view that gets relevant information for customer billing
CREATE VIEW customer_billing_info AS
SELECT
	c.firstName,
	c.lastName,
	p.billingAddress,
	m.subscriptionCharge
FROM
	customer c
JOIN
	payment p ON c.customerID = p.customerID
JOIN
	membership m ON c.customerID = m.customerID;

--Select all from view
SELECT * FROM customer_billing_info;
