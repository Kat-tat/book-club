# Book Club Database

I created this database to keep track of the books we had read and restaurants we had visited as part of my book club. 

This was submitted as my final project for the Code First Girls Kickstarter Class Data & SQL.



## Contents

[Built With](https://github.com/Kat-tat/book-club/edit/main/README.md#built-with)

[Aims](https://github.com/Kat-tat/book-club/edit/main/README.md#aims)

[Diagrams](https://github.com/Kat-tat/book-club/edit/main/README.md#diagrams)

[Stored Function Examples](https://github.com/Kat-tat/book-club/edit/main/README.md#stored-function-examples)

[View Examples](https://github.com/Kat-tat/book-club/edit/main/README.md#view-examples)



### Built With

MySQL Workbench 8.0.36

### Aims

1. Create relational database of 6 tables to hold data about the books we were reading, the restaurants we were visiting and the members.
2. Use a subquery to update the books table with the average rating of the ratings from the member_ratings table.
3. Create [stored functions](https://github.com/Kat-tat/book-club/edit/main/README.md#stored-function-examples) to show whether a member has read a book and whether a book is longer than average.
4. Create joins and [views](https://github.com/Kat-tat/book-club/edit/main/README.md#view-examples) to display information from my database in my presentation. 

### Diagram

![projectdiagram](https://github.com/Kat-tat/book-club/assets/168368191/9668604b-76e2-4a4c-a306-a253839e0ffd)

### Stored Function Examples

Has a member read a book?

```
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
```

Is a book longer than average?
```
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
```

### View Examples

Creating a view of the details of the member and book in the [stored function](https://github.com/Kat-tat/book-club/edit/main/README.md#stored-function-examples) has_read

```
CREATE VIEW hasread AS 
SELECT b.book_name, m.first_name, m.last_name, has_read(r.unfinished)
FROM member_ratings AS r
JOIN books AS b ON b.book_id = r.book_id
JOIN members AS m ON r.member_id = m.member_id
ORDER BY b.book_name ASC;
```

Creating a view of the full meeting details

```
CREATE VIEW full_meeting_details AS
SELECT m.meeting_id, m.date, b.book_name, r.restaurant_name
FROM meetings AS m
JOIN books AS b ON m.book_id = b.book_id
JOIN restaurants AS r ON r.restaurant_id = m.restaurant_id;
```

