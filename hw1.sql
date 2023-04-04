-- Simon Dutton
-- Due: April 4, 2023
-- First SQL project
-- Week 4, Day 1

--1. How many actors are there with the last name ‘Wahlberg’? 
-- ANSWER: 2

-- RETURNS count of items where last name is Wahlberg
SELECT COUNT(last_name)
FROM actor
WHERE last_name = 'Wahlberg';

-- RETURNS table of items where last name is Wahlburg
-- 2 items in table
SELECT last_name
FROM actor
WHERE last_name = 'Wahlberg';
 
--2. How many payments were made between $3.99 and $5.99? 
-- ANSWER: 0

-- RETURNS count of items where payments are between 3.99 and 5.99
SELECT COUNT(amount)
FROM payment
WHERE amount >= 3.99 AND amount <= 5.99;

-- RETURNS a table of all amounts where payments are between 3.99 and 5.99
-- no data because no items fit this qualification
SELECT amount
FROM payment
WHERE amount >= 3.99 AND amount <= 5.99;
 
--3. What film does the store have the most of? (search in inventory) 
-- ANSWER: there are 72 movies tied for first, so I will not list them all here

-- RETURNS title and id for movies with the most copies
-- 72 items in list, so 72 items tied for first place
SELECT title, film_id
FROM film
WHERE film_id IN (
    SELECT film_id 
    FROM inventory 
    GROUP BY film_id 
    HAVING COUNT(film_id) = (
        SELECT MAX(c) 
        FROM (
            SELECT COUNT(film_id) AS c
            FROM inventory
            GROUP BY film_id
        ) AS max
    ) ORDER BY film_id
);

-- RETURNS the number of films with the most copies
SELECT COUNT(film_id)
FROM film
WHERE film_id IN (
    SELECT film_id 
    FROM inventory 
    GROUP BY film_id 
    HAVING COUNT(film_id) = (
        SELECT MAX(c) 
        FROM (
            SELECT COUNT(film_id) AS c
            FROM inventory
            GROUP BY film_id
        )
    AS max) 
    ORDER BY film_id
);

-- RETURNS a table of film_ids which have the highest count
-- the highest count is 8
SELECT film_id, COUNT(film_id)
FROM inventory 
GROUP BY film_id 
HAVING COUNT(film_id) = (
    SELECT MAX(c) 
    FROM (
        SELECT COUNT(film_id) AS c
        FROM inventory
        GROUP BY film_id
    ) AS max
) ORDER BY film_id;
 
--4. How many customers have the last name ‘William’? 
-- ANSWER: 0

-- RETURNS count of the number of customers with the last name William
SELECT COUNT(last_name)
FROM customer
WHERE last_name = 'William';

-- RETURNS a table of the customers with the last name William
-- returns No Data because there are none
SELECT last_name
FROM customer
WHERE last_name = 'William';
 
 
--5. What store employee (get the id) sold the most rentals? 
-- ANSWER: EMPLOYEE # 1 (Mike Hillyer) sold 8040 copies

-- RETURNS how many rentals each staff sold
-- EMPLOYEE #1 sold 8040 which is the most
SELECT staff_id, COUNT(staff_id)
FROM rental
GROUP BY staff_id;

-- RETURNS the staff who sold the most, and how many they sold
-- EMPLOYEE # 1 sold 8040 copies
SELECT staff_id, COUNT(staff_id)
FROM rental
GROUP BY staff_id
HAVING COUNT(staff_id) = 
(SELECT MAX(max.count)
FROM (SELECT staff_id, COUNT(staff_id) AS count
        FROM rental GROUP BY staff_id)max);

-- RETURNS the name of the staff member who sold the most copies
-- Mike Hillyer is the name of employee #1
SELECT first_name, last_name, staff_id
FROM staff 
WHERE staff_id = (
    SELECT staff_id
    FROM rental
    GROUP BY staff_id
    HAVING COUNT(staff_id) = (
        SELECT MAX(max.count)
        FROM (
            SELECT staff_id, COUNT(staff_id) AS count
            FROM rental 
            GROUP BY staff_id
        )
    max)
);
 
 
--6. How many different district names are there? 
-- ANSWER: 378

-- RETURNS count of distinct districts
SELECT COUNT(DISTINCT district)
FROM address;

-- RETURNS table of distinct districts
-- 378 items in table
SELECT DISTINCT district
FROM address;

-- RETURNS districts with how many times they are used
-- this eliminates duplicates
-- 378 districts in the list
SELECT district, COUNT(district)
FROM address
GROUP BY district
ORDER BY district;
 
 
--7. What film has the most actors in it? (use film_actor table and get film_id) 
-- ANSWER: Film #508, Lambs Cincinatti, has 15 actors

-- RETURNS the film_ids sorted by how many actors they have (DESC)
-- topmost item is film_id # 508 with 15 actors
SELECT film_id, COUNT(actor_id)
FROM film_actor
GROUP BY film_id
ORDER BY COUNT(actor_id) DESC;

-- RETURNS just the film_id with the highest number of actors
-- film_id # 508 has 15 actors
SELECT film_id, COUNT(actor_id)
FROM film_actor
GROUP BY film_id
HAVING COUNT(actor_id) = (
    SELECT MAX(max.count)
    FROM (
        SELECT film_id, COUNT(actor_id) AS count
        FROM film_actor 
        GROUP BY film_id
    )
max);

-- RETURNS the title and film_id of the film with the highest number of actors
-- Lambs Cincinatti, film id #508
SELECT title, film_id
FROM film 
WHERE film_id = (
    SELECT film_id
    FROM film_actor
    GROUP BY film_id
    HAVING COUNT(actor_id) = (
        SELECT MAX(max.count)
        FROM (
            SELECT film_id, COUNT(actor_id) AS count
            FROM film_actor 
            GROUP BY film_id
        )
    max)
);

 
--8. From store_id 1, how many customers have a last name ending with ‘es’? (use customer table) 
-- ANSWER: 13

-- RETURNS the count of last names ending with 'es'
SELECT COUNT(last_name)
FROM customer
WHERE store_id=1 AND last_name LIKE '%es'

-- RETURNS a table of last names ending with 'es'
-- There are 13 items in the table
SELECT last_name
FROM customer
WHERE store_id=1 AND last_name LIKE '%es'

-- RETURNS a table of last names ending with 'es'
-- still shows booleans, but only the ones that are TRUE
SELECT last_name, last_name LIKE '%es'
FROM customer
WHERE store_id=1 AND last_name LIKE '%es';

 
--9. How many payment amounts (4.99, 5.99, etc.) had a number of rentals above 
-- 250 for customers with ids between 380 and 430? (use group by and having > 250) 
-- ANSWER: 11 payment amounts

-- RETURNS 11 (counts up how many payment amounts)
SELECT COUNT(count)
FROM (
    SELECT amount, COUNT(c)
    FROM (
        SELECT DISTINCT amount, customer_id
        FROM payment AS c
        GROUP BY customer_id, amount
        HAVING customer_id >= 380 AND customer_id <= 430
        ORDER BY customer_id) c
    GROUP BY amount
) count;


-- RETURNS all payment amounts and their individual counts
-- There are 11 items in the table, so 11 payment amounts
SELECT amount, COUNT(c)
FROM (
    SELECT DISTINCT amount, customer_id
    FROM payment AS c
    GROUP BY customer_id, amount
    HAVING customer_id >= 380 AND customer_id <= 430
    ORDER BY customer_id) c
GROUP BY amount;

 
--10.  Within the film table, how many rating categories are there? 
--ANSWER: 5

-- RETURNS the count of distinct ratings
SELECT COUNT(DISTINCT rating)
FROM film;

-- RETURNS a table of all the distinct ratings.
--There are 5 elements in the table
SELECT DISTINCT rating
FROM film;

--And what rating has the most movies total? 
-- ANSWER: PG-13

-- RETURNS the rating with the most movies
SELECT rating
FROM film
GROUP BY rating
HAVING COUNT(rating)= (
    SELECT MAX(max.count)
    FROM (
        SELECT rating, COUNT(rating) AS count
        FROM film 
        GROUP BY rating
    )
max);

--RETURNS a list of ratings and how many movies they each have
-- Sorted by highest # of movies at the top
--PG-13 is at the top of the list, with the most movies
SELECT rating, MAX(max.count)
FROM (
    SELECT rating, COUNT(rating) AS count
    FROM film 
    GROUP BY rating
)max
GROUP BY rating
ORDER BY MAX(max.count) DESC;