

-- IM80(IM DB)의 계정을 두개 이상 가지고 있는 사용자 체크

use im80
select login_id, name, count(*) from dbo.org_user
where login_id is not null
group by login_id, name
having count(*) > 1

select * from dbo.org_user
where name = '성국현'

select * from dbo.org_user
where login_id = 'sung'

select * from dbo.org_group

select login_id, ex_dept_name, email, end_date from dbo.org_user
where name = '김관우'

select u.status, u.name, u.login_id, u.CODE AS [사번], u.email, dept.name, u.end_date, g_jikw.name AS '직위', g_jikm.name AS '직책', ex_dept_name
	from dbo.org_user AS u
	left join dbo.org_group AS g_jikm
	ON g_jikm.code =u.ex_duty_level 
	left join dbo.org_group as g_jikw
	on g_jikw.code = u.ex_duty_rank
	INNER JOIN dbo.org_group as dept
	on dept.group_id = u.group_id
	where login_id in
(
'lottebeer','keg1008','yskim3','karma076','jpkim','klsj0466','chilsung2','chsk','kthci','jkryou','pkyong65','gsseong','dgyou','yoonbi',
'wplee','dlbtry','jhlee','foreverangel','sbjo','ylcho','jjk3308','chasy0329','k2jstar','wdhwang')
	AND u.status = '1'


select * from dbo.org_user where login_id in
(
'lottebeer','keg1008','yskim3','karma076','jpkim','klsj0466','chilsung2','chsk','kthci','jkryou','pkyong65','gsseong','dgyou','yoonbi',
'wplee','dlbtry','jhlee','foreverangel','sbjo','ylcho','jjk3308','chasy0329','k2jstar','wdhwang')


select * from [dbo].[org_group_type]
select * from [dbo].[org_group] where group_type_id ='2' and domain_id ='1'
select * from dbo.org_user where name ='이원표'


select ex_dept_name, * from org_user where domain_id ='1'
