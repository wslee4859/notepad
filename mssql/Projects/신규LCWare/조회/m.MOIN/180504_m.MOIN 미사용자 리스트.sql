
/***************************
m.MOIN 사용자 리스트 조회
* 식품BU, 전산팀은 과금에서 제외처리
****************************/
use im80
select 
ou.code, 
ou.name, 
og.name,
ogu_pos.name AS 직위, 
ogu_tit.name AS 직급,
ogu_wor.name AS 직책,
ou.email,
ou.ex_mmoin_yn
from im80.[dbo].[org_user] as ou
left join im80.[dbo].[org_group] as og
ON ou.group_id = og.group_id 
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
where (ou.ex_mmoin_yn != 'Y' OR ou.ex_mmoin_yn is null)
AND ou.status ='1' AND ou.domain_id = '11' 
AND ou.sec_level = '9'
AND ou.ex_lcware_yn = 'L'
AND ou.code not in ('06035','17203','13097','09055','19026','11081','10091','15256','02144','02214','15253','14139','14047','13026','14141','15046','21262','15255','22079') -- 전산팀 사용자 제외(미청구)
AND ou.group_id not in ('10948') -- 식품BU는 사용자 제외(미청구 처리)
AND og.name not like '%신협%'
AND og.name not like '%CH%'
order by og.ex_sort_key, ou.name

