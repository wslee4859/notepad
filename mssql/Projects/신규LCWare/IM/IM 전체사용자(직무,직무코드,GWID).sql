select ou.domain_id,
ou.code, ou.name, ogu_pos.name, og.code, login_id   
from [dbo].[org_user] AS ou
	left outer join 
		(select a.user_id, b.group_id, b.name, a.org_id, b.ex_sort_key from dbo.org_group_user a inner join dbo.org_group b
		 on a.group_id = b.group_id where b.group_type_id = '1')  as ogu_pos
		on ou.user_id = ogu_pos.user_id and ou.group_id = ogu_pos.org_id
		left outer join dbo.org_group AS og
		on og.group_id = ogu_pos.group_id
where ou.status = '1' 
AND ou.domain_id in ('11','1')
AND ou.name not like '%test%'
AND ou.name not like '%ewf%'
AND ou.name not like '%관리자%'
AND ou.name not like '%테스트%'
AND ou.name not like '%server%'
AND ou.name not like '%master%'
AND ou.name not like '%lottechilsung%'
AND ou.name not like '%idea%'
AND ou.name not like '%mail%'
AND ou.name not like '%아사히%'
AND ou.name not like '%큐브%'
AND ou.name not like '%당직자%'
AND ou.name not like '%인사%'
order by domain_id desc, ou.name 

		--where ou.name = '이완상'

		--5021

		--select * from dbo.org_group  where name like '%사무직%'


		--(select a.user_id, b.group_id, b.name, a.org_id, b.ex_sort_key from dbo.org_group_user a inner join dbo.org_group b
		-- on a.group_id = b.group_id where b.group_type_id = '1' AND b.name = '사무직') 