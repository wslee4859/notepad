
USE COMMON

/*���� ����Ʈ ���� ���� �ο� */
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
AND U.user_name not like '%������%'
AND U.user_name not like '%�׽�Ʈ%'
AND U.user_name not like '%server%'
AND U.user_name not like '%master%'
AND U.user_name not like '%lottechilsung%'
AND U.user_name not like '%idea%'
AND U.user_name not like '%mail%'
AND U.user_name not like '%�ƻ���%'
AND U.user_name not like '%ť��%'
AND U.user_name not like '%������%'
AND U.user_name not like '%�λ�%'
AND U.parent_group_name not in ('������','���ߴ��','����')
AND U.group_name not in ('������')
ORDER BY domain_name, O.seq 


/*�ַ� ����Ʈ ���� ���� �ο� */
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
AND U.user_name not like '%������%'
AND U.user_name not like '%�׽�Ʈ%'
AND U.user_name not like '%server%'
AND U.user_name not like '%master%'
AND U.user_name not like '%lottechilsung%'
AND U.user_name not like '%idea%'
AND U.user_name not like '%mail%'
AND U.user_name not like '%�ƻ���%'
AND U.user_name not like '%ť��%'
AND U.user_name not like '%������%'
AND U.user_name not like '%�λ�%'
AND U.parent_group_name not in ('������','���ߴ��','����')
AND U.group_name not in ('������')
ORDER BY domain_name, O.seq 


/*CH ����Ʈ ���� ���� �ο� */
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
AND U.user_name not like '%������%'
AND U.user_name not like '%�׽�Ʈ%'
AND U.user_name not like '%server%'
AND U.user_name not like '%master%'
AND U.user_name not like '%lottechilsung%'
AND U.user_name not like '%idea%'
AND U.user_name not like '%mail%'
AND U.user_name not like '%�ƻ���%'
AND U.user_name not like '%ť��%'
AND U.user_name not like '%������%'
AND U.user_name not like '%�λ�%'
AND U.parent_group_name not in ('������','���ߴ��','����')
AND U.group_name not in ('������')
ORDER BY domain_name, O.seq 


/*�������� ����Ʈ ���� ���� �ο� */
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
AND U.user_name not like '%������%'
AND U.user_name not like '%�׽�Ʈ%'
AND U.user_name not like '%server%'
AND U.user_name not like '%master%'
AND U.user_name not like '%lottechilsung%'
AND U.user_name not like '%idea%'
AND U.user_name not like '%mail%'
AND U.user_name not like '%�ƻ���%'
AND U.user_name not like '%ť��%'
AND U.user_name not like '%������%'
AND U.user_name not like '%�λ�%'
AND U.parent_group_name not in ('������','���ߴ��','����')
AND U.group_name not in ('������')
ORDER BY domain_name, O.seq 


/*���� ����Ʈ ���� ���� �ο� */
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
AND U.user_name not like '%������%'
AND U.user_name not like '%�׽�Ʈ%'
AND U.user_name not like '%server%'
AND U.user_name not like '%master%'
AND U.user_name not like '%lottechilsung%'
AND U.user_name not like '%idea%'
AND U.user_name not like '%mail%'
AND U.user_name not like '%�ƻ���%'
AND U.user_name not like '%ť��%'
AND U.user_name not like '%������%'
AND U.user_name not like '%�λ�%'
AND U.parent_group_name not in ('������','���ߴ��','����')
AND U.group_name not in ('������')

ORDER BY domain_name, O.seq 



/*�ܺ� ���� ����*/
/********************************
* �׷���� �ܺα��� ����� ��ȸ 
*********************************/
select ou.ex_comp_nm, ou.code, ou.login_id, ou.name, og.name, og1.name, ogu_wor.name AS ��å, ogu_tit.name AS ����, ogu_pos.name AS ����
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
AND og.name not in  ('������')
AND og1.name not in  ('������','����','���ߴ��')
AND og.name not like '%�ƻ���%'
AND ou.name not like '%ewf%'
AND ou.name not like '%�׽�Ʈ%'
AND ou.name not like '%CP119%'
AND ou.status = '1'
order by og.ex_sort_key


/*���� ��� ����*/
/********************************
* �׷���� ���� ����� ��ȸ
*********************************/
select ou.ex_comp_nm, ou.code, ou.login_id, ou.name, og.name, og1.name, ogu_wor.name AS ��å, ogu_tit.name AS ����, ogu_pos.name AS ����
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
AND og.name not in  ('������')
AND og1.name not in  ('������','����','���ߴ��')
AND og.name not like '%�ƻ���%'
AND ou.name not like '%ewf%'
AND ou.name not like '%�׽�Ʈ%'
AND ou.name not like '%CP119%'
AND ou.status = '1'
order by og.ex_sort_key

