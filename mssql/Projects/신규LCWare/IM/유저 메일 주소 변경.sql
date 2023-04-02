-- IM DB

select user_id
	,group_id
	,name
	,code
	,login_id
	,email
	 from im80.dbo.org_user where name = 'È²Ä¡¿õ'

begin tran
update im80.dbo.org_user 
set email = 'photosg@lotteliquor.com' 
where login_id = 'photosg' AND user_id = '2091'

--commit
--rollback


