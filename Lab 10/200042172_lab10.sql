set serveroutput on size  1000000

-----Task 1-----
declare
    total_rows number(2);
    rows_updated number(2);
begin
    update department
        set budget=budget - (0.10*budget)
            where budget>99999;

    rows_updated := sql%rowcount; 

    select count(*) into total_rows from department;

    dbms_output.put_line('Number of departments that did not get affected: ' || to_char(total_rows-rows_updated));

end;
/

-----Task 2-----
-----procedure-----
create or replace 
procedure instructor_schedule
(free_day in time_slot.day%type, s_hr in time_slot.start_hr%type, e_hr in time_slot.end_hr%type)
is 
    ins_name instructor.name%type;
    ins_id instructor.id%type;

    cursor ins(free_day time_slot.day%type, s_hr time_slot.start_hr%type, e_hr time_slot.end_hr%type)
    is
        select id, name
        from instructor natural join teaches natural join section natural join time_slot
        where day=free_day and start_hr=s_hr and end_hr=e_hr;
    
begin
    open ins(free_day, s_hr, e_hr);
    loop
        fetch ins into ins_id, ins_name;
        exit when ins%notfound;
        dbms_output.put_line(ins_id || ' ' || ins_name);
    end loop;
    close ins;
end;
/

-----call-----
begin
    instructor_schedule('F', 8, 8);
end;
/

-----Task 3-----
-----procedure-----
create or replace
procedure top_students(n in int)
is
    std_id student.id%type;
    std_name student.name%type;
    std_dept_name student.dept_name%type;
    std_course_num int;

    cursor find_std
    is
        select id, max(name) as name, max(dept_name) as dept_name,count(course_id) as no_of_courses
        from student natural join takes
        group by id
        order by no_of_courses desc;
        
begin
    open find_std;
    loop
        fetch find_std into std_id, std_name, std_dept_name, std_course_num;
        exit when find_std%rowcount>n;
        dbms_output.put_line(std_id || ' ' || std_name || '     ' || std_dept_name || '     ' || std_course_num);
    end loop;
    close find_std;
end;
/

-----call-----
begin
    top_students(5);
end;
/

-----Task 4-----
-----trigger-----
drop sequence ins_seq;
create sequence ins_seq
minvalue 10000
maxvalue 99999
start with 10000
increment by 1
cache 500;

drop trigger trigger_generate_id;
create or replace 
trigger trigger_generate_id
before insert on instructor
for each row
begin
    select ins_seq.nextval
    into :new.id
    from dual;
end;
/

-----call-----
insert into instructor(name, dept_name, salary) values ('Mozart', 'Music', '40000');

-----Task 5-----
-----trigger-----
drop trigger assign_advisor;
create or replace
trigger assign_advisor
after insert on student
for each row
declare
    advisor_id instructor.id%type;
begin
    select ins into advisor_id
    from
    (
        select i.id as ins, max(i.dept_name), coalesce(count(a.s_id), 0) as c
        from instructor i left join advisor a on i.id=a.i_id
        where i.dept_name = :new.dept_name
        group by i.id
        order by c
    )
    where rownum<=1;

    insert into advisor(i_id,s_id) values(advisor_id,:new.ID);
end;
/

-----call-----
insert into student values ('12376', 'Shanta', 'History', '54');
