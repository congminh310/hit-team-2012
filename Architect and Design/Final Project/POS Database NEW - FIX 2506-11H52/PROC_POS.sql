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
							
	-- ======================================--======================================--
--==========================================USER======================================== --
	-- ======================================--======================================--
CREATE PROC SP_USER
@USER_ADDRESS VARCHAR(50), 
@USER_NAME VARCHAR(50), 
@USER_PHONE VARCHAR(15),
@USER_BUSSINESS VARCHAR(15),
@RETAILSTOREID VARCHAR(9)
AS
BEGIN
 	DECLARE @STAFF_ID VARCHAR(6)
	DECLARE @MAX INT
	
	IF NOT EXISTS (SELECT 1 FROM [USER] )
	BEGIN
		SET @STAFF_ID = SUBSTRING(@USER_BUSSINESS,0,3) + '0001'
	END
	ELSE
	BEGIN
		SET @MAX = (SELECT MAX (RIGHT(USERID,4)) FROM [USER] )
		SET @MAX = @MAX+1
		SET @STAFF_ID = SUBSTRING(@USER_BUSSINESS,0,3) + RIGHT('0000'+CONVERT(VARCHAR(4),@MAX),4)
	END

	INSERT INTO [USER] VALUES (@STAFF_ID, @USER_ADDRESS, @USER_NAME, @USER_PHONE, @STAFF_ID, @RETAILSTOREID)
END
GO

-- =============================================
-- Author:		HUY HUYNH
-- Create date: 27/06/2012
-- Description:	Procedure will create an id increase automatic when add new category
-- =============================================
ALTER PROC SP_CATEGORY
@CATEGORY_NAME NVARCHAR(50)
AS
BEGIN
	DECLARE @CATEGORYID VARCHAR(9)
	DECLARE @MAX INT
	
	IF NOT EXISTS (SELECT 1 FROM CATEGORY )
	BEGIN
		SET @CATEGORYID = 'CA0001'
	END
	ELSE
	BEGIN
		SET @MAX = (SELECT MAX (RIGHT(CATEGORYID,4)) FROM CATEGORY )
		SET @MAX = @MAX+1
		SET @CATEGORYID = 'CA' + RIGHT('000'+CONVERT(VARCHAR(4),@MAX),4)
	END

	INSERT INTO CATEGORY VALUES (@CATEGORYID,@CATEGORY_NAME)
END
GO

	-- ======================================--======================================--
--=======================================SP_RETAILSTORE======================================== --
	-- ======================================--======================================--
ALTER PROC SP_RETAILSTORE
@RETAILSTORE_NAME NVARCHAR(50)
AS
BEGIN
	DECLARE @RETAILSTOREID VARCHAR(9)
	DECLARE @MAX INT
	
	IF NOT EXISTS (SELECT 1 FROM CATEGORY )
	BEGIN
		SET @RETAILSTOREID = 'RE0001'
	END
	ELSE
	BEGIN
		SET @MAX = (SELECT MAX (RIGHT(CATEGORYID,4)) FROM CATEGORY )
		SET @MAX = @MAX+1
		SET @RETAILSTOREID = 'RE' + RIGHT('000'+CONVERT(VARCHAR(4),@MAX),4)
	END

	INSERT INTO RETAILSTORE VALUES (@RETAILSTOREID,@RETAILSTORE_NAME)
END
GO

	-- ======================================--======================================--
--=======================================BILL======================================== --
	-- ======================================--======================================--
Alter PROC SP_BILL
					(@COMPUTERMAC VARCHAR(17),
						@CUSTOMERID VARCHAR(9)	,
							@USERID VARCHAR (9) ,
								@TOTALCOST FLOAT ,
									@DATE DATETIME ,
										@PLUSPOINT INT ,
											@MINUSPOINT INT )
						
AS
BEGIN
	DECLARE @BILLID VARCHAR(9)
	DECLARE @MAX INT

	IF NOT EXISTS (SELECT 1 FROM BILL )
	BEGIN
		SET @BILLID = 'BI0001'
	END

	ELSE
		BEGIN
			SET @MAX = (SELECT MAX (RIGHT(BILLID,4)) FROM BILL )
			SET @MAX = @MAX+1
			SET @BILLID = 'BI' + RIGHT('000'+CONVERT(VARCHAR(4),@MAX),4)
		END
	INSERT INTO BILL  VALUES (@BILLID, @COMPUTERMAC, @CUSTOMERID, @USERID, @TOTALCOST, 
	@DATE, @PLUSPOINT, @MINUSPOINT)
END
GO

	-- ======================================--======================================--
--=======================================PRODUCT======================================== --
	-- ======================================--======================================--
ALTER PROC SP_PRODUCT(@PRODUCT_NAME NVARCHAR(50), @BASICCOST FLOAT, @CATEGORYID VARCHAR(9))
AS
BEGIN
	DECLARE @PRODUCTID VARCHAR(9)
	DECLARE @MAX INT

	IF NOT EXISTS (SELECT 1 FROM PRODUCT)
		BEGIN
			SET @PRODUCTID = 'PR'+ '0001'
		END

	ELSE
		BEGIN
			SET @MAX = (SELECT MAX(RIGHT(PRODUCTID,4) )FROM PRODUCT)
			SET @MAX = @MAX+1
			SET @PRODUCTID = 'PR'+RIGHT('000' + CONVERT(VARCHAR(4),@MAX),4)
		END
	INSERT INTO PRODUCT  VALUES (@PRODUCTID,@PRODUCT_NAME,@BASICCOST,@CATEGORYID)
END
GO

--LƯU Ý:=============================================
--LƯU Ý: CHẠY TỪNG DÒNG 1 ĐỐI VỚI PHẦN ADD NÀY ======
--LƯU Ý:=============================================
EXEC SP_CATEGORY 'BEAR'
EXEC SP_PRODUCT 'HEINEKEN', '15000', 'CA0001'
EXEC SP_RETAILSTORE 'ABC Store'
INSERT INTO COMPUTER VALUES ('00:A0:C9:14:C8:29','RE0001') 
EXEC SP_USER N'115/28 Tran Đinh Xu, Q1, Tp.HCM', 'Giang Nguyen', '01656002722','CASHIER' ,'RE0001'
EXEC SP_USER N'116 Tran Đinh Xu, Q1, Tp.HCM', 'Huy Huynh', '01656002722','MANAGER' ,'RE0001'
INSERT INTO CUSTOMER VALUES ('0', N'Ảo Văn Lòi','0', '0', '0') 
EXEC SP_BILL '00:A0:C9:14:C8:29', '0', 'CA0001', '200000', '06/06/2012', '200', '0'



SELECT * FROM CATEGORY
SELECT * FROM PRODUCT
SELECT * FROM RETAILSTORE
SELECT * FROM COMPUTER
SELECT * FROM [USER]
SELECT * FROM CUSTOMER 
SELECT * FROM BILL
