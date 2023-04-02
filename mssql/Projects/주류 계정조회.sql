SELECT * FROM [dbo].[org_users] WHERE STATUS = '1' AND domain_id = '1'

/****************************************
*********  주류 조회 **************
*****************************************/
use im80
select ou.domain_id ,
ou.status ,
ou.code ,
UPPER(ou.login_id),
ou.name,
ou.email, 
ogu_pos.name AS 직위, 
ogu_tit.name AS 직급,
ogu_wor.name AS 직책,
og.name AS 부서, 
og1.name AS [1상위부서],
og2.name AS [2상위부서],
og3.name AS [3상위부서],
og3.name AS [4상위부서],
--og.code AS 그룹코드,
--og.ex_sort_key AS 정렬키,
--ou.ex_lcware_yn AS LCWare사용여부
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
left join [dbo].[org_group] as og2
on og1.parent_id = og2.group_id	
left join [dbo].[org_group] as og3
on og2.parent_id = og3.group_id	
left join [dbo].[org_group] as og4
on og3.parent_id = og4.group_id
where 1=1
AND ou.domain_id = '1' 
AND ou.status = '1' 
--AND ou.group_id = '5592'
--AND ou.sec_level = '2'
order by og.ex_sort_key, ou.code desc



/****************************************
*********  음료 조회 **************
*****************************************/
use im80
select ou.domain_id ,
ou.status ,
ou.code ,
UPPER(ou.login_id),
ou.name,
ou.email, 
ogu_pos.name AS 직위, 
ogu_tit.name AS 직급,
ogu_wor.name AS 직책,
og.name AS 부서, 
og1.name AS [1상위부서],
og2.name AS [2상위부서],
og3.name AS [3상위부서],
og3.name AS [4상위부서]
--og.code AS 그룹코드,
--og.ex_sort_key AS 정렬키,
--ou.ex_lcware_yn AS LCWare사용여부
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
left join [dbo].[org_group] as og2
on og1.parent_id = og2.group_id	
left join [dbo].[org_group] as og3
on og2.parent_id = og3.group_id	
left join [dbo].[org_group] as og4
on og3.parent_id = og4.group_id
left join [dbo].[org_group] as og5
on og4.parent_id = og5.group_id
where 1=1
AND ou.domain_id = '11' 
AND ou.status = '1' 
--AND ou.group_id = '5592'
--AND ou.sec_level = '2'
order by og.ex_sort_key, ou.code desc


