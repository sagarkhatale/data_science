use ineuron;

create table city
(ID				int,
NAME			varchar(17),
COUNTRY_CODE	varchar(3),
DISTRICT		varchar(20),
POPULATION		int,
constraint city_pk_01 primary key (ID));

/* 	Q1. Query all columns for all American cities in the CITY table with populations larger than 100000.
	The CountryCode for America is USA.	*/
select * from city where country_code = 'USA' and population > 100000;

/*	Q2. Query the NAME field for all American cities in the CITY table with populations larger than 120000.
	The CountryCode for America is USA.	*/
select name from city where country_code = 'USA' and population > 120000;

/*	Q3. Query all columns (attributes) for every row in the CITY table.	*/
select * from city;

/*	Q4. Query all columns for a city in CITY with the ID 1661.	*/
select * from city where id = 1661;

/*	Q5. Query all attributes of every Japanese city in the CITY table. The COUNTRYCODE for Japan is JPN.	*/
select * from city where country_code = 'JPN';

/*	Q6. Query the names of all the Japanese cities in the CITY table. The COUNTRYCODE for Japan is JPN.	*/
select name from city where country_code = 'JPN';

create table station
(ID		int,
CITY	varchar(21),
STATE	varchar(2),
LAT_N	int,
LONG_W	int,
constraint station_pk_01 primary key (ID));

/*	Q7. Query a list of CITY and STATE from the STATION table.	*/
select city, state from station;

/*	Q8. Query a list of CITY names from STATION for cities that have an even ID number.
	Print the results in any order, but exclude duplicates from the answer.	*/
select city from station where (id % 2) = 0;

/*	Q9. Find the difference between the total number of CITY entries in the table
	and the number of distinct CITY entries in the table.*/
select count(city) Tot_City, count(distinct(city)) Dist_City, count(city) - count(distinct(city)) Diff from station;

/*	Q10. Query the two cities in STATION with the shortest and longest CITY names, as well as their
	respective lengths (i.e. number of characters in the name). If there is more than one smallest or
	largest city, choose the one that comes first when ordered alphabetically.	*/
(select min(length(city)), city from station
group by city
order by 1, 2
limit 1)
union all
(select max(length(city)), city from station
group by city
order by 1 desc, 2
limit 1);

/*	Q11. Query the list of CITY names starting with vowels (i.e., a, e, i, o, or u) from STATION.
	Your result cannot contain duplicates.	*/
select distinct city from station where lower(city) regexp '^[aeiou]';

/*	Q12. Query the list of CITY names ending with vowels (a, e, i, o, u) from STATION.
	Your result cannot contain duplicates.	*/
select distinct city from station where lower(city) regexp '[aeiou]$';

/*	Q13. Query the list of CITY names from STATION that do not start with vowels.
	Your result cannot contain duplicates.	*/
select distinct city from station where lower(city) regexp '^[^aeiou]';

/*	Q14. Query the list of CITY names from STATION that do not end with vowels.
	Your result cannot contain duplicates.	*/
select distinct city from station where lower(city) regexp '[^aeiou]$';

/*	Q15. Query the list of CITY names from STATION that either do not start with vowels or do not end with vowels.
	Your result cannot contain duplicates.	*/
select distinct city from station where lower(city) regexp '^[^aeiou]' or lower(city) regexp '[^aeiou]$';

/*	Q16. Query the list of CITY names from STATION that do not start with vowels and do not end with vowels.
	Your result cannot contain duplicates.	*/
select distinct city from station where lower(city) regexp '^[^aeiou]' and lower(city) regexp '[^aeiou]$';

create table product
(prod_id int,
prod_name varchar(30),
unit_price int,
constraint product_pk_01 primary key (prod_id));

insert into product
values
	(1001, 'Poco M2 Pro', 13500),
	(1002, 'Nokia 6670', 10000),
    (1003, 'Moto g40', 13999),
    (1004, 'iPhone 13 Pro', 49500);

create table sales
(seller_id int,
prod_id int,
buyer_id int,
sale_date date,
quantity int,
price int,
constraint sales_fk_01 foreign key(prod_id) references product(prod_id));

insert into sales
values
	(1, 1001, 1, '2020-09-09', 1, 13500),
    (2, 1002, 1, '2003-08-08', 1, 10000),
    (1, 1003, 1, '2022-08-19', 1, 13999),
    (3, 1004, 2, '2023-08-23', 1, 49500);

/*	Q17. Write an SQL query that reports the products that were only sold in the 3rd quarter of 2022.
	That is, between 2022-07-01 and 2022-09-30 inclusive.	*/
select distinct pd.prod_name from 
product pd, sales sl
where sl.prod_id = pd.prod_id
and sale_date between '2022-07-01' and '2022-09-30';

create table views
(article_id int,
author_id int,
viewer_id int,
view_date date);

insert into views
values
	(1, 3, 5, '2019-08-01'),
    (1, 3, 6, '2019-08-02'),
    (2, 7, 7, '2019-08-01'),
    (2, 7, 6, '2019-08-02'),
    (4, 7, 1, '2019-07-22'),
    (3, 4, 4, '2019-07-21'),
    (3, 4, 4, '2019-07-21');

/*	Q18. Write an SQL query to find all the authors that viewed at least one of their own articles.
	Return the result table sorted by id in ascending order.	*/
select distinct v.id from (select author_id id, viewer_id vi, count(*) vc
							from views
							where author_id = viewer_id
							group by author_id, viewer_id
						  ) v
where v.vc >= 1
order by v.id;

create table delivery
(delivery_id int,
customer_id int,
order_date date,
cust_pref_del_date date,
constraint delivery_pk_01 primary key (delivery_id));

insert into delivery
values
	(1, 1, '2019-08-01', '2019-08-02'),
    (2, 5, '2019-08-02', '2019-08-02'),
    (3, 1, '2019-08-11', '2019-08-11'),
    (4, 3, '2019-08-24', '2019-08-26'),
    (5, 4, '2019-08-21', '2019-08-22'),
    (6, 2, '2019-08-11', '2019-08-13');

/*	Q19. If the customer's preferred delivery date is the same as the order date, then the order is called immediately;
	otherwise, it is called scheduled. Write an SQL query to find the percentage of immediate orders in the table,
    rounded to 2 decimal places.	*/
select format((100 * (select count(1) from delivery where order_date = cust_pref_del_date) / (select count(1) from delivery)), 2)
from dual;

create table ads
(ad_id int,
user_id int,
action enum('Clicked', 'Viewed', 'Ignored'),
constraint ads_pk_01 primary key (ad_id, user_id));

insert into ads
values
	(1, 1, 1),
    (2, 2, 1),
    (3, 3, 2),
    (5, 5, 3),
    (1, 7, 3),
    (2, 7, 2),
    (3, 5, 1),
    (1, 4, 2),
    (2, 11, 2),
    (1, 2, 1);

/*	Q20. Write an SQL query to find the ctr of each Ad. Round ctr to two decimal points.
	Return the result table ordered by ctr in descending order and by ad_id in ascending order in case of a tie.
	Formula: total clicks / (total clicks + total views) * 100
    Explanation:
		for ad_id = 1, ctr = (2/(2+1)) * 100 = 66.67
		for ad_id = 2, ctr = (1/(1+2)) * 100 = 33.33
		for ad_id = 3, ctr = (1/(1+1)) * 100 = 50.00
		for ad_id = 5, ctr = 0.00, Note that ad_id = 5 has no clicks or views.
	Note that we do not care about Ignored Ads.	*/
select distinct a1.ad_id, cl.click, v.vw, ifnull(format(cl.click / (cl.click + v.vw) * 100, 2), 0) ctr
from ads a1
left join (select c1.ad_id, c1.action, count(*) click
				from ads c1 where c1.action = 'Clicked'
                group by c1.ad_id, c1.action
		  ) cl
on a1.ad_id = cl.ad_id
left join (select c1.ad_id, c1.action, count(*) vw
				from ads c1 where c1.action = 'Viewed'
                group by c1.ad_id, c1.action
		  ) v
on a1.ad_id = v.ad_id
order by 1;

create table employee
(emp_id		int,
 team_id	int,
 constraint emp_pk_01 primary key (emp_id));
 
 insert into employee
 values
	(1, 8),
    (2, 8),
    (3, 8),
    (4, 7),
    (5, 9),
    (6, 9);
 
/*	Q21. Write an SQL query to find the team size of each of the employees.	*/
select e.emp_id, tc.team_size
from employee e, (select team_id, count(*) team_size from employee group by team_id) tc
where e.team_id = tc.team_id;

create table countries
(country_id		int,
 country_name	varchar(30),
 constraint countries_pk_01 primary key (country_id));

create table weather
(country_id		int,
 weather_state	int,
 day			date,
 constraint weather_pk_01 primary key (country_id, day),
 constraint weather_fk_01 foreign key(country_id) references countries(country_id));
 
 insert into countries
 values
	(2, 'USA'),
    (3, 'Australia'),
    (7, 'Peru'),
    (5, 'China'),
    (8, 'Morocco'),
    (9, 'Spain'),
    (1, 'Bharat');

insert into weather
values
    (2, 15, '2019-11-01'),
    (2, 12, '2019-10-28'),
    (2, 12, '2019-10-27'),
    (3, -2, '2019-11-10'),
    (3, 0, '2019-11-11'),
    (3, 3, '2019-11-12'),
    (5, 16, '2019-11-07'),
    (5, 18, '2019-11-09'),
    (5, 21, '2019-11-23'),
    (7, 25, '2019-11-28'),
    (7, 22, '2019-12-01'),
    (7, 20, '2019-12-02'),
    (8, 25, '2019-11-05'),
    (8, 27, '2019-11-15'),
    (8, 31, '2019-11-25'),
    (9, 7, '2019-10-23'),
    (9, 3, '2019-12-23'),
    (1, 27, '2019-11-01'),
    (1, 25, '2019-11-02'),
    (1, 38, '2019-11-03');

/*	Q22. Write an SQL query to find the type of weather in each country for November 2019.
	The type of weather is:
	● Cold if the average weather_state is less than or equal 15,
	● Hot if the average weather_state is greater than or equal to 25, and
	● Warm otherwise.	*/
with avg_state as
(select c.country_name,
		sum(w.weather_state) / count(w.weather_state) avg_st
 from countries c, weather w
 where c.country_id = w.country_id
 and day between '2019-11-01' and '2019-11-30'
 group by c.country_name)
select
	c.country_name,
	case
		when a.avg_st <= 15 then 'Cold'
		when a.avg_st >= 25 then 'Hot'
		else 'Warm'
	end weather_type
from countries c, avg_state a
where c.country_name = a.country_name;

create table prices
(prod_id	int,
 start_date	date,
 end_date	date,
 price		int,
 constraint priecs_pk_01 primary key (prod_id, start_date, end_date));

create table unit_sold
(prod_id		int,
 purchase_date	date,
 units			int,
 constraint unit_sold_fk_01 foreign key (prod_id) references prices(prod_id));

insert into prices
values
	(1, '2019-02-17', '2019-02-28', 5),
    (1, '2019-03-01', '2019-03-22', 20),
    (2, '2019-02-01', '2019-02-20', 15),
    (2, '2019-02-21', '2019-03-31', 30);

insert into unit_sold
values
	(1, '2019-02-25', 100),
    (1, '2019-03-01', 15),
    (2, '2019-02-10', 200),
    (2, '2019-03-22', 30);

/*	Q23. Write an SQL query to find the average selling price for each product.
	average_price should be rounded to 2 decimal places.	*/
select pe.prod_id, format(sum(pe.earning)/sum(pe.units), 2) avg_price
from (select p.prod_id, p.price, u.units, (p.price * u.units) earning
		from prices p, unit_sold u
		where p.prod_id = u.prod_id
		and u.purchase_date between p.start_date and p.end_date) pe
group by pe.prod_id;

create table activity
(player_id		int,
 device_id		int,
 event_date		date,
 games_played	int,
 constraint activity_pk_01 primary key (player_id, event_date));
 
insert into activity
values
	(1, 2, '2016-03-01', 5),
    (1, 2, '2016-05-02', 6),
    (2, 3, '2017-06-25', 1),
    (3, 1, '2016-03-02', 0),
    (3, 4, '2018-07-03', 5);

/*	Q24. Write an SQL query to report the first login date for each player.	*/
select player_id, min(event_date) from activity
group by player_id;

/*	Q25. Write an SQL query to report the device that is first logged in for each player.	*/
select a.player_id, a.device_id from 
activity a, (select player_id, min(event_date) min_date from activity
			 group by player_id) md
where a.player_id = md.player_id
and a.event_date = md.min_date;

create table products
(prod_id		int,
 prod_name		varchar(30),
 prod_category	varchar(20),
 constraint products_pk_01 primary key (prod_id));

create table orders
(prod_id	int,
 order_date	date,
 unit		int,
 constraint orders_fk_01 foreign key (prod_id) references products(prod_id));
 
 insert into products
 values
	(1, 'Leetcode Solutions', 'Book'),
    (2, 'Jewels of Stringology', 'Book'),
    (3, 'HP', 'Laptop'),
    (4, 'Lenovo', 'Laptop'),
    (5, 'Leetcode Kit', 'T-shirt');

insert into orders
values
	(1, '2020-02-05', 60),
    (1, '2020-02-10', 70),
    (2, '2020-01-18', 30),
    (2, '2020-02-11', 80),
    (3, '2020-02-17', 2),
    (3, '2020-02-24', 3),
    (4, '2020-03-01', 20),
    (4, '2020-03-04', 30),
    (4, '2020-03-04', 60),
    (5, '2020-02-25', 50),
    (5, '2020-02-27', 50),
    (5, '2020-03-01', 50);

/*	Q26. Write an SQL query to get the names of products that have at least 100 units ordered in February 2020
	and their amount.	*/
select p.prod_name, sum(o.unit)
from products p, orders o
where p.prod_id = o.prod_id
and o.order_date between '2020-02-01' and '2020-02-29'
group by p.prod_name
having sum(o.unit) >= 100;

create table users
(user_id	int,
name		varchar(50),
mail		varchar(70));

insert into users
values
	(1, 'Winston', 'winston@leetcode.com'),
    (2, 'Jonathan', 'jonathanisgreat'),
    (3, 'Annabelle', 'bella-@leetcode.com'),
    (4, 'Sally', 'sally.come@leetcode.com'),
    (5, 'Marwan', 'quarz#2020@leetcode.com'),
    (6, 'David', 'david69@gmail.com'),
    (7, 'Shapiro', '.shapo@leetcode.com');

/*	Q27. Write an SQL query to find the users who have valid emails.
	A valid e-mail has a prefix name and a domain where:
	● The prefix name is a string that may contain letters (upper or lower case), digits, 
		underscore	'_', period '.', and/or dash '-'. The prefix name must start with a letter.
	● The domain is '@leetcode.com'	*/
-- valid email having domain as '@leetcode.com'
select * from users where mail REGEXP '^[A-Za-z0-9].[A-Za-z0-9_.-]*@leetcode.com';
-- valid email having any valid domain
select * from users where mail REGEXP '^[A-Za-z0-9].[A-Za-z0-9_.-]*@[A-Za-z0-9.-]+[.][A-Za-z]+$';

create table customers
(customer_id	int,
name			varchar(50),
country			varchar(30),
constraint customers_pk_01 primary key(customer_id));

insert into customers
values
	(1, 'Winston', 'USA'),
    (2, 'Jonathan', 'Peru'),
    (3, 'Moustafa', 'Egypt');

insert into product
values
	(10, 'LC Phone', 300),
    (20, 'LC T-Shirt', 10),
    (30, 'LC Book', 45),
    (40, 'LC Keychain', 2);

select * from product;

create table orders_28
(order_id	int,
customer_id	int,
product_id	int,
order_date	date,
quantity	int,
constraint orders_28_pk_01 primary key(order_id),
constraint orders_28_fk_01 foreign key(customer_id) references customers(customer_id));

insert into orders_28
values
	(1, 1, 10, '2020-06-10', 1),
    (2, 1, 20, '2020-07-10', 1),
    (3, 1, 30, '2020-07-10', 2),
    (4, 2, 10, '2020-06-10', 2),
    (5, 2, 40, '2020-07-10', 10),
    (6, 3, 20, '2020-06-10', 2),
    (7, 3, 30, '2020-06-10', 2),
    (9, 3, 30, '2020-05-10', 3);

/*	Q28. Write an SQL query to report the customer_id and customer_name of customers who have spent at
	least $100 in each month of June and July 2020.	*/
select o28.customer_id, month(o28.order_date) o_month, sum((o28.quantity * p.unit_price)) bill_price
from product p, orders_28 o28
where o28.product_id = p.prod_id
group by o28.customer_id, o_month
having bill_price >= 100;

select c.customer_id, c.name
from customers c,
	(select o28.customer_id, month(o28.order_date) o_month, sum((o28.quantity * p.unit_price)) bill_price
	from product p, orders_28 o28
	where o28.product_id = p.prod_id
	group by o28.customer_id, o_month
	having bill_price >= 100) po
where c.customer_id = po.customer_id
and po.o_month in (6, 7)
group by c.customer_id, c.name
having count(po.o_month) = 2;

create table TVProgram
(program_date	date,
content_id		int,
channel			varchar(30),
constraint tvprogram_pk_01 primary key(program_date, content_id));

insert into TVProgram
values
	('2020-06-10 08:00', 1, 'LC-Channel'),
    ('2020-05-11 12:00', 2, 'LC-Channel'),
    ('2020-05-12 12:00', 3, 'LC-Channel'),
    ('2020-05-13 14:00', 4, 'Disney Ch'),
    ('2020-06-18 14:00', 4, 'Disney Ch'),
    ('2020-07-15 16:00', 5, 'Disney Ch');

create table content
(content_id		varchar(5),
title			varchar(30),
Kids_content	enum('Y','N'),
content_type	varchar(20),
constraint content_pk_01 primary key(content_id));

insert into content
values
	(1, 'Leetcode Movie', 'N', 'Movies'),
    (2, 'Alg. for Kids', 'Y', 'Series'),
    (3, 'Database Sols', 'N', 'Series'),
    (4, 'Aladdin', 'Y', 'Movies'),
    (5, 'Cinderella', 'Y', 'Movies');

/*	Q29. Write an SQL query to report the distinct titles of the kid-friendly movies streamed in June 2020.	*/
select c.title
from TVProgram tv, content c
where tv.content_id = c.content_id
and tv.program_date between '2020-06-01' and '2020-06-30'
and c.kids_content = 'Y'
and c.content_type = 'Movies';

create table npv
(id		int,
year	int,
npv		int,
constraint npv_pk_01 primary key(id, year));

insert into npv
values
	(1, 2018, 100),
    (7, 2020, 30),
    (13, 2019, 40),
    (1, 2019, 113),
    (2, 2008, 121),
    (3, 2009, 12),
    (11, 2020, 99),
    (7, 2019, 0);

create table queries
(id		int,
year	int,
constraint queries_pk_01 primary key(id, year));

insert into queries
values
	(1, 2019),
	(2, 2008),
	(3, 2009),
	(7, 2018),
	(7, 2019),
	(7, 2020),
	(13, 2019);

/*	Q30. Write an SQL query to find the npv of each query of the Queries table.	*/
select q.id, q.year, ifnull(n.npv, 0)
from queries q
left outer join npv n
on q.id = n.id and q.year = n.year;

/*	Q31. Duplicate of Q30	*/

create table employees
(id		int,
name	varchar(30),
constraint employees_pk_01 primary key(id));

insert into employees
values
	(1, 'Alice'),
    (7, 'Bob'),
	(11, 'Meir'),
    (90, 'Winston'),
    (3, 'Jonathan');

create table employeesUNI
(id			int,
unique_id	int,
constraint employeesUNI_pk_01 primary key(id, unique_id));

insert into employeesUNI
values
	(3, 1),
    (11, 2),
    (90, 3);

/*	Q32. Write an SQL query to show the unique ID of each user, If a user does not have a unique ID replace just show null.	*/
select u.unique_id, e.name
from employeesUNI u
right outer join employees e
on u.id = e.id;

create table users_33
(id		int,
name	varchar(30),
constraint users_33_pk_01 primary key(id));

insert into users_33
values
	(1, 'Alice'),
    (2, 'Bob'),
    (3, 'Alex'),
    (4, 'Donald'),
    (7, 'Lee'),
    (13, 'Jonathan'),
    (19, 'Elvis');

create table rides
(id			int,
user_id		int,
distance	int,
constraint rides_pk_01 primary key(id),
constraint rides_fk_01 foreign key(user_id) references users_33(id));

insert into rides
values
	(1, 1, 120),
    (2, 2, 317),
    (3, 3, 222),
    (4, 7, 100),
    (5, 13, 312),
    (6, 19, 50),
    (7, 7, 120),
    (8, 19, 400),
    (9, 7, 230);

/*	Q33. Write an SQL query to report the distance travelled by each user.	*/
select u.name, ifnull(sum(r.distance), 0)
from users_33 u
left outer join rides r
on u.id = r.user_id
group by u.name
order by 2 desc, 1;

/*	Q34. Duplicate of Q26	*/

create table movies
(movie_id	int,
title		varchar(20),
constraint movies_pk_01 primary key(movie_id));

insert into movies
values
	(1, 'Avengers'),
    (2, 'Frozen 2'),
    (3, 'Joker');

create table MovieRating
(movie_id	int,
user_id		int,
rating		int,
created_at	date,
constraint movierating_pk_01 primary key(movie_id, user_id));

insert into MovieRating
values
	(1, 1, 3, '2020-01-12'),
    (1, 2, 4, '2020-02-11'),
    (1, 3, 2, '2020-02-12'),
    (1, 4, 1, '2020-01-01'),
    (2, 1, 5, '2020-02-17'),
    (2, 2, 2, '2020-02-01'),
    (2, 3, 2, '2020-03-01'),
    (3, 1, 3, '2020-02-22'),
    (3, 2, 4, '2020-02-25');

/*	Q35-1. Write an SQL query to:
	● Find the name of the user who has rated the greatest number of movies.
	  In case of a tie, return the lexicographically smaller user name.	*/
select u33.name, mr.user_id, count(1) cnt
from MovieRating mr, users_33 u33
where mr.user_id = u33.id
group by u33.name, mr.user_id
order by 3 desc, 1;

select umr.name from
(select u33.name, mr.user_id, count(1) cnt
from MovieRating mr, users_33 u33
where mr.user_id = u33.id
group by u33.name, mr.user_id
order by 3 desc, 1) umr
LIMIT 1;

/*	Q35-2. Write an SQL query to:
	● Find the movie name with the highest average rating in February 2020.
      In case of a tie, return the lexicographically smaller movie name.	*/
select max_mr.title from
(select mr.movie_id, m.title, sum(mr.rating) max_rating
from MovieRating mr, movies m
where mr.created_at between '2020-02-01' and '2020-02-29'
and mr.movie_id = m.movie_id
group by mr.movie_id
order by max_rating desc, m.title) max_mr
LIMIT 1;

/*	Q36. Duplicate of Q33	*/

/*	Q37. Duplicate of Q32	*/

create table departments
(id		int,
name	varchar(30),
constraint departments_pk_01 primary key(id));

insert into departments
values
	(1, 'Electrical Engineering'),
    (7, 'Computer Engineering'),
    (13, 'Business Administration');

create table students
(id		int,
name	varchar(30),
dept_id	int,
constraint students_pk_01 primary key(id));

insert into students
values
	(23, 'Alice', 1),
    (1, 'Bob', 7),
    (5, 'Jennifer', 13),
    (2, 'John', 14),
    (4, 'Jasmine', 77),
    (3, 'Steve', 74),
    (6, 'Luis', 1),
    (8, 'Jonathan', 7),
    (7, 'Daiana', 33),
    (11, 'Madelynn', 1);

/* 	Q38. Write an SQL query to find the id and the name of all students
		who are enrolled in departments that no longer exist.	*/
select s.id, s.name
from students s
where s.dept_id not in (select d.id from departments d);

create table calls
(from_id	int,
to_id		int,
duration	int);

insert into calls
values
	(1,2,59),
    (2,1,11),
    (1,3,20),
    (3,4,100),
    (3,4,200),
    (3,4,200),
    (4,3,499);

/*	Q39. Write an SQL query to report the number of calls and the total call duration
		 between each pair of distinct persons (person1, person2) where person1 < person2.	*/
SELECT LEAST(from_id, to_id) AS person1, GREATEST(from_id, to_id) AS person2, 
		COUNT(*) AS call_count, SUM(duration) AS total_call_duration
FROM calls
GROUP BY LEAST(from_id, to_id), GREATEST(from_id, to_id)
HAVING person1 < person2;

/*	Q40. Duplicate of Q23	*/

create table warehouse
(name		varchar(30),
product_id	int,
units		int,
constraint warehouse_pk_01 primary key(name, product_id));

insert into warehouse
values
	('LCHouse1', 1, 1),
    ('LCHouse1', 2, 10),
    ('LCHouse1', 3, 5),
    ('LCHouse2', 1, 2),
    ('LCHouse2', 2, 2),
    ('LCHouse3', 4, 1);

create table products_41
(product_id		int,
product_name	varchar(20),
Width			int,
Length			int,
Height			int,
constraint products_41_pk_01 primary key(product_id));

insert into products_41
values
	(1, 'LC-TV', 5, 50, 40),
    (2, 'LC-KeyChain', 5, 5, 5),
    (3, 'LC-Phone', 2, 10, 10),
    (4, 'LC-T-Shirt', 4, 10, 20);

/*	Q41. Write an SQL query to report the number of cubic feet of volume the inventory occupies in each warehouse.	*/
select w.name, sum(w.units * pv.p_vol) volumn
from warehouse w, (select p.product_id, (p.width * p.length * p.height) p_vol from products_41 p) pv
where w.product_id = pv.product_id
group by w.name;

create table sales_42
(sale_date	date,
fruit		enum('apples', 'oranges'),
sold_num	int,
constraint sales_42_pk_01 primary key(sale_date, fruit));

insert into sales_42
values
	('2020-05-01', 'apples', 10),
    ('2020-05-01', 'oranges', 8),
    ('2020-05-02', 'apples', 15),
    ('2020-05-02', 'oranges', 15),
    ('2020-05-03', 'apples', 20),
    ('2020-05-03', 'oranges', 0),
    ('2020-05-04', 'apples', 15),
    ('2020-05-05', 'oranges', 16);

/*	Q42. Write an SQL query to report the difference between the number of apples and oranges sold each day.	*/
select a.sale_date, (a.sold_num - o.sold_num) diff from
(select f1.sale_date, f1.sold_num from sales_42 f1 where f1.fruit = 'apples') a,
(select f2.sale_date, f2.sold_num from sales_42 f2 where f2.fruit = 'oranges') o
where a.sale_date = o.sale_date;

/*	Q43. Write an SQL query to report the fraction of players that logged in again on the day after the day they
		first logged in, rounded to 2 decimal places. In other words, you need to count the number of players
		that logged in for at least two consecutive days starting from their first login date, then divide that
		number by the total number of players.	*/
with PlayerLoginDays AS
(select player_id, event_date, DATE_ADD(event_date, interval 1 day) next_date from activity)
select round(count(a1.player_id)/(select count(distinct player_id) from activity),2)
from activity a1, PlayerLoginDays pld
where a1.player_id = pld.player_id
and a1.event_date = pld.next_date;

create table employee_44
(id			int,
name		varchar(20),
department	varchar(20),
managerId	int,
constraint employee_44_pk_01 primary key(id));

insert into employee_44
values
	(101, 'John', 'A', NULL),
    (102, 'Dan', 'A', 101),
    (103, 'James', 'A', 101),
    (104, 'Amy', 'A', 101),
    (105, 'Anne', 'A', 101),
    (106, 'Ron', 'B', 101);

/*	Q44. Write an SQL query to report the managers with at least five direct reports.	*/
with mngr_emp as
(select managerid, count(id)
from employee_44
group by managerid
having count(id) >= 5)
select e.name from employee_44 e, mngr_emp me
where e.id = me.managerid;

/*	Q45. Write an SQL query to report the respective department name and number of students majoring in
		each department for all departments in the Department table (even ones with no current students).
		Return the result table ordered by student_number in descending order. In case of a tie, order them by
		dept_name alphabetically.	*/
with dept_stud as
(select dept_id dept, count(id) stud_in_dept from students group by dept_id)
select d.name, ds.stud_in_dept from departments d, dept_stud ds
where d.id = ds.dept
order by 2 desc;

create table products_46
(prod_key	int,
constraint products_46_pk_01 primary key(prod_key));

insert into products_46
values
	(5),
    (6);

create table customers_46
(cust_id	int,
prod_key	int,
constraint customers_46_fk_01 foreign key(prod_key) references products_46(prod_key));

insert into customers_46
values
	(1,5),
    (2,6),
    (3,5),
    (3,6),
    (1,6);

/*	Q46. Write an SQL query to report the customer ids from the Customer table 	that bought all the products in the Product table.	*/
select c.cust_id from customers_46 c
group by c.cust_id
having count(distinct c.prod_key) = (select count(1) from products_46);

create table employee_47
(emp_id		int,
name		varchar(30),
exp_year	int,
constraint employee_47_pk_01 primary key(emp_id));

insert into employee_47
values
	(1,'Ketan',3),
    (2,'Aniket',2),
    (3,'Jeevan',3),
    (4,'Dinesh',2);

create table project
(proj_id	int,
emp_id		int,
constraint project_pk_01 primary key(proj_id, emp_id),
constraint project_fk_01 foreign key(emp_id) references employee_47(emp_id));

insert into project
values
	(1,1),
    (1,2),
    (1,3),
    (2,1),
    (2,4);

/*	Q47. Write an SQL query that reports the most experienced employees in each project.
	In case of a tie, report all employees with the maximum number of experience years	*/
with proj_emp_exp as
(select p.proj_id, p.emp_id,
		dense_rank() over (partition by p.proj_id order by e.exp_year desc) exp_rank
from employee_47 e, project p
where p.emp_id = e.emp_id)
select proj_id, emp_id from proj_emp_exp
where exp_rank = 1;

create table books
(book_id	int,
name		varchar(30),
available_from	date,
constraint books_pk_01 primary key(book_id));

insert into books
values
(1,'Kalila AndDemna','2010-01-01'),
(2,'28 Letters','2012-05-12'),
(3,'The Hobbit','2019-06-10'),
(4,'13 Reasons Why','2019-06-01'),
(5,'The Hunger Games','2008-09-21');

create table orders_48
(order_id	int,
book_id		int,
quantity	int,
dispatch_date	date,
constraint orders_48_pk_01 primary key(order_id),
constraint orders_48_fk_01 foreign key(book_id) references books(book_id));

insert into orders_48
values
	(1, 2, 1, '2018-05-01'),
    (2, 3, 8, '2018-06-12'),
    (3, 4, 9, '2018-07-01'),
    (4, 1, 10, '2018-08-01'),
    (5, 3, 11, '2018-07-12');

insert into orders_48
values
	(6, 5, 9, '2018-07-12');

/*	Q48. Write an SQL query that reports the books that have sold less than 10 copies in the last year,
	excluding books that have been available for less than one month from today. Assume today is 2019-06-23.	*/
select o.book_id, o.quantity, o.dispatch_date from books b, orders_48 o
where o.book_id = b.book_id
and b.available_from <= date_sub('2019-06-23', interval 1 month)
and o.dispatch_date between date_sub('2019-06-23', interval 365 day) and '2019-06-23'
and o.quantity < 10;

create table enrollments
(student_id	int,
course_id	int,
grade		int,
constraint enrollments_pk_01 primary key(student_id, course_id));

insert into enrollments
values
	(2,2,95),
    (2,3,95),
    (1,1,90),
    (1,2,99),
    (3,1,80),
    (3,2,75),
    (3,3,82);

/*	Q49. Write a SQL query to find the highest grade with its corresponding course for each student. In case of
a tie, you should find the course with the smallest course_id.	*/
with highest_rank as
(select student_id, course_id, grade,
	rank() over (partition by student_id order by grade desc, course_id) grade_desc
from enrollments)
select student_id, min(course_id), grade from highest_rank a
where grade_desc = 1
group by student_id, course_id;

/*	Q50. The winner in each group is the player who scored the maximum total points within the group. In the
	case of a tie, the lowest player_id wins. Write an SQL query to find the winner in each group.	*/
