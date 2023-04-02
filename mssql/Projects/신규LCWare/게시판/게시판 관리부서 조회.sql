/**************************************************
* 게시판 관리 부서 조회
*
***************************************************/

select BT.Korean,UnitID, B.UnitName, ORG.name [최신조직도] ,B.Permission
from [BD].[BoardACL] AS B
left join [BD].[BoardText] AS BT
ON B.ResourceID = BT.TextID 
left join [Common].[IM].[VIEW_ORG] AS ORG
on B.UnitID = ORG.group_code
WHERE B.unitName != ORG.name
where BT.korean = '톡까놓는사이다'




/**************************************************
* 게시판 부서명 변경 처리*
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






