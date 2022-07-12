-- ### Instructions

-- Write the SQL queries to answer the following questions:

  

   
  use sakila;
  
  
  -- 1. Select the first name, last name, and email address of all the customers who have rented a movie.
  
  SELECT DISTINCT(CONCAT(first_name," ", last_name)) as customer_name, lower(email)
  FROM customer c
  JOIN rental r ON r.customer_id=c.customer_id
  WHERE r.rental_id>0;
  
  -- 2.-- - What is the average payment made by each customer (display the *customer id*, *customer name* (concatenated), 
  -- and the *average payment made*).
  
  SELECT DISTINCT(CONCAT(c.first_name," ", c.last_name)) as customer_name, c.customer_id, AVG(p.amount) as average_payment
  FROM customer c
  JOIN rental r ON r.customer_id=c.customer_id
  JOIN payment p ON p.customer_id=r.customer_id
  GROUP BY customer_name,customer_id;
  
  --  3. Select the *name* and *email* address of all the customers who have rented the "Action" movies.
  
	-- 3.1. Write the query using multiple join statements
    SELECT category_id, name
    FROM category
    WHERE name='action'; -- The category_id of action films is 1.
    
    SELECT DISTINCT(CONCAT(c.first_name," ", c.last_name)) as customer_name, c.email as email
    FROM customer c
    JOIN store s ON s.store_id=c.store_id
    JOIN inventory i ON i.store_id=s.store_id
    JOIN film f ON f.film_id=i.inventory_id
    JOIN film_category fc ON fc.film_id=f.film_id
    WHERE fc.category_id=1
    ORDER BY customer_name ASC;
    
    -- 3.2. Write the query using sub queries with multiple WHERE clause and `IN` condition
	SELECT DISTINCT(CONCAT(c.first_name," ", c.last_name)) as customer_name, c.email as email
    FROM customer c
    WHERE store_id in (
		SELECT store_id
        FROM store s 
		WHERE store_id in (
			SELECT store_id
			FROM inventory i
			WHERE film_id in(
				SELECT film_id
				FROM film f
				WHERE film_id in (
					SELECT film_id
					FROM film_category fc
					WHERE category_id in (
						SELECT category_id 
						FROM category c
						WHERE name='action'
                        )
                        )
                        )
                        )
                        )ORDER BY customer_name ASC;
    
    
    
   --  3.3. Verify if the above two queries produce the same results or not
   
   -- Yes, the results are the same.
  
   -- 4. Use the case statement to create a new column classifying existing columns as either or high value transactions based on 
   -- the amount of payment. If the amount is between 0 and 2, label should be `low` and if the amount is between 2 and 4, the label should be 
  -- `medium`, and if it is more than 4, then it should be `high`. 
  
  SELECT amount
  FROM payment;
  
  SELECT amount,
  (CASE 
  WHEN amount BETWEEN 0 AND 2 THEN 'low'
  WHEN amount BETWEEN 2 AND 4 THEN 'medium'
  ELSE 'high'
  END) as transaction_value
  FROM payment;
  
  