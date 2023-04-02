--구 LCWare 에 사용자정보 등록  IMUSER

-- 그룹웨어 IMUSER
--EmpID
--UserName
--PersonID
--Phone
--Address
--HandPhone
--BirthDay
--LunarYN
--Jo
--SEX
--PS
--EntDate
--EnableYN
--MailAddress
--UserAccount


-- vwIMUSER
--UserID
--EmpID
--UserName
--PersonID
--Phone
--Address
--HandPhone
--BirthDay
--LunarYN
--Jo
--SEX
--PS
--EntDate
--EnableYN
--GuBun


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


--[IM_DEPT]
select * from [dbo].[IM_DEPT_USER]
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

 -- 구 LCWare 정보가 있는지 확인
select * from eManage.[dbo].[TB_USER] where UserCD = '20147169'

use ERP_EKW_DTS

select * from [ERPSQL1\INST1].[LeAcc].dbo.vwIMUSer Where EmpID = '20150928'

begin tran 
insert into ERP_EKW_DTS.[dbo].[IM_USER] 
select 
EmpID,
UserName,
'1111111111111',
Phone,
Address,
HandPhone,
BirthDay,
LunarYN,
Jo,
SEX,
PS,
EntDate,
'Y',
NULL,
NULL
from [ERPSQL1\INST1].[LeAcc].dbo.vwIMUSer
where EmpID = '20150819'

commit



/***************************
 대량 사용자 용 *************
 ****************************/
use ERP_EKW_DTS

begin tran 
insert into ERP_EKW_DTS.[dbo].[IM_USER] 
select 
EmpID,
UserName,
'1111111111111',
Phone,
Address,
HandPhone,
BirthDay,
LunarYN,
Jo,
SEX,
PS,
EntDate,
'Y',
NULL,
NULL
from [ERPSQL1\INST1].[LeAcc].dbo.vwIMUSer
where EmpID in (
'20150923',
'20150924',
'20150927',
'20150928',
'20150929',
'20150892',
'20150893' )



commit
rollback




select * from [dbo].[vwIMUserDept] where EmpID = '20150591'




