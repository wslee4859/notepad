-- �����α��� �ð� ���� (���� ��ȹ������ 2018-03-08 ver )
select
O.seq,
U.domain_name, 
U.parent_group_name,
U.group_name,
U.User_name,
U.responsibility_name,
U.position_name,
U.classpos_name,
U.email,
U.employee_num,
U.display_yn,
M.last_login_date,
U.login_id,
CASE WHEN EXISTS (select user_id from [10.103.1.108].im80.[dbo].[org_rule_user] where rule_group_id = '8215' AND user_id = U.user_code) THEN 'Y' 
WHEN EXISTS (select user_id from [10.103.1.108].im80.[dbo].[org_group_user] where group_id = '8215' AND user_id = U.user_code) THEN 'Y' ELSE 'N' END					AS MAIL
from [IM].[VIEW_USER] AS U
left join IM.VIEW_ORG AS O
on U.group_code = O.group_code
left join [CM].[Member] AS M
on U.user_code = M.id
WHERE (U.display_yn = 'Y' OR U.display_yn is null)
AND U.domain_name = '�Ե�����'
--AND U.email is not null
--AND U.user_name = '���п�'
AND U.group_name not like '%����%'
AND U.group_name not like '%CH%'
AND U.group_name not like '%����%'
AND U.group_name not like '%������Ʈ%'
AND U.parent_group_name not like '%������Ʈ%'
AND U.User_name != '�ŵ���'
order by O.seq, U.classpos_seq

