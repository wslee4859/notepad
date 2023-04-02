
-- 몇 빙고가 되었는지 알 수 있는 스택 테이블 
CREATE TABLE STACK
(	
	STACK INT
)

-- 빙고가 된 칸을 알 수 있는 테이블 
DROP TABLE BingoCheck   
CREATE TABLE BingoCheck   
(
	id INT IDENTITY NOT NULL ,
	chk INT
)
DECLARE @pCNT INT
SET @pCNT = 1
WHILE(@pCNT<= 12)
BEGIN
INSERT INTO BingoCheck VALUES (0)
SET @pCNT = @pCNT+ 1
END

SELECT * FROM BingoCheck