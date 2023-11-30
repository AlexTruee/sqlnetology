CREATE TABLE IF NOT EXISTS genre (
	genre_id SERIAL PRIMARY KEY,
	name VARCHAR(30) unique NOT NULL
);

CREATE TABLE IF NOT EXISTS singer (
	singer_id SERIAL PRIMARY KEY,
	name VARCHAR(40) NOT NULL
);

CREATE TABLE IF NOT EXISTS genre_singer (
	genre_id INTEGER REFERENCES genre(genre_id),
	singer_id INTEGER REFERENCES singer(singer_id),
	CONSTRAINT pk_genre_singer PRIMARY KEY (genre_id, singer_id)
);


CREATE TABLE IF NOT EXISTS album (
	album_id SERIAL PRIMARY KEY,
	name VARCHAR(40) unique NOT NULL,
	release INTEGER check(release>1900)
);


CREATE TABLE IF NOT EXISTS singer_album (
	album_id INTEGER REFERENCES album(album_id),
	singer_id INTEGER REFERENCES singer(singer_id),
	CONSTRAINT pk_singer_album PRIMARY KEY (album_id, singer_id)
);


CREATE TABLE IF NOT EXISTS track (
	track_id SERIAL PRIMARY KEY,
	name VARCHAR(50) NOT NULL,
	duration INTEGER,
	album_id INTEGER REFERENCES album(album_id)
);

CREATE TABLE IF NOT EXISTS collection (
	collection_id SERIAL PRIMARY KEY,
	name VARCHAR(40) unique NOT NULL,
	release INTEGER check(release>1900),
);

CREATE TABLE IF NOT EXISTS collection_track (
	track_id INTEGER REFERENCES track(track_id),
	collection_id INTEGER REFERENCES collection(collection_id),
	CONSTRAINT pk_collection_track PRIMARY KEY (track_id, collection_id)
);


