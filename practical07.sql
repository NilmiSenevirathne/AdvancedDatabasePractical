CREATE DATABASE ENDP07;
USE ENDP07;


CREATE TABLE NEWSTUDENT(
   ID INT PRIMARY KEY AUTO_INCREMENT,
   NAME VARCHAR(100)NOT NULL,
   ADDRESS VARCHAR(255) NOT NULL,
   MARKS INT 
);

-- part a
DELIMITER //
CREATE TRIGGER INSERT_BEFORE_MARKS
BEFORE INSERT
ON NEWSTUDENT FOR EACH ROW
BEGIN
    IF NEW.MARKS IS NOT NULL THEN
       SET NEW.MARKS = NEW.MARKS + 100;
	ELSE
       SET NEW.MARKS = 100;
	END IF;
END //
DELIMITER ;

INSERT INTO NEWSTUDENT (NAME,ADDRESS,MARKS)
VALUES
    ('Bille', 'NY', 200),
    ('Eilish', 'London', 190),
    ('Ariana', 'Miami', 180),
    ('Chris', 'Tokyo', NULL);

SELECT * FROM NEWSTUDENT;

-- part b
CREATE TABLE SPECIFIED_MARKS
(
   TOTAL_MARKS  INT,
   AVERAGE_MARKS DECIMAL(6,2));
   
DELIMITER //
CREATE TRIGGER NEW_AFTER_INSERT_MARKS
AFTER INSERT
ON NEWSTUDENT FOR EACH ROW
BEGIN
    DECLARE total_marks INT;
    DECLARE avg_marks DECIMAL(6,2);
    
    SET total_marks = (SELECT SUM(MARKS) FROM NEWSTUDENT);
    SET avg_marks = (SELECT AVG(MARKS) FROM NEWSTUDENT);
    
    -- Assuming there is always one row in SPECIFIED_MARKS with SID = 1 
	IF (SELECT COUNT(*) FROM SPECIFIED_MARKS) = 0 THEN
		INSERT INTO SPECIFIED_MARKS (TOTAL_MARKS, AVERAGE_MARKS)
          VALUES (total_marks, average_marks);
	ELSE UPDATE SPECIFIED_MARKS 
		SET TOTAL_MARKS = total_marks, AVERAGE_MARKS = average_marks WHERE SID = 1; 
        END IF;
END //
DELIMITER ;

SELECT * FROM SPECIFIED_MARKS;
   

-- 02 a)

CREATE TABLE Student_Trigger   
(   
Student_RollNo INT NOT NULL PRIMARY KEY,   
Student_FirstName Varchar (100),   
Student_EnglishMarks INT,   
Student_PhysicsMarks INT,    
Student_ChemistryMarks INT,   
Student_MathsMarks INT,   
Student_TotalMarks INT,   
Student_Percentage DECIMAL(5,2));

DESC Student_Trigger;


DELIMITER //
CREATE TRIGGER INSERT_BEFORE_STUDENT
BEFORE INSERT
ON Student_Trigger FOR EACH ROW
BEGIN 
    
       SET NEW.Student_TotalMarks = (NEW.Student_EnglishMarks + NEW.Student_PhysicsMarks + NEW.Student_ChemistryMarks + NEW.Student_MathsMarks);
	   SET NEW.Student_Percentage = NEW.Student_TotalMarks / 4;
END //
DELIMITER ;

INSERT INTO Student_Trigger
(Student_RollNo, Student_FirstName, Student_EnglishMarks, Student_PhysicsMarks, Student_ChemistryMarks, Student_MathsMarks)
VALUES
 (1, 'Alice', 85, 78, 90, 88), 
 (2, 'Bob', 72, 75, 70, 80),
 (3, 'Charlie', 95, 92, 98, 91), 
 (4, 'David', 66, 70, 65, 68),
 (5, 'Eva', 88, 84, 90, 86);

SELECT * FROM Student_Trigger;

-- 03
CREATE TABLE tbl_product (
    pro_id INT PRIMARY KEY AUTO_INCREMENT,
    pro_price DECIMAL(10, 2) NOT NULL,
    pro_sprice DECIMAL(10, 2),
    pro_quantity INT NOT NULL,
    reorder_qty INT NOT NULL
);

CREATE TABLE tbl_proreorder (
    id INT PRIMARY KEY AUTO_INCREMENT,
    pro_id INT,
    quantity INT,
    FOREIGN KEY (pro_id) REFERENCES tbl_product(pro_id)
);

DELIMITER //
CREATE TRIGGER BEFORE_UPDATE
BEFORE UPDATE
ON tbl_product FOR EACH ROW
BEGIN
     IF NEW.pro_quantity = NEW.reorder_qty THEN
        INSERT INTO tbl_proreorder
        ( pro_id,quantity)
        VALUES
        (NEW.pro_id,NEW.pro_quantity);
	END IF;
END //
DELIMITER ;

INSERT INTO tbl_product 
(pro_price, pro_sprice, pro_quantity, reorder_qty) 
VALUES 
(100.00, 120.00, 50, 50), 
(200.00, 240.00, 30, 30), 
(150.00, 180.00, 20, 10);

UPDATE tbl_product
SET pro_quantity = 30
WHERE pro_id = 2;

SELECT * FROM tbl_proreorder;


-- 04
CREATE TABLE EMPLOYEE(
   NAME VARCHAR(100) NOT NULL,
   AGE INT,
   ADDRESS VARCHAR(255) NOT NULL,
   DEPID INT,
   FOREIGN KEY(DEPID) REFERENCES DEPARTMENT(DEPID)
);

CREATE TABLE DEPARTMENT(
   DEPID INT PRIMARY KEY AUTO_INCREMENT,
   DEPNAME VARCHAR(100) NOT NULL
);

CREATE TABLE EMPLOYEE_ARCHIEVE
(
   NAME VARCHAR(100) NOT NULL,
   AGE INT,
   ADDRESS VARCHAR(255) NOT NULL,
   DEPID INT
);

DELIMITER //
CREATE TRIGGER BEFORE_DELETE
BEFORE DELETE
ON EMPLOYEE FOR EACH ROW
BEGIN
    INSERT INTO EMPLOYEE_ARCHIEVE
    (NAME,AGE,ADDRESS,DEPID)
    VALUES
    (OLD.NAME,OLD.AGE,OLD.ADDRESS,OLD.DEPID);
END //
DELIMITER ;

INSERT INTO DEPARTMENT (DEPNAME)
VALUES 
    ('Human Resources'),
    ('Finance'),
    ('Engineering'),
    ('Marketing'),
    ('Sales');

INSERT INTO EMPLOYEE (NAME, AGE, ADDRESS, DEPID)
VALUES 
    ('Alice', 30, '123 Elm St', 1),
    ('Bob', 35, '456 Oak St', 2),
    ('Charlie', 28, '789 Pine St', 3),
    ('David', 42, '101 Maple St', 4),
    ('Eva', 25, '202 Birch St', 5),
    ('Frank', 33, '303 Cedar St', 1),
    ('Grace', 29, '404 Spruce St', 2);

SET SQL_SAFE_UPDATES = 0;
DELETE FROM EMPLOYEE WHERE NAME = 'Alice';
SELECT * FROM EMPLOYEE_ARCHIEVE;
SELECT * FROM EMPLOYEE;
DELETE FROM DEPARTMENT WHERE DEPID = 1;

-- 05

CREATE TABLE Locations (
LocationID int,
 LocName varchar(100));
 
CREATE TABLE LocationHist (
LocationID int,
 ModifiedDate DATETIME);
 
DELIMITER //
CREATE TRIGGER AFTER_UPDATE
AFTER UPDATE
ON Locations FOR EACH ROW
BEGIN 
    INSERT INTO LocationHist
    (LocationID,ModifiedDate)
    VALUES
    (NEW.LocationID,NOW());
END //
DELIMITER ;
 
-- Insert sample data into Locations table
INSERT INTO Locations (LocationID, LocName) VALUES (1, 'Main Office');

-- Update the location name
UPDATE Locations SET LocName = 'Headquarters' WHERE LocationID = 1;

-- Check the LocationHist table to see the update history
SELECT * FROM LocationHist;


-- 06
CREATE TABLE BOOK_DET(
   BID INT AUTO_INCREMENT PRIMARY KEY ,
   BTITLE VARCHAR(100) NOT NULL,
   COPIES INT
);

CREATE TABLE BOOK_ISSUE(
   BID INT,
   SID INT AUTO_INCREMENT PRIMARY KEY,
   BTITLE VARCHAR(100) NOT NULL,
   FOREIGN KEY (BID) REFERENCES BOOK_DET(BID)
);

DELIMITER //
CREATE TRIGGER AFTER_INSERT_BOOK_ISSUE_NEW
AFTER INSERT
ON BOOK_ISSUE
FOR EACH ROW
BEGIN
   UPDATE BOOK_DET
   SET COPIES = COPIES - 1
   WHERE BID = NEW.BID;
   
END //
DELIMITER ;


INSERT INTO BOOK_DET (BTITLE, COPIES)
VALUES 
    ('Introduction to SQL', 10),
    ('Advanced SQL', 5),
    ('Database Management Systems', 7),
    ('Data Structures', 12),
    ('Algorithms', 6);

INSERT INTO BOOK_ISSUE (BID, BTITLE) VALUES (2, 'Advanced SQL');

SELECT * FROM BOOK_ISSUE;
SELECT * FROM BOOK_DET;
   
   
-- 07
CREATE TABLE Highschooler (
    ID INT ,
    name TEXT,
    grade INT,
    PRIMARY KEY (ID)
);

CREATE TABLE Friend (
    ID1 INT,
    ID2 INT,
    PRIMARY KEY (ID1, ID2)
);

CREATE TABLE Likes (
    ID1 INT,
    ID2 INT,
    PRIMARY KEY (ID1, ID2)
);

-- a) This trigger will ensure that when (A, B) is inserted, (B, A) is also inserted.

INSERT INTO Friend (ID1, ID2) VALUES (1, 2);
INSERT INTO Friend (ID1, ID2) VALUES (3, 4);

DELIMITER //
CREATE TRIGGER AFITER_INSERT_FRIEND
AFTER INSERT
ON Friend FOR EACH ROW
BEGIN
   IF NOT EXISTS(SELECT 1 FROM Friend WHERE ID1 = NEW.ID2 AND ID2 = NEW.ID1)THEN
       INSERT INTO Friend(ID1,ID2)VALUES(NEW.ID2,NEW.ID1);
   END IF;
END //
DELIMITER ;

SELECT * FROM Friend;

-- This trigger will ensure that when (A, B) is deleted, (B, A) is also deleted.
DELETE FROM Friend WHERE ID1 = 1 AND ID2 = 2;

DELIMITER //
CREATE TRIGGER AFTER_DELETE_FRIEND
AFTER DELETE
ON Friend FOR EACH ROW
BEGIN
    DELETE FROM Friend WHERE ID1 = OLD.ID2 AND ID2=OLD.ID1;
END //
DELIMITER ;
SELECT * FROM Friend;

-- b) 
-- Delete Students Who Graduate (Grade > 12)

INSERT INTO Highschooler (ID, name, grade) VALUES (1, 'AMAL', 8);

UPDATE Highschooler SET grade = 13 WHERE ID = 1;

DELIMITER //
CREATE TRIGGER after_update_grade_nEW
AFTER UPDATE
ON Highschooler
FOR EACH ROW
BEGIN
    IF NEW.grade > 12 THEN
        DELETE FROM Highschooler WHERE ID = NEW.ID;
    END IF;
END //
DELIMITER ;

SELECT * FROM Highschooler;


-- 08 create a view for those salespeople who belong to the city of New York
CREATE TABLE salesman (
    salesman_id INT PRIMARY KEY,
    name VARCHAR(100),
    city VARCHAR(100),
    commission DECIMAL(5, 2)
);

INSERT INTO salesman (salesman_id, name, city, commission)
VALUES
    (5001, 'James Hoog', 'New York', 0.15),
    (5002, 'Nail Knite', 'Paris', 0.13),
    (5005, 'Pit Alex', 'London', 0.11),
    (5006, 'Mc Lyon', 'Paris', 0.14),
    (5007, 'Paul Adam', 'Rome', 0.13),
    (5003, 'Lauson Hen', 'San Jose', 0.12);


CREATE VIEW salesmen_NewYork AS
SELECT salesman_id,name,city,commission 
FROM salesman
WHERE city = 'New York';

SELECT * FROM salesmen_NewYork;

-- 09 create a view for all salespersons. Return salesperson ID, name,  AND CITY
CREATE VIEW all_sales_persons AS
SELECT salesman_id,name,city FROM salesman;

SELECT * FROM all_sales_persons;

-- 10 create a view that counts the number of customers in each grade. 

CREATE TABLE customer (
    customer_id INT,
    cust_name VARCHAR(50),
    city VARCHAR(50),
    grade INT,
    salesman_id INT
);

INSERT INTO customer (customer_id, cust_name, city, grade, salesman_id) VALUES
(3002, 'Nick Rimando', 'New York', 100, 5001),
(3007, 'Brad Davis', 'New York', 200, 5001),
(3005, 'Graham Zusi', 'California', 200, 5002),
(3008, 'Julian Green', 'London', 300, 5002),
(3004, 'Fabian Johnson', 'Paris', 300, 5006),
(3009, 'Geoff Cameron', 'Berlin', 100, 5003),
(3003, 'Jozy Altidore', 'Moscow', 200, 5007);

CREATE VIEW COUNT_OF_CUSTOMERS AS
SELECT grade,COUNT(*) AS CustomerCount FROM customer
GROUP BY grade;
SELECT * FROM COUNT_OF_CUSTOMERS;


-- 11  create a view to count the number of unique customers, compute the average and the total purchase amount of customer orders by each date. 

CREATE TABLE orders (
    ord_no INT PRIMARY KEY,
    purch_amt DECIMAL(10, 2),
    ord_date DATE,
    customer_id INT,
    salesman_id INT
);

INSERT INTO orders (ord_no, purch_amt, ord_date, customer_id, salesman_id)
VALUES
    (70001, 150.50, '2012-10-05', 3005, 5002),
    (70009, 270.65, '2012-09-10', 3001, 5005),
    (70002, 65.26, '2012-10-05', 3002, 5001),
    (70004, 110.50, '2012-08-17', 3009, 5003),
    (70007, 948.50, '2012-09-10', 3005, 5002),
    (70005, 2400.60, '2012-07-27', 3007, 5001),
    (70008, 5760.00, '2012-09-10', 3002, 5001);

CREATE VIEW CUSTOMER_ORDER_SUMMARY AS 
SELECT 
    ord_date,
    COUNT(DISTINCT customer_id) AS UniqueCustomer,
    AVG(purch_amt) AS AveragePurchaseAmount,
    SUM(purch_amt) AS TotalPurchaseAmount FROM orders
    ORDER BY ord_date;
   
SELECT * FROM CUSTOMER_ORDER_SUMMARY;


 



