
use ERP_EKW_DTS
select * from [dbo].[IM_USER] where userName = '��ȿ��'
select * from [dbo].[IM_DEPT] where deptName = '����������'
select * from [dbo].[IM_CODE_SUB]
select * from [dbo].[IM_DEPT_USER] where empID = '19026'


select * from [dbo].[IM_DEPT_USER]
select * from [dbo].[IM_USER] where username = '�̿ϻ�'
19026   	�̿ϻ�	1111111111111	NULL	NULL	NULL	NULL	0	���	F	NULL	NULL	Y	NULL	NULL
20150672	���ֿ�	1111111111111	NULL	NULL	NULL	NULL	0	���	M	NULL	NULL	Y	NULL	NULL
����������� 01221   
00583  ����������


begin tran
--rollback
insert into dbo.IM_USER VALUES('20150685','������','1111111111111',null,null,null,null,'0','���','M',null,null,'Y',null,null)

commit

select * from [dbo].[IM_DEPT_USER] where empid = '19026'
-- empID, DeptCd, JikGeupID, JikMID, JikChaekID, PositionOrder, FrDate, DisplayYN 
begin tran
insert into dbo.IM_DEPT_USER VALUES('20150685','00583',null,null,null,1,'20150817','1')

commit