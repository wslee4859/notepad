ALTER PROCEDURE SP_EXAM1_�޿����_�̿ϻ�
	@pYear char(6)
AS
	DECLARE
		@pPgAmt INT,
		@pJpAmt INT,
		@pTax INT,
		@pRealAmt INT,
		@pCnt INT

--CREATE TABLE #TEMP 
--( num INT IDENTITY NOT NULL)
SELECT * INTO #TEMP FROM EmpMaster_�̿ϻ�    -- �ӽ� ���̺� ����
ALTER TABLE #TEMP							-- ���̺� ��(��ȣ) �߰� 
	ADD num INT IDENTITY NOT NULL 
-- SELECT * FROM #TEMP
-- DROP TABLE #TEMP
	SET @pCnt = 1
-- ���� �⵵�� ���� ���� ��� �� �⵵ �� ���� 
IF EXISTS (SELECT YearMM FROM PayMaster_NEW_�̿ϻ� WHERE YearMM = @pYear)
	BEGIN
		DELETE PayMaster_NEW_�̿ϻ� WHERE YearMM = @pYear
	END
-- ��� ����
	WHILE (@pCnt <= 200)
		BEGIN
			-- �⺻�� 
			SET @pPgAmt = (SELECT Pg.PgAmt FROM #TEMP AS Em
									LEFT JOIN PayMaster_�⺻��_�̿ϻ� AS Pg
										ON Em.PgCd = Pg.PgCd
									WHERE 1=1 
										AND Em.num = @pCnt )
			-- ���������� 0 �ϰ��
			IF (SELECT Jp.JpAmt FROM #TEMP AS Em   
									LEFT JOIN PayMaster_��������_�̿ϻ� AS Jp
										ON Em.JpCd = Jp.jpCd
									WHERE 1=1
										AND Em.num = @pCnt ) IS NULL
				BEGIN
					SET @pJpAmt = 0
				END
			-- ���� ������ 0�� �ƴϸ�
			ELSE  
				BEGIN		
					SET @pJpAmt = (SELECT Jp.JpAmt FROM #TEMP AS Em
											LEFT JOIN PayMaster_��������_�̿ϻ� AS Jp
												ON Em.JpCd = Jp.jpCd
											WHERE 1=1
												AND Em.num = @pCnt )
				END

			SET @pTax = (@pPgAmt + @pJpAmt) * 0.1  -- ����  ? ������ ����
			
			SET @pRealAmt = (@pPgAmt + @pJpAmt) - @pTax   -- �Ǽ��ɾ� 
			
			INSERT INTO PayMaster_NEW_�̿ϻ� SELECT EmpID, @pYear, @pPgAmt, @pJpAmt, @pTax, @pRealAmt 
												FROM #TEMP	WHERE 1=1 AND num=@pCnt 

			SET @pCnt = @pCnt + 1 -- ī���� 
		END
		--END



/*
DECLARE	@pPgAmt INT,
		@pCnt INT
SET @pCnt = 1
WHILE (@pCnt <= 200)
	BEGIN
	SET @pPgAmt = (SELECT Pg.PgAmt FROM #TEMP AS Em
							LEFT JOIN PayMaster_�⺻��_��Ƹ� AS Pg
								ON Em.PgCd = Pg.PgCd
							WHERE 1=1 
								AND Em.num = @pCnt)
	SET @pCnt = @pCnt + 1
	SELECT @pPgAmt
	END
*/
				