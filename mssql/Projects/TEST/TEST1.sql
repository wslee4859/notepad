/*			Pg.PgNm = '이사대우'
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
		OR Pg.PgNm = 'T4(남)'*/

EXEC SP_TEST4_이완상 '201404','',''

					SELECT Pg.PgNm,D.DeptNm, Pay.PbYm, AVG(Pay.PayAmt) AS [평균 급여]
						FROM EmpMaster_이완상 AS EM
							INNER JOIN DeptMaster_이완상 AS D
								ON EM.DeptCd= D.DeptCd
							INNER JOIN PgMaster_이완상 AS Pg
								ON EM.PgCd = Pg.PgCd
							INNER JOIN PayMaster_이완상 AS Pay
								ON EM.EmpId = Pay.EmpId
						WHERE 1=1							
						AND D.DeptNm ='안성환경기술담당'
						GROUP BY D.DeptNm, Pg.PgNm, Pay.PbYm
		
					SELECT Pg.PgNm,D.DeptNm, AVG(Pay.PayAmt) AS [평균 급여]
								FROM EmpMaster_이완상 AS EM
							INNER JOIN DeptMaster_이완상 AS D
								ON EM.DeptCd= D.DeptCd
							INNER JOIN PgMaster_이완상 AS Pg
								ON EM.PgCd = Pg.PgCd
							INNER JOIN PayMaster_이완상 AS Pay
								ON EM.EmpId = Pay.EmpId
						WHERE 1=1							
						AND D.DeptNm ='안성환경기술담당'
						AND Pay.PbYm ='201404'
						GROUP BY D.DeptNm, Pg.PgNm
					
					SELECT Pg.PgNm,D.DeptNm, AVG(Pay.PayAmt) AS [평균 급여]
						FROM EmpMaster_이완상 AS EM
							INNER JOIN DeptMaster_이완상 AS D
								ON EM.DeptCd= D.DeptCd
							INNER JOIN PgMaster_이완상 AS Pg
								ON EM.PgCd = Pg.PgCd
							INNER JOIN PayMaster_이완상 AS Pay
								ON EM.EmpId = Pay.EmpId
						WHERE 1=1
						AND Pay.PbYm ='201411'							
						AND D.DeptNm ='광주생산담당'
						GROUP BY D.DeptNm, Pg.PgNm

CREATE TABLE E4 
(	DeptNm varchar(40),
	PbYm varchar(40),
	Amt INT
)
CREATE TABLE S1 
(	DeptNm varchar(40),
	PbYm varchar(40),
	Amt INT
)

CREATE TABLE S2
(	DeptNm varchar(40),
	PbYm varchar(40),
	Amt INT
)

CREATE TABLE M1
(	DeptNm varchar(40),
	PbYm varchar(40),
	Amt INT
)
CREATE TABLE M2
(	DeptNm varchar(40),
	PbYm varchar(40),
	Amt INT
)
CREATE TABLE SA_M
(	DeptNm varchar(40),
	PbYm varchar(40),
	Amt INT
)
CREATE TABLE SA_W
(	DeptNm varchar(40),
	PbYm varchar(40),
	Amt INT
)
CREATE TABLE A_M               -- A(남)
(	DeptNm varchar(40), 
	PbYm varchar(40),
	Amt INT
)
CREATE TABLE T1
(	DeptNm varchar(40),
	PbYm varchar(40),
	Amt INT
)
CREATE TABLE T2
(	DeptNm varchar(40),
	PbYm varchar(40),
	Amt INT
)
CREATE TABLE T3
(	DeptNm varchar(40),	
	PbYm varchar(40),
	Amt INT
)
CREATE TABLE T4
(	DeptNm varchar(40),
	PbYm varchar(40),
	Amt INT
)
/************************************* 직급 테이블 생성 *****************************************************/

/*************************************  테이블 삭제 ********************************************************/

DROP TABLE E4
DROP TABLE S1
DROP TABLE S2
DROP TABLE M1
DROP TABLE M2
DROP TABLE SA_M
DROP TABLE SA_W
DROP TABLE A_M
DROP TABLE T1
DROP TABLE T2
DROP TABLE T3
DROP TABLE T4


SELECT * FROM DeptNm WHERE PbYm = '201401'
SELECT * FROM E4
SELECT * FROM S1
SELECT * FROM S2
SELECT * FROM T2 WHERE PbYm =  '201401' ORDER BY DeptNm

DECLEAR 

SELECT De.DeptNm AS [부서명/직급명], E4.Amt, S1.Amt, S2.Amt, M1.Amt, M2.Amt, SA_M.Amt, SA_W.Amt, A_M.Amt, 
		T1.Amt, T2.Amt, T3.Amt, T4.Amt
	FROM DeptNm AS De
		LEFT JOIN E4
			ON De.DeptNm = E4.DeptNm AND De.PbYm = E4.PbYm
		LEFT JOIN S1
			ON De.DeptNm = S1.DeptNm
		LEFT JOIN S2
			ON De.DeptNm = S2.DeptNm
		LEFT JOIN M1
			ON De.DeptNm = M1.DeptNm
		LEFT JOIN M2
			ON De.DeptNm = M2.DeptNm
		LEFT JOIN SA_M
			ON De.DeptNm = SA_M.DeptNm
		LEFT JOIN SA_W
			ON De.DeptNm = SA_W.DeptNm
		LEFT JOIN A_M
			ON De.DeptNm = A_M.DeptNm
		LEFT JOIN T1
			ON De.DeptNm = T1.DeptNm
		LEFT JOIN T2
			ON De.DeptNm = T2.DeptNm
		LEFT JOIN T3
			ON De.DeptNm = T3.DeptNm
		LEFT JOIN T4
			ON De.DeptNm = T4.DeptNm 
	WHERE De.PbYm = '201401'
	GROUP BY 



	/*WHERE 1=1
		AND E4.PbYm = '201401'
		AND S1.PbYm = '201401'
		AND S2.PbYm = '201401'
		AND M1.PbYm = '201401'
		AND M2.PbYm = '201401'
		AND SA_M.PbYm = '201401'
		AND SA_W.PbYm = '201401'
		AND A_M.PbYm = '201401'
		AND T1.PbYm = '201401'
		AND T2.PbYm = '201401'
		AND T3.PbYm = '201401'
		AND T4.PbYm = '201401'*/
	

INSERT INTO E4 SELECT DeptNm, PbYm, AvgPayAmt FROM AvgAmt WHERE PgNm = '이사대우' 
INSERT INTO S1 SELECT DeptNm, PbYm,  AvgPayAmt FROM AvgAmt WHERE PgNm = 'S1' 
INSERT INTO S2 SELECT DeptNm, PbYm, AvgPayAmt FROM AvgAmt WHERE PgNm = 'S2' 
INSERT INTO M1 SELECT DeptNm, PbYm, AvgPayAmt FROM AvgAmt WHERE PgNm = 'M1' 
INSERT INTO M2 SELECT DeptNm, PbYm, AvgPayAmt FROM AvgAmt WHERE PgNm = 'M2' 
INSERT INTO SA_M SELECT DeptNm, PbYm,  AvgPayAmt FROM AvgAmt WHERE PgNm = 'SA(남)' 
INSERT INTO SA_W SELECT DeptNm, PbYm,  AvgPayAmt FROM AvgAmt WHERE PgNm = 'SA(여)' 
INSERT INTO A_M SELECT DeptNm, PbYm,  AvgPayAmt FROM AvgAmt WHERE PgNm = 'A(남)' 
INSERT INTO T1 SELECT DeptNm, PbYm,  AvgPayAmt FROM AvgAmt WHERE PgNm = 'T1(남)' 
INSERT INTO T2 SELECT DeptNm, PbYm,  AvgPayAmt FROM AvgAmt WHERE PgNm = 'T2(남)' 
INSERT INTO T3 SELECT DeptNm, PbYm,  AvgPayAmt FROM AvgAmt WHERE PgNm = 'T3(남)' 
INSERT INTO T4 SELECT DeptNm, PbYm,  AvgPayAmt FROM AvgAmt WHERE PgNm = 'T4(남)' 


SELECT * FROM test 

SELECT * FROM E4
SELECT * FROM S1
SELECT * FROM S2

SELECT DeptNm, PbYm 
INTO DeptNm
FROM AvgAmt GROUP BY DeptNm, PbYm

SELECT * FROM AvgAmt

DROP TABLE DeptNm

