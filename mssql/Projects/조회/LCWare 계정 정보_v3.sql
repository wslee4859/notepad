--LCWare ����� ���� ��ȸ 
--  UserCD (���) 
--raiserror('test',11,1)


-- TB_USER ������ DeleteDate
-- HISTORY ������ EndDate
use [eManage]

DECLARE @pUserName nvarchar(50),
		@pUserCD varchar(50)
--<<<<<<<<<<<<<<<<<<<<<<<<�̰���  �̸� or ��� ����ϸ� ���� >>>>>>>>>>>>>>>>>>>>>>>>>
set @pUserName = '����ȯ' 
set @pUserCD = null
--<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< null�� ǥ��  >>>>>>>>>>><<<<<<<>>>>>>>><<<<<<>>>><<<<<<

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


-- ����� ���� �μ� 
SELECT D.DeptName AS [�μ�], U.UserName AS [�̸�] , U.UserAccount , JikG.CodeName AS [����], 
		JikC.CodeName AS [��å], JikW.CodeName AS [����], U.EmpID, U.DeleteDate, U.MailAddress 
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


