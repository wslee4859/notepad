
-- �� ���� �Ǿ����� �� �� �ִ� ���� ���̺� 
CREATE TABLE STACK
(	
	STACK INT
)

-- ���� �� ĭ�� �� �� �ִ� ���̺� 
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