ALTER PROCEDURE SP_BingoTable_CREATE
AS
EXEC SP_NumTable_Create
/***************** TABLE : BingoTable   -- 랜덤 숫자가 들어갈 빙고 상자 ********************
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
*******************************************초기값 세팅 *************************처음만 사용함
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
WHILE (@pCNT <=5)     -- 랜덤한 수로 빙고 테이블 만드는 반복문 
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

--  TABLE :  BingoCheck		 한줄 빙고 되었을 때 확인 테이블 세팅
DECLARE @pCNT2 INT
SET @pCNT2 = 1
WHILE(@pCNT2<= 12)
	BEGIN
		UPDATE BingoCheck 
		SET chk = 0
		WHERE id = @pCNT2

		SET  @pCNT2 = @pCNT2 + 1
	END

-- TABLE : STACK			몇 빙고 되었는지 확인 테이블 세팅
		UPDATE STACK
		SET STACK = 0



--SELECT * FROM BingoCheck


/******* 랜던함 중복 없는 값 테이블에 입력하는 구문 
WHILE (@Default <= 5)
	BEGIN
		SET @RAND = CONVERT(INT, ROUND((RAND() * (@CountMenu-1))+1, 0))	  -- 랜드값 만드는 곳 
		SET @temp = (SELECT Count1 FROM CountLunchMenu WHERE num = @RAND )  -- CountLunchMenu 의 데이터 
		WHILE(@temp = 48)    --48 이 안나올때 까지  계속 실행
			BEGIN
				SET @temp = (SELECT Count1 FROM CountLunchMenu WHERE num = ROUND((RAND() * (@CountMenu-1))+1, 0)) 
			END

		
		UPDATE RandNum			-- RandNum 테이블의 중복되지 않는 랜덤한 값 입력
		SET RandNum = @temp
		WHERE num = @Default

		UPDATE CountLunchMenu	-- CountLunchMenu 에서 뽑아온 데이터 행의 데이터를 48로 바꿈
		SET Count1 = 48
		WHERE num = @temp

		SET @Default = @Default + 1
	END
*/

