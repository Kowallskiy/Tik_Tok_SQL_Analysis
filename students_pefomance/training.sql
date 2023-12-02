CREATE TABLE math AS
SELECT * FROM student_math_clean

PRAGMA table_info(math)

select DISTINCT final_grade
from math

SELECT sex, SUM(case when final_grade >= 15 then 1 else 0 end) as good_performers
from math
group by sex

select DISTINCT parent_status
from math

select parent_status, SUM(case when final_grade >= 15 then 1 else 0 end) as good_performers
from math
group by parent_status

select parent_status, sex, SUM(case when final_grade >= 15 then 1 else 0 end) as good_performers
from math
group by parent_status, sex

select parent_status, sex, SUM(case when final_grade <= 5 then 1 else 0 end) as bad_performers
from math
GROUP by parent_status, sex

SELECT DISTINCT mother_education
from math

select father_education, SUM(case when final_grade >= 15 then 1 else 0 end) as good_perfomance
from math
group by father_education

SELECT DISTINCT family_size
from math

select family_size, sex, sum(case when final_grade >= 15 then 1 else 0 end) as good_perfomance
from math
GROUP by family_size, sex

select DISTINCT school
from math

select *
from math
order by final_grade DESC
limit 5

SELECT school_choice_reason, SUM(CASE when final_grade >= 15 then 1 else 0 end) as good_perfomance
from math
group by school_choice_reason

select study_time, sex, SUM(case when final_grade >= 15 then 1 else 0 end) as good_perfomance
from math
GROUP by study_time, sex

select DISTINCT health
from math

select sex, health, COUNT(1)
FROM math
where final_grade >= 15
group by health, sex

-- for some reason girls' health is worse --
select sex, health, COUNT(1)
from math
group by sex, health

-- the number of boys in the study is less than that one of girls --
SELECT sex, count(1)
from math
group by sex

with new as (
  select sex, school_support
  from math
  where final_grade >= 15
  )
select sex, school_support, count(1)
from new
group by school_support, sex