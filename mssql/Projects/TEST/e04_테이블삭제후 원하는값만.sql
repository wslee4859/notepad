/*********************** 테이블 삭제후 원하는 결과값만 테이블에 적용 ****************/
DROP TABLE AvgAmt
SELECT De.DeptNm, Pg.PgNm, AVG(PayAmt) AS AvgPayAmt
INTO AvgAmt
	FROM EmpMaster_이완상 AS Em
	LEFT JOIN PgMaster_이완상 AS Pg
		ON Em.PgCd = Pg.PgCd
	LEFT JOIN PayMaster_이완상 AS Pay
		ON Em.EmpId = Pay.EmpId
	LEFT JOIN DeptMaster_이완상 AS De
		ON Em.DeptCd = De.DeptCd	
	WHERE 1=1 
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
		OR Pg.PgNm = 'T4(남)') AND Pay.PbYm = @pYear
	GROUP BY Pg.PgNm, De.DeptNm         
	ORDER BY Pg.PgNm 
/***************************************************************************************/
SELECT D.DeptNm,Pg.PgNm, AVG(Pay.PayAmt) AS [평균 급여]
							FROM EmpMaster_이완상 AS EM
								INNER JOIN DeptMaster_이완상 AS D
									ON EM.DeptCd= D.DeptCd
								INNER JOIN PgMaster_이완상 AS Pg
									ON EM.PgCd = Pg.PgCd
								INNER JOIN PayMaster_이완상 AS Pay
									ON EM.EmpId = Pay.EmpId
							WHERE 1=1
							GROUP BY Pg.PgNm , D.DeptNm