/***********************************
************** lab 5 ***************
***********************************/

use SIA_UNIVERSITY
go

------- task 1
select AUDITORIUM, AUDITORIUM_CAPACITY, AUDITORIUM_TYPENAME
from AUDITORIUM
    inner join AUDITORIUM_TYPE
        on AUDITORIUM.AUDITORIUM_TYPE = AUDITORIUM_TYPE.AUDITORIUM_TYPE

------- task 2
select AUDITORIUM, AUDITORIUM_CAPACITY, AUDITORIUM_TYPENAME
from AUDITORIUM
    inner join AUDITORIUM_TYPE
        on AUDITORIUM_TYPENAME like N'Компьютерный%'

------- task 3
select AUDITORIUM, AUDITORIUM_CAPACITY, AUDITORIUM_TYPENAME
from AUDITORIUM as A, AUDITORIUM_TYPE as T
    where  A.AUDITORIUM_TYPE = T.AUDITORIUM_TYPE

------- task 4
select STUDENT.NAME, PULPIT.PULPIT,FACULTY.FACULTY,PROFESSION.PROFESSION,SUBJECT.SUBJECT,STUDENT.IDSTUDENT,
    case
        when(PROGRESS.NOTE = 6) then N'Шесть'
        when(PROGRESS.NOTE = 7) then N'Семь'
        when(PROGRESS.NOTE = 8) then N'Восемь'
    end NOTE
from STUDENT
    inner join PROGRESS on PROGRESS.IDSTUDENT = STUDENT.IDSTUDENT and PROGRESS.NOTE between 6 and 8
    inner join SUBJECT on PROGRESS.SUBJECT = SUBJECT.SUBJECT
    inner join PULPIT on PULPIT.PULPIT = SUBJECT.PULPIT
    inner join FACULTY F  on F.FACULTY = PULPIT.FACULTY
    inner join GROUPS on STUDENT.IDGROUP = GROUPS.IDGROUP
    inner join PROFESSION on PROFESSION.PROFESSION= GROUPS.PROFESSION
    inner join FACULTY on PROFESSION.FACULTY = FACULTY.FACULTY and GROUPS.FACULTY = FACULTY.FACULTY
order by
         FACULTY desc,
         PULPIT desc,
         PROFESSION desc,
         STUDENT.NAME,
         PROGRESS.NOTE

-------- task 5  4=>5 modifier
select STUDENT.NAME, PULPIT.PULPIT,FACULTY.FACULTY,PROFESSION.PROFESSION,SUBJECT.SUBJECT,STUDENT.IDSTUDENT,
    case
        when(PROGRESS.NOTE = 6) then N'Шесть'
        when(PROGRESS.NOTE = 7) then N'Семь'
        when(PROGRESS.NOTE = 8) then N'Восемь'
    end NOTE
from STUDENT
    inner join PROGRESS on PROGRESS.IDSTUDENT = STUDENT.IDSTUDENT and PROGRESS.NOTE between 6 and 8
    inner join SUBJECT on PROGRESS.SUBJECT = SUBJECT.SUBJECT
    inner join PULPIT on PULPIT.PULPIT = SUBJECT.PULPIT
    inner join FACULTY F  on F.FACULTY = PULPIT.FACULTY
    inner join GROUPS on STUDENT.IDGROUP = GROUPS.IDGROUP
    inner join PROFESSION on PROFESSION.PROFESSION= GROUPS.PROFESSION
    inner join FACULTY on PROFESSION.FACULTY = FACULTY.FACULTY and GROUPS.FACULTY = FACULTY.FACULTY
order by
    (
        case
            when(PROGRESS.NOTE = 6) then 3
            when(PROGRESS.NOTE = 7) then 1
            when(PROGRESS.NOTE = 8) then 2
        end
    )

-------- task 6
select isnull(TEACHER_NAME,'***') as Преподаватель,PULPIT_NAME as Кафедра
from PULPIT
    left join TEACHER T on PULPIT.PULPIT = T.PULPIT

-------- task 7
BEGIN

select isnull(TEACHER_NAME,'***') as Преподаватель,PULPIT_NAME as Кафедра
from TEACHER
    left join PULPIT P on TEACHER.PULPIT = P.PULPIT

select isnull(TEACHER_NAME,'***') as Преподаватель,PULPIT_NAME as Кафедра
from TEACHER
    right join PULPIT P on TEACHER.PULPIT = P.PULPIT

END

-------- task 7
BEGIN
--full
select PULPIT.PULPIT_NAME Кафедра, isnull(T.TEACHER_NAME, '***') 'Имя преподавателя'
from PULPIT
    full join TEACHER T on PULPIT.PULPIT = T.PULPIT

--union

select PULPIT.PULPIT_NAME Кафедра, isnull(T.TEACHER_NAME, '***') 'Имя преподавателя'
from PULPIT
    left join TEACHER T on PULPIT.PULPIT = T.PULPIT
    union
select PULPIT.PULPIT_NAME Кафедра, isnull(T.TEACHER_NAME, '***') 'Имя преподавателя'
from PULPIT
    right join TEACHER T on PULPIT.PULPIT = T.PULPIT

-------------------

select PULPIT.PULPIT_NAME Кафедра, isnull(T.TEACHER_NAME, '***') 'Имя преподавателя'
from PULPIT
    right join TEACHER T on PULPIT.PULPIT = T.PULPIT

-------------------

select PULPIT.PULPIT_NAME Кафедра, isnull(TEACHER.TEACHER_NAME, '***') 'Имя преподавателя'
from PULPIT
full outer join TEACHER on PULPIT.PULPIT = TEACHER.PULPIT
where TEACHER.PULPIT is null

-------------------
end;

------- task 9
select AUDITORIUM.AUDITORIUM, AUDITORIUM_TYPE.AUDITORIUM_TYPENAME
from AUDITORIUM
cross join AUDITORIUM_TYPE
where AUDITORIUM.AUDITORIUM_TYPE = AUDITORIUM_TYPE.AUDITORIUM_TYPE





