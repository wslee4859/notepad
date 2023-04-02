select * from [dbo].[lotte_sync_bulk_user] where name = '±è¾ç±â'




select * from [dbo].[org_user] where name = '±è¾ç±â'
select * from [dbo].[org_user] where code = '20132010C'


begin tran
update [dbo].[org_user] 
set sec_level = '2'
where code = '20132010C'
commit


select * from [dbo].[org_group_user] where user_id = '52431'
begin tran 
update [dbo].[org_group_user]
set sec_level = '2'
where user_id = '52431'
-- commit


begin tran
delete [dbo].[lotte_sync_bulk_user]
where code = '20132010C'
commit



