ALTER PROCEDURE SP_BINGO_CHECK
	@pSTACK INT
AS
--DECLARE @pSTACK INT
-- 1¿­ ºù°í
IF((SELECT one FROM BingoTable WHERE id = 1) = 'BINGO' AND (SELECT one FROM BingoTable WHERE id = 2) = 'BINGO' 
	AND (SELECT one FROM BingoTable WHERE id = 3) = 'BINGO'	AND (SELECT one FROM BingoTable WHERE id = 4) = 'BINGO' 
	AND (SELECT one FROM BingoTable WHERE id = 5) = 'BINGO') 
		BEGIN
			RAISERROR ('ºù°í', 11, 2)
			UPDATE STACK
			SET STACK = (SELECT * FROM STACK) + 1
			UPDATE BingoTable
			SET one = 'B'
			WHERE id = 1	
			UPDATE BingoTable
			SET one = 'I'
			WHERE id = 2
			UPDATE BingoTable
			SET one = 'N'
			WHERE id = 3
			UPDATE BingoTable
			SET one = 'G'
			WHERE id = 4
			UPDATE BingoTable
			SET one = 'O'
			WHERE id = 5
			SELECT * FROM BingoTable
		END
--2¿­ ºù°í 
ELSE IF((SELECT two FROM BingoTable WHERE id = 1) = 'BINGO' AND (SELECT two FROM BingoTable WHERE id = 2) = 'BINGO' 
	AND (SELECT two FROM BingoTable WHERE id = 3) = 'BINGO'	AND (SELECT two FROM BingoTable WHERE id = 4) = 'BINGO' 
	AND (SELECT two FROM BingoTable WHERE id = 5) = 'BINGO') 
		BEGIN
			RAISERROR ('ºù°í', 11, 2)
			UPDATE STACK
			SET STACK = (SELECT * FROM STACK) + 1
			UPDATE BingoTable
			SET two = 'B'
			WHERE id = 1	
			UPDATE BingoTable
			SET two = 'I'
			WHERE id = 2
			UPDATE BingoTable
			SET two = 'N'
			WHERE id = 3
			UPDATE BingoTable
			SET two = 'G'
			WHERE id = 4
			UPDATE BingoTable
			SET two = 'O'
			WHERE id = 5
			SELECT * FROM BingoTable
		END
--3¿­ ºù°í 
ELSE IF((SELECT three FROM BingoTable WHERE id = 1) = 'BINGO' AND (SELECT three FROM BingoTable WHERE id = 2) = 'BINGO' 
	AND (SELECT three FROM BingoTable WHERE id = 3) = 'BINGO'	AND (SELECT three FROM BingoTable WHERE id = 4) = 'BINGO' 
	AND (SELECT three FROM BingoTable WHERE id = 5) = 'BINGO') 
		BEGIN
			RAISERROR ('ºù°í', 11, 2)
			UPDATE STACK
			SET STACK = (SELECT * FROM STACK) + 1
			UPDATE BingoTable
			SET three = 'B'
			WHERE id = 1	
			UPDATE BingoTable
			SET three = 'I'
			WHERE id = 2
			UPDATE BingoTable
			SET three = 'N'
			WHERE id = 3
			UPDATE BingoTable
			SET three = 'G'
			WHERE id = 4
			UPDATE BingoTable
			SET three = 'O'
			WHERE id = 5
			SELECT * FROM BingoTable
		END
--4¿­ ºù°í 
ELSE IF((SELECT four FROM BingoTable WHERE id = 1) = 'BINGO' AND (SELECT four FROM BingoTable WHERE id = 2) = 'BINGO' 
	AND (SELECT four FROM BingoTable WHERE id = 3) = 'BINGO' AND (SELECT four FROM BingoTable WHERE id = 4) = 'BINGO' 
	AND (SELECT four FROM BingoTable WHERE id = 5) = 'BINGO') 
		BEGIN
			RAISERROR ('ºù°í', 11, 2)
			UPDATE STACK
			SET STACK = (SELECT * FROM STACK) + 1
			UPDATE BingoTable
			SET four = 'B'
			WHERE id = 1	
			UPDATE BingoTable
			SET four = 'I'
			WHERE id = 2
			UPDATE BingoTable
			SET four = 'N'
			WHERE id = 3
			UPDATE BingoTable
			SET four = 'G'
			WHERE id = 4
			UPDATE BingoTable
			SET four = 'O'
			WHERE id = 5
			SELECT * FROM BingoTable
		END
--5¿­ ºù°í 
ELSE IF((SELECT five FROM BingoTable WHERE id = 1) = 'BINGO' AND (SELECT five FROM BingoTable WHERE id = 2) = 'BINGO' 
	AND (SELECT five FROM BingoTable WHERE id = 3) = 'BINGO'	AND (SELECT five FROM BingoTable WHERE id = 4) = 'BINGO' 
	AND (SELECT five FROM BingoTable WHERE id = 5) = 'BINGO') 
		BEGIN			
			UPDATE BingoTable
			SET five = 'B'
			WHERE id = 1	
			UPDATE BingoTable
			SET five = 'I'
			WHERE id = 2
			UPDATE BingoTable
			SET five = 'N'
			WHERE id = 3
			UPDATE BingoTable
			SET five = 'G'
			WHERE id = 4
			UPDATE BingoTable
			SET five = 'O'
			WHERE id = 5			
			UPDATE STACK
			SET STACK = (SELECT * FROM STACK) + 1
			RAISERROR ('ºù°í', 11, 2)
			SELECT * FROM BingoTable
		END
--1Çà ºù°í 
ELSE IF ((SELECT one FROM BingoTable WHERE id = 1) = 'BINGO' AND (SELECT two FROM BingoTable WHERE id = 1) = 'BINGO'
		AND (SELECT three FROM BingoTable WHERE id = 1) = 'BINGO'	AND (SELECT four FROM BingoTable WHERE id = 1) = 'BINGO'
		AND (SELECT five FROM BingoTable WHERE id = 1) = 'BINGO')
		BEGIN			
			UPDATE BingoTable
			SET one = 'B'
			WHERE id = 1	
			UPDATE BingoTable
			SET one = 'I'
			WHERE id = 1
			UPDATE BingoTable
			SET one = 'N'
			WHERE id = 1
			UPDATE BingoTable
			SET one = 'G'
			WHERE id = 1
			UPDATE BingoTable
			SET one = 'O'
			WHERE id = 1			
			UPDATE STACK
			SET STACK = (SELECT * FROM STACK) + 1
			RAISERROR ('ºù°í', 11, 2)
			SELECT * FROM BingoTable
		END
--2Çà ºù°í 
ELSE IF ((SELECT one FROM BingoTable WHERE id = 2) = 'BINGO' AND (SELECT two FROM BingoTable WHERE id = 2) = 'BINGO'
		AND (SELECT three FROM BingoTable WHERE id = 2) = 'BINGO'	AND (SELECT four FROM BingoTable WHERE id = 2) = 'BINGO'
		AND (SELECT five FROM BingoTable WHERE id = 2) = 'BINGO')
		BEGIN			
			UPDATE BingoTable
			SET one = 'B'
			WHERE id = 1	
			UPDATE BingoTable
			SET one = 'I'
			WHERE id = 1
			UPDATE BingoTable
			SET one = 'N'
			WHERE id = 1
			UPDATE BingoTable
			SET one = 'G'
			WHERE id = 1
			UPDATE BingoTable
			SET one = 'O'
			WHERE id = 1			
			UPDATE STACK
			SET STACK = (SELECT * FROM STACK) + 1
			RAISERROR ('ºù°í', 11, 2)
			SELECT * FROM BingoTable
		END
--3Çà ºù°í 
ELSE IF ((SELECT one FROM BingoTable WHERE id = 3) = 'BINGO' AND (SELECT two FROM BingoTable WHERE id = 3) = 'BINGO'
		AND (SELECT three FROM BingoTable WHERE id = 3) = 'BINGO'	AND (SELECT four FROM BingoTable WHERE id = 3) = 'BINGO'
		AND (SELECT five FROM BingoTable WHERE id = 3) = 'BINGO')
		BEGIN			
			UPDATE BingoTable
			SET one = 'B'
			WHERE id = 1	
			UPDATE BingoTable
			SET one = 'I'
			WHERE id = 1
			UPDATE BingoTable
			SET one = 'N'
			WHERE id = 1
			UPDATE BingoTable
			SET one = 'G'
			WHERE id = 1
			UPDATE BingoTable
			SET one = 'O'
			WHERE id = 1			
			UPDATE STACK
			SET STACK = (SELECT * FROM STACK) + 1
			RAISERROR ('ºù°í', 11, 2)
			SELECT * FROM BingoTable
		END
--4Çà ºù°í 
ELSE IF ((SELECT one FROM BingoTable WHERE id = 4) = 'BINGO' AND (SELECT two FROM BingoTable WHERE id = 2) = 'BINGO'
		AND (SELECT three FROM BingoTable WHERE id = 4) = 'BINGO'	AND (SELECT four FROM BingoTable WHERE id = 4) = 'BINGO'
		AND (SELECT five FROM BingoTable WHERE id = 4) = 'BINGO')
		BEGIN			
			UPDATE BingoTable
			SET one = 'B'
			WHERE id = 1	
			UPDATE BingoTable
			SET one = 'I'
			WHERE id = 1
			UPDATE BingoTable
			SET one = 'N'
			WHERE id = 1
			UPDATE BingoTable
			SET one = 'G'
			WHERE id = 1
			UPDATE BingoTable
			SET one = 'O'
			WHERE id = 1			
			UPDATE STACK
			SET STACK = (SELECT * FROM STACK) + 1
			RAISERROR ('ºù°í', 11, 2)
			SELECT * FROM BingoTable
		END
--5Çà ºù°í 
ELSE IF ((SELECT one FROM BingoTable WHERE id = 5) = 'BINGO' AND (SELECT two FROM BingoTable WHERE id = 2) = 'BINGO'
		AND (SELECT three FROM BingoTable WHERE id = 5) = 'BINGO'	AND (SELECT four FROM BingoTable WHERE id = 5) = 'BINGO'
		AND (SELECT five FROM BingoTable WHERE id = 5) = 'BINGO')
		BEGIN			
			UPDATE BingoTable
			SET one = 'B'
			WHERE id = 1	
			UPDATE BingoTable
			SET one = 'I'
			WHERE id = 1
			UPDATE BingoTable
			SET one = 'N'
			WHERE id = 1
			UPDATE BingoTable
			SET one = 'G'
			WHERE id = 1
			UPDATE BingoTable
			SET one = 'O'
			WHERE id = 1			
			UPDATE STACK
			SET STACK = (SELECT * FROM STACK) + 1
			RAISERROR ('ºù°í', 11, 2)
			SELECT * FROM BingoTable
		END

IF((SELECT * FROM STACK) = @pSTACK)
	BEGIN
		RAISERROR ('5 ºù°í ³¡', 11, 2)
		UPDATE STACK
		SET STACK = 0
		RETURN
	END

SELECT STACK AS [ºù°í] FROM STACK 
-- SELECT * FROM BingoTable
