


select * from [dbo].[lotte_sync_bulk_user] where name = '박상아'



USE im80
select name,code,user_id, login_id, domain_id 
from [dbo].[org_user] where name = '이성훈'

select * from [dbo].[org_user] where code = '00215CB'
select * from [dbo].[org_group_user] where user_id = '1557'
select * from [dbo].[org_group] where group_id = '10631'

-- code, user_id 를 붙여넣는다. 

-- 음료, 주류 용
begin tran
update [dbo].[org_user] 
set sec_level = '9',
	domain_id = '1'
where code = '91012' AND domain_id = '11'

update [dbo].[org_group_user]
set sec_level = '2'
where user_id = '21812'

rollback
-- commit



-- CH 전용
begin tran
update [dbo].[org_user] 
set sec_level = '2'
where code = '00215CB'

update [dbo].[org_group_user]
set sec_level = '2'
where user_id = '23521'


delete [dbo].[lotte_sync_bulk_user]
where code = '19950190'
rollback

-- commit



