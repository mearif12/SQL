-- task 4

--1.
CREATE TRIGGER trg_test ON Item FOR INSERT
AS 
BEGIN 
  PRINT 'Data inserted in Item Table';  -- customize output while insert with (1 row affected)
END

SELECT * FROM Item;

INSERT INTO Item (item_id,item_name,item_category,item_price,item_qoh,item_last_sold)
VALUES ('P22222','apple','Fruits',12,8,'2025-08-30');

INSERT INTO Item (item_id,item_name,item_category,item_price,item_qoh,item_last_sold)
VALUES ('P33333','guava','Fruits',19,6,'2025-06-30');

DELETE FROM Item WHERE item_id = 'P22222' OR item_id = 'P33333';

GO

--2.
CREATE TRIGGER trg_update_item ON Transactions FOR INSERT 
AS
BEGIN
     DECLARE @item_id char(6), @tranamount int, @tran_type char(1)
     SELECT @item_id=item_id, @tranamount=tran_quantity, @tran_type=tran_type FROM INSERTED
     IF (@tran_type ='S')
       UPDATE Item SET item_qoh=item_qoh- @tranamount WHERE item_id=@item_id 
     ELSE
       UPDATE Item SET item_qoh=item_qoh+ @tranamount WHERE item_id=@item_id
END

SELECT * FROM Transactions;

INSERT INTO Transactions (tran_id,item_id,cust_id,tran_type,tran_quantity,tran_date)
VALUES('T997654321','P22222','C00002','O',60,'2024-03-23');  -- see Item table for the change

GO

--T:1.
CREATE TRIGGER trg_update_customerSupplier ON Transactions FOR INSERT
AS
BEGIN
    DECLARE @custsup_id CHAR(6), @tranamount MONEY, @tran_type CHAR(1)

    SELECT 
        @custsup_id = cust_id,   
        @tranamount = tran_quantity, 
        @tran_type = tran_type
    FROM INSERTED

    IF (@tran_type = 'S')
    BEGIN
        UPDATE CustomerAndSuppliers
        SET sales_amnt = sales_amnt + @tranamount
        WHERE cusl_id = @custsup_id
    END

    ELSE IF (@tran_type = 'O')
    BEGIN
        UPDATE CustomerAndSuppliers
        SET proc_amnt = proc_amnt + @tranamount
        WHERE cusl_id = @custsup_id
    END
END

SELECT * FROM CustomerAndSuppliers;

INSERT INTO Transactions (tran_id,item_id,cust_id,tran_type,tran_quantity,tran_date)
VALUES('T995655612','P22222','C00002','S',80,'2024-03-13'); 

INSERT INTO Transactions (tran_id,item_id,cust_id,tran_type,tran_quantity,tran_date)
VALUES('T898654345','P22222','C00002','O',60,'2024-03-23'); 

GO

--T:2.
ALTER TRIGGER trg_update_customerSupplier ON Transactions FOR INSERT
AS
BEGIN
    DECLARE @custsup_id CHAR(6), @tranamount MONEY, @tran_type CHAR(1);

    SELECT 
        @custsup_id = cust_id,   
        @tranamount = tran_quantity, 
        @tran_type = tran_type
    FROM INSERTED;

    IF (@tran_type = 'S')
    BEGIN
        UPDATE CustomerAndSuppliers
        SET sales_amnt = sales_amnt + @tranamount
        WHERE cusl_id = @custsup_id; 
    END
    ELSE
    BEGIN
        UPDATE CustomerAndSuppliers
        SET proc_amnt = proc_amnt + @tranamount
        WHERE cusl_id = @custsup_id; 
    END
END;


INSERT INTO Transactions (tran_id,item_id,cust_id,tran_type,tran_quantity,tran_date)
VALUES('T898654345','P22222','C00002','O',60,'2024-03-23'); 

DROP TRIGGER trg_test;