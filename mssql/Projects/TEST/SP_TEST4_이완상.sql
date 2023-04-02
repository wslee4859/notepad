ALTER PROCEDURE SP_TEST4_�̿ϻ�
	@pYear char(6),
	@pDeptCd char(5),
	@pPgCd char(8)
AS
	IF @pYear = ' '  -- ��� �Է� �ȵ� �� 
	--IF NOT EXISTS (SELECT @pYear)
		BEGIN
			RAISERROR('����� �Է����ֽñ� �ٶ��ϴ�.!',11,1)
			RETURN
		END
	ELSE IF @pDeptCd = ' ' AND @pPgCd = ' '      -- �μ��ڵ� �����ڵ� �Ѵ� �ȵ��� �� 
		BEGIN
			RAISERROR('TEST : �μ��ڵ�, �����ڵ� �Ѵ� �ȵ���',11,1)
						EXEC SP_TEST04_DROP
						EXEC SP_TEST04_CREATE
--				DECLARE
--			    @pYear char(6)
--				SET @pYear = '201401'
				SELECT D.DeptNm,Pg.PgNm, AVG(Pay.PayAmt) AS AvgPayAmt
				INTO AvgAmt
							FROM EmpMaster_�̿ϻ� AS EM
								INNER JOIN DeptMaster_�̿ϻ� AS D
									ON EM.DeptCd= D.DeptCd
								INNER JOIN PgMaster_�̿ϻ� AS Pg
									ON EM.PgCd = Pg.PgCd
								INNER JOIN PayMaster_�̿ϻ� AS Pay
									ON EM.EmpId = Pay.EmpId
							WHERE 1=1
									AND	Pay.PbYm = @pYear 
									AND (Pg.PgNm = '�̻���'
										OR Pg.PgNm = 'S1'
										OR Pg.PgNm = 'S2'
										OR Pg.PgNm = 'M1'
										OR Pg.PgNm = 'M2'
										OR Pg.PgNm = 'SA(��)'
										OR Pg.PgNm = 'SA(��)'
										OR Pg.PgNm = 'A(��)'
										OR Pg.PgNm = 'T1(��)'
										OR Pg.PgNm = 'T2(��)'
										OR Pg.PgNm = 'T3(��)'
										OR Pg.PgNm = 'T4(��)')
							GROUP BY Pg.PgNm , D.DeptNm
					EXEC SP_TEST04_INSERT
					EXEC SP_TEST04_PRINT
					DROP TABLE AvgAmt
					DROP TABLE DeptNm
			RETURN
		END
	ELSE IF @pDeptCd = ' ' OR @pPgCd = ' '       -- �μ��ڵ� �����ڵ� �� �� �ϳ� �ȵ��� �� -> �μ��ڵ�, �����ڵ� ����
		BEGIN
			RAISERROR('TEST : �μ��ڵ�, �����ڵ� �� �ϳ� �ȵ���',11,1)
				IF @pDeptCd = ' '   -- �μ� �ڵ� �Է� �ȵ� �� 
					BEGIN				-- ��� �μ� ��� �޿� ��� 
						RAISERROR('TEST : �μ��ڵ� �ȵ���',11,1)
						SELECT Pg.PgNm,D.DeptNm, AVG(Pay.PayAmt) AS [��� �޿�]
						FROM EmpMaster_�̿ϻ� AS EM
							INNER JOIN DeptMaster_�̿ϻ� AS D
								ON EM.DeptCd= D.DeptCd
							INNER JOIN PgMaster_�̿ϻ� AS Pg
								ON EM.PgCd = Pg.PgCd
							INNER JOIN PayMaster_�̿ϻ� AS Pay
								ON EM.EmpId = Pay.EmpId
						WHERE 1=1
								AND	Pay.PbYm = @pYear		
								AND Pg.PgCd = @pPgCd
						GROUP BY D.DeptNm, Pg.PgNm
					END 
		--	DECLARE @pYear char(6)
		--	SET @pYear = '201404'
				IF @pPgCd = ' '			-- ���� �ڵ� �Է� �ȵ� �� 
					BEGIN				-- ��� ���� ��� �޿� ��� 
						RAISERROR('TEST : �����ڵ� �ȵ���',11,1)
						SELECT D.DeptNm , Pg.PgNm, AVG(Pay.PayAmt) AS [��� �޿�]
						FROM EmpMaster_�̿ϻ� AS EM
							INNER JOIN DeptMaster_�̿ϻ� AS D
								ON EM.DeptCd= D.DeptCd
							INNER JOIN PgMaster_�̿ϻ� AS Pg
								ON EM.PgCd = Pg.PgCd
							INNER JOIN PayMaster_�̿ϻ� AS Pay
								ON EM.EmpId = Pay.EmpId
						WHERE 1=1
								AND D.DeptCd = @pDeptCd
								AND Pay.PbYm = @pYear	
						GROUP BY Pg.PgNm, D.DeptNm  
					END 
		END
ELSE   	/************************** ��� �� �Է� �Ǿ��� �� ****************************************/
	BEGIN
		IF (	SELECT AVG(Pay.PayAmt) AS [��� �޿�]   -- ��ȸ�� ������(��� �޿� ���� ���� ���)
					FROM EmpMaster_�̿ϻ� AS EM
					INNER JOIN DeptMaster_�̿ϻ� AS D
						ON EM.DeptCd= D.DeptCd
					INNER JOIN PgMaster_�̿ϻ� AS Pg
						ON EM.PgCd = Pg.PgCd
					INNER JOIN PayMaster_�̿ϻ� AS Pay
						ON EM.EmpId = Pay.EmpId
					WHERE 1=1
					AND Pay.PbYm = @pYear 
					AND D.DeptCd = @pDeptCd
					AND Pg.PgCd = @pPgCd 
					--AND AVG(Pay.PayAmt) > 20000
					GROUP BY Pay.PbYm, Pg.PgCd, D.DeptCd
				  ) IS NULL
			BEGIN
				RAISERROR('TEST : ��ȸ�� �����Ͱ� �����ϴ�.',11,1)
			END
		ELSE
			BEGIN
				SELECT  D.DeptCd, Pg.PgCd, Pay.PbYm, AVG(Pay.PayAmt) AS [��� �޿�]
					FROM EmpMaster_�̿ϻ� AS EM
					INNER JOIN DeptMaster_�̿ϻ� AS D
						ON EM.DeptCd= D.DeptCd
					INNER JOIN PgMaster_�̿ϻ� AS Pg
						ON EM.PgCd = Pg.PgCd
					INNER JOIN PayMaster_�̿ϻ� AS Pay
						ON EM.EmpId = Pay.EmpId
					WHERE 1=1
					AND Pay.PbYm = @pYear 
					AND D.DeptCd = @pDeptCd
					AND Pg.PgCd = @pPgCd 
					GROUP BY Pg.PgCd, Pay.PbYm,  D.DeptCd
			END
	END





--DROP PROCEDURE SP_TEST4_�̿ϻ�
--	DECLARE @pYear char(6)
--	SET @pYear = '201401'
--	ELSE IF NOT EXISTS (SELECT @pDeptCd) && (SELECT @pPgCd)
--		BEGIN
--			RAISERROR('TEST �μ��ڵ�, �����ڵ� �Ѵ� �ȵ���',11,1)
--			RETURN
--		END
--
--		
--

--			
--	
--			--GROUP BY D.DeptNm
--
--				
--			
--/*			
--CREATE TABLE #TEMP 
--SELECT * INTO #TEMP FROM EmpMaster_�̿ϻ�
--SELECT * FROM #TEMP
--DROP TABLE #TEMP
--*/
--/*CREATE TABLE #TEMP
--(	ESA int,
--	S1 int,
--	S2 int,
--	M1 int,
--	M2 int,
--	SA_M int,
--	SA_W int,
--	A_M int,
--	A_W int
--)*/
----DROP TABLE #TEMP
--

