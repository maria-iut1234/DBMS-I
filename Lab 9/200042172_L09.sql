set serveroutput on size 1000000
begin null;
end null;

---Warm-up Tasks 1---

-----1(a)-----
declare
    my_name varchar2(20);

begin
    my_name := '& my_name';
    dbms_output.put_line('My name is ' || my_name);
    exception
    when others then 
        dbms_output.put_line(sqlerrm);

end;
/

------1(b)------
declare
    my_id varchar2(20);

begin
    my_id := '& my_id';
    dbms_output.put_line('Length of ID is ' || length(my_id));

exception
    when others then
        dbms_output.put_line(sqlerrm);

end;
/

-----1(c)-----
declare
    num1 number;
    num2 number;

begin
    num1 := '& num1';
    num2 := '& num2';
    dbms_output.put_line('Product of num1 and num2 is ' || num1*num2);

exception
    when others then
        dbms_output.put_line(sqlerrm);

end;
/

-----1(d)-----
declare
    curr_date date := sysdate;

begin
    dbms_output.put_line(to_char(curr_date, 'DD-MON-YY HH12:MI:SS PM'));

exception
    when others then
        dbms_output.put_line(sqlerrm);

end;
/

-----1(e)-----
-----with case-----
declare
    num number;

begin
    num := '& num';
    dbms_output.put('The number ' || num || ' is a ' );

    case true
        when round(num, 0)=num then
            dbms_output.put_line('whole number.');
        else
            dbms_output.put_line('fractional number.');
    end case;

end;
/

-----without case-----
declare
    num number;

begin
    num := '& num';
    dbms_output.put('The number ' || num || ' is a ' );

    if(round(num, 0)=num)
        then dbms_output.put_line('whole number.');
    else
        dbms_output.put_line('fractional number.');
    end if;

end;
/

-----1(f)-----
-----procedure-----
create or replace
procedure check_prime(num in number, msg out varchar2)
as
begin  
    msg := ' is a prime number.';

    for i in 2..round(sqrt(num)) loop
        if mod(num, i)=0 
            then msg := ' is a composite number.';
            exit;
        end if;
    end loop;

end;
/

----checking procedure-----
declare
    num number;
    msg varchar2(20);
begin
    num := 23;
    check_prime(num, msg);
    dbms_output.put_line(num || msg);
end;
/

-----Task 2-----
-----2(a)-----
-----procedure-----
create or replace
procedure top_rated(n in number)
is
    row_num int;
    mov_id movie.mov_id%type;
    mov_title movie.mov_title%type;
    mov_year movie.mov_year%type;
    mov_language movie.mov_language%type;
    mov_releasedate movie.mov_releasedate%type;
    mov_country movie.mov_country%type;
    rev_stars rating.rev_stars%type;

    cursor find_movies(n number)
    is
        select *
        from
        (
            select mov_id, mov_title, mov_year, mov_language, mov_releasedate, mov_country, rev_stars
            from movie natural join rating
            where rev_stars>0
            order by rev_stars desc
        )
        where rownum<=n;
begin
    for row in (select count(*) as c from movie) loop
        if n>row.c then
            raise_application_error(-2000, 'Number exceeds total number of movies!');
        else
            open find_movies(n);
            loop
                fetch find_movies into mov_id, mov_title, mov_year, mov_language, mov_releasedate, mov_country, rev_stars;
                exit when find_movies%notfound;
                dbms_output.put_line(row_num);
                dbms_output.put_line('Movie ID: ' || mov_id);
                dbms_output.put_line('Movie Title: ' || mov_title);
                dbms_output.put_line('Movie Year: ' || mov_year);
                dbms_output.put_line('Movie Language: ' || mov_language);
                dbms_output.put_line('Movie Release Date: ' || mov_releasedate);
                dbms_output.put_line('Movie Country: ' || mov_country);
                dbms_output.put_line('Rev Stars: ' || rev_stars);
                dbms_output.put_line('-----');
            end loop;
            close find_movies;
        end if;
    end loop;
end;
/

-----call-----
declare
    num int;
begin
    num := '& num';
    top_rated(num);
end;
/

-----2(b)-----
-----function-----
create or replace
function movie_status(mov_title in movie.mov_title%type)
return varchar2
is
    mov_status varchar2(10);
    cast_num int;

    cursor find_status(m_title in movie.mov_title%type)
    is
        select count(act_id) as c
        from movie natural join casts
        where mov_title=m_title
        group by mov_id;

begin
    open find_status(mov_title);
    loop
        fetch find_status into cast_num;
        exit when find_status%notfound;
        if cast_num=1 then
            mov_status :='Solo';
        else
            mov_status :='Ensemble';
        end if;
    end loop;
return mov_status;
end;
/

-----call-----
declare
    movie varchar2(25);
begin
    movie := '& movie';
    dbms_output.put_line(movie_status(movie));
end;
/

-----2(c)-----
-----procedure-----
create or replace
procedure oscar_nominees
is
    dir_id director.dir_id%type;
    dir_firstname director.dir_firstname%type;
    dir_lastname director.dir_lastname%type;

    cursor find_nominees
    is
        select dir_id, dir_firstname, dir_lastname
        from director natural join direction natural join movie
        -----oscar movies-----
        where mov_id in (select mov_id
                            -----number of reviewers-----
                            from (select mov_id, count(rev_id) as rev_c
                                    from movie natural join rating
                                    group by mov_id
                                    order by count(rev_id) desc)q1 natural join
                            -----avg rating-----
                                (select mov_id, avg(rev_stars) as rat_c
                                    from movie natural join rating
                                    group by mov_id
                                    order by count(rev_stars) desc)q2
                            where rev_c>10 and rat_c>=7);

begin
    open find_nominees;
    loop
        fetch find_nominees into dir_id, dir_firstname, dir_lastname;
        exit when find_nominees%notfound;
        dbms_output.put_line('Director ID: ' || dir_id);
        dbms_output.put_line('Director First Name: ' || dir_firstname);
        dbms_output.put_line('Director Last Name: ' || dir_lastname);
        dbms_output.put_line('-----');
    end loop;
    close find_nominees;
end;
/

-----call-----
begin
    oscar_nominees;
end;
/

-----2(d)-----
-----function-----
create or replace
function movie_category(mv_title in movie.mov_title%type)
return varchar2
is
    mov_category varchar2(50);
    mov_year number;
    mov_avg_rating number;
    m_title movie.mov_title%type;

    cursor find_category(mv_title in movie.mov_title%type)
    is
        select m, y, rat_c
        from (-----returns the years for the movies-----
                select mov_id, max(mov_title) as m, max(extract(year from mov_releasedate))as y
                from movie
                group by mov_id
                order by y)q1 natural join
            (-----returns the avergae rating for each movie-----
                select mov_id, max(mov_title) as m, avg(rev_stars) as rat_c
                from movie natural join rating
                group by mov_id
                order by count(rev_stars) desc)q2
        where m=mv_title;

begin
    open find_category(mv_title);
    loop
        fetch find_category into m_title, mov_year, mov_avg_rating;
        exit when find_category%notfound;

        if mov_year>=1990 and mov_year<=1999 and mov_avg_rating>7.3 then
            mov_category :='Neat Nineties';
        elsif mov_year>=1980 and mov_year<=1989 and mov_avg_rating>7.1 then
            mov_category :='Ecstatic Eighties';
        elsif mov_year>=1970 and mov_year<=1979 and mov_avg_rating>6.9 then
            mov_category :='Super Seventies';
        elsif mov_year>=1960 and mov_year<=1969 and mov_avg_rating>6.7 then
            mov_category :='Sweet Sixties';
        elsif mov_year>=1950 and mov_year<=1959 and mov_avg_rating>6.5 then
            mov_category :='Fantastic Fifties';
        else
            mov_category := 'Garbage';
        end if;
    end loop;
return mov_category;
end;
/

-----call------
declare
    movie varchar2(25);
begin
    movie := '& movie';
    dbms_output.put_line(movie_category(movie));
end;
/