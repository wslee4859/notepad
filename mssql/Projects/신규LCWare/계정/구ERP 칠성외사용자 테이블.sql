

use LeAcc
select * from [dbo].[THWLCWareMst]
where  1=1 
	AND USeDateTo > getdate()




select * from [dbo].[THWLCWareMst] where EmpNm in ('�����','�����','������','��������')


select * 
from [dbo].[THWLCWareMst]
where  1=1 
	AND USeDateTo > getdate()
	AND EmpNm = '���翵'


/* Insert ��
-- �ùٸ� ���������� �־���. 
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
'�ֶ̾�',
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
	AND EmpNm = '�̽�ö' 

--commit



