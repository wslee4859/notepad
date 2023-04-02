


select * from [dbo].[org_user] 
where domain_id = '11' 
	AND email is null
	AND status = '1'
	AND login_id = code
	AND (ex_display_yn <> 'N' OR ex_display_yn is null)
	--AND ex_enable_yn = 'N'
	AND ex_lcware_yn = 'L'



select * from [dbo].[org_user] 
where domain_id = '11' 
	AND email is null
	AND status = '1'
	AND login_id is null
	AND (ex_display_yn <> 'N' OR ex_display_yn is null)
	--AND ex_enable_yn = 'N'
	AND ex_lcware_yn = 'L'