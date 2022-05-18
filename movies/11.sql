-- write a SQL query to list the titles of the five highest rated movies (in order) that Chadwick Boseman starred in, starting with the highest rated.
-- Your query should output a table with a single column for the title of each movie.
SELECT movies.title FROM people 
JOIN stars ON people.id = stars.person_id
JOIN movies ON stars.movie_id = movies.id
JOIN ratings ON movies.id = ratings.movie_id
WHERE name = "Chadwick Boseman"
ORDER BY ratings.rating DESC
LIMIT 5;

# joining people to stars: link people.id to stars.person_id
# joining stars to movies: link stars.movie_id to movies.id 
# joining movies to ratings: link movies.id to ratings.movie_id
