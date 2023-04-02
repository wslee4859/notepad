1. 
-- 임시 테이블 
use ERP_EKW_DTS
select * from [dbo].[IM_DEPT_USER] where EmpID = '20150335'
select * from [dbo].[IM_DEPT] where DeptCd = '00273'
select * from [dbo].[IM_USER] where empid = '20150335'


select * from [dbo].[TE_USER] where EmpID = '20150335'
--select * from [dbo].[TE_GROUP_USER] where UserID = '137650'
select * from [dbo].[TE_DEPT]

-- TE_USER enableYN = Y 로 변경
begin tran 
update [dbo].[TE_USER]
set EnableYN = 'Y'
where EmpID = '20150335'
--commit

begin tran 
update [dbo].[IM_USER]
set EnableYN = 'Y'
where EmpID = '20150335'


-- 위의 값 변경 후 배치작업(음료 IM-EKW 총괄)



2. 
-- 사용자 검색
-- 
use eManage
select * from [dbo].[TB_USER] where UserName = '전준'

-- 부서 변동시 
select * from [dbo].[TB_DEPT_USER_HISTORY] where UserID = '143099'
select * from [dbo].[TB_DEPT] where deptid = '2759'



-- 구 전자결재 사용하기 위해서는 신규 포탈 계정, 메일주소, 메일사서함(임의) 로 값을 업데이트 해줘야 함. 
begin tran
update [dbo].[TB_USER] 
set UserAccount = 'kbs88',
	MailAddress = 'kbs88@lottechilsung.co.kr',
	MailServer = 'ekw2bMail2'
where UserCD = '20150875'

--commit
select @@trancount
--rollback




