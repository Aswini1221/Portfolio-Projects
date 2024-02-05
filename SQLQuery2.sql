use Portfolio1
go
create table t11 (id int)
insert into t11 values(1)
insert into t11 values(1)
insert into t11 values(1)
insert into t11 values(2)
insert into t11 values(2)
insert into t11 values(3)
insert into t11 values(null)

create table t12 (id int)
insert into t12 values(1)
insert into t12 values(1)
insert into t12 values(2)
insert into t12 values(2)
insert into t12 values(2)
insert into t12 values(4)
insert into t12 values(null)

select * from t11

select * from t12

 select count(*) from t11 join t12 on t11.id= t12.id
 
 select count(*) from t11 Left join t12 on t11.id= t12.id
 
 select count(*) from t11  right join t12 on t11.id= t12.id

 
 select count(*) from t11  full join t12 on t11.id= t12.id

 
 select count(*) from t11  cross join t12 

 select * from employee
 select MAX(salary) from employee where salary <( select Max(salary) from employee)
 --select * from
-- (select empid,ename,salary,dense_rank() over(partition by salary order by salary desc)as rn from employee) a
 --where rn=1

 select  distinct salary from employee e1 where 3-1= (select count(distinct salary) from employee e2 where e2.salary > e1.salary)