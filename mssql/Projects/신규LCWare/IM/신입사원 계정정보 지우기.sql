use im80
select * from [dbo].[org_user] where name = '��â��' AND code = '20147169'

begin tran 
update dbo.org_user
set login_id = NULL
where name = '��â��' AND code = '20147169'




-- commit

select @@TRANCOUNT

