use im80
select u.status
	, u.name
	, u.login_id
	, u.CODE AS [사번]
	, u.email, dept.name
	, u.end_date
	, g_jikw.name AS '직위'
	, g_jikm.name AS '직책'
	, u.ex_dept_name
	, u.ex_yn_moin AS '모인사용여부'
	,u.ex_enable_yn AS 'LCWare사용여부'

	from dbo.org_user AS u
	left join dbo.org_group AS g_jikm
	ON g_jikm.code =u.ex_duty_level 
	left join dbo.org_group as g_jikw
	on g_jikw.code = u.ex_duty_rank
	INNER JOIN dbo.org_group as dept
	on dept.group_id = u.group_id
	where 1=1
	AND u.login_id = '1054058912'
	OR u.Code = '1054058912'
	--AND u.status = '1' AND (u.end_date > getdate() OR u.end_date is null)
