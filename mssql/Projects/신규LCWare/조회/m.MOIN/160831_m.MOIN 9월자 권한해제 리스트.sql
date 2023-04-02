

/***************************
m.MOIN (개별)사용자  조회
****************************/
use im80
select 
ou.name, 
ou.code, 
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
where ou.ex_mmoin_yn= 'Y' AND ou.status ='1' AND ou.domain_id = '11'
AND ou.code not in ('06035','17203','13097','09055','19026','11081','10091','15256','02144','02214','15253')
--AND ou.code in ('20080133','20333004','92118' )
AND ou.name in (
'오창성','최경일','김형찬','박경신','하재택','이강희','김종철','박원근','김정배','김정근','임병선','이종훈','허남일','김창훈','오창식','박근홍','현수현','조재호' )


-- 3명 오창성, 최경일, 김형찬은 관리자페이지에서 제외.  
select ex_mmoin_yn from im80.[dbo].[org_user] 
where code  in (
'20080124',
'20000122',
'19213633',
'20046782',
'19607774',
'20070306',
'19240891',
'1921073A',
'20109308',
'18803597',
'20050009',
'1920083A',
'19302117',
'19606707',
'20050681') 

begin tran
update im80.[dbo].[org_user] 
SET ex_mmoin_yn = 'N'
where code  in (
'20080124',
'20000122',
'19213633',
'20046782',
'19607774',
'20070306',
'19240891',
'1921073A',
'20109308',
'18803597',
'20050009',
'1920083A',
'19302117',
'19606707',
'20050681') 













