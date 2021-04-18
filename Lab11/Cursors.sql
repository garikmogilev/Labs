--------- LAB 10 ---------
use SIA_UNIVERSITY


-- TASK 1 cursor
---------------------------------------------------------------------------------------
declare cursorForSubject cursor for select SUBJECT from SUBJECT where PULPIT = N'ИСиТ';
---------------------------------------------------------------------------------------
declare @subject char(20), @s char(300)='';
open cursorForSubject;
fetch cursorForSubject into @subject;
print N'Список дисциплин на кафедре ИСиТ:';
while @@fetch_status = 0
    begin
        set @s = rtrim(@subject) + ',' + @s;
        fetch cursorForSubject into @subject;
    end
print @s;
close cursorForSubject;

-- TASK 2 local/global
---------------------------------------------------------------------------------------
declare cgProfession cursor local for select PROFESSION_NAME from PROFESSION;
---------------------------------------------------------------------------------------
declare @profession_name char(100), @p varchar(500)='';
open cgProfession;
fetch cgProfession into @profession_name;
while @@fetch_status = 0
    begin
        set @p = rtrim(@profession_name) + ' | ' + @p;
        fetch cgProfession into @profession_name;
    end
print '1 ' + @p;

declare @profession_name_2 char(100), @p2 varchar(500);
fetch cgProfession into @p2;
while @@fetch_status = 0
    begin
        set @p2 = rtrim(@profession_name_2) + ' ' + @p2;
        fetch cgProfession into @profession_name_2;
    end
print '2 ' + @p2;

---------------------------------------------------------------------------------------
declare cgProfession cursor global for select PROFESSION_NAME from PROFESSION;
---------------------------------------------------------------------------------------
open cgProfession;
declare @profession_name char(100), @p varchar(500)='';
fetch cgProfession into @profession_name;
while @@fetch_status = 0
    begin
        print @profession_name;
        fetch cgProfession into @profession_name;
    end
close cgProfession

open cgProfession;
declare @profession_name_2 char(100), @p2 varchar(500);
fetch cgProfession into @profession_name_2;
while @@fetch_status = 0
    begin
        set @p2 = rtrim(@profession_name_2) + ' ' + @p2;
        fetch cgProfession into @profession_name_2;
    end
print '2 ' + @p2;
close cgProfession;

-- TASK 3  local static/local dynamic
---------------------------------------------------------------------------------------
declare cgProfession cursor local static for select PROFESSION_NAME from PROFESSION;
---------------------------------------------------------------------------------------
open cgProfession;
declare @profession_name char(100), @p varchar(500)='';
-- NOTE add new profession
insert into PROFESSION values ('1-92 01 01',N'ФИТ',N'Программное обеспечение информационных технологий',N'инженер программист');
fetch cgProfession into @profession_name;
while @@fetch_status = 0
    begin
        print @profession_name;
        fetch cgProfession into @profession_name;
    end
close cgProfession
-- NOTE delete new profession
delete PROFESSION where PROFESSION = N'1-92 01 01';

---------------------------------------------------------------------------------------
declare cdProfession cursor local dynamic scroll for select PROFESSION_NAME  from PROFESSION;
---------------------------------------------------------------------------------------
open cdProfession;
declare @profession_name char(100);
-- NOTE add new profession
insert into PROFESSION values ('1-92 01 01',N'ФИТ',N'Программное обеспечение информационных технологий',N'инженер программист');
fetch cdProfession into @profession_name;
while @@fetch_status = 0
    begin
        print @profession_name;
        fetch cdProfession into @profession_name;
    end
close cdProfession
-- NOTE delete new profession
delete PROFESSION where PROFESSION = N'1-92 01 01';

-- TASK 4 local dynamic scroll
---------------------------------------------------------------------------------------
declare cdsProfession cursor local dynamic scroll for select row_number() over (order by PROFESSION_NAME),PROFESSION_NAME  from PROFESSION;
---------------------------------------------------------------------------------------
open cdsProfession;
declare @id int, @profession_name char(100);
-- NOTE first row
fetch cdsProfession into @id, @profession_name;
print cast(@id as varchar) +': '+ @profession_name;
-- NOTE relative 3
fetch relative 3 from cdsProfession into @id, @profession_name;
print cast(@id as varchar) +': '+@profession_name;
-- NOTE absolute 13
fetch absolute 13 from cdsProfession into @id, @profession_name;
print cast(@id as varchar) +': '+@profession_name;
-- NOTE prior (previous line)
fetch prior from cdsProfession into @id, @profession_name;
print cast(@id as varchar) +': '+@profession_name;
-- NOTE last
fetch last from cdsProfession into @id, @profession_name;
print cast(@id as varchar) +': '+@profession_name;
close cdsProfession

-- TASK 5 current of
declare @subject char(10), @note int;
declare cldProgress cursor local dynamic for select SUBJECT, NOTE from PROGRESS;
open cldProgress;
fetch cldProgress into @subject, @note;
update PROGRESS set NOTE = NOTE - 1 where current of cldProgress;
fetch cldProgress into @subject, @note;
delete PROGRESS where current of cldProgress;
close cldProgress;
insert PROGRESS values (N'ОАиП',1001,'2013-01-10',8);

-- TASK 6
drop table #TEMP
select PROGRESS.NOTE into #TEMP from PROGRESS
	inner join STUDENT on STUDENT.IDSTUDENT = PROGRESS.IDSTUDENT
	inner join GROUPS on GROUPS.IDGROUP = STUDENT.IDGROUP
select * from #TEMP

declare @note int = 0
declare CURS cursor for select * from #TEMP  for update
open CURS
while @@fetch_status = 0
	begin
	fetch CURS into @note
	if @note < 4
		delete PROGRESS where current of CURS
	end
close CURS
deallocate CURS

declare @id int = 0, @specId int
declare CURS cursor for select STUDENT.IDSTUDENT from STUDENT for update
OPEN CURS
while @@fetch_status = 0
	begin
	fetch CURS into @id
	if @id = @specId
	    update STUDENT set STUDENT.IDGROUP = STUDENT.IDGROUP + 1 where current of CURS
	end
close CURS
deallocate CURS