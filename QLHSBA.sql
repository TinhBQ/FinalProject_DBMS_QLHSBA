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

-- BEGIN: FUNCTION func_Auto_PeopleId
CREATE FUNCTION func_Auto_PeopleId(@role TINYINT)
RETURNS VARCHAR(20)
AS
BEGIN
DECLARE @id_next VARCHAR(20)
DECLARE @max INT
DECLARE @object VARCHAR(2)
IF @role = 0
BEGIN
	SET @object = 'TN'
END
ELSE
BEGIN
	IF @role = 1
	BEGIN
		SET @object = 'BN'
	END
	ELSE
	BEGIN
		SET @object = 'NV'
	END
END
SELECT @max = COUNT(role) FROM dbo.People WHERE role = @role
SET @id_next = @object + RIGHT('0' + CAST(@max AS VARCHAR(17)), 18)
-- Kiểm tra id đã tồn tại chưa
WHILE(EXISTS(SELECT peopleID FROM dbo.People WHERE peopleID = @id_next))
BEGIN
	SET @max = @max + 1
	SET @id_next = @object + RIGHT('0' + CAST(@max AS VARCHAR(17)), 18)
END
RETURN @id_next
END
GO
-- END: FUNCTION func_Auto_PeopleId

-- BEGIN: FUNCTION func_Auto_serviceID
CREATE FUNCTION func_Auto_serviceID()
RETURNS VARCHAR(20)
AS
BEGIN
	DECLARE @id_next VARCHAR(20)
	DECLARE @max INT
	DECLARE @object VARCHAR(2)
	BEGIN
		SET @object = 'SV'
	END
	SELECT @max = COUNT(serviceID) FROM [Services]
	SET @id_next = @object + RIGHT('0' + CAST(@max AS VARCHAR(17)), 18)
	-- Kiểm tra id đã tồn tại chưa
	WHILE(EXISTS(SELECT serviceID FROM [Services] WHERE serviceID = @id_next))
	BEGIN
		SET @max = @max + 1
		SET @id_next = @object + RIGHT('0' + CAST(@max AS VARCHAR(17)), 18)
	END
		RETURN @id_next
END
GO
-- END: FUNCTION func_Auto_serviceID

-- BEGIN: FUNCTION func_Auto_departmentID
CREATE FUNCTION func_Auto_departmentID()
RETURNS VARCHAR(20)
AS
BEGIN
	DECLARE @id_next VARCHAR(20)
	DECLARE @max INT
	DECLARE @object VARCHAR(3)
	BEGIN
		SET @object = 'Dep'
	END
	SELECT @max = COUNT(departmentID) FROM [Departments]
	SET @id_next = @object + RIGHT('0' + CAST(@max AS VARCHAR(17)), 18)
	-- Kiểm tra id đã tồn tại chưa
	WHILE(EXISTS(SELECT departmentID FROM [Departments] WHERE departmentID = @id_next))
	BEGIN
		SET @max = @max + 1
		SET @id_next = @object + RIGHT('0' + CAST(@max AS VARCHAR(17)), 18)
	END
		RETURN @id_next
END
GO
-- END: FUNCTION func_Auto_departmentID

-- BEGIN: FUNCTION func_Auto_ReceiptID
CREATE FUNCTION func_Auto_ReceiptID()
RETURNS VARCHAR(20)
AS
BEGIN
	DECLARE @id_next VARCHAR(20)
	DECLARE @max INT
	DECLARE @object VARCHAR(3)
	BEGIN
		SET @object = 'Rec'
	END
	SELECT @max = COUNT(receiptID) FROM [Receipts]
	SET @id_next = @object + RIGHT('0' + CAST(@max AS VARCHAR(17)), 18)
	-- Kiểm tra id đã tồn tại chưa
	WHILE(EXISTS(SELECT receiptID FROM [Receipts] WHERE receiptID = @id_next))
	BEGIN
		SET @max = @max + 1
		SET @id_next = @object + RIGHT('0' + CAST(@max AS VARCHAR(17)), 18)
	END
		RETURN @id_next
END
GO
-- END: FUNCTION func_Auto_ReceiptID

-- BEGIN: FUNCTION func_Auto_prescriptionID
CREATE FUNCTION func_Auto_prescriptionID()
RETURNS VARCHAR(20)
AS
BEGIN
	DECLARE @id_next VARCHAR(20)
	DECLARE @max INT
	DECLARE @object VARCHAR(2)
	BEGIN
		SET @object = 'DT'
	END
	SELECT @max = COUNT(prescriptionID) FROM [Prescriptions]
	SET @id_next = @object + RIGHT('0' + CAST(@max AS VARCHAR(17)), 18)
	-- Kiểm tra id đã tồn tại chưa
	WHILE(EXISTS(SELECT prescriptionID FROM [Prescriptions] WHERE prescriptionID = @id_next))
	BEGIN
		SET @max = @max + 1
		SET @id_next = @object + RIGHT('0' + CAST(@max AS VARCHAR(17)), 18)
	END
		RETURN @id_next
END
GO
-- END: FUNCTION func_Auto_prescriptionID

-- BEGIN: FUNCTION func_Auto_medicineID
CREATE FUNCTION func_Auto_medicineID()
RETURNS VARCHAR(20)
AS
BEGIN
	DECLARE @id_next VARCHAR(20)
	DECLARE @max INT
	DECLARE @object VARCHAR(2)
	BEGIN
		SET @object = 'MC'
	END
	SELECT @max = COUNT(medicineID) FROM [Medicines]
	SET @id_next = @object + RIGHT('0' + CAST(@max AS VARCHAR(17)), 18)
	-- Kiểm tra id đã tồn tại chưa
	WHILE(EXISTS(SELECT medicineID FROM [Medicines] WHERE medicineID = @id_next))
	BEGIN
		SET @max = @max + 1
		SET @id_next = @object + RIGHT('0' + CAST(@max AS VARCHAR(17)), 18)
	END
		RETURN @id_next
END
GO
-- END: FUNCTION func_Auto_medicineID

-- BEGIN: FUNCTION func_Auto_medicineGroupID
CREATE FUNCTION func_Auto_medicineGroupID()
RETURNS VARCHAR(20)
AS
BEGIN
	DECLARE @id_next VARCHAR(20)
	DECLARE @max INT
	DECLARE @object VARCHAR(3)
	SET @object = 'MCG'
	SELECT @max = COUNT(medicineGroupID) FROM [MedicineGroups]
	SET @id_next = @object + RIGHT('0' + CAST(@max AS VARCHAR(17)), 18)
	-- Kiểm tra id đã tồn tại chưa
	WHILE(EXISTS(SELECT medicineGroupID FROM [MedicineGroups] WHERE medicineGroupID = @id_next))
	BEGIN
		SET @max = @max + 1
		SET @id_next = @object + RIGHT('0' + CAST(@max AS VARCHAR(17)), 18)
	END
		RETURN @id_next
END
GO
-- END: FUNCTION func_Auto_medicineGroupID

-- BEGIN: FUNCTION func_Auto_examinateID
CREATE FUNCTION func_Auto_examinateID()
RETURNS VARCHAR(20)
AS
BEGIN
	DECLARE @id_next VARCHAR(20)
	DECLARE @max INT
	DECLARE @object VARCHAR(2)
	BEGIN
		SET @object = 'EX'
	END
	SELECT @max = COUNT(examinateID) FROM [Examination]
	SET @id_next = @object + RIGHT('0' + CAST(@max AS VARCHAR(17)), 18)
	-- Kiểm tra id đã tồn tại chưa
	WHILE(EXISTS(SELECT examinateID FROM [Examination] WHERE examinateID = @id_next))
	BEGIN
		SET @max = @max + 1
		SET @id_next = @object + RIGHT('0' + CAST(@max AS VARCHAR(17)), 18)
	END
		RETURN @id_next
END
GO
-- END: FUNCTION func_Auto_examinateID

-- BEGIN: func_FullName
CREATE FUNCTION func_FullName(@peopleID  VARCHAR(20))
RETURNS NVARCHAR(100)
AS
BEGIN
	DECLARE @firstName NVARCHAR(32)
	DECLARE @lastName NVARCHAR(32)
	DECLARE @fullName NVARCHAR(100)

	SELECT @firstName = firstName FROM People WHERE peopleID = @peopleID
	SELECT @lastName = lastName FROM People WHERE peopleID = @peopleID 
	SET @fullName = @lastName + ' ' + @firstName
	RETURN @fullName
END
GO
-- END: func_FullName

CREATE FUNCTION func_ConvertID(@ID VARCHAR(20), @lenObject INT)
RETURNS INT
AS
BEGIN
	DECLARE @Res INT
	SELECT @ID = RIGHT(@ID, LEN(@ID) - @lenObject)
	SET @Res = CONVERT(INT, @ID)
	RETURN @Res
END
GO

CREATE FUNCTION func_GetPrescriptionID_New()
RETURNS VARCHAR(20)
AS
BEGIN
	DECLARE @ID VARCHAR(20)
	SELECT @ID = prescriptionID FROM Prescriptions WHERE createdAt = (SELECT MAX(createdAt) FROM Prescriptions)
	RETURN @ID
END
GO

CREATE FUNCTION func_UpdateQuanlityMedicine(@prescriptionID VARCHAR(20), @medicineName NVARCHAR(255), @quanlity INT)
RETURNS INT
BEGIN
	DECLARE @count INT
	DECLARE @quanlityNew INT

	SELECT @count = count FROM dbo.Medicines WHERE medicineName = @medicineName
	SELECT @quanlityNew = quanlity FROM dbo.Prescription_Medicine WHERE medicineName = @medicineName AND prescriptionID = @prescriptionID
	
	SET @count = @count + @quanlity - @quanlityNew

	RETURN @count
END
GO

-- Begin: trigger Inserted and Updated in People
CREATE TRIGGER trg_Inserted_Updated_People ON dbo.People
FOR INSERT, UPDATE
AS
DECLARE @createdAt DATETIME
DECLARE @updatedAt DATETIME
DECLARE @role TINYINT
DECLARE @peopleID VARCHAR(20)
BEGIN
	IF TRIGGER_NESTLEVEL() > 1
    RETURN

	SELECT @peopleID = Inserted.peopleID, @createdAt = Inserted.createdAt, @updatedAt = Inserted.updatedAt
	FROM Inserted
    -- Inserted
	IF (@createdAt IS NULL)
	BEGIN
        -- Tự động cập nhật ngày tạo
		SET @createdAt = GETDATE()
		UPDATE dbo.People SET createdAt = @createdAt WHERE peopleID = @peopleID

        -- Cập nhật Id tăng tự động
        SELECT @role = Inserted.role FROM Inserted
        SET @peopleId = dbo.func_Auto_PeopleId(@role)
        UPDATE dbo.People SET peopleID = @peopleId WHERE peopleID = 'XX0000'

        -- Kế thừa id qua Patient
        IF (@role = 1)
        BEGIN
            INSERT INTO dbo.Patients (patientID)
            VALUES (@peopleId)
        END
        -- Kế thừa id qua Employees
        ELSE
        BEGIN
            IF (@role = 2)
            BEGIN
                INSERT INTO dbo.Employees (employeeID)
                VALUES (@peopleId)
            END
        END
    END
    -- Updated
	ELSE
	BEGIN
        -- Tự động cập nhật ngày update
		SET @updatedAt = GETDATE()
		UPDATE dbo.People SET updatedAt = @updatedAt WHERE peopleID = @peopleID
	END
END
GO
-- End: trigger Inserted and Updated in People

-- Begin: trigger Inserted and Updated in Services
CREATE TRIGGER trg_Inserted_Updated_Service ON dbo.Services
FOR INSERT, UPDATE
AS
DECLARE @createdAt DATETIME
DECLARE @updatedAt DATETIME
DECLARE @serviceID VARCHAR(20)
BEGIN
	IF TRIGGER_NESTLEVEL() > 1
    RETURN

	SELECT @serviceID = Inserted.serviceID, @createdAt = Inserted.createdAt, @updatedAt = Inserted.updatedAt
	FROM Inserted
    -- Inserted
	IF (@createdAt IS NULL)
	BEGIN
        -- Tự động tạo ngày tạo
		SET @createdAt = GETDATE()
		UPDATE dbo.Services SET createdAt = @createdAt WHERE serviceID = @serviceID

        -- Tự động tạo ID
	    SET @serviceID = dbo.func_Auto_serviceID()
	    UPDATE [Services] SET serviceID = @serviceID WHERE serviceID = 'XX0000'
	END
    -- Updated
	ELSE
	BEGIN
        -- Tự động tạo ngày cập nhật
		SET @updatedAt = GETDATE()
		UPDATE dbo.Services SET updatedAt = @updatedAt WHERE serviceID = @serviceID
	END
END
GO
-- End: trigger Inserted and Updated in Services

--Begin: trigger createdAt in UsingService
CREATE TRIGGER UsingService_CreatedAt ON dbo.UsingService
FOR INSERT
AS
DECLARE @createdAt DATETIME
DECLARE @usingServiceID VARCHAR(20)
BEGIN
	IF TRIGGER_NESTLEVEL() > 1
    RETURN

	SELECT @usingServiceID = Inserted.usingServiceID, @createdAt = Inserted.createdAt
	FROM Inserted
	IF (@createdAt IS NULL)
	BEGIN
		SET @createdAt = GETDATE()
		UPDATE dbo.UsingService SET createdAt = @createdAt WHERE usingServiceID = @usingServiceID
	END
END
GO
--End: trigger createdAt in UsingService

-- Begin: trigger Inserted and Updated in Departments
CREATE TRIGGER trg_Inserted_Updated_Department ON dbo.Departments
FOR INSERT, UPDATE
AS
DECLARE @createdAt DATETIME
DECLARE @updatedAt DATETIME
DECLARE @departmentID VARCHAR(20)
BEGIN
    IF TRIGGER_NESTLEVEL() > 1
    RETURN

	SELECT @departmentID = Inserted.departmentID, @createdAt = Inserted.createdAt, @updatedAt = Inserted.updatedAt
	FROM Inserted
    -- Inserted
	IF (@createdAt IS NULL)
	BEGIN
        -- Tự động cập nhật ngày tạo
		SET @createdAt = GETDATE()
		UPDATE dbo.Departments SET createdAt = @createdAt WHERE departmentID = @departmentID

        -- Cập nhật ID tăng tự động
        SET @departmentID = dbo.func_Auto_departmentID()
        UPDATE [Departments] SET departmentID = @departmentID WHERE departmentID = 'XXX0000'
	END
    -- Updated
	ELSE
	BEGIN
        -- Cập nhật ngày update
		SET @updatedAt = GETDATE()
		UPDATE dbo.Departments SET updatedAt = @updatedAt WHERE departmentID = @departmentID
	END
END
GO
-- End: trigger Inserted and Updated in Departments

-- Begin: trigger Inserted and Updated in Receipts
CREATE TRIGGER trg_Inserted_Updated_Receipt ON dbo.Receipts
FOR INSERT, UPDATE
AS
DECLARE @createdAt DATETIME
DECLARE @updatedAt DATETIME
DECLARE @receiptID VARCHAR(20)
BEGIN
	IF TRIGGER_NESTLEVEL() > 1
    RETURN

	SELECT @receiptID = Inserted.receiptID, @createdAt = Inserted.createdAt, @updatedAt = Inserted.updatedAt
	FROM Inserted
    -- Inserted
	IF (@createdAt IS NULL)
	BEGIN
        -- Tự động cập nhật ngày tạo
		SET @createdAt = GETDATE()
		UPDATE dbo.Receipts SET createdAt = @createdAt WHERE receiptID = @receiptID

        -- Tự động cập nhật ID
        SET @receiptID = dbo.func_Auto_receiptID()
	    UPDATE [receipts] SET receiptID = @receiptID WHERE receiptID = 'XXX0000'
	END
    -- Updated
	ELSE
	BEGIN
        -- Tự động cập nhật ngày Update
		SET @updatedAt = GETDATE()
		UPDATE dbo.Receipts SET updatedAt = @updatedAt WHERE receiptID = @receiptID
	END
END
GO
-- End: trigger Inserted and Updated in Receipts

--Begin: trigger createdAt in Pay
CREATE TRIGGER Pay_CreatedAt ON dbo.Pay
FOR INSERT
AS
DECLARE @createdAt DATETIME
DECLARE @payID VARCHAR(20)
BEGIN
	IF TRIGGER_NESTLEVEL() > 1
    RETURN

	SELECT @payID = Inserted.payID, @createdAt = Inserted.createdAt
	FROM Inserted
	IF (@createdAt IS NULL)
	BEGIN
		SET @createdAt = GETDATE()
		UPDATE dbo.Pay SET createdAt = @createdAt WHERE payID = @payID
	END
END
GO
--End: trigger createdAt in Pay

-- Begin: trigger Inserted and Updated in Prescriptions
CREATE TRIGGER trg_Inserted_Updated_Prescription ON dbo.Prescriptions
FOR INSERT, UPDATE
AS
DECLARE @createdAt DATETIME
DECLARE @updatedAt DATETIME
DECLARE @prescriptionID VARCHAR(20)
BEGIN
	IF TRIGGER_NESTLEVEL() > 1
    RETURN

	SELECT @prescriptionID = Inserted.prescriptionID, @createdAt = Inserted.createdAt, @updatedAt = Inserted.updatedAt
	FROM Inserted
    -- Inserted
	IF (@createdAt IS NULL)
	BEGIN
		SET @createdAt = GETDATE()
		UPDATE dbo.Prescriptions SET createdAt = @createdAt WHERE prescriptionID = @prescriptionID

        SET @prescriptionID = dbo.func_Auto_prescriptionID()
	    UPDATE [Prescriptions] SET prescriptionID = @prescriptionID WHERE prescriptionID = 'XX0000'
	END
    -- Updated
	ELSE
	BEGIN
		SET @updatedAt = GETDATE()
		UPDATE dbo.Prescriptions SET updatedAt = @updatedAt WHERE prescriptionID = @prescriptionID
	END
END
GO
-- End: trigger Inserted and Updated in Prescriptions

CREATE TRIGGER trg_Inserted_Updated_Medicine ON dbo.Medicines
FOR INSERT, UPDATE
AS
DECLARE @createdAt DATETIME
DECLARE @updatedAt DATETIME
DECLARE @medicineID VARCHAR(20)
BEGIN
	IF TRIGGER_NESTLEVEL() > 1
    RETURN

	SELECT @medicineID = Inserted.medicineID, @createdAt = Inserted.createdAt, @updatedAt = Inserted.updatedAt
	FROM Inserted
    -- Inserted
	IF (@createdAt IS NULL)
	BEGIN
		SET @createdAt = GETDATE()
		UPDATE dbo.Medicines SET createdAt = @createdAt WHERE medicineID = @medicineID

        SET @medicineID = dbo.func_Auto_medicineID();
	    UPDATE [Medicines] SET medicineID = @medicineID WHERE medicineID = 'XX0000'
	END
    -- Updated
	ELSE
	BEGIN
		SET @updatedAt = GETDATE()
		UPDATE dbo.Medicines SET updatedAt = @updatedAt WHERE medicineID = @medicineID
	END
END
GO

CREATE TRIGGER trg_Deleted_Medicine ON dbo.Medicines
FOR DELETE
AS
DECLARE @updatedAt DATETIME
DECLARE @medicineID VARCHAR(20)
BEGIN
	IF TRIGGER_NESTLEVEL() > 1
    RETURN
	
	SELECT @medicineID = Deleted.medicineID, @updatedAt = Deleted.updatedAt
	FROM Deleted

	DECLARE @status TINYINT
	SELECT @status = status FROM dbo.Medicines WHERE medicineID = @medicineID
	IF (@status > 0)
	BEGIN
		RaisError ('Khong the > 10', 16, 1)
		RollBack Tran
	END
END
GO

-- Begin: trigger Inserted and Updated in MedicineGroups
CREATE TRIGGER trg_Inserted_Updated_MedicineGroup ON dbo.MedicineGroups
FOR INSERT, UPDATE
AS
DECLARE @createdAt DATETIME
DECLARE @updatedAt DATETIME
DECLARE @medicineGroupID VARCHAR(20)
BEGIN
	IF TRIGGER_NESTLEVEL() > 1
    RETURN

	SELECT @medicineGroupID = Inserted.medicineGroupID, @createdAt = Inserted.createdAt, @updatedAt = Inserted.updatedAt
	FROM Inserted
    -- Inserted
	IF (@createdAt IS NULL)
	BEGIN
		SET @createdAt = GETDATE()
		UPDATE dbo.MedicineGroups SET createdAt = @createdAt WHERE medicineGroupID = @medicineGroupID

        SET @medicineGroupID = dbo.func_Auto_medicineGroupID();
	    UPDATE [MedicineGroups] SET medicineGroupID = @medicineGroupID WHERE medicineGroupID = 'XXX0000'
	END
    -- Updated
	ELSE
	BEGIN
		SET @updatedAt = GETDATE()
		UPDATE dbo.MedicineGroups SET updatedAt = @updatedAt WHERE medicineGroupID = @medicineGroupID
	END
END
GO
-- End: trigger Inserted and Updated in MedicineGroups

-- Begin: trigger Inserted in Examination
CREATE TRIGGER trg_Inserted_Examination ON dbo.Examination
FOR INSERT
AS
DECLARE @createdAt DATETIME
DECLARE @examinateID VARCHAR(20)
BEGIN
    IF TRIGGER_NESTLEVEL() > 1
    RETURN

	SELECT @examinateID = Inserted.examinateID, @createdAt = Inserted.createdAt
	FROM Inserted
	IF (@createdAt IS NULL)
	BEGIN
		SET @createdAt = GETDATE()
		UPDATE dbo.Examination SET createdAt = @createdAt WHERE examinateID = @examinateID

        SET @examinateID = dbo.func_Auto_examinateID()
	    UPDATE [Examination] SET examinateID = @examinateID WHERE examinateID = 'XX0000'
	END
END
GO
-- End: trigger Inserted in Examination

-- Begin: trigger Inserted in Examination
CREATE TRIGGER trg_Updated_Examination ON dbo.Examination
FOR UPDATE
AS
DECLARE @createdAt DATETIME
DECLARE @examinateID VARCHAR(20)
BEGIN
    IF TRIGGER_NESTLEVEL() > 1
    RETURN

	SELECT @examinateID = deleted.examinateID FROM deleted

	UPDATE [Examination] SET [status] = 2 WHERE examinateID = @examinateID
END
GO
-- End: trigger Inserted in Examination

CREATE TRIGGER trg_Inserted_Prescription_Medicine ON dbo.Prescription_Medicine
FOR INSERT
AS
DECLARE @prescriptionID VARCHAR(20)
DECLARE @medicineName NVARCHAR(255)
DECLARE @quanlity INT
BEGIN
	IF TRIGGER_NESTLEVEL() > 1
    RETURN

	SELECT @prescriptionID = Inserted.prescriptionID, @medicineName = Inserted.medicineName, @quanlity = Inserted.quanlity FROM Inserted

	DECLARE @count INT
	SELECT @count = count FROM dbo.Medicines WHERE medicineName = @medicineName
	SET @count = @count - @quanlity
	
	
	UPDATE dbo.Medicines SET [count] = @count WHERE medicineName = @medicineName

	UPDATE dbo.Prescriptions SET [status] = 2 WHERE prescriptionID = @prescriptionID
END
GO

CREATE TRIGGER trg_Updated_Prescription_Medicine ON dbo.Prescription_Medicine
FOR UPDATE
AS
DECLARE @prescriptionID VARCHAR(20)
DECLARE @medicineName NVARCHAR(255)
DECLARE @quanlity INT
BEGIN
	IF TRIGGER_NESTLEVEL() > 1
    RETURN

	SELECT @prescriptionID = deleted.prescriptionID, @medicineName = deleted.medicineName, @quanlity = deleted.quanlity FROM deleted

	DECLARE @count INT

	SET @count = dbo.func_UpdateQuanlityMedicine(@prescriptionID, @medicineName, @quanlity)
	
	UPDATE dbo.Medicines SET [count] = @count WHERE medicineName = @medicineName
END
GO

CREATE TRIGGER trg_Deleted_Prescription_Medicine ON dbo.Prescription_Medicine
FOR DELETE
AS
DECLARE @prescriptionID VARCHAR(20)
BEGIN
	IF TRIGGER_NESTLEVEL() > 1
    RETURN

	SELECT @prescriptionID = deleted.prescriptionID FROM deleted

	DECLARE @count INT
	SELECT  @count = COUNT(*) FROM Prescription_Medicine WHERE prescriptionID = @prescriptionID

	IF (@count = 0)
	BEGIN
		UPDATE dbo.Prescriptions SET [status] = 1 WHERE prescriptionID = @prescriptionID
	END
END
GO

CREATE VIEW [View_Doctor]
AS
SELECT [P].[peopleID]   as [doctorID]
     , [P].[firstName]  as [doctorFirstname]
     , [P].[lastName]   as [doctorLastName]
     , [P].[sex]
     , [P].[birthDay]
     , [P].[address]
     , [P].[phone]
     , [P].[cardID]
     , [D].[departmentName]
     , [P].[createdAt]
     , [P].[updatedAt]
FROM([dbo].[People]             as [P]
    INNER JOIN [dbo].[Employees] as [E]
        ON [P].[peopleID] = [E].[employeeID])
    JOIN [dbo].[Departments] as [D]
        ON ([E].[departmentID] = [D].[departmentID])
WHERE [E].[position] = N'Bác sĩ';
GO


CREATE VIEW [View_Staff]
AS
SELECT [P].[peopleID]   as [doctorID]
     , [P].[firstName]  as [doctorFirstname]
     , [P].[lastName]   as [doctorLastName]
     , [P].[sex]
     , [P].[birthDay]
     , [P].[address]
     , [P].[phone]
     , [P].[cardID]
     , [D].[departmentName]
	 , [D].[departmentID]
     , [P].[createdAt]
     , [P].[updatedAt]
FROM([dbo].[People]             as [P]
    INNER JOIN [dbo].[Employees] as [E]
        ON [P].[peopleID] = [E].[employeeID])
    JOIN [dbo].[Departments] as [D]
        ON ([E].[departmentID] = [D].[departmentID])
WHERE [E].[position] = N'Nhân viên';
GO

CREATE VIEW [View_MedicineGroup_ConvertID]
AS
SELECT *, dbo.func_ConvertID(medicineGroupID, 3) AS ConvertID FROM MedicineGroups;
GO

CREATE VIEW [View_Medicine_ConvertID]
AS
SELECT *, dbo.func_ConvertID(medicineID, 2) AS ConvertID FROM Medicines;
GO

CREATE VIEW [View_Service_ConvertID]
AS
SELECT *, dbo.func_ConvertID(serviceID, 2) AS ConvertID FROM Services;
GO

CREATE VIEW [View_CreatedPrescription_New]
AS
SELECT P.prescriptionID, M.medicineID, M.medicineName, M.medicineGroupName, M.shape, M.unit, M.medicinePrice, M.expiry, M.count, P.quanlity
FROM dbo.Medicines AS [M]
INNER JOIN dbo.Prescription_Medicine AS [P] ON M.medicineName = P.medicineName
GO

--==================   View 'View_Patients' để xem các thông tin cơ bản của bệnh nhân
CREATE VIEW [dbo].[View_Patients] AS SELECT [P].[peopleID]   as [patientID]
     , [P].[firstName]  as [patientFirstName]
     , [P].[lastName]   as [patientLastname]
     , [P].[sex]
     , [P].[birthDay]
     , [P].[address]
     , [P].[phone]
     , [P].[cardID]
     , [P2].[patientJob]
     , [P2].[healthInsurance]
     , [P2].[reason]
     , [P].[createdAt]
     , [P].[updatedAt]
FROM [dbo].[People]            as [P]
    INNER JOIN [dbo].[Patients] as [P2]
        ON ([P].[peopleID] = [P2].[patientID])
GO
--============================================================



--==================== View 'View_Examination' để xem các thông tin bên trong 1 đơn khám
-- ================== chỉ lấy những đơn khám chưa bị xóa (kể cả những đơn khám đang đợi)
CREATE VIEW [dbo].[View_Examination] AS SELECT 
				Ex.examinateID,
				Ex.patientID,
				P1.firstName as tenBenhNhan,
				P1.lastName as hoBenhNhan,
				Ex.employeeID,
				P2.firstName as tenBacSi,
				P2.lastName as hoBacSi,
				Ex.[height],
				Ex.[weight],
				Ex.[temperature],
				Ex.[breathing],
				Ex.[symptom],
				Ex.[veins],
				Ex.[bloodPressure],
				Ex.[preliminaryDiagnosis],
				Ex.[finalDiagnosis],
				Ex.[treatmentDirection],
				Ex.[createdAt],
				Ex.status
FROM ((Examination as Ex INNER JOIN 
														(Patients as Pa 
																	INNER JOIN 
																			People AS P1 
																	ON (Pa.patientID = P1.peopleID))
												ON (Ex.patientID = Pa.patientID))
					INNER JOIN 
					(Employees as Em
								INNER JOIN 
										People as P2
								ON (Em.employeeID = P2.peopleID))
			ON (Ex.employeeID = Em.employeeID))
WHERE 
	Ex.status != 0
GO
--===========================================




--=========================================== view 'View_UsingService' để lấy các thông tin cơ bản của khách hàng sử dụng dịch vụ
--=========================================== có cả tính tiền tổng theo số lượng
CREATE VIEW [dbo].[View_UsingService] AS SELECT 
	US.usingServiceID,
	US.patientID,
	S.serviceID,
	S.serviceName,
	S.servicePrice,
	US.quantity,
	US.status,
	S.servicePrice * US.quantity AS totalPay,
	US.createdAt
FROM
		(UsingService as US
			INNER JOIN
		Services AS S
			ON (US.serviceID = S.serviceID))
GO
--===========================================

CREATE VIEW [View_Patients_Wait]
AS
SELECT [EX].[examinateID]
    ,  [P].[peopleID]   as [patientID]
     , [P].[firstName]  as [patientFirstName]
     , [P].[lastName]   as [patientLastname]
     , [P].[sex]
     , [P].[birthDay]
     , [P].[address]
     , [P].[phone]
     , [P].[cardID]
     , [P2].[patientJob]
     , [P2].[healthInsurance]
     , [P2].[reason]
     , [P].[createdAt]
     , [P].[updatedAt]
FROM ([dbo].[People]            as [P]
    INNER JOIN [dbo].[Patients] as [P2]
        ON ([P].[peopleID] = [P2].[patientID]))
    INNER JOIN [dbo].[Examination] as [EX]
        ON ([P2].[patientID] = [EX].[patientID])
WHERE [EX].[status] = 1;
GO

CREATE VIEW [View_Wait_DrugSupply]
AS
SELECT CPre.prescriptionID
     , CPre.examinateID
     ,  [P].[peopleID]   as [patientID]
     , [P].[firstName]  as [patientFirstName]
     , [P].[lastName]   as [patientLastname]
     , [P].[sex]
     , [P].[birthDay]
     , [P].[address]
     , [P].[phone]
     , [P].[cardID]
     , [P2].[patientJob]
     , [P2].[healthInsurance]
     , [P2].[reason]
     , [P].[createdAt]
     , [P].[updatedAt]
FROM (([dbo].[People]            as [P]
    INNER JOIN [dbo].[Patients] as [P2]
        ON ([P].[peopleID] = [P2].[patientID]))
    INNER JOIN (dbo.CreatedPrescription as [CPre] INNER JOIN dbo.Prescriptions as [Pre] ON (CPre.prescriptionID = Pre.prescriptionID))
        ON (P2.patientID = CPre.patientID))
WHERE Pre.[status] = 1;
GO

CREATE VIEW [View_Department_ConvertID]
AS
SELECT *, dbo.func_ConvertID(departmentID, 3) AS ConvertID FROM Departments;
GO


/*
	View 'View_ListMedicine_Precesciption' lấy danh sách các đơn thuốc, danh sách thuốc
	lấy cả tên thuốc, tên bệnh nhân và giá tiền theo số lượng
*/
CREATE VIEW [dbo].[View_ListMedicine_Precesciption] 
AS 
SELECT
	CP.prescriptionID,
	Cp.examinateID,
	patientID,
	employeeID,
	medicineID,
	M.medicineName,
	PM.quanlity,
	M.medicinePrice,
	PM.quanlity * M.medicinePrice as totalPrice,
	P.createdAt,
	P.status
FROM 
	CreatedPrescription as CP
		INNER JOIN 
			(Prescription_Medicine as PM INNER JOIN Prescriptions AS P ON (PM.prescriptionID = P.prescriptionID)
				INNER JOIN 
			Medicines as M 
				ON (PM.medicineName = M.medicineName))
		ON (CP.prescriptionID = CP.prescriptionID)
GO
--===============================================================

/*
	FUNCTION lấy tổng giá tiền của các dịch vụ 
	mà bệnh nhân chọn sử dụng mà chưa thanh toán
	
	tham số đầu vào: VARCHAR(20) : ID bệnh nhân
	trả về: INT
*/
CREATE FUNCTION [dbo].[func_getTotalPay_usingService] (@patientID VARCHAR(20))
RETURNS INT
AS
BEGIN
	DECLARE @totalPay INT 
	
	SELECT @totalPay = SUM(payTotal)
	FROM func_getListService_notYet(@patientID)
	
	RETURN @totalPay
END
GO
--===============================


--=============================== FUNCTION 'func_getExamHistory'
/*
	FUNCTION lấy lịch sử các lần khám trước của bệnh nhân
	trả về các thông tin cơ bản của những lần khám đó
	
	tham số đầu vào: VARCHAR(20) : id bệnh nhân cần xem
	trả về: TABLE multi value với thông tin các lần khám trước
*/
CREATE FUNCTION [dbo].[func_getExamHistory]
( 
	@patientID VARCHAR(20)
)
RETURNS @a TABLE
(
	examinateID VARCHAR(20),
	patientID VARCHAR(20),
	tenBenhNhan NVARCHAR(32),
	hoBenhNhan NVARCHAR(32),
	employeeID VARCHAR(20),
	tenBacSi NVARCHAR(32),
	hoBacSi NVARCHAR(32),
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
    [createdAt] DATETIME
)
AS
BEGIN
	INSERT INTO @a
	SELECT 
		examinateID,
		patientID,
		tenBenhNhan,
		hoBenhNhan,
		employeeID,
		tenBacSi,
		hoBacSi,   
		height,
		weight,
		[temperature],
		[breathing],
		[symptom],
		[veins],
		[bloodPressure],
		[preliminaryDiagnosis],
		[finalDiagnosis],
		[treatmentDirection],
		[createdAt]
	FROM View_Examination as VE
	WHERE VE.patientID = @patientID AND VE.status = 2
	-- status = 2 nghĩa là đã khám rồi
	ORDER BY VE.createdAt DESC
	RETURN 
END
GO
--===============================


--=============================== FUNCTION 'func_getExamWithID'
/*
	FUNCTION xem thông tin các đơn khám thông qua ID 
	
	tham số truyền vào: VARCHAR(20) : id đơn khám cần tìm
	trả về : TABLE : thông tin của đơn khám cần tìm
*/
CREATE FUNCTION [dbo].[func_getExamWithID]
( 
	@examID VARCHAR(20)
)
RETURNS @a TABLE
(
	examinateID VARCHAR(20),
	patientID VARCHAR(20),
	tenBenhNhan NVARCHAR(32),
	hoBenhNhan NVARCHAR(32),
	employeeID VARCHAR(20),
	tenBacSi NVARCHAR(32),
	hoBacSi NVARCHAR(32),
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
    [createdAt] DATETIME
)
AS
BEGIN
	INSERT INTO @a
	SELECT 
		examinateID,
		patientID,
		tenBenhNhan,
		hoBenhNhan,
		employeeID,
		tenBacSi,
		hoBacSi,   
		height,
		weight,
		[temperature],
		[breathing],
		[symptom],
		[veins],
		[bloodPressure],
		[preliminaryDiagnosis],
		[finalDiagnosis],
		[treatmentDirection],
		[createdAt]
	FROM View_Examination as VE
	WHERE VE.examinateID = @examID
	RETURN 
END
GO
--===============================



--=============================== FUNCTION 'func_getListService_notYet'
/*
	FUNCTION lấy thông tin các dịch vụ bệnh nhân đã sử dụng mà chưa thanh toán
		để thanh toán
		
	tham số đầu vào: VARCHAR(20) : id bệnh nhân cần xem
	trả về: TABLE thông tin danh sách các dịch vụ bệnh nhân đã sử dụng mà chưa thanh toán
*/
CREATE FUNCTION [dbo].[func_getListService_notYet](@patientID VARCHAR(20))
RETURNS @usingServiceList TABLE
(
	usingServiceID INT,
	patientID VARCHAR(20),
	serviceID VARCHAR(20),
	serviceName NVARCHAR(255),
	unitPrice int,
	quantity TINYINT,
	status TINYINT,
	payTotal int,
	createdAt DATETIME
)
AS
BEGIN
	INSERT INTO @usingServiceList
	SELECT *
	FROM
		View_UsingService AS VUS
	WHERE
		VUS.status = 1 AND VUS.patientID = @patientID
	RETURN 
END
GO
--===============================



--=============================== FUNCTION 'func_getRelatives'
/*
	FUNCTION lấy danh sách các thân nhân của 1 bệnh nhân
	
	tham số truyền vào: VARCHAR(20) : id bệnh nhân cần xem
	trả về: TABLE : danh sách các id, họ tên của thân nhân mà bệnh nhân ấy có
*/
CREATE FUNCTION [dbo].[func_getRelatives]
(
	@patientID VARCHAR(20)
)
RETURNS @a TABLE
(
	relativeID VARCHAR(20),
	firstName NVARCHAR(32),
	lastName NVARCHAR(32)
)
AS
BEGIN
	INSERT INTO @a
	SELECT R.relativeID, P.firstName, P.lastName FROM 
	(Relatives as R INNER JOIN People AS P ON (R.relativeID = P.peopleID))
	INNER JOIN View_Patients as Pa ON (R.patientID = Pa.patientID)
	WHERE (R.patientID = @patientID)
	RETURN
END
GO
--===============================


--=============================== FUNCTION 'func_listPatient_UsingService_toDay'
/*
	FUNCTION lấy danh sách những bệnh nhân có sử dụng dịch vụ vào ngày hôm nay
	mục đích: để xem, thống kê và thanh toán
	
	tham số truyền vào: không có
	trả về: TABLE : danh sách các thông tin:
								id bệnh nhân,
								họ và tên của bệnh nhân
*/
CREATE FUNCTION [dbo].[func_listPatient_UsingService_toDay] ()
RETURNS @listPatient TABLE
(
	patientID VARCHAR(20),
	patientFirstName NVARCHAR(32),
	patientLastname NVARCHAR(32)
)
AS
BEGIN
	INSERT INTO @listPatient
	SELECT DISTINCT
			VP.patientID,
			VP.patientFirstName,
			VP.patientLastname
	FROM
		View_Patients as VP 
			INNER JOIN 
		UsingService as US
			ON (VP.patientID = US.patientID)
	WHERE 
		US.status = 1 AND CAST(US.createdAt as date) = CAST(getdate() as date)
	
	RETURN 
END
GO
--===============================

/*
	Functione 'func_getListMedicion_withExamID'
	Lấy danh sách các thuốc trong đơn khám 
	
	tham số truyền vào : VARCHAR(20) : ID đơn khám
	trả về : danh sách các đơn thuốc, danh sách thuốc
	lấy cả tên thuốc, tên bệnh nhân và giá tiền theo số lượng
*/
CREATE FUNCTION [dbo].[func_getListMedicion_withExamID]
(
	@examID VARCHAR(20)
)
RETURNS @a TABLE
(
	prescriptionID VARCHAR(20),
	examinateID VARCHAR(20),
	patientID VARCHAR(20),
	employeeID VARCHAR(20),
	medicineID VARCHAR(20),
	medicineName NVARCHAR(255),
	quanlity INT,
	medicinePrice INT,
	totalPrice INT,
	createdAt DATE,
	status tinyint
)
AS
BEGIN
	INSERT INTO @a
	SELECT *
	FROM View_ListMedicine_Precesciption
	WHERE (examinateID = @examID)
	RETURN 
END
GO
--===========================================


/*
	FUNCTION 'func_getTotalPay_ListMedicine_withExamID'
	Lấy tổng giá tiền của đơn thuốc trong đơn khám
	
	Tham số truyền vào : VARCHAR(20) : ID đơn khám
	trả về : integer
*/

CREATE FUNCTION [dbo].[func_getTotalPay_ListMedicine_withExamID]
(
	@examID VARCHAR(20)
)
RETURNS INT
AS
BEGIN
	DECLARE @totayPay INT
	SELECT @totayPay = SUM(totalPrice)
	FROM [dbo].[func_getListMedicion_withExamID](@examID) AS fGLM
	
	RETURN @totayPay
END
GO
--=================================================



/*
	FUNCTION 'func_getPrecription_notYet'
	Lấy danh sách các đơn thuốc của bệnh nhân chưa thanh toán
	
	tham số truyền vào : id bệnh nhân : VARCHAR(20)
*/
CREATE FUNCTION [dbo].[func_getPrecription_notYet]
(
	@patientID VARCHAR(20)
)
RETURNS @a TABLE
(
	examinateID VARCHAR(20),
	HoBacSi NVARCHAR(32),
	TenBacSi NVARCHAR(32),
	createdAt DATE
)
AS
BEGIN
	INSERT INTO @a
	SELECT DISTINCT
		VE.examinateID,
		VE.hoBacSi,
		VE.tenBacSi,
		VE.createdAt
	FROM 
		View_ListMedicine_Precesciption as VLP
			INNER JOIN
		View_Examination as VE
			ON (VLP.examinateID = VE.examinateID)
	WHERE 
			(VE.patientID = @patientID)
		AND
			(VLP.status = 2)
	RETURN 
END
GO
--=================================================

--Begin: PROCEDURE InsertPatient
CREATE PROCEDURE InsertPatient (@patientFirstName nvarchar(32),
								@patientLastname nvarchar(32),
								@sex char(1),
								@birthDay DATE,
								@address nvarchar(510),
								@phone varchar(15),
								@cardID varchar(15),
								@patientJob nvarchar(255),
								@healthInsurance varchar(20),
								@reason nvarchar(500))
AS
BEGIN
	BEGIN TRANSACTION Tran_InsertPatient
	BEGIN TRY
		DECLARE @role TINYINT
        SET @role = 1

		INSERT INTO dbo.People (firstName, lastName, sex, birthDay, address, phone, cardID, role)
		VALUES (@patientFirstName, @patientLastname, @sex, @birthDay, @address, @phone, @cardID, @role)

		DECLARE @patientID VARCHAR(20)
		SELECT @patientID = MAX(peopleID) FROM dbo.People WHERE role = @role
		
		UPDATE dbo.Patients SET patientJob = @patientJob, healthInsurance = @healthInsurance, reason = @reason 
		WHERE patientID = @patientID

		COMMIT TRANSACTION Tran_InsertPatient
    END TRY
	BEGIN CATCH
		PRINT('Thêm không thành công!')
		COMMIT TRANSACTION Tran_InsertPatient
	END CATCH
END
GO
--End: PROCEDURE InsertPatient

--Begin: PROCEDURE UpdatePatient
CREATE PROCEDURE UpdatePatient (@patientFirstName nvarchar(32),
								@patientLastname nvarchar(32),
								@sex char(1),
								@birthDay DATE,
								@address nvarchar(510),
								@phone varchar(15),
								@cardID varchar(15),
								@patientJob nvarchar(255),
								@healthInsurance varchar(20),
								@reason nvarchar(500),
								@peopleID VARCHAR(20))
AS
BEGIN
	BEGIN TRANSACTION Tran_UpdatePatient
	BEGIN TRY
		UPDATE dbo.People SET firstName = @patientFirstName,
								lastName = @patientLastname,
								sex = @sex,
								birthDay = @birthDay,
								address = @address,
								phone = @phone,
								cardID = @cardID
		WHERE peopleID = @peopleID

		UPDATE dbo.Patients SET patientJob = @patientJob,
								healthInsurance = @healthInsurance,
								reason = @reason
		WHERE patientID = @peopleID

		COMMIT TRANSACTION Tran_UpdatePatient
	END TRY
	BEGIN CATCH
		PRINT('Cập nhật không thành công')
		ROLLBACK TRANSACTION Tran_UpdatePatient
	END CATCH
END
GO
--End: PROCEDURE UpdatePatient

--Begin: PROCEDURE FindAllPatientWait
CREATE PROCEDURE FindAllPatientWait
AS
BEGIN
SELECT * FROM View_Patients_Wait
END
GO
--END: PROCEDURE FindAllPatientWait

--Begin: PROCEDURE InsertRelative
CREATE PROCEDURE InsertRelative (@relativeFirstName nvarchar(32),
								@relativeLastname nvarchar(32),
								@sex char(1),
								@birthDay DATE,
								@address nvarchar(510),
								@phone varchar(15),
								@cardID varchar(15),
								@patientID VARCHAR(20))
AS
BEGIN
	BEGIN TRANSACTION Tran_InsertRelative
	BEGIN TRY
		DECLARE @role TINYINT
        SET @role = 0
		INSERT INTO dbo.People (firstName, lastName, sex, birthDay, address, phone, cardID, role)
		VALUES (@relativeFirstName, @relativeLastname, @sex, @birthDay, @address, @phone, @cardID, @role)


		DECLARE @relativeID VARCHAR(20)
		SELECT @relativeID = MAX(peopleID) FROM dbo.People WHERE role = @role

		INSERT INTO dbo.Relatives (relativeID, patientID)
		VALUES(@relativeID, @patientID)

		COMMIT TRANSACTION Tran_InsertRelative
	END TRY
    BEGIN CATCH
		PRINT('Thêm không thành công')
		ROLLBACK TRANSACTION Tran_InsertRelative
	END CATCH
END
GO
--End: PROCEDURE InsertRelative

--Begin: PROCEDURE UpdateRelative
CREATE PROCEDURE UpdateRelative (@relativeFirstName nvarchar(32),
								@relativeLastname nvarchar(32),
								@sex char(1),
								@birthDay DATE,
								@address nvarchar(510),
								@phone varchar(15),
								@cardID varchar(15),
								@patientID VARCHAR(20),
								@relativeID VARCHAR(20))
AS
BEGIN
	BEGIN TRANSACTION Tran_UpdateRelative
	BEGIN TRY
		UPDATE dbo.People SET firstName = @relativeFirstName,
								lastName = @relativeLastname,
								sex = @sex,
								birthDay = @birthDay,
								address = @address,
								phone = @phone,
								cardID = @cardID
		WHERE peopleID = @relativeID

		UPDATE dbo.Relatives SET patientID = @patientID WHERE relativeID = @relativeID

		COMMIT TRANSACTION Tran_UpdateRelative
	END TRY
    BEGIN CATCH
		ROLLBACK TRANSACTION Tran_UpdateRelative
	END CATCH
END
GO
--End: PROCEDURE UpdateRelative


--Begin: PROCEDURE InsertDoctor
CREATE PROCEDURE InsertDoctor (@employeeFirstName nvarchar(32),
								@employeeLastname nvarchar(32),
								@sex char(1),
								@birthDay DATE,
								@address nvarchar(510),
								@phone varchar(15),
								@cardID varchar(15),
								@departmentID VARCHAR(25))
AS
BEGIN
	BEGIN TRANSACTION Tran_InsertDoctor
	BEGIN TRY
		DECLARE @role TINYINT

        SET @role = 2
		INSERT INTO dbo.People (firstName, lastName, sex, birthDay, address, phone, cardID, role)
		VALUES (@employeeFirstName, @employeeLastname, @sex, @birthDay, @address, @phone, @cardID, @role)

		DECLARE @employeeID VARCHAR(20)
		SELECT @employeeID = MAX(peopleID) FROM dbo.People WHERE role = @role

		DECLARE @position NVARCHAR(25)
		SET @position = N'Bác sĩ'

		UPDATE dbo.Employees SET position = @position, departmentID = @departmentID WHERE employeeID = @employeeID

		COMMIT TRANSACTION Tran_InsertDoctor
	END TRY
	BEGIN CATCH
		PRINT('Thêm không thành công')
		ROLLBACK TRANSACTION Tran_InsertDoctor
	END CATCH
END
GO
--End: PROCEDURE InsertDoctor

--Begin: PROCEDURE InsertStaff
CREATE PROCEDURE InsertStaff (@employeeFirstName nvarchar(32),
								@employeeLastname nvarchar(32),
								@sex char(1),
								@birthDay DATE,
								@address nvarchar(510),
								@phone varchar(15),
								@cardID varchar(15),
								@departmentID VARCHAR(25))
AS
BEGIN
	BEGIN TRANSACTION Tran_InsertStaff
	BEGIN TRY
		DECLARE @role TINYINT

        SET @role = 2
		INSERT INTO dbo.People (firstName, lastName, sex, birthDay, address, phone, cardID, role)
		VALUES (@employeeFirstName, @employeeLastname, @sex, @birthDay, @address, @phone, @cardID, @role)

		DECLARE @employeeID VARCHAR(20)
		SELECT @employeeID = MAX(peopleID) FROM dbo.People WHERE role = @role

		DECLARE @position NVARCHAR(25)
		SET @position = N'Nhân viên'

		UPDATE dbo.Employees SET position = @position, departmentID = @departmentID WHERE employeeID = @employeeID

		COMMIT TRANSACTION Tran_InsertDoctor
	END TRY
	BEGIN CATCH
		PRINT('Thêm không thành công')
		ROLLBACK TRANSACTION Tran_InsertStaff
	END CATCH
END
GO
--End: PROCEDURE InsertStaff

--Begin: PROCEDURE UpdateDoctor_Staff
CREATE PROCEDURE UpdateDoctor_Staff (@employeeFirstName nvarchar(32),
								@employeeLastname nvarchar(32),
								@sex char(1),
								@birthDay DATE,
								@address nvarchar(510),
								@phone varchar(15),
								@cardID varchar(15),
								@departmentID VARCHAR(25),
								@peopleID VARCHAR(20))
AS
BEGIN
	BEGIN TRANSACTION Tran_UpdateDoctor_Staff
	BEGIN TRY
		UPDATE dbo.People SET firstName = @employeeFirstName,
								lastName = @employeeLastname,
								sex = @sex,
								birthDay = @birthDay,
								address = @address,
								phone = @phone,
								cardID = @cardID
		WHERE peopleID = @peopleID

		UPDATE dbo.Employees SET departmentID = @departmentID WHERE employeeID = @peopleID

		COMMIT TRANSACTION Tran_UpdateDoctor_Staff
	END TRY
	BEGIN CATCH
		PRINT('Thêm không thành công')
		ROLLBACK TRANSACTION Tran_UpdateDoctor_Staff
	END CATCH
END
GO
--End: PROCEDURE UpdateDoctor_Staff

--Begin: PROCEDURE FindAllDoctor
CREATE PROCEDURE FindAllDoctor
AS
BEGIN
SELECT * FROM View_Doctor
END
GO
--END: PROCEDURE FindAllDoctor

--Begin: PROCEDURE FindAllStaff
CREATE PROCEDURE FindAllStaff
AS
BEGIN
SELECT * FROM View_Staff
END
GO
--END: PROCEDURE FindAllStaff

--Begin: PROCEDURE FindDepartmentNameByDoctorId
CREATE PROCEDURE FindDepartmentNameByDoctorId(@doctorID NVARCHAR(25))
AS
BEGIN
SELECT departmentName FROM View_Doctor WHERE doctorID = @doctorID;
END
GO
--End: PROCEDURE FindDepartmentNameByDoctorId

CREATE PROCEDURE FindFullNameDoctorByDoctorId(@doctorID NVARCHAR(25))
AS
BEGIN
SELECT dbo.func_FullName(@doctorID);
END
GO

CREATE PROCEDURE spCountPatientsWait
AS
BEGIN
SELECT COUNT(*) FROM View_Patients_Wait;
END
GO

-- CREATE PROCEDURE spExaminateIDNext
-- AS
-- BEGIN
-- SELECT dbo.func_Auto_examinateID();
-- END
-- GO

CREATE PROCEDURE spUpdateExamination(@patientID VARCHAR(20),
										@employeeID VARCHAR(20),
										@height FLOAT,
										@weight FLOAT,
										@temperature FLOAT,
										@breathing INT,
										@symptom NVARCHAR(510),
										@veins INT,
										@bloodPressure INT,
										@preliminaryDiagnosis NVARCHAR(510),
										@finalDiagnosis NVARCHAR(510),
										@treatmentDirection NVARCHAR(510),
										@examinateID VARCHAR(20))
AS
BEGIN
	BEGIN TRANSACTION Tran_UpdateExamination
	BEGIN TRY
		UPDATE dbo.Examination SET patientID = @patientID, employeeID = @employeeID, height = @height, 
		weight = @weight, temperature = @temperature, breathing = @breathing, symptom = @symptom, veins = @veins, bloodPressure = @bloodPressure, 
		preliminaryDiagnosis = @preliminaryDiagnosis, finalDiagnosis = @finalDiagnosis, treatmentDirection = treatmentDirection WHERE examinateID = @examinateID

		INSERT INTO dbo.Prescriptions (descriptionPrescription) VALUES (NULL)

		DECLARE @prescriptionID VARCHAR(20)
		SET @prescriptionID = dbo.func_GetPrescriptionID_New()

		INSERT INTO dbo.CreatedPrescription (patientID, employeeID, prescriptionID, examinateID)
		VALUES (@patientID,  @employeeID, @prescriptionID, @examinateID)

		COMMIT TRANSACTION Tran_UpdateExamination
	END TRY
	BEGIN CATCH
		PRINT('Thêm không thành công')
		-- SELECT @ErrorNumber = ERROR_NUMBER()
		-- SELECT ERROR_NUMBER() AS ErrorNumber,
		-- ERROR_MESSAGE() AS ErrorMessage;
		ROLLBACK TRANSACTION Tran_UpdateExamination
	END CATCH
END
GO

-- CREATE PROCEDURE spInsertPrescription_Null(@patientID VARCHAR(20), @employeeID  VARCHAR(20))
-- AS
-- BEGIN
-- 	BEGIN TRANSACTION Tran_InsertPrescriptionNull
-- 	BEGIN TRY
-- 		INSERT INTO dbo.Prescriptions (descriptionPrescription) VALUES (NULL)

-- 		DECLARE @prescriptionID VARCHAR(20)
-- 		SET @prescriptionID = dbo.func_GetPrescriptionID_New()

-- 		INSERT INTO dbo.CreatedPrescription (patientID, employeeID, prescriptionID)
-- 		VALUES (@patientID,  @employeeID, @prescriptionID)

-- 		COMMIT TRANSACTION Tran_InsertPrescriptionNull
-- 	END TRY
-- 	BEGIN CATCH
-- 		PRINT('Thêm không thành công')
-- 		-- SELECT @ErrorNumber = ERROR_NUMBER()
-- 		-- SELECT ERROR_NUMBER() AS ErrorNumber,
-- 		-- ERROR_MESSAGE() AS ErrorMessage;
-- 		ROLLBACK TRANSACTION Tran_InsertPrescriptionNull
-- 	END CATCH
-- END
-- GO

CREATE PROCEDURE spFindAllMedicineGroup
AS
BEGIN
SELECT medicineGroupID, medicineGroupName, createdAt, updatedAt FROM dbo.[View_MedicineGroup_ConvertID] ORDER BY ConvertID ASC;
END
GO

CREATE PROCEDURE spInsertMedicineGroup(@medicineGroupName NVARCHAR(255))
AS
BEGIN
INSERT INTO dbo.MedicineGroups(medicineGroupName) VALUES (@medicineGroupName);
END
GO

CREATE PROCEDURE spUpdateMedicineGroup(@medicineGroupID VARCHAR(20), @medicineGroupName NVARCHAR(255))
AS
BEGIN
UPDATE dbo.MedicineGroups SET medicineGroupName = @medicineGroupName WHERE medicineGroupID = @medicineGroupID;
END
GO

CREATE PROCEDURE spDeleteMedicineGroup(@medicineGroupID VARCHAR(20))
AS
BEGIN
DELETE dbo.MedicineGroups WHERE medicineGroupID = @medicineGroupID;
END
GO

CREATE PROCEDURE spInsertMedicine(@medicineName NVARCHAR(255),
									@unit NVARCHAR(255),
									@medicinePrice INT,
									@expiry INT,
									@count INT,
									@shape NVARCHAR(100),
									@medicineGroupName NVARCHAR(255))
AS
BEGIN
	INSERT INTO dbo.Medicines(medicineName, unit, medicinePrice, expiry, count, shape, medicineGroupName)
	VALUES (@medicineName, @unit, @medicinePrice, @expiry, @count, @shape, @medicineGroupName)
END
GO


CREATE PROCEDURE spFindMedicineBymedicineNameLike (@medicineName NVARCHAR(255))
AS
BEGIN
	SELECT medicineID, medicineName, unit, medicinePrice, expiry, count, shape, medicineGroupName, createdAt, updatedAt FROM dbo.[View_Medicine_ConvertID] WHERE medicineName LIKE '%' + @medicineName + '%' AND [status] = 1 ORDER BY ConvertID ASC;
END
GO

CREATE PROCEDURE spUpdateMedicine(@medicineName NVARCHAR(255),
									@unit NVARCHAR(255),
									@medicinePrice INT,
									@expiry INT,
									@count INT,
									@shape NVARCHAR(100),
									@medicineGroupName NVARCHAR(255),
									@medicineID VARCHAR(20))
AS
BEGIN
	UPDATE dbo.Medicines SET medicineName =  @medicineID, unit = @unit, medicinePrice = @medicinePrice, expiry = @expiry, count = @count, shape = @shape, medicineGroupName = @medicineGroupName
	WHERE medicineID = @medicineID;
END
GO

CREATE PROCEDURE spDeleteMedicine1(@medicineID VARCHAR(20))
AS
BEGIN

	UPDATE Medicines SET [status] = 0 WHERE medicineID = @medicineID;
END
GO

CREATE PROCEDURE spFindAllMedicine1
AS
BEGIN
	SELECT medicineID, medicineName, unit, medicinePrice, expiry, count, shape, medicineGroupName, createdAt, updatedAt FROM dbo.[View_Medicine_ConvertID] WHERE [status] = 1 ORDER BY ConvertID ASC;
END
GO

CREATE PROCEDURE spFindAllMedicine0
AS
BEGIN
	SELECT medicineID, medicineName, unit, medicinePrice, expiry, count, shape, medicineGroupName, createdAt, updatedAt FROM dbo.[View_Medicine_ConvertID] WHERE [status] = 0 ORDER BY ConvertID ASC;
END
GO

CREATE PROCEDURE spRestoreMedicine(@medicineID VARCHAR(20))
AS
BEGIN
	UPDATE Medicines SET [status] = 1 WHERE medicineID = @medicineID;
END
GO

CREATE PROCEDURE spFindAllMedicine1ByMedicineName(@medicineName NVARCHAR(255))
AS
BEGIN
	SELECT medicineID, medicineName, unit, medicinePrice, expiry, count, shape, medicineGroupName, createdAt, updatedAt FROM dbo.[View_Medicine_ConvertID] WHERE [status] = 1 AND medicineName = @medicineName ORDER BY ConvertID ASC;
END
GO

CREATE PROCEDURE spUpdatePrescription(@prescriptionID VARCHAR(20), @descriptionPrescription NVARCHAR(500))
AS
BEGIN
	UPDATE dbo.Prescriptions SET descriptionPrescription = @descriptionPrescription WHERE prescriptionID = @prescriptionID
END
GO


CREATE PROCEDURE spInsertPrescription_Medicine(@prescriptionID VARCHAR(20), @medicineName NVARCHAR(255), @quanlity INT)
AS
BEGIN
INSERT INTO dbo.Prescription_Medicine (prescriptionID, medicineName, quanlity)
VALUES (@prescriptionID, @medicineName, @quanlity)
END
GO

CREATE PROCEDURE spFindAllPrescription_Medicine(@prescriptionID VARCHAR(20))
AS
BEGIN
SELECT * FROM [View_CreatedPrescription_New] WHERE prescriptionID = @prescriptionID
END
GO

CREATE PROCEDURE spUpdatePrescription_Medicine(@prescriptionID VARCHAR(20), @medicineName NVARCHAR(255), @quanlity INT)
AS
BEGIN
UPDATE dbo.Prescription_Medicine SET quanlity = @quanlity WHERE prescriptionID = @prescriptionID AND medicineName = @medicineName
END
GO

CREATE PROCEDURE spDeletePrescription_Medicine(@prescriptionID VARCHAR(20), @medicineName NVARCHAR(255))
AS
BEGIN
	BEGIN TRANSACTION Tran_DeletePrescription_Medicine
	BEGIN TRY
		DECLARE @quanlity INT
		SELECT @quanlity = quanlity FROM dbo.Prescription_Medicine WHERE medicineName = @medicineName AND prescriptionID = @prescriptionID

		DECLARE @count INT
		SELECT @count = count FROM dbo.Medicines WHERE medicineName = @medicineName
		SET @count = @count + @quanlity
		UPDATE dbo.Medicines SET [count] = @count WHERE medicineName = @medicineName

		DELETE dbo.Prescription_Medicine WHERE prescriptionID = @prescriptionID AND medicineName = @medicineName

		COMMIT TRANSACTION Tran_DeletePrescription_Medicine
	END TRY
	BEGIN CATCH
		PRINT('Xóa không thành công')
		-- SELECT @ErrorNumber = ERROR_NUMBER()
		-- SELECT ERROR_NUMBER() AS ErrorNumber,
		-- ERROR_MESSAGE() AS ErrorMessage;
		ROLLBACK TRANSACTION Tran_DeletePrescription_Medicine
	END CATCH
END
GO



--============================= procedure 'proc_createNewNullExamination'
CREATE PROCEDURE [dbo].[proc_createNewNullExamination]
(
	@patientID VARCHAR(20),
	@employeeID VARCHAR(20)
)
AS
BEGIN
	-- khởi tạo đơn khám null tất cả các thuộc tính, 
	-- chỉ có ID bệnh nhân và ngày tạo
	-- ID nhân viên ở đây lấy mặc định là 
	-- của nhân viên lễ tân đăng nhập và tạo Exam
	INSERT INTO Examination
				(patientID, employeeID, status)
	VALUES
				(@patientID, @employeeID, 1)
END
GO
--==================================




--================================== procedure 'proc_InsertUsingService'
/*
	procedure tạo 1 using service 
	với đầu vào là 
		ID bệnh nhân, 
		ID dịch vụ chọn sử dụng
		và số lượng dịch vụ đó
	với status bằng 1 có nghĩa là usingService đó chưa bị xóa và chưa được thanh toán
	
*/
CREATE PROCEDURE [dbo].[proc_InsertUsingService]
(
	@patientID VARCHAR(20),
	@serviceID VARCHAR(20),
	@quantity tinyint
)
AS
BEGIN
	INSERT INTO UsingService 
			(patientID, serviceID, quantity, status)
	VALUES 
			(@patientID, @serviceID, @quantity, 1)
END
GO
--==================================



--================================== procedure 'proc_UpdateUsingService'
/*
	PROCEDURE cập nhật thông tin của usingService với ID là usingServiceID truyền vào
	được cập nhật mới các thông tin như 
			id bệnh nhân sử dụng
			id dịch vụ sử dụng
			và số lượng của dịch vụ được chọn
*/
CREATE PROCEDURE [dbo].[proc_UpdateUsingService]
(
	@usingServiceID VARCHAR(20),
	@patientID VARCHAR(20),
	@serviceID VARCHAR(20),
	@quantity tinyint
)
AS
BEGIN
	UPDATE UsingService
	SET
		patientID = @patientID,
		serviceID = @serviceID,
		quantity = @quantity
	WHERE
		usingServiceID = @usingServiceID
END
GO
--==================================


CREATE PROCEDURE [dbo].[InsertRelative_Exist] (@patientID VARCHAR(20), @relativeID VARCHAR(20))
AS
BEGIN
	INSERT INTO [dbo].[Relatives]
						 ([relativeID],[patientID])
			 VALUES
							(@relativeID, @patientID)
END
GO

CREATE PROCEDURE spWaitDrugSupply
AS
BEGIN
	SELECT * FROM dbo.[View_Wait_DrugSupply]
END
GO


CREATE PROCEDURE spFindAllDepartment1
AS
BEGIN
	SELECT departmentID, departmentName, createdAt, updatedAt FROM [View_Department_ConvertID] ORDER BY ConvertID ASC;
END
GO

CREATE PROCEDURE spFindAllDepartment1BydepartmentNameLike (@departmentName NVARCHAR(255))
AS
BEGIN
	SELECT departmentID, departmentName, createdAt, updatedAt FROM [View_Department_ConvertID] WHERE departmentName LIKE '%' + @departmentName + '%' ORDER BY ConvertID ASC;
END
GO


CREATE PROCEDURE spInsertDepartment(@departmentName NVARCHAR(255))
AS
BEGIN
	INSERT INTO dbo.Departments (departmentName) VALUES (@departmentName)
END
GO

CREATE PROCEDURE spUpdateDepartment(@departmentName NVARCHAR(255), @departmentID VARCHAR(20))
AS
BEGIN
	UPDATE dbo.Departments SET departmentName = @departmentName WHERE departmentID = @departmentID
END
GO

CREATE PROCEDURE spDeleteDepartment(@departmentID VARCHAR(20))
AS
BEGIN
	DELETE dbo.Departments WHERE departmentID = @departmentID
END
GO



-- ====================================== PROCEDURE 'proc_Pay_service'
--================= Thanh toán dịch vụ đã sử dụng
/*
	Tạo hóa đơn Pay và Receipt
	Chuyển trạng thái status của các UsingService mà người dùng sử dụng, 
				chưa thanh toán thành 3  (đã thanh toán)
*/
--================= 
/*
	tham số đầu vào: 
		id bệnh nhân : VARCHAR(20)
		id nhân viên thanh toán : VARCHAR(20)
*/
CREATE PROCEDURE [dbo].[proc_Pay_service]
(
	@patientID VARCHAR(20),
	@employeeID VARCHAR(20)
)
AS
BEGIN
	--========== Tạo Receipts mới
	EXEC proc_InsertReceipt 'Service', @patientID, @employeeID
	
	DECLARE @receiptID VARCHAR(20)
	SELECT @receiptID = MAX(receiptID) FROM Receipts
	
	--=========== Tạo Pay mới
	DECLARE @totayPay INT
	SELECT @totayPay = [dbo].[func_getTotalPay_usingService](@patientID)
	
	EXEC proc_InsertPay @patientID, @employeeID, @receiptID, @totayPay
	
	--======== Cập nhật status của các UsingService của bệnh nhân 
	---- mà chưa thanh toán thành 3
	DECLARE @usingServiceID INT,
					@Count_US INT
	
	SELECT @Count_US = COUNT(usingServiceID)
	FROM [dbo].[func_getListService_notYet](@patientID)
	
	WHILE @Count_US > 0
	BEGIN
		
		SELECT @usingServiceID = MIN(usingServiceID) FROM [dbo].[func_getListService_notYet](@patientID)
		
		UPDATE UsingService 
		SET status = 3
		WHERE	usingServiceID = @usingServiceID
		
		SELECT @Count_US = COUNT(usingServiceID) FROM [dbo].[func_getListService_notYet](@patientID)
		
	END
END
GO
--====================================================



--=============================== PROCEDURE 'proc_InsertReceipt'
/*
	Tạo hóa đơn với tên tạo từ loại hóa đơn và id bệnh nhân
*/
CREATE PROCEDURE [dbo].[proc_InsertReceipt]
(
	@type VARCHAR(50),
	@patientID VARCHAR(20),
	@employeeID VARCHAR(20)
)
AS
BEGIN
	INSERT INTO Receipts (receiptName, status)
	VALUES (@type + '_' + @patientID + '_' + @employeeID, 1)
END
GO
--====================================================


--====================== PROCEDURE 'proc_InsertPay'
/*
	Nhập pay mới
*/
CREATE PROCEDURE [dbo].[proc_InsertPay]
(
	@patientID VARCHAR(20),
	@employeeID VARCHAR(20),
	@receiptID VARCHAR(20),
	@payTotal INT
)
AS
BEGIN
	INSERT INTO Pay
		(patientID, employeeID, receiptID, payTotal, status)
	VALUES
		(@patientID, @employeeID, @receiptID, @payTotal, 1)
END
GO
--====================================================


-- ====================================== PROCEDURE 'proc_Pay_Medicine'
--================= Thanh toán đơn khám 
/*
	Tạo hóa đơn Pay và Receipt
	Chuyển trạng thái status của các Prescriptions của bệnh nhân, 
				chưa thanh toán thành 3 (đã thanh toán)
*/
--================= 
/*
	tham số đầu vào: 
		id bệnh nhân : VARCHAR(20)
		id nhân viên thanh toán : VARCHAR(20)
		id đơn khám
*/
CREATE PROCEDURE [dbo].[proc_Pay_Medicine]
(
	@patientID VARCHAR(20),
	@employeeID VARCHAR(20),
	@examinationID VARCHAR(20)
)
AS
BEGIN
	--========== Tạo Receipts mới
	EXEC proc_InsertReceipt 'Medicine', @patientID, @employeeID
	
	DECLARE @receiptID VARCHAR(20)
	SELECT @receiptID = MAX(receiptID) FROM Receipts
	
	--=========== Tạo Pay mới
	DECLARE @totayPay INT
	SELECT @totayPay = [dbo].[func_getTotalPay_ListMedicine_withExamID](@examinationID)
	
	EXEC proc_InsertPay @patientID, @employeeID, @receiptID, @totayPay
	
	--======== Cập nhật status của các Prescriptions 
	---- mà chưa thanh toán thành 3 (đã thanh toán)
	DECLARE @prescriptionID VARCHAR(20)
	
	SELECT @prescriptionID = MIN(prescriptionID) 
	FROM [dbo].[func_getListMedicion_withExamID](@examinationID)
	
	UPDATE Prescriptions 
	SET
		status = 3
	WHERE
		prescriptionID = @prescriptionID

END
GO
--=================================================================

CREATE PROCEDURE spFindAllService
AS
BEGIN
	SELECT serviceID, serviceName, servicePrice, createdAt, updatedAt FROM dbo.[View_Service_ConvertID] ORDER BY ConvertID ASC
END
GO

CREATE PROCEDURE spFindAllServiceByServiceNameLike (@serviceName NVARCHAR(255))
AS
BEGIN
	SELECT serviceID, serviceName, servicePrice, createdAt, updatedAt FROM dbo.[View_Service_ConvertID] WHERE serviceName LIKE '%' + @serviceName + '%' ORDER BY ConvertID ASC
END
GO

CREATE PROCEDURE spInsertService(@serviceName NVARCHAR(255), @servicePrice INT)
AS
BEGIN
	INSERT INTO dbo.Services (serviceName, servicePrice)  VALUES (@serviceName, @servicePrice)
END
GO

CREATE PROCEDURE spUpdateService(@serviceName NVARCHAR(255), @servicePrice INT, @serviceID VARCHAR(20))
AS
BEGIN
	UPDATE dbo.Services SET serviceName = @serviceName, servicePrice =  @servicePrice WHERE serviceID = @serviceID
END
GO

CREATE PROCEDURE spDeleteService(@serviceID VARCHAR(20))
AS
BEGIN
	DELETE dbo.Services WHERE serviceID = @serviceID
END
GO

------------------TẠO ROLE-----------------------
create role admin
create role doctor
create role employee


------------------ADMIN CÓ TOÀN BỘ QUYỀN TRÊN TẤT CẢ CÁC BẢNG--------------------------------
GRANT ALTER, VIEW DEFINITION, EXECUTE TO admin

------------------PHÂN QUYỀN MỨC VIEW CHO DOCTOR---------------------------------------
GRANT SELECT on dbo.Accounts to doctor 
GRANT SELECT on dbo.Departments to doctor 
GRANT SELECT on dbo.Employees to doctor 
GRANT SELECT, UPDATE, INSERT, DELETE on dbo.Examination to doctor 
GRANT SELECT on dbo.MedicineGroups to doctor 
GRANT SELECT on dbo.Medicines to doctor 
GRANT SELECT, UPDATE, INSERT, DELETE on dbo.Patients to doctor 
GRANT SELECT on dbo.Pay to doctor 
GRANT SELECT on dbo.Prescription_Medicine to doctor 
GRANT SELECT on dbo.Prescriptions to doctor 
GRANT SELECT on dbo.Receipts to doctor 
GRANT SELECT on dbo.Relatives to doctor 
GRANT SELECT on dbo.Roles to doctor 
GRANT SELECT on dbo.Services to doctor 
GRANT SELECT on dbo.UsingService to doctor

------------------PHÂN QUYỀN MỨC VIEW CHO EMPLOYEE---------------------------------------
GRANT SELECT on dbo.Accounts to employee 
GRANT SELECT on dbo.Departments to employee 
GRANT SELECT on dbo.Employees to employee 
GRANT SELECT on dbo.Examination to employee 
GRANT SELECT, UPDATE, INSERT, DELETE on dbo.MedicineGroups to employee 
GRANT SELECT, UPDATE, INSERT, DELETE on dbo.Medicines to employee 
GRANT SELECT, UPDATE, INSERT, DELETE on dbo.Patients to employee 
GRANT SELECT, UPDATE, INSERT, DELETE on dbo.Pay to employee 
GRANT SELECT, UPDATE, INSERT, DELETE on dbo.Prescription_Medicine to employee 
GRANT SELECT on dbo.Prescriptions to employee 
GRANT SELECT, UPDATE, INSERT, DELETE on dbo.Receipts to employee 
GRANT SELECT, UPDATE, INSERT, DELETE on dbo.Relatives to employee 
GRANT SELECT on dbo.Roles to employee 
GRANT SELECT on dbo.Services to employee 
GRANT SELECT, UPDATE, INSERT, DELETE on dbo.UsingService to employee
GO


------------------PROCEDURE THÊM ACCOUNT (VÀO SQL SERVER)-----------
create procedure addAccountServer2 @username varchar(20), @pass varchar(100), @roleid int
as begin 
	declare @login nvarchar(4000)
	set @login = N'CREATE LOGIN ' + QUOTENAME(@username) + ' WITH PASSWORD = ' + QUOTENAME(@pass, '''') + ', default_database = ' + QUOTENAME('QLHSBA')
	exec(@login)
	declare @user nvarchar(4000)
	set @user = N'CREATE USER ' + QUOTENAME(@username) + ' FOR LOGIN ' + QUOTENAME(@username)
	exec(@user)
	begin
		if(@roleid = 1) --admin
			begin
				exec sp_addrolemember 'admin', @username
			end
		if(@roleid = 2) --doctor
			begin
				exec sp_addrolemember 'doctor', @username
			end
		if(@roleid = 3) --doctor
			begin
				exec sp_addrolemember 'employee', @username
			end
	end
end
go

----------------------UPDATE----------------------------

------------------PROCEDURE XÓA ACCOUNT (VÀO SQL SERVER)-----------
create procedure DeleleAccountServer @username varchar(30)
as begin 
	declare @user nvarchar(4000)
	set @user = N'DROP USER' + QUOTENAME(@username) + ';'
	exec(@user)
	declare @login nvarchar(4000)
	set @login = N'DROP LOGIN ' + QUOTENAME(@username) + ';'
	exec(@login)
end
go

---------------------XÓA TK-----------------------------
create procedure deleteAccount @username nvarchar(20)
as
if exists (select Accounts.Username from Accounts where Username = @username)
begin
begin transaction
delete from Accounts where Accounts.Username = @username ;
exec DeleleAccountServer @username;
commit transaction
end
go

--------------PROCEDURE THÊM ACCOUNT----------------
create procedure InsertAccount2 @username varchar(20), @password varchar(100), @role int
as
begin
if not exists (select Username from Accounts where Username=@username)
	begin
	begin transaction
	if(@role=1)
	begin
		insert into Accounts values (@username, @password, 1);
		exec addAccountServer2 @username, @password, @role
	end
	if(@role=2)
		begin
			insert into Accounts values (@username, @password, 2);
			exec addAccountServer2 @username,@password, @role
		end
	if(@role=3)
		begin
			insert into Accounts values (@username, @password, 3);
			exec addAccountServer2 @username, @password, @role
		end
	commit transaction
	end
end
go

--------------------------------------------------------------


create procedure CheckLogin @username varchar(20), @password varchar(100)
as
begin
	SELECT Username, password FROM Accounts WHERE Username = @username and password = @password
end
go

CREATE VIEW View_Account
AS
SELECT * FROM Accounts
go

----------------------------doctor---------------------------------
-------------Phân quyền mức proc, view------------
--Phân quyền trên procedure
GRANT EXECUTE ON InsertStaff TO doctor 
GRANT EXECUTE ON InsertStaff TO doctor 
GRANT EXECUTE ON InsertStaff TO doctor 
--Phân quyền trên view
GRANT SELECT on View_Doctor to doctor 
GRANT ALTER, VIEW DEFINITION, SELECT on View_Patients_Wait to doctor 
GRANT ALTER, SELECT on View_Staff to doctor 

-------------Employ--------------------
--Phân quyền trên procedure
GRANT EXECUTE on InsertPatient to employee
GRANT EXECUTE on UpdatePatient to employee
GRANT EXECUTE on InsertRelative to employee
GRANT EXECUTE on UpdateRelative to employee
-- Trên view
GRANT SELECT on View_Staff to employee
GRANT ALTER, VIEW DEFINITION, SELECT on View_Patients_Wait to employee
GO
create procedure GetInforByAccountName @name nvarchar(20)
as begin
select * 
from ([dbo].[People] as [P]
    INNER JOIN [dbo].[Accounts] as [A]
        ON [P].[peopleID] = [A].[Username])
where Username = @name
end
go

create procedure GetRoleByAccountName @name nvarchar(20)
as begin
select RoleID 
from Accounts
where Username = @name
end
go


CREATE FUNCTION dbo.fnGetRoleByAccountName(@name varchar(20))
RETURNS INT
AS
BEGIN
	DECLARE @ID INT
	SELECT @ID = RoleID FROM Accounts WHERE @name = Username
	RETURN @ID
END
GO

---------------------------------------UPDATE
----------------------UPDATE----------------------------
create procedure updateAccount @username nvarchar(20), @pass varchar(100), @role int
as
if exists (select Accounts.Username from Accounts where Username = @username)
begin
begin transaction
update Accounts set Password = @pass, RoleID = @role from Accounts where Accounts.Username = @username ;
commit transaction
end
go

EXEC dbo.InsertPatient @patientFirstName = N'Tĩnh',  -- nvarchar(32)
                       @patientLastname = N'Bùi Quốc',   -- nvarchar(32)
                       @sex = 'F',                -- char(1)
                       @birthDay = '2002-10-10', -- date
                       @address = N'484 Lê Văn Việt',           -- nvarchar(510)
                       @phone = '0946541256',              -- varchar(15)
                       @cardID = '111111111',             -- varchar(15)
                       @patientJob = N'Học sinh',        -- nvarchar(255)
                       @healthInsurance = '111111111',   -- varchar(20)
                       @reason = N'Bị đau dạ dày'             -- nvarchar(500)

EXEC dbo.InsertPatient @patientFirstName = N'A',  -- nvarchar(32)
                       @patientLastname = N'Nguyễn Văn',   -- nvarchar(32)
                       @sex = 'F',                -- char(1)
                       @birthDay = '2002-10-11', -- date
                       @address = N'123 Hàm Minh',           -- nvarchar(510)
                       @phone = '0123456789',              -- varchar(15)
                       @cardID = '111111112',             -- varchar(15)
                       @patientJob = N'Sinh viên',        -- nvarchar(255)
                       @healthInsurance = '111111112',   -- varchar(20)
                       @reason = N'Sốt, ho khan'             -- nvarchar(500)

EXEC dbo.InsertPatient @patientFirstName = N'B',  -- nvarchar(32)
                       @patientLastname = N'Nguyễn Thị',   -- nvarchar(32)
                       @sex = 'M',                -- char(1)
                       @birthDay = '1999-10-02', -- date
                       @address = N'321 Nguyễn Bỉnh Khiêm',           -- nvarchar(510)
                       @phone = '0987654321',              -- varchar(15)
                       @cardID = '111111113',             -- varchar(15)
                       @patientJob = N'Kế toán',        -- nvarchar(255)
                       @healthInsurance = '111111113',   -- varchar(20)
                       @reason = Null             -- nvarchar(500)

EXECUTE dbo.InsertRelative @relativeFirstName = N'Một', -- nvarchar(32)
                           @relativeLastname = N'Lê văn',  -- nvarchar(32)
                           @sex = 'F',                -- char(1)
                           @birthDay = '1999-07-08', -- date
                           @address = N'194 Hàm Thuận Nam',           -- nvarchar(510)
                           @phone = '0334488221',              -- varchar(15)
                           @cardID = '222222222',             -- varchar(15)
                           @patientID = 'BN01'           -- varchar(20)

EXECUTE dbo.InsertRelative @relativeFirstName = N'Hai', -- nvarchar(32)
                           @relativeLastname = N'Lê văn',  -- nvarchar(32)
                           @sex = 'M',                -- char(1)
                           @birthDay = '1999-08-08', -- date
                           @address = N'146 Hàm Cường',           -- nvarchar(510)
                           @phone = '0334488222',              -- varchar(15)
                           @cardID = '222222223',             -- varchar(15)
                           @patientID = 'BN02'           -- varchar(20)

EXECUTE dbo.InsertRelative @relativeFirstName = N'Ba', -- nvarchar(32)
                           @relativeLastname = N'Lê văn',  -- nvarchar(32)
                           @sex = 'F',                -- char(1)
                           @birthDay = '2002-08-08', -- date
                           @address = N'147 Minh Tiến',           -- nvarchar(510)
                           @phone = '0334488332',              -- varchar(15)
                           @cardID = '222222333',             -- varchar(15)
                           @patientID = 'BN03'           -- varchar(20)

EXEC dbo.spInsertDepartment @departmentName = N'Khoa Nhi'
EXEC dbo.spInsertDepartment @departmentName = N'Khoa Truyền nhiễm'
EXEC dbo.spInsertDepartment @departmentName = N'Khoa Cấp cứu'
EXEC dbo.spInsertDepartment @departmentName = N'Khoa Hồi sức'
EXEC dbo.spInsertDepartment @departmentName = N'Test'

EXEC dbo.InsertDoctor @employeeFirstName = N'A', -- nvarchar(32)
                        @employeeLastname = N'Bùi Thái',  -- nvarchar(32)
                        @sex = 'F',                -- char(1)
                        @birthDay = '1980-02-02', -- date
                        @address = N'145 Hoàng Diệu',           -- nvarchar(510)
                        @phone = '0112233445',              -- varchar(15)
                        @cardID = '111111114',             -- varchar(15)
						@departmentID = 'Dep01'       -- varchar(25)

EXEC dbo.InsertDoctor @employeeFirstName = N'C', -- nvarchar(32)
                        @employeeLastname = N'Bùi Thị',  -- nvarchar(32)
                        @sex = 'M',                -- char(1)
                        @birthDay = '1981-01-01', -- date
                        @address = N'146 Dân Chủ',           -- nvarchar(510)
                        @phone = '0112233446',              -- varchar(15)
                        @cardID = '111111115',             -- varchar(15)
						@departmentID = 'Dep02'       -- varchar(25)

EXEC InsertDoctor @employeeFirstName = N'D', -- nvarchar(32)
                        @employeeLastname = N'Nguyễn Thị',  -- nvarchar(32)
                        @sex = 'M',                -- char(1)
                        @birthDay = '1983-06-01', -- date
                        @address = N'101 Võ Văn Ngân',           -- nvarchar(510)
                        @phone = '0112233447',              -- varchar(15)
                        @cardID = '111111116',             -- varchar(15)
						@departmentID = 'Dep03'       -- varchar(25)


EXEC dbo.InsertStaff @employeeFirstName = N'Một', -- nvarchar(32)
                        @employeeLastname = N'Đỗ Thị',  -- nvarchar(32)
                        @sex = 'M',                -- char(1)
                        @birthDay = '1983-06-06', -- date
                        @address = N'134 Đỗ Xuân Hợp',           -- nvarchar(510)
                        @phone = '0112233448',              -- varchar(15)
                        @cardID = '111111117',             -- varchar(15)
						@departmentID = 'Dep03'       -- varchar(25)

EXEC dbo.InsertStaff @employeeFirstName = N'Hai', -- nvarchar(32)
                        @employeeLastname = N'Đỗ Thị',  -- nvarchar(32)
                        @sex = 'M',                -- char(1)
                        @birthDay = '1984-07-07', -- date
                        @address = N'345 Đỗ Xuân Hợp',           -- nvarchar(510)
                        @phone = '0112233449',              -- varchar(15)
                        @cardID = '111111118',             -- varchar(15)
						@departmentID = 'Dep01'       -- varchar(25)

EXEC dbo.spInsertMedicineGroup @medicineGroupName = N'Thuốc trị đau dạ dày'
EXEC dbo.spInsertMedicineGroup @medicineGroupName = N'Thuốc trị ho'
EXEC dbo.spInsertMedicineGroup @medicineGroupName = N'Thuốc giảm đau'
EXEC dbo.spInsertMedicineGroup @medicineGroupName = N'Thuốc kháng sinh'

EXEC dbo.spInsertMedicine   @medicineName = N'MaaLox',
                            @unit = N'500mg/vien',
                            @medicinePrice = 60000,
                            @expiry = 30,
                            @count = 12,
                            @shape = N'Viên',
                            @medicineGroupName = N'Thuốc trị đau dạ dày'

EXEC dbo.spInsertMedicine   @medicineName = N'Eugica',
                            @unit = N'350mg/vien',
                            @medicinePrice = 70000,
                            @expiry = 60,
                            @count = 120,
                            @shape = N'Viên',
                            @medicineGroupName = N'Thuốc trị ho'

EXEC dbo.spInsertMedicine   @medicineName = N'Panadol',
                            @unit = N'220mg/vien',
                            @medicinePrice = 4000,
                            @expiry = 50,
                            @count = 125,
                            @shape = N'Viên',
                            @medicineGroupName = N'Thuốc giảm đau'

EXEC dbo.spInsertMedicine   @medicineName = N'Penicillin',
                            @unit = N'220mg/vien',
                            @medicinePrice = 4500,
                            @expiry = 70,
                            @count = 130,
                            @shape = N'Viên',
                            @medicineGroupName = N'Thuốc kháng sinh'

EXEC dbo.spInsertMedicine   @medicineName = N'Tetracyclin',
                            @unit = N'220mg/vien',
                            @medicinePrice = 4500,
                            @expiry = 50,
                            @count = 10,
                            @shape = N'Viên',
                            @medicineGroupName = N'Thuốc kháng sinh'

-------------------INSERT ROLE-----------------------------
insert into Roles values ('admin');
insert into Roles values ('doctor');
insert into Roles values ('employee');

------------------ TẠO TÀI KHOẢN-------------------------
insert into Accounts values ('BN01', 'admin0001', 1);
insert into Accounts values ('NV01', 'doctor001', 2);
go

EXEC dbo.InsertAccount2 @username = 'NV01',
					   @password = 'doctor001',
					   @role = 1

EXEC dbo.InsertAccount2 @username = 'NV02',
					   @password = 'doctor001',
					   @role = 2

EXEC dbo.InsertAccount2 @username = 'NV03',
					   @password = 'doctor001',
					   @role = 3



