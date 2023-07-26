create user swe200042172 identified by cse4308;
grant create session, resource, dba to swe200042172;
conn swe200042172/cse4308;

create table instructor
(
id number not null,
name varchar(20) not null,
dept_name varchar(20) not null,
salary number not null
);

insert into instructor values(10101, 'Srinivasan', 'Comp. Sci.', 65000);
insert into instructor values(12121, 'Wu', 'Finance', 90000);
insert into instructor values(15151, 'Mozart', 'Music', 40000);
insert into instructor values(22222, 'Einstein', 'Physics', 95000);
insert into instructor values(32343, 'El Said', 'History', 60000);
insert into instructor values(33456, 'Gold', 'Physics', 87000);
insert into instructor values(45565, 'Katz', 'Comp. Sci.', 75000);
insert into instructor values(58583, 'Califieri', 'History', 62000);
insert into instructor values(76543, 'Singh', 'Finance', 80000);
insert into instructor values(76766, 'Crick', 'Biology', 72000);
insert into instructor values(83821, 'Brandt', 'Comp. Sci.', 92000);
insert into instructor values(98345, 'Kim', 'Elec. Eng.', 80000);

select * from instructor;
select id, name from instructor;
select name, dept_name from instructor where salary>70000;
select name, dept_name from instructor where salary>=10000 and salary<=80000;
select name, id from instructor where dept_name='Comp. Sci.';
select name, salary from instructor where dept_name='Finance';
select name, id from instructor where dept_name='Comp. Sci.' or salary>=75000;
select distinct dept_name from instructor;