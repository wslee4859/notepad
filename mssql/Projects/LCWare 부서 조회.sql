--LCWare �μ� ��ȸ 
use emanage

DECLARE @pUserCD varchar(50),
		@pDeptName nvarchar(200),
		@pUserID int,
		@pDeptID int
--<<<<<<<<<<<<<<<<<<<<<<<<�̰��� ��� ��� >>>>>>>>>>>>>>>>>>>>>>>>>
set @pUserCD ='19025'


-- �μ� �˻�
 select DeptName FROM dbo.TB_Dept WHERE DeptName like '%ȭ��%' order by DeptName 

-- ����� �˻�
select * from dbo.TB_USER 
WHERE UserCD = @pUserCD AND deletedate > getdate()
-- �˻��� ����� �μ� �ڵ� set
set @pUserID = (select UserID from dbo.TB_USER WHERE UserCD = @pUserCD)

-- ���� ����� �μ� �˻�
select D.DeptName from dbo.TB_DEPT AS D
inner join dbo.TB_DEPT_USER_HISTORY AS DUH
ON D.DeptID = DUH.DeptID
WHERE DUH.UserID = @pUserID AND EndDate > getdate()

--�ش� �μ��� DeptID set
SET @pDeptID = (select top 1 D.DeptID from dbo.TB_DEPT AS D
					inner join dbo.TB_DEPT_USER_HISTORY AS DUH
					ON D.DeptID = DUH.DeptID
				WHERE DUH.UserID = @pUserID AND EndDate > getdate()
							ORDER BY D.DeptID DESC)

select * from tb_dept_user_history where userID = @pUserID AND EndDate > getdate() order by Deptid DESC

-- �μ��� �ش��ϴ� �ο� �˻� 
-- select * from dbo.TB_DEPT_USER_HISTORY
SELECT D.DeptName AS [�μ�], U.UserName AS [�̸�], U.EnableYN AS [LCWare��뿩��]
	, U.HRSyncYN AS [��������] 
FROM dbo.TB_DEPT AS D
	left JOIN dbo.TB_DEPT_USER_HISTORY AS DUH
	ON D.DeptID = DUH.DeptID
	left JOIN dbo.TB_USER AS U
	ON  U.UserID = DUH.UserID
WHERE D.DeptID = @pDeptID
	AND U.HRSyncYN ='Y'
	AND U.EnableYN ='Y'


select * from tb_dept

