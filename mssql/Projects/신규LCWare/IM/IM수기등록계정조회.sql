use im80
select U.user_id
		,U.group_id
		,U.name
		,U.code
		,U.login_id
		,U.email
		,G.[ex_dept_name_full]
		,G.[ex_dept_name1]
from [dbo].[org_user] AS U
left join dbo.org_group AS G
on U.group_id = G.group_id
where U.status = '1' 
	AND U.sec_level = '2'
order by code