-- �ش� �׷쿡 ���Ե� ��� ���� ��ȸ 
-- ���� ��å ��� 

use im80
select  og.name
, ou.code, ou.name, ou.login_id 
, JG.name AS [����]
, JW.name AS [����]
, JC.name AS [��å]
FROM [dbo].[org_group_user] AS ogu
left join [dbo].[org_user] AS ou
on ogu.user_id = ou.user_id 
left outer join 
	(select a.user_id, b.group_id, b.name, a.org_id, b.ex_sort_key from dbo.org_group_user a inner join dbo.org_group b
	 on a.group_id = b.group_id where b.group_type_id = '11')  as JG
	on ou.user_id = JG.user_id and ou.group_id = JG.org_id
	left outer join 
	(select a.user_id, b.group_id, b.name, a.org_id, b.ex_sort_key from dbo.org_group_user a inner join dbo.org_group b
	 on a.group_id = b.group_id where b.group_type_id = '1')  as JW
	on ou.user_id = JW.user_id and ou.group_id = JW.org_id
	left outer join 
	(select a.user_id, b.group_id, b.name, a.org_id, b.ex_sort_key from dbo.org_group_user a inner join dbo.org_group b
	 on a.group_id = b.group_id where b.group_type_id = '2')  as JC
	on ou.user_id = JC.user_id and ou.group_id = JC.org_id
left join [dbo].[org_group] AS  og
on og.group_id = ou.group_id
where ogu.user_id in (select user_id from [dbo].[org_group_user] where ogu.group_id = '8408' )
