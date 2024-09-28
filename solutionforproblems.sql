-- Advanced SQL Project -- Spotify Datasets

-- create table--

DROP TABLE IF EXISTS spotify;
CREATE TABLE spotify (
    artist VARCHAR(255),
    track VARCHAR(255),
    album VARCHAR(255),
    album_type VARCHAR(50),
    danceability FLOAT,
    energy FLOAT,
    loudness FLOAT,
    speechiness FLOAT,
    acousticness FLOAT,
    instrumentalness FLOAT,
    liveness FLOAT,
    valence FLOAT,
    tempo FLOAT,
    duration_min FLOAT,
    title VARCHAR(255),
    channel VARCHAR(255),
    views FLOAT,
    likes BIGINT,
    comments BIGINT,
    licensed BOOLEAN,
    official_video BOOLEAN,
    stream BIGINT,
    energy_liveness FLOAT,
    most_played_on VARCHAR(50)
);


--EDA--

select count (*) from spotify;

select count (distinct artist) from spotify;

select Distinct album_type from spotify;

select duration_min from spotify;

select  MAX  (duration_min) from spotify;

select  MIN  (duration_min) from spotify;


SELECT * FROM SPOTIFY
WHERE DURATION_MIN = 0;


DELETE FROM SPOTIFY
WHERE DURATION_MIN = 0;

SELECT * FROM SPOTIFY
WHERE DURATION_MIN = 0;

SELECT DISTINCT CHANNEL FROM SPOTIFY;

SELECT DISTINCT MOST_PLAYED_ON FROM SPOTIFY;

--------------------------------------------------------
--Data Analysis  - Easy Ctaegory 
--------------------------------------------------------

-- Retrieve the names of all tracks that have more than 1 billion streams.
-- List all albums along with their respective artists.
-- Get the total number of comments for tracks where licensed = TRUE.
-- Find all tracks that belong to the album type single.
-- Count the total number of tracks by each artist.


-- 1.  Retrieve the names of all tracks that have more than 1 billion streams.

select * from spotify 
where stream > 1000000000 ;

2. -- List all albums along with their respective artists.

select  
   distinct album , artist   
from spotify  
order by 1 ;


3.  ---Get the total number of comments for tracks where licensed = TRUE.

--  select distinct lincesed from spotify 
 
select  
   sum (comments ) as total_comments 
from spotify 
where licensed  = 'true' ;



4. -- Find all tracks that belong to the album type single.

select * from spotify 
where album_type = 'single' ;

5.--Count the total number of tracks by each artist.

select 
   artist ,
   count (*) as total_no_songs 
from  spotify 
group by artist
order by 2 


------------------------
--Medium Level
------------------------

---Calculate the average danceability of tracks in each album.
---Find the top 5 tracks with the highest energy values.
---List all tracks along with their views and likes where official_video = TRUE.
---For each album, calculate the total views of all associated tracks.
---Retrieve the track names that have been streamed on Spotify more than YouTube.


6. ---Calculate the average danceability of tracks in each album.

select 
  album ,
  avg (danceability) as avg_danceability 
from spotify
group by 1
order by 2 desc 

7. ---Find the top 5 tracks with the highest energy values.

select 
  track,
  max(energy)
from spotify
group by 1
order by 2 desc 
limit 5

8.---List all tracks along with their views and likes where official_video = TRUE.

select
   track,
   sum(views) as total_views,
   sum(likes) as total_likes 
from spotify
where official_video = 'true'
group by 1
order  by 2 desc
limit 5 

9.---For each album, calculate the total views of all associated tracks.

select
    album,
	track,
	sum(views)
from spotify
group by 1 ,2 
order by 3 desc

10.---Retrieve the track names that have been streamed on Spotify more than YouTube.

select * from 
(select
    track,
	--most_played_on,
	coalesce(sum(case when most_played_on = 'youtube'  then stream end), 0 ) as streamed_on_youtube,
	coalesce(sum(case when most_played_on = 'spotify'  then stream end), 0 ) as streamed_on_spotify
from spotify
group by 1
)as t1
where
   streamed_on_spotify > streamed_on_youtube
   and
   streamed_on_youtube <> 0 ;


------------------------------------------
--Advanced Problem
------------------------------------------

11.---Find the top 3 most-viewed tracks for each artist using window functions.

with ranking_artist
as
(select
   artist,
   track,
   sum(views) as total_view , 
   dense_rank() over(partition by artist order by sum (views) desc) as rank 
from spotify
group by 1 , 2
order by 1 , 3 desc
)
select * from ranking_artist
where rank <= 3 


12.---Write a query to find tracks where the liveness score is above the average.

select
    track,
	artist,
	liveness
from spotify
where liveness  > (select avg (liveness) from spotify)


13.---Use a WITH clause to calculate the difference between the highest and lowest 
--energy values for tracks in each album.


with cte
as
(select
	album,
	max(energy) as highest_energy,
	min(energy) as lowest_energery
from spotify
group by  1
)
select
	album,
	highest_energy - lowest_energery as energy_diff
from cte
order  by 2 desc



------end---

