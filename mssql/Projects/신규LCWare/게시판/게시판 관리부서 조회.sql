/**************************************************
* �Խ��� ���� �μ� ��ȸ
*
***************************************************/

select BT.Korean,UnitID, B.UnitName, ORG.name [�ֽ�������] ,B.Permission
from [BD].[BoardACL] AS B
left join [BD].[BoardText] AS BT
ON B.ResourceID = BT.TextID 
left join [Common].[IM].[VIEW_ORG] AS ORG
on B.UnitID = ORG.group_code
WHERE B.unitName != ORG.name
where BT.korean = '�����»��̴�'




/**************************************************
* �Խ��� �μ��� ���� ó��*
***************************************************/
rollback
--commit
begin tran
update B
set B.unitname = ORG.name
from [BD].[BoardACL] AS B
	inner join [Common].[IM].[VIEW_ORG] AS ORG
	on B.UnitID = ORG.group_code
WHERE B.unitName != ORG.name






