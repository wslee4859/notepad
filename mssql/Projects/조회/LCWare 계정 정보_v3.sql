--LCWare 사용자 계정 조회 
--  UserCD (사번) 
--raiserror('test',11,1)


-- TB_USER 에서는 DeleteDate
-- HISTORY 에서는 EndDate
use [eManage]

DECLARE @pUserName nvarchar(50),
		@pUserCD varchar(50)
--<<<<<<<<<<<<<<<<<<<<<<<<이곳에  이름 or 사번 등록하면 나옴 >>>>>>>>>>>>>>>>>>>>>>>>>
set @pUserName = '정용환' 
set @pUserCD = null
--<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< null로 표기  >>>>>>>>>>><<<<<<<>>>>>>>><<<<<<>>>><<<<<<

if @pUserCD is not null
	begin
		select * from dbo.TB_USER
		where 1=1 
			and UserCD = @pUserCD
			and DeleteDate > getdate()
		
	end
else if(@pUserName is not null)
	begin
		select * from dbo.TB_USER
		where 1=1 
			and UserName = @pUserName
			and DeleteDate > getdate()
		--set @pUserName = (select UserName from dbo.TB_USER	where UserName = @pUserName)
	end


-- 사용자 계정 부서 
SELECT D.DeptName AS [부서], U.UserName AS [이름] , U.UserAccount , JikG.CodeName AS [직군], 
		JikC.CodeName AS [직책], JikW.CodeName AS [직위], U.EmpID, U.DeleteDate, U.MailAddress 
FROM dbo.TB_DEPT_USER_HISTORY AS DUH
	INNER JOIN dbo.TB_DEPT AS D
		ON DUH.DeptID = D.DeptID
	INNER JOIN dbo.TB_USER AS U
		ON DUH.UserID =U.UserID
	left JOIN dbo.TB_CODE_SUB AS JikG
		ON DUH.JikGeupID = JikG.SubCode AND JikG.ClassCode = '10JG'
	left JOIN dbo.TB_CODE_SUB AS JikC
		ON DUH.JikChaekID = JikC.SubCode AND JikC.ClassCode = '10JC'
	left JOIN dbo.TB_CODE_SUB AS JikW
		ON DUH.JikWiID = JikW.SubCode AND JikW.ClassCode = '10JW'
where (U.userName = @pUserName or U.userCD = @pUserCd) AND U.DeleteDate > getdate() AND DUH.EndDate > getdate()

--select * from dbo.TB_DEPT_USER_HISTORY WHERE UserID = '114045'
--select * from dbo.TB_CODE_SUB


