USE TestDB
SELECT EM.EmpNm, SUM(P.PayAmt) AS [총 월급]  ,MAX(P.PayAmt) AS [가장 높은 월급], MIN(P.PayAmt) AS [가장 낮은 월급], AVG(P.PayAmt) AS [평균 월급]
  FROM EmpMaster_이완상 AS EM
--EM.DeptCd AS [부서코드], D.DeptNm AS [부서명], P.PbYm, SUM(P.PayAmt)
INNER JOIN DeptMaster_이완상 AS D
	ON EM.DeptCd = D.DeptCd
RIGHT OUTER JOIN PayMaster_이완상 AS P
	ON EM.EmpId = P.EmpId

-- GROUP BY P.PbYm , D.DeptCd, D.DeptNm
 GROUP BY EM.EmpNm
ORDER BY [가장 높은 월급]

GO
SELECT D.DeptCd AS [부서코드], D.DeptNm AS [부서명], P.PbYm AS [월], SUM(P.PayAmt) AS [총 월급]  ,MAX(P.PayAmt) AS [가장 높은 월급], MIN(P.PayAmt) AS [가장 낮은 월급], AVG(P.PayAmt) AS [평균 월급]
  FROM EmpMaster_이완상 AS EM
--EM.DeptCd AS [부서코드], D.DeptNm AS [부서명], P.PbYm, SUM(P.PayAmt)
INNER JOIN DeptMaster_이완상 AS D
	ON EM.DeptCd = D.DeptCd
RIGHT OUTER JOIN PayMaster_이완상 AS P
	ON EM.EmpId = P.EmpId

 GROUP BY P.PbYm , D.DeptCd, D.DeptNm
 -- GROUP BY D.DeptNm, P.PbYm , D.DeptCd 

