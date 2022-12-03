CREATE TABLE [People]
(
    [peopleID] VARCHAR(20) DEFAULT 'XX0000',
    [firstName] NVARCHAR(32) NOT NULL,
    [lastName] NVARCHAR(32) NOT NULL,
    [sex] CHAR(1) NOT NULL,
    [birthDay] DATE NOT NULL,
    [address] NVARCHAR(510) NOT NULL,
    [phone] VARCHAR(15) NOT NULL,
    [cardID] VARCHAR(15) NULL UNIQUE,
    [role] TINYINT NOT NULL,
    [status] TINYINT NOT NULL DEFAULT 1,
	[createdAt] DATETIME,
	[updatedAt] DATETIME,
    CONSTRAINT [peopleKey]
        PRIMARY KEY ([peopleID]),
    CONSTRAINT [sexCheck] CHECK ([sex] = 'M'
                                 OR [sex] = 'F'
                                 OR [sex] = 'O'
                                ),
    -- thân nhân = 0; bệnh nhân = 1; nhân viên = 2
    CONSTRAINT [role] CHECK ([role]
                             BETWEEN 0 AND 2
                            ),
    CONSTRAINT [birthdayCheck] CHECK ([birthDay] < GETDATE()),
    CONSTRAINT [chk_phone] CHECK ([phone] NOT LIKE '%[^0-9]%'),
);
GO

CREATE TABLE [Patients]
(
    [patientID] VARCHAR(20) DEFAULT 'XX0000', --Khóa chính tương ứng lớp cha
    [patientJob] NVARCHAR(255),
    [healthInsurance] VARCHAR(20),
    [reason] NVARCHAR(500),
    CONSTRAINT [patientKey]
        PRIMARY KEY ([patientID]),
    CONSTRAINT [people_patient]
        FOREIGN KEY ([patientID])
        REFERENCES [dbo].[People] ([peopleID]) ON UPDATE CASCADE
);
GO

--cycle relationship of relatives
CREATE TABLE [Relatives]
(
    [relativeID] VARCHAR(20),
    [patientID] VARCHAR(20),
    CONSTRAINT [relativeKey]
        PRIMARY KEY (
						[relativeID],
                        [patientID]
                    ),
    CONSTRAINT [twoPeople] CHECK ([patientID] <> [relativeID]),
    CONSTRAINT [existPerson1]
        FOREIGN KEY ([patientID])
        REFERENCES [dbo].[People] ([peopleID]),
    CONSTRAINT [existPerson2]
        FOREIGN KEY ([relativeID])
        REFERENCES [dbo].[People] ([peopleID])
);
GO

CREATE TABLE [Employees]
(
    [employeeID] VARCHAR(20), --Khóa chính tương ứng lớp cha
    [position] NVARCHAR(25),
    CONSTRAINT [employeeKey]
        PRIMARY KEY ([employeeID]),
	CONSTRAINT positionCheck CHECK (position = N'Bác sĩ' OR position = N'Nhân viên'),
    CONSTRAINT [people_employee]
        FOREIGN KEY ([employeeID])
        REFERENCES [dbo].[People] ([peopleID]) ON UPDATE CASCADE,
);
GO

CREATE TABLE [Services]
(
    [serviceID] VARCHAR(20) DEFAULT 'XX0000',
    [serviceName] NVARCHAR(255) NOT NULL UNIQUE,
    [servicePrice] INT,
    [status] TINYINT NOT NULL DEFAULT 1,
    [createdAt] DATETIME,
	[updatedAt] DATETIME,
    CONSTRAINT [sPrice] CHECK ([servicePrice] > 0),
    CONSTRAINT [serviceKey]
        PRIMARY KEY ([serviceID])
);
GO

CREATE TABLE [UsingService]
(
    [usingServiceID] INT IDENTITY(1,1) NOT NULL UNIQUE,
    [patientID] VARCHAR(20),
    [serviceID] VARCHAR(20),
    [quantity] TINYINT,
    [status] TINYINT NOT NULL DEFAULT 1,
    [createdAt] DATETIME,
    CONSTRAINT [usingPKEY]
        PRIMARY KEY (
                        [usingServiceID],
                        [patientID],
                        [serviceID]
                    ),
    CONSTRAINT [pUsingFKEY]
        FOREIGN KEY ([patientID])
        REFERENCES [dbo].[Patients] ([patientID]) ON UPDATE CASCADE,
    CONSTRAINT [sUsingFKEY]
        FOREIGN KEY ([serviceID])
        REFERENCES [dbo].[Services] ([serviceID]) ON UPDATE CASCADE,
    CONSTRAINT [using#] CHECK ([quantity] > 0)
);
GO


CREATE TABLE [Departments]
(
    [departmentID] VARCHAR(20) DEFAULT 'XXX0000',
    [departmentName] NVARCHAR(255) NOT NULL UNIQUE,
    [status] TINYINT NOT NULL DEFAULT 1,
    [createdAt] DATETIME,
	[updatedAt] DATETIME,
    CONSTRAINT [departmentKey]
        PRIMARY KEY ([departmentID])
);
GO

-- relationship belong
ALTER TABLE [dbo].[Employees] ADD [departmentID] VARCHAR(20) NULL;
GO

ALTER TABLE [dbo].[Employees]
ADD CONSTRAINT [belongDepartment]
    FOREIGN KEY ([departmentID])
    REFERENCES [dbo].[Departments] ([departmentID]) ON DELETE SET NULL ON UPDATE CASCADE;
GO

CREATE TABLE [Receipts]
(
    [receiptID] VARCHAR(20) DEFAULT 'XXX0000',
    [receiptName] NVARCHAR(255),
    [status] TINYINT NOT NULL DEFAULT 1,
    [createdAt] DATETIME,
	[updatedAt] DATETIME,
    CONSTRAINT [receiptKey]
        PRIMARY KEY ([receiptID])
);
GO

CREATE TABLE [Pay]
(
    [payID] INT IDENTITY(1,1) NOT NULL UNIQUE,
    [patientID] VARCHAR(20) NOT NULL,
    [employeeID] VARCHAR(20) NOT NULL,
    [receiptID] VARCHAR(20) NOT NULL,
    [payTotal] INT,
    [status] TINYINT NOT NULL DEFAULT 1,
    [createdAt] DATETIME,
    CONSTRAINT [payKey]
        PRIMARY KEY (
                        [payID],
                        [patientID],
                        [employeeID],
                        [receiptID]
                    ),
    CONSTRAINT [patientPay]
        FOREIGN KEY ([patientID])
        REFERENCES [dbo].[Patients] ([patientID]),
    CONSTRAINT [employeePay]
        FOREIGN KEY ([employeeID])
        REFERENCES [dbo].[Employees] ([employeeID]),
    CONSTRAINT [receiptPay]
        FOREIGN KEY ([receiptID])
        REFERENCES [dbo].[Receipts] ([receiptID])
);
GO

CREATE TABLE [Prescriptions]
(
	[prescriptionID] VARCHAR(20) DEFAULT 'XX0000',
    [descriptionPrescription] NVARCHAR(500),
    [createdAt] DATETIME,
    [updatedAt] DATETIME,
    [status] TINYINT NOT NULL DEFAULT 1,
    CONSTRAINT [prescriptionKey]
        PRIMARY KEY ([prescriptionId])
);
GO

CREATE TABLE [CreatedPrescription]
(
    [_id] INT IDENTITY(1, 1) NOT NULL UNIQUE,
    [patientID] VARCHAR(20) NOT NULL,
    [employeeID] VARCHAR(20) NOT NULL,
    [prescriptionID] VARCHAR(20) NOT NULL,
    CONSTRAINT [CreatedPrescriptionKey] 
        PRIMARY KEY([_id],
                    [patientID],
                    [employeeID],
                    [prescriptionID]),
    CONSTRAINT [CreatedPrescription_Patient_FK] FOREIGN KEY (patientID) REFERENCES Patients (patientID),
    CONSTRAINT [CreatedPrescription_Employee_FK] FOREIGN KEY (employeeID) REFERENCES Employees (employeeID),
    CONSTRAINT [CreatedPrescription_Prescription_FK] FOREIGN KEY (prescriptionID) REFERENCES Prescriptions (prescriptionID)
);
GO

ALTER TABLE dbo.CreatedPrescription ADD examinateID VARCHAR(20);
GO

SELECT * FROM CreatedPrescription

CREATE TABLE [Medicines]
(
    [medicineID] VARCHAR(20) DEFAULT 'XX0000',
    [medicineName] NVARCHAR(255) NOT NULL UNIQUE,
    [unit] NVARCHAR(255),
    [medicinePrice] INT,
    [status] TINYINT NOT NULL DEFAULT 1,
	expiry INT NOT NULL, --số ngày sử dụng
	count INT NOT NULL CHECK(count >= 0), -- số tồn trong kho
    shape NVARCHAR(100) NOT NULL,
    [createdAt] DATETIME,
    [updatedAt] DATETIME,
    CONSTRAINT [dPrice] CHECK ([medicinePrice] > 0),
    CONSTRAINT [drugKey]
        PRIMARY KEY ([medicineID])
);
GO

CREATE TABLE Prescription_Medicine
(
    [prescriptionID] VARCHAR(20) NOT NULL,
    [medicineName] NVARCHAR(255) NOT NULL,
    [quanlity] INT NOT NULL,
    CONSTRAINT [Prescription_Medicine_Key] 
        PRIMARY KEY(
                    [prescriptionID],
                    [medicineName]),
    CONSTRAINT [Prescription_Medicine_FK] FOREIGN KEY (prescriptionID) REFERENCES Prescriptions(prescriptionID),
    CONSTRAINT [Medicine_Prescription_FK] FOREIGN KEY (medicineName) REFERENCES Medicines(medicineName),
);
GO

CREATE TABLE MedicineGroups
(
    [medicineGroupID] VARCHAR(20) DEFAULT 'XXX0000',
    [medicineGroupName] NVARCHAR(255) NOT NULL UNIQUE,
    [createdAt] DATETIME,
    [updatedAt] DATETIME,
    CONSTRAINT [medicineGroupKey]
        PRIMARY KEY ([medicineGroupID])
);
GO

ALTER TABLE [Medicines] ADD [medicineGroupName] NVARCHAR(255);
GO
ALTER TABLE [Medicines] ADD CONSTRAINT [Medicine_MedicineGroup_FK] FOREIGN KEY (medicineGroupName) REFERENCES MedicineGroups(medicineGroupName)
ON DELETE SET NULL ON UPDATE CASCADE;
GO

CREATE TABLE [Examination]
(
    [examinateID] VARCHAR(20) UNIQUE DEFAULT 'XX0000',
    [patientID] VARCHAR(20),
    [employeeID] VARCHAR(20),
    [height] FLOAT,
    [weight] FLOAT,
    [temperature] FLOAT,
    [breathing] INT,
    [symptom] NVARCHAR(510),
    [veins] INT,
    [bloodPressure] INT,
    [preliminaryDiagnosis] NVARCHAR(510),
    [finalDiagnosis] NVARCHAR(510),
    [treatmentDirection] NVARCHAR(510),
    [status] TINYINT NOT NULL DEFAULT 1,
    [createdAt] DATETIME,
    CONSTRAINT [examKey]
        PRIMARY KEY (
                        [patientID],
                        [employeeID] ,
                        [examinateID]
                    ), 

    CONSTRAINT [patientExam]
        FOREIGN KEY ([patientID])
        REFERENCES [dbo].[Patients] ([patientID]),
    CONSTRAINT [employeeExam]
        FOREIGN KEY ([employeeID])
        REFERENCES [dbo].[Employees] ([employeeID]),
    CONSTRAINT [examID]
        UNIQUE ([examinateID]),
    CONSTRAINT [gtZero] CHECK ([height] > 0
                               AND [weight] > 0
                               AND [temperature] > 0
                               AND [breathing] > 0
                               AND [veins] > 0
                              )
);
GO

--Roles
create table Roles(
	ID int IDENTITY(1,1) primary key,
	role nvarchar(50) not null,
	CONSTRAINT [roleCheck] CHECK ([role] = 'admin'
                                 OR [role] = 'doctor'
                                 OR [role] = 'employee'
                                ),
);
go
-- Accounts
create table Accounts (
	Username varchar(20) primary key,
	Password varchar(100)  not null,
	RoleID int not null,
	foreign key (RoleID) references Roles(ID),
	foreign key (Username) references People(peopleID),
);
go

