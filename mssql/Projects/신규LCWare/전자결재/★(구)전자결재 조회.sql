--(��)���ڰ��� ��ȸ 
-- URL : https://portal.lottechilsung.co.kr/UM/Migration/FormLoad/FormMainPreRead.aspx?mode=COMPLETE&pid=Z958D451B99964E359B69B3DB387D2108&open_yn=Y&wid=Z678331B855D74B7182F56B7128D44A1D&postscript=N&deptid=&refDoc=N&attachYN=&FolderID=&FormID=&SortCol=&SortOrder=&StartDate=&EndDate=
-- oid �ٿ������� ��.

-- 10.120.6.96 
use EWF_MIG
select oid, name, state, creator, subject, CREATE_DATE, COMPLETED_DATE from [dbo].[PROCESS_INSTANCE] where subject like '%�������%' order by create_date

select oid, name, process_oid, state, creator, CREATE_DATE, COMPLETED_DATE, subject from [dbo].[PROCESS_INSTANCE] where subject like '%���Ұ�����%' AND name like '%��ȼ�(������)%' AND CREATOR like '���¿�' order by create_date desc

--�����
select oid, name, process_oid, state, creator, subject from [dbo].[PROCESS_INSTANCE] where creator like '%�赿ȯ%' AND name like '%�㺸%'
select oid, name, state, creator, subject, CREATE_DATE, COMPLETED_DATE from [dbo].[PROCESS_INSTANCE] where creator like '%%' AND name like '%�㺸%'ANd subject like '%�������%' order by create_date


select * from [dbo].[PROCESS_INSTANCE] where creator = '������' AND name = '����ó���Ƿڼ�' AND subject like '%2014��%'
https://portal.lottechilsung.co.kr/UM/Migration/FormLoad/FormMainPreRead.aspx?mode=COMPLETE&pid=Z209E4E16962D4F6FA26D6520CC1918EE
ZE1BCE81D78F9437C946FC7F122E2F476



-- �� ���̺� ã�� 
select * from [eWFFORM_MIG].[dbo].[WF_FORMS] where fORM_NAME like '%��ȼ�%'





-- ��ü

use EWF_MIG
select M.oid, M.name, M.process_oid, M.STATE , M.creator, M.CREATE_DATE, M.DELETE_DATE, M.COMPLETED_DATE, M.subject, M.CREATOR_DEPT 
from [dbo].[PROCESS_INSTANCE] AS M
where 1=1
--AND M.name like '%��ȼ�%'
AND subject like '%Ȱ����%'
--AND M.CREATOR = '��ö��'
--AND M.CREATE_DATE > '2010-11-01' 
--AND M.CREATE_DATE < '2011-03-01' 
--AND F.PROCESS_INSTANCE_STATE = '7'
--AND M.CREATOR_DEPT like '%�ȼ�%'
order by M.create_date 



-- ��ȼ� ��
use EWF_MIG
select M.name,M.OID, M.SUBJECT, M.CREATE_DATE, M.CREATOR_DEPT, M.CREATOR, F.PROCESS_INSTANCE_STATE
from [dbo].[PROCESS_INSTANCE] AS M
left JOIN [eWFFORM_MIG].[dbo].[FORM_Y28B72F2F7EE54FB5BE13E8F2A3637978] AS F
ON M.OID = F.PROCESS_ID 
where 1=1
AND name like '%��ȼ�%'
AND M.subject like '%�ҿ���� ��� �� �Ű�%'
--AND M.CREATOR = '�տܽ�'
--AND M.CREATOR_DEPT like '%�Ϻλ�����%'
-- AND (M.CREATOR_DEPT like '%���ǻ����%' OR M.CREATOR_DEPT like '%���ǻ����%')
--AND M.CREATE_DATE > '2013-01-01' AND M.CREATE_DATE < '2015-04-01'
AND F.PROCESS_INSTANCE_STATE = '7'
order by M.CREATE_DATE

 [dbo].[PROCESS_INSTANCE] WHERE NAME like '%��ȼ�(������)%' ORDER BY  CREATE_DATE 
-- ��ȼ� ������ ��
use EWF_MIG
select M.OID, M.SUBJECT, M.CREATE_DATE, M.CREATOR_DEPT, M.CREATOR, F.PROCESS_INSTANCE_STATE
from [dbo].[PROCESS_INSTANCE] AS M
left JOIN [eWFFORM_MIG].[dbo].[FORM_YFA4BC440266849EB8DBA1A1FE7C55EE6] AS F
ON M.OID = F.PROCESS_ID 
where 1=1
AND name like '%��ȼ�(������)%'
AND M.subject like '%Ȱ����%'
--AND M.CREATOR in ('���α�','�̽¿�')
--AND M.CREATOR_DEPT like '%����%'
-- AND (M.CREATOR_DEPT like '%���ǻ����%' OR M.CREATOR_DEPT like '%���ǻ����%')
AND M.CREATE_DATE > '2011-11-01'  AND M.CREATE_DATE < '2012-04-01'
AND F.PROCESS_INSTANCE_STATE = '7'
order by M.CREATE_DATE


-- ��ȼ� ������ ��(���Ǵ��) 
use EWF_MIG
select M.NAME, M.OID, M.SUBJECT, M.CREATE_DATE, M.CREATOR_DEPT, M.CREATOR, F.PROCESS_INSTANCE_STATE
from [dbo].[PROCESS_INSTANCE] AS M
left JOIN [eWFFORM_MIG].[dbo].[FORM_YFA4BC440266849EB8DBA1A1FE7C55EE6] AS F
ON M.OID = F.PROCESS_ID 
where 1=1
AND name like '%��ȼ�(������)%'
-- AND subject like '%��ǰ��%'
-- AND M.CREATOR = 'Ȳ�κ�'
AND (M.CREATOR_DEPT like '%���ǻ����%' OR M.CREATOR_DEPT like '%���ǻ����%')
-- AND M.CREATOR_DEPT like '%���Ǵ��%'
AND M.CREATE_DATE > '2012-01-01' AND M.CREATE_DATE < '2015-01-01'
AND F.PROCESS_INSTANCE_STATE = '7'
--AND CREATOR_DEPT like '%�Ǹ����%'
order by M.CREATE_DATE


-- ��ȼ� ��(���Ǵ��) 
use EWF_MIG
select M.NAME, M.OID, M.SUBJECT, M.CREATE_DATE, M.CREATOR_DEPT, M.CREATOR, F.PROCESS_INSTANCE_STATE
from [dbo].[PROCESS_INSTANCE] AS M
left JOIN [eWFFORM_MIG].[dbo].[FORM_Y28B72F2F7EE54FB5BE13E8F2A3637978] AS F
ON M.OID = F.PROCESS_ID 
where 1=1
AND name like '%��ȼ�%'
-- AND subject like '%��ǰ��%'
-- AND M.CREATOR = 'Ȳ�κ�'
AND (M.CREATOR_DEPT like '%���ǻ����%' OR M.CREATOR_DEPT like '%���ǻ����%')
-- AND M.CREATOR_DEPT like '%���Ǵ��%'
AND M.CREATE_DATE > '2012-01-01' AND M.CREATE_DATE < '2015-01-01'
AND F.PROCESS_INSTANCE_STATE = '7'
--AND CREATOR_DEPT like '%�Ǹ����%'
order by M.CREATE_DATE

-- �����Ƿڼ���(���Ǵ��) 
use EWF_MIG
select M.NAME, M.OID, M.SUBJECT, M.CREATE_DATE, M.CREATOR_DEPT, M.CREATOR, F.PROCESS_INSTANCE_STATE
from [dbo].[PROCESS_INSTANCE] AS M
left JOIN [eWFFORM_MIG].[dbo].[FORM_Y8D4A994E63054A5EB14621BDD3A4483E] AS F
ON M.OID = F.PROCESS_ID 
where 1=1
AND name like '%����%'
-- AND subject like '%��ǰ��%'
-- AND M.CREATOR = 'Ȳ�κ�'
AND (M.CREATOR_DEPT like '%���ǻ����%' OR M.CREATOR_DEPT like '%���ǻ����%')
-- AND M.CREATOR_DEPT like '%���Ǵ��%'
AND M.CREATE_DATE > '2012-01-01' AND M.CREATE_DATE < '2015-01-01'
AND F.PROCESS_INSTANCE_STATE = '7'
--AND CREATOR_DEPT like '%�Ǹ����%'
order by M.CREATE_DATE



-- �ŷ�ó ����ǰ�Ǽ� (���Ǵ��) 
use EWF_MIG
select M.NAME, M.OID,replace(replace(M.subject,char(13),''),char(10),''), M.CREATE_DATE, M.CREATOR_DEPT, M.CREATOR, F.PROCESS_INSTANCE_STATE
from [dbo].[PROCESS_INSTANCE] AS M
left JOIN [eWFFORM_MIG].[dbo].[FORM_YB9222DABFA484AC6AC97F2A23C649789] AS F
ON M.OID = F.PROCESS_ID 
where 1=1
AND name like '%�ŷ�ó%'
-- AND subject like '%��ǰ��%'
-- AND M.CREATOR = 'Ȳ�κ�'
AND (M.CREATOR_DEPT like '%���ǻ����%' OR M.CREATOR_DEPT like '%���ǻ����%')
-- AND M.CREATOR_DEPT like '%���Ǵ��%'
AND M.CREATE_DATE > '2012-01-01' AND M.CREATE_DATE < '2015-01-01'
AND F.PROCESS_INSTANCE_STATE = '7'
--AND CREATOR_DEPT like '%�Ǹ����%'
order by M.CREATE_DATE


-- �ŷ�ó ����ǰ�Ǽ� 
use EWF_MIG
select M.NAME, M.OID,replace(replace(M.subject,char(13),''),char(10),''), M.CREATE_DATE, M.CREATOR_DEPT, M.CREATOR, F.PROCESS_INSTANCE_STATE
from [dbo].[PROCESS_INSTANCE] AS M
left JOIN [eWFFORM_MIG].[dbo].[FORM_YB9222DABFA484AC6AC97F2A23C649789] AS F
ON M.OID = F.PROCESS_ID 
where 1=1
AND name like '%�ŷ�ó%'
AND M.subject like '%�Ｚ���κ���%'
AND M.CREATOR = '�ֱ���'
-- AND (M.CREATOR_DEPT like '%�λ�FS���%' OR M.CREATOR_DEPT like '%�λ����Ǵ��%')
-- AND M.CREATOR_DEPT like '%�λ�FS���%'
-- AND M.CREATE_DATE > '2012-01-01' AND M.CREATE_DATE < '2016-01-01'
  AND F.PROCESS_INSTANCE_STATE = '7'
--AND CREATOR_DEPT like '%�Ǹ����%'
order by M.CREATE_DATE



Z3E2F1D9F169F47128C163F76329AF966
ZDDF1CF79ECF34DD29E56A9E151438495

-- �����Ƿڼ� ��ȸ (�������������)
use EWF_MIG
select M.NAME, M.OID, replace(replace(M.subject,char(13),''),char(10),''), M.CREATE_DATE, M.CREATOR_DEPT, M.CREATOR, F.PROCESS_INSTANCE_STATE
from [dbo].[PROCESS_INSTANCE] AS M
left JOIN [eWFFORM_MIG].[dbo].[FORM_Y8D4A994E63054A5EB14621BDD3A4483E] AS F
ON M.OID = F.PROCESS_ID 
where 1=1
AND name like '�����Ƿڼ�'
-- AND subject like '%��ǰ��%'
-- AND M.CREATOR = 'Ȳ�κ�'
--AND (M.CREATOR_DEPT like '%���ǻ����%' OR M.CREATOR_DEPT like '%���ǻ����%')
-- AND (M.SUBJECT like '%��ǰ��%' OR M.SUBJECT like '%��ȭ��%' OR M.SUBJECT like '%����%')
AND M.CREATOR_DEPT like '%���ǻ����%'
AND M.CREATE_DATE > '2011-12-31' AND  M.CREATE_DATE < '2015-01-01'
AND F.PROCESS_INSTANCE_STATE = '7'
order by M.CREATE_DATE



-- �����Ƿڼ� 
use EWF_MIG
select M.NAME, M.OID, replace(replace(M.subject,char(13),''),char(10),''), M.CREATE_DATE, M.CREATOR_DEPT, M.CREATOR, F.PROCESS_INSTANCE_STATE
from [dbo].[PROCESS_INSTANCE] AS M
left JOIN [eWFFORM_MIG].[dbo].[FORM_Y8D4A994E63054A5EB14621BDD3A4483E] AS F
ON M.OID = F.PROCESS_ID 
where 1=1
AND name like '�����Ƿڼ�'
-- AND subject like '%��ǰ��%'
-- AND M.CREATOR = 'Ȳ�κ�'
--AND (M.CREATOR_DEPT like '%���ǻ����%' OR M.CREATOR_DEPT like '%���ǻ����%')
-- AND (M.SUBJECT like '%��ǰ��%' OR M.SUBJECT like '%��ȭ��%' OR M.SUBJECT like '%����%')
AND M.CREATOR_DEPT like '%���ǻ����%'
AND M.CREATE_DATE > '2011-12-31' AND  M.CREATE_DATE < '2015-01-01'
AND F.PROCESS_INSTANCE_STATE = '7'
order by M.CREATE_DATE




-- ��ü���� ��ȸ
use EWF_MIG
select M.NAME, M.OID, replace(replace(M.subject,char(13),''),char(10),''), M.CREATE_DATE, M.CREATOR_DEPT, M.CREATOR
from [dbo].[PROCESS_INSTANCE] AS M
where 1=1
AND name like '�����Ƿڼ�'
-- AND subject like '%��ǰ��%'
-- AND M.CREATOR = 'Ȳ�κ�'
--AND (M.CREATOR_DEPT like '%���ǻ����%' OR M.CREATOR_DEPT like '%���ǻ����%')
-- AND (M.SUBJECT like '%��ǰ��%' OR M.SUBJECT like '%��ȭ��%' OR M.SUBJECT like '%����%')
AND M.CREATOR_DEPT like '%�����������%'
AND M.CREATE_DATE > '2011-12-31' AND  M.CREATE_DATE < '2015-01-01'
order by M.CREATE_DATE



-- ��ü���� ��ȸ (���λ� ����)
use EWF_MIG
select M.NAME, M.OID, replace(replace(M.subject,char(13),''),char(10),''), M.CREATE_DATE, M.CREATOR_DEPT, M.CREATOR
from [dbo].[PROCESS_INSTANCE] AS M
where 1=1
-- AND (name like '%��ȼ�(������)%' OR name like '%����ǰ�Ǽ�%')
AND M.name like '%��ȼ�%'
AND subject like '%4��%'
-- AND (M.CREATOR = '�����' OR M.CREATOR = '��ö��')
-- AND (M.CREATOR_DEPT like '%���ǻ����%' OR M.CREATOR_DEPT like '%���ǻ����%')
-- AND (M.SUBJECT like '%��ǰ��%' OR M.SUBJECT like '%��ȭ��%' OR M.SUBJECT like '%����%')
AND M.CREATOR_DEPT like '%�Ϻ�����%'
AND M.CREATE_DATE > '2011-12-31' AND  M.CREATE_DATE < '2015-01-01'
order by M.CREATE_DATE 




-- �Ϻ����� ������ 
use EWF_MIG
select M.NAME, M.OID, replace(replace(M.subject,char(13),''),char(10),''), M.CREATE_DATE, M.CREATOR_DEPT, M.CREATOR, F.PROCESS_INSTANCE_STATE
from [dbo].[PROCESS_INSTANCE] AS M
left JOIN [eWFFORM_MIG].[dbo].[FORM_YFA4BC440266849EB8DBA1A1FE7C55EE6] AS F
ON M.OID = F.PROCESS_ID 
where 1=1
AND name like '%��ȼ�(������)%'
-- AND subject like '%��ǰ��%'
AND M.CREATOR = '������'
AND M.CREATOR_DEPT like '%�Ϻ�����%'
AND M.CREATE_DATE > '2014-01-01' 
AND F.PROCESS_INSTANCE_STATE = '7'
order by M.CREATE_DATE




use EWF_MIG
select M.OID, M.SUBJECT, M.CREATE_DATE, M.CREATOR_DEPT,  M.CREATOR, F.PROCESS_INSTANCE_STATE
from [dbo].[PROCESS_INSTANCE] AS M
left JOIN [eWFFORM_MIG].[dbo].[FORM_YFA4BC440266849EB8DBA1A1FE7C55EE6] AS F
ON M.OID = F.PROCESS_ID 
where 1=1
AND name like '%��ȼ�(������)%'
-- AND subject like '%��ǰ��%'
-- AND M.CREATOR = 'Ȳ�κ�'
AND M.CREATOR_DEPT like '%���ǻ����%'
AND M.CREATE_DATE > '2012-01-01' 
AND F.PROCESS_INSTANCE_STATE = '7'
--AND CREATOR_DEPT like '%�Ǹ����%'
order by M.CREATE_DATE



select * from [eWFFORM_MIG].[dbo].[WF_FORMS] where fORM_NAME = '��ȼ�(������)'


use EWF_MIG
select *, replace(replace(subject,char(13),''),char(10),'')
from [dbo].[PROCESS_INSTANCE] 
where 1=1
-- AND name like '%��ȼ�%'
--AND subject like '%�Ե��ó׸�%'
--AND CREATOR = 'Ȳ�κ�'
AND CREATOR_DEPT = '��������'
AND CREATE_DATE > '2013-01-01' AND CREATE_DATE < '2015-01-01'
-- AND state = '7'
--AND CREATOR_DEPT like '%�Ǹ����%'
order by CREATE_DATE


ZDD81829A78904D828447638B13027353

order by create_date desc


select * from [eWFFORM_MIG].[dbo].[WF_FORMS] where FORM_NAME like '�����Ƿڼ�'

[eWFFORM_MIG].[dbo].[FORM_Y8D4A994E63054A5EB14621BDD3A4483E]

Z5ADB5ECFDB9A4D18ABE1996414E9CEB7

https://portal.lottechilsung.co.kr/UM/Migration/FormLoad/FormMainPreRead.aspx?mode=COMPLETE&pid=Z5ADB5ECFDB9A4D18ABE1996414E9CEB7&open_yn=Y&wid=Z678331B855D74B7182F56B7128D44A1D&postscript=N&deptid=&refDoc=N&attachYN=&FolderID=&FormID=&SortCol=&SortOrder=&StartDate=&EndDate=