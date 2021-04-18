-- LAB 8 --

use SIA_UNIVERSITY


-- TASK 1
------------------------------------------------------------------------------
-- NOTE new view Academic
------------------------------------------------------------------------------

create view Academic
    as select
        TEACHER_NAME,
              GENDER,
              PULPIT
from TEACHER

------------------------------------------------------------------------------
-- NOTE request use for Academic
------------------------------------------------------------------------------
select * from Academic

------------------------------------------------------------------------------
-- NOTE alter Academic
------------------------------------------------------------------------------
alter view Academic
    as select
        TEACHER_NAME,
              PULPIT
from TEACHER

------------------------------------------------------------------------------
-- NOTE drop view an Academic
------------------------------------------------------------------------------
drop view Academic

-- TASK 2
------------------------------------------------------------------------------
-- NOTE new QuantityPulpit
------------------------------------------------------------------------------
create view QuantityPulpit
    as select FACULTY_NAME,
              count(*)[CountFaculty]
from FACULTY join PULPIT P on FACULTY.FACULTY = P.FACULTY
group by FACULTY_NAME

------------------------------------------------------------------------------
-- NOTE test QuantityPulpit
------------------------------------------------------------------------------
select * from QuantityPulpit

------------------------------------------------------------------------------
-- NOTE drop QuantityPulpit
------------------------------------------------------------------------------
drop view QuantityPulpit

-- TASK 3
------------------------------------------------------------------------------
-- NOTE new AUDITORIUMS
------------------------------------------------------------------------------
create view AUDITORIUMS
    as select
        AUDITORIUM_NAME,
        AUDITORIUM_TYPE
from AUDITORIUM
where AUDITORIUM_TYPE = N'ЛК'
------------------------------------------------------------------------------
-- NOTE insert used AUDITORIUMS
------------------------------------------------------------------------------
insert AUDITORIUMS values (N'200-3',N'ЛК'),
                          (N'100-3',N'ЛК')
------------------------------------------------------------------------------
-- NOTE drop AUDITORIUMS
------------------------------------------------------------------------------
drop view QuantityPulpit

-- TASK 4
------------------------------------------------------------------------------
-- NOTE new LecturesAuditorium
------------------------------------------------------------------------------
create view LecturesAuditorium
    as select
        AUDITORIUM_NAME,
        AUDITORIUM_TYPE
from AUDITORIUM
where AUDITORIUM_TYPE = N'ЛК' with check option

-- TASK 5
------------------------------------------------------------------------------
-- NOTE new view SUBJECTS
------------------------------------------------------------------------------
create view SUBJECTS
    as select top 100
        SUBJECT,
        SUBJECT_NAME
from SUBJECT
order by SUBJECT

-- TASK 6
------------------------------------------------------------------------------
-- NOTE new view QuantityPulpit + schemabinding
------------------------------------------------------------------------------
create view QuantityPulpit with schemabinding
    as select F.FACULTY_NAME,
              count(*)[CountFaculty]
from dbo.FACULTY F join dbo.PULPIT P on F.FACULTY = P.FACULTY
group by F.FACULTY_NAME

-- TASK 7
use Market
------------------------------------------------------------------------------
-- NOTE new view ShortInfoProduct + with check option
------------------------------------------------------------------------------
create view ShortInfoProduct
    as select ProductCategory,
              ProductName,
              ProductLongDesc,
              ProductPrice
from products
where ProductPrice != 0 with check option

------------------------------------------------------------------------------
-- NOTE new view QuantityProductCategory + schemabinding
------------------------------------------------------------------------------
create view QuantityProductCategory with schemabinding
    as select CategoryName,
              count(*)[QuantityProducts]
from dbo.products P join dbo.productcategories P2 on P2.CategoryID = P.ProductCategory
group by CategoryName

------------------------------------------------------------------------------
-- NOTE using my views
------------------------------------------------------------------------------

-- Short info of products
select * from ShortInfoProduct

-- Quantity products for category
select * from QuantityProductCategory

