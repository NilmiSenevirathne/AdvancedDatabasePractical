
-- 01
CREATE DATABASE ENDP06;

USE ENDP06;

-- 02
CREATE TABLE employee(
   employeeID int,
   FirstName varchar(100),
   LastName varchar(100),
   Email varchar(100),
   HireDate Date,
   DepartmentID int
);

-- 03
INSERT INTO employee (employeeID, FirstName, LastName, Email, HireDate, DepartmentID)
VALUES
(1, 'Kamal', 'Perera', 'perera@example.lk', '2021-05-12', 1),
(2, 'Nimal', 'Fernando', 'fernando@example.lk', '2020-08-23', 2),
(3, 'Sunil', 'Silva', 'silva@example.lk', '2019-11-05', 1),
(4, 'Chathura', 'Kumarasinghe', 'kumarasinghe@example.lk', '2022-02-13', 1),
(5, 'Dilshan', 'Jayawardena', 'jayawardena@example.lk', '2021-07-29', 2),
(6, 'Aruna', 'Weerasinghe', 'weerasinghe@example.lk', '2020-09-01', 1),
(7, 'Malkanthi', 'Rathnayake', 'rathnayake@example.lk', '2019-06-14', 4),
(8, 'Ruwan', 'De Silva', 'desilva@example.lk', '2018-06-30', 3),
(9, 'Saman', 'Senanayake', 'senanayake@example.lk', '2021-04-10', 4),
(10, 'Indika', 'Karunaratne', 'karunaratne@example.lk', '2019-12-25', 2);

-- 04
ALTER TABLE employee ADD PRIMARY KEY(employeeID);

-- 05
CREATE TABLE department (
    DepartmentID int AUTO_INCREMENT PRIMARY KEY,
    DepartmentName varchar(100),
    Location varchar(100)
);

-- 06
INSERT INTO department (DepartmentName, Location)
 VALUES
('Web Development', 'LOC001'),
( 'Mobile Development', 'LOC002'),
('Cloud Engineering', 'LOC003'),
( 'Digital Marketing', 'LOC004'),
('Business Intelligence', 'LOC005'),
( 'Employee Training', 'LOC006');

-- 07
ALTER TABLE employee ADD FOREIGN KEY(DepartmentID) REFERENCES department(DepartmentID);

-- 08
ALTER TABLE employee DROP PRIMARY KEY; 

-- 09
ALTER TABLE employee ADD PRIMARY KEY(DepartmentID,employeeID);

-- 10
CREATE TABLE project
(
    ProjectID int AUTO_INCREMENT PRIMARY KEY,
    ProjectName varchar(100),
    StartDate Date,
    EndDate Date
);

-- 11
INSERT INTO project(ProjectName,StartDate,EndDate)
VALUES
('Website Design', '2024-01-10', '2024-03-15'),
('Mobile App Development', '2024-02-01', '2024-06-30'),
('Cloud Migration', '2024-03-01', '2024-10-30'),
('Data Analytics Initiative', '2024-04-15', '2024-09-30'),
('Digital Marketing Campaign', '2024-05-01', '2024-07-30'),
('Employee Training Program', '2024-06-01', '2024-08-01');

-- 12
CREATE TABLE employee_project 
(
   employeeID int,
   departmentID int,
   projectID int,
   PRIMARY KEY ( employeeID,departmentID,projectID),
   FOREIGN KEY (departmentID, projectID)REFERENCES employee(DepartmentID,employeeID),
   FOREIGN KEY (projectID)REFERENCES project( ProjectID )
);

-- 13
CREATE INDEX idx_firstName ON employee(FirstName);
show index from employee;
   
-- 14
CREATE UNIQUE INDEX idx_email ON employee(Email);

-- 15
CREATE UNIQUE INDEX idx_depname_location ON department(DepartmentName, Location);
show index from department;

-- 16
ALTER TABLE employee 
ADD COLUMN ContactNumber CHAR(10),
ADD COLUMN City VARCHAR(20),
ADD COLUMN District VARCHAR(20),
ADD COLUMN Province VARCHAR(20);

-- 17
SET SQL_SAFE_UPDATES = 0;
UPDATE  employee 
SET ContactNumber = '0712345678' ,
    City = 'Colombo',
    District = 'Colombo',
    Province = 'Western'
WHERE employeeID = 1;

UPDATE employee
SET ContactNumber = '0771234567',
    City = 'Rathnapura',
    District = 'Rathnapura',
    Province = 'Sabaragamuwa'
WHERE employeeID = 2;

UPDATE employee 
SET ContactNumber = '0771234567',
    City = 'Rathnapura',
    District = 'Rathnapura',
    Province = 'Sabaragamuwa'
WHERE employeeID = 3;

UPDATE employee SET 
    ContactNumber = '0759988776', 
    City = 'Matara', 
    District = 'Matara', 
    Province = 'Southern' 
WHERE employeeID = 4;

UPDATE employee SET 
    ContactNumber = '0759988776', 
    City = 'Horana', 
    District = 'Colombo', 
    Province = 'Western' 
WHERE employeeID= 5;

UPDATE employee SET 
    ContactNumber = '0752233445', 
    City = 'Negombo', 
    District = 'Gampaha', 
    Province = 'Western' 
WHERE employeeID = 6;

UPDATE employee SET 
    ContactNumber = '0755566778', 
    City = 'Nuwara Eliya', 
    District = 'Nuwara Eliya', 
    Province = 'Central' 
WHERE employeeID = 7;

UPDATE employee SET 
    ContactNumber = '0754455667', 
    City = 'Jaffna', 
    District = 'Jaffna', 
    Province = 'Northern' 
WHERE employeeID = 8;

UPDATE employee SET 
    ContactNumber = '0753344556', 
    City = 'Batticaloa', 
    District = 'Batticaloa', 
    Province = 'Eastern' 
WHERE employeeID = 9;

UPDATE employee SET 
    ContactNumber = '0757788990', 
    City = 'Trincomalee', 
    District = 'Trincomalee', 
    Province = 'Eastern' 
WHERE employeeID = 10;

-- 18
CREATE INDEX idx_department_city ON employee (departmentID,City);

-- 19
CREATE INDEX idx_project_enddate ON project(EndDate);

-- 20
CREATE INDEX idx_province ON employee(Province);
CREATE INDEX idx_project ON project(ProjectID);
CREATE INDEX idx_province_project ON employee_project (employeeID,projectID);

