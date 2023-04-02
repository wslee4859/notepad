/****************************************
********* ���� ���� �μ� ��ȸ ���� **************
*****************************************/
	use im80


	WITH T_OU AS
	(
		SELECT 
			a.group_id,
			a.parent_id,
			a.name,
			a.status,
			a.ex_sort_key
		FROM org_group AS A 
		WHERE A.group_id in ('5389') AND A.status = '1'   --�����μ� �Է�


		UNION ALL
		SELECT 
			a.group_id,
			a.parent_id,
			a.name,
			a.status,
			a.ex_sort_key
		FROM org_group AS A INNER JOIN
			T_OU B ON A.parent_id = B.group_id
		    WHERE A.status = '1'       
	)
	--select * from T_OU order by ex_sort_key

/****************************************
*********  ���� ����� ���� ��ȸ **************
*****************************************/
select ou.code ,
ou.name,
ou.login_id,
ogu_pos.name AS ����, 
ogu_tit.name AS ����,
ogu_wor.name AS ��å,
og1.name AS �����μ�,
og.name AS �μ�, 
CASE WHEN EXISTS (select user_id from [dbo].[org_rule_user] where rule_group_id = '8215' AND user_id = ou.user_id) THEN 'Y' 
WHEN EXISTS (select user_id from [dbo].[org_group_user] where group_id = '8215' AND user_id = ou.user_id) THEN 'Y' ELSE 'N' END					AS MAIL, 
--og.code AS �׷��ڵ�,
--og.ex_sort_key AS ����Ű,
ou.ex_lcware_yn AS LCWare��뿩��,
ou.mobile
from [dbo].[org_user] as ou
left join [dbo].[org_group] as og
on ou.group_id = og.group_id
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
left join [dbo].[org_group] as og1
on og.parent_id = og1.group_id	
where ou.domain_id = '11' 
AND ou.status = '1' 
AND ou.group_id in (select group_id from T_OU ) 
order by og.ex_sort_key, ou.code, ogu_tit.ex_sort_key desc







































































































































