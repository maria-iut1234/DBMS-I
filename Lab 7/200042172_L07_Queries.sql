---task(a)---
select max(division_name), max(division_size), max(division_description), count(district_name)
from division
group by division_name;

---task(b)---
---view for number of citizens in a district---
create or replace view district_citizens as
select count(nid) as num
from citizen
group by district_name;

select *
from district
where district_name in (select district.district_name
                        from district, district_citizens
                        where district_citizens.num>=20000);

---task(c)---
select count(accident_id)
from accident natural join license natural join citizen
where nid=210;

---task(d)---
select hospital_id
from (select hospital_id, count(nid)
        from hospital natural join central_system
        group by hospital_id
        order by count(nid) desc)
where rownum<=5;

---task(e)---
select blood_group
from central_system natural join citizen;

---task(f)---
select division_name, count(nid) as density
from citizen natural join district natural join division
group by division_name;

---task(g)---
select district_name
from (select district_name, count(nid)
        from district natural join citizen
        group by district_name)
where rownum<=3;

---task(h)---
select count(accident_id)
from citizen natural join license natural join accident
group by district_name;

---task(i)---
select division_name
from (select division_name, count(accident_id)
        from citizen natural join license natural join accident natural join district natural join division
        group by division_name
        order by count(accident_id))
where rownum<=1;

---task(j)---
select count(accident_id)
from accident natural join license
where license_type='non-professional' or license_type='professional';

---task(k)---
select citizen_name
from citizen natural join central_system
where (date_of_admission-release_date) in 
    (select mix(date_of_admission-release_date)
    from central_system);

---task(l)---
create or replace view citizen_age as
select ((extract(year from sysdate))-(extract(year from date_of_birth))) as age, nid 
from citizen;

select division_name
from (select division_name, count(nid)
        from division natural join district natural join citizen natural join citizen_age
        where age<=30 and age>=15
        group by division_name
        order by count(nid))
where rownum<=1;

---task(m)---
select citizen_name
from citizen natural join license
where expired_date<sysdate;

---task(n)---
select count(accident_id)
from accident natural join license
where expired_date<sysdate;

---task(o)---
(select license_id
from license)
minus
(select license_id
from accident);

---task(p)---
select division_name, sum(no_deaths)
from accident natural join license natural join citizen natural join district natural join division
group by division_name;

---task(q)---
create or replace view citizen_age_license as
select ((extract(year from issue_date))-(extract(year from date_of_birth))) as age, nid 
from citizen natural join license;

select citizen_name
from citizen natural join license natural join citizen_age_license
where age<22 or age>40;

---task(r)---
select nid, citizen_name
from citizen natural join accident natural join central_system natural join license
where date_of_accident=date_of_admission;

---task(s)---
select max(hospital_name), max(patients)
from (select hospital_id, count(nid) as patients
        from hospital natural join central_system natural join citizen natural join district natural join division
        where division_name='Dhaka'
        group by hospital_id) natural join hospital
where rownum<=1;

---task(t)---
select nid
from citizen natural join license natural join accident
where district_name<>place_of_accident;
