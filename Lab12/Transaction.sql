/***********************************
************** lab 12 **************
***********************************/
use SIA_UNIVERSITY

-- TASK 1
      set nocount on
	if  exists (select * from  SYS.OBJECTS where OBJECT_ID= object_id(N'DBO.USERS') )
	        drop table USERS;

	declare @c int, @flag char = 'c';           -- commit или rollback?

	SET IMPLICIT_TRANSACTIONS  ON   -- включ. режим неявной транзакции

	CREATE table USERS(users varchar(20),password varchar(20), role int); -- начало транзакции
		INSERT USERS values ('user1', '12345',0),('user2', '12345',0),('user3', '12345',0),('admin', '12345',1);
		set @c = (select count(*) from USERS);
		print N'количество строк в таблице X: ' + cast( @c as varchar(2));
		if @flag = 'c'  commit;                   -- завершение транзакции: фиксация
	          else   rollback;                                 -- завершение транзакции: откат
      SET IMPLICIT_TRANSACTIONS  OFF   -- выключ. режим неявной транзакции

	if  exists (select * from  SYS.OBJECTS       -- таблица USERS есть?
	            where OBJECT_ID= object_id(N'DBO.USERS') )
	print N'таблица USERS есть';
      else print N'таблицы USERS нет'

-- TASK 2
begin try
    begin tran
        insert USERS values ('user12', '00000', 1)
        --insert USERS values ('admin', '00000', 1)
        delete USERS where role = 1 and users = 'admin'
        select * from USERS
    commit tran;
end try
begin catch
    print error_message()
    if @@trancount > 0 rollback tran
end catch

-- TASK 3
declare @point varchar(32);
begin try
    begin tran
        insert USERS values ('user5', '00000', 0)
            set @point = 'save1';
            save tran @point;
        insert USERS values ('user6', '00000', 0)
            set @point = 'save1';
            save tran @point;
        --insert USERS values ('admin', '00000', 1)
        delete USERS where role = 1 and users = 'admin'
        select * from USERS
    commit tran;
end try
begin catch
    print error_message()
    if @@trancount > 0
        begin
            rollback tran @point;
        end
end catch

-- TASK 4
-- NOTE A --
	set transaction isolation level READ UNCOMMITTED
	begin transaction
	-------------------------- NOTE t1 ------------------
	select @@SPID, 'insert users' 'результат', * from USERS where users = 'admin';
	select @@SPID, 'update users'  'результат',  users, password from USERS where users = 'admin';
	commit;
	-------------------------- NOTE t2 -----------------
-- NOTE B --
	begin transaction
	select @@SPID
	insert USERS values ('user32', '8765', 1);
	update USERS set users  =  'superadmin'
                           where users = 'admin'
	-------------------------- NOTE t1 --------------------
	-------------------------- NOTE t2 --------------------
	rollback;

-- TASK 5
-- A ---
          set transaction isolation level READ COMMITTED
	begin transaction
	select count(*) from USERS 	where users = 'admin';
	-------------------------- t1 ------------------
	-------------------------- t2 -----------------
	select  'update USERS'  'результат', count(*)
	                           from USERS  where users = 'admin';
	commit;

	--- B ---
	begin transaction
	-------------------------- t1 --------------------
        update USERS set users = 'super' where users = 'admin';
        commit;
	-------------------------- t2 --------------------

-- TASK 6
-- A ---
          set transaction isolation level  REPEATABLE READ
	begin transaction
	select users from USERS where users = 'admin';
	-------------------------- t1 ------------------
	-------------------------- t2 -----------------
select IIF(users = 'admin', 'insert  USERS', ' ') 'результат', users from USERS where users = 'user12312';
	commit;

	--- B ---
	begin transaction
	-------------------------- t1 --------------------
          insert USERS values ('user12312','234234',  0);
          commit;
	-------------------------- t2 --------------------

-- TASK 7
-- A ---
          set transaction isolation level SERIALIZABLE
	begin transaction
	delete USERS where users = 'admin';
          insert USERS values ('user4', '12312', 0);
          update USERS set password = '12312' where users = 'admin';
          select  users from USERS  where users like 'user%';
	-------------------------- t1 -----------------
	select  users from USERS where users like 'user%';
	-------------------------- t2 ------------------
	commit;

	--- B ---
	begin transaction
	delete USERS where users = 'admin';
          insert USERS values ('admin2', '34234',1);
          select  users from USERS  where users like 'user%';
          -------------------------- t1 --------------------
          commit;
          select  users from USERS  where users like 'user%';
      -------------------------- t2 --------------------

-- TASK 8
begin tran
    insert users values ('admin2', '34234',1);
    begin tran
        update USERS set users = 'admin' where users = 'admin2'
    commit;
    if @@trancount > 0 rollback;
    select
            (select count(*) from USERS where users = 'admin') 'USERS',
            (select count(*) from USERS where password = '34234') 'PASSWORDS'