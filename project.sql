CREATE DATABASE book_club;

USE book_club;

#Create tables

CREATE TABLE meetings (
meeting_id INT PRIMARY KEY AUTO_INCREMENT,
date DATE,
book_id INT,
restaurant_id INT
);

CREATE TABLE books (
book_id INT PRIMARY KEY AUTO_INCREMENT,
book_name VARCHAR(20),
author VARCHAR(20),
genre VARCHAR(20),
average_rating FLOAT(2),
member_choosing INT,
pages INT
);

CREATE TABLE members (
member_id INT PRIMARY KEY AUTO_INCREMENT,
first_name VARCHAR (20),
last_name VARCHAR (20),
vegan BOOLEAN
);

CREATE TABLE meals (
meal_id INT PRIMARY KEY AUTO_INCREMENT,
member_id INT,
restaurant_id INT,
starter VARCHAR (20),
main VARCHAR (20),
dessert VARCHAR (20),
price FLOAT (2)
);

CREATE TABLE restaurants (
restaurant_id INT PRIMARY KEY AUTO_INCREMENT,
name VARCHAR (20),
location VARCHAR (20),
cuisine_type VARCHAR (20),
mocktails BOOLEAN
);

CREATE TABLE member_ratings (
member_id INT,
book_id INT,
rating FLOAT(2),
unfinished BOOLEAN
);

#Adding foreign keys

ALTER TABLE meetings ADD FOREIGN KEY (book_id) REFERENCES books (book_id);

ALTER TABLE meetings ADD FOREIGN KEY (restaurant_id) REFERENCES restaurants (restaurant_id);

ALTER TABLE books ADD FOREIGN KEY (member_choosing) REFERENCES members (member_id);

ALTER TABLE meals ADD FOREIGN KEY (member_id) REFERENCES members (member_id);

ALTER TABLE meals ADD FOREIGN KEY (restaurant_id) REFERENCES restaurants (restaurant_id);

ALTER TABLE member_ratings ADD FOREIGN KEY (book_id) REFERENCES books (book_id);


#wanted to add another column to books table 

ALTER TABLE books
ADD COLUMN fiction BOOLEAN;

ALTER TABLE books
MODIFY book_name VARCHAR(30);

#stored procedures insert data 

DELIMITER //
CREATE PROCEDURE insert_books(
IN book_name VARCHAR(30),
IN author VARCHAR (20),
IN genre VARCHAR (20),
IN average_rating FLOAT (2),
IN pages INT,
IN member_choosing INT, 
IN fiction BOOLEAN)
BEGIN
INSERT INTO books (book_name, author, genre, average_rating, pages, member_choosing, fiction) VALUES (book_name, author, genre, average_rating, pages, member_choosing, fiction);
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE insert_members(
IN first_name VARCHAR(20),
IN last_name VARCHAR (20),
IN vegan BOOLEAN)
BEGIN
INSERT INTO members (first_name, last_name, vegan) VALUES (first_name, last_name, vegan);
END //
DELIMITER ;

#Insert data

CALL insert_members('Kathryn', 'Tarrant', 0);
CALL insert_members('Vicki',' A', 0);
CALL insert_members('Jess', 'SB', 1);
CALL insert_members('Shelley', 'H', 0);

SELECT * FROM members;

SELECT * FROM books;

#update average rating using ratings from member_ratings table
#interesting subquery

UPDATE books AS bfull_meeting_detailsfull_meeting_details
SET b.average_rating =(
SELECT AVG(r.rating) FROM member_ratings AS r
WHERE b.book_id = r.book_id);

#joins to show full details of meeting

CREATE VIEW full_meeting_details AS
SELECT m.meeting_id, m.date, b.book_name, r.restaurant_name
FROM meetings AS m
JOIN books AS b ON m.book_id = b.book_id
JOIN restaurants AS r ON r.restaurant_id = m.restaurant_id;

#creating a stored function to see if book_name is longer than average

SELECT AVG(pages) FROM books;

DELIMITER //
CREATE FUNCTION longer_book(pages INT)
RETURNS VARCHAR(50) 
DETERMINISTIC
BEGIN
DECLARE result VARCHAR(50); 

IF pages  > 467 THEN
SET result = 'long';
ELSE
SET result = 'short';
END IF;
RETURN result;
END //

DELIMITER ;

CREATE VIEW longer_books AS
SELECT book_name, longer_book(pages) FROM books;

#trying a stored function to find out if member has read book - going to try and use a join to display

DELIMITER //
CREATE FUNCTION has_read(unfinished BOOLEAN)
RETURNS VARCHAR(50)
DETERMINISTIC
BEGIN
DECLARE result VARCHAR(50);

IF unfinished = 1 THEN
SET result = 'No';
ELSE 
SET result = 'Yes';
END IF;
RETURN result;
END //

DELIMITER ;

CREATE VIEW hasread AS 
SELECT b.book_name, m.first_name, m.last_name, has_read(r.unfinished)
FROM member_ratings AS r
JOIN books AS b ON b.book_id = r.book_id
JOIN members AS m ON r.member_id = m.member_id
ORDER BY b.book_name ASC;

CREATE VIEW book_ratings AS 
SELECT b.book_name, b.author, r.rating, m.first_name, m.last_name, b.average_rating, (r.rating - b.average_rating) AS rating_difference
FROM books AS b
JOIN member_ratings AS r ON r.book_id = b.book_id
JOIN members AS m ON m.member_id = r.member_id;

#creating a view and using it in a join

CREATE VIEW popular_genres AS
SELECT COUNT(genre), genre FROM books
GROUP BY genre
HAVING COUNT(genre) >= 2;

SELECT p.genre, b.book_name, b.author
FROM popular_genres AS p
JOIN books AS b ON p.genre= b.genre;



