-- ���� ����� ���� ���� ���� ver 3
-- ������ �� ����������. ǥ�ø� ���� ������ ���̺� ��ȸ
use Common
select 
U.employee_num,
P.user_name,
P.email,
P.mobile,
P.group_name,
P.parent_group_name,
P.position_name
from [IM].[VIEW_PLURAL] AS P
left join IM.VIEW_ORG AS O
on P.group_code = O.group_code
left join [IM].[VIEW_USER] AS U
on P.user_code = U.user_code
where P.domain_name = '�Ե�����' 
AND (U.display_yn is null OR U.display_yn = 'Y')
AND (P.display_yn is null OR P.display_yn = 'Y')
AND U.email is not null
AND P.user_name = '�̿�ǥ'
order by O.seq, P.classpos_seq, P.user_name



-- ������ ����(���� ��ȹ������ 2016-12-12 ver )
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
CASE WHEN EXISTS (select user_id from [10.103.1.108].im80.[dbo].[org_rule_user] where rule_group_id = '8215' AND user_id = U.user_code) THEN 'Y' 
WHEN EXISTS (select user_id from [10.103.1.108].im80.[dbo].[org_group_user] where group_id = '8215' AND user_id = U.user_code) THEN 'Y' ELSE 'N' END					AS MAIL
from [IM].[VIEW_USER] AS U
left join IM.VIEW_ORG AS O
on U.group_code = O.group_code
WHERE (U.display_yn = 'Y' OR U.display_yn is null)
AND U.domain_name = '�Ե�����'
AND U.email is not null
--AND U.user_name = '���п�'
AND U.group_name not like '%����%'
AND U.group_name not like '%������Ʈ%'
AND U.parent_group_name not like '%������Ʈ%'
AND (U.classpos_name not in ('����','�󹫺�A','�󹫺�B','�ڹ�','��','ȸ��','����','�λ���','�Ѱ�ȸ��') OR U.classpos_name is NULL) --2018-06-19 ������븮 ��û
order by O.seq, U.classpos_seq

--���� ������(������ seq�� ������ �������� ����)
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
CASE WHEN EXISTS (select user_id from [10.103.1.108].im80.[dbo].[org_rule_user] where rule_group_id = '8215' AND user_id = U.user_code) THEN 'Y' 
WHEN EXISTS (select user_id from [10.103.1.108].im80.[dbo].[org_group_user] where group_id = '8215' AND user_id = U.user_code) THEN 'Y' ELSE 'N' END					AS MAIL
from [IM].[VIEW_USER] AS U
left join IM.VIEW_ORG AS O
on U.group_code = O.group_code
WHERE (U.display_yn = 'Y' OR U.display_yn is null)
AND U.domain_name = '�Ե�����'
AND U.email is not null
--AND U.user_name = '���п�'
AND U.group_name like '%����%'
AND (U.classpos_name not in ('����','�󹫺�A','�󹫺�B','�ڹ�','��','ȸ��','����','�λ���','�Ѱ�ȸ��') OR U.classpos_name is NULL)
order by O.seq, U.classpos_seq






-- �ַ� ��
select
U.domain_name, 
U.parent_group_name,
U.group_name,
U.User_name,
U.responsibility_name,
U.position_name,
U.classpos_name,
U.email,
U.employee_num,
U.display_yn
from [IM].[VIEW_USER] AS U
left join IM.VIEW_ORG AS O
on U.group_code = O.group_code
WHERE (U.display_yn = 'Y' OR U.display_yn is null)
AND U.domain_name = '�Ե��ַ�'
AND U.email is not null
-- AND U.email  like '%@lotte.net' ��ϼ��� ���� ��
AND employee_num not like '%CB%'
--AND U.user_name = '���п�'
order by O.seq, U.classpos_seq



-- ������ ��ȸ
select domain_name, login_id, user_name, group_name, parent_group_name, position_name, email
from [IM].[VIEW_PLURAL] 
where user_code in (select user_code from  [IM].[VIEW_PLURAL] group by user_code  having count(user_code)>1 )
AND domain_name = '�Ե�����'


-- ���� �����ڸ� 
select domain_name, login_id, user_name, group_name, parent_group_name, position_name, email
from [IM].[VIEW_PLURAL] 
where user_code in (select user_code from  [IM].[VIEW_PLURAL] where domain_name = '�Ե�����' group by user_code  having count(user_code)>1 )
AND domain_name = '�Ե�����'


-- ������ ��ȸ
select domain_name, login_id, user_name, group_name, parent_group_name, position_name, email
from [IM].[VIEW_PLURAL] 
where user_code in (select user_code from  [IM].[VIEW_PLURAL] where domain_name = '�Ե��ַ�' group by user_code  having count(user_code)>1 )
