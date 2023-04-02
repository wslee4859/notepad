
use eManage
select DeptID, DeptName from dbo.TB_DEPT WHERE DeptName like '%화재%'



SELECT D.DeptName AS [부서], U.UserName AS [이름], U.EnableYN AS [LCWare사용여부]
	, U.HRSyncYN AS [재직여부] 
FROM dbo.TB_DEPT AS D
	left JOIN dbo.TB_DEPT_USER_HISTORY AS DUH
	ON D.DeptID = DUH.DeptID
	left JOIN dbo.TB_USER AS U
	ON  U.UserID = DUH.UserID
WHERE D.DeptID = '3388'   -- deptID
	AND U.HRSyncYN ='Y'
	AND U.EnableYN ='Y'