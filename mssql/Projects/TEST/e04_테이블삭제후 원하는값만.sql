/*********************** ���̺� ������ ���ϴ� ������� ���̺� ���� ****************/
DROP TABLE AvgAmt
SELECT De.DeptNm, Pg.PgNm, AVG(PayAmt) AS AvgPayAmt
INTO AvgAmt
	FROM EmpMaster_�̿ϻ� AS Em
	LEFT JOIN PgMaster_�̿ϻ� AS Pg
		ON Em.PgCd = Pg.PgCd
	LEFT JOIN PayMaster_�̿ϻ� AS Pay
		ON Em.EmpId = Pay.EmpId
	LEFT JOIN DeptMaster_�̿ϻ� AS De
		ON Em.DeptCd = De.DeptCd	
	WHERE 1=1 
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
		OR Pg.PgNm = 'T4(��)') AND Pay.PbYm = @pYear
	GROUP BY Pg.PgNm, De.DeptNm         
	ORDER BY Pg.PgNm 
/***************************************************************************************/
SELECT D.DeptNm,Pg.PgNm, AVG(Pay.PayAmt) AS [��� �޿�]
							FROM EmpMaster_�̿ϻ� AS EM
								INNER JOIN DeptMaster_�̿ϻ� AS D
									ON EM.DeptCd= D.DeptCd
								INNER JOIN PgMaster_�̿ϻ� AS Pg
									ON EM.PgCd = Pg.PgCd
								INNER JOIN PayMaster_�̿ϻ� AS Pay
									ON EM.EmpId = Pay.EmpId
							WHERE 1=1
							GROUP BY Pg.PgNm , D.DeptNm