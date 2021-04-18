-- LAB 9 --

use SIA_UNIVERSITY;

--Task 1
declare
    @_char char(6) = 'Spring',
    @_varchar varchar(6) = 'Spring',
    @_datatime datetime ,
    @_time time,
    @_int int,
    @_smallint smallint,
    @_tint tinyint,
    @_numeric numeric(12,5);

set @_datatime = '2004-05-24T14:25:10';
set @_time = '12AM';
select @_smallint = 255;
select  @_tint = 2, @_numeric = 777.777;

print @_char ;
print @_varchar ;
print @_datatime ;
print @_time ;

select  @_int value_int, @_smallint value_smallint, @_tint value_tinyint, @_numeric value_numeric;

-- TASK 2

declare
    @capacity int = (select sum(AUDITORIUM_CAPACITY) from AUDITORIUM ),
    @_quantityAuditorium int,
    @_capacityAvg float,
    @_quantityLessAvg int,
    @_totalCapacity int;

print @capacity;
if @capacity > 200
    begin
        set @_quantityAuditorium = (select count(*)  from AUDITORIUM);
        set @_capacityAvg = (select avg(AUDITORIUM_CAPACITY)  from AUDITORIUM);
        set @_quantityLessAvg = (select count(*) from AUDITORIUM where AUDITORIUM_CAPACITY < @_capacityAvg);

        print 'Quantity auditoriums: ' + cast(@_quantityAuditorium as nvarchar);
        print 'Average capacity: ' + cast(@_capacityAvg as nvarchar);
        print 'Quantity capacity more 200: ' + cast(@_quantityLessAvg as nvarchar);
        print 'Percent auditoriums capacity more 200: ' + cast((cast(@_quantityLessAvg as float)/cast(@_quantityAuditorium as float)*100) as nvarchar) + '%';
    end
else
    begin
        set @_totalCapacity = (select sum(AUDITORIUM_CAPACITY)  from AUDITORIUM);
        print 'Total capacity: ' + cast(@_totalCapacity as nvarchar);
    end

-- TASK 3
PRINT CAST(@@ROWCOUNT AS VARCHAR) + N' - число обработанных строк; '
PRINT CAST(@@VERSION AS VARCHAR) + N' версия SQL Server; '
PRINT CAST(@@SPID AS VARCHAR) + N' - возвращает системный идентификатор процесса, назначенный сервером текущему подключению;'
PRINT CAST(@@ERROR AS VARCHAR) + N' - код последней ошибки; '
PRINT CAST(@@SERVERNAME AS VARCHAR) + N' - имя сервера; '
PRINT CAST(@@TRANCOUNT AS VARCHAR) + N' - возвращает уровень вложенности транзакции; '
PRINT CAST(@@FETCH_STATUS AS VARCHAR) + N' - проверка результата считывания строк результирующего набора; '
PRINT CAST(@@NESTLEVEL AS VARCHAR) + N' - уровень вложенности текущей процедуры; ';

--Task 4
declare @z float, @t float, @x float
set @t = 200
set @x = 200
if @t > @x
	set @z = convert(int, sin(@t))^2
else if @t < @x
	set @z = 4*(@t + @x)
else
	set @z = 1 - EXP(@x - 2)
print 'Z =  ' + cast(@z as varchar)

SELECT substring(STUDENT.NAME, 1, charindex(' ', STUDENT.NAME))
+substring(STUDENT.NAME, charindex(' ', STUDENT.NAME)+1,1)+'.'
+substring(STUDENT.NAME, charindex(' ', STUDENT.NAME, charindex(' ', STUDENT.NAME)+1)+1,1)+'.' AS [STUDENT NAME]
FROM STUDENT;

select NAME,p.SUBJECT,P.NOTE,STUDENT.IDSTUDENT,datename(weekday,PDATE)
from STUDENT
inner join PROGRESS P on STUDENT.IDSTUDENT = P.IDSTUDENT
 where SUBJECT = N'СУБД'

-- TASK 5
declare @quantityNote int = (select count(*) from PROGRESS where NOTE > 6);
if @quantityNote > 20
    begin
        print 'Quantity note more six and than more 20 ';
        print 'Quantity note more than six: ' + cast(@quantityNote as nvarchar);
    end
else
    begin
         print 'Quantity note more six and than less 20 ';
        print 'Quantity note more than six: ' + cast(@quantityNote as nvarchar);
    end

-- TASK 6
SELECT STUDENT.NAME, AVG(PROGRESS.NOTE) [AVERAGE],
    CASE
	    WHEN AVG(PROGRESS.NOTE) BETWEEN 1 AND 3 THEN 'retake the exam'
	    WHEN AVG(PROGRESS.NOTE) BETWEEN 5 AND 7 THEN 'somehow passed the exam'
	    ELSE 'maybe he was studying for the exam'
	END RESULT
FROM STUDENT
    INNER JOIN PROGRESS ON PROGRESS.IDSTUDENT = STUDENT.IDSTUDENT
GROUP BY STUDENT.NAME

--Task 7
create table #TEMP(
	ID int,
	RAND int,
	MESSAGE varchar(max)
	)

declare @index int = 0
while @index < 10
	begin
	insert #TEMP values (@index, floor(20000*rand()),('message' + CAST(@index AS varchar)))
	set @index += 1
	end

select * from #TEMP

drop table #TEMP

--Task 8
DECLARE @y INT = 1
PRINT @y+5
PRINT @y+9
RETURN
PRINT 'HELLO'


--TASK 9
BEGIN TRY
UPDATE dbo.AUDITORIUM SET AUDITORIUM_CAPACITY = N'А' where AUDITORIUM.AUDITORIUM_TYPE LIKE N'%ЛК%'
END TRY
BEGIN CATCH
PRINT ERROR_NUMBER()
PRINT ERROR_MESSAGE()
PRINT ERROR_LINE()
PRINT ERROR_PROCEDURE()
PRINT ERROR_SEVERITY()
PRINT ERROR_STATE()
END CATCH