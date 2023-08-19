use ineuron;
show tables;

create table id_skill
(id int,
tech varchar(30));

insert into id_skill values (1, "DS"),
(1, "Tableau"),
(1, "SQL"),
(2, "R"),
(2, "PowerBI"),
(3, "SQL");

select * from id_skill;

/*	display ID's having all the 3 skills :  DS, Tableau, SQL */
select v_id id from 
(select id v_id, count(*) v_cnt from id_skill where tech in ("DS", "Tableau", "SQL")
 group by id) tb
 where v_cnt = 3;

create table product_info
(prod_id int,
prod_desc varchar(30),
constraint pi_pk_01 primary key (prod_id));

insert into product_info values (1001, "My_Blog"),
(1002, "My_YouTube"),
(1003, "My_Inst"),
(1004, "My_Medium"),
(1005, "Krish_YouTube");

select * from product_info;

create table product_likes
(user_id int,
prod_id int,
like_date date,
constraint pl_fk_01 foreign key (prod_id)
references product_info(prod_id));

insert into product_likes values(2001, 1001, "2023-08-19"),
(2001, 1005, "2023-05-13"),
(2002, 1002, "2023-08-19");

select * from product_likes;

/*	display products which don't have nay likes
	Note - MySQL don't support minus operation so use outer join */
select distinct pi.prod_id
from product_info pi
left join product_likes pl
using (prod_id)
where pl.prod_id is null;
