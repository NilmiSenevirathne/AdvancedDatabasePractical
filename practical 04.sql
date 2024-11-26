create schema db_student;
create schema db_student	1 row(s) affected	0.015 sec

use db_student;
use db_student	0 row(s) affected	0.000 sec

create table StudentMarks
( stud_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
total_marks INT,
grade VARCHAR(5));
create table StudentMarks ( stud_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY, total_marks INT, grade VARCHAR(5))	0 row(s) affected	0.032 sec

INSERT INTO StudentMarks
(total_marks, grade)
VALUES
(450,'A'),
(480,'A+'),
(490,'A+'),
(440,'B+'),
(400,'C+'),
(380,'C'),
(250,'D'),
(200,'E'),
(100,'F'),
(150,'F'),
(220,'E');
INSERT INTO StudentMarks (total_marks, grade) VALUES (450,'A'), (480,'A+'), (490,'A+'), (440,'B+'), (400,'C+'), (380,'C'), (250,'D'), (200,'E'), (100,'F'), (150,'F'), (220,'E')	11 row(s) affected Records: 11  Duplicates: 0  Warnings: 0	0.000 sec


DELIMITER $$
CREATE PROCEDURE GetStudentData()
BEGIN
    SELECT * FROM StudentMarks;
END$$
DELIMITER ;
CREATE PROCEDURE GetStudentData() BEGIN     SELECT * FROM StudentMarks; END	0 row(s) affected	0.015 sec
CALL GetStudentData();
11 row(s) returned	0.000 sec / 0.000 sec


DELIMITER $$
CREATE PROCEDURE db_student.spGetDetailsByStudentName(IN studentID INT)
BEGIN
     SELECT stud_id, total_marks, grade FROM Studentmarks WHERE stud_id  = studentID;
END$$
DELIMITER ;
0 row(s) affected	0.016 sec

CALL spGetDetailsByStudentName(1);
1 row(s) returned	0.000 sec / 0.000 sec


DELIMITER $$
CREATE PROCEDURE db_student.spGetAverageMarks(OUT average DECIMAL(5,2))
BEGIN
     SELECT AVG(total_marks) INTO average FROM StudentMarks;
END$$
DELIMITER ;
0 row(s) affected	0.016 sec

CALL db_student.spGetAverageMarks(@average_marks);
1 row(s) affected, 1 warning(s): 1265 Data truncated for column 'average' at row 1	0.000 sec

SELECT @average_marks;
SELECT @average_marks LIMIT 0, 1000	1 row(s) returned	0.000 sec / 0.000 sec

DELIMITER //
CREATE PROCEDURE spUpdateCounter(INOUT counter INT, IN increment INT)
BEGIN
  SET counter  = counter +increment;
END //
DELIMITER ;
0 row(s) affected	0.000 sec

SET @counter  =10;
0 row(s) affected	0.000 sec

CALL db_student.spUpdateCounter(@counter,3);
0 row(s) affected	0.000 sec

SELECT @counter;
1 row(s) returned	0.000 sec / 0.000 sec


DELIMITER //
CREATE PROCEDURE db_student.spCountOfBelowAverage(OUT countBelowAverage INT)
BEGIN
  DECLARE avgMarks DECIMAL(5,2) DEFAULT 0;
  SELECT AVG(total_marks) INTO avgMarks FROM studentMarks;
  SELECT COUNT(*) INTO CountBelowAverage FROM studentMarks WHERE total_marks<avgMarks;
END //
DELIMITER ;
0 row(s) affected	0.016 sec

CALL db_student.spCountOfBelowAverage(@countBelowAverage);
1 row(s) affected	0.000 sec

SELECT @countBelowAverage;
1 row(s) returned	0.000 sec / 0.000 sec

-- DELIMITER $$
-- CREATE PROCEDURE test_proc.comments()
-- BEGIN
--    SELECT "hello world";
-- END $$
-- DELIMITER ;

DELIMITER $$
CREATE PROCEDURE db_student.spGetIsAboveAverage(IN studentId INT , OUT isAboveAverage BOOLEAN)
BEGIN
   DECLARE avgMarks DECIMAL(5,2) DEFAULT 0;
   DECLARE studMarks INT DEFAULT 0;
   SELECT AVG(total_marks) INTO avgMarks FROM studentMarks;
   SELECT total_marks INTO studMarks FROM studentMarks WHERE stud_id = studentId;
   IF studMarks > avgMarks THEN 
       SET isAboveAverage = TRUE;
	ELSE
       SET isAboveAverage = FALSE;
	END IF;
END $$
DELIMITER ;
0 row(s) affected	0.015 sec


SET isAboveAverage = NULL;
CALL db_student.spGetIsAboveAverage(1,@isAboveAverage)
1 row(s) affected	0.000 sec
SELECT @isAboveAverage; 
1 row(s) returned	0.000 sec / 0.000 sec


DELIMITER $$
  CREATE PROCEDURE db_student.spGetResult(IN studentID INT , OUT result VARCHAR(20) )
  BEGIN
       CALL db_student.spGetIsAboveAverage(studentID,@isAboveAverage);
       IF @isAboveAverage = 0 THEN
          SET result = "FAIL";
	   ELSE
           SET result = "PASS";
	   END IF;
  END $$
DELIMITER ;
0 row(s) affected	0.016 sec

CALL db_student.spGetResult(1,@result);
1 row(s) affected	0.000 sec

SELECT @result; 
1 row(s) returned	0.000 sec / 0.000 sec


DELIMITER $$
CREATE PROCEDURE db_student.spGetStudentClass(IN studentID INT, OUT class VARCHAR(20))
BEGIN 
      DECLARE marks INT DEFAULT 0;
      SELECT total_marks INTO marks FROM studentMarks WHERE stud_id = studentID;
      
      IF marks >=400 THEN 
        SET class  = "1st class";
	  ELSEIF marks >= 300 AND marks < 400 THEN
		SET class  = "2nd class";
	  ELSE 
        SET class  = "Fail";
	  END IF;
END $$
DELIMITER ;
0 row(s) affected	0.016 sec

CALL db_student.spGetStudentClass(1,@class);
1 row(s) affected	0.016 sec

SELECT @class;
1 row(s) returned	0.000 sec / 0.000 sec

-- error handling CODE WITH IN THE  sql PROCEDURE 
DECLARE exit/continue {} HANDLER FOR {Conditon}{Statement}

 -- Types of Actions
-- 1.Continue - procedure ek athule error ekak thibunath continue krnw 
-- 2. Exit - procedure eke flow eka terminate wenw

-- Condition
-- 1062 - error code of duplicate violation of the primary key

-- DECLARE EXIT HANDLER FOR 1062
-- BEGIN
--       SELECT "DUPLICATE KEY ERROR" AS ERRORmessage;
-- END 

DELIMITER $$
CREATE PROCEDURE db_student.InsertStudentDatas(IN studentID INT, IN total_marks INT,IN grade VARCHAR(20), OUT rowCount INT)
BEGIN
-- error handler declaration for duplicate key
DECLARE EXIT HANDLER FOR 1062
BEGIN 
   SELECT "DUPLICATE KEY ERROR" AS errormessage;
END;

-- main procedure statements
INSERT INTO studentMarks(stud_id, total_marks, grade) VALUES (studentID, total_marks, grade);
SELECT COUNT(*) FROM studentMarks INTO rowCount;

END $$

DELIMITER ;
0 row(s) affected	0.016 sec

CALL db_student.InsertStudentDatas(1,450,'A+',@rowCount);
1 row(s) returned	0.015 sec / 0.000 sec

SELECT @rowCount;

DROP PROCEDURE db_student.InsertStudentDatas;

DELIMITER $$
CREATE PROCEDURE db_student.InsertStudentDatas(IN studentID INT, IN total_marks INT,IN grade VARCHAR(20), OUT rowCount INT)
BEGIN
-- error handler declaration for duplicate key
DECLARE CONTINUE HANDLER FOR 1062
BEGIN 
   SELECT "DUPLICATE KEY ERROR" AS errormessage;
END;

-- main procedure statements
INSERT INTO studentMarks(stud_id, total_marks, grade) VALUES (studentID, total_marks, grade);
SELECT COUNT(*) FROM studentMarks INTO rowCount;

END $$
DELIMITER ;
0 row(s) affected	0.015 sec

CALL db_student.InsertStudentDatas(1,450,'A+',@rowCount);
1 row(s) returned	0.015 sec / 0.000 sec

SELECT @rowCount;
1 row(s) returned	0.000 sec / 0.000 sec


DELIMITER //
CREATE PROCEDURE db_student.spInsertStudentData(IN studentID INT, IN total_marks INT,IN grade VARCHAR(20), OUT rowCount INT)
BEGIN
     DECLARE CONTINUE HANDLER FOR 1062
     BEGIN
        SELECT 'DUPLICATE ERROR' AS error_msg;  
     END ;
     
     INSERT INTO studentMarks(stud_id, total_marks, grade) VALUES(studentId,total_marks,grade);
    SELECT COUNT(*) FROM studentMarks INTO rowCount;

END //
DELIMITER ;

CALL db_student.spInsertStudentData (1,450,'A+',@rowCount);
SELECT @rowCount;










