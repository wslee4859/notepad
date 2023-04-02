ALTER PROCEDURE SP_EXAM1_급여계산_이완상
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
SELECT * INTO #TEMP FROM EmpMaster_이완상    -- 임시 테이블 생성
ALTER TABLE #TEMP							-- 테이블 열(번호) 추가 
	ADD num INT IDENTITY NOT NULL 
-- SELECT * FROM #TEMP
-- DROP TABLE #TEMP
	SET @pCnt = 1
-- 같은 년도에 값이 있을 경우 그 년도 값 삭제 
IF EXISTS (SELECT YearMM FROM PayMaster_NEW_이완상 WHERE YearMM = @pYear)
	BEGIN
		DELETE PayMaster_NEW_이완상 WHERE YearMM = @pYear
	END
-- 계산 구문
	WHILE (@pCnt <= 200)
		BEGIN
			-- 기본급 
			SET @pPgAmt = (SELECT Pg.PgAmt FROM #TEMP AS Em
									LEFT JOIN PayMaster_기본급_이완상 AS Pg
										ON Em.PgCd = Pg.PgCd
									WHERE 1=1 
										AND Em.num = @pCnt )
			-- 직무수당이 0 일경우
			IF (SELECT Jp.JpAmt FROM #TEMP AS Em   
									LEFT JOIN PayMaster_직무수당_이완상 AS Jp
										ON Em.JpCd = Jp.jpCd
									WHERE 1=1
										AND Em.num = @pCnt ) IS NULL
				BEGIN
					SET @pJpAmt = 0
				END
			-- 직무 수당이 0이 아니면
			ELSE  
				BEGIN		
					SET @pJpAmt = (SELECT Jp.JpAmt FROM #TEMP AS Em
											LEFT JOIN PayMaster_직무수당_이완상 AS Jp
												ON Em.JpCd = Jp.jpCd
											WHERE 1=1
												AND Em.num = @pCnt )
				END

			SET @pTax = (@pPgAmt + @pJpAmt) * 0.1  -- 세금  ? 변수값 정수
			
			SET @pRealAmt = (@pPgAmt + @pJpAmt) - @pTax   -- 실수령액 
			
			INSERT INTO PayMaster_NEW_이완상 SELECT EmpID, @pYear, @pPgAmt, @pJpAmt, @pTax, @pRealAmt 
												FROM #TEMP	WHERE 1=1 AND num=@pCnt 

			SET @pCnt = @pCnt + 1 -- 카운터 
		END
		--END



/*
DECLARE	@pPgAmt INT,
		@pCnt INT
SET @pCnt = 1
WHILE (@pCnt <= 200)
	BEGIN
	SET @pPgAmt = (SELECT Pg.PgAmt FROM #TEMP AS Em
							LEFT JOIN PayMaster_기본급_김아름 AS Pg
								ON Em.PgCd = Pg.PgCd
							WHERE 1=1 
								AND Em.num = @pCnt)
	SET @pCnt = @pCnt + 1
	SELECT @pPgAmt
	END
*/
				