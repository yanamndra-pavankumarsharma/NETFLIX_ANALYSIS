DROP TABLE IF EXISTS netflix;
CREATE TABLE netflix
(
    show_id      VARCHAR(5),
    type         VARCHAR(10),
    title        VARCHAR(250),
    director     VARCHAR(550),
    casts        VARCHAR(1050),
    country      VARCHAR(550),
    date_added   VARCHAR(55),
    release_year INT,
    rating       VARCHAR(15),
    duration     VARCHAR(15),
    listed_in    VARCHAR(250),
    description  VARCHAR(550)
);
SELECT*FROM netflix;




__Task 1 Count the Number of Movies vs TV Shows

SELECT type, COUNT(*) AS number_of_Tv_Movies
FROM netflix
GROUP BY 1


--TASK 2 Find the Most Common Rating for Movies and TV Shows

WITH RatingCounts AS(
		SELECT type,rating,COUNT(*) AS count_of_type
		FROM netflix
		GROUP BY 1,2
		ORDER BY 3 ASC
),
RankedRatings AS(
		SELECT type,rating ,count_of_type ,
		RANK()
		OVER(PARTITION BY rating ORDER BY count_of_type  ) AS rank
		FROM RatingCounts 
		
)
SELECT type,rating AS most_frequent_rating 
FROM RankedRatings
WHERE rank =1;



		
--TASK 3 List All Movies Released in a Specific Year (e.g., 2020)

SELECT*FROM netflix 
WHERE release_year = 2020;


-- TASK 4 List Number Of Movies Released In Specific Year

SELECT  release_year, type , COUNT(*) AS no_of_releases_year
FROM netflix
GROUP BY 1,2
HAVING type = 'Movie'
ORDER BY 1 ASC

--TASK 5 Find the Top 5 Countries with the Most Content on Netflix

SELECT * FROM netflix;

SELECT * FROM 
(
	SELECT UNNEST(STRING_TO_ARRAY(Country , ',')) AS Country ,
	COUNT(*) AS Total_Content
	FROM netflix
	GROUP BY 1
)AS T1
WHERE Country IS NOT NULL
ORDER BY Total_Content ASC
LIMIT 5;


--TASK 6  Find Content Added in the Last 5 Years

SELECT*FROM netflix
WHERE TO_DATE(date_added,'Month DD,YYYY')>= CURRENT_DATE - INTERVAL '5 YEARS'

--TASK 7 Identify the Longest Movie

SELECT * FROM netflix
WHERE type = 'Movie'
ORDER BY SPLIT_PART(duration,  ' ' , 1)::INT DESC

--TASK 8 Find All Movies/TV Shows by Director 'Rajiv Chilaka'

SELECT*FROM
(
	SELECT* , UNNEST(STRING_TO_ARRAY (director, ',')) AS director_name
	FROM netflix 
)AS t

WHERE director_name = 'Rajiv Chilaka'

--TASK 9 List All TV Shows with More Than 5 Seasons

SELECT *
FROM netflix
WHERE type = 'TV Show'
  AND SPLIT_PART(duration, ' ', 1)::INT > 5;

--TASK 10 Count the Number of Content Items in Each Genre

SELECT 
UNNEST(STRING_TO_ARRAY(listed_in , ',')) AS genere,
COUNT(*) AS number_of_content
FROM netflix
GROUP BY 1
ORDER BY 2 ASC

--TASK 11 Find each year and the average numbers of content release in India on netflix.

SELECT 
    country,
    release_year,
    COUNT(show_id) AS total_release,
    ROUND(
        COUNT(show_id)::numeric /
        (SELECT COUNT(show_id) FROM netflix WHERE country = 'India')::numeric * 100,2
    ) AS avg_release
FROM netflix
WHERE country = 'India'
GROUP BY country, release_year
ORDER BY avg_release DESC
LIMIT 5;

-- TASK 12 List All Movies that are Documentaries

 SELECT*FROM netflix 
 WHERE
 listed_in LIKE '%Documentaries';

 --TASK 13  Find All Content Without a Director

 SELECT*FROM netflix 
 WHERE 
 director IS  NULL

 --TASK 14 Find How Many Movies Actor 'Salman Khan' Appeared in the Last 10 Years

 SELECT * FROM netflix 
 WHERE casts like '%Salman Khan%'
 AND
 release_year> EXTRACT(YEAR FROM CURRENT_DATE) - 10

 --TASK 15 Find the Top 10 Actors Who Have Appeared in the Highest Number of Movies Produced in India

 SELECT 
 	UNNEST(STRING_TO_ARRAY(casts , ',')) AS actor,
 	COUNT(*)
 FROM netflix
 WHERE country = 'India'
 GROUP BY actor
 ORDER BY COUNT(*) DESC
 LIMIT 10

--TASK 16  Categorize Content Based on the Presence of 'Kill' and 'Violence' Keywords
SELECT*FROM netflix

SELECT category ,
COUNT(*) AS content_count
FROM(
		SELECT
		CASE
		WHEN description LIKE '%kill%' OR description LIKE '%Violence%' THEN 'bad'
		ELSE 'good'
		END AS  category
		FROM netflix
)AS categorized_content

GROUP BY category





















