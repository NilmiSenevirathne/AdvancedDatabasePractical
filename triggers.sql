CREATE DATABASE testTrigger;

USE testTrigger;

CREATE TABLE Student(
Name varchar(35),
Age int,
Score int,
Grade Char(10));

-- before insert trigger
DELIMITER //
CREATE TRIGGER sample_before_insert
BEFORE INSERT 
ON Student FOR EACH ROW
BEGIN
   IF NEW.Score <35 THEN 
	 SET NEW.Grade = 'PASS';
   ELSE
	 SET NEW.Grade = 'FAIL';
   END IF;
END //
DELIMITER ;

INSERT INTO Student 
(Name,Age,Score,Grade)
VALUES
('John',21,76,NULL),
('Jane',20,24,NULL),
('Kamal',21,57,NULL),
('Jony',19,87,NULL);

SELECT * FROM Student;

-- after insert trigger
CREATE TABLE Users(
ID INT AUTO_INCREMENT,
NAME VARCHAR(100) NOT NULL,
AGE INT NOT NULL,
BIRTH_DATE VARCHAR(100),
PRIMARY KEY(ID));

CREATE TABLE PUSH_NOTIFICATIONS(
   ID INT AUTO_INCREMENT,
   BIRTH_DATE VARCHAR(100),
   NOTIFICATIONS VARCHAR(255) NOT NULL,
   PRIMARY KEY(ID));
   
DELIMITER //
CREATE TRIGGER after_trigger 
AFTER INSERT 
ON Users FOR EACH ROW
BEGIN
    IF NEW.BIRTH_DATE IS NOT NULL THEN
        INSERT INTO PUSH_NOTIFICATIONS
        VALUES
        (NEW.ID, NEW.BIRTH_DATE, CONCAT('HAPPY BIRTHDAY ,' , NEW.NAME, '!'));
	END IF;
END //
DELIMITER ;

INSERT INTO Users
(NAME, AGE, BIRTH_DATE)
VALUES
('Sasha', 23, '24/06/1999'),
('Nehaa',32, '12/01/2001');

SELECT * FROM PUSH_NOTIFICATIONS;


-- BEFORE UPDATE TRIGGER
CREATE TABLE SalesInfo(
ID INT AUTO_INCREMENT ,
PRODUCT VARCHAR(100) NOT NULL,
QUANTITY INT NOT NULL DEFAULT 0,
FISCALYEAR SMALLINT NOT NULL,
CHECK(FISCALYEAR BETWEEN 2000 AND 2050),
CHECK(QUANTITY >=0),
UNIQUE(PRODUCT,FISCALYEAR),
PRIMARY KEY(ID));

INSERT INTO SalesInfo(PRODUCT,QUANTITY,FISCALYEAR)  
VALUES  
    ('2003 Maruti Suzuki',110, 2020),  
    ('2015 Avenger', 120,2020),  
    ('2018 Honda Shine', 150,2020),  
    ('2014 Apache', 150,2020); 
   
DELIMITER //
CREATE TRIGGER before_update_sales
BEFORE UPDATE
ON SalesInfo FOR EACH ROW
BEGIN
    DECLARE error_msg VARCHAR(255);
    SET error_msg = ('The new quantity cannot be grater than 2 times the current quantitiy');
     IF NEW.QUANTITY > OLD.QUANTITY *2 THEN
        SIGNAL SQLSTATE '45000' 
          SET MESSAGE_TEXT = error_msg;
	END IF;
END //
DELIMITER ;

UPDATE SalesInfo set QUANTITY = 241 WHERE ID = 2;

-- MySQL AFTER UPDATE TRIGGER

CREATE TABLE students(    
    id int NOT NULL AUTO_INCREMENT,    
    name varchar(45) NOT NULL,    
    class int NOT NULL,    
    email_id varchar(65) NOT NULL,    
    PRIMARY KEY (id)    
);  

INSERT INTO students (name, class, email_id)     
VALUES ('Stephen', 6, 'stephen@javatpoint.com'),   
('Bob', 7, 'bob@javatpoint.com'),   
('Steven', 8, 'steven@javatpoint.com'),   
('Alexandar', 7, 'alexandar@javatpoint.com'); 

CREATE TABLE student_log (
  USER VARCHAR(45) NOT NULL,
  DESCRIPTIONS VARCHAR(65) NOT NULL
  );

DELIMITER //
CREATE TRIGGER after_update_info
AFTER UPDATE
ON students FOR EACH ROW
BEGIN
    INSERT INTO student_log VALUES
      (USER (), CONCAT ('Update Student Record ', OLD.name, 'Previous Class: ', OLD.class, 'Present Class ', NEW.class));
END //
DELIMITER ;

SET SQL_SAFE_UPDATES = 0;
UPDATE students SET class = class +1;
SELECT * FROM students;


-- MySQL BEFORE DELETE Trigger
CREATE TABLE salaries (  
    emp_num INT PRIMARY KEY,  
    valid_from DATE NOT NULL,  
    amount DEC(8 , 2 ) NOT NULL DEFAULT 0  
); 

INSERT INTO salaries (emp_num, valid_from, amount)  
VALUES  
    (102, '2020-01-10', 45000),  
    (103, '2020-01-10', 65000),  
    (105, '2020-01-10', 55000),  
    (107, '2020-01-10', 70000),  
    (109, '2020-01-10', 40000); 
    
 CREATE TABLE salary_archives (  
    id INT PRIMARY KEY AUTO_INCREMENT,  
    emp_num INT,  
    valid_from DATE NOT NULL,  
    amount DEC(18 , 2 ) NOT NULL DEFAULT 0,  
    deleted_time TIMESTAMP DEFAULT NOW()  
);    

DELIMITER //
CREATE TRIGGER before_delete_salary
BEFORE DELETE
ON salaries FOR EACH ROW
BEGIN 
    INSERT INTO salary_archives
    (emp_num,valid_from,amount)
    VALUES (OLD.emp_num,OLD.valid_from,OLD.amount);
END //
DELIMITER ;

DELETE FROM salaries WHERE emp_num = 105;
SELECT * FROM salary_archives;

-- MySQL AFTER DELETE Trigger
CREATE TABLE total_salary_budget(  
    total_budget DECIMAL(10,2) NOT NULL  
);

INSERT INTO total_salary_budget (total_budget)  
SELECT SUM(amount) FROM salaries;

select * from total_salary_budget; 

DELIMITER //
CREATE TRIGGER after_delete_salary
AFTER DELETE 
ON salaries FOR EACH ROW
BEGIN
   UPDATE total_salary_budget 
     SET total_budget = total_budget - OLD.amount;
END //
DELIMITER ;

DELETE FROM salaries WHERE emp_num = 109;
SELECT * FROM total_salary_budget;



  

    
