/***************************************
���� Ȯ�� VER 2.0
***************************************/
ALTER PROCEDURE SP_BINGO_CHECK
	@pSTACK INT
AS
--DECLARE @pSTACK INT
-- 1�� ����
IF((SELECT one FROM BingoTable WHERE id = 1) = 'BINGO' AND (SELECT one FROM BingoTable WHERE id = 2) = 'BINGO' 
	AND (SELECT one FROM BingoTable WHERE id = 3) = 'BINGO'	AND (SELECT one FROM BingoTable WHERE id = 4) = 'BINGO' 
	AND (SELECT one FROM BingoTable WHERE id = 5) = 'BINGO') AND (SELECT chk FROM BingoCheck WHERE id =1) = 0
		BEGIN
			RAISERROR ('����', 11, 2)
			UPDATE STACK
			SET STACK = (SELECT * FROM STACK) + 1
			
			UPDATE BingoCheck
			SET chk = 1
			WHERE id = 1
		END
--2�� ���� 
ELSE IF((SELECT two FROM BingoTable WHERE id = 1) = 'BINGO' AND (SELECT two FROM BingoTable WHERE id = 2) = 'BINGO' 
	AND (SELECT two FROM BingoTable WHERE id = 3) = 'BINGO'	AND (SELECT two FROM BingoTable WHERE id = 4) = 'BINGO' 
	AND (SELECT two FROM BingoTable WHERE id = 5) = 'BINGO') AND (SELECT chk FROM BingoCheck WHERE id =2) = 0
		BEGIN
			RAISERROR ('����', 11, 2)
			UPDATE STACK
			SET STACK = (SELECT * FROM STACK) + 1

			UPDATE BingoCheck
			SET chk = 1
			WHERE id = 2
		END
--3�� ���� 
ELSE IF((SELECT three FROM BingoTable WHERE id = 1) = 'BINGO' AND (SELECT three FROM BingoTable WHERE id = 2) = 'BINGO' 
	AND (SELECT three FROM BingoTable WHERE id = 3) = 'BINGO'	AND (SELECT three FROM BingoTable WHERE id = 4) = 'BINGO' 
	AND (SELECT three FROM BingoTable WHERE id = 5) = 'BINGO') AND (SELECT chk FROM BingoCheck WHERE id = 3) = 0
		BEGIN
			RAISERROR ('����', 11, 2)
			UPDATE STACK
			SET STACK = (SELECT * FROM STACK) + 1

			UPDATE BingoCheck
			SET chk = 1
			WHERE id = 3
		END
--4�� ���� 
ELSE IF((SELECT four FROM BingoTable WHERE id = 1) = 'BINGO' AND (SELECT four FROM BingoTable WHERE id = 2) = 'BINGO' 
	AND (SELECT four FROM BingoTable WHERE id = 3) = 'BINGO' AND (SELECT four FROM BingoTable WHERE id = 4) = 'BINGO' 
	AND (SELECT four FROM BingoTable WHERE id = 5) = 'BINGO') AND (SELECT chk FROM BingoCheck WHERE id =4) = 0
		BEGIN
			RAISERROR ('����', 11, 2)
			UPDATE STACK
			SET STACK = (SELECT * FROM STACK) + 1

			UPDATE BingoCheck
			SET chk = 1
			WHERE id = 4
		END
--5�� ���� 
ELSE IF((SELECT five FROM BingoTable WHERE id = 1) = 'BINGO' AND (SELECT five FROM BingoTable WHERE id = 2) = 'BINGO' 
	AND (SELECT five FROM BingoTable WHERE id = 3) = 'BINGO'	AND (SELECT five FROM BingoTable WHERE id = 4) = 'BINGO' 
	AND (SELECT five FROM BingoTable WHERE id = 5) = 'BINGO') AND (SELECT chk FROM BingoCheck WHERE id =5) = 0
		BEGIN			
			UPDATE STACK
			SET STACK = (SELECT * FROM STACK) + 1
			RAISERROR ('����', 11, 2)

			UPDATE BingoCheck
			SET chk = 1
			WHERE id = 5
		END
--1�� ���� 
ELSE IF ((SELECT one FROM BingoTable WHERE id = 1) = 'BINGO' AND (SELECT two FROM BingoTable WHERE id = 1) = 'BINGO'
		AND (SELECT three FROM BingoTable WHERE id = 1) = 'BINGO'	AND (SELECT four FROM BingoTable WHERE id = 1) = 'BINGO'
		AND (SELECT five FROM BingoTable WHERE id = 1) = 'BINGO') AND (SELECT chk FROM BingoCheck WHERE id =6) = 0
		BEGIN					
			UPDATE STACK
			SET STACK = (SELECT * FROM STACK) + 1
			RAISERROR ('����', 11, 2)
			
			UPDATE BingoCheck
			SET chk = 1
			WHERE id = 6
		END
--2�� ���� 
ELSE IF ((SELECT one FROM BingoTable WHERE id = 2) = 'BINGO' AND (SELECT two FROM BingoTable WHERE id = 2) = 'BINGO'
		AND (SELECT three FROM BingoTable WHERE id = 2) = 'BINGO'	AND (SELECT four FROM BingoTable WHERE id = 2) = 'BINGO'
		AND (SELECT five FROM BingoTable WHERE id = 2) = 'BINGO') AND (SELECT chk FROM BingoCheck WHERE id =7) = 0
		BEGIN				
			UPDATE STACK
			SET STACK = (SELECT * FROM STACK) + 1
			RAISERROR ('����', 11, 2)
		
			UPDATE BingoCheck
			SET chk = 1
			WHERE id = 7
		END
--3�� ���� 
ELSE IF ((SELECT one FROM BingoTable WHERE id = 3) = 'BINGO' AND (SELECT two FROM BingoTable WHERE id = 3) = 'BINGO'
		AND (SELECT three FROM BingoTable WHERE id = 3) = 'BINGO'	AND (SELECT four FROM BingoTable WHERE id = 3) = 'BINGO'
		AND (SELECT five FROM BingoTable WHERE id = 3) = 'BINGO') AND (SELECT chk FROM BingoCheck WHERE id =8) = 0
		BEGIN			
			UPDATE STACK
			SET STACK = (SELECT * FROM STACK) + 1
			RAISERROR ('����', 11, 2)
			
			UPDATE BingoCheck
			SET chk = 1
			WHERE id = 8			
		END
--4�� ���� 
ELSE IF ((SELECT one FROM BingoTable WHERE id = 4) = 'BINGO' AND (SELECT two FROM BingoTable WHERE id = 2) = 'BINGO'
		AND (SELECT three FROM BingoTable WHERE id = 4) = 'BINGO'	AND (SELECT four FROM BingoTable WHERE id = 4) = 'BINGO'
		AND (SELECT five FROM BingoTable WHERE id = 4) = 'BINGO') AND (SELECT chk FROM BingoCheck WHERE id =9) = 0
		BEGIN				
			UPDATE STACK
			SET STACK = (SELECT * FROM STACK) + 1
			RAISERROR ('����', 11, 2)

			UPDATE BingoCheck
			SET chk = 1
			WHERE id = 9
		END
--5�� ���� 
ELSE IF ((SELECT one FROM BingoTable WHERE id = 5) = 'BINGO' AND (SELECT two FROM BingoTable WHERE id = 2) = 'BINGO'
		AND (SELECT three FROM BingoTable WHERE id = 5) = 'BINGO'	AND (SELECT four FROM BingoTable WHERE id = 5) = 'BINGO'
		AND (SELECT five FROM BingoTable WHERE id = 5) = 'BINGO') AND (SELECT chk FROM BingoCheck WHERE id =10) = 0
		BEGIN			
			UPDATE STACK
			SET STACK = (SELECT * FROM STACK) + 1
			RAISERROR ('����', 11, 2)

			UPDATE BingoCheck
			SET chk = 1
			WHERE id = 10
		END
ELSE IF ((SELECT one FROM BingoTable WHERE id = 1) = 'BINGO' AND (SELECT two FROM BingoTable WHERE id = 2) = 'BINGO'
		AND (SELECT three FROM BingoTable WHERE id = 3) = 'BINGO'	AND (SELECT four FROM BingoTable WHERE id = 4) = 'BINGO'
		AND (SELECT five FROM BingoTable WHERE id = 5) = 'BINGO') AND (SELECT chk FROM BingoCheck WHERE id =11) = 0
		BEGIN			
			UPDATE STACK
			SET STACK = (SELECT * FROM STACK) + 1
			RAISERROR ('����', 11, 2)

			UPDATE BingoCheck
			SET chk = 1
			WHERE id = 11
		END
ELSE IF((SELECT one FROM BingoTable WHERE id = 5) = 'BINGO' AND (SELECT two FROM BingoTable WHERE id = 4) = 'BINGO'
		AND (SELECT three FROM BingoTable WHERE id = 3) = 'BINGO'	AND (SELECT four FROM BingoTable WHERE id = 2) = 'BINGO'
		AND (SELECT five FROM BingoTable WHERE id = 1) = 'BINGO') AND (SELECT chk FROM BingoCheck WHERE id =12) = 0
		BEGIN			
			UPDATE STACK
			SET STACK = (SELECT * FROM STACK) + 1
			RAISERROR ('����', 11, 2)

			UPDATE BingoCheck
			SET chk = 1
			WHERE id = 12
		END

-- 5������ ���  ����޼��� ���� 
IF((SELECT * FROM STACK) = @pSTACK)
	BEGIN
		RAISERROR ('5 ���� ��', 11, 2)
		UPDATE STACK
		SET STACK = 0
		
		UPDATE BingoTable
		SET one = 'B'
		WHERE id = 1	
		UPDATE BingoTable
		SET two = 'I'
		WHERE id = 1
		UPDATE BingoTable
		SET three = 'N'
		WHERE id = 1
		UPDATE BingoTable
		SET four = 'G'
		WHERE id = 1
		UPDATE BingoTable
		SET five = 'O'
		WHERE id = 1		
		
		UPDATE BingoTable
		SET one = 'B'
		WHERE id = 2	
		UPDATE BingoTable
		SET two = 'I'
		WHERE id = 2
		UPDATE BingoTable
		SET three = 'N'
		WHERE id = 2
		UPDATE BingoTable
		SET four = 'G'
		WHERE id = 2
		UPDATE BingoTable
		SET five = 'O'
		WHERE id = 2

		UPDATE BingoTable
		SET one = 'B'
		WHERE id = 3	
		UPDATE BingoTable
		SET two = 'I'
		WHERE id = 3
		UPDATE BingoTable
		SET three = 'N'
		WHERE id = 3
		UPDATE BingoTable
		SET four = 'G'
		WHERE id = 3
		UPDATE BingoTable
		SET five = 'O'
		WHERE id = 3

		UPDATE BingoTable
		SET one = 'B'
		WHERE id = 4	
		UPDATE BingoTable
		SET two = 'I'
		WHERE id = 4
		UPDATE BingoTable
		SET three = 'N'
		WHERE id = 4
		UPDATE BingoTable
		SET four = 'G'
		WHERE id = 4
		UPDATE BingoTable
		SET five = 'O'
		WHERE id = 4

		UPDATE BingoTable
		SET one = 'B'
		WHERE id = 5	
		UPDATE BingoTable
		SET two = 'I'
		WHERE id = 5
		UPDATE BingoTable
		SET three = 'N'
		WHERE id = 5
		UPDATE BingoTable
		SET four = 'G'
		WHERE id = 5
		UPDATE BingoTable
		SET five = 'O'
		WHERE id = 5
		SELECT * FROM BingoTable
		RETURN
	END

SELECT STACK AS [����] FROM STACK 
-- SELECT * FROM BingoTable
