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

-- �޴� ���� ī��Ʈ �Ͽ� ���̺� ����       : CountLunchMenu   ���ɸ޴� ���� ���̺�
DECLARE @COUNT INT, @Default INT
SET @Default = 1
SET @COUNT = (SELECT COUNT(Menu) FROM LunchMenu)


WHILE (@Default <= @COUNT)
 BEGIN
	INSERT INTO CountLunchMenu VALUES (@Default)
	SET @Default = @Default + 1
 END


-- RandNum �⺻����      : ���� ������ ���̺� ���� 
SET @Default = 1
WHILE(@Default < = 5)
BEGIN
	INSERT INTO RandNum VALUES(4859)
	SET @Default = @Default + 1
END

-- ���ɸ޴� ���� 
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

INSERT INTO LunchMenu_week  VALUES ('��','','')
INSERT INTO LunchMenu_week  VALUES ('ȭ','','')
INSERT INTO LunchMenu_week  VALUES ('��','','')
INSERT INTO LunchMenu_week  VALUES ('��','','')
INSERT INTO LunchMenu_week  VALUES ('��','','')
********************************/
