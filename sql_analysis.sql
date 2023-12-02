CREATE TABLE tik AS
SELECT * from TikToc;

**ANALYSIS**

--count the number of unique values-- 
SELECT COUNT(*) as UniqueValues
from tik;

--count the number of missing values in the table-- 
DECLARE @TableName NVARCHAR(MAX) = 'tik';
DECLARE @DynamicSQL NVARCHAR(MAX);

SELECT @DynamicSQL =
	'SELECT * FROM' + @TableName + 'WHERE' +
    STRING_AGG(column_name + 'IS NULL', 'OR')
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = @TableName;

EXEC sp_executesql @DynamicSQL;

--count the number of missing values-- 
SELECT COUNT(*) as MissingValues
from tik
where timestamp is null or account_id is null or nickname is null or biography is null 
or awg_engagement_rate is null or comment_engagement_rate is null or like_engagement_rate
is null or bio_link is null or followers is null or following is null or likes is NULL
or videos_count is null or create_time is null or id is null or top_videos is null 
or url is null or profile_pic_url is null;

--let's take a look at five fisrt rows to get a better understanding of the data-- 
SELECT * from tik LIMIT 5;

--it seems like a few columns have wrong data type, which requires converting-- 
ALTER table tik 
add column timest DATE;

UPDATE tik 
set timest = DATE(timestamp);

alter table tik 
drop column timestamp;

ALTER table tik RENAME column timest to timestamp;

--another way to change dtype of a column-- 
create table new_tik (
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
  create_time TEXT,
  id INT,
  top_videos TEXT,
  url TEXT,
  profile_pic_url TEXT,
  timestamp DATE
  );
  
INSERT INTO new_tik
SELECT account_id, nickname, biography, awg_engagement_rate, comment_engagement_rate,
like_engagement_rate, bio_link, is_verified, followers, following, likes, videos_count,
create_time, id, top_videos, url, profile_pic_url, timest
FROM tik;

SELECT * from new_tik LIMIT 5;

DROP table tik;

alter table new_tik RENAME to tik;

--it is time to extract data from the table-- 
select account_id, strftime('%Y', timestamp) as year
from tik
where strftime('%Y', timestamp) = '2023';

select * from tik limit 5;

--a person with the highest engagement rate--
SELECT * from tik 
order by awg_engagement_rate DESC
limit 1;

SELECT * from tik 
order by followers DESC
limit 1;

select count(*)
from tik 
where followers >= 1000000;

SELECT nickname, biography
from tik 
where followers >= 1000000;

--the number of people whose nickname starts with letter A--
select count(*) as starts_with_A
from tik 
where nickname like 'A%';

--retrieve account ids and biographies of people who are verified--
select account_id, biography
from tik 
where is_verified = 1;

--Retrieve the account_id and followers for rows where biography contains the word "travel"--
SELECT account_id, followers, biography
from tik 
where biography like '%travel%';

--Calculate the average like_engagement_rate for all rows.--
select AVG(like_engagement_rate) as average_like_engagement
from tik;

--Find the maximum number of likes in the table--
SELECT nickname, likes
from tik 
GROUP by likes 
order by likes desc limit 1;

--Increase the followers count by 100 for all rows where following is greater than 500.--
update tik
set followers = followers + 100
where following > 500;

--Insert a new row with your own data into the table--
INSERT into tik DEFAULT VALUES;

--delete rows where likes count is less than 10--
delete from tik where likes < 10;

--Remove all rows where videos_count is zero--
DELETE from tik where videos_count = 0;

--Imagine you have another table xxx with columns account_id and category. Join this--
--table with your current table based on the account_id column and retrieve account--
--information along with their associated categories--
select T.nickname, T.followers, X.category
from tik as T 
inner join xxx as X on T.account_id = X.account_id;

--Calculate the total number of likes for each month of timestamp--
SELECT strftime('%m', timestamp) as month, SUM(likes) as total_likse
from tik 
GROUP by month
order by total_likse DESC;

--Find the average awg_engagement_rate for different ranges of followers--
--(e.g., less than 1000, 1000-5000, 5000+)--
select AVG(awg_engagement_rate) as average_engagement,
	CASE
    	when followers < 1000 then 'Under 1000 followers'
        when followers BETWEEN 1000 and 5000 then '1000-5000 followers'
        when followers > 5000 then '5000+ followers'
    end as follower_range
from tik 
group by follower_range
order by average_engagement desc;

--Retrieve rows where followers count is greater than the average followers count for all rows--
SELECT *
from tik 
where followers > (SELECT AVG(followers) from tik);