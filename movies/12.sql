-- list the titles of all movies in which both Johnny Depp and Helena Bonham Carter starred
-- output a table with a single column for the title of each movie
-- assume that there is only one person in the database with the name Johnny Depp
-- assume that there is only one person in the database with the name Helena Bonham Carter
-- 1 column and 6 rows

-- SELECT id FROM people WHERE name = "Johnny Depp";
-- SELECT id FROM people WHERE name = "Helena Bonham Carter";

-- SELECT movie_id FROM stars WHERE person_id IN (SELECT id FROM people WHERE name = "Johnny Depp");
-- SELECT movie_id FROM stars WHERE person_id IN (SELECT id FROM people WHERE name = "Helena Bonham Carter");

SELECT title FROM movies WHERE id IN (SELECT movie_id FROM stars WHERE person_id IN (SELECT id FROM people WHERE name = "Johnny Depp")) AND id IN (SELECT movie_id FROM stars WHERE person_id IN (SELECT id FROM people WHERE name = "Helena Bonham Carter"));