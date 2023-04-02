/*************************************
* 2018-01-06 �ۼ��� �̿ϻ�
* ���ڰ��� ���źμ� �� �ٸ��� �˻�
*
**************************************/

-- ��ȸ
select WF.FORM_NAME, FS.FORM_ID, FS.RECEPTION_DEPT, FS.RECEPTION_DEPT_CODE, O.name AS �űԺμ��̸�
from [WF].[WF_FORM_SCHEMA] AS FS
inner join common.[IM].[VIEW_ORG] AS O
ON FS.RECEPTION_DEPT_CODE = O.group_code
inner join [WF].[WF_FORMS] AS WF
ON FS.FORM_ID = WF.FORM_ID
WHERE RCV_USE_YN = 'Y'


-- Ʋ�� �͸� ��ȸ 
select WF.FORM_NAME, FS.FORM_ID, FS.RECEPTION_DEPT, FS.RECEPTION_DEPT_CODE, O.name AS �űԺμ��̸�
from [WF].[WF_FORM_SCHEMA] AS FS
inner join common.[IM].[VIEW_ORG] AS O
ON FS.RECEPTION_DEPT_CODE = O.group_code
inner join [WF].[WF_FORMS] AS WF
ON FS.FORM_ID = WF.FORM_ID
WHERE RCV_USE_YN = 'Y' AND FS.RECEPTION_DEPT ! = O.name




select * from [WF].[WF_FORM_SCHEMA] where reception_dept = '�Ǹ������'
select reception_dept from [WF].[WF_FORM_SCHEMA] where reception_dept_code = '5540' AND RCV_USE_YN = 'Y'  -- RCV_USE_YN : ���Ű��� ��뿩��


-- �μ� DB ������Ʈ 
rollback
begin tran
update [WF].[WF_FORM_SCHEMA]
set RECEPTION_DEPT = (select name from common.[IM].[VIEW_ORG] where group_code = '138')
where reception_dept_code = '138'


--commit

-- ���� �Խ��� ���� --
update B
set B.unitname = ORG.name
from [BD].[BoardACL] AS B
	inner join [Common].[IM].[VIEW_ORG] AS ORG
	on B.UnitID = ORG.group_code
WHERE B.unitName != ORG.name