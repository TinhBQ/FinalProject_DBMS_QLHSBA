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




