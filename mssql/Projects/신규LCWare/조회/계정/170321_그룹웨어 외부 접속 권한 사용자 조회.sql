/********************************
* �׷���� �ܺα��� ����� ��ȸ 
*********************************/
use im80
select ou.status ,ou.ex_comp_nm, ou.code, ou.login_id, ou.name, og.name, og1.name, ogu_wor.name AS ��å, ogu_tit.name AS ����, ogu_pos.name AS ����, ou.sec_level
from [im80].[dbo].[org_user] AS ou
left join [im80].[dbo].[org_group] AS og
ON ou.group_id = og.group_id
left join [im80].[dbo].[org_group] AS og1
ON og.parent_id = og1.group_id
	left outer join 
		(select a.user_id, b.group_id, b.name, a.org_id, b.ex_sort_key from [im80].dbo.org_group_user a inner join  [im80].dbo.org_group b
		 on a.group_id = b.group_id where b.group_type_id = '1')  as ogu_pos
		on ou.user_id = ogu_pos.user_id and ou.group_id = ogu_pos.org_id
		left outer join 
		(select a.user_id, b.group_id, b.name, a.org_id, b.ex_sort_key from  [im80].dbo.org_group_user a inner join  [im80].dbo.org_group b
		 on a.group_id = b.group_id where b.group_type_id = '11')  as ogu_tit 
		on ou.user_id = ogu_tit.user_id and ou.group_id = ogu_tit.org_id
		left outer join 
		(select a.user_id, b.group_id, b.name, a.org_id, b.ex_sort_key from  [im80].dbo.org_group_user a inner join  [im80].dbo.org_group b
		 on a.group_id = b.group_id where b.group_type_id = '2')  as ogu_wor
		on ou.user_id = ogu_wor.user_id and ou.group_id = ogu_wor.org_id
where 1=1
AND ( ou.user_id in (select user_id from  [im80].[dbo].[org_rule_user] where rule_group_id = '8361') 
	OR ou.user_id in (select user_id from [dbo].[org_group_user] where group_id = '8361'))
AND ou.status = '1'
order by og.ex_sort_key, ou.code desc




[dbo].[org_group_user] where group_id = '8361'


/********************************
* �׷���� �ܺα��� ����� ��ȸ(��ȹ ���޿�)
*********************************/
use im80
select ou.status ,ou.ex_comp_nm, ou.code, ou.login_id, ou.name, og.name, og1.name, ogu_wor.name AS ��å, ogu_tit.name AS ����, ogu_pos.name AS ����, ou.sec_level
from [im80].[dbo].[org_user] AS ou
left join [im80].[dbo].[org_group] AS og
ON ou.group_id = og.group_id
left join [im80].[dbo].[org_group] AS og1
ON og.parent_id = og1.group_id
	left outer join 
		(select a.user_id, b.group_id, b.name, a.org_id, b.ex_sort_key from [im80].dbo.org_group_user a inner join  [im80].dbo.org_group b
		 on a.group_id = b.group_id where b.group_type_id = '1')  as ogu_pos
		on ou.user_id = ogu_pos.user_id and ou.group_id = ogu_pos.org_id
		left outer join 
		(select a.user_id, b.group_id, b.name, a.org_id, b.ex_sort_key from  [im80].dbo.org_group_user a inner join  [im80].dbo.org_group b
		 on a.group_id = b.group_id where b.group_type_id = '11')  as ogu_tit 
		on ou.user_id = ogu_tit.user_id and ou.group_id = ogu_tit.org_id
		left outer join 
		(select a.user_id, b.group_id, b.name, a.org_id, b.ex_sort_key from  [im80].dbo.org_group_user a inner join  [im80].dbo.org_group b
		 on a.group_id = b.group_id where b.group_type_id = '2')  as ogu_wor
		on ou.user_id = ogu_wor.user_id and ou.group_id = ogu_wor.org_id
where 1=1
AND ( ou.user_id in (select user_id from  [im80].[dbo].[org_rule_user] where rule_group_id = '8361') 
	OR ou.user_id in (select user_id from [dbo].[org_group_user] where group_id = '8361'))
AND ou.status = '1'
AND og.name not like '%�ƻ���%'
AND ou.name not like '%mail%'
AND ou.name not like '%�׽�Ʈ%'
AND ou.name not like '%test%'
AND ou.name not like '%������%'
AND ou.name not like '%mainserver%'
AND ou.name not like '%������%'
AND ou.name not like '%�����%'
order by og.ex_sort_key, ou.code desc
