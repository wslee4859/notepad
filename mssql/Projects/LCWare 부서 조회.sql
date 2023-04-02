--LCWare 부서 조회 
use emanage

DECLARE @pUserCD varchar(50),
		@pDeptName nvarchar(200),
		@pUserID int,
		@pDeptID int
--<<<<<<<<<<<<<<<<<<<<<<<<이곳에 사번 등록 >>>>>>>>>>>>>>>>>>>>>>>>>
set @pUserCD ='19025'


-- 부서 검색
 select DeptName FROM dbo.TB_Dept WHERE DeptName like '%화재%' order by DeptName 

-- 사용자 검색
select * from dbo.TB_USER 
WHERE UserCD = @pUserCD AND deletedate > getdate()
-- 검색한 사용자 부서 코드 set
set @pUserID = (select UserID from dbo.TB_USER WHERE UserCD = @pUserCD)

-- 계정 사용자 부서 검색
select D.DeptName from dbo.TB_DEPT AS D
inner join dbo.TB_DEPT_USER_HISTORY AS DUH
ON D.DeptID = DUH.DeptID
WHERE DUH.UserID = @pUserID AND EndDate > getdate()

--해당 부서의 DeptID set
SET @pDeptID = (select top 1 D.DeptID from dbo.TB_DEPT AS D
					inner join dbo.TB_DEPT_USER_HISTORY AS DUH
					ON D.DeptID = DUH.DeptID
				WHERE DUH.UserID = @pUserID AND EndDate > getdate()
							ORDER BY D.DeptID DESC)

select * from tb_dept_user_history where userID = @pUserID AND EndDate > getdate() order by Deptid DESC

-- 부서에 해당하는 인원 검색 
-- select * from dbo.TB_DEPT_USER_HISTORY
SELECT D.DeptName AS [부서], U.UserName AS [이름], U.EnableYN AS [LCWare사용여부]
	, U.HRSyncYN AS [재직여부] 
FROM dbo.TB_DEPT AS D
	left JOIN dbo.TB_DEPT_USER_HISTORY AS DUH
	ON D.DeptID = DUH.DeptID
	left JOIN dbo.TB_USER AS U
	ON  U.UserID = DUH.UserID
WHERE D.DeptID = @pDeptID
	AND U.HRSyncYN ='Y'
	AND U.EnableYN ='Y'


select * from tb_dept

