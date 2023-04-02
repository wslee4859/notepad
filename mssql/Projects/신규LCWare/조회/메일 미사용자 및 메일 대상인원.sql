/**************************************************
** 메일 사서함 미생성 계정
**************************************************/
select OU.sec_level, OU.name, OG.name, ogu_pos.name, ogu_tit.name, ogu_wor.name , OU.email
from [dbo].[org_user] AS OU
left join [dbo].[org_group] AS OG
ON OU.group_id = OG.group_id 
left outer join 
		(select a.user_id, b.group_id, b.name, a.org_id, b.ex_sort_key from dbo.org_group_user a inner join dbo.org_group b
		 on a.group_id = b.group_id where b.group_type_id = '1')  as ogu_pos
		on ou.user_id = ogu_pos.user_id and ou.group_id = ogu_pos.org_id
		left outer join 
		(select a.user_id, b.group_id, b.name, a.org_id, b.ex_sort_key from dbo.org_group_user a inner join dbo.org_group b
		 on a.group_id = b.group_id where b.group_type_id = '11')  as ogu_tit 
		on ou.user_id = ogu_tit.user_id and ou.group_id = ogu_tit.org_id
		left outer join 
		(select a.user_id, b.group_id, b.name, a.org_id, b.ex_sort_key from dbo.org_group_user a inner join dbo.org_group b
		 on a.group_id = b.group_id where b.group_type_id = '2')  as ogu_wor
		on ou.user_id = ogu_wor.user_id and ou.group_id = ogu_wor.org_id
WHERE OU.status = '1'
	AND OU.ex_lcware_yn = 'E'
	AND OU.domain_id = '11'


/**************************************************
** 로그인 계정이 없는(메일 사서함 생성 대상 인원)
**************************************************/
SELECT OU.sec_level, OU.NAME, OU.code, OU.login_id, OG.name, ogu_pos.name, ogu_tit.name, ogu_wor.name , OU.email
FROM [dbo].[org_user] AS OU
left join [dbo].[org_group] AS OG
ON OU.group_id = OG.group_id 
left outer join 
		(select a.user_id, b.group_id, b.name, a.org_id, b.ex_sort_key from dbo.org_group_user a inner join dbo.org_group b
		 on a.group_id = b.group_id where b.group_type_id = '1')  as ogu_pos
		on ou.user_id = ogu_pos.user_id and ou.group_id = ogu_pos.org_id
		left outer join 
		(select a.user_id, b.group_id, b.name, a.org_id, b.ex_sort_key from dbo.org_group_user a inner join dbo.org_group b
		 on a.group_id = b.group_id where b.group_type_id = '11')  as ogu_tit 
		on ou.user_id = ogu_tit.user_id and ou.group_id = ogu_tit.org_id
		left outer join 
		(select a.user_id, b.group_id, b.name, a.org_id, b.ex_sort_key from dbo.org_group_user a inner join dbo.org_group b
		 on a.group_id = b.group_id where b.group_type_id = '2')  as ogu_wor
		on ou.user_id = ogu_wor.user_id and ou.group_id = ogu_wor.org_id
WHERE OU.STATUS = '1'
	AND OU.DOMAIN_ID = '11'
	AND OU.EX_LCWARE_YN = 'L'
	AND (OU.email is null OR login_id is null)
	AND OU.sec_level = '9'


