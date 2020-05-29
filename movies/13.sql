-- list the names of all people who starred in a movie in which Kevin Bacon also starred
-- output a table with a single column for the name of each person
-- multiple people named Kevin Bacon in the database. Be sure to only select the Kevin Bacon born in 1958
-- Kevin Bacon himself should not be included in the resulting list
-- 1 column and 176 rows

-- SELECT id FROM people WHERE name = "Kevin Bacon" AND birth = "1958";
-- SELECT movie_id FROM stars WHERE person_id IN (SELECT id FROM people WHERE name = "Kevin Bacon" AND birth = "1958");

-- SELECT DISTINCT(person_id) FROM stars WHERE movie_id IN (SELECT movie_id FROM stars WHERE person_id IN (SELECT id FROM people WHERE name = "Kevin Bacon" AND birth = "1958"));
-- SELECT DISTINCT(person_id) FROM stars WHERE movie_id IN (SELECT movie_id FROM stars WHERE person_id IN (SELECT id FROM people WHERE name = "Kevin Bacon" AND birth = "1958")) AND person_id NOT IN (SELECT id FROM people WHERE name = "Kevin Bacon" AND birth = "1958");
SELECT name FROM people WHERE id IN (SELECT DISTINCT(person_id) FROM stars WHERE movie_id IN (SELECT movie_id FROM stars WHERE person_id IN (SELECT id FROM people WHERE name = "Kevin Bacon" AND birth = "1958")) AND person_id NOT IN (SELECT id FROM people WHERE name = "Kevin Bacon" AND birth = "1958"));