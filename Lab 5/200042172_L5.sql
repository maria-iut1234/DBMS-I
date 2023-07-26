
---task01---
create or replace view Advisor_Selection
as 
select id, name, dept_name
from instructor;

---task02---
create or replace view Student_Count
as 
select max(Advisor_Selection.name) as advisor_name, count(advisor.s_id) as student_count
from Advisor_Selection
left join advisor on Advisor_Selection.id=advisor.i_id
group by Advisor_Selection.id;

---task03---
---task03(a)---
drop role student_role;
create role student_role;
grant create session to student_role;
grant select on course to student_role;
grant select on Advisor_Selection to student_role;

---task03(b)---
drop role course_teacher;
create role course_teacher;
grant create session to course_teacher;
grant select on course to course_teacher;
grant select on student to course_teacher;

---task03(c)---
drop role head_dept;
create role head_dept;
grant create session to head_dept;
grant course_teacher to head_dept;
grant select on instructor to head_dept;
grant insert on instructor to head_dept;

---task03(d)---
drop role administrator;
create role administrator;
grant create session to administrator;
grant select on department to administrator;
grant select on instructor to administrator;
grant update(budget) on department to administrator;

---task04---
---demonstrating task03(a)---
drop user s1;
create user s1 identified by ps1;
grant student_role to s1;
conn s1/ps1;
select * from swe200042172.Advisor_Selection;
select * from swe200042172.course;
drop table swe200042172.course; 
--will give insufficient privileges error--
conn swe200042172/cse4308

---demonstrating task03(b)---
drop user c1;
create user c1 identified by ps2;
grant course_teacher to c1;
conn c1/ps2;
select * from swe200042172.student;
select * from swe200042172.course;
drop table swe200042172.course; 
--will give insufficient privileges error--
conn swe200042172/cse4308

---demonstrating task03(c)---
drop user h1;
create user h1 identified by ps3;
grant head_dept to h1;
conn h1/ps3;
select * from swe200042172.student;
select * from swe200042172.course;
insert into swe200042172.instructor values ('24172', 'Maria', 'Music', '456700');
drop table swe200042172.course; 
--will give insufficient privileges error--
conn swe200042172/cse4308

---demonstrating task03(d)---
drop user a1;
create user a1 identified by ps4;
grant administrator to a1;
conn a1/ps4;
select * from swe200042172.department;
select * from swe200042172.instructor;
update swe200042172.department set budget='150000' where dept_name='Music';
drop table swe200042172.department; 
--will give insufficient privileges error--
conn swe200042172/cse4308

