1. 
-- �ӽ� ���̺� 
use ERP_EKW_DTS
select * from [dbo].[IM_DEPT_USER] where EmpID = '20150335'
select * from [dbo].[IM_DEPT] where DeptCd = '00273'
select * from [dbo].[IM_USER] where empid = '20150335'


select * from [dbo].[TE_USER] where EmpID = '20150335'
--select * from [dbo].[TE_GROUP_USER] where UserID = '137650'
select * from [dbo].[TE_DEPT]

-- TE_USER enableYN = Y �� ����
begin tran 
update [dbo].[TE_USER]
set EnableYN = 'Y'
where EmpID = '20150335'
--commit

begin tran 
update [dbo].[IM_USER]
set EnableYN = 'Y'
where EmpID = '20150335'


-- ���� �� ���� �� ��ġ�۾�(���� IM-EKW �Ѱ�)



2. 
-- ����� �˻�
-- 
use eManage
select * from [dbo].[TB_USER] where UserName = '����'

-- �μ� ������ 
select * from [dbo].[TB_DEPT_USER_HISTORY] where UserID = '143099'
select * from [dbo].[TB_DEPT] where deptid = '2759'



-- �� ���ڰ��� ����ϱ� ���ؼ��� �ű� ��Ż ����, �����ּ�, ���ϻ缭��(����) �� ���� ������Ʈ ����� ��. 
begin tran
update [dbo].[TB_USER] 
set UserAccount = 'kbs88',
	MailAddress = 'kbs88@lottechilsung.co.kr',
	MailServer = 'ekw2bMail2'
where UserCD = '20150875'

--commit
select @@trancount
--rollback




