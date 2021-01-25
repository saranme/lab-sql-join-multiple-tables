/*
Lab | SQL Joins on multiple tables
In this lab, you will be using the Sakila database of movie rentals.

Instructions
Write a query to display for each store its store ID, city, and country.
Write a query to display how much business, in dollars, each store brought in.
What is the average running time of films by category?
Which film categories are longest?
Display the most frequently rented movies in descending order.
List the top five genres in gross revenue in descending order.
Is "Academy Dinosaur" available for rent from Store 1?
*/
Use sakila;
-- 1 Write a query to display for each store its store ID, city, and country.
SELECT s.store_id, c.city_id, c.city, c.country_id, co.country
FROM store s
JOIN address a
ON s.address_id = s.address_id
JOIN city c
ON c.city_id = a.city_id
JOIN country co
ON c.country_id = co.country_id
ORDER BY country;

-- 2 Write a query to display how much business, in dollars, each store brought in.
SELECT c.store_id, SUM(p.amount) total_brought_in
FROM customer c
JOIN payment p
ON c.customer_id = p.customer_id
GROUP BY 1;

-- 3 What is the average running time of films by category?
SELECT round(AVG(f.length),2) avg_length, c.name category
FROM film f
JOIN film_category fc
ON f.film_id = fc.film_id
JOIN category c
ON fc.category_id = c.category_id
GROUP BY 2
ORDER BY 1 DESC;

-- 4 Which film categories are longest?
SELECT SUM(f.length) avg_length, c.name category
FROM film f
JOIN film_category fc
ON f.film_id = fc.film_id
JOIN category c
ON fc.category_id = c.category_id
GROUP BY 2
ORDER BY 1 DESC;

-- 5 Display the most frequently rented movies in descending order.
SELECT COUNT(f.film_id), f.film_id, f.title 
FROM film f
LEFT JOIN inventory i
ON f.film_id = i.film_id
JOIN rental r
ON r.inventory_id = i.inventory_id
GROUP BY 2,3
ORDER BY 1 DESC;

-- 6 List the top five genres in gross revenue in descending order.
SELECT c.category_id, c.name category, SUM(amount) revenue
FROM category c
JOIN film_category fc
ON c.category_id = fc.category_id
JOIN inventory i
ON i.film_id = fc.film_id
JOIN rental r
ON r.inventory_id = i.inventory_id
JOIN payment p
ON p.customer_id = r.customer_id
GROUP BY 1,2
ORDER BY revenue DESC
LIMIT 5;

-- Is "Academy Dinosaur" available for rent from Store 1?
SELECT r.rental_date, r.return_date, r.last_update, r.inventory_id
FROM film f
LEFT JOIN inventory i 
ON i.film_id = f.film_id
JOIN rental r
ON r.inventory_id = i.inventory_id
WHERE f.title = 'ACADEMY DINOSAUR' AND i.store_id = 1
ORDER BY 3 DESC
-- Yes, it is availbalbe the ones that have inventory_id 2,3,4.

