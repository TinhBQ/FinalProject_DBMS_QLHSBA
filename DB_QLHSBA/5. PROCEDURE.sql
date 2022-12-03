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
