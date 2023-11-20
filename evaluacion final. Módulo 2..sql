use sakila

1. Selecciona todos los nombres de las películas sin que aparezcan duplicados.

SELECT title as titulo_peliculas
FROM film
# Para asegurarnos utilizamos el DISTINCT
SELECT DISTINCT title as titulo_peliculas
FROM film


2. Muestra los nombres de todas las películas que tengan una clasificación de "PG-13".
# Seleccionamos titulo, rating y dentro del rating las peliculas que sea "PG-13"
SELECT title as titulo_peliculas, rating as clasificacion
FROM film
WHERE rating ="PG-13"

#Opción únicamente títulos
SELECT title as titulo_peliculas
FROM film
WHERE rating ="PG-13"


3. Encuentra el título y la descripción de todas las películas que contengan la palabra "amazing" en su descripción.
#Seleccionamos el título y descripción que aparecen en la tabla film. Dentro de descripción utilizamos un operador de filtro.
 # En esta query se observar la descripción
SELECT title as titulos_peliculas , description
FROM film
WHERE description LIKE '%amazing%'
 # En esa opción tomamos los datos de la tabla film_text
 
SELECT title as titulos_peliculas, description
FROM film_text
WHERE description LIKE '%amazing%'


4. Encuentra el título de todas las películas que tengan una duración mayor a 120 minutos

# Tomamos tabla de film donde aparece duración (length)
SELECT title as titulo, length as duracion
FROM film
WHERE length >120

#Esta opción es sin ver la duración, aparecen solo títulos
SELECT title as titulo
FROM film
WHERE length >120

5. Recupera los nombres de todos los actores.
# Seleccionamos nombres y apellidos de tabla actores.

SELECT first_name as nombre, last_name as apellido
FROM actor

6. Encuentra el nombre y apellido de los actores que tengan "Gibson" en su apellido.
#Seleccionamos nombre y apellido de tablas actores filtrando por Gibson

SELECT first_name as nombre, last_name as apellido
FROM actor
WHERE last_name = "Gibson"
# Esto es otra fórmula utilizando operadores

SELECT first_name as nombre, last_name as apellido
FROM actor
WHERE last_name like "%GIBSON%"

7. Encuentra los nombres de los actores que tengan un actor_id entre 10 y 20
#Tomamos tabla actores: su id, nombre y apellido. Después realizamos condición en el actor_id. Al ser un dato entre dos utilizamos Between 

SELECT actor_id, first_name, last_name
FROM actor
WHERE actor_id BETWEEN 10 AND 20

#Es la misma consulta solo que en esta solo aparecen los nombres

SELECT  first_name as nombre, last_name as apellido
FROM actor
WHERE actor_id BETWEEN 10 AND 20

8. Encuentra el título de las películas en la tabla film que no sean ni "R" ni "PG-13" en cuanto a su clasificación.
Tomamos tabla de película y seleccionamos los que no sean de rating indicado (WHERE NOT IN)
# En esta consulta aparece  el título de la película y el rating
SELECT title as titulo, rating as clasificacion
FROM film
WHERE rating  NOT IN ("R", "PG-13")
# En esta consulta aparece solo el titulo
SELECT title as titulo
FROM film
WHERE rating  NOT IN ("R", "PG-13")

9. Encuentra la cantidad total de películas en cada clasificación de la tabla film y muestra la clasificación junto con el recuento.
# La clasificacion de la tabla film es rating, contamos los id de las películas por rating.
SELECT COUNT(film_id) as numero_peliculas, rating as clasificacion
FROM film
GROUP BY rating

10. Encuentra la cantidad total de películas alquiladas por cada cliente y muestra el ID del cliente, su nombre y apellido junto con la cantidad de películas alquiladas.
Aquí son la cantidad de alquileres
# Como no toda la información está en una tabla, tenemos que ir relacionandolas. Partimos de cliente y relacionamos con rental.
 #Primero contamos los alquileres realizados por cliente.
SELECT customer.customer_id, first_name, last_name, COUNT(rental_id) AS alquileres
FROM customer 
INNER JOIN rental
ON customer. customer_id = rental. customer_id
GROUP BY customer_id, first_name, last_name

# y Aquí podemos ver las cantidades de películas y películas diferentes. Por eso añadimos otra tabla inventory. A veces el numero de alquileres es mayor al de peliculas porque aquí seleccionamos las distintas. 
SELECT customer.customer_id, customer.first_name, customer.last_name,
    COUNT(DISTINCT film.film_id) AS peliculas_alquiladas_diferentes
FROM customer
INNER JOIN rental 
ON customer.customer_id = rental.customer_id
INNER JOIN inventory 
ON rental.inventory_id = inventory.inventory_id
INNER JOIN film 
ON inventory.film_id = film.film_id
GROUP BY customer.customer_id, customer.first_name, customer.last_name

11. Encuentra la cantidad total de películas alquiladas por categoría y muestra el nombre de la categoría junto con el recuento de alquileres.
SELECT category.name AS categoria, COUNT(rental.rental_id) AS total_alquileres
FROM rental
INNER JOIN  inventory 
ON rental.inventory_id = inventory.inventory_id
INNER JOIN film 
ON inventory.film_id = film.film_id
INNER JOIN film_category
ON film.film_id = film_category.film_id
INNER JOIN category 
ON film_category.category_id = category.category_id
GROUP BY category.name;


12.  Encuentra el promedio de duración de las películas para cada clasificación de la tabla film y muestra la clasificación junto con el promedio de duración.   

# Consulta sobre tabla film, la clasificacion es el rating y hacemos media de la duración.
SELECT AVG(length) as media_duracion, rating as clasificacion
FROM film
GROUP BY rating

13. Encuentra el nombre y apellido de los actores que aparecen en la película con title "Indian Love".
# La información está en tablas de film, film_actor y actor. Las relacionamos y después ponemos condición en el título.
SELECT  film.title as titulo, actor.first_name as nombre, actor.last_name as apellido
FROM film
INNER JOIN film_actor
ON film.film_id = film_actor.film_id
INNER JOIN actor
ON actor.actor_id = film_actor.actor_id
WHERE film.title ="Indian Love"

14. Muestra el título de todas las películas que contengan la palabra "dog" o "cat" en su descripción.
# Podemos utilizar dos tablas o film o film_text y como son dos palabras las incluimos como condicion.
SELECT title, description
FROM  film
WHERE description LIKE  "%dog%"  OR description LIKE  "%cat%"

SELECT title, description
FROM  film_text
WHERE description LIKE  "%dog%"   OR description LIKE  "%cat%"

# Si solo queremos el título
SELECT title
FROM  film_text
WHERE description LIKE  "%dog%"   OR description LIKE  "%cat%"

# Total de películas con esa condiciones. No se pide pero por si nos puede interesar.
SELECT COUNT(title)as recuento_películas
FROM  film_text
WHERE description LIKE  "%dog%"   OR description LIKE  "%cat%"


15. Hay algún ACTOR  que no aparecen en ninguna película en la tabla film_actor. (DUDO)

SELECT actor.actor_id, actor.first_name, actor.last_name
FROM actor 
LEFT JOIN film_actor 
ON actor.actor_id = film_actor.actor_id
WHERE film_actor.actor_id IS NULL

16. Encuentra el título de todas las películas que fueron lanzadas entre el año 2005 y 2010.
# Seleccionamos de la tabla de películas el año de lanzamiento y como es entre dos fechas utilizamos between
SELECT title, release_year 
FROM film
WHERE release_year BETWEEN 2005 AND 2010
# Está opción aparece solo el título
SELECT title AS titulo
FROM film
WHERE release_year BETWEEN 2005 AND 2010

17. Encuentra el título de todas las películas que son de la misma categoría que "Family".
# Unimos tabla de películas, categorias de películas y categorias para poder extraer información. Luego la condicion es que categoria sea family.
SELECT film. film_id, film.title, category.name
from film
INNER JOIN film_category
ON film. film_id = film_category.film_id
INNER JOIN category
ON film_category. category_id = category. category_id
WHERE name = "Family"
# Consulta con solo títulos.
SELECT film.title
from film
INNER JOIN film_category
ON film. film_id = film_category.film_id
INNER JOIN category
ON film_category. category_id = category. category_id
WHERE name = "Family"

18. Muestra el nombre y apellido de los actores que aparecen en más de 10 películas.
#Tenemos que coger información de tablas tanto de actor como de pelis_actor para contabilizar. Relacionamos tablas y contamos.
#Agrupamos con actor_id e incluimos having (condición tras agrupar)

SELECT first_name, last_name, COUNT(film. film_id) AS peliculas_que_aparece
FROM actor
INNER JOIN film_actor
ON actor.actor_id = film_actor.actor_id
INNER JOIN film
ON film_actor.film_id = film.film_id
GROUP BY actor.actor_id
HAVING COUNT(film.film_id) >10

# Consulta solo con nombre
SELECT first_name, last_name
FROM actor
INNER JOIN film_actor
ON actor.actor_id = film_actor.actor_id
INNER JOIN film
ON film_actor.film_id = film.film_id
GROUP BY actor.actor_id
HAVING COUNT(film.film_id) >10


19. Encuentra el título de todas las películas que son "R" y tienen una duración mayor a 2 horas en la tabla film.
# Tabla de film puesto que tenemos tanto rating como length. Con un AND podemos unir las condiciones.

SELECT title, rating, length
FROM film
WHERE rating = "R" AND length > 120
# consulta con títulos únicamente.
SELECT title
FROM film
WHERE rating = "R" AND length > 120

20. Encuentra las categorías de películas que tienen un promedio de duración superior a 120 minutos y muestra el nombre de la categoría junto con el promedio de duración.
#Unimos tabla de fil, film_category y category. Debemos calcular media de lenght. Después agrupamos por categoria y la condición con un having.
SELECT category.name, AVG(length) AS media_duracion
FROM film
INNER JOIN film_category
ON film. film_id = film_category.film_id
INNER JOIN category
ON film_category. category_id = category.category_id
GROUP BY name
HAVING media_duracion >120


21. Encuentra los actores que han actuado en al menos 5 películas y muestra el nombre del actor junto con la cantidad de películas en las que han actuado.
# Relacionamos tablas para tener datos de actor y número de películas. Podemos relacionar o tres o dos tablas. Importante contabilizar id de las películas y expresar la condicion.

SELECT first_name, last_name, COUNT(DISTINCT film. film_id) AS peliculas_actuado
FROM actor
INNER JOIN film_actor
ON actor.actor_id = film_actor.actor_id
INNER JOIN film
ON film_actor.film_id = film.film_id
GROUP BY actor.actor_id
HAVING COUNT(film.film_id) >=5

SELECT first_name, last_name, COUNT(DISTINCT film_actor.film_id) AS peliculas_actuado
FROM actor
INNER JOIN film_actor
ON actor.actor_id = film_actor.actor_id
GROUP BY actor.actor_id
HAVING COUNT(film_actor.film_id) >=5

22 Encuentra el título de todas las películas que fueron alquiladas por más de 5 días. Utiliza una subconsulta para encontrar los rental_ids con una duración superior a 5 días y luego selecciona las películas correspondientes.

# Subconsulta de fechas de alquileres
#DATEDIFF DEVUELVE LA DIFERENCIA ENTRE DOS FECHAS.

SELECT rental_id, DATEDIFF(return_date, rental_date) AS dias_alquiler, return_date, rental_date
        FROM rental
        WHERE DATEDIFF(return_date, rental_date)

#Salen todas las películas con sus días de alquiler mayores a 5
SELECT film.title, DATEDIFF(return_date, rental_date)  AS dias_alquiler
FROM film
INNER JOIN inventory
ON film.film_id = inventory.film_id
INNER JOIN rental
ON inventory.inventory_id = rental.inventory_id
WHERE rental.rental_id IN ( SELECT rental_id 
        FROM rental
        WHERE DATEDIFF(return_date, rental_date)  >5)
	
# En esta consulta solo los títulos
SELECT film.title
FROM film
INNER JOIN inventory 
ON film.film_id = inventory.film_id
INNER JOIN rental 
ON inventory.inventory_id = rental.inventory_id
WHERE rental.rental_id IN (
    SELECT rental_id 
    FROM rental
    WHERE DATEDIFF(return_date, rental_date) > 5)
GROUP BY film.title;

        
# Y aquí vemos la media de dias por película por si pudiera interesarnos

SELECT  film.title, AVG(DATEDIFF(return_date, rental_date)) AS duracion_promedio
FROM film
INNER JOIN inventory 
ON film.film_id = inventory.film_id
INNER JOIN rental 
ON inventory.inventory_id = rental.inventory_id
WHERE  rental.rental_id IN (
        SELECT  rental_id
        FROM  rental
        WHERE DATEDIFF(return_date, rental_date) > 5)
GROUP BY film.title;

23. Encuentra el nombre y apellido de los actores que no han actuado en ninguna película de la categoría
 "Horror". Utiliza una subconsulta para encontrar los actores que han actuado en películas de la categoría "Horror" y luego exclúyelos de la lista de actor
# seleccionamos los id distinto porque puede que se repitan y actores aparezcan dos veces.
SELECT  DISTINCT actor.actor_id, first_name, last_name, name
FROM actor
INNER JOIN film_actor 
ON actor.actor_id = film_actor.actor_id
INNER JOIN film_category
ON film_actor.film_id = film_category. film_id
INNER JOIN category
ON film_category.category_id = category.category_id
WHERE name= "HORROR"

# incluimos los actores de horror dentro de la query para decir que queremos todos los actores MENOS esos.
SELECT first_name, last_name
FROM actor 
WHERE actor_id NOT IN (SELECT DISTINCT actor.actor_id
FROM actor
INNER JOIN film_actor 
ON actor.actor_id = film_actor.actor_id
INNER JOIN film_category
ON film_actor.film_id = film_category. film_id
INNER JOIN category
ON film_category.category_id = category.category_id
WHERE name= "HORROR")

# BONUS
24. BONUS: Encuentra el título de las películas que son comedias y tienen una duración mayor a 180 minutos en la tabla film.
#subconsulta titulos y categoria
SELECT title, name
FROM film
INNER JOIN film_category
ON film.film_id =film_category.film_id
INNER JOIN category
ON film_category.category_id = category.category_id
WHERE name = "Comedy"

#consulta de duración
SELECT title
FROM film
WHERE length>180

# UNA opción con subconsulta
SELECT title, length
FROM film
WHERE length>180 AND title IN (SELECT title
FROM film
INNER JOIN film_category
ON film.film_id =film_category.film_id
INNER JOIN category
ON film_category.category_id = category.category_id
WHERE name = "Comedy")

#otra opción si quiero que aparezca todo
SELECT title, category.name, length
FROM film
INNER JOIN film_category 
ON film.film_id = film_category.film_id
INNER JOIN category
ON film_category.category_id = category.category_id
HAVING length > 180 AND category.name = "Comedy";

25. BONUS: Encuentra todos los actores que han actuado juntos en al menos una película. La consulta debe mostrar el nombre y apellido de los actores y el número de películas en las que han actuado juntos



