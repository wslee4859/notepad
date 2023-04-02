

--  login_id 랑 이름이 같은 중복 사용자 찾기 
use im80
select login_id, name, count(*) from dbo.org_user
where login_id is not null
group by login_id, name
having count(*) > 1


-- login_id 만 같은 모든 중복 사용자 (로그인 아이디는 같지만 이름이 다른 사람도 포함)
use im80
select login_id, count(login_id) from dbo.org_user
where login_id is not null
group by login_id
having count(login_id) > 1

-- login_id 만 같은 모든 중복 사용자 (로그인 아이디는 같지만 이름이 다른 사람도 포함) 의 정보 select
use im80
select login_id, name, ex_dept_name from dbo.org_user where login_id in ( select login_id from dbo.org_user where login_id is not null group by login_id having count(login_id) > 1 )

-- 전산팀 제외 

select u.status, u.name, u.login_id, u.CODE AS [사번], u.email, dept.name, u.end_date, g_jikw.name AS '직위', g_jikm.name AS '직책', u.ex_dept_name, u.ex_yn_moin AS '모인사용여부',
	u.ex_enable_yn AS 'LCWare사용여부'
	from dbo.org_user AS u
	left join dbo.org_group AS g_jikm
	ON g_jikm.code =u.ex_duty_level 
	left join dbo.org_group as g_jikw
	on g_jikw.code = u.ex_duty_rank
	INNER JOIN dbo.org_group as dept
	on dept.group_id = u.group_id
	where login_id in
('chasy0329','chilsung2','chsk','dgyou','dlbtry','foreverangel','gsseong','jaehlee','jhlee','jilee','jjk3308','jkryou','jpkim','jskim1','k2jstar','karma076','keg1008','kimyc',
'klsj0466','kthci','lottebeer','parksw','pkyong65','rokmc','sbjo','sung','wdhwang','wplee','yhchoi','yjjung','ylcho', 'yoonbi', 'yskim3')
AND u.status = '1' AND (u.end_date > getdate() OR u.end_date is null)


select * from dbo.org_user















-------------------------------

chasy0329
chilsung2
chsk
dgyou
dlbtry
foreverangel
gsseong
jaehlee
jhlee
jilee
jjk3308
jkryou
jpkim
jskim1
k2jstar
karma076
keg1008
kimyc
klsj0466
kthci
lottebeer
parksw
pkyong65
rokmc
sbjo
sung
wdhwang
wplee
yhchoi
yjjung
ylcho
yoonbi
yskim3