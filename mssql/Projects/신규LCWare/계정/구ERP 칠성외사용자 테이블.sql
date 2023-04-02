

use LeAcc
select * from [dbo].[THWLCWareMst]
where  1=1 
	AND USeDateTo > getdate()




select * from [dbo].[THWLCWareMst] where EmpNm in ('고건하','김건태','박준현','남궁유진')


select * 
from [dbo].[THWLCWareMst]
where  1=1 
	AND USeDateTo > getdate()
	AND EmpNm = '정재영'


/* Insert 예
-- 올바른 계정정보를 넣어줌. 
begin tran 
insert into TZAUserGrp
select 
'20120775',
Pwd,
'20120775',
CustCd,
Flag,
PwdChgDate,
UseFlag,
PwdOld,
RegEmpID,
RegDate
 from TZAUserGrp where UserID = 'doyoung' 
 -- commit
*/
select @@trancount
rollback


begin tran 
insert into [dbo].[THWLCWareMst]
select 
'08417',
'이애란',
ResidId,
DeptCd,
PgCd,
Ps,
JpCd,
JdCd,
JoCd,
SexCd,
BirthDay,
'20150923',
RetDate,
LunarYn,
RetYn,
ZipNo,
Addr1,
Addr2,
TelNo,
HPTelNo,
IsLiveYn,
ApprovalPass,
NicName,
NomalEmpYN,
'20150923',
'20160101',
IsDisplayYN
from [dbo].[THWLCWareMst]
where  1=1 
	AND USeDateTo > getdate()
	AND EmpNm = '이승철' 

--commit



