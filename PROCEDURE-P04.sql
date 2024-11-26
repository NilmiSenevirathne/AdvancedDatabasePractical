CREATE DATABASE ENDP04;
USE ENDP04;

CREATE TABLE employee (
    EID VARCHAR(100),
    Ef_name VARCHAR(100),
    El_name VARCHAR(100),
    E_phone CHAR(10),
    E_mail VARCHAR(100),
    Age INT,
    DEPID INT,
    ROLEID INT,
    FOREIGN KEY (DEPID) REFERENCES department(DID),
    PRIMARY KEY (EID)
);

CREATE TABLE login
(
   UID VARCHAR(50) PRIMARY KEY,
   USERNAME VARCHAR(100),
   PASSWORD VARCHAR(20),
   EMPID VARCHAR(100),
   FOREIGN KEY(EMPID)REFERENCES employee(EID)
);

INSERT INTO login (UID, USERNAME, PASSWORD, EMPID) VALUES
('001', 'sarath', 's12', 'E001'),
('002', 'kamal', 'k12', 'E002'),
('003', 'amali', 'a12', 'E003'),
('004', 'shani', 's21', 'E004'),
('005', 'nimesha', 'n12', 'E005');

CREATE TABLE department (
    DID INT PRIMARY KEY,
    name VARCHAR(50),
    description VARCHAR(100)
);

INSERT INTO department (DID, name, description) VALUES
(1, 'Science', 'Science dep'),
(2, 'IT', 'IT dep'),
(3, 'Maths', 'Maths dep'),
(4, 'ET', 'ET dep'),
(5, 'BST', 'BST dep');

INSERT INTO employee (EID, Ef_name, El_name, E_phone, E_mail, Age, DEPID, ROLEID) VALUES
('E001', 'Sarath', 'Weerasinghe', '0715267893', 'abcsarath@gmail.com', 22, 1, 1),
('E002', 'Kamal', 'Nadhun', '0778945613', 'abckamal@gmail.com', 23, 2, 2),
('E003', 'Amali', 'Sadamini', '0725468134', 'abcamali@gmail.com', 58, 3, 3),
('E004', 'Shani', 'Arosha', '0707775552', 'abcshani@gmail.com', 45, 4, 4),
('E005', 'Nimesha', 'Sewwandi', '0768882225', 'abcnimesha@gmail.com', 25, 5, 4);

CREATE TABLE role
(
   RID INT AUTO_INCREMENT PRIMARY KEY,
   NAME VARCHAR(100),
   DESCRIPTION VARCHAR(255)
);

INSERT INTO Role (NAME, DESCRIPTION) 
VALUES  
    ('QA Engineer', 'Role 1'), 
    ('SE Engineer', 'Role 2'), 
    ('Project Manager', 'Role 3'), 
    ('Business Analyst', 'Role 4'), 
    ('Technical Consultant', 'Role 5'); 
    
-- 03
DELIMITER //
CREATE PROCEDURE get_allemployeeDetails()
BEGIN
   SELECT * FROM employee;
END //
DELIMITER ;

-- 04
DELIMITER //
CREATE PROCEDURE getEmployeeDetails()
BEGIN
   SELECT * FROM employee;
END //
DELIMITER ;
CALL getEmployeeDetails();

-- 05
DELIMITER //
CREATE PROCEDURE getEmployeeByID(IN emp_id VARCHAR(100))
BEGIN
   SELECT * FROM employee WHERE EID = emp_id;
END //
DELIMITER ;
CALL getEmployeeByID('E002');

-- 06
DELIMITER $$
CREATE PROCEDURE getDepartmentDetails()
BEGIN
   SELECT * FROM department;
END $$
DELIMITER //
CALL getDepartmentDetails();

-- 07
DELIMITER //
CREATE PROCEDURE getRolesDetails()
BEGIN
   SELECT * FROM role;
END //
DELIMITER ;
CALL getRolesDetails();

-- 07
DELIMITER //
CREATE PROCEDURE getloginDetails()
BEGIN
  SELECT * FROM login;
END //
DELIMITER ;
CALL getloginDetails();

-- 08
DELIMITER //
CREATE PROCEDURE GETEMPLOYEE_HIGH()
BEGIN
   SELECT * FROM employee WHERE Age > 30;
END //
DELIMITER ;
CALL GETEMPLOYEE_HIGH();

-- 09
DELIMITER //
CREATE PROCEDURE usp_GetLastName(IN EMID VARCHAR(20))
BEGIN
    SELECT El_name FROM employee WHERE EID = EMID;
END //
DELIMITER ;
DROP PROCEDURE usp_GetLastName;
CALL usp_GetLastName('E001')

-- 10
DELIMITER //
CREATE PROCEDURE  usp_GetFirstName(IN EMP_ID VARCHAR(100))
BEGIN
   SELECT Ef_name FROM employee WHERE EID = EMP_ID;
END //
DELIMITER ;
CALL usp_GetFirstName('E002');

-- 11
DELIMITER //
CREATE PROCEDURE  getdepartmentName(IN EMPID VARCHAR(100))
BEGIN
   SELECT name AS DEPARTMENT_NAME FROM department d JOIN employee e ON d.DID = e.DEPID WHERE e.EID = EMPID;
END //
DELIMITER ;
DROP PROCEDURE getdepartmentName;
CALL getdepartmentName('E002');

-- 12
DELIMITER //
CREATE PROCEDURE getnEWRoleName(IN EMPID VARCHAR(100))
BEGIN
   SELECT NAME AS ROLENAME FROM Role r JOIN employee e ON r.RID = e.ROLEID WHERE e.EID = EMPID;
END ;
DELIMITER ;
CALL getnEWRoleName('E002');

-- 13
DELIMITER //
CREATE PROCEDURE countOfEmployee(IN DEP_ID INT )
BEGIN
  SELECT COUNT(EID) AS NUMBEROFEMPLOYEES FROM employee E WHERE E.DEPID = DEP_ID;
END //
DELIMITER ;

CALL  countOfEmployee(4);

-- 14 
DELIMITER //
CREATE PROCEDURE getLoginDetailsOfEmployee(IN EMP_ID VARCHAR(100))
BEGIN
     SELECT * FROM login WHERE EMPID = EMP_ID;
END //
DELIMITER ;
CALL getLoginDetailsOfEmployee('E002');

-- 15
CREATE TABLE studentMarks
(
   stud_id int auto_increment primary key,
   total_marks int,
   grade varchar(10)
);

INSERT INTO studentMarks(total_marks, grade)  
VALUES(450, 'A'), (480, 'A+'), (490, 'A++'), (440, 'B+'),(400, 'C+'),(380,'C') 
,(250, 'D'),(200,'E'),(100,'F'),(150,'F'),(220, 'E'); 

-- 16
DELIMITER //
CREATE PROCEDURE getStudentMarksDetails()
BEGIN
   SELECT * FROM studentMarks;
END //
DELIMITER ;
CALL getStudentMarksDetails();

-- 17
DELIMITER //
CREATE PROCEDURE getStuDetailsByID(IN STID INT)
BEGIN
    SELECT * FROM studentMarks WHERE stud_id = STID;
END //
DELIMITER ;
CALL getStuDetailsByID(1);

-- 18
DELIMITER //
CREATE PROCEDURE getAverageMarks(OUT Average DECIMAL(6,2))
BEGIN
     
     SELECT AVG(total_marks) INTO Average FROM studentMarks;
END //
DELIMITER ;
CALL getAverageMarks(@Average);
SELECT @Average as Average;
DROP PROCEDURE getAverageMarks;

-- 19
DELIMITER //
CREATE PROCEDURE getPassMarks()
BEGIN
    DECLARE Average DECIMAL(6,2);
    SELECT AVG(total_marks) INTO Average FROM studentMarks;
    SELECT COUNT(stud_id) FROM studentMarks WHERE total_marks < Average ;
END //
DELIMITER ;
CALL getPassMarks();
DROP PROCEDURE getPassMarks;

-- 20
DELIMITER //
CREATE FUNCTION COUNTER_VALUE(initialval INT ,incrementval INT ,finalval INT )
RETURNS INT
DETERMINISTIC
BEGIN 
    
      SET finalval = initialval + incrementval; 
	  RETURN finalval;
END //
DELIMITER ;
SELECT COUNTER_VALUE (10,5,@finalval) AS FINAL_VALUE;