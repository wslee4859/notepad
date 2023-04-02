
use ERP_EKW_DTS

DECLARE @EmpID nvarchar(10)
set @EmpID = '20145102'

--해당 사번으로 부서 매핑값 확인 
select * from [dbo].[TE_USER] where EmpID = @EmpID
select * from [dbo].[IM_USER] where EmpID = @EmpID
01028   
-- TE
select * from [dbo].[TE_DEPT_USER] where EmpID = '20145102'
select * from [dbo].[TE_DEPT] where DeptCd in ( select DeptCd from [dbo].[TE_DEPT_USER] where EmpID = '20145102' )
	-- 직급
select * from [dbo].[TE_CODE_SUB]  where SubCode in ( select JikGeupID from [dbo].[TE_DEPT_USER] where EmpID = '20145102' ) AND ClassCode = '10JG'
	-- 직무
select * from [dbo].[TE_CODE_SUB]  where SubCode in ( select JikMuID from [dbo].[TE_DEPT_USER] where EmpID = '20145102' ) AND ClassCode = '10JW'
	-- 직책
select * from [dbo].[TE_CODE_SUB]  where SubCode in ( select JikChaekID from [dbo].[TE_DEPT_USER] where EmpID = '20145102' ) AND ClassCode = '10JC'


-- IM 
select * from [dbo].[IM_DEPT_USER] where  EmpID = '20145102'
select * from [dbo].[IM_DEPT] where DeptCd = '00276'



--변경 될 부서CD 찾기 
select * from [dbo].[TE_DEPT] where deptname like '%경주지점%' -- 00276                 (백업 : 00269   )
select * from [dbo].[TE_DEPT] where DeptCd = '00276'

-- 변경 될 직무 찾기 
select * from [dbo].[TE_CODE_SUB] where CodeName like '%지점업무%'   -- 0048    




begin tran 
update [dbo].[TE_DEPT_USER] 
set DeptCd = '00276', JikMuID = '0048'
where  EmpID = '20145102'

update [dbo].[IM_DEPT_USER]
set DeptCd = '00276', JikMuID = '0048'
where  EmpID = '20145102' 

--   commit



use eManage
select * from [dbo].[TB_USER] where Usercd = '20145102'
select * from [dbo].[TB_DEPT_USER_HISTORY] where UserID in (select UserID from [dbo].[TB_USER] where Usercd = '20145102') AND EndDate > getdate()
select * from [dbo].[TB_DEPT] where DeptID = '2690'