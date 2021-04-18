-- LAB 7 --

use SIA_UNIVERSITY;
-- TASK 1
select min(AUDITORIUM_CAPACITY)[Minimal capacity],
       max(AUDITORIUM_CAPACITY)[Maximal capacity],
       avg(AUDITORIUM_CAPACITY)[Average capacity],
       sum(AUDITORIUM_CAPACITY)[Summa capacity]
from AUDITORIUM

-- TASK 2
select AUDITORIUM.AUDITORIUM_TYPE,
       min(AUDITORIUM_CAPACITY)[Minimal capacity],
       max(AUDITORIUM_CAPACITY)[Maximal capacity],
       avg(AUDITORIUM_CAPACITY)[Average capacity],
       sum(AUDITORIUM_CAPACITY)[Summa capacity]
from AUDITORIUM
    inner join AUDITORIUM_TYPE on AUDITORIUM_TYPE.AUDITORIUM_TYPE = AUDITORIUM.AUDITORIUM_TYPE
    group by AUDITORIUM.AUDITORIUM_TYPE

-- TASK 3
select *
    from (select case
--NOTE производим выборку
                     when NOTE = 10 then '10'
                     when NOTE between 8 and 9 then '8-9'
                     when NOTE between 6 and 7 then '6-7'
                     when NOTE between 4 and 5 then '4-5'
                     when NOTE < 4 then 'fail'
                     end[note],count(*)[quantity]
          from PROGRESS
          group by case
--NOTE производим группировку
                       when NOTE = 10 then '10'
                       when NOTE between 8 and 9 then '8-9'
                       when NOTE between 6 and 7 then '6-7'
                       when NOTE between 4 and 5 then '4-5'
                       when NOTE < 4 then 'fail'
                       end
         )as T
            order by case note
--NOTE производим сортировку
                when '10'  then 1
                when '8-9' then 2
                when '6-7' then 3
                when '4-5' then 4
                when 'fail'then 5
                end

-- TASK 4
------------------------------------------------------------------------------
-- NOTE средний результаты каждого факультета
------------------------------------------------------------------------------
select G.FACULTY, G.PROFESSION, round(avg(cast(NOTE as float)),2)[AVG NOTE]
from PROGRESS
    inner join STUDENT S on S.IDSTUDENT = PROGRESS.IDSTUDENT
    inner join GROUPS G on G.IDGROUP = S.IDGROUP
    inner join FACULTY F on F.FACULTY = G.FACULTY
    group by  G.PROFESSION, G.FACULTY
------------------------------------------------------------------------------
-- NOTE средний результаты каждого факультета только предметы ОАиП и БД
------------------------------------------------------------------------------
select G.FACULTY, G.PROFESSION, round(avg(cast(NOTE as float)),2)[AVG NOTE]
from PROGRESS
    inner join STUDENT S on S.IDSTUDENT = PROGRESS.IDSTUDENT
    inner join GROUPS G on G.IDGROUP = S.IDGROUP
    inner join FACULTY F on F.FACULTY = G.FACULTY
    where SUBJECT = N'ОАиП' or SUBJECT = N'БД'
    group by  G.PROFESSION, G.FACULTY

-- TASK 5
------------------------------------------------------------------------------
-- NOTE средний результаты факультета ТОВ + rollup
------------------------------------------------------------------------------
select G.PROFESSION, SUBJECT, round(avg(cast(NOTE as float)),2)[AVG NOTE]
from PROGRESS
    inner join STUDENT S on S.IDSTUDENT = PROGRESS.IDSTUDENT
    inner join GROUPS G on G.IDGROUP = S.IDGROUP
    inner join FACULTY F on F.FACULTY = G.FACULTY
    where F.FACULTY = N'ТОВ'
    group by  (G.PROFESSION), SUBJECT with rollup

-- TASK 6
------------------------------------------------------------------------------
-- NOTE средний результаты факультета ТОВ + cube
------------------------------------------------------------------------------
select G.PROFESSION, SUBJECT, round(avg(cast(NOTE as float)),2)[AVG NOTE]
from PROGRESS
    inner join STUDENT S on S.IDSTUDENT = PROGRESS.IDSTUDENT
    inner join GROUPS G on G.IDGROUP = S.IDGROUP
    inner join FACULTY F on F.FACULTY = G.FACULTY
    where F.FACULTY = N'ТОВ'
    group by G.PROFESSION, SUBJECT with cube

-- TASK 7
------------------------------------------------------------------------------
-- NOTE средний результаты факультета ТОВ по каждой дисциплине
------------------------------------------------------------------------------
select G.FACULTY, G.PROFESSION, SUBJECT, round(avg(cast(NOTE as float)),2)[AVG NOTE]
from PROGRESS
    inner join STUDENT S on S.IDSTUDENT = PROGRESS.IDSTUDENT
    inner join GROUPS G on G.IDGROUP = S.IDGROUP
    where G.FACULTY = N'ТОВ'
 group by G.PROFESSION, SUBJECT, G.FACULTY
------------------------------------------------------------------------------
-- NOTE средний результаты факультета ХТиТ по каждой дисциплине
------------------------------------------------------------------------------
select G.FACULTY, G.PROFESSION, SUBJECT, round(avg(cast(NOTE as float)),2)[AVG NOTE]
from PROGRESS
    inner join STUDENT S on S.IDSTUDENT = PROGRESS.IDSTUDENT
    inner join GROUPS G on G.IDGROUP = S.IDGROUP
    where G.FACULTY = N'ХТиТ'
 group by G.PROFESSION, SUBJECT, G.FACULTY
------------------------------------------------------------------------------
-- NOTE средний результаты факультета ХТиТ union ТОВ по каждой дисциплине
------------------------------------------------------------------------------
select G.FACULTY, G.PROFESSION, SUBJECT, round(avg(cast(NOTE as float)),2)[AVG NOTE]
from PROGRESS
    inner join STUDENT S on S.IDSTUDENT = PROGRESS.IDSTUDENT
    inner join GROUPS G on G.IDGROUP = S.IDGROUP
    where G.FACULTY = N'ТОВ'
 group by G.PROFESSION, SUBJECT, G.FACULTY
union all
select G.FACULTY, G.PROFESSION, SUBJECT, round(avg(cast(NOTE as float)),2)[AVG NOTE]
from PROGRESS
    inner join STUDENT S on S.IDSTUDENT = PROGRESS.IDSTUDENT
    inner join GROUPS G on G.IDGROUP = S.IDGROUP
    where G.FACULTY = N'ХТиТ'
 group by G.PROFESSION, SUBJECT, G.FACULTY

-- TASK 8
------------------------------------------------------------------------------
-- NOTE средний результаты факультета ХТиТ union ТОВ по каждой дисциплине
------------------------------------------------------------------------------
select G.FACULTY, G.PROFESSION, SUBJECT, round(avg(cast(NOTE as float)),2)[AVG NOTE]
from PROGRESS
    inner join STUDENT S on S.IDSTUDENT = PROGRESS.IDSTUDENT
    inner join GROUPS G on G.IDGROUP = S.IDGROUP
    where G.FACULTY = N'ТОВ'
 group by G.PROFESSION, SUBJECT, G.FACULTY
intersect
select G.FACULTY, G.PROFESSION, SUBJECT, round(avg(cast(NOTE as float)),2)[AVG NOTE]
from PROGRESS
    inner join STUDENT S on S.IDSTUDENT = PROGRESS.IDSTUDENT
    inner join GROUPS G on G.IDGROUP = S.IDGROUP
    where G.FACULTY = N'ХТиТ'
 group by G.PROFESSION, SUBJECT, G.FACULTY

-- TASK 9
------------------------------------------------------------------------------
-- NOTE средний результаты факультета ХТиТ union ТОВ по каждой дисциплине
------------------------------------------------------------------------------
select G.FACULTY, G.PROFESSION, SUBJECT, round(avg(cast(NOTE as float)),2)[AVG NOTE]
from PROGRESS
    inner join STUDENT S on S.IDSTUDENT = PROGRESS.IDSTUDENT
    inner join GROUPS G on G.IDGROUP = S.IDGROUP
    where G.FACULTY = N'ТОВ'
 group by G.PROFESSION, SUBJECT, G.FACULTY
except
select G.FACULTY, G.PROFESSION, SUBJECT, round(avg(cast(NOTE as float)),2)[AVG NOTE]
from PROGRESS
    inner join STUDENT S on S.IDSTUDENT = PROGRESS.IDSTUDENT
    inner join GROUPS G on G.IDGROUP = S.IDGROUP
    where G.FACULTY = N'ХТиТ'
 group by G.PROFESSION, SUBJECT, G.FACULTY

-- TASK 10
------------------------------------------------------------------------------
-- NOTE количество оценок 8 или 9
------------------------------------------------------------------------------
select PROGRESS.SUBJECT, count(*) as [count 8 or 9]
from PROGRESS
group by PROGRESS.SUBJECT, PROGRESS.NOTE
having PROGRESS.NOTE = 8 or PROGRESS.NOTE = 9
order by [count 8 or 9] desc

-- TASK 11 MARKET
begin
use Market

------------------------------------------------------------------------------
-- NOTE сумму товаров, среднюю стоимость, и самый дешевый и дорогой товар
------------------------------------------------------------------------------
select CategoryName,
    round(sum(ProductPrice),1) as [summ all products],
    round(avg(ProductPrice),1) as [avg all products],
    min(ProductPrice) as [min price product],
    max(ProductPrice) as [max price product]
from products
inner join productcategories p on p.CategoryID = products.ProductCategory
    group by CategoryName

------------------------------------------------------------------------------
-- NOTE сумму товаров по категориям
------------------------------------------------------------------------------
select CategoryName, round(sum(ProductPrice),1) as SummAllCategories
    from products
    inner join productcategories p on p.CategoryID = products.ProductCategory
    group by rollup (CategoryName)

------------------------------------------------------------------------------
-- NOTE  категории товаров суммой больше 200
------------------------------------------------------------------------------
select CategoryName, round(sum(ProductPrice),1) as SummAllCategories
    from products
    inner join productcategories p on p.CategoryID = products.ProductCategory
    group by CategoryName
    having sum(ProductPrice) > 200

------------------------------------------------------------------------------
-- NOTE  intersect
------------------------------------------------------------------------------
select P2.CategoryID,P2.CategoryName
    from products P1, productcategories P2
intersect
select P3.CategoryID, p3.CategoryName
    from productcategories P3
    join products p4 on p3.CategoryID = P4.ProductCategory

------------------------------------------------------------------------------
-- NOTE  except
------------------------------------------------------------------------------
select P2.CategoryID,P2.CategoryName
    from products P1, productcategories P2
except
select P3.CategoryID, p3.CategoryName
    from productcategories P3
    join products p4 on p3.CategoryID = P4.ProductCategory

end