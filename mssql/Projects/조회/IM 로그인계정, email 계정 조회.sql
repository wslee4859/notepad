
--  login_id, email�� �ٸ� ���. 
use im80
select domain_id, name, login_id, email, ex_dept_nm  from [dbo].[org_user]    --domain_id, name, login_id, email, ex_dept_nm
where status = '1'
	AND domain_id = '1'
	AND (end_date > getdate() 
	OR end_date is null  )
	AND email is not null



------------------------------
	use im80
select u.name, u.login_id, u.CODE AS [���], u.email, dept.name, u.end_date, g_jikw.name AS '����', g_jikm.name AS '��å', u.ex_dept_nm, u.ex_yn_moin AS '���λ�뿩��'
	from dbo.org_user AS u
	left join dbo.org_group AS g_jikm
	ON g_jikm.code =u.ex_duty_level 
	left join dbo.org_group as g_jikw
	on g_jikw.code = u.ex_duty_rank
	left JOIN dbo.org_group as dept
	on dept.group_id = u.group_id
	where 1=1
	AND u.status = '1'
	AND u.domain_id = '1'
	AND (u.end_date > getdate() 
	OR u.end_date is null  )
	AND u.email is not null




	


