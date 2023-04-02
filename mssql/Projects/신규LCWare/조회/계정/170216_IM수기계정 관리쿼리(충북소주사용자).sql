/******************************************
********* 하위 부서 조회 쿼리 **************
*******************************************/
	use im80

	WITH T_OU AS
	(
		SELECT 
			a.group_id,
			a.parent_id,
			a.name,
			a.status,
			a.ex_sort_key
		FROM org_group AS A 
		WHERE A.group_id in ('8331') AND A.status = '1'   --상위부서 입력


		UNION ALL
		SELECT 
			a.group_id,
			a.parent_id,
			a.name,
			a.status,
			a.ex_sort_key
		FROM org_group AS A INNER JOIN
			T_OU B ON A.parent_id = B.group_id
		    WHERE A.status = '1'       
	)
	--select * from T_OU order by ex_sort_key

/**************************************************
*********  충북소주 사용자 계정 조회 **************
***************************************************/

select ou.code ,
ou.name,
ou.login_id,
ogu_pos.name AS 직위, 
ogu_tit.name AS 직급,
ogu_wor.name AS 직책,
og1.name AS 상위부서,
og.name AS 부서, 
CASE WHEN EXISTS (select user_id from [dbo].[org_rule_user] where rule_group_id = '8215' AND user_id = ou.user_id) THEN 'Y' 
WHEN EXISTS (select user_id from [dbo].[org_group_user] where group_id = '8215' AND user_id = ou.user_id) THEN 'Y' ELSE 'N' END					AS MAIL, 
--og.code AS 그룹코드,
--og.ex_sort_key AS 정렬키,
ou.ex_lcware_yn AS LCWare사용여부 ,
ou.mobile,
ou.ex_display_yn
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
AND ou.group_id in (select group_id from T_OU) 
order by og.ex_sort_key, ou.code, ogu_tit.ex_sort_key desc





--'5397',
--'5403',
--'5433',
--'5514',
--'5518',
--'5505',
--'10671',
--'10696',
--'10681',
--'10697',
--'10682',
--'10698',
--'10683',
--'10684',
--'10699',
--'10685',
--'10686',
--'10700',
--'10687',
--'10701',
--'10688',
--'10689',
--'10702',
--'10690',
--'10691',
--'10692',
--'10693',
--'10694',
--'10703',
--'10695',
--'5467',
--'5491',
--'5567',
--'5564',
--'5669',
--'5578',
--'5565',
--'5562',
--'5559',
--'5560',
--'5561',
--'5558',
--'5519',
--'5624',
--'5573',
--'5549',
--'5577',
--'5574',
--'5576',
--'5572',
--'5563'







































































































































