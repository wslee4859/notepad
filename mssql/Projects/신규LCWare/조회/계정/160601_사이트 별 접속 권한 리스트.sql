
USE COMMON

/*음료 사이트 접속 권한 인원 */
select U.domain_name, employee_num,  login_id, user_name, group_name, parent_group_name, responsibility_name, classpos_name, position_name, U.display_yn
from [IM].[VIEW_USER] AS U
left join [IM].[VIEW_ORG] AS O
ON U.group_code = O.group_code
WHERE U.user_code in (
									select user_code FROM [IM].[VIEW_USER_GROUP] 
									where group_code in ( select GroupID from [CM].[MenuAuthority] where MenuID = '10002' AND AuthRead = '1' ))
AND U.user_code not in ( select user_code FROM [IM].[VIEW_USER_GROUP] 
									where group_code in ( select GroupID from [CM].[MenuAuthority] where MenuID = '10002' AND AuthDeny = '1' ))
AND U.user_name not like '%test%'
AND U.user_name not like '%ewf%'
AND U.user_name not like '%관리자%'
AND U.user_name not like '%테스트%'
AND U.user_name not like '%server%'
AND U.user_name not like '%master%'
AND U.user_name not like '%lottechilsung%'
AND U.user_name not like '%idea%'
AND U.user_name not like '%mail%'
AND U.user_name not like '%아사히%'
AND U.user_name not like '%큐브%'
AND U.user_name not like '%당직자%'
AND U.user_name not like '%인사%'
AND U.parent_group_name not in ('전산팀','개발담당','운영담당')
AND U.group_name not in ('전산팀')
ORDER BY domain_name, O.seq 


/*주류 사이트 접속 권한 인원 */
select U.domain_name, employee_num,  login_id, user_name, group_name, parent_group_name, responsibility_name, classpos_name, position_name, U.display_yn
from [IM].[VIEW_USER] AS U
left join [IM].[VIEW_ORG] AS O
ON U.group_code = O.group_code
WHERE U.user_code in (
									select user_code FROM [IM].[VIEW_USER_GROUP] 
									where group_code in ( select GroupID from [CM].[MenuAuthority] where MenuID = '10127' AND AuthRead = '1' ))
AND U.user_code not in ( select user_code FROM [IM].[VIEW_USER_GROUP] 
									where group_code in ( select GroupID from [CM].[MenuAuthority] where MenuID = '10127' AND AuthDeny = '1' ))
AND U.user_name not like '%test%'
AND U.user_name not like '%ewf%'
AND U.user_name not like '%관리자%'
AND U.user_name not like '%테스트%'
AND U.user_name not like '%server%'
AND U.user_name not like '%master%'
AND U.user_name not like '%lottechilsung%'
AND U.user_name not like '%idea%'
AND U.user_name not like '%mail%'
AND U.user_name not like '%아사히%'
AND U.user_name not like '%큐브%'
AND U.user_name not like '%당직자%'
AND U.user_name not like '%인사%'
AND U.parent_group_name not in ('전산팀','개발담당','운영담당')
AND U.group_name not in ('전산팀')
ORDER BY domain_name, O.seq 


/*CH 사이트 접속 권한 인원 */
select U.domain_name, employee_num,  login_id, user_name, group_name, parent_group_name, responsibility_name, classpos_name, position_name, U.display_yn  from [IM].[VIEW_USER] AS U
left join [IM].[VIEW_ORG] AS O
ON U.group_code = O.group_code
WHERE U.user_code in (
									select user_code FROM [IM].[VIEW_USER_GROUP] 
									where group_code in ( select GroupID from [CM].[MenuAuthority] where MenuID = '10292' AND AuthRead = '1' ))
AND U.user_code not in ( select user_code FROM [IM].[VIEW_USER_GROUP] 
									where group_code in ( select GroupID from [CM].[MenuAuthority] where MenuID = '10292' AND AuthDeny = '1' ))
AND U.user_name not like '%test%'
AND U.user_name not like '%ewf%'
AND U.user_name not like '%관리자%'
AND U.user_name not like '%테스트%'
AND U.user_name not like '%server%'
AND U.user_name not like '%master%'
AND U.user_name not like '%lottechilsung%'
AND U.user_name not like '%idea%'
AND U.user_name not like '%mail%'
AND U.user_name not like '%아사히%'
AND U.user_name not like '%큐브%'
AND U.user_name not like '%당직자%'
AND U.user_name not like '%인사%'
AND U.parent_group_name not in ('전산팀','개발담당','운영담당')
AND U.group_name not in ('전산팀')
ORDER BY domain_name, O.seq 


/*백학음료 사이트 접속 권한 인원 */
select U.domain_name, employee_num,  login_id, user_name, group_name, parent_group_name, responsibility_name, classpos_name, position_name  from [IM].[VIEW_USER] AS U
left join [IM].[VIEW_ORG] AS O
ON U.group_code = O.group_code
WHERE U.user_code in (
									select user_code FROM [IM].[VIEW_USER_GROUP] 
									where group_code in ( select GroupID from [CM].[MenuAuthority] where MenuID = '10389' AND AuthRead = '1' ))
AND U.user_code not in ( select user_code FROM [IM].[VIEW_USER_GROUP] 
									where group_code in ( select GroupID from [CM].[MenuAuthority] where MenuID = '10389' AND AuthDeny = '1' ))
AND U.user_name not like '%test%'
AND U.user_name not like '%ewf%'
AND U.user_name not like '%관리자%'
AND U.user_name not like '%테스트%'
AND U.user_name not like '%server%'
AND U.user_name not like '%master%'
AND U.user_name not like '%lottechilsung%'
AND U.user_name not like '%idea%'
AND U.user_name not like '%mail%'
AND U.user_name not like '%아사히%'
AND U.user_name not like '%큐브%'
AND U.user_name not like '%당직자%'
AND U.user_name not like '%인사%'
AND U.parent_group_name not in ('전산팀','개발담당','운영담당')
AND U.group_name not in ('전산팀')
ORDER BY domain_name, O.seq 


/*신협 사이트 접속 권한 인원 */
select U.domain_name, employee_num,  login_id, user_name, group_name, parent_group_name, responsibility_name, classpos_name, position_name  from [IM].[VIEW_USER] AS U
left join [IM].[VIEW_ORG] AS O
ON U.group_code = O.group_code
WHERE U.user_code in (
									select user_code FROM [IM].[VIEW_USER_GROUP] 
									where group_code in ( select GroupID from [CM].[MenuAuthority] where MenuID = '10439' AND AuthRead = '1' ))
AND U.user_code not in ( select user_code FROM [IM].[VIEW_USER_GROUP] 
									where group_code in ( select GroupID from [CM].[MenuAuthority] where MenuID = '10439' AND AuthDeny = '1' ))
AND U.user_name not like '%test%'
AND U.user_name not like '%ewf%'
AND U.user_name not like '%관리자%'
AND U.user_name not like '%테스트%'
AND U.user_name not like '%server%'
AND U.user_name not like '%master%'
AND U.user_name not like '%lottechilsung%'
AND U.user_name not like '%idea%'
AND U.user_name not like '%mail%'
AND U.user_name not like '%아사히%'
AND U.user_name not like '%큐브%'
AND U.user_name not like '%당직자%'
AND U.user_name not like '%인사%'
AND U.parent_group_name not in ('전산팀','개발담당','운영담당')
AND U.group_name not in ('전산팀')

ORDER BY domain_name, O.seq 



/*외부 접속 권한*/
/********************************
* 그룹웨어 외부권한 사용자 조회 
*********************************/
select ou.ex_comp_nm, ou.code, ou.login_id, ou.name, og.name, og1.name, ogu_wor.name AS 직책, ogu_tit.name AS 직급, ogu_pos.name AS 직위
from [10.103.1.108].[im80].[dbo].[org_user] AS ou
left join [10.103.1.108].[im80].[dbo].[org_group] AS og
ON ou.group_id = og.group_id
left join [10.103.1.108].[im80].[dbo].[org_group] AS og1
ON og.parent_id = og1.group_id
	left outer join 
		(select a.user_id, b.group_id, b.name, a.org_id, b.ex_sort_key from [10.103.1.108].[im80].dbo.org_group_user a inner join [10.103.1.108].[im80].dbo.org_group b
		 on a.group_id = b.group_id where b.group_type_id = '1')  as ogu_pos
		on ou.user_id = ogu_pos.user_id and ou.group_id = ogu_pos.org_id
		left outer join 
		(select a.user_id, b.group_id, b.name, a.org_id, b.ex_sort_key from [10.103.1.108].[im80].dbo.org_group_user a inner join [10.103.1.108].[im80].dbo.org_group b
		 on a.group_id = b.group_id where b.group_type_id = '11')  as ogu_tit 
		on ou.user_id = ogu_tit.user_id and ou.group_id = ogu_tit.org_id
		left outer join 
		(select a.user_id, b.group_id, b.name, a.org_id, b.ex_sort_key from [10.103.1.108].[im80].dbo.org_group_user a inner join [10.103.1.108].[im80].dbo.org_group b
		 on a.group_id = b.group_id where b.group_type_id = '2')  as ogu_wor
		on ou.user_id = ogu_wor.user_id and ou.group_id = ogu_wor.org_id
where 1=1
AND ou.user_id in (select user_id from [10.103.1.108].[im80].[dbo].[org_rule_user] where rule_group_id = '8361')
AND og.name not in  ('전산팀')
AND og1.name not in  ('전산팀','운영담당','개발담당')
AND og.name not like '%아사히%'
AND ou.name not like '%ewf%'
AND ou.name not like '%테스트%'
AND ou.name not like '%CP119%'
AND ou.status = '1'
order by og.ex_sort_key


/*메일 사용 권한*/
/********************************
* 그룹웨어 메일 사용자 조회
*********************************/
select ou.ex_comp_nm, ou.code, ou.login_id, ou.name, og.name, og1.name, ogu_wor.name AS 직책, ogu_tit.name AS 직급, ogu_pos.name AS 직위
from [10.103.1.108].[im80].[dbo].[org_user] AS ou
left join [10.103.1.108].[im80].[dbo].[org_group] AS og
ON ou.group_id = og.group_id
left join [10.103.1.108].[im80].[dbo].[org_group] AS og1
ON og.parent_id = og1.group_id
	left outer join 
		(select a.user_id, b.group_id, b.name, a.org_id, b.ex_sort_key from [10.103.1.108].[im80].dbo.org_group_user a inner join [10.103.1.108].[im80].dbo.org_group b
		 on a.group_id = b.group_id where b.group_type_id = '1')  as ogu_pos
		on ou.user_id = ogu_pos.user_id and ou.group_id = ogu_pos.org_id
		left outer join 
		(select a.user_id, b.group_id, b.name, a.org_id, b.ex_sort_key from [10.103.1.108].[im80].dbo.org_group_user a inner join [10.103.1.108].[im80].dbo.org_group b
		 on a.group_id = b.group_id where b.group_type_id = '11')  as ogu_tit 
		on ou.user_id = ogu_tit.user_id and ou.group_id = ogu_tit.org_id
		left outer join 
		(select a.user_id, b.group_id, b.name, a.org_id, b.ex_sort_key from [10.103.1.108].[im80].dbo.org_group_user a inner join [10.103.1.108].[im80].dbo.org_group b
		 on a.group_id = b.group_id where b.group_type_id = '2')  as ogu_wor
		on ou.user_id = ogu_wor.user_id and ou.group_id = ogu_wor.org_id
where 1=1
AND ou.user_id in (select user_id from [10.103.1.108].[im80].[dbo].[org_rule_user] where rule_group_id = '8215')
AND og.name not in  ('전산팀')
AND og1.name not in  ('전산팀','운영담당','개발담당')
AND og.name not like '%아사히%'
AND ou.name not like '%ewf%'
AND ou.name not like '%테스트%'
AND ou.name not like '%CP119%'
AND ou.status = '1'
order by og.ex_sort_key

