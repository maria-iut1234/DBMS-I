---task 1---
SELECT COUNT(T_ID) 
FROM TRANSACTIONS 
WHERE A_ID=49;

---task 2---
SELECT COUNT(T_ID) 
FROM TRANSACTIONS 
WHERE TYPE='0';

---task 3---
SELECT * 
FROM TRANSACTIONS 
WHERE DTM BETWEEN TO_DATE('2021/06/01 00:00:00', 'yyyy/mm/dd hh24:mi:ss') AND 
TO_DATE('2022/01/01 00:00:00', 'yyyy/mm/dd hh24:mi:ss');

---task 4---
---view for balance---
create or replace view balance as
select sum(case
            when t.type='0' then amount
            when t.type='1' then -amount
            else 0
            end) as total, a_id
from transactions t
group by a_id;

---view for transaction amount---
create or replace view total_amount as
select sum(amount) as sum_amount, a_id
from transactions t
group by a_id;

---view for number of CIP---
create or replace view total_cip as
select distinct b.a_id
from balance b, total_amount t
where b.total>1000000 and t.sum_amount>5000000;

---number of CIP---
select count(*) as cip
from total_cip;

---view for number of VIP---
create or replace view total_vip as
select distinct b.a_id
from balance b, total_amount t
where b.total>500000 and b.total<900000 and 
t.sum_amount>2500000 and t.sum_amount<4500000;

---number of VIP---
select count(*) as vip
from total_vip;

---view for number of OP---
create or replace view total_op as
select distinct b.a_id
from balance b, total_amount t
where b.total<100000 and t.sum_amount<1000000;

---number of OP---
select count(*) as op
from total_op;

---number of people in neither category---
select count(a_id) as neither
from account
where a_id not in (select a_id from total_vip) and
a_id not in (select a_id from total_cip) and 
a_id not in (select a_id from total_op);