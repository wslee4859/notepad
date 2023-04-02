--select top 1 * from [dbo].[org_user] where name = '±è¼º°â'
select * from [dbo].[org_group_user] where user_id = '51471'
select 
	U.status,
	U.sec_level,
	U.group_id,
	U.code,
	G.name,
	U.name,
	U.login_id,
	U.create_dt,
	ex_lcware_yn,
	ex_display_yn,
	U.start_date,
	U.end_date
from [dbo].[org_user] AS U
left join [dbo].[org_group] AS G
ON G.group_id = U.group_id
left join [dbo].[org_group_user] AS A inner join dbo.org_group AS B
ON a.group_id = b.group_id AS ogu_tit


	left outer join 
	(select a.user_id, b.group_id, b.name, a.org_id, b.ex_sort_key from dbo.org_group_user a inner join dbo.org_group b
	 on a.group_id = b.group_id where b.group_type_id = '11')  as ogu_tit 



	on ou.user_id = ogu_tit.user_id and ou.group_id = ogu_tit.org_id


 where U.domain_id = '11'
	AND U.group_id in (
	-- CH ºÎ¼­ 
'5434',
'8404',
'8409',
'8408',
'8407',
'8410',
'8411',
'5436',
'8406',
'8415',
'8416',
'8417',
'8403',
'5437',
'8405',
'8412',
'8413',
'8414',
'8401',
'8391',
'8418',
'5385',
'8402' )



 
 
 
 select * from  [dbo].[org_group] where name like '%CH%'

5434
8404
8409
8408
8407
8410
8411
5436
8406
8415
8416
8417
8403
5437
8405
8412
8413
8414
8401
8391
8418
5385
8402