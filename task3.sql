-- task 3

--1.
CREATE PROC sp_showTitleAndAuthor 
AS
BEGIN
    SELECT "Authors Last Name"=au_lname FROM authors where au_id in (select au_id from 
           titleauthor where title_id='BU1032');
END

EXEC sp_showTitleAndAuthor;

DROP PROC sp_showTitleAndAuthor;

SELECT * FROM titleauthor;
SELECT * FROM authors;

GO -- for another separate batch

--2.
ALTER PROC sp_showTitleAndAuthor
AS
BEGIN
    SELECT "Authors Last Name"=au_lname FROM authors where au_id in (select au_id from 
           titleauthor where title_id='TC7777');
END   
EXEC sp_showTitleAndAuthor;

GO

--3.
ALTER PROC sp_showTitleAndAuthor @titleid char(15) 
AS
BEGIN
  SELECT "Authors Last Name"=au_lname FROM authors where au_id in (select au_id from 
        titleauthor where title_id=@titleid)
END
EXEC sp_showTitleAndAuthor 'BU1032';

GO

--4.
CREATE PROC sp_updatePrice @titleid char(15) 
AS
BEGIN
   DECLARE @price MONEY
   SELECT @price=price from TITLES WHERE title_id=@titleid 
   set @price=@price+0.1*@price
   IF @price<=20
   UPDATE titles SET price= @price WHERE title_id=@titleid
END
EXEC sp_updatePrice 'BU7832';

GO

--5.
ALTER PROC sp_updatePrice @titleid char(15) 
AS
BEGIN
    DECLARE @price MONEY
    SELECT @price=price from TITLES WHERE title_id=@titleid 
    set @price=@price+0.3*@price
    IF @price<=40
    UPDATE titles SET price= @price WHERE title_id=@titleid
END
EXEC sp_updatePrice 'BU7832';

SELECT * FROM titles;

-- (invalid for couldn't detect) intellisense refresh : ctrl + shift + R

GO

--T:1.
CREATE PROC sp_showCategorySummary
AS
BEGIN
   SELECT 
      category AS Category,
      COUNT(*) AS [Total number of items],
      AVG(price) AS [Average Price]
   FROM Items
   GROUP BY category
END
EXEC sp_showCategorySummary;

GO

--T:2.
CREATE PROC sp_showCheaperItems 
   @catName VARCHAR(50),
   @maxPrice MONEY
AS
BEGIN
   SELECT * 
   FROM Items
   WHERE category = @catName AND price < @maxPrice
END
EXEC sp_showCheaperItems 'Electronics', 500

GO

--T:3.
CREATE PROC sp_increasePriceUntilAvg
   @catName VARCHAR(50),
   @desiredAvg MONEY
AS
BEGIN
   DECLARE @currentAvg MONEY

   SELECT @currentAvg = AVG(price) FROM Items WHERE category=@catName

   WHILE(@currentAvg < @desiredAvg)
   BEGIN
      UPDATE Items
      SET price = price + (price * 0.10)
      WHERE category=@catName

      SELECT @currentAvg = AVG(price) FROM Items WHERE category=@catName
   END
END
EXEC sp_increasePriceUntilAvg 'Electronics', 1000


