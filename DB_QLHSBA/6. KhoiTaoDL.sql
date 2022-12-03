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


EXEC dbo.spInsertExamination    @patientID = 'BN03',
                                @employeeID = 'NV03',
                                @height = 1.58,
                                @weight = 48.5,
                                @temperature = 38,
                                @breathing = 80,
                                @symptom = N'Ho nhiều, đàm nhiều',
                                @veins = 70,
                                @bloodPressure = 100,
                                @preliminaryDiagnosis = N'Triệu chứng điển hình của viêm phế quản',
                                @finalDiagnosis = N'Viêm phế quản',
                                @treatmentDirection = N'Liệu pháp oxy'

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

EXEC dbo.InsertAccount2 @username = 'NV01',
					   @password = 'doctor001',
					   @role = 1
EXEC dbo.InsertAccount2 @username = 'NV02',
					   @password = 'doctor001',
					   @role = 2
EXEC dbo.InsertAccount2 @username = 'NV03',
					   @password = 'doctor001',
					   @role = 3

