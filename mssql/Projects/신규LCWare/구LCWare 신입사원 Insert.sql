
use ERP_EKW_DTS
select * from [dbo].[IM_USER] where userName = '김효은'
select * from [dbo].[IM_DEPT] where deptName = '대전생산담당'
select * from [dbo].[IM_CODE_SUB]
select * from [dbo].[IM_DEPT_USER] where empID = '19026'


select * from [dbo].[IM_DEPT_USER]
select * from [dbo].[IM_USER] where username = '이완상'
19026   	이완상	1111111111111	NULL	NULL	NULL	NULL	0	사원	F	NULL	NULL	Y	NULL	NULL
20150672	박주용	1111111111111	NULL	NULL	NULL	NULL	0	사원	M	NULL	NULL	Y	NULL	NULL
영업지원담당 01221   
00583  대전생산담당


begin tran
--rollback
insert into dbo.IM_USER VALUES('20150685','정재중','1111111111111',null,null,null,null,'0','사원','M',null,null,'Y',null,null)

commit

select * from [dbo].[IM_DEPT_USER] where empid = '19026'
-- empID, DeptCd, JikGeupID, JikMID, JikChaekID, PositionOrder, FrDate, DisplayYN 
begin tran
insert into dbo.IM_DEPT_USER VALUES('20150685','00583',null,null,null,1,'20150817','1')

commit