-- ================================================
-- Template generated from Template Explorer using:
-- Create Procedure (New Menu).SQL
--
-- Use the Specify Values for Template Parameters 
-- command (Ctrl-Shift-M) to fill in the parameter 
-- values below.
--
-- This block of comments will not be included in
-- the definition of the procedure.
-- ================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

----------------------------------------------------------------------------------------------------------
-------------------------------------------INSERT---------------------------------------------------------
----------------------------------------------------------------------------------------------------------
GO							

-- =============================================
-- Author:		Giang Nguyen
-- Create date: 27/07/2012
-- Description:	Procedure will create an id increase automatic when add new category
-- =============================================


----------------------------------------------------------------------------------------------------------
-------------------------------------------SEARCHING---------------------------------------------------------
----------------------------------------------------------------------------------------------------------
GO							

-- =============================================
-- Author:		Huy Huynh
-- Create date: 28/07/2012
-- Description:
-- =============================================

	-- ======================================--======================================--
--==========================================USER======================================== --
	-- ======================================--======================================--
CREATE PROC SP_SEARCH_USER
AS
BEGIN
	SELECT [USERID], [PASSWORD], A.[AUTHORITYID],AUTHORITY_NAME
	FROM dbo.[USER] U, dbo.AUTHORITY A
	WHERE A.[AUTHORITYID] = U.[AUTHORITYID] AND USER_STATUS = 'TRUE'
END
GO

	-- ======================================--======================================--
--==========================================DEPARTMENT======================================== --
	-- ======================================--======================================--
CREATE PROC SP_SEARCH_DEPARTMENT
AS
BEGIN
	SELECT DEPARTMENTID, DEPARTMENT_NAME
	FROM dbo.DEPARTMENT
	WHERE DEPARTMENT_STATUS = 'TRUE'
END
GO

	-- ======================================--======================================--
--==========================================STUDENT======================================== --
	-- ======================================--======================================--
CREATE PROC SP_SEARCH_STUDENTID
@STUDENTID VARCHAR(9)
AS
BEGIN
	SELECT	STUDENTID, STUDENT_NAME, STUDENT_DATEOFBIRTH,DEPARTMENT_NAME
	FROM	dbo.STUDENT S, DEPARTMENT D
	WHERE	STUDENTID = @STUDENTID and
			S.DEPARTMENTID = D.DEPARTMENTID
END
GO
	-- ======================================--======================================--
--==========================================RECORD======================================== --
	-- ======================================--======================================--
CREATE PROC SP_SEARCH_RECORD
@STUDENTID VARCHAR(9)
AS
BEGIN
	SELECT	RE.RECORDID, RECORD_NAME, RECORD_STATUS, NOTE
	FROM	dbo.STUDENT S, dbo.RECORD RE, dbo.RECEIPT_DETAIL RD, dbo.RECEIPT RT
	WHERE	S.STUDENTID = @STUDENTID AND
			S.STUDENTID = RT.STUDENTID AND
			RT.RECEIPTID = RD.RECEIPTID AND
			RD.RECORDID = RE.RECORDID		
END
GO


----------------------------------------------------------------------------------------------------------
-------------------------------------------CREATE---------------------------------------------------------
----------------------------------------------------------------------------------------------------------
GO							

-- =============================================
-- Author:		Huy Huynh
-- Create date: 28/07/2012
-- Description:
-- =============================================
GO
	-- ======================================--======================================--
--==========================================STUDENT======================================== --
	-- ======================================--======================================--
--Import thông tin student vào
CREATE PROC SP_IMPORT_STUDENT_RECORD
@STUDENT_ID VARCHAR(9),
@STUDENT_NAME NVARCHAR(50),
@BATCH INT,
@STUDENT_PHONE VARCHAR(15),
@DATEOFBIRTH DATETIME,
@STUDENT_GENDER NVARCHAR(50),
@STUDENT_ADDRESS NVARCHAR(50),
@DEPARTMENTID VARCHAR(15),
@USERID VARCHAR(9)
AS
BEGIN
	INSERT INTO STUDENT VALUES (@STUDENT_ID,@STUDENT_NAME,@BATCH,@STUDENT_ADDRESS,@STUDENT_PHONE,@STUDENT_GENDER,@DATEOFBIRTH,@DEPARTMENTID,@USERID)
END
GO

-- ======================================--======================================--
--==========================================RECIEPT======================================== --
	-- ======================================--======================================--
--Thêm record vào
CREATE PROC SP_CREATE_STUDENT_RECEIPT
@STUDENTID VARCHAR(9),
@USERID VARCHAR(9),
@DEPARTMENTID VARCHAR(9),
@DATE_CREATED DATETIME
AS
BEGIN
	DECLARE @RECEIPTID VARCHAR(10)
	DECLARE @MAX INT
	
	IF NOT EXISTS (SELECT 1 FROM RECEIPT )
	BEGIN
		SET @RECEIPTID = YEAR(@DATE_CREATED)+@DEPARTMENTID+'0001'
	END
	ELSE
	BEGIN
		SET @MAX = (SELECT MAX (RIGHT(RECEIPTID,4)) FROM RECEIPT )
		SET @MAX = @MAX+1
		SET @RECEIPTID = YEAR(@DATE_CREATED) + @DEPARTMENTID + RIGHT('000'+CONVERT(VARCHAR(4),@MAX),4)
	END

	INSERT INTO RECEIPT VALUES (@RECEIPTID,@STUDENTID,@USERID,@DATE_CREATED)
END
GO


-- ======================================--======================================--
--==========================================RECEIPT DETAIL======================================== --
	-- ======================================--======================================--
--Thêm record vào
CREATE PROC SP_CREATE_RECEIPT_DETAIL
@RECEIPTID VARCHAR(10)
AS
BEGIN
	INSERT INTO RECEIPT_DETAIL VALUES (@RECEIPTID,1,'FALSE','')
	INSERT INTO RECEIPT_DETAIL VALUES (@RECEIPTID,2,'FALSE','')
	INSERT INTO RECEIPT_DETAIL VALUES (@RECEIPTID,3,'FALSE','')
	INSERT INTO RECEIPT_DETAIL VALUES (@RECEIPTID,4,'FALSE','')
	INSERT INTO RECEIPT_DETAIL VALUES (@RECEIPTID,5,'FALSE','')
	INSERT INTO RECEIPT_DETAIL VALUES (@RECEIPTID,6,'FALSE','')
	INSERT INTO RECEIPT_DETAIL VALUES (@RECEIPTID,7,'FALSE','')
	INSERT INTO RECEIPT_DETAIL VALUES (@RECEIPTID,8,'FALSE','')
	INSERT INTO RECEIPT_DETAIL VALUES (@RECEIPTID,9,'FALSE','')
END
GO


----------------------------------------------------------------------------------------------------------
-------------------------------------------UPDATE---------------------------------------------------------
----------------------------------------------------------------------------------------------------------
GO							

-- =============================================
-- Author:		Huy Huynh
-- Create date: 30/07/2012
-- Description:
-- =============================================
GO
	-- ======================================--======================================--
--==========================================USER======================================== --
	-- ======================================--======================================--

CREATE PROC SP_UPDATE_USER_LOGIN_ALLOWED
@USERID VARCHAR(9),
@STATUS BIT
AS
BEGIN
	update	[USER]
	set		USER_LOGINALOWED = @STATUS
	where	USERID = @USERID
END
GO

-- ======================================--======================================--
--==========================================RECEIPT DETAIL======================================== --
	-- ======================================--======================================--
--Thêm record vào
CREATE PROC SP_UPDATE_RECEIPT_DETAIL
@RECEIPTID VARCHAR(10),
@RECORDID INT,
@STATUS BIT,
@NOTE NVARCHAR(100)
AS
BEGIN
	UPDATE	RECEIPT_DETAIL
	SET		RECORD_STATUS = @STATUS,
			NOTE = @NOTE
	WHERE	@RECEIPTID = RECEIPTID AND
			@RECEIPTID = RECORDID
END
GO


---------------------------------------------------------------------------------------------------


--INSERT DATA BASE
INSERT INTO dbo.AUTHORITY VALUES ('AU0001','Administrator')
INSERT INTO dbo.AUTHORITY VALUES ('AU0002','The Faculty Monitor')
INSERT INTO dbo.AUTHORITY VALUES ('AU0003','The Received Student Record Officer')
INSERT INTO dbo.AUTHORITY VALUES ('AU0004','The Training Department Officer')
INSERT INTO dbo.AUTHORITY VALUES ('AU0005','The Human Resource Department Officer')
INSERT INTO dbo.AUTHORITY VALUES ('AU0006','The Management Committee')

INSERT INTO DEPARTMENT VALUES ('HIGH',N'Tài khoản cấp cao','FALSE')
INSERT INTO DEPARTMENT VALUES ('AX',N'Kiến trúc Xây dựng','TRUE')
INSERT INTO DEPARTMENT VALUES ('NN',N'Ngoại ngữ','TRUE')
INSERT INTO DEPARTMENT VALUES ('MC',N'Mỹ thuật Công nghiệp','TRUE')
INSERT INTO DEPARTMENT VALUES ('SH',N'Công nghệ Sinh học','TRUE')
INSERT INTO DEPARTMENT VALUES ('MT',N'Công nghệ & Quản lý Môi trường','TRUE')
INSERT INTO DEPARTMENT VALUES ('DA',N'Điện lạnh','TRUE')
INSERT INTO DEPARTMENT VALUES ('DL',N'Du lịch','TRUE')
INSERT INTO DEPARTMENT VALUES ('TH',N'Công nghệ Thông tin','TRUE')
INSERT INTO DEPARTMENT VALUES ('TC',N'Ban Trung học Chuyên nghiệp','TRUE')
INSERT INTO DEPARTMENT VALUES ('FB',N'Tài chính Ngân hàng','TRUE')
INSERT INTO DEPARTMENT VALUES ('KT',N'Kế toán - Kiểm toán','TRUE')
INSERT INTO DEPARTMENT VALUES ('CO',N'Thương Mại','TRUE')
INSERT INTO DEPARTMENT VALUES ('QT',N'Quản trị Kinh doanh','TRUE')
INSERT INTO DEPARTMENT VALUES ('PR',N'Quan hệ Công chúng & Truyền thông','TRUE')

INSERT INTO [USER] VALUES('ADMIN',N'Chân Tình','2/9/1991', N'115/28 Trần Đình Xu, Q1','01656002722','Nam','Admin','True','True','HIGH','AU0001')
INSERT INTO [USER] VALUES('987654320',N'Baby Sunshine','1/11/1991', N'7/14 Nguyễn Khắc Nhu, Q1','01679246288','Nam','123','True','True','TH','AU0002')
INSERT INTO [USER] VALUES('123456789',N'Cùi Quang Hiệp', '9/22/1991', N'112 Cống Quỳnh, Q1','0153968742',N'Nữ','123','True','True','HIGH','AU0006')
INSERT INTO [USER] VALUES('124556789',N'Nguyễn Trần Hồng Phúc', '7/15/1991', N'113 Cống Quỳnh, Q1','0153968746',N'Nam','123','True','True','HIGH','AU0005')
INSERT INTO [USER] VALUES('124558589',N'Trần Dũng Đạt', '5/25/1991', N'13 Cống Quỳnh, Q1','0153968741',N'Nam','123','True','True','HIGH','AU0004')
INSERT INTO [USER] VALUES('124556745',N'Giang Thị Hà Thanh', '8/3/1991', N'24 Cống Quỳnh, Q1','0153458742',N'Nam','123','True','True','HIGH','AU0003')
INSERT INTO [USER] VALUES('124523789',N'Trần Như Nhộng', '5/2/1991', N'113 Cống Quỳnh, Q1','0156968742',N'Nam','123','True','True','NN','AU0002')
INSERT INTO [USER] VALUES('124555789',N'Nguyễn Thị Mẹt', '12/2/1991', N'113 Cống Quỳnh, Q1','0155668742',N'Nữ','123','True','True','AX','AU0002')

INSERT INTO dbo.RECORD VALUES (1,N'Giấy báo trúng tuyển')
INSERT INTO dbo.RECORD VALUES (2,N'Học bạ THPT (Bản photo có kèm bản chính)')
INSERT INTO dbo.RECORD VALUES (3,N'Bằng tốt nghiệp PTTH, BTTH, giấy CNTN tạm thời (Bản photo kèm theo bản chính đối chiếu)')
INSERT INTO dbo.RECORD VALUES (4,N'Giấy khai sinh (Bản photo có kèm bản chính)')
INSERT INTO dbo.RECORD VALUES (5,N'Giấy tờ xác định đối tượng và khu vực ưu tiên')
INSERT INTO dbo.RECORD VALUES (6,N'Hộ khẩu thường trú (Bản photo có kèm bản chính)')
INSERT INTO dbo.RECORD VALUES (7,N'Hồ sơ chuyển sinh hoạt đoàn')
INSERT INTO dbo.RECORD VALUES (8,N'04 phong bì dán tem ghi rõ địa chỉ gia đình')
INSERT INTO dbo.RECORD VALUES (9,N'Đã chụp ảnh thẻ tại trường')

--THỰC THI CÁC HÀM SELECT
SELECT * FROM DEPARTMENT
GO
SELECT * FROM [USER]
GO
SELECT * FROM AUTHORITY
GO
SELECT * FROM STUDENT
GO
SELECT * FROM RECORD
GO

--SEARCH USER
EXEC SP_SEARCH_USER
GO
--SEARCH DEPARTMENT
EXEC SP_SEARCH_DEPARTMENT
GO