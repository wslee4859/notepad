
use eManage
select DeptID, DeptName from dbo.TB_DEPT WHERE DeptName like '%ȭ��%'



SELECT D.DeptName AS [�μ�], U.UserName AS [�̸�], U.EnableYN AS [LCWare��뿩��]
	, U.HRSyncYN AS [��������] 
FROM dbo.TB_DEPT AS D
	left JOIN dbo.TB_DEPT_USER_HISTORY AS DUH
	ON D.DeptID = DUH.DeptID
	left JOIN dbo.TB_USER AS U
	ON  U.UserID = DUH.UserID
WHERE D.DeptID = '3388'   -- deptID
	AND U.HRSyncYN ='Y'
	AND U.EnableYN ='Y'