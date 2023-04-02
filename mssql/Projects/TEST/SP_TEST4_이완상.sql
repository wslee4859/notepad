ALTER PROCEDURE SP_TEST4_이완상
	@pYear char(6),
	@pDeptCd char(5),
	@pPgCd char(8)
AS
	IF @pYear = ' '  -- 년월 입력 안될 시 
	--IF NOT EXISTS (SELECT @pYear)
		BEGIN
			RAISERROR('년월을 입력해주시기 바랍니다.!',11,1)
			RETURN
		END
	ELSE IF @pDeptCd = ' ' AND @pPgCd = ' '      -- 부서코드 직급코드 둘다 안들어올 때 
		BEGIN
			RAISERROR('TEST : 부서코드, 직급코드 둘다 안들어옴',11,1)
						EXEC SP_TEST04_DROP
						EXEC SP_TEST04_CREATE
--				DECLARE
--			    @pYear char(6)
--				SET @pYear = '201401'
				SELECT D.DeptNm,Pg.PgNm, AVG(Pay.PayAmt) AS AvgPayAmt
				INTO AvgAmt
							FROM EmpMaster_이완상 AS EM
								INNER JOIN DeptMaster_이완상 AS D
									ON EM.DeptCd= D.DeptCd
								INNER JOIN PgMaster_이완상 AS Pg
									ON EM.PgCd = Pg.PgCd
								INNER JOIN PayMaster_이완상 AS Pay
									ON EM.EmpId = Pay.EmpId
							WHERE 1=1
									AND	Pay.PbYm = @pYear 
									AND (Pg.PgNm = '이사대우'
										OR Pg.PgNm = 'S1'
										OR Pg.PgNm = 'S2'
										OR Pg.PgNm = 'M1'
										OR Pg.PgNm = 'M2'
										OR Pg.PgNm = 'SA(남)'
										OR Pg.PgNm = 'SA(여)'
										OR Pg.PgNm = 'A(남)'
										OR Pg.PgNm = 'T1(남)'
										OR Pg.PgNm = 'T2(남)'
										OR Pg.PgNm = 'T3(남)'
										OR Pg.PgNm = 'T4(남)')
							GROUP BY Pg.PgNm , D.DeptNm
					EXEC SP_TEST04_INSERT
					EXEC SP_TEST04_PRINT
					DROP TABLE AvgAmt
					DROP TABLE DeptNm
			RETURN
		END
	ELSE IF @pDeptCd = ' ' OR @pPgCd = ' '       -- 부서코드 직급코드 둘 중 하나 안들어올 때 -> 부서코드, 직급코드 따로
		BEGIN
			RAISERROR('TEST : 부서코드, 직급코드 중 하나 안들어옴',11,1)
				IF @pDeptCd = ' '   -- 부서 코드 입력 안될 때 
					BEGIN				-- 모든 부서 평균 급여 계산 
						RAISERROR('TEST : 부서코드 안들어옴',11,1)
						SELECT Pg.PgNm,D.DeptNm, AVG(Pay.PayAmt) AS [평균 급여]
						FROM EmpMaster_이완상 AS EM
							INNER JOIN DeptMaster_이완상 AS D
								ON EM.DeptCd= D.DeptCd
							INNER JOIN PgMaster_이완상 AS Pg
								ON EM.PgCd = Pg.PgCd
							INNER JOIN PayMaster_이완상 AS Pay
								ON EM.EmpId = Pay.EmpId
						WHERE 1=1
								AND	Pay.PbYm = @pYear		
								AND Pg.PgCd = @pPgCd
						GROUP BY D.DeptNm, Pg.PgNm
					END 
		--	DECLARE @pYear char(6)
		--	SET @pYear = '201404'
				IF @pPgCd = ' '			-- 직급 코드 입력 안될 때 
					BEGIN				-- 모든 직급 평균 급여 계산 
						RAISERROR('TEST : 직급코드 안들어옴',11,1)
						SELECT D.DeptNm , Pg.PgNm, AVG(Pay.PayAmt) AS [평균 급여]
						FROM EmpMaster_이완상 AS EM
							INNER JOIN DeptMaster_이완상 AS D
								ON EM.DeptCd= D.DeptCd
							INNER JOIN PgMaster_이완상 AS Pg
								ON EM.PgCd = Pg.PgCd
							INNER JOIN PayMaster_이완상 AS Pay
								ON EM.EmpId = Pay.EmpId
						WHERE 1=1
								AND D.DeptCd = @pDeptCd
								AND Pay.PbYm = @pYear	
						GROUP BY Pg.PgNm, D.DeptNm  
					END 
		END
ELSE   	/************************** 모든 값 입력 되었을 때 ****************************************/
	BEGIN
		IF (	SELECT AVG(Pay.PayAmt) AS [평균 급여]   -- 조회할 데이터(평균 급여 값이 없을 경우)
					FROM EmpMaster_이완상 AS EM
					INNER JOIN DeptMaster_이완상 AS D
						ON EM.DeptCd= D.DeptCd
					INNER JOIN PgMaster_이완상 AS Pg
						ON EM.PgCd = Pg.PgCd
					INNER JOIN PayMaster_이완상 AS Pay
						ON EM.EmpId = Pay.EmpId
					WHERE 1=1
					AND Pay.PbYm = @pYear 
					AND D.DeptCd = @pDeptCd
					AND Pg.PgCd = @pPgCd 
					--AND AVG(Pay.PayAmt) > 20000
					GROUP BY Pay.PbYm, Pg.PgCd, D.DeptCd
				  ) IS NULL
			BEGIN
				RAISERROR('TEST : 조회할 데이터가 없습니다.',11,1)
			END
		ELSE
			BEGIN
				SELECT  D.DeptCd, Pg.PgCd, Pay.PbYm, AVG(Pay.PayAmt) AS [평균 급여]
					FROM EmpMaster_이완상 AS EM
					INNER JOIN DeptMaster_이완상 AS D
						ON EM.DeptCd= D.DeptCd
					INNER JOIN PgMaster_이완상 AS Pg
						ON EM.PgCd = Pg.PgCd
					INNER JOIN PayMaster_이완상 AS Pay
						ON EM.EmpId = Pay.EmpId
					WHERE 1=1
					AND Pay.PbYm = @pYear 
					AND D.DeptCd = @pDeptCd
					AND Pg.PgCd = @pPgCd 
					GROUP BY Pg.PgCd, Pay.PbYm,  D.DeptCd
			END
	END





--DROP PROCEDURE SP_TEST4_이완상
--	DECLARE @pYear char(6)
--	SET @pYear = '201401'
--	ELSE IF NOT EXISTS (SELECT @pDeptCd) && (SELECT @pPgCd)
--		BEGIN
--			RAISERROR('TEST 부서코드, 직급코드 둘다 안들어옴',11,1)
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
--SELECT * INTO #TEMP FROM EmpMaster_이완상
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

