-- ���� ���Ի�� �߰� �ϱ� 

-- 1. ���μ��� �λ翡 ��� �ȵǰ�, IM�� �ٷ� �����  ���������ϹǷ� �λ� �� ���μ����� ����
-- 2. IM �������� �����ϸ�, ERP_EKW_DTS ���μ����� ���� 
-- 3. IM_USER�� INSERT
-- 4. IM_DEPT_USER�� INSERT
-- 5. ���� IM-EKW �Ѱ� ����
-- 6. ���ڰ��� �� ����� ���� �Է� ���� ���ϻ缭��, ���� ���� UPDATE 
use ERP_EKW_DTS
select * from [dbo].[IM_USER] where userName = '������'


select * from [dbo].[IM_USER] where userName = '�����'
select * from [dbo].[IM_DEPT] where deptName like '%����%'     -- 01461   
select * from [dbo].[IM_CODE_SUB]
select * from [dbo].[IM_DEPT_USER] where empID = '8267'
select * from [dbo].[IM_USER] where empID in ('19026','8267')


--������ ����� ����� ��ȸ�Ͽ� �ش� ����ڿ� �ٸ� ������ ���� �Է��ϰ� ����̶� �μ��� �ٸ��� �Է��Ѵ�. 
use ERP_EKW_DTS
begin tran
insert into [dbo].[IM_USER]
select 
'8273',   --���
'�����',   --UserName
PersonID,
Phone,
Address,
HandPhone,
BirthDay,
LunarYN,
Jo,
SEX,
PS,
EntDate,
EnableYN,
'bbodagu111@lottechilsung.co.kr',
'bbodagu111'
FROM [dbo].[IM_USER]
WHERE EmpID = '8270'

--������ ����� ����� ��ȸ�Ͽ� �ش� ����ڿ� �ٸ� ������ ���� �Է��ϰ� ����̶� �μ��� �ٸ��� �Է��Ѵ�. 
use ERP_EKW_DTS
begin tran
insert into dbo.IM_DEPT_USER 
select 
'8273',   --���
'01430',   --�μ�
JikGeupID,
JikMuID,
JikChaekID,
PositionOrder,
FrDate,
DisplayYN
FROM dbo.IM_DEPT_USER 
WHERE EmpID = '8273'


commit
rollback

-- ���� �۾� IM-EKW �Ѱ� ���� 

-- 8267    
-- 8268    
-- 8269    
select * from eManage.[dbo].[TB_USER] WHERE EmpID = '8273'

-- �α��� ���̵� �Է� -- �� ���ڰ��� ����ϱ� ���ؼ��� �ű� ��Ż ����, �����ּ�, ���ϻ缭��(����) �� ���� ������Ʈ ����� ��. 
begin tran 
update eManage.[dbo].[TB_USER]
set UserAccount = 'bbodagu111',
	MailAddress = 'bbodagu111@lottechilsung.co.kr',
	MailServer = 'ekw2bMail2'
where EmpID = '8273'

commit
select @@trancount
--rollback










