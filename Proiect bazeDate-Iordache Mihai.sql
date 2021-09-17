#Project cours Database MySQL

CREATE DATABASE IF NOT EXISTS wannabe_sptify_database;
USE wannabe_sptify_database;


#######################       PHASE 2 PROJECT BEGIN     #####################

#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ USER/ADDRESS/AUTORITY


CREATE TABLE IF NOT EXISTS adress(
    id INT UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
    country VARCHAR(50) NOT NULL,
    city VARCHAR(50)
   
);


CREATE TABLE IF NOT EXISTS user(
    id INT UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    username VARCHAR(50)  UNIQUE NOT NULL,
    birth_date DATE,
    join_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    email varchar(100) NOT NULL,
    account_type ENUM ('PREMIUM', 'NORMAL') DEFAULT 'NORMAL',
    id_adress INT UNSIGNED UNIQUE NOT NULL, #am pus unique ca sa creez o relatie de 1 la 1 astefel incat sa nu am un user cu 2 sau mai multe adrese
    FOREIGN KEY(id_adress) references adress(id)
);



CREATE TABLE IF NOT EXISTS autority(
    id INT UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
    user_authority SET('ADMIN', 'USER') DEFAULT 'USER',
    id_user INT UNSIGNED NOT NULL,
    FOREIGN KEY(id_user) REFERENCES user(id)
);

#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

						#
                        #
                        #

#---------------------------------------------------------------------- ARTIST/ALBUM/SONG/PLAY-LIST/PLAY-LIST-SONG

CREATE TABLE IF NOT EXISTS artist(
    id INT UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL  
);

CREATE TABLE IF NOT EXISTS album(
    id INT UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(200) NOT NULL,
    release_date DATE
);



CREATE TABLE IF NOT EXISTS song(
    id INT UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(100),
    duration TIME NOT NULL,
    id_artist INT UNSIGNED NOT NULL,
    id_album INT UNSIGNED,
    FOREIGN KEY(id_album) REFERENCES album(id),
    FOREIGN KEY(id_artist) REFERENCES artist(id)
);




CREATE TABLE IF NOT EXISTS list(
    id INT UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
    id_user INT UNSIGNED NOT NULL,
    name VARCHAR(100),
    id_song INT UNSIGNED NOT NULL,
    FOREIGN KEY(id_user) REFERENCES user(id),
    FOREIGN KEY(id_song) REFERENCES song(id) 
);

#mi-am dat seama ca e o greseala in conceptia bazei de date. Creez tabela intermediara de mai jos @ManyToMany. Astfel fiecare user poate avea mai multe play_list-uri

CREATE TABLE IF NOT EXISTS play_list_song(
    id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    id_list INT UNSIGNED NOT NULL,
    id_song INT UNSIGNED NOT NULL,
    FOREIGN KEY(id_list) REFERENCES list(id),
    FOREIGN KEY(id_song) REFERENCES song(id)
);

#---------------------------------------------------------------------------------------------------------


#rename table list to play_list
RENAME TABLE list TO play_list;
#I need to modify column-> id_list from table play_list_song in id_play_list
ALTER TABLE play_list_song CHANGE COLUMN id_list id_play_list INT UNSIGNED NOT NULL;

#after organizing the tables I need to delete id_song from table list/play_list -> the column is moved in the new table play_list_song
#pas1 -> drop foreign key
ALTER TABLE play_list DROP FOREIGN KEY play_list_ibfk_2;
#pas2 -> drop column play_list
ALTER TABLE play_list DROP COLUMN id_song;


#drop column email din table user;
ALTER TABLE user drop email;
describe user;

#add column email back to table user but is not NOT NULL now
ALTER TABLE user ADD email VARCHAR(100);
#I move column email to be after username column
ALTER TABLE user MODIFY email VARCHAR(100) AFTER username; 

#delete foreign key from table user
#pas 1 -> drop foreign key
ALTER TABLE user DROP FOREIGN KEY user_ibfk_1;
#pas 2 -> delete column id_adress
ALTER TABLE user DROP id_adress;

#add column id_user in table address wich will be foreign key
ALTER TABLE adress ADD COLUMN id_user INT UNSIGNED NOT NULL;
#make id_user foreign key in table adress
ALTER TABLE adress ADD CONSTRAINT FOREIGN KEY(id_user) REFERENCES user(id);

#I realised i wrote adress(address) wrong and I need to modify the name of the table
RENAME TABLE adress TO address;

#modify the table name autority -> authority
RENAME TABLE autority TO authority;

#add index to table song for colum title to speed up the searches after this parameter
CREATE INDEX song_speed_search ON song(title);

###################################################  PHASE 2 PROJECT END   ###########################################################################
#
#
#
#
#
#
#
###################################################  PHASE 3 PROJECT BEGIN   ###########################################################################   

#POPULATE THE TABLES


# INSERT users INTO TABLE
INSERT INTO user (first_name, last_name, username, email, birth_date, join_date, account_type) VALUES
    ('Warren', 'Ryana', 'Foxy','warren_r@yahoo.com', '2015-03-26', '2021-02-15', DEFAULT),
    ('Clive', 'Brett', 'MagicMan', 'magic@gmail.com', '1983-12-25', '2018-08-20', 'PREMIUM'),
    ('Toby', 'Cristianne', 'yolo', NULL, '1975-04-10', '2016-04-02', 'PREMIUM'),
    ('Justin', 'Ulysses', 'Popey', NULL, '1965-07-30', '2019-05-01', 'PREMIUM'),
    ('Trisha', 'Gladis', 'trish', 'trish_x@gmail.com', '1998-08-23', '2021-01-08', DEFAULT),
    ('Geneva', 'Vale', 'sorcerer', 'sorcerer@hotmail.com', '2001-11-18', '2020-06-05', 'NORMAL'),
    ('Catharine', 'Kimberlyn', 'excelsior', NULL, '2002-01-20','2016-05-18', 'NORMAL'),
    ('Camelia', 'Catrinel', 'nebuna', NULL, '1987-08-08', '2019-07-23', 'NORMAL'),
    ('Radu', 'Mazare', 'mike', 'mike@gmail.com', '2013-08-20', '2018-07-25', 'NORMAL'),
    ('Ramona', 'Felicia', 'feli', 'feli@yahoo.com', '2004-05-06', '2018-08-01', 'PREMIUM'),
    ('Mihai', 'Iordache', 'Ginitoru', 'faraonu_ginitoru@yahooo.com', '1982-12-23','2019-04-03', 'PREMIUM');
    
INSERT INTO user (first_name, last_name, username, email, birth_date, join_date, account_type) VALUES
 ('Ramn', 'Felii', 'fe', 'feli@yao.com', '2004-09-03', '2018-08-01', 'PREMIUM');

#INSER users ADDRESS INTO address TABLE 
INSERT INTO address(country, city, id_user) VALUES
    ('USA', 'New York', 1),
    ('USA', 'Philadelphia',3),
    ('USA', 'Washington', 2),
    ('UK', 'London', 5),
    ('Ireland', 'Dublin', 4),
    ('Germany', 'Berlin', 6),
    ('UK', 'Mancester', 7),
    ('Romania', 'Bucharest', 11),
    ('France', 'Paris', 10),
    ('Spain', 'Madrid', 8),
    ('Madagascar', 'Antanarivo', 9);
    
 #INSERT users' autositie's INTO autority TABLE   
 INSERT INTO authority(user_authority, id_user) VALUES
    (DEFAULT, 1),
    (DEFAULT, 2),
    ('USER', 5),
    ('USER', 6),
    (DEFAULT, 7),
    (DEFAULT, 3),
    (DEFAULT, 4),
    (DEFAULT, 9),
    (DEFAULT, 10),
	('ADMIN,USER', 8),
    ('ADMIN,USER',11);
    
    #INSERT artists INTO artist TABLE
    INSERT INTO artist(name) VALUES
    ('Above & Beyond'),
    ('Lukas Termena'),
    ('David Brothers'),
    ('ATB'),
    ('Deep & Wide'),
    ('Chris Hampshire, Thomas Datt'),
    ('Bearson'),
    ('De Nuit, Inner Visions'),
    ('Melosense'),
    ('Jose Padilla'),
    ('Dennis Lloid'),
    ('Nea'),
    ('Phil Collins'),
    ('Satin Jackets'),
    ('Ingo Hermann'),
    ('Khari Khalamari'),
    ('Clush'),
    ('Jakatta'),
    ('Puremusic'),
    ('Delirium'),
    ('Lane 8'),
    ('Superheart'),
    ('Lana Del Rey'),
    ('Oleg Byonic'),
    ('SAINt JHN, Lenny Kravitz'),
    ('Passenger 10'),
    ('Tyoto'),
    ('Betical'),
    ('Jobarpopoulos'),
    ('Ambyion');
    
    
#INSERT album name and date INTO album TABLE 
INSERT INTO album(name, release_date) VALUES
    ('Peace OF Mind', '2015-05-26'),
    ('Freedom', '2019-04-05'),
    ('Curracloe', '2016-08-23'),
    ('No Silence', '2012-07-06'),
    ('Cafe del Mar Music', '2017-04-08'),
    ('Big Room Miami Vol.2', '2020-04-12'),
    ('Bearson', '2018-05-20'),
    ('All That Mattered (Love You Down)', '2016-11-07'),
    ('Polarization', '2019-05-23'),
    ('Adios ayer', '2017-12-05'),
    ('Nevermind', '2019-11-18'),
    ('Some Say', '2020-03-12'),
    ('Face Value', '1981-04-15'),
    ('For Days', '2013-07-09'),
    ('Flowerfields', '2015-08-30'),
    ('Night Drivers 1986', '2020-07-15'),
    ('Afternoon', '2019-06-22'),
    ('Visions', '2009-04-25'),
    ('Divine Properties', '2015-06-27'),
    ('Mythologie', '2016-10-30'),
    ('Litle by Litle', '2018-02-24'),
    ('Opening Credits', '2019-07-09'),
    ('Doin Time', '2019-08-02'),
    ('The Door Into Infinity', '2019-06-01'),
    ('Ghetto Lennys LoveSongs', '2019-10-19'),
    ('What a Feeling', '2013-12-25');
    

    
#INSERT song title, duration and foreign keys INTO song TABLE    
INSERT INTO song(title, duration, id_artist, id_album) VALUES
    ('Peace OF Mind - Croquet Club Remix', '00:05:15', 1, 1),
    ('Freedom', '00:04:48',2, 2),
    ('Curracloe', '00:08:52', 3, 3),
    ('Ecstasy', '00:04:21', 4, 4),
    ('Easy Rider', '00:04:55', 5, 5),
    ('Speed OF Light', '00:05:41', 6, 6),
    ('Let It Go', '00:04:23',7 ,7),
    ('All That Mattered (Love You Down)', '00:03:20', 8, 8),
    ('Polarization', '00:03:21', 9, 9),
    ('Adios ayer', '00:05:03', 10, 10),
    ('Nevermind', '00:02:37', 11, 11),
    ('Some Say', '00:02:56', 12, 12),
    ('In The Air Tonight - 2015 Remastered', '00:05:36', 13, 13),
    ('Anothr Day in Paradise - 2016 Remastered', '00:05:22', 13, 13),
    ('In The Air Tonight', '00:05:30', 13, 13),
    ('Night Keys', '00:06:11', 14, 14),
    ('For Days - Original Mix', '00:05:45', 14, 14),
    ('Silverlights', '00:04:54', 15, 15),
    ('Lost In Space', '00:03:25', 15, 15),
    ('Let You Go', '00:04:38', 15, 15),
    ('Night Drivers 1986', '00:02:36', 16, 16),
    ('Transitions', '00:02:48', 16, 16),
    ('The Epiphany', '00:02:35', 16, 16),
    ('Afternoon', '00:02:16', 17, 17),
    ('Its Never Too Late', '00:03:45', 17, 17),
    ('Willow (chilled electric version)', '00:01:56', 17, 17),
    ('Sway', '00:02:25', 17, 17),
    ('American Dream', '00:04:29', 18, 18),
    ('The Other World', '00:05:29',18, 18),
    ('Strung Out', '00:10:16', 18, 18),
    ('Ride the Storm', '00:05:31', 18, 18),
    ('It Will Be', '00:04:13', 18, 18),
    ('If I Could', '00:05:38', 19, 19),
    ('Dreams', '00:06:18', 19, 19),
    ('Muses', '00:06:44', 19 ,19),
    ('Roses', '00:07:24', 19 ,19),
    ('Belive', '00:05:16', 19, 19),
    ('Blue Fires', '00:06:25', 20, 20),
    ('Zero', '00:04:50', 20, 20),
    ('Keep On Dreaming', '00:05:23', 20, 20),
    ('Stay','00:04:08', 20, 20),
    ('Angels', '00:05:56', 20, 20),
    ('Continuum', '00:06:25', 20, 20),
    ('Dark Visions', '00:04:20', 20, 20),
    ('Stir Me Up', '00:04:56', 21, 21),
    ('Litle by Litle', '00:05:33', 21, 21),
    ('Atlas', '00:05:50', 21, 21),
    ('Daya', '00:06:18', 21, 21),
    ('No Captain', '00:05:16', 21, 21),
    ('No End in Sight / Outro', '00:07:19', 21, 21),
    ('Open Credits', '00:04:29', 22, 22),
    ('Count on Me', '00:03:48', 22, 22),
    ('After Midnight', '00:03:37', 22, 22),
    ('2001', '00:03:56', 22, 22),
    ('Doin Time', '00:03:21', 23, 23),
    ('Bionic', '00:06:14', 24, 24),
    ('Far From Me', '00:04:49', 24, 24),
    ('Waht s Your Sign', '00:05:16', 24, 24),
    ('The Stig', '00:05:57', 24, 24),
    ('Borders (feat. Lenny Kravitz)', '00:03:53', 25, 25),
    ('What a Feeling - Original Mix', '00:04:04', 26, 26),
    ('Dreamer', '00:02:51', 27, NULL),
    ('Solar', '00:05:39', 28, NULL),
    ('Kata(Edit)', '00:02:20', 29, NULL),
    ('Reaching For The Stars', '00:03:58', 30, NULL);
    
    
    
#INSERT play list name and user foreign key INTO play_list TABLE  @OneToMany  
INSERT INTO play_list(id_user, name) VALUES
(11, 'Gini playList'),
(11, 'Chill'),
(1, 'Foxy playlist'),
(4, 'JU playlist'),
(10, 'lefi playlist'),
(10, 'bau playlist'),
(8, 'kinky playlist'),
(3, 'gg playlist'),
(9, 'fitness playlist'),
(7, 'motivation playlist'),
(7, 'lounge playlist'),
(11, 'game playlist'),
(2, 'stuff playlist'),
(8, 'boring playlist'),
(1, 'bla bla playlist'); 

    
#INSERT foreign keys of play_list table and song table INTO play_list_song TABLE @ManyToMany 
INSERT INTO play_list_song (id_play_list, id_song) VALUES
    (1, 1), (1, 3), (1, 6), (1, 8), (1, 10), (1, 15), (1, 61), (1, 20),(1, 62), (1, 64),
    (2, 11), (2, 25), (2, 54), (2, 18), (2, 43),
    (3, 45), (3, 19), (3, 20), (3, 33), (3, 48), (3, 5),
    (4, 17), (4, 2),
    (5, 58), (5, 1), (5, 6), (5, 5),(5, 63), (5, 62),
    (6, 37),(6, 62),
    (7, 9), (7, 14), (7, 27), (7, 19), (7, 52),
    (8, 10), (8, 21), (8, 23), (8, 41),
    (9, 13), (9, 35), (9, 38), (9, 16), (9, 31), (9, 6),
    (10, 11), (10, 21), (10, 15),
    (11, 32), (10, 40), (10, 42), (10, 49), (10, 52), (10, 5), (10, 7),(10, 65),
    (12, 11), (12, 51), (12, 58), (12, 59), (12, 9),(12, 64), (12, 65),
    (13, 24), (13, 18), (13, 10), (13, 45),
    (14, 61), (14, 53), (14, 47),
    (15, 62);
    
    
    
#UPDATE-----------------------------------------------------------------------------------------------------------------------    
SET sql_safe_updates = 0;
#add 1 minute to the duration of the song Freedom    
UPDATE song SET duration = ADDTIME(duration,'00:01:00') WHERE title = 'Freedom'; 

#change username Trish of user Trisha Gladis
UPDATE user SET username = 'TG_gladiator' WHERE first_name = 'Trisha' AND last_name = 'Gladis';

#add emails to all the users that dont have an email regitered to them. The form of the email will be: first_name-last_name@spotify.com;
UPDATE user SET email = CONCAT(first_name, '-', last_name, '@spotify.com') WHERE email IS NULL;

#update emails that contains @spotify.com so that the email adress has only small leters;
UPDATE user SET email = LOWER(email) WHERE email LIKE '%@spotify.com';


#DELETE -------------------------------------------------------------------------------------------------------------------------

#delete user with id = 1 and all the data related to her -> address / authority / play_list / play_list_song data;
#to delete the user I need to add DELETE CASCADE to all foreign keys related to the user info, otherwise it doesnt let me delete the user
	

#add DELETE CASCADE to fereign key constraint to id_user in address table
#step1 -> drop foreing key constraint
ALTER TABLE address DROP FOREIGN KEY  address_ibfk_1;
#step2 -> add new foreign key constraint for CASCADE DELETE
ALTER TABLE address ADD CONSTRAINT FK_id_user_cascade_delete
FOREIGN KEY(id_user) REFERENCES user(id) ON DELETE CASCADE;


#add DELETE CASCADE to foreign key constraint to id_user in authority table
#step1 -> drop foreign key constraint
ALTER TABLE authority DROP FOREIGN KEY authority_ibfk_1;
#step2 -> add new foreing key constraint for DELETE CASCADE 
ALTER TABLE authority ADD CONSTRAINT FK_auth_id_user_cascade_delete
FOREIGN KEY(id_user) REFERENCES user(id) ON DELETE CASCADE;


#add DELETE CASCADE to foreign key constraint to id_user in play_list table
#step1 -> drop foreign key constraint
ALTER TABLE play_list DROP FOREIGN KEY  play_list_ibfk_1;
#step2 -> add new foreign key constraint for DELETE CASCADE
ALTER TABLE play_list ADD CONSTRAINT FK_play_list_id_user_cascade_delete
FOREIGN KEY(id_user) REFERENCES user(id) ON DELETE CASCADE;


#add DELETE CASCADE to foreign key constraint to id_play_list in play_list_song table
#step1 -> delete the foreign constraint for id_play_list
ALTER TABLE play_list_song DROP FOREIGN KEY play_list_song_ibfk_1;
#step2 -> add new foreign key constraint for DELETE CASCADE
ALTER TABLE play_list_song ADD CONSTRAINT FK_play_list_song_id_play_list
FOREIGN KEY(id_play_list) REFERENCES play_list(id) ON DELETE CASCADE;


#delete user and all info related to him/her WHERE id = 1;    
DELETE u FROM user u WHERE u.id = 1; # -> deletes all the data for the user from the following tables: USER / ADDRESS / AUTHORITY / PLAY_LIST / PLAY_LIST_SONG

									 
#delete the song with id =1; -> i want to delete only the song, but the album and the artist remain in the database. I dont want to make a cascade delete for
#the data in this 2 tables. But when I delete the song I want the row that has the foreign key of the song in the play_list_song table to be deleted								
							

#add DELETE CASCADE to foreign key constraint id_song in play_list_song table
#step1 -> delete foreing key constraint for id_song
ALTER TABLE play_list_song DROP FOREIGN KEY play_list_song_ibfk_2;
#step2 - >add new foreign key constraint for DELTE CASCADE
ALTER TABLE play_list_song ADD CONSTRAINT FK_id_song_delete_cascade
FOREIGN KEY(id_song) REFERENCES song(id) ON DELETE CASCADE;

# now I delete the song from the song table, I keep the artist and album info and the song is removed from all the users play_list_song 
DELETE s FROM song s WHERE s.id =1;  


#delete the song with the tile = Nevermind. Dont use SET sql_safe_updates = 0 or the id of the song in the WHERE caluse
SET sql_safe_updates=1;
DELETE s FROM song s JOIN
(SELECT id FROM song WHERE title = 'Nevermind') g
ON s.id = g.id WHERE s.title = 'Nevermind';
SET sql_safe_updates=0;


#delete all the songs that have a duration bigger thant 8 minutes
DELETE s FROM song s WHERE minute(s.duration) >= 8;


#delete the songs that are on the albums that have release_date 2019
DELETE s FROM song s JOIN
(SELECT a.id FROM album a WHERE YEAR(a.release_date) = 2019) g
ON s.id = g.id;

#########################################   PHASE 3 PROJECT BEGIN   ##############################################
#
#
#
#
#
#
#
#########################################   PHASE 4 PROJECT END   ###############################################

#SUBINTEROGARE 1 - scalar---------------------------------

#show all the albums that have rlease_date in the same year as the Litle By Litle album
SELECT a.name FROM album a WHERE YEAR(a.release_date) =
(SELECT YEAR(release_date) FROM album WHERE name = 'Litle By Litle');


#SUBINTEROGARE 2 - list-------------------------------------

#show the album name, the songs names and the release year of the albums that were released
#between the years that  "Mythologie" and "What a Feeling" album released
#step 1 -> find the year when the albums were released
SELECT YEAR(release_date) FROM album WHERE name = 'Mythologie';
SELECT YEAR(release_date) FROM album WHERE name = 'What a Feeling';

#step2 -> make a list of all the release years of the albums that were released between the years of these 2 albums
SELECT YEAR(release_date) FROM album WHERE YEAR(RELEASE_date)
	BETWEEN 
	(SELECT YEAR(release_date) FROM album WHERE name = 'What a Feeling')
	AND
	(SELECT YEAR(release_date) FROM album WHERE name = 'Mythologie');
        
#step 3 -> make the query        
SELECT a.name AS album_name, s.title AS song_title, YEAR(a.release_date) AS release_year 
FROM song s
JOIN album a ON  a.id = s.id_album
WHERE YEAR(a.release_date) IN (

				SELECT YEAR(release_date) FROM album WHERE YEAR(RELEASE_date)
				BETWEEN 
				(SELECT YEAR(release_date) FROM album WHERE name = 'What a Feeling')
				AND
				(SELECT YEAR(release_date) FROM album WHERE name = 'Mythologie')
) ORDER BY release_year;   


#SUBINTEROGARE 3 - inregistrare---------------------------

# show userers that have the same account type and joined in the same year as Justin Ulysses
SELECT concat(first_name, ' ', last_name) AS users
FROM user WHERE (account_type, YEAR(join_date)) = 
						(SELECT
						u.account_type,
						YEAR(join_date)
						FROM user u
						WHERE first_name = 'Justin' AND last_name = 'Ulysses');


#JOIN 1---------------------------------------------------
#select first_name, last_name of the firts user that joined the application and the songs and artists the he/she has in the play lists.
SELECT
	concat_ws(' ', u.first_name, u.last_name) AS user_credentials,
	art.name AS artist,
	s.title AS song
FROM user u 
	JOIN play_list pl ON u.id = pl.id_user
	JOIN play_list_song pls ON pl.id = pls.id_play_list
	JOIN song s ON s.id = pls.id_song
	JOIN artist art ON art.id = s.id_artist
WHERE u.join_date =
		(SELECT
		MIN(u.join_date)
		FROM USER u) 
ORDER BY artist;


#JOIN 2----------------------------------------------------
#show the username, country and city of all the admins
SELECT a.country, a.city, u.username
FROM user u
	JOIN authority auth ON u.id = auth.id_user
	JOIN address a ON u.id = a.id_user
WHERE auth.user_authority LIKE '%ADMIN%';


#JOIN 3-----------------------------------------------------
#show all users playlists that have songs that dont have any album -> eliminate duplicate songs in playlists.
SELECT DISTINCT s.title, u.username, pl.name
FROM user u
	JOIN play_list pl ON u.id = pl.id_user
	JOIN play_list_song pls ON pl.id = pls.id_play_list
	RIGHT JOIN song s ON s.id = pls.id_song
WHERE s.id_album IS NULL;

#JOIN 4 -> -----------------------------------------------
#show all athe songs and the coresponded album an artist including songs that dont have albums
SELECT
	s.title AS sont_title,
	s.duration AS song_duration,
	a.name AS album_name,
	art.name AS artist_name
FROM song s
    JOIN artist art ON s.id_artist = art.id
    LEFT JOIN album a ON s.id_album = a.id;
    

#JOIN 5 ->  -------------------------------------------------
#show how many songs are in each album, the name of the artists, including the songs that dont have any albums 
SELECT
	count(s.id) AS nr_of_songs,
	a.name AS ablum_name,
	art.name AS artist_name
FROM song s
    	JOIN artist art ON s.id_artist = art.id
    	LEFT JOIN album a ON s.id_album = a.id
GROUP BY ablum_name, artist_name
ORDER BY ablum_name DESC;
    

    
#GROUP FUNCTIONS
#GROUP 1
#show all songs that have a diration bigger then 5 minutes
SELECT
	EXTRACT(MINUTE FROM s.duration) AS minute_duration,
	s.duration,
	s.title
FROM song s
GROUP BY s.duration, s.title
HAVING minute_duration >5 ;

#GROUP 2
#show the users that have more than 30 minutes of songs in atleast 1 of theyer playlists
SELECT
	u.username, SEC_TO_TIME(SUM(TIME_TO_SEC(s.duration))) AS max_duration,
	pl.name
FROM user u
	JOIN play_list pl ON u.id = pl.id_user
	JOIN play_list_song pls ON pl.id = pls.id_play_list
	JOIN song s ON s.id = pls.id_song
GROUP BY pl.name
HAVING max_duration > '00:30:00';

#GROUP 3
#concatenate first_name and last_name on one colum and all the songs from all the playlists that have more than 5 songs in another colum, 
#show the playlist name too
SELECT 
	concat(u.first_name, ' ', u.last_name) AS user,
	pl.name AS play_list,
    count(pls.id_song) AS nr_of_songs,
	GROUP_CONCAT(s.title ORDER BY s.title SEPARATOR ' // ') AS songs
FROM user u
    JOIN play_list pl ON u.id = pl.id_user
    JOIN play_list_song pls ON pl.id = pls.id_play_list
    JOIN song s ON pls.id_song = s.id
GROUP BY pl.name, user
HAVING nr_of_songs > 5
ORDER BY user;


#MySQL predifined functions

# PREDIFINED FUNCTIONS 1 ----------------------------------------------------------------------
#show the age of each user in years, months, days, allsow add username and first_name and last_name
SELECT
	username,
    CONCAT_WS('-', first_name, last_name) AS name,
	CONCAT(
	TIMESTAMPDIFF(YEAR, birth_date, CURDATE()), ' years - ',
    	TIMESTAMPDIFF(MONTH,DATE_ADD(birth_date , INTERVAL TIMESTAMPDIFF(YEAR,birth_date, CURDATE()) YEAR), now()), ' months -',
	TIMESTAMPDIFF(DAY, DATE_ADD(birth_date, INTERVAL TIMESTAMPDIFF(MONTH, birth_date, CURDATE()) MONTH), now()), ' days') AS age
 FROM user
 ORDER BY age DESC; 
 
 # PREDIFINED FUNCTIONS 2 ----------------------------------------------------------------------
 #place all the users in 3 categoryes: if the user is under 18 years old he is minor
 # if the user is between 18 and 50 years onl he is young
 # if the user is above 50 years ol he is old 
SELECT 
    u.username,
    TIMESTAMPDIFF(YEAR, birth_date, CURDATE()) AS age,
    IF(TIMESTAMPDIFF(YEAR, birth_date, CURDATE()) < 18, 'MINOR',
	IF(TIMESTAMPDIFF(YEAR, birth_date, CURDATE()) BETWEEN 18 AND 50,  'YOUNG', 'OLD')) AS category
FROM user u;
    
# PREDIFINED FUNCTIONS 3 ----------------------------------------------------------------------  
#concatenate the username and the first initials form first_name and last_name and then reverse the two leters for the last user that joined
SELECT
CONCAT(u.username,'-', REVERSE(CONCAT(substring(u.first_name, 1, 1), substring(u.last_name, 1, 1)))) AS username_and_initilas
FROM user u
WHERE u.join_Date = (SELECT MAX(u.join_date) FROM user u);     
  

#########################################   PHASE 4 PROJECT END      ###############################################
#
#
#
#
#
#
#########################################   PHASE 5 PROJECT BEGIN     ##################################################

#VIEW 1 ------------------------------------------------------------------

#create a info_user view where you join address, user and autority tables with the related columns: country, city -> address table
																								#	username, year that the user was born -> user table
                                                                                                #	user_autority -> autority table
CREATE OR REPLACE VIEW  info_user AS
SELECT
	a.country AS country,
	a.city AS city,
	u.username AS username,
	YEAR(u.birth_date) AS birth_date,
	auth.user_authority AS autority
FROM address a
	JOIN user u
	JOIN authority auth
WHERE u.id = a.id_user AND u.id = auth.id_user;

SELECT * FROM info_user;

#VIEW 2 ------------------------------------------------------------------------

# show how many play lists has each user (show all the users including the ones that dont have any play lists)
CREATE OR REPLACE VIEW user_nr_play_lists AS
SELECT
	u.username,
	count(p.id) AS nrOfPlayLists 
FROM user u
	LEFT JOIN play_list p ON u.id = p.id_user
GROUP BY username
ORDER BY nrOfPlayLists DESC;

SELECT * FROM user_nr_play_lists;

#VIEW 3 ---------------------------------------------------------------

# show the username and the number of max songs the he/she has in all playlists
CREATE OR REPLACE VIEW max_songs AS
SELECT
	u.username,
	count(s.id_song) AS nrOfSongs
FROM user u
	JOIN play_list p ON u.id = p.id_user
	JOIN play_list_song s ON s.id_play_list = p.id
GROUP BY username
ORDER BY nrOfSongs DESC LIMIT 1;

SELECT * FROM max_songs;

#VIEW 4 ----------------------------------------------------------------

# show haw many songs has each user in evey play list
CREATE OR REPLACE VIEW user_play_list_nr_of_songs AS
SELECT
	u.username AS username,
	p.name AS playListName,
	count(s.id_song)AS nrOfSongs
FROM user u
	JOIN play_list p ON u.id = p.id_user
	JOIN play_list_song s ON p.id = s.id_play_list
GROUP BY username, playListName
ORDER BY username ASC, nrOfSongs DESC;

SELECT * FROM user_play_list_nr_of_songs;

#########################################    PHASE 5 PROJECT BEGIN    ######################################### 
#
#
#
#
#
#
#########################################    PHASE 6 PROJECT END    ######################################### 

#FUNCTION 1 ---------------------------------------------------------
#crete a fucntion that shows all the users from the same country and the country, the function recives the username
DELIMITER //
CREATE FUNCTION showUsersFromTheSameCountry(username VARCHAR(50)) RETURNS TEXT
BEGIN

	DECLARE message TEXT;
    DECLARE countId INT;


SELECT 
	concat(GROUP_CONCAT(u.username ORDER BY u.username SEPARATOR '/ '), ' -> ', a.country),
	count(u.id)
INTO
	message,
    	countId
FROM address a
JOIN user u ON u.id = a.id_user
WHERE a.country = 
		(SELECT a.country 
		FROM address a
		JOIN user u ON u.id = a.id_user
		WHERE u.username = username);

  
IF countId > 0 THEN
	RETURN message;
ELSE
	RETURN concat('Username: ', username, ' -> not found!');
END IF;

END;
//
DELIMITER ;


SELECT showUsersFromTheSameCountry('MagicMan');
SELECT showUsersFromTheSameCountry('zzzz');


#FUNCTION 2 ---------------------------------------------------------------------------------
#create function that recives as a parameter the name of an artist and returns the name of the artis, total time of his songs, the count of this songs
#and the name of all his songs
SET @result = NULL;
DELIMITER //
CREATE FUNCTION showSongTimes(artistName VARCHAR(100)) RETURNS TEXT
BEGIN
    DECLARE songsTime TIME;
    DECLARE countSongs INT;
    DECLARE songNames TEXT;
    DECLARE returnedText TEXT;

	SELECT 
		SEC_TO_TIME(SUM(TIME_TO_SEC(s.duration))),
		count(s.id),
		GROUP_CONCAT(s.title ORDER BY s.title SEPARATOR '; ')
    	INTO
		songsTime,
		countSongs,
		songNames
	FROM artist a
    JOIN song s ON s.id_artist = a.id
    WHERE a.name = artistName; 
   
    SET returnedText = CONCAT(artistName, ': has ', countSongs, ' songs  with a time of ', songsTime, ' minutes -> ',songNames);
   
   CASE countSongs
		WHEN 0 THEN RETURN concat(artistName, ' doesnt have any songs');
		WHEN 1 THEN RETURN returnedText;
		WHEN 2 THEN RETURN returnedText;
		ELSE RETURN returnedText;
   END CASE;
END;
//
DELIMITER ;

SET @result = showSongTimes('delirium');
select @result;


#FUNCTION 3 ------------------------------------------------------------
#create a function that recives as parameter fist_name and last_name of the user and if he has 2 years or more since he joined the app and if he has a PREMIUM
#account he recives a 1 month bonus PREMIUM, if he has les than 2 years he recives 15 days of PREMIUM if he doesnt have a PREMIUM account tell him to buy a PREMIUM ACCOUNT!!
DELIMITER //
CREATE FUNCTION giveBonusPremiumMonth(firstName VARCHAR(50), lastName VARCHAR(50)) RETURNS varchar(100)
BEGIN 
	DECLARE joinYears INT;
	DECLARE typeOfAccount VARCHAR(15);
    	DECLARE response VARCHAR(100);

	 SELECT
		TIMESTAMPDIFF(YEAR, u.join_date, curdate()),
		u.account_type
	 INTO
		joinYears,
		typeOfAccount
	 FROM user u
	 WHERE u.first_name = firstName AND u.last_name = lastName;
   
    
    IF(joinYears >= 2 AND typeOfAccount = 'PREMIUM') THEN
		SET response = concat('For beeing a valued member of this app for ', joinYears, ' years you recived a 1 month PREMIUM' );
	ELSE IF(joinYears < 2 AND typeOfAccount = 'PREMIUM') THEN 		
		SET response = concat('For beeing a valued member of this app for ', joinYears, ' years you recived 15 days PREMIUM' );
	ELSE
		SET response = concat('If you want no comercials buy PREMIUM ACCOUNT!!');
	END IF;
    END IF;
    
    RETURN response;
END;
//
DELIMITER ;

select giveBonusPremiumMonth('toby', 'cristianne');
select giveBonusPremiumMonth('trisha', 'gladis');


#########################################    PHASE 6 PROJECT BEGIN    ######################################### 
#
#
#
#
#
#
#
##########################################   PHASE 7 PROJECT END    ##########################################

#PROCEDURES

#PROCEDURE 1 --------------------------
#create a procedure that recives a username and returns the number of songs in all user playlists and the names of the songs
DELIMITER //
CREATE PROCEDURE userPlaylistAndSongs(IN username VARCHAR(50), OUT nrOfSongs INT, OUT songs TEXT)
BEGIN

 	SELECT
	  count(pls.id_song),
	  group_concat(s.title ORDER BY s.title SEPARATOR '/' )
    	INTO
	  nrOfSongs,
	  songs
	FROM user u
	JOIN play_list pl ON u.id = pl.id_user
	JOIN play_list_song pls ON pl.id = pls.id_play_list
	JOIN song s ON pls.id_song = s.id
	WHERE u.username = username;

END;
//
DELIMITER ;

CALL userPlaylistAndSongs('yolo', @x, @y);
SELECT @x, @y;

#PROCEDURE 2---------------------------
DELIMITER //
CREATE PROCEDURE accountType(IN username VARCHAR(50), OUT message VARCHAR(100))
BEGIN
	DECLARE x_account VARCHAR(20);


	SELECT u.account_type INTO x_account
    	FROM user u 
	WHERE u.username = username;
    
    
    
	CASE x_account
		WHEN 'PREMIUM' THEN SET message = concat('Username: ',username, ' has an ', x_account, ' account!');
        	WHEN 'NORMAL' THEN SET message = concat('Username: ',username, ' has an ', x_account, ' account!');
        	ELSE SET message = concat(username,  'doesnt have any type of account atached');
	END CASE;

END;
//
DELIMITER ;

CALL accountType('Ginitoru', @z);
SELECT @z;

#PROCEDURE 3---------------------------------
#create a procedure that recives the name of a song and displays all the users that have that song in theyer playlists
#if more that 3 users listen to that song then display ' <sont.title>' is a hit.

DELIMITER //
CREATE PROCEDURE showUsername(IN songName VARCHAR(150))
BEGIN

     DECLARE users VARCHAR(200);
     DECLARE users_count INT DEFAULT 0;
     DECLARE message VARCHAR(100) DEFAULT concat('Song ', songName, ' does not exists!!');
     DECLARE song_id INT;

SELECT
	GROUP_CONCAT(u.username ORDER BY u.username SEPARATOR '/'),
	COUNT(u.username),
	s.id
INTO users, users_count, song_id
	FROM user u
    JOIN play_list pl ON u.id = pl.id_user
    JOIN play_list_song pls ON pls.id_play_list = pl.id
    JOIN song s ON pls.id_song = s.id
WHERE s.title = songName;


    IF users_count >= 3 THEN
	SET message = concat(songName, ' is a HIT!!!!!!!!!!');
    END IF;
    
    IF users_count < 3 AND users_count >= 1 THEN
	SET message = concat(songName, ' is not a HIT!!!!!!!');
    END IF;
    
    IF users_count = 0 AND song_id > 0 THEN
	SET message = concat(' No user has ', songName, ' in theyer playlist');
        SET users = '0';
        SET users_count = 0;
	END IF;
    
   select users, users_count, message;

END;
//
DELIMITER ;

CALL showUsername('Speed OF Light');
CALL showUsername('Sway');
CALL showUsername ('freedom');


##########################################   PHASE 7 PROJECT BEGIN    ##########################################
#
#
#
#
#
#
##########################################    PHASE 8 PROJECT END     ###########################################

#CURSOR 1----------------------------------------------------------
#create a procedure that populates the table comercial_table -> depending of the users age and account specify if the app will send comercials or not.
CREATE TABLE IF NOT EXISTS comercial_table(
    id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    user_name VARCHAR(110) NOT NULL,
    years INT,
    account_type VARCHAR(20),
    type_of_comercial TEXT
);

DELIMITER //
CREATE PROCEDURE spam_comercials() 

BEGIN

    DECLARE accountType VARCHAR(20);
    DECLARE country VARCHAR(50);
    DECLARE flag VARCHAR(10) DEFAULT 'green';
    DECLARE user_name VARCHAR(100);
    DECLARE response TEXT;
    DECLARE years INT;
    

    DECLARE comercial_cursor CURSOR FOR
					SELECT
						CONCAT(u.first_name, ' ', u.last_name) AS years, 
						TIMESTAMPDIFF(YEAR, u.birth_date, CURDATE()),
						u.account_type,
						a.country
					 FROM user u
					 JOIN address a
					 ON u.id = a.id_user
			     		 ORDER BY years;
                     
      
     DECLARE CONTINUE HANDLER FOR NOT FOUND
				BEGIN
				   SET flag = 'red';
				END;
        
	TRUNCATE TABLE comercial_table;
    
	OPEN comercial_cursor; 
        spin: LOOP
	    FETCH comercial_cursor INTO user_name, years, accountType, country;

	    IF flag = 'red' THEN
		LEAVE spin;
	    END IF;
            
            IF  ((18 <= years AND years <= 50) AND accountType = 'NORMAL') THEN
                SET response = concat('send young people comercials for country ', country);
            END IF;
            
            IF (years < 18 AND accountType = 'NORMAL') THEN
		 SET response = concat('send kids comercials for country ', country);
	    END IF;
            
            IF(years > 50 AND accountType = 'NORMAL') THEN
		 SET response = concat('send old people comercials for country ', country);
	    END IF;
             
             IF (accountType = 'PREMIUM') THEN
		SET response = 'dont send comercials - > this users pays for app!!!!';
             END IF;
			
	INSERT INTO comercial_table VALUES (NULL, user_name, years, accountType, response);
            
        END LOOP;  
	CLOSE comercial_cursor;  
END;
//
DELIMITER ;
CALL spam_comercials();
SELECT * FROM comercial_table;



#CURSOR 2 ------------------------------------------------------------------
#show the user playlist, songs, and the number of songs in all the playlists;
DELIMITER //
CREATE PROCEDURE groupSongsAndPlaylists(IN user_name VARCHAR(50), OUT song_count INT, out playListSongs TEXT, OUT groupPlayList TEXT )
BEGIN    
    DECLARE flag INT DEFAULT 1;
    DECLARE songId INT default 0;
    DECLARE songs TEXT;
    DECLARE playList VARCHAR(100);
  
    DECLARE cursor_x CURSOR FOR 						
			SELECT s.id, s.title, pl.name 
				FROM play_list pl
				JOIN user u ON u.id = pl.id_user
				JOIN play_list_song pls ON pl.id = pls.id_play_list
				JOIN song s ON pls.id_song = s.id
			WHERE u.username = user_name;
                        
	DECLARE CONTINUE HANDLER FOR NOT FOUND
		BEGIN
			SET flag = 0;
		END;
        
	SET song_count = 0;
	SET playListSongs = '';
	SET groupPlayList= '';
            
OPEN  cursor_x;
	spin: LOOP
		FETCH cursor_x INTO songId, songs, playList;

		IF flag = 0 THEN
			LEAVE spin;
		END IF;
            
            	IF songId > 0 THEN
			SET song_count = song_count + 1;
			SET playListSongs = CONCAT_WS('/ ', songs, playListSongs);
                
               		IF (groupPlayList NOT LIKE CONCAT('%' , playList , '%')) THEN
		     		SET groupPlayList = CONCAT_WS('; ',playList, groupPlayList);
			END IF;
            	END IF;    
	END LOOP;
CLOSE cursor_x; 
END;
//
DELIMITER ;

CALL groupSongsAndPlaylists('Ginitoru', @song_count, @song_title, @playlist_name);
SELECT @song_count, @song_title, @playlist_name;

#CURSOR 3 -----------------------------------------
#given the name of the album show what songs have the users in theyer playlists.
DELIMITER //
CREATE PROCEDURE showWhatSongsFromAlbumsAreInUsersPlaylists(IN albumName VARCHAR(200))
BEGIN
    DECLARE flag INT DEFAULT 1;
    DECLARE userX VARCHAR(50);
    DECLARE songX VARCHAR(100);
    DECLARE allUsers TEXT DEFAULT ''; #neaparat de pus default '' ca altfel nu merg if-urile####################
    DECLARE allSongs TEXT DEFAULT '';
    DECLARE result TEXT DEFAULT '';

	DECLARE cursor_album CURSOR FOR
				SELECT u.username, s.title 
						FROM user u
						JOIN play_list pl ON u.id = pl.id_user
						JOIN play_list_song pls ON pl.id = pls.id_play_list
						JOIN song s ON pls.id_song = s.id
						JOIN album a ON a.id = s.id_album
				WHERE a.name = albumName;
								
                                
	DECLARE CONTINUE HANDLER FOR NOT FOUND
					BEGIN
					  SET flag = 0;
					END;
	SET result = '';

    OPEN cursor_album;
		spin: LOOP
			FETCH cursor_album INTO userX, songX;
            
            IF(flag = 0) THEN
				LEAVE spin;
            END IF;
            
            IF(allUsers NOT LIKE CONCAT('%', userX, '%')) THEN
				SET allUsers = CONCAT_WS('/', userX, allUsers );
			END IF;
            
            IF(allSongs NOT LIKE CONCAT('%', songX, '%')) THEN
				SET allSongs = CONCAT_WS(';',songX, allSongs);
			END IF;
		END LOOP;
            
        SET result = concat ('Users:-> ', allUsers, ' have this songs:-> ', allSongs, ' from album: ', albumName, ' -> in theyer playlists');
	
	CLOSE cursor_album;
    
    SELECT result;
	
END;
//
DELIMITER ;

CALL showWhatSongsFromAlbumsAreInUsersPlaylists('Mythologie');



##########################################   PROJECT 8 PROJECT END    ###########################################
#
#
#
#
#
#
##########################################   PROJECT 9 PROJECT BEGIN    ###########################################

#TRIGGER 1----------------------------------------------------------
#create a trigger that creates an email with: first_name-last_name@spotify.com if the user doesnt have one, and if it is user birthday
#and he has a NORMAL account give him a PREMIUM account;
DELIMITER //
CREATE TRIGGER beforeInsertUser BEFORE INSERT ON user
FOR EACH ROW
BEGIN 
    DECLARE dayOfBirth INT DEFAULT 0;
    DECLARE monthOfBirth INT DEFAULT 0;

		IF(NEW.email IS NULL) THEN
			SET NEW.email = CONCAT(NEW.first_name, '-', NEW.last_name, '@spotify.com');
		END IF;
        
        SET dayOfBirth = EXTRACT(DAY FROM NEW.birth_date);
        SET monthOfBirth = EXTRACT(MONTH FROM NEW.birth_date);
        
        IF(NEW.account_type = 'NORMAL' AND ( dayOfBirth = EXTRACT(DAY FROM CURDATE()) AND monthOfBirth = EXTRACT(MONTH FROM CURDATE()))) THEN
		SET NEW.account_type = 'PREMIUM';
	END IF;
END;
//
DELIMITER ;


INSERT INTO user (first_name, last_name, username, email, birth_date, join_date, account_type) VALUES
	('Gica', 'Ion', 'bibica',NULL, '2015-09-13', '2021-02-15', DEFAULT);
SELECT * FROM user u WHERE u.username = 'bibica';




#TRIGGER 2--------------------------------------------------------
#display a message/send an email after the users updates his acount to PREMIUM or NORMAL
SET @sendEmail = '';
DELIMITER //
CREATE TRIGGER afterUpdateAccount AFTER UPDATE ON user
FOR EACH ROW
BEGIN
	
    IF(OLD.account_type = 'NORMAL' AND NEW.account_type = 'PREMIUM') THEN
	SET @sendEmail = concat('Thank you ', OLD.first_name, ' ', OLD.last_name, ' for purcesing PREMIUM account!!!!');
    END IF;
    
    IF(OLD.account_type = 'PREMIUM' AND NEW.account_type = 'NORMAL') THEN
	SET @sendEmail = concat('This is not nice ', OLD.first_name, ' ', OLD.last_name, ', now the app will spam you with ads!!!!');
    END IF;
END;
//
DELIMITER ;

UPDATE user u SET u.account_type = 'NORMAL' WHERE username = 'mike';
SELECT @sendEmail;


#TRIGGER 3 ----------------------------------------------------
#if the song inserted into the database exists allready then cancel the insert.
DELIMITER //
CREATE TRIGGER beforeInsertSong BEFORE INSERT ON song
FOR EACH ROW
BEGIN

	DECLARE songName VARCHAR(100) DEFAULT '';
    

	SELECT  distinct s.title INTO songName
        FROM song s
        WHERE s.title = NEW.title;

		IF songName = NEW.title THEN
			SIGNAL SQLSTATE '45000'
			SET MESSAGE_TEXT = ' END OF SCRIPT!!!:-)) -> You can not insert the song. It is allready in the database!!!. INSERT WAS ABORTED!!';
		END IF;
END;
//
DELIMITER ;

INSERT INTO song(title, duration, id_artist, id_album) VALUES
('Ecstasy', '00:04:21', 4, 4);



########################################## PHASE 9 PROJECT END    ###########################################



