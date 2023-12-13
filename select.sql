/* Задание 2
Название и продолжительность самого длительного трека.*/
SELECT name, duration
FROM track
ORDER BY duration DESC
LIMIT 1;

/* Название треков, продолжительность которых не менее 3,5 минут. (210 сек)*/
SELECT name, duration
FROM track
WHERE duration >= 210;

/* Названия сборников, вышедших в период с 2018 по 2020 год включительно.*/
SELECT name
FROM collection
WHERE release BETWEEN 2018 AND 2020;

/* Исполнители, чьё имя состоит из одного слова.*/
SELECT name
FROM singer
WHERE name
NOT LIKE '% %';

/* Название треков, которые содержат слово «мой» или «my».*/
SELECT name
FROM track
WHERE STRING_TO_ARRAY(LOWER(name), ' ') && ARRAY ['my', 'мой'];

/*Задание 3
Количество исполнителей в каждом жанре.*/
SELECT g.name, COUNT(singer_id)
FROM genre_singer gs
LEFT JOIN genre g
    ON gs.genre_id = g.genre_id
GROUP BY g.name;

/*Количество треков, вошедших в альбомы 2019–2020 годов.*/
SELECT COUNT(t.track_id)
FROM track t
LEFT JOIN album a ON t.album_id = a.album_id
where a.release between 2019 and 2020;

/*Средняя продолжительность треков по каждому альбому.*/
SELECT a.name, CAST(AVG(t.duration) AS INT)
FROM album a
LEFT JOIN track t ON t.album_id = a.album_id
GROUP BY a.name;

/*Все исполнители, которые не выпустили альбомы в 2020 году.*/
SELECT name
FROM singer s
EXCEPT
SELECT s2.name FROM singer_album sa
JOIN album a ON a.album_id = sa.album_id
JOIN singer s2 ON s2.singer_id = sa.singer_id
WHERE a.release = 2020;

/*Названия сборников, в которых присутствует конкретный исполнитель (выберите его сами).*/
SELECT DISTINCT c.name
FROM collection c
JOIN collection_track ct ON ct.collection_id  = c.collection_id
JOIN track t ON t.track_id = ct.track_id
JOIN album a ON a.album_id = t.album_id
JOIN singer_album sa ON sa.album_id = a.album_id
JOIN singer s on s.singer_id = sa.singer_id
WHERE s.name = 'Ария';

/*Задание 4(необязательное)
Названия альбомов, в которых присутствуют исполнители более чем одного жанра.*/

SELECT a.name, count(g.name)
FROM album a
JOIN singer_album sa
    ON sa.album_id = a.album_id
JOIN singer s
    ON s.singer_id = sa.singer_id
JOIN genre_singer gs
    ON gs.singer_id = s.singer_id
JOIN genre g
    ON g.genre_id = gs.genre_id
GROUP BY a.name, s.singer_id
HAVING count(g.name) > 1;

/*Наименования треков, которые не входят в сборники.*/
SELECT t.name
FROM track t
LEFT JOIN collection_track ct
    ON ct.track_id = t.track_id
WHERE ct.collection_id
    IS NULL;

/*Исполнитель или исполнители, написавшие самый короткий по продолжительности трек,
  — теоретически таких треков может быть несколько.*/
SELECT s.name
FROM singer s
LEFT JOIN singer_album sa
    ON s.singer_id = sa.singer_id
LEFT JOIN album a
    ON sa.album_id = a.album_id
WHERE a.album_id = (
        SELECT t.album_id FROM track t
        WHERE t.duration = (
                        SELECT MIN(duration)
                        FROM track
                             )
                    );

/*Названия альбомов, содержащих наименьшее количество треков.*/
SELECT a.name, COUNT(t.track_id)
FROM album a
JOIN track t
    ON t.album_id = a.album_id
GROUP BY a.album_id
HAVING COUNT(t.track_id) =
	(SELECT COUNT(t.track_id)
	 FROM album a
	JOIN track t ON t.album_id = a.album_id
	GROUP BY a.album_id
	ORDER BY COUNT(t.track_id)
	LIMIT 1);