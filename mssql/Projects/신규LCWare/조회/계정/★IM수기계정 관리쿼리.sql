/************************************************
*********  IM ������� ����(����) **************
************************************************/

use im80
select ou.code ,
ou.name,
ou.login_id,
ogu_pos.name AS ����, 
ogu_tit.name AS ����,
ogu_wor.name AS ��å,
og.name AS �μ�, 
og1.name AS �����μ�,
--og.code AS �׷��ڵ�,
--og.ex_sort_key AS ����Ű,
ou.ex_lcware_yn AS LCWare��뿩��
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
AND (ou.sec_level = '2' OR ou.code in (select code from [dbo].[lotte_sync_bulk_user])  )   -- CH �뷮 ����� �α��� 
-- order by og.ex_sort_key, ou.code desc
order by ou.code desc




/***********************************************
*********  IM ������� ����(�ַ�) **************
************************************************/

use im80
select ou.code ,
ou.name,
ou.login_id,
ogu_pos.name AS ����, 
ogu_tit.name AS ����,
ogu_wor.name AS ��å,
og.name AS �μ�, 
og1.name AS �����μ�,
--og.code AS �׷��ڵ�,
--og.ex_sort_key AS ����Ű,
ou.ex_lcware_yn AS LCWare��뿩��, 
ou.create_dt ��������
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
where ou.domain_id = '1' 
AND ou.status = '1' 
AND (ou.sec_level = '2' OR ou.code in (select code from [dbo].[lotte_sync_bulk_user])  )   -- CH �뷮 ����� �α��� 
-- order by og.ex_sort_key, ou.code desc
order by ou.create_dt 









