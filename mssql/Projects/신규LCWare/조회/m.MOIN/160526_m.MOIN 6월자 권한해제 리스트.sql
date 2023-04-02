/***************************
m.MOIN (05-26 권한해제)사용자  조회
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
AND ou.login_id in (
'74hsw',
'7sung42da',
'bolee',
'bsshin',
'cksong',
'dhchoi',
'haemo',
'helloween',
'hss73',
'hsublee',
'hypark1',
'junkim',
'junmin',
'kimsunchang',
'kkyom',
'ktkim',
'kyil429',
'mheepark',
'mkkoo',
'shjo',
'songsmi',
'wysung',
'younga',
'19705861',
'1990131A',
'CGOH',
'chojinyoung',
'chong',
'cylee',
'dudrnr-09',
'ekaqo',
'enury',
'eylee',
'flyteddy',
'ggacjin',
'gsickkim',
'hcnc12345',
'hisubi7',
'ilovekisses',
'iysung',
'jgsea',
'jclee',
'jdlotte',
'jhlee3',
'jjaelee',
'john0809',
'jskim1',
'jykim1',
'kbsin',
'ksj77',
'kychoi',
'lsw64',
'malls4',
'mgkim',
'mjunkim',
'mrjun',
'ms6939',
'msukim',
'psku',
'sinji0826',
'white02',
'wodyddkqja',
'xman2k',
'ybkim',
'yjjung1',
'ymjang',
'yoen',
'ysh1247',
'ywjung1',
'dydwnek',
'eunson',
'gsseong',
'hjkim',
'jkryou',
'pyk0913',
'starpiglet',
'tgsong',
'chilsung2',
'chleepower',
'chy',
'cksis',
'hwkwon',
'jose1012',
'pks728',
'shlee',
'7sktw',
'jgyang',
'jkm',
'kyb9293',
'leesejin',
'osg8577a',
'rlarldud',
'sy1lee' )

































































































