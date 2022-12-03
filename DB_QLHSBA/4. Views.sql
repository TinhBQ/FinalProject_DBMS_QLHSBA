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
     , [D].[departmentID]
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


