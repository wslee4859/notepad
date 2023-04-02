use im80
select 
ou.name, 
ou.code, 
og.name,
ogu_pos.name AS 직위, 
ogu_tit.name AS 직급,
ogu_wor.name AS 직책,
ou.login_id
--ou.email,
--ou.ex_mmoin_yn
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
where ou.domain_id = '11' AND ou.login_id in (
'KK82',
'GOMASS',
'KYC',
'MUYEO',
'PINETREE',
'JOGIYONG',
'USUNG',
'SSTOH',
'SJOH',
'KIGONG',
'sd',
'DSOH',
'KWHIGH',
'JBU',
'YUN0503',
'BUKYUNG',
'DONGPYUNG',
'GRIS',
'KENZOJ',
'BOTRANS3',
'OPENMUN',
'WOOJIN01',
'YANGCG72',
'YB0242',
'BOTRANS2',
'SC-00101',
'SC-00201',
'SC-00301',
'SC-00401',
'SC-00501',
'SC-00601',
'SC-00701',
'SC-00801',
'SC-00901',
'SC-01001',
'SC-01101',
'SC-01201',
'SC-01301',
'SC-01401',
'SC-01501',
'SC-01601',
'SC-01701',
'SC-01801',
'SC-01901',
'SC-02001',
'SC-02101',
'SC-02201',
'SC-02301',
'SC-02401',
'SC-02601',
'SC-02701',
'SC-02801',
'SC-02901',
'SC-03001',
'SC-03101',
'SC-03201',
'SC-03301',
'SC-03401',
'SC-03501',
'SC-03601',
'SC-03701',
'SC-03801',
'SC-03901',
'SC-04001',
'SC-04101',
'SC-04201',
'SC-04301',
'SC-04401',
'SC-04501',
'SC-04601',
'SC-04701',
'SC-04801',
'SC-04901',
'SC-05001',
'SC-05101',
'SC-05201',
'SC-05301',
'SC-05401',
'SC-05501',
'SC-05601',
'SC-05701',
'SC-05801',
'SC-05901',
'SC-06001',
'SC-06101',
'YHU1210',
'SMWDTC78',
'CBS0027',
'JAJAVA2003',
'PSB1234',
'OJKWON',
'20047562',
'JY5341',
'GH0862',
'CHOIHO0',
'BSJ0253',
'SPEERS77',
'WOWOW0825',
'GOODEGG2',
'SUSINO',
'JJIN1201',
'HG80HG',
'K12W12',
'DHEMA81',
'CYM0685',
'HAND7067',
'2010A325',
'SYH3746',
'YANAGI80',
'LJH8010',
'SUNPLUS38',
'KSA101143',
'20060761',
'20060421',
'KSE071',
'CYB8886',
'DUDGY',
'KBG801',
'KROUN123',
'YKW1204',
'POLO1654',
'JINJIN7576',
'EASY918',
'RLFWOALS89',
'DWJO2622',
'QOGJSL83',
'HMKIM',
'HANSALAG',
'BH9077',
'KB4690',
'SW2100',
'SOLOVE',
'SGKANG',
'JS9577',
'9DRA21',
'JSOH1',
'KIMYI219',
'SJD80',
'JHYUN1',
'KIMJH',
'1HO',
'JSH0420',
'DUNHILL',
'JBLEE1',
'DHJEON',
'JUNIK81',
'NUNIKI',
'MOO821022',
'YI650804',
'KAREYA74',
'20150334',
'OYH76',
'ABWLRTMXK',
'DBTJSTLR1' )







































































--[dbo].[org_rule_user] where rule_group_id = '8361'