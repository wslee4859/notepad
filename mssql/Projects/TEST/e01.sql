USE TestDB
SELECT EM.EmpNm, SUM(P.PayAmt) AS [�� ����]  ,MAX(P.PayAmt) AS [���� ���� ����], MIN(P.PayAmt) AS [���� ���� ����], AVG(P.PayAmt) AS [��� ����]
  FROM EmpMaster_�̿ϻ� AS EM
--EM.DeptCd AS [�μ��ڵ�], D.DeptNm AS [�μ���], P.PbYm, SUM(P.PayAmt)
INNER JOIN DeptMaster_�̿ϻ� AS D
	ON EM.DeptCd = D.DeptCd
RIGHT OUTER JOIN PayMaster_�̿ϻ� AS P
	ON EM.EmpId = P.EmpId

-- GROUP BY P.PbYm , D.DeptCd, D.DeptNm
 GROUP BY EM.EmpNm
ORDER BY [���� ���� ����]

GO
SELECT D.DeptCd AS [�μ��ڵ�], D.DeptNm AS [�μ���], P.PbYm AS [��], SUM(P.PayAmt) AS [�� ����]  ,MAX(P.PayAmt) AS [���� ���� ����], MIN(P.PayAmt) AS [���� ���� ����], AVG(P.PayAmt) AS [��� ����]
  FROM EmpMaster_�̿ϻ� AS EM
--EM.DeptCd AS [�μ��ڵ�], D.DeptNm AS [�μ���], P.PbYm, SUM(P.PayAmt)
INNER JOIN DeptMaster_�̿ϻ� AS D
	ON EM.DeptCd = D.DeptCd
RIGHT OUTER JOIN PayMaster_�̿ϻ� AS P
	ON EM.EmpId = P.EmpId

 GROUP BY P.PbYm , D.DeptCd, D.DeptNm
 -- GROUP BY D.DeptNm, P.PbYm , D.DeptCd 

