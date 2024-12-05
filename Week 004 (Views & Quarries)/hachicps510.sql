--create movie store tables
CREATE TABLE movie(
    movieID INTEGER PRIMARY KEY NOT NULL,
    movieName VARCHAR(50) NOT NULL,
    moviePoster VARCHAR(100) NOT NULL,
    movieDirector VARCHAR(50) NOT NULL,
    movieDescription VARCHAR(50) NOT NULL,
    moviePrice FLOAT NOT NULL,
    movieRating INTEGER NOT NULL,
    movieGenre VARCHAR(50) NOT NULL
);

CREATE TABLE admin(
    adminUsername VARCHAR(50) PRIMARY KEY NOT NULL,
    adminEmail VARCHAR(50) NOT NULL UNIQUE,
    adminPassword VARCHAR(50) NOT NULL
  );

CREATE TABLE customer(
    customerID INT PRIMARY KEY,
    firstName VARCHAR(50) NOT NULL,
    lastName VARCHAR(50) NOT NULL,
    customerUsername VARCHAR(50) NOT NULL UNIQUE,
    customerPassword VARCHAR(50) NOT NULL,
    email VARCHAR(50) NOT NULL,
    customerBirthday VARCHAR(50) NOT NULL
);

CREATE TABLE payment(
    paymentID INT PRIMARY KEY,
    billingAddress VARCHAR(50) NOT NULL,
    cardHolderName VARCHAR(50) NOT NULL,
    customerID INT NOT NULL,
    CONSTRAINT customerIDFK FOREIGN KEY (customerID) REFERENCES customer(customerID)
);

CREATE TABLE membership(
    membershipID INT PRIMARY KEY,
    startDate DATE NOT NULL,
    endDate DATE NOT NULL,
    subscriptionCharge INT NOT NULL
);

--insert into tables

INSERT INTO movie (movieID, movieName, moviePoster, movieDirector, movieDescription, moviePrice, movieRating, movieGenre)
VALUES (1, 'Aladdin', 'https://originalvintagemovieposters.com/wp-content/uploads/2020/03/Aladdin-9002-scaled.jpg', 'Guy Ritchie', 'Aladdin, a kind thief, woos Jasmin, the princess', 10.99, 7, 'Family');

INSERT INTO movie (movieID, movieName, moviePoster, movieDirector, movieDescription, moviePrice, movieRating, movieGenre)
VALUES (10, 'CREED', 'https://image.tmdb.org/t/p/original/1BfTsk5VWuw8FCocAhCyqnRbEzq.jpg', 'Ryan Coogler', 'Boxing', 9.99, 10, 'Action');

INSERT INTO movie (movieID, movieName, moviePoster, movieDirector, movieDescription, moviePrice, movieRating, movieGenre)
VALUES (2, 'Avatar The Way Of The Water','https://dylancolestudio.com/movie-posters', 'James Cameron', 'Ex marine falls in love with the Navi culture',15, 9, 'Family');

INSERT INTO movie (movieID, movieName, moviePoster, movieDirector, movieDescription, moviePrice, movieRating, movieGenre)
VALUES (3,'The Jungle Book','https://dylancolestudio.com/movie-posters', 'Jon Favreau', 'An adventure story about a man-cub named Mowgli',10.99, 7, 'Family');

INSERT INTO admin (adminUsername, adminEmail, adminPassword)
VALUES ('admin1', 'admin1@moviestore.com', 'password123');

INSERT INTO admin (adminUsername, adminEmail, adminPassword)
VALUES ('admin2', 'admin2@moviestore.com', 'password123');


INSERT INTO customer (customerID, firstName, lastName, customerUsername, customerPassword, email, customerBirthday)
VALUES (1, 'John', 'Bosko', 'j_bosks', 'pass123', 'johnny@google.com', '2000-05-15');

INSERT INTO customer (customerID, firstName, lastName, customerUsername, customerPassword, email, customerBirthday)
VALUES (2, 'Jane', 'Doe', 'jane_mouse', 'password456', 'janey@yahoo.com', '2000-09-10');


INSERT INTO payment (paymentID, billingAddress, cardHolderName, customerID)
VALUES (1, '123 Elm Street', 'John Bosko', 1);

INSERT INTO payment (paymentID, billingAddress, cardHolderName, customerID)
VALUES (2, '456 Ronny Avenue', 'Jane Doe', 2);


INSERT INTO membership (membershipID, startDate, endDate, subscriptionCharge)
VALUES (1, '2024-01-01', '2025-01-01', 99);

INSERT INTO membership (membershipID, startDate, endDate, subscriptionCharge)
VALUES (2, '2024-02-15', '2025-02-15', 99);

--return movie with price = $10.00
SELECT moviePrice FROM movie where movieid = 10;

--return movies with price 10.99
SELECT movieName
FROM MOVIE
WHERE moviePrice = 10.99;

SELECT movieName, moviePrice FROM movie;

SELECT movieName FROM movie WHERE moviePrice < 12;

SELECT * FROM customer;

SELECT email FROM customer WHERE customerUsername = 'j_bosks';

SELECT paymentID, billingAddress, cardHolderName, customerID FROM payment;

SELECT movieName FROM movie WHERE movieRating >= 9;

SELECT COUNT(*) AS totalMovies FROM movie;

SELECT * FROM membership WHERE endDate > TO_DATE('2024-01-31', 'YYYY-MM-DD');

UPDATE movie
SET moviePrice = 12.99
WHERE movieName = 'Aladdin';

UPDATE customer
SET email = 'jd_boski@example.com'
WHERE customerUsername = 'j_bosks';

DELETE FROM movie
WHERE movieID = 3;

DELETE FROM movie
WHERE movieID = 3;

SELECT customerID FROM customer WHERE customerUsername = 'jane_mouse';

DELETE FROM payment
WHERE customerID = (SELECT customerID FROM customer WHERE customerUsername = 'jane_mouse');

DELETE FROM customer
WHERE customerUsername = 'jane_mouse';

