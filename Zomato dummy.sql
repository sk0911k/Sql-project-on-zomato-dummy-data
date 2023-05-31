                        #### zomato project ####
create database zomato
use zomato

CREATE TABLE golduser_signup(
userid integer,
gold_signup_date date); 

INSERT INTO golduser_signup(userid, gold_signup_date) 
 VALUES (1,'2022-05-11'),
 (2, '2022-05-12')
 
 select * from golduser_signup

CREATE TABLE users(
userid integer,
signup_date date); 

INSERT INTO users
 VALUES (1,'2022-09-12'),
(2,'2022-08-13'),
(3,'2022-08-14');

CREATE TABLE sales(
userid integer,
created_date date,
product_id integer); 

INSERT INTO sales 
 VALUES (1,'2022-09-12',2),
(2,'2022-09-01',1),
(3,'2022-09-21',3),
(4,'2022-09-29',2),
(5,'2022-09-25',3),
(6,'2022-09-22',2),
(7,'2022-09-14',1),
(8,'2022-09-13',4)


CREATE TABLE product(
product_id integer,
product_name text,
price integer); 

INSERT INTO product 
 VALUES
(1,'xyz',980),
(2,'acb',870),
(3,'sjgjj',330);


select * from sales;
select * from product;
select * from golduser_signup;
select * from users;

Q.1)- What is a total amount each customer spend on zomato

select a.userid,sum(b.price) as total_amount from sales a inner join product b on a.product_id=b.product_id group by useridselect a.userid , sum(b.price) as total_amount from sales a inner join product b on a.product_id = b.product_id group by userid

Q.2)- How many days each coustomer visited zomato

select userid,count(created_date)customer_visited from sales group by userid

Q 3- What was first_rank product purchase by each customer

select*,rank()over(partition by userid order by product_id)rnk from sales

Q 4)-What was the most purchase item on the menu and how many times

select product_id,count(product_id) as most_purchase from sales group by product_id

Q 5) which item was the most popular for each customer

select*from
(select*,rank()over(partition by userid order by most_purchase desc)rnk from
(select userid,product_id,count(product_id)most_purchase from sales group by userid,product_id)a)b where rnk=1

Q 6) -which item was purchase first by the customer after they become a member


select*from
(select*,rank()over(partition by userid order by gold_signup_date)rnk from
(select a.userid,a.product_id,a.created_date,b.gold_signup_date from sales a inner join golduser_signup b on a.userid=b.userid
and created_date>=gold_signup_date)a)b where rnk=1

Q-7) which item was purchase first by the customer before they become a member

select*from
(select*,rank()over(partition by userid order by gold_signup_date)rnk from
(select a.userid,a.product_id,a.created_date,b.gold_signup_date from sales a inner join golduser_signup b on a.userid=b.userid
and created_date<=gold_signup_date)a)b where rnk=1

Q-8) What is the total order and amout spent for each member

select userid,count(created_date)total_order,sum(price)total_amt from
(select c.*,d.price from
(select a.userid,a.product_id,a.created_date,b.gold_signup_date from sales a inner join golduser_signup b on a.product_id=b.userid )c
inner join product d on c.product_id=d.product_id)e group by userid

Q 9) If buying each product genarate points for 5rs=1 Blinkit point and product has diffrent points 
xyz=5rs
acb=10rs
sjgjj=5rs

select userid ,sum(total_points)as total_points_earned from
(select e.* ,amt/point as total_points from
(select d.*,case when product_id=1 then 5 when product_id=2 then 10 when product_id=3 then 5 else 0 end as point from 
(select c.userid,c.product_id,sum(price)amt from
(select a.*,b.price from sales a inner join product b on a.product_id=b.product_id)c group by userid,product_id)d)e)f group by userid

Q 10) rank all the transaction of the coustomer

select*,rank()over(partition by userid order by created_date)rnk from sales

Q 11) Rank all the transaction for each member whenever they are a Blinkit gold member for every transaction mark as NA

select c.*,case when gold_signup_date is null then 0 else rank()over(partition by userid order by created_date desc)end as rnk from
(select a.userid,a.created_date,a.product_id,b.gold_signup_date from sales a left join golduser_signup b on a.userid=b.userid
and created_date>=gold_signup_date)c

