ALTER PROCEDURE SP_BingoTable_CREATE
AS
EXEC SP_NumTable_Create
/***************** TABLE : BingoTable   -- ���� ���ڰ� �� ���� ���� ********************
DROP TABLE BingoTable
CREATE TABLE BingoTable
(	
	id INT IDENTITY NOT NULL,   --id INT IDENTITY(0,1) NOT NULL,
	one char(8),
	two char(8),
	three char(8),
	four char(8),
	five char(8)
)
*******************************************�ʱⰪ ���� *************************ó���� �����
-- INSERT INTO BingoTable VALUES ('91', '92', '93', '94', '95')    --column
INSERT INTO BingoTable VALUES ('0', '0', '0', '0', '0')
INSERT INTO BingoTable VALUES ('1', '2', '3', '4', '5')
INSERT INTO BingoTable VALUES ('1', '2', '3', '4', '5')
INSERT INTO BingoTable VALUES ('1', '2', '3', '4', '5')	
INSERT INTO BingoTable VALUES ('1', '2', '3', '4', '5')
SELECT * FROM BingoTable
*********************************************************************************************/
DECLARE @pCNT INT, @pRAND INT, @temp CHAR(8)   
SET @pCNT = 1
WHILE (@pCNT <=5)     -- ������ ���� ���� ���̺� ����� �ݺ��� 
	BEGIN
		SET @pRAND = (ROUND((RAND()* 24)+1, 0))
		SET @temp = CONVERT(CHAR(8), (SELECT num FROM NumTable WHERE id = @pRAND))
		WHILE (@temp = '4859')
			BEGIN
				SET @pRAND = (ROUND((RAND()* 24)+1, 0))
				SET @temp = CONVERT(CHAR(8),(SELECT num FROM NumTable WHERE id = @pRAND))
			END
		UPDATE BingoTable 
		SET one = @temp
		WHERE id = @pCNT 
		UPDATE NumTable
		SET num = '4859'
		WHERE id = CONVERT(INT, @temp)

		SET @pRAND = (ROUND((RAND()* 24)+1, 0))
		SET @temp = CONVERT(CHAR(8), (SELECT num FROM NumTable WHERE id = @pRAND))
		WHILE (@temp = '4859')
			BEGIN
				SET @pRAND = (ROUND((RAND()* 24)+1, 0))
				SET @temp = CONVERT(CHAR(8),(SELECT num FROM NumTable WHERE id = @pRAND))
			END	
		UPDATE BingoTable 
		SET two = @temp
		WHERE  id = @pCNT 
		UPDATE NumTable
		SET num = '4859'
		WHERE id = CONVERT(INT, @temp)
		SET @pRAND = (ROUND((RAND()* 24)+1, 0))
		SET @temp = CONVERT(CHAR(8), (SELECT num FROM NumTable WHERE id = @pRAND))
		WHILE (@temp = '4859')
			BEGIN
				SET @pRAND = (ROUND((RAND()* 24)+1, 0))
				SET @temp = CONVERT(CHAR(8),(SELECT num FROM NumTable WHERE id = @pRAND))
			END	
		UPDATE BingoTable 
		SET three = @temp
		WHERE  id = @pCNT 
		UPDATE NumTable
		SET num = '4859'
		WHERE id = CONVERT(INT, @temp)

		SET @pRAND = (ROUND((RAND()* 24)+1, 0))
		SET @temp = CONVERT(CHAR(8), (SELECT num FROM NumTable WHERE id = @pRAND))
		WHILE (@temp = '4859')
			BEGIN
				SET @pRAND = (ROUND((RAND()* 24)+1, 0))
				SET @temp = CONVERT(CHAR(8),(SELECT num FROM NumTable WHERE id = @pRAND))
			END	
		UPDATE BingoTable 
		SET four = @temp
		WHERE  id = @pCNT 
		UPDATE NumTable
		SET num = '4859'
		WHERE id = CONVERT(INT, @temp)

		SET @pRAND = (ROUND((RAND()* 24)+1, 0))
		SET @temp = CONVERT(CHAR(8), (SELECT num FROM NumTable WHERE id = @pRAND))
		WHILE (@temp = '4859')
			BEGIN
				SET @pRAND = (ROUND((RAND()* 24)+1, 0))
				SET @temp = CONVERT(CHAR(8),(SELECT num FROM NumTable WHERE id = @pRAND))
			END	
		UPDATE BingoTable 
		SET five = @temp
		WHERE  id = @pCNT 
		UPDATE NumTable
		SET num = '4859'
		WHERE id = CONVERT(INT, @temp)
		SET @pCNT = @pCNT + 1
	END
SELECT * FROM BingoTable

--  TABLE :  BingoCheck		 ���� ���� �Ǿ��� �� Ȯ�� ���̺� ����
DECLARE @pCNT2 INT
SET @pCNT2 = 1
WHILE(@pCNT2<= 12)
	BEGIN
		UPDATE BingoCheck 
		SET chk = 0
		WHERE id = @pCNT2

		SET  @pCNT2 = @pCNT2 + 1
	END

-- TABLE : STACK			�� ���� �Ǿ����� Ȯ�� ���̺� ����
		UPDATE STACK
		SET STACK = 0



--SELECT * FROM BingoCheck


/******* ������ �ߺ� ���� �� ���̺� �Է��ϴ� ���� 
WHILE (@Default <= 5)
	BEGIN
		SET @RAND = CONVERT(INT, ROUND((RAND() * (@CountMenu-1))+1, 0))	  -- ���尪 ����� �� 
		SET @temp = (SELECT Count1 FROM CountLunchMenu WHERE num = @RAND )  -- CountLunchMenu �� ������ 
		WHILE(@temp = 48)    --48 �� �ȳ��ö� ����  ��� ����
			BEGIN
				SET @temp = (SELECT Count1 FROM CountLunchMenu WHERE num = ROUND((RAND() * (@CountMenu-1))+1, 0)) 
			END

		
		UPDATE RandNum			-- RandNum ���̺��� �ߺ����� �ʴ� ������ �� �Է�
		SET RandNum = @temp
		WHERE num = @Default

		UPDATE CountLunchMenu	-- CountLunchMenu ���� �̾ƿ� ������ ���� �����͸� 48�� �ٲ�
		SET Count1 = 48
		WHERE num = @temp

		SET @Default = @Default + 1
	END
*/

