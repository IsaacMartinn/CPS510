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

--return price
SELECT moviePrice FROM movie where movieid = 10;

--return movies with price 10.99
SELECT movieName
FROM MOVIE
WHERE moviePrice = 10.99;

