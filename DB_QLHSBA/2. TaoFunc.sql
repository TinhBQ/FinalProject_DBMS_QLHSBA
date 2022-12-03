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

---- code của Phát
--=============================== FUNCTION 'func_getTotalPay_usingService'
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
--=================================================



