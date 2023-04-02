/************************************************************************
빙고게임 입력값 받는 프로시저 

입력값 받게되면 해당값이 BINGO로 변환
*************************************************************************/

ALTER PROCEDURE SP_BINGO_GAME
	@input char(8)
AS
	DECLARE @pCNT INT
	SET @pCNT = 1
WHILE(@pCNT <= 5)
BEGIN
	IF((SELECT one FROM BingoTable WHERE id = @pCNT) = @input)
		BEGIN
			UPDATE BingoTable
			SET one = 'BINGO'
			WHERE one = @input
			SELECT * FROM BingoTable
			RETURN
		END
	ELSE IF((SELECT two FROM BingoTable WHERE id = @pCNT) = @input)
		BEGIN
			UPDATE BingoTable
			SET two = 'BINGO'
			WHERE two = @input
			SELECT * FROM BingoTable
			RETURN
		END

	ELSE IF((SELECT three FROM BingoTable WHERE id = @pCNT) = @input)
		BEGIN
			UPDATE BingoTable
			SET three = 'BINGO'
			WHERE three = @input
			SELECT * FROM BingoTable
			RETURN
		END

	ELSE IF((SELECT four FROM BingoTable WHERE id = @pCNT) = @input)
		BEGIN
			UPDATE BingoTable
			SET four = 'BINGO'
			WHERE four = @input
			SELECT * FROM BingoTable
			RETURN
		END

	ELSE IF((SELECT five FROM BingoTable WHERE id = @pCNT) = @input)
		BEGIN
			UPDATE BingoTable
			SET five = 'BINGO'
			WHERE five = @input
			SELECT * FROM BingoTable
			RETURN
		END
	ELSE
		BEGIN
			SET @pCNT = @pCNT + 1
		END
END 
SELECT * FROM BingoTable
