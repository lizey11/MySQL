Use Sakila;
show tables;
SELECT * FROM actor;
#1a. Display the first and last names of all actors from the table `actor`.
 
SELECT first_name, last_name FROM actor;
#1b. Display the first and last name of each actor in a single column in upper case letters. Name the column `Actor Name`.

SELECT UPPER(CONCAT(first_name," ",last_name))
as Actor_Name FROM actor;

# 2a. You need to find the ID number, first name, and last name of an actor, of whom you know only the first name, "Joe." What is one query would you use to obtain this information?
SELECT actor_id, first_name, last_name FROM actor
WHERE first_name = 'Joe';
    
# 2b. Find all actors whose last name contain the letters `GEN`:
SELECT actor_id, first_name, last_name 
FROM actor WHERE INSTR(`last_name`, 'Gen');

# 2c. Find all actors whose last names contain the letters `LI`. This time, ORDER the rows BY last name and first name, in that ORDER:
SELECT actor_id, first_name, last_name FROM actor WHERE INSTR(`last_name`, 'Li')
ORDER BY last_name, first_name;
    
# 2d. Using `IN`, display the `country_id` and `country` columns of the following COUNTries: Afghanistan, Bangladesh, and China:
SELECT country_id, country FROM country
WHERE country IN ('Afghanistan', 'Bangladesh', 'China');
    
# 3a. Add a `middle_name` column to the table `actor`. Position it between `first_name` and `last_name`. Hint: you will need to specify the data type.
ALTER TABLE actor
	ADD COLUMN middle_name VARCHAR(20) AFTER first_name;
	SELECT * FROM actor;
    
# 3b. You realize that some of these actors have tremendously long last names. Change the data type of the `middle_name` column to `blobs`.
ALTER TABLE actor
	DROP middle_name,
	ADD COLUMN middle_name BLOB AFTER first_name;
	SELECT * FROM actor;
    
# 3c. Now delete the `middle_name` column.
ALTER TABLE actor
	DROP middle_name;
	SELECT * FROM actor;
    
# 4a. List the last names of actors, as well as how many actors have that last name.
SELECT last_name, 
	COUNT(last_name) as CNT
	FROM actor 
	GROUP BY last_name;

# 4b. List last names of actors and the number of actors who have that last name, but only for names that are shared BY at least two actors
SELECT last_name, 
	COUNT(last_name) as CNT
	FROM actor
	GROUP BY last_name
	Having COUNT(*) >=2;

# 4c. Oh, no! The actor `HARPO WILLIAMS` was accidentally entered in the `actor` table as `GROUCHO WILLIAMS`, the name of Harpo's second cousin's husband's yoga teacher. Write a query to fix the record.
UPDATE actor
	SET first_name = 'HARPO'
	WHERE first_name = 'GROUCHO' AND last_name = 'Williams';
	SELECT * FROM actor
    WHERE last_name = 'Williams';

#4d. Perhaps we were too hasty in changing `GROUCHO` to `HARPO`. It turns out that `GROUCHO` was the correct name after all! In a single query, if the first name of the actor is currently `HARPO`, change it to `GROUCHO`. Otherwise, change the first name to `MUCHO GROUCHO`, as that is exactly what the actor will be with the grievous error. BE CAREFUL NOT TO CHANGE THE FIRST NAME OF EVERY ACTOR TO `MUCHO GROUCHO`, HOWEVER! (Hint: update the record using a unique identifier.)
UPDATE actor SET first_name = CASE 
WHEN first_name = 'GROUCHO' AND last_name = 'Williams' THEN 'MUCHO GROUCHO' 
WHEN first_name = 'HARPO' AND last_name = 'Williams' THEN 'GROUCHO'
ELSE first_name
END
WHERE last_name = 'Williams';

# 5a. You cannot locate the schema of the `address` table. Which query would you use to re-create it?
SHOW CREATE TABLE sakila.address;

-- CREATE TABLE `address` (
--   `address_id` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
--   `address` varchar(50) NOT NULL,
--   `address2` varchar(50) DEFAULT NULL,
--   `district` varchar(20) NOT NULL,
--   `city_id` smallint(5) unsigned NOT NULL,
--   `postal_code` varchar(10) DEFAULT NULL,
--   `phone` varchar(20) NOT NULL,
--   `location` geometry NOT NULL,
--   `last_update` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
--   PRIMARY KEY (`address_id`),
--   KEY `idx_fk_city_id` (`city_id`),
--   SPATIAL KEY `idx_location` (`location`),
--   CONSTRAINT `fk_address_city` FOREIGN KEY (`city_id`) REFERENCES `city` (`city_id`) ON UPDATE CASCADE
-- ) ENGINE=InnoDB AUTO_INCREMENT=606 DEFAULT CHARSET=utf8

-- 6a. Use JOIN to display the first and last names, as well as the address, of each staff member. Use the 
-- tables staff and address:

SELECT first_name, last_name, address
FROM staff s
INNER JOIN address a
ON s.address_id = a.address_id;

# 6b. Use `JOIN` to display the total amount rung up BY each staff member in August of 2005. Use tables `staff` and `payment`. 
SELECT username, Sum(amount) FROM staff
	JOIN(payment) ON staff.staff_id=payment.staff_id 	
	WHERE payment_date BETWEEN '2005-08-01 00:00:00' and '2005-09-01 00:00:00' 
	GROUP BY username;

# 6c. List each film and the number of actors who are listed for that film. Use tables `film_actor` and `film`. Use inner JOIN.
SELECT title, COUNT(*) AS Number_of_Actors FROM film
	JOIN film_actor ON film.film_id = film_actor.film_id
	GROUP BY title;
    
# 6d. How many copies of the film `Hunchback Impossible` exist in the inventory system?
SELECT title, COUNT(inventory_id) FROM inventory JOIN(film) ON inventory.film_id=film.film_id
	WHERE title = 'Hunchback Impossible'
	GROUP BY title;
 
# 6e. Using the tables `payment` and `customer` and the `JOIN` command, list the total paid BY each customer. List the customers alphabetically BY last name:
SELECT first_name, last_name, SUM(amount) FROM customer JOIN(payment) ON customer.customer_id=payment.customer_id
	GROUP BY first_name, last_name
    ORDER BY last_name DESC;

# 7a. The music of Queen and Kris KristoffersON have seen an unlikely resurgence. As an unintended consequence, films starting with the letters `K` and `Q` have also soared in popularity. Use subqueries to display the titles of movies starting with the letters `K` and `Q` whose language is English. 
SELECT title, name FROM film JOIN(language) ON film.language_id=language.language_id
	WHERE name = 'English' AND title LIKE 'k%' or title LIKE 'q%';

#        or

SELECT title
FROM film
WHERE title LIKE 'k%' or title LIKE 'q%' AND language_id in
(
SELECT language_id
FROM language    
WHERE name = 'English'
);
    

# 7b. Use subqueries to display all actors who appear in the film `Alone Trip`.
SELECT title, first_name, last_name FROM actor JOIN(film_actor) ON actor.actor_id = film_actor.actor_id
	JOIN(film) ON film_actor.film_id=film.film_id
    WHERE title ='ALONE TRIP';
    
#        or

SELECT first_name, last_name
FROM actor
WHERE actor_id IN
(
SELECT actor_id
FROM film_actor
WHERE film_id IN
(
SELECT film_id
FROM film
WHERE title ='ALONE TRIP' 
));

# 7c. You want to run an email marketing campaign in Canada, for which you will need the names and email addresses of all Canadian customers. Use JOINs to retrieve this information.
SELECT first_name, last_name, email FROM customer 
	JOIN(address) ON customer.address_id=address.address_id
    JOIN(city) ON address.city_id=city.city_id
    JOIN(country) ON city.country_id=country.country_id
	WHERE country='Canada';
     
#        or

SELECT first_name, last_name, email
FROM customer
WHERE address_id IN
(
SELECT address_id
FROM address
WHERE city_id IN
(
SELECT city_id
FROM city
WHERE country_id IN
(
SELECT country_id
FROM country
WHERE country='Canada'
)));

# 7d. Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as famiy films.
SELECT title, name AS Genre FROM film_category
	JOIN(category) ON category.category_id=film_category.category_id
	JOIN(film) ON film.film_id=film_category.film_id
	WHERE name='family';

# 7e. Display the most frequently rented movies in DESCending ORDER.
SELECT title, COUNT(*) FROM payment
	JOIN rental ON payment.rental_id=rental.rental_id
	JOIN inventory ON rental.inventory_id=inventory.inventory_id
	JOIN film ON inventory.film_id=film.film_id
	GROUP BY title
	ORDER BY COUNT(*) DESC;
		
# 7f. Write a query to display how much business, in dollars, each store brought in.
SELECT store_id, concat('$',format(SUM(amount),2)) AS USD FROM staff 
	JOIN payment ON staff.staff_id=payment.staff_id
	GROUP BY store_id;

# 7g. Write a query to display for each store its store ID, city, and country.
SELECT store_id, city, country FROM staff
	JOIN address ON staff.address_id=address.address_id
	JOIN city ON address.city_id=city.city_id
	JOIN country ON city.country_id=country.country_id
    
# 7h. List the top five genres in gross revenue in DESCending ORDER. (##Hint##: you may need to use the following tables: category, film_category, inventory, payment, and rental.)
SELECT name AS Genre, concat('$',format(SUM(amount),2)) AS Gross_Revenue FROM category
	JOIN film_category ON category.category_id=film_category.category_id
	JOIN inventory ON film_category.film_id=inventory.film_id
	JOIN rental ON inventory.inventory_id=rental.inventory_id
	JOIN payment ON rental.rental_id=payment.rental_id
	GROUP BY Genre
	ORDER BY SUM(amount) DESC
    LIMIT 5
# 8a. In your new role as an executive, you would like to have an easy way of viewing the Top five genres BY gross revenue. Use the solutiON FROM the problem above to create a view. If you haven't solved 7h, you can substitute another query to create a view.
Create View Top_5_Genres AS(
SELECT name AS Genre, concat('$',format(SUM(amount),2)) AS Gross_Revenue FROM category
	JOIN film_category ON category.category_id=film_category.category_id
	JOIN inventory ON film_category.film_id=inventory.film_id
	JOIN rental ON inventory.inventory_id=rental.inventory_id
	JOIN payment ON rental.rental_id=payment.rental_id
	GROUP BY Genre
	ORDER BY SUM(amount) DESC
    LIMIT 5
    )
    
Select*from Top_5_Genres

# 8b. How would you display the view that you created in 8a?
'Response to 7h & 8a contain correct formatting'

# 8c. You find that you no longer need the view `top_five_genres`. Write a query to delete it.
Drop VIEW Top_5_Genres

### Appendix: List of Tables in the Sakila DB

* A schema is also available as `sakila_schema.svg`. Open it with a browser to view.

```sql
	'actor'
	'actor_info'
	'address'
	'category'
	'city'
	'country'
	'customer'
	'customer_list'
	'film'
	'film_actor'
	'film_category'
	'film_list'
	'film_text'
	'inventory'
	'language'
	'nicer_but_slower_film_list'
	'payment'
	'rental'
	'sales_by_film_category'
	'sales_by_store'
	'staff'
	'staff_list'
	'store'
```

## Uploading Homework

* To submit this homework using BootCampSpot:

  * Create a GitHub repository.
  * Upload your .sql file with the completed queries.
  * Submit a link to your GitHub repo through BootCampSpot.
