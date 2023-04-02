/************************************************
*********  IM 수기계정 관리(음료) **************
************************************************/

use im80
select ou.code ,
ou.name,
ou.login_id,
ogu_pos.name AS 직위, 
ogu_tit.name AS 직급,
ogu_wor.name AS 직책,
og.name AS 부서, 
og1.name AS 상위부서,
--og.code AS 그룹코드,
--og.ex_sort_key AS 정렬키,
ou.ex_lcware_yn AS LCWare사용여부
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
AND (ou.sec_level = '2' OR ou.code in (select code from [dbo].[lotte_sync_bulk_user])  )   -- CH 대량 사용자 로그인 
-- order by og.ex_sort_key, ou.code desc
order by ou.code desc




/***********************************************
*********  IM 수기계정 관리(주류) **************
************************************************/

use im80
select ou.code ,
ou.name,
ou.login_id,
ogu_pos.name AS 직위, 
ogu_tit.name AS 직급,
ogu_wor.name AS 직책,
og.name AS 부서, 
og1.name AS 상위부서,
--og.code AS 그룹코드,
--og.ex_sort_key AS 정렬키,
ou.ex_lcware_yn AS LCWare사용여부, 
ou.create_dt 생성일자
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
AND (ou.sec_level = '2' OR ou.code in (select code from [dbo].[lotte_sync_bulk_user])  )   -- CH 대량 사용자 로그인 
-- order by og.ex_sort_key, ou.code desc
order by ou.create_dt 









