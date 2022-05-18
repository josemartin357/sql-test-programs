# write a SQL query that returns the average energy of songs that are by Drake
SELECT avg(energy) FROM songs WHERE artist_id IN(SELECT id FROM artists WHERE name = "Drake");