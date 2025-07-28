-- task 2

--1.
SELECT au_lname,title_id FROM authors JOIN titleauthor ON authors.au_id = titleauthor.au_id;

--T:1.
SELECT title AS Title,SUBSTRING(au_fname,1,1)+'. '+au_lname AS Authors FROM titleauthor JOIN titles 
ON titles.title_id = titleauthor.title_id JOIN authors ON titleauthor.au_id = authors.au_id;

--T:1.
SELECT title AS Title,SUBSTRING(au_fname,1,1)+'. '+au_lname AS Authors,pub_name AS Publishers
FROM titleauthor JOIN titles ON titles.title_id = titleauthor.title_id JOIN
authors ON titleauthor.au_id = authors.au_id JOIN publishers ON titles.pub_id = publishers.pub_id;

--2.
SELECT au_lname,pub_name FROM authors,publishers;

--T:2.
SELECT SUBSTRING(au_fname,1,1)+'. '+au_lname as Authors,authors.city as City,pub_name as Publishers 
FROM authors JOIN publishers ON authors.city = publishers.city


--3.
SELECT * FROM titles WHERE royalty = (SELECT avg(royalty) FROM titles)

--T:3.
SELECT SUBSTRING(authors.au_fname,1,1)+'. '+au_lname as Authors FROM authors JOIN titleauthor
ON authors.au_id = titleauthor.au_id WHERE titleauthor.title_id IN 
(
  SELECT title_id
  FROM titles
  WHERE royalty = (SELECT MAX(royalty) FROM titles)
);

DROP TABLE Transactions;

DROP TABLE CustomerAndSuppliers;

--4.
CREATE TABLE CustomerAndSuppliers
(
   cusl_id char(6) primary key check(cusl_id like '[CS][0-9][0-9][0-9][0-9][0-9]'),
   cusl_fname char(15) not null,
   cusl_lname varchar(15),
   cusl_address text,
   cusl_telno char(12) check(cusl_telno like '01[0-9]-[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'),
   cusl_city char(12) default 'Rajshahi',
   sales_amnt money check(sales_amnt >= 0),
   proc_amnt money check(proc_amnt >= 0)
);

--5.
INSERT INTO CustomerAndSuppliers (cusl_id,cusl_fname,cusl_lname,cusl_address,cusl_telno,cusl_city,sales_amnt,proc_amnt)
VALUES ('C00002','Khaled','Hossain','Agargaon','017-00000090','Dhaka',10,50);

SELECT * FROM CustomerAndSuppliers;

DROP TABLE Item
--T:4.
CREATE TABLE Item
(
   item_id char(6) primary key check(item_id like 'P[0-9][0-9][0-9][0-9][0-9]'),
   item_name char(12),
   item_category char(10) check(item_category like '[A-Z]%'),
   item_price float(12) check(item_price >= 0),
   item_qoh int check(item_qoh >= 0),
   item_last_sold date default getdate()
);

INSERT INTO Item
(item_id,item_name,item_category,item_price,item_qoh)
VALUES('P11111','banana','Fruits',10,9);

CREATE TABLE Transactions
(
   tran_id char(10) primary key check(tran_id like 'T[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'),
   item_id char(6),
   cust_id char(6),
   tran_type char(1) check(tran_type in ('S' ,'O')), --[SO]
   tran_quantity int check(tran_quantity > 0),
   tran_date datetime default getdate(),
   FOREIGN KEY (item_id)
   REFERENCES Item(item_id),
   FOREIGN KEY (cust_id)
   REFERENCES CustomerAndSuppliers(cusl_id)

);

INSERT INTO Transactions
(tran_id,item_id,cust_id,tran_type,tran_quantity)
VALUES('T123456789','P11111','C00002','O',20);
