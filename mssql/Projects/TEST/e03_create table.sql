USE TestDB
BEGIN TRAN
DECLARE @pChar char(2)

DROP TABLE dbo.Test3_Child_�̿ϻ�
CREATE TABLE dbo.Test3_Child_�̿ϻ�
(	
	ChildNm char(8),
	CNT100 INT,
	CNT500 INT,
	CNT1000 INT,
	CNT5000 INT,
	CNT10000 INT
)

INSERT INTO dbo.Test3_Child_�̿ϻ� SELECT * FROM dbo.Test3_Child
SELECT * FROM dbo.Test3_Child_�̿ϻ�
CASE WHEN @pChar = 'D' THEN SELECT *, (CNT100*100 + CNT500*500 + CNT1000*1000 + CNT5000*5000 + CNT10000*10000) AS [�� �ݾ�] FROM dbo.Test3_Child_�̿ϻ�
END
SELECT @@TRANCOUNT
--ROLLBACK TRAN 