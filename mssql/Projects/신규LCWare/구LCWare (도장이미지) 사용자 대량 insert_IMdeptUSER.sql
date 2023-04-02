--구 LCWare 에 사용자정보 등록  IMUSER

--[vwIMUserDept]
EmpID
DeptCd
JikGeupID
JikMuID
JikChaekID
ERPJikGeupID
ERPJikMuID
ERPJikChaekID
PositionOrder
FrDate
DisplayYN
GuBun


--[IM_DEPT_USER]
EmpID
DeptCd
JikGeupID
JikMuID
JikChaekID
PositionOrder
FrDate
DisplayYN

/***************************
 개인 사용자 용 *************
 ****************************/
 use ERP_EKW_DTS
--rollback

select * from [ERPSQL1\INST1].[LeAcc].dbo.vwIMUserDept where EmpID  '20150819'
select * from  ERP_EKW_DTS.[dbo].[IM_DEPT_USER] where EmpID = '20150819'
begin tran 
insert into ERP_EKW_DTS.[dbo].[IM_DEPT_USER]
select 
EmpID,
DeptCd,
JikGeupID,
JikMuID,
JikChaekID,
PositionOrder,
FrDate,
DisplayYN
from [ERPSQL1\INST1].[LeAcc].dbo.vwIMUserDept
where EmpID = '20150819'

--commit





/***************************
 대량 사용자 용 *************
 ****************************/

select * from [ERPSQL1\INST1].[LeAcc].dbo.vwIMUserDept 
where EmpID  in (
'20150923',
'20150924',
'20150927',
'20150928',
'20150929',
'20150892',
'20150893' )

use ERP_EKW_DTS
--rollback
begin tran 
insert into ERP_EKW_DTS.[dbo].[IM_DEPT_USER]
select 
EmpID,
DeptCd,
JikGeupID,
JikMuID,
JikChaekID,
PositionOrder,
FrDate,
DisplayYN
from [ERPSQL1\INST1].[LeAcc].dbo.vwIMUserDept
where EmpID in (
'20150923',
'20150924',
'20150927',
'20150928',
'20150929',
'20150892',
'20150893' )

commit



select *, DeptName from [dbo].[IM_DEPT_USER]  AS U
left join dbo.IM_Dept AS D
on u.deptcd = D.deptcd
where DeptName is null 
AND EmpID in (
'20150923',
'20150924',
'20150927',
'20150928',
'20150929',
'20150892',
'20150893' )