


select domain_id, login_id, email  from dbo.org_user
where login_id != substring(email,0,charindex('@',email,0)) 
and status = 1