--number01(without intersect)--
select distinct customer.customer_name
from customer, depositor, borrower
where customer.customer_name=depositor.customer_name and
customer.customer_name=borrower.customer_name;

--number01(with intersect)--
select depositor.customer_name
from customer, depositor
where customer.customer_name=depositor.customer_name
intersect
select borrower.customer_name
from borrower, customer
where customer.customer_name=borrower.customer_name;

--number02(without union)--
select distinct customer.customer_name, customer.customer_street, customer.customer_city
from customer, depositor, borrower
where customer.customer_name=depositor.customer_name or
customer.customer_name=borrower.customer_name;

--number02(with union)--
select customer.customer_name, customer.customer_street, customer.customer_city
from customer, depositor
where customer.customer_name=depositor.customer_name
union
select customer.customer_name, customer.customer_street, customer.customer_city
from customer, borrower
where customer.customer_name=borrower.customer_name;

--number03(without minus)--
select distinct customer.customer_name, customer.customer_city
from customer, depositor, borrower
where customer.customer_name=borrower.customer_name and
borrower.customer_name not in 
    (select customer_name 
    from depositor);

--number03(with minus)--
select customer.customer_name, customer.customer_city
from customer, borrower
where customer.customer_name=borrower.customer_name
minus
select customer.customer_name, customer.customer_city
from customer, depositor
where customer.customer_name=depositor.customer_name;

--number04--
select sum(assets)
from branch;

--number05--
select branch.branch_city, coalesce(count(account.account_number), 0) as count_account_num
from branch
left join account on account.branch_name=branch.branch_name
group by branch.branch_city
order by branch.branch_city;

--number06--
select branch.branch_name, coalesce(avg(account.balance), 0) as avg_balance
from branch
left join account on branch.branch_name=account.branch_name
group by branch.branch_name
order by avg_balance desc;

--number07--
select branch.branch_city, coalesce(sum(account.balance), 0) as balance_sum
from branch
left join account on account.branch_name=branch.branch_name
group by branch.branch_city
order by branch.branch_city;

--number08(without having)--
select branch.branch_name, coalesce(avg(loan.amount), 0) as avg_loan
from branch
left join loan on branch.branch_name=loan.branch_name
where branch.branch_city!='Horseneck'
group by branch.branch_name
order by branch.branch_name;

--number08(with having)--
select branch.branch_name, coalesce(avg(loan.amount), 0) as avg_loan
from branch
left join loan on branch.branch_name=loan.branch_name
group by branch.branch_name
having branch.branch_name not in
    (select branch_name
    from branch
    where branch_city='Horseneck')
order by branch.branch_name;

--number09(without all)--
select depositor.customer_name, depositor.account_number
from depositor, account
where depositor.account_number=account.account_number and
account.balance = 
    (select max(account.balance) 
    from account);

--number09(with all)--
select depositor.customer_name, depositor.account_number
from depositor, account
where depositor.account_number=account.account_number and
account.balance>=all
    (select account.balance 
    from account);

--number10--
select distinct customer.customer_name, customer.customer_street, customer.customer_city
from customer, depositor, account, branch
where customer.customer_name=depositor.customer_name and
depositor.account_number=account.account_number and
branch.branch_name=account.branch_name and
branch.branch_city=customer.customer_city;

--number11(without having)--
select *
from 
    (select branch.branch_city, avg(loan.amount) as avg_loan
    from branch natural join loan
    group by branch.branch_city) query
where query.avg_loan>=1500;

--number11(with having)--
select branch_city, avg(loan.amount) as avg_loan
from branch natural join loan
group by branch_city
having avg(amount)>=1500;

--number12--
select branch_name
from account natural join branch
group by branch_name
having sum(balance)>
(select avg(account.balance)
from account);

--number13--
select distinct customer_name
from (select customer_name, sum(balance) as s_balance
from customer natural join (depositor natural join account)
group by customer_name) q1 natural join 
(select customer_name, amount
from customer natural join (borrower natural join loan)) q2
where q2.amount<=q1.s_balance;


--number14--
select branch.branch_name, branch.branch_city, branch.assets
from branch, customer
where branch.branch_city=customer.customer_city and
customer.customer_name in
(--customers with no account or loan--
select customer_name
from customer
where customer_name not in
(select customer.customer_name
from customer, depositor, borrower
where customer.customer_name=depositor.customer_name or
customer.customer_name=borrower.customer_name)) and
branch.branch_name in
(--branch used for loans--
select branch_name
from loan natural join borrower) and
branch.branch_name in
(--branch used for account--
select branch_name
from account natural join depositor);





