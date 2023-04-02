ALTER PROCEDURE SP_LUNCH_SETTING
AS
DROP TABLE RandNum
DROP TABLE CountLunchMenu
DROP TABLE LunchSum


CREATE TABLE CountLunchMenu
(	
	num INT IDENTITY NOT NULL,
	Count1 INT
)

CREATE TABLE RandNum
(
	num int IDENTITY NOT NULL,
	RandNum INT
)

-- 메뉴 종류 카운트 하여 테이블 생성       : CountLunchMenu   점심메뉴 갯수 테이블
DECLARE @COUNT INT, @Default INT
SET @Default = 1
SET @COUNT = (SELECT COUNT(Menu) FROM LunchMenu)


WHILE (@Default <= @COUNT)
 BEGIN
	INSERT INTO CountLunchMenu VALUES (@Default)
	SET @Default = @Default + 1
 END


-- RandNum 기본세팅      : 요일 랜덤값 테이블 세팅 
SET @Default = 1
WHILE(@Default < = 5)
BEGIN
	INSERT INTO RandNum VALUES(4859)
	SET @Default = @Default + 1
END

-- 점심메뉴 총합 
CREATE TABLE LunchSum
(	
	SUM INT
)

--SELECT * FROM CountLunchMenu
--SELECT * FROM RandNum
--	
/**************************
DROP TABLE LunchMenu_week
CREATE TABLE LunchMenu_week
( 
	num int IDENTITY NOT NULL,
	day NVARCHAR(10),
	Menu NVARCHAR(20),
	Sort INT
)

INSERT INTO LunchMenu_week  VALUES ('월','','')
INSERT INTO LunchMenu_week  VALUES ('화','','')
INSERT INTO LunchMenu_week  VALUES ('수','','')
INSERT INTO LunchMenu_week  VALUES ('목','','')
INSERT INTO LunchMenu_week  VALUES ('금','','')
********************************/
