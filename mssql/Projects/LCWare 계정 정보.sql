--LCWare ����� ���� ��ȸ 
--  UserCD (���) 
--raiserror('test',11,1)

use emanage

DECLARE @pUserName nvarchar(50),
		@pUserCD varchar(50)
--<<<<<<<<<<<<<<<<<<<<<<<<�̰���  �̸� or ��� ����ϸ� ���� >>>>>>>>>>>>>>>>>>>>>>>>>
set @pUserName = '�ӵ���' 
set @pUserCD = null
--<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< null�� ǥ��  >>>>>>>>>>><<<<<<<>>>>>>>><<<<<<>>>><<<<<<


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

--����� ���� �μ� 
SELECT D.DeptName AS [�μ�], U.UserName AS [�̸�] , U.UserAccount , JikG.CodeName AS [����], 
		JikC.CodeName AS [��å], JikW.CodeName AS [����], U.EmpID, U.DeleteDate
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

