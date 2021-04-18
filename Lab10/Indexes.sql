--------- LAB 10 ---------
use tempdb
exec SP_HELPINDEX 'AUDITORIUM_TYPE'

-- TASK 1
drop index #EXPLRE_CL
drop table #EXPLRE

CREATE table  #EXPLRE
 (    TIND int,
      TFIELD varchar(100)
  );


set nocount on;
declare @i int = 0;
    while @i<100000
    begin insert #EXPLRE(TIND, TFIELD)
        values (floor(2000)*rand(),replicate(N'строка', 10));
        if(@i%100=0) print @i;
    set @i = @i + 1;
end;

SELECT * FROM #EXPLRE where TIND between 1500 and 2000 order by TIND

checkpoint;                 --фиксация БД
DBCC DROPCLEANBUFFERS;      --очистить буферный кэш

CREATE clustered index #EXPLRE_CL on #EXPLRE(TIND asc)

exec SP_HELPINDEX '#EXPLRE'

-- TASK 2
CREATE table #EX
(    TKEY int,
      CC int identity(1, 1),
      TF varchar(100)
);

  set nocount on;
  declare @i int = 0;
  while   @i < 20000       -- добавление в таблицу 20000 строк
  begin
       INSERT #EX(TKEY, TF) values(floor(30000*RAND()), replicate(N'строка ', 10));
        set @i = @i + 1;
  end;

  SELECT count(*)[количество строк] from #EX;
  SELECT * from #EX
  checkpoint;                 --фиксация БД
  DBCC DROPCLEANBUFFERS;      --очистить буферный кэш

  CREATE index #EX_NONCLU on #EX(TKEY, CC)
  SELECT * from  #EX where  TKEY > 1500 and  CC < 4500;
  SELECT * from  #EX order by  TKEY, CC

-- TASK 3
  CREATE  index #EX_TKEY_X on #EX(TKEY) INCLUDE (CC)
  SELECT CC from #EX where TKEY>15000

-- TASK 4
SELECT TKEY from  #EX where TKEY between 5000 and 19999;
SELECT TKEY from  #EX where TKEY>15000 and  TKEY < 20000;
SELECT TKEY from  #EX where TKEY=17000 ;

CREATE  index #EX_WHERE on #EX(TKEY) where (TKEY>=15000 and  TKEY < 20000);

-- TASK 5
SELECT name [Индекс], avg_fragmentation_in_percent [Фрагментация (%)]
        FROM sys.dm_db_index_physical_stats(DB_ID(N'TEMPDB'),
        OBJECT_ID(N'#EX'), NULL, NULL, NULL) ss
        JOIN sys.indexes ii on ss.object_id = ii.object_id and ss.index_id = ii.index_id
                                                                                                    WHERE name is not null;
INSERT top(10000) #EX(TKEY, TF) select TKEY, TF from #EX;

ALTER index #EX_NONCLU on #EX reorganize;

ALTER index #EX_WHERE on #EX rebuild with (online = off);

-- TASK 6
DROP index #EX_TKEY_X on #EX;
    CREATE index #EX_TKEY_X on #EX(TKEY)
        with (fillfactor = 65);

INSERT top(50)percent INTO #EX(TKEY, TF)
SELECT TKEY, TF  FROM #EX;

SELECT name [Индекс], avg_fragmentation_in_percent [Фрагментация (%)]
       FROM sys.dm_db_index_physical_stats(DB_ID(N'TEMPDB'),
       OBJECT_ID(N'#EX'), NULL, NULL, NULL) ss  JOIN sys.indexes ii
                                     ON ss.object_id = ii.object_id and ss.index_id = ii.index_id
                                                                                          WHERE name is not null;

-- TASK 7
------------------------------------------------------------------------------
-- NOTE  my indexes from database Market
------------------------------------------------------------------------------
use Market

-- NOTE create new indexes
create index category_sort_asc on products(ProductCategory asc);
create index category_sort_less_twelve on products (ProductCategory asc) where ProductCategory < 12;
create index product_name_include on products (ProductName asc) include (ProductName)
-- NOTE use select
select ProductName from products where ProductCategory < 12;
select ProductName from products;

-- NOTE check fragmentation
SELECT name [Индекс], avg_fragmentation_in_percent [Фрагментация (%)]
       FROM sys.dm_db_index_physical_stats(DB_ID(N'Market'),
       OBJECT_ID(N'products'), NULL, NULL, NULL) ss  JOIN sys.indexes ii
                    ON ss.object_id = ii.object_id and ss.index_id = ii.index_id
                                                                                          WHERE name is not null;
