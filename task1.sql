use pubs;

select * from sysobjects;

select name from sysobjects where xtype='U';

select * from authors;

select phone, au_id from authors;

select au_lname, state from authors;

select * from authors where state='CA';

select * from authors where au_lname='White' and state='CA';

select title from titles where ytd_sales > 8000;

select title from titles where royalty >= 12 and royalty <= 24;

select title from titles where royalty between 12 and 24;

select * from titles order by price;

select * from titles order by price asc, pub_id desc;

select * from titles order by price desc;

select max(price) from titles;

select avg(price) from titles;

select type, max(price) from titles group by type;

select title, price from titles where price >= (select avg(price) from titles) order by title;

select type, avg(price) from titles group by type having avg(price) > 15;

select type as Type, avg(price) as 'Average price', sum(ytd_sales) as 'Yearly sales' from titles group by type;

select (SUBSTRING(au_fname,1,1)+'. ' + au_lname) as Name, phone from authors;
