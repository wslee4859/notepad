/****************************************
*********  IM 계정 조회 *****************
주류 영업본부 리스트 (마케팅, 영업전략부문 및 하위부서 제외)
*****************************************/

use im80
select ou.code ,
ou.name,
ou.login_id,
ogu_pos.name AS 직위, 
ogu_tit.name AS 직급,
ogu_wor.name AS 직책,
og.name AS 부서, 
og1.name AS [1상위부서],
og2.name AS [2상위부서],
--og.code AS 그룹코드,
--og.ex_sort_key AS 정렬키,
ou.ex_lcware_yn AS LCWare사용여부, 
og.ex_sort_key
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
--left join [dbo].[org_group] as ogg
--on ou.group_id = og2.group_id	
where ou.domain_id = '1' 
AND ou.status = '1' 
--AND ou.name = '고현진'
--AND (ou.sec_level = '2' OR ou.code in (select code from [dbo].[lotte_sync_bulk_user])  )   -- CH 대량 사용자 로그인 
AND ou.group_id in (
'111',
'115',
'160',
'168',
'169',
'9341',
'9342',
'9772',
'184',
'185',
'186',
'190',
'9344',
'9345',
'9346',
'9356',
'9357',
'9353',
'9354',
'9355',
'368',
'369',
'370',
'371',
'351',
'352',
'9343',
'9349',
'9350',
'9352',
'187',
'188',
'197',
'254',
'284',
'285',
'297',
'294',
'302',
'298',
'299',
'301',
'191',
'193',
'194',
'198',
'199',
'204',
'206',
'211',
'341',
'342',
'344',
'345',
'346',
'348',
'7147',
'304',
'328',
'9348',
'9351',
'9358',
'9360',
'9362',
'9359',
'9361',
'9363',
'459',
'183',
'196',
'201',
'203',
'205',
'209',
'212',
'8461',
'427',
'462',
'463',
'478',
'517',
'325',
'326',
'327',
'511',
'513',
'7143',
'7146',
'7695',
'7696',
'516',
'7694',
'484',
'498',
'7693',
'395',
'401',
'405',
'407',
'464',
'466',
'514',
'7148',
'467',
'468',
'470',
'471',
'472',
'474',
'476',
'7144',
'7145',
'391',
'421',
'424',
'449',
'450',
'451',
'452',
'453',
'454',
'518',
'366',
'372',
'373',
'376',
'9841',
'9842',
'9843',
'9844',
'9845',
'9847',
'9846',
'9848',
'9851',
'9849',
'9850',
'9852',
'435',
'438',
'436',
'439',
'441',
'480',
'444',
'497',
'312',
'313',
'315',
'316',
'324',
'317',
'318',
'354',
'359',
'363',
'378',
'383',
'485',
'500',
'487',
'488',
'489',
'7142',
'481',
'482',
'499',
'502',
'442',
'505',
'507',
'508',
'509',
'510' )
order by cast(og.ex_sort_key AS int), ou.code desc
















































































































































































