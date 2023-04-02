

/***************************
* IM ±âÁØ °âÁ÷ÀÚ Á¶È¸ Äõ¸®
****************************/

select OU.domain_id, OG.domain_id, OU.code, OU.name, OG.NAME, OGU.relation_type, OU.ex_lcware_yn
from [dbo].[org_user] AS OU
inner join [dbo].[org_group_user] AS OGU
ON OU.user_id = OGU.user_id AND (relation_type = '2' OR relation_type = '1')
inner join [dbo].[org_group] AS OG
ON OGU.group_id = OG.group_id 
where OU.user_id in (select user_id from [dbo].[org_group_user] where relation_type = '2')
AND	OU.status = '1'
order by OU.domain_id desc, OU.user_id, OGU.relation_type

