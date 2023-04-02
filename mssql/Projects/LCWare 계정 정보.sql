--LCWare 사용자 계정 조회 
--  UserCD (사번) 
--raiserror('test',11,1)

use emanage

DECLARE @pUserName nvarchar(50),
		@pUserCD varchar(50)
--<<<<<<<<<<<<<<<<<<<<<<<<이곳에  이름 or 사번 등록하면 나옴 >>>>>>>>>>>>>>>>>>>>>>>>>
set @pUserName = '임동훈' 
set @pUserCD = null
--<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< null로 표기  >>>>>>>>>>><<<<<<<>>>>>>>><<<<<<>>>><<<<<<


if @pUserCD is null
	begin
		select * from dbo.TB_USER
		where 1=1 
			and userName = @pUserName
		
	end
else if(@pUserName is null)
	begin
		select * from dbo.TB_USER
		where 1=1 
			--and userName = @pUserName
			and UserCD = @pUserCD
	end

--사용자 계정 부서 
SELECT D.DeptName AS [부서], U.UserName AS [이름] , U.UserAccount , JikG.CodeName AS [직군], 
		JikC.CodeName AS [직책], JikW.CodeName AS [직위], U.EmpID, U.DeleteDate
FROM dbo.TB_DEPT_USER_HISTORY AS DUH
	INNER JOIN dbo.TB_DEPT AS D
		ON DUH.DeptID = D.DeptID
	INNER JOIN dbo.TB_USER AS U
		ON DUH.UserID =U.UserID
	INNER JOIN dbo.TB_CODE_SUB AS JikG
		ON DUH.JikGeupID = JikG.SubCode AND JikG.ClassCode = '10JG'
	INNER JOIN dbo.TB_CODE_SUB AS JikC
		ON DUH.JikChaekID = JikC.SubCode AND JikC.ClassCode = '10JC'
	INNER JOIN dbo.TB_CODE_SUB AS JikW
		ON DUH.JikWiID = JikW.SubCode AND JikW.ClassCode = '10JW'
where U.userName = @pUserName

