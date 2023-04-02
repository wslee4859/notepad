select 
	domain_id,
	code, 
	name,
	status,
	sec_level,
	login_id,
	start_date,
	end_date,
	ex_dept_name
from [dbo].[org_user] 
where 1=1 
	--AND sec_level = '2' 
	--AND 
order by code 

--select * from [dbo].[org_user] where name = 'ÀÌ½ÂÃ¶'