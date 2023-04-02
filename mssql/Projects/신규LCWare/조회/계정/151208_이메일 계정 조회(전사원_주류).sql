-- �ַ� ����� ���� ���� ���� ver 1
use Common
select 
U.domain_name,
U.employee_num,
U.User_name,
U.email,
U.group_name,
U.parent_group_name,
O.seq,
U.responsibility_name,
U.position_name, 
U.classpos_name,
U.display_yn
from 
[IM].[VIEW_USER] AS U
left join IM.VIEW_ORG AS O
on U.group_code = O.group_code
where U.domain_code = '1'
AND U.email is not null
AND (U.display_yn is null OR U.display_yn = 'Y')
order by O.seq 

-- �ַ� ����� ���� ���� ���� ver 2
-- ������ �� ������ ǥ�ø� ���� ������ ���̺� ��ȸ
use Common
select 
U.employee_num,
P.user_name,
U.email,
U.mobile,
U.group_name,
U.parent_group_name
from [IM].[VIEW_PLURAL] AS P
left join IM.VIEW_ORG AS O
on P.group_code = O.group_code
left join [IM].[VIEW_USER] AS U
on P.user_code = U.user_code
where P.domain_name = '�Ե��ַ�' 
AND (U.display_yn is null OR U.display_yn = 'Y')
AND (P.display_yn is null OR P.display_yn = 'Y')
order by O.seq, P.classpos_seq, P.user_name
 

 
 IM.VIEW_ORG where name = '������'
 [IM].[VIEW_USER] where user_name = '������'


