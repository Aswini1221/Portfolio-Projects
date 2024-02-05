create database test
use test
go
create table t1 (Id int)
insert into t1 values(null)
insert into t1 values(null)
select * from t1
create table t2 (id int)
insert into t2 values(null)

insert into t2 values(null)
select * from t2

select * from t1 join t2 on t1.Id= t2.id
select * from t1 left outer Join t2 on t1.Id =t2.id 
select * from t1 right outer Join t2 on t1.Id =t2.id 
select * from t1 full outer Join t2 on t1.Id =t2.id 
