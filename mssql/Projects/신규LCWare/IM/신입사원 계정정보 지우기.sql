use im80
select * from [dbo].[org_user] where name = '양창근' AND code = '20147169'

begin tran 
update dbo.org_user
set login_id = NULL
where name = '양창근' AND code = '20147169'




-- commit

select @@TRANCOUNT

