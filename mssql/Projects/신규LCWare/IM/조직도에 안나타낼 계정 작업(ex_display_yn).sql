

select * from [dbo].[org_user] where name like '%ewf%'

begin tran
update dbo.org_user
set ex_display_yn = 'N'
where name like '%ewf%'

select @@TRANCOUNT


select * from [dbo].[org_user] where name like '%��%'

select * from [dbo].[org_user] 
where user_id in (
'26093',
'26187',
'26092',
'26076',
'26078',
'26139',
'26123',
'26073',
'26188',
'21514',
'26089',
'26133')

begin tran
update [dbo].[org_user]
set ex_display_yn = 'N'
where user_id in (
'26093',
'26187',
'26092',
'26076',
'26078',
'26139',
'26123',
'26073',
'26188',
'21514',
'26089',
'26133')


select * from [dbo].[org_user] where name like '%�׽�Ʈ%'

begin tran
update [dbo].[org_user]
set ex_display_yn = 'N'
where name like '%�׽�Ʈ%'

select * from [dbo].[org_user] where name like '%CP%'

begin tran
update [dbo].[org_user]
set ex_display_yn = 'N'
where name like '%CP%'

select * from [dbo].[org_user] where name like '%main%'

begin tran
update [dbo].[org_user]
set ex_display_yn = 'N'
where name like '%main%'

select * from [dbo].[org_user] where name like '%mail%'
begin tran
update [dbo].[org_user]
set ex_display_yn = 'N'
where name like '%mail%'

select * from [dbo].[org_user] where name like '%������%'
begin tran
update [dbo].[org_user]
set ex_display_yn = 'N'
where name like '%������%'
--commit


select * from [dbo].[org_user] where name like '%������%'
begin tran
update [dbo].[org_user]
set ex_display_yn = 'N'
where name like '%������%'

select * from [dbo].[org_user] where name like '%�λ�%'
begin tran
update [dbo].[org_user]
set ex_display_yn = 'N'
where name in ('�λ�')


select * from [dbo].[org_user] where name like '%����%'
begin tran
update [dbo].[org_user]
set ex_display_yn = 'N'
 where name like '%����%'
 
 select * from [dbo].[org_user] where name like '%����%'
begin tran
update [dbo].[org_user]
set ex_display_yn = 'N'
 where name like '%����%'



select * from [dbo].[org_user] where name like '%�渮��%'
begin tran
update [dbo].[org_user]
set ex_display_yn = 'N'
 where name like '%�渮��%'
 
 select * from [dbo].[org_user] where name like '%����%'
begin tran
update [dbo].[org_user]
set ex_display_yn = 'N'
 where name like '%����%'

 select * from [dbo].[org_user] where name like '%�ϰ�%'
begin tran
update [dbo].[org_user]
set ex_display_yn = 'N'
 where name like '%�ϰ�%'


select * from [dbo].[org_user] where name like '%����%'
begin tran
update [dbo].[org_user]
set ex_display_yn = 'N'
where name like '%����%'

select * from [dbo].[org_user] where name like '%����%'
begin tran
update [dbo].[org_user]
set ex_display_yn = 'N'
where name like '%����%'

select * from [dbo].[org_user] where name like '%kateam%'
begin tran
update [dbo].[org_user]
set ex_display_yn = 'N'
where name like '%kateam%'

select * from [dbo].[org_user] where name like '%����%'
begin tran
update [dbo].[org_user]
set ex_display_yn = 'N'
where name like '%����%'


select * from [dbo].[org_user] where name like '%���%'
begin tran
update [dbo].[org_user]
set ex_display_yn = 'N'
where name like '%���%'
--commit


select * from [dbo].[org_user] where name like '%�ѵ�%'
begin tran
update [dbo].[org_user]
set ex_display_yn = 'N'
where name like '%�ѵ�%'


select * from [dbo].[org_user] where name like '%�Ǹ�%'
begin tran
update [dbo].[org_user]
set ex_display_yn = 'N'
where name like '%�Ǹ�%'

select * from [dbo].[org_user] where name like '%����%'
begin tran
update [dbo].[org_user]
set ex_display_yn = 'N'
where name like '%����%'


select * from [dbo].[org_user] where name like '%����%'
begin tran
update [dbo].[org_user]
set ex_display_yn = 'N'
where name like '%����%'
commit


select * from [dbo].[org_user] where name like '%�ؿܿ�����%'
begin tran
update [dbo].[org_user]
set ex_display_yn = 'N'
where name like '%�ؿܿ�����%'
--commit

select * from [dbo].[org_user] where name like '%��ǰ%'
begin tran
update [dbo].[org_user]
set ex_display_yn = 'N'
where name like '%��ǰ%'
--commit

select * from [dbo].[org_user] where name like '%����%'
begin tran
update [dbo].[org_user]
set ex_display_yn = 'N'
where name like '%����%'

select * from [dbo].[org_user] where name like '%������%'
begin tran
update [dbo].[org_user]
set ex_display_yn = 'N'
where name like '%������%'


select * from [dbo].[org_user] where name like '%����%'
begin tran
update [dbo].[org_user]
set ex_display_yn = 'N'
where name like '%����%'
commit

rollback
select @@TRANCOUNT

