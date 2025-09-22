-- SECTION A
-- A1) Create database and use it
CREATE DATABASE HEALTHOUTREACH;
USE HEALTHOUTREACH;

-- 1) DOCTOR TABLE
CREATE TABLE DOCTOR
(
    DoctorID CHAR(4) PRIMARY KEY,
    DoctorName VARCHAR(80) NOT NULL,
    Email VARCHAR(120) UNIQUE,
    Speciality VARCHAR(50) NOT NULL,
    Active BIT NOT NULL DEFAULT 1
);

-- 2) CLINIC TABLE
CREATE TABLE CLINIC
(
    ClinicID CHAR(5) PRIMARY KEY,
    ClinicName VARCHAR(80) NOT NULL,
    ClinicAddress VARCHAR(120) NOT NULL
);

-- 3) OUTREACH TABLE
CREATE TABLE OUTREACH
(
    DoctorID CHAR(4) NOT NULL,
    ClinicID CHAR(5) NOT NULL,
    EventDate DATE NOT NULL,
    SeatsAvailable INT NOT NULL CHECK (SeatsAvailable >= 0),
    Status VARCHAR(12) NOT NULL CHECK (Status IN ('Planned','Confirmed','Cancelled')),
    SeatsBooked INT NOT NULL DEFAULT 0, -- Add column for seats booked
    PRIMARY KEY (DoctorID, ClinicID, EventDate),
    FOREIGN KEY (DoctorID) REFERENCES DOCTOR(DoctorID),
    FOREIGN KEY (ClinicID) REFERENCES CLINIC(ClinicID)
);

-- Show created objects and constraints
SELECT name, type_desc
FROM sys.objects
WHERE type IN ('U','PK','F','C','UQ');

-- A2) Insert rows and show data
INSERT INTO DOCTOR VALUES
('D001','Nomsa Dlamini','nomsa@clinic.org','GP',1),
('D002','Sipho Nkosi','sipho@clinic.org','Pediatrics',1),
('D003','Maya Naidoo','maya@clinic.org','Dermatology',1),
('D004','Henk Cloete','henk@clinic.org','GP',1),
('D005','Sihle Nukani', NULL ,'Physiotherapy',1);
SELECT * FROM DOCTOR;

INSERT INTO CLINIC VALUES
('CL001','Joburg Community','167 Pert Road, Johannesburg'),
('CL002','Gqeberha Wellness','5 Second Avenue, Gqeberha'),
('CL003','Mkhize Health','33 Bertha Mkhize Street, Durban'),
('CL004','Durban Central','27 Bram Fischer Road, Durban'),
('CL005','Tshwane Family','210 Du Toit Street, Tshwane');
SELECT * FROM CLINIC;

INSERT INTO OUTREACH (DoctorID, ClinicID, EventDate, SeatsAvailable, Status)
VALUES
('D002','CL001','2025-10-10',50,'Confirmed'),
('D002','CL004','2025-10-12',30,'Planned'),
('D003','CL005','2025-10-09',15,'Confirmed'),
('D004','CL003','2025-10-11',20,'Confirmed'),
('D004','CL001','2025-10-10',40,'Planned');
SELECT * FROM OUTREACH;

-- A3) Correct constraint for SeatsBooked without referring to SeatsAvailable
-- Remove check constraint (which was problematic)
-- ALTER TABLE OUTREACH
-- ADD CHECK (SeatsBooked >= 0 AND SeatsBooked <= SeatsAvailable);

-- A4) Update SeatsBooked = 35 for specified row
UPDATE OUTREACH
SET SeatsBooked = 35
WHERE DoctorID = 'D004'
  AND ClinicID = 'CL001'
  AND EventDate = '2025-10-10';
SELECT * FROM OUTREACH
WHERE DoctorID = 'D004'
  AND ClinicID = 'CL001'
  AND EventDate = '2025-10-10';

-- SECTION B
-- B1) Doctors with no outreach
SELECT DoctorName
FROM DOCTOR d
WHERE NOT EXISTS (SELECT 1 FROM OUTREACH o WHERE o.DoctorID = d.DoctorID);

-- B2) Seats per doctor (include those with none)
SELECT d.DoctorName,
       SUM(o.SeatsAvailable) AS TotalSeatsAvailable
FROM DOCTOR d
LEFT JOIN OUTREACH o ON d.DoctorID = o.DoctorID
GROUP BY d.DoctorName
ORDER BY d.DoctorName;

-- B3) Best clinic for DoctorID D004
SELECT d.DoctorName, c.ClinicName, o.SeatsAvailable
FROM OUTREACH o
JOIN DOCTOR d ON o.DoctorID = d.DoctorID
JOIN CLINIC c ON o.ClinicID = c.ClinicID
WHERE o.DoctorID = 'D004'
  AND o.SeatsAvailable = (
      SELECT MAX(SeatsAvailable)
      FROM OUTREACH
      WHERE DoctorID = 'D004');

-- B4) Booking pressure (FillRate >= 50%)
SELECT d.DoctorName, o.EventDate, o.SeatsAvailable, o.SeatsBooked,
       o.SeatsBooked * 100.0 / NULLIF(o.SeatsAvailable, 0) AS FillRate
FROM OUTREACH o
JOIN DOCTOR d ON o.DoctorID = d.DoctorID
WHERE o.SeatsBooked * 100.0 / NULLIF(o.SeatsAvailable, 0) >= 50
ORDER BY FillRate DESC;

-- SECTION C optional
-- C1) Nonclustered index
CREATE NONCLUSTERED INDEX IX_OUTREACH_DoctorID
ON OUTREACH(DoctorID) INCLUDE (SeatsAvailable);

-- C2) Attempt to insert duplicate row (will cause PK error)
-- This will raise a Primary Key violation due to duplicate combination of DoctorID, ClinicID, and EventDate
-- INSERT INTO OUTREACH VALUES ('D002','CL001','2025-10-10',50,'Confirmed',0);
