/**********   TABLE : NumTable   *********숫자 상자 생성**************/
ALTER PROCEDURE SP_NumTable_Create
AS
DROP TABLE NumTable
DECLARE @pCNT INT
CREATE TABLE NumTable
(
	id INT IDENTITY NOT NULL,
	num CHAR(8)
)

SET @pCNT = 1
WHILE(@pCNT <= 25)
	BEGIN
		INSERT NumTable VALUES (CONVERT(CHAR(3), @pCNT))
		SET @pCNT = @pCNT + 1
	END



--SELECT * FROM NumTable
/********************************************************************/

