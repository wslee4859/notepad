ALTER PROCEDURE SP_EXAM1_급여조회_이완상
	@pYear char(6),
	@pDeptCd char(5)
AS
IF @pYear = ANY(SELECT YearMM FROM PayMaster_NEW_이완상 GROUP BY YearMM)
	BEGIN
		IF @pDeptCd = ''
			BEGIN
				SELECT Em.EmpId AS [사원번호], 
						Em.EmpNm AS [사원명],
						D.DeptNm AS [부서명],
						Pg.PgNm AS [직급명],
						Jp.JpNm AS [직무명],
						Pay.PgAmt AS [기본급],
						Pay.JpAmt AS [직무수당],
						Pay.Tax As [세금],
						Pay.RealAmt AS [실수령액]
				FROM EmpMaster_이완상 AS Em
					LEFT JOIN DeptMaster_이완상 AS D
						ON Em.DeptCd = D.DeptCd
					LEFT JOIN PgMaster_이완상 AS Pg
						ON Em.PgCd = Pg.PgCd
					LEFT JOIN JpMaster_이완상 AS Jp
						ON Em.JpCd = Jp.JpCd
					LEFT JOIN PayMaster_NEW_이완상 AS Pay
						ON Em.EmpId = Pay.EmpId
					WHERE 1=1
						AND Pay.YearMM = @pYear
					ORDER BY Pay.RealAmt DESC
			END
		ELSE IF @pDeptCd = ANY(SELECT Em.DeptCd FROM PayMaster_NEW_이완상 AS Pay
									INNER JOIN EmpMaster_이완상 AS Em
									ON  Pay.EmpID = Em.EmpId 
									GROUP BY Em.DeptCd)
			BEGIN
				SELECT Em.EmpId AS [사원번호], 
						Em.EmpNm AS [사원명],
						D.DeptNm AS [부서명],
						Pg.PgNm AS [직급명],
						Jp.JpNm AS [직무명],
						Pay.PgAmt AS [기본급],
						Pay.JpAmt AS [직무수당],
						Pay.Tax As [세금],
						Pay.RealAmt AS [실수령액]
				FROM EmpMaster_이완상 AS Em
					LEFT JOIN DeptMaster_이완상 AS D
						ON Em.DeptCd = D.DeptCd
					LEFT JOIN PgMaster_이완상 AS Pg
						ON Em.PgCd = Pg.PgCd
					LEFT JOIN JpMaster_이완상 AS Jp
						ON Em.JpCd = Jp.JpCd
					LEFT JOIN PayMaster_NEW_이완상 AS Pay
						ON Em.EmpId = Pay.EmpId
					WHERE 1=1
						AND Em.DeptCd = @pDeptCd
						AND Pay.YearMM = @pYear
					ORDER BY Pay.RealAmt DESC
			END
		ELSE
			BEGIN
				RAISERROR('존재하지 않는 부서코드 입니다!',11,2)
			END
				
	END
ELSE 
	BEGIN
		RAISERROR('조회값을 입력하세요 : (YYYYMM)',11,2)
		RETURN
	END
 

		
		


--	GROUP BY 


		
	