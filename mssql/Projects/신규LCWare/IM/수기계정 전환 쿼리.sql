select * from [dbo].[org_user] where name = '김혜진' AND code = '20170412'

update [dbo].[org_user] where name =

21977

[dbo].[org_group_user] where user_id = '90441'

[dbo].[org_group] where group_id in ( '3994' , '4876', '5176', '5389')
[dbo].[org_group_user] where sec_level = '2'




begin tran
update  [dbo].[org_user] 
set sec_level = '9'
where user_id = '90441'

update  [dbo].[org_group_user]
set sec_level = '2'
where user_id = '21977'

commit


select * from [dbo].[org_group_user] where user_id = '21977'

/*******************************
* 수기계정 -> 동기화 계정 전환
********************************/

begin tran
update  [dbo].[org_user] 
set sec_level = '9'
where user_id = '90441'


select * from [dbo].[org_group_user] where user_id = '90441'
begin tran
update  [dbo].[org_group_user]
set sec_level = '9'
where user_id = '90441'
-- commit

select @@trancount

