## SQL Analysis
____
The database I used for the analysis was __SQLite__. The purpose of this analysis was to __practice__ the learned material and __acquire new techniques__ for manipulating data using _SQL_.

First, I had to create a new table and upload data into that table from the _TikTok.csv_ file:
```SQL
CREATE TABLE tik AS
SELECT * FROM TikToc;
```
The main analysis began with gaining a fundamental understanding of the dataset:
```SQL
--count the number of unique values-- 
SELECT COUNT(*) AS UniqueValues
FROM tik;

--count the number of missing values-- 
SELECT COUNT(*) AS MissingValues
FROM tik
WHERE timestamp IS NULL OR account_id IS NULL OR nickname IS NULL OR biography IS NULL 
OR awg_engagement_rate IS NULL OR comment_engagement_rate IS NULL OR like_engagement_rate
IS NULL OR bio_link IS NULL OR followers IS NULL OR following IS NULL OR likes IS NULL
OR videos_count IS NULL OR CREATE_time IS NULL OR id IS NULL OR top_videos IS NULL 
OR url IS NULL OR profile_pic_url IS NULL;

--Let's examine the first five rows to gain a better understanding of the data:-- 
SELECT * FROM tik LIMIT 5;
```
There were a few columns with incorrect data types. I decided to convert them using two approaches. The first method is suitable for converting a single column, while the second one can be applied to convert several columns:
```SQL
ALTER TABLE tik 
add column timest DATE;

UPDATE tik 
SET timest = DATE(timestamp);

ALTER TABLE tik 
DROP column timestamp;

ALTER TABLE tik RENAME column timest TO timestamp;
```
```SQL
CREATE TABLE new_tik (
  account_id VARCHAR(255),
  nickname TEXT,
  biography TEXT,
  awg_engagement_rate FLOAT,
  comment_engagement_rate FLOAT,
  like_engagement_rate FLOAT,
  bio_link TEXT,
  is_verified NUM,
  followers INT,
  following INT,
  likes INT,
  videos_count INT,
  CREATE_time TEXT,
  id INT,
  top_videos TEXT,
  url TEXT,
  profile_pic_url TEXT,
  timestamp DATE
  );
  
INSERT INTO new_tik
SELECT account_id, nickname, biography, awg_engagement_rate, comment_engagement_rate,
like_engagement_rate, bio_link, is_verified, followers, following, likes, videos_count,
CREATE_time, id, top_videos, url, profile_pic_url, timest
FROM tik;

SELECT * FROM new_tik LIMIT 5;

DROP TABLE tik;

ALTER TABLE new_tik RENAME TO tik;
```
To retrieve account IDs from the year 2023:
```SQL
SELECT account_id, strftime('%Y', timestamp) AS year
FROM tik
WHERE strftime('%Y', timestamp) = '2023';
```
_Retrieve_ information about the individual with the _highest_ engagement rate:
```SQL
SELECT * FROM tik 
ORDER BY awg_engagement_rate DESC
LIMIT 1;
```
The _count_ of individuals whose nickname _starts with_ the letter "A":
```SQL
SELECT count(*) AS starts_with_A
FROM tik 
WHERE nickname LIKE 'A%';
```
_Retrieve_ account IDs and biographies of individuals who are _verified_:
```SQL
SELECT account_id, biography
FROM tik 
WHERE is_verified = 1;
```
_Retrieve_ the account_id and followers for rows where biography _contains the word_ "travel":
```SQL
SELECT account_id, followers, biography
FROM tik 
WHERE biography LIKE '%travel%';
```
_Calculate the average_ like_engagement_rate for all rows:
```SQL
SELECT AVG(like_engagement_rate) AS average_like_engagement
FROM tik;
```
_Find the maximum_ number of likes in the table:
```SQL
SELECT nickname, likes
FROM tik 
GROUP BY likes 
ORDER BY likes DESC LIMIT 1;
```
_Increase_ the followers count _by 100_ for all rows where _following is greater than 500_:
```SQL
UPDATE tik
SET followers = followers + 100
WHERE following > 500;
```
_Insert a new row_ with your own data into the table:
```SQL
INSERT INTO tik DEFAULT VALUES;
```
_Delete rows_ where _likes_ count is _less than 10_:
```SQL
DELETE FROM tik WHERE likes < 10;
```
_Remove_ all _rows_ where _videos_count is zero_:
```SQL
DELETE FROM tik WHERE videos_count = 0;
```
Imagine you have another table _xxx_ with columns _account_id_ and _category_. Join this table with your current table based on the _account_id_ column and retrieve account information along with their associated categories:
```SQL
SELECT T.nickname, T.followers, X.category
FROM tik AS T 
INNER JOIN xxx AS X ON T.account_id = X.account_id;
```
_Calculate_ the total number of _likes_ for each month of timestamp:
```SQL
SELECT strftime('%m', timestamp) AS month, SUM(likes) AS total_likse
FROM tik 
GROUP BY month
ORDER BY total_likse DESC;
```
Find the average _awg_engagement_rate_ for different ranges of followers (e.g., _less than 1000_, _1000-5000_, _5000+_):
```SQL
SELECT AVG(awg_engagement_rate) AS average_engagement,
	CASE
    	WHEN followers < 1000 THEN 'Under 1000 followers'
        WHEN followers BETWEEN 1000 AND 5000 THEN '1000-5000 followers'
        WHEN followers > 5000 THEN '5000+ followers'
    END AS follower_range
FROM tik 
GROUP BY follower_range
ORDER BY average_engagement DESC;
```
Retrieve rows where _followers_ count is greater than the average _followers_ count for all rows:
```SQL
SELECT *
FROM tik 
WHERE followers > (SELECT AVG(followers) FROM tik);
