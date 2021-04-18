/***********************************
************** lab 6 ***************
***********************************/

use SIA_UNIVERSITY
GO

------- TASK 1
select PULPIT_NAME,FACULTY_NAME
    from SIA_UNIVERSITY.dbo.PULPIT, SIA_UNIVERSITY.dbo.FACULTY
    where PULPIT.FACULTY = FACULTY.FACULTY
and FACULTY.FACULTY
    in (select PROFESSION.FACULTY
        from PROFESSION
        where PROFESSION_NAME like N'%технологи[ия]%'
        )

------- TASK 2
select distinct PULPIT_NAME, FACULTY_NAME
from PULPIT
    inner join FACULTY
        on PULPIT.FACULTY = FACULTY.FACULTY
        where PULPIT.FACULTY in
        (
        select PROFESSION.FACULTY
        from PROFESSION
            where PROFESSION_NAME like N'%технологи[ия]%'
        )

------- TASK 3
select distinct PULPIT_NAME, FACULTY_NAME
from PULPIT
    inner join FACULTY
        on PULPIT.FACULTY = FACULTY.FACULTY
    inner join PROFESSION
        on FACULTY.FACULTY = PROFESSION.FACULTY
        where PROFESSION.PROFESSION_NAME like  N'%технологи[ия]%'

------- TASK 4
select AUDITORIUM_TYPE, AUDITORIUM_CAPACITY
from AUDITORIUM A1
    where A1.AUDITORIUM_CAPACITY = (
        select top 1 A2.AUDITORIUM_CAPACITY
        from AUDITORIUM A2
        where A2.AUDITORIUM_TYPE = A1.AUDITORIUM_TYPE
        order by A2.AUDITORIUM_CAPACITY desc)
        order by A1.AUDITORIUM_CAPACITY desc

------- TASK 5
select FACULTY_NAME
from FACULTY
    where not exists(
        select *
        from PULPIT
         where FACULTY.FACULTY = PULPIT.FACULTY)

------- TASK 6
SELECT top 1
    (select avg (NOTE) from PROGRESS where SUBJECT = N'ОАиП')[ОАиП],
    (select avg (NOTE) from PROGRESS where SUBJECT = N'КГ')[БД],
    (select avg (NOTE) from PROGRESS where SUBJECT = N'СУБД')[СУБД]
FROM PROGRESS

------- TASK 7
select *
from PROGRESS
where PROGRESS.SUBJECT = N'ОАиП' and
      PROGRESS.NOTE >=all (select PROGRESS.NOTE
                          from PROGRESS
                          where PROGRESS.SUBJECT = N'ОАиП')

------- TASK 8
select *
from PROGRESS
where PROGRESS.SUBJECT = N'ОАиП' and
      PROGRESS.NOTE >any (select PROGRESS.NOTE
                          from PROGRESS
                          where PROGRESS.SUBJECT = N'ОАиП')