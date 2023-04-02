use Common
select 
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
where U.domain_code = '11'
--AND responsibility_name = '사원'
AND U.email is not null
--AND classpos_name != '직급미확인'
AND (U.display_yn is null OR U.display_yn = 'Y')
order by O.seq 


[IM].[VIEW_ORG]


select * from [IM].[VIEW_USER] where display_yn = 'N'