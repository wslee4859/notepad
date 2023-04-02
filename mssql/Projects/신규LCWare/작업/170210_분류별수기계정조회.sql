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
ou.ex_lcware_yn AS LCWare사용여부,
ou.mobile,
ou.ex_dept_nm,
ou.ex_lgort_nm,
ou.ex_werks_nm,
ou.ex_jp_nm,
ou.ex_djp_nm,
ou.ex_emp_gu_nm,
ou.ex_branch_snm,
ou.ex_kostl_nm
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
AND ou.code in (
'20146414',
'20146407',
'20146406',
'20146405',
'20146404',
'20146399',
'20146398',
'20146799',
'20146713',
'20146706',
'20146701',
'20146697',
'20146696',
'20146525',
'20146511',
'20146527',
'20146507',
'20146480',
'20146638',
'20146626',
'20146618',
'20146617',
'20146616',
'20146615',
'20146612',
'20147069',
'20146968',
'20147003',
'2010B109',
'20147122',
'20147121',
'20147129',
'20147133',
'20147207',
'20150279',
'20150331',
'20150470',
'20150485',
'20150879')
order by ou.code desc

/************************************************
*********  주스대리점 **************
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
ou.mobile,
ou.ex_dept_nm,
ou.ex_lgort_nm,
ou.ex_werks_nm,
ou.ex_jp_nm,
ou.ex_djp_nm,
ou.ex_emp_gu_nm,
ou.ex_branch_snm,
ou.ex_kostl_nm
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
AND ou.code in (
'460406',
'457988',
'457954',
'457662',
'456264',
'455251')

order by ou.code desc

/************************************************
*********  SCM 운영담당 **************
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
ou.mobile,
ou.ex_dept_nm,
ou.ex_lgort_nm,
ou.ex_werks_nm,
ou.ex_jp_nm,
ou.ex_djp_nm,
ou.ex_emp_gu_nm,
ou.ex_branch_snm,
ou.ex_kostl_nm
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
AND ou.code in (
'201361',
'20120391',
'20120383',
'90024',
'20301',
'20046748',
'08239',
'08298',
'08297',
'08274',
'08272',
'08271',
'08187',
'08292',
'08291',
'08288',
'08287',
'08285',
'08284',
'08275',
'08273',
'08186',
'08184',
'08182',
'2010A319',
'2010A318',
'08317',
'08318')
order by ou.code desc




/************************************************
*********  기타 **************
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
ou.mobile,
ou.ex_dept_nm,
ou.ex_lgort_nm,
ou.ex_werks_nm,
ou.ex_jp_nm,
ou.ex_djp_nm,
ou.ex_emp_gu_nm,
ou.ex_branch_snm,
ou.ex_kostl_nm
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
AND ou.code in (
'20146219',
'90119',
'90115',
'90114',
'91013',
'20146625',
'08278',
'08276',
'08277' )
order by ou.code desc





/************************************************
*********  기공 **************
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
ou.mobile,
ou.ex_dept_nm,
ou.ex_lgort_nm,
ou.ex_werks_nm,
ou.ex_jp_nm,
ou.ex_djp_nm,
ou.ex_emp_gu_nm,
ou.ex_branch_snm,
ou.ex_kostl_nm
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
AND ou.code in (
'50160',
'50159',
'50158',
'50157',
'50156',
'50155',
'90134',
'90133',
'90132',
'90131',
'90129',
'90128',
'90127',
'90126',
'90125',
'90124',
'90123',
'90122',
'90121',
'90027',
'50154',
'50151',
'90120',
'50150',
'50149',
'50147',
'50119',
'50118',
'50117',
'50116',
'50115',
'50114',
'50113',
'50112',
'50111',
'50110',
'50109',
'50108',
'90142',
'50146',
'50145',
'50123',
'50121',
'50120',
'50107',
'50106',
'50105',
'50104',
'50103',
'50102',
'50101',
'50100',
'50099',
'50098',
'50097',
'50144',
'50143',
'50142',
'50141',
'50140',
'50139',
'50138',
'50137',
'50136',
'50135',
'50134',
'50132',
'50131',
'50130',
'50129',
'50128',
'50127',
'50126',
'50125',
'50124',
'90146',
'50122',
'50096',
'91019',
'90200',
'90156',
'90148',
'50095',
'50094',
'50093',
'50065',
'50064',
'50063',
'50062',
'50061',
'50060',
'50059',
'50058',
'50057',
'50056',
'50055',
'50054',
'50053',
'50052',
'50051',
'50050',
'50092',
'50091',
'50090',
'50089',
'50088',
'50087',
'50069',
'50067',
'50066',
'50049',
'50048',
'50047',
'50046',
'50045',
'50044',
'50043',
'50042',
'50085',
'50084',
'50083',
'50082',
'50081',
'50080',
'50079',
'50078',
'50075',
'50074',
'50073',
'50072',
'50071',
'50070',
'50068',
'50041',
'50039',
'50010',
'50009',
'50008',
'50006',
'50005',
'50004',
'50003',
'50002',
'50001',
'50040',
'50038',
'50037',
'50036',
'50035',
'50034',
'50033',
'50032',
'50031',
'50030',
'50029',
'50028',
'50027',
'50025',
'50024',
'50014',
'50012',
'50011',
'50023',
'50022',
'50021',
'50019',
'50018',
'50017',
'50016',
'50015',
'50013',
'08294',
'50148',
'50161',
'50163',
'50162',
'08319',
'08320',
'50166',
'50165',
'50164',
'50170',
'50169',
'50168',
'50167',
'92104',
'92105',
'92110',
'92114' )
order by ou.code desc
















































































































































































































































