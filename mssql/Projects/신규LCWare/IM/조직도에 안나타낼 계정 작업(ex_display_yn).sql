

select * from [dbo].[org_user] where name like '%ewf%'

begin tran
update dbo.org_user
set ex_display_yn = 'N'
where name like '%ewf%'

select @@TRANCOUNT


select * from [dbo].[org_user] where name like '%실%'

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


select * from [dbo].[org_user] where name like '%테스트%'

begin tran
update [dbo].[org_user]
set ex_display_yn = 'N'
where name like '%테스트%'

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

select * from [dbo].[org_user] where name like '%당직자%'
begin tran
update [dbo].[org_user]
set ex_display_yn = 'N'
where name like '%당직자%'
--commit


select * from [dbo].[org_user] where name like '%관리자%'
begin tran
update [dbo].[org_user]
set ex_display_yn = 'N'
where name like '%관리자%'

select * from [dbo].[org_user] where name like '%인사%'
begin tran
update [dbo].[org_user]
set ex_display_yn = 'N'
where name in ('인사')


select * from [dbo].[org_user] where name like '%서울%'
begin tran
update [dbo].[org_user]
set ex_display_yn = 'N'
 where name like '%서울%'
 
 select * from [dbo].[org_user] where name like '%구매%'
begin tran
update [dbo].[org_user]
set ex_display_yn = 'N'
 where name like '%구매%'



select * from [dbo].[org_user] where name like '%경리부%'
begin tran
update [dbo].[org_user]
set ex_display_yn = 'N'
 where name like '%경리부%'
 
 select * from [dbo].[org_user] where name like '%가상%'
begin tran
update [dbo].[org_user]
set ex_display_yn = 'N'
 where name like '%가상%'

 select * from [dbo].[org_user] where name like '%북경%'
begin tran
update [dbo].[org_user]
set ex_display_yn = 'N'
 where name like '%북경%'


select * from [dbo].[org_user] where name like '%지사%'
begin tran
update [dbo].[org_user]
set ex_display_yn = 'N'
where name like '%지사%'

select * from [dbo].[org_user] where name like '%지점%'
begin tran
update [dbo].[org_user]
set ex_display_yn = 'N'
where name like '%지점%'

select * from [dbo].[org_user] where name like '%kateam%'
begin tran
update [dbo].[org_user]
set ex_display_yn = 'N'
where name like '%kateam%'

select * from [dbo].[org_user] where name like '%벤딩%'
begin tran
update [dbo].[org_user]
set ex_display_yn = 'N'
where name like '%벤딩%'


select * from [dbo].[org_user] where name like '%밴딩%'
begin tran
update [dbo].[org_user]
set ex_display_yn = 'N'
where name like '%밴딩%'
--commit


select * from [dbo].[org_user] where name like '%한동%'
begin tran
update [dbo].[org_user]
set ex_display_yn = 'N'
where name like '%한동%'


select * from [dbo].[org_user] where name like '%판매%'
begin tran
update [dbo].[org_user]
set ex_display_yn = 'N'
where name like '%판매%'

select * from [dbo].[org_user] where name like '%오츠%'
begin tran
update [dbo].[org_user]
set ex_display_yn = 'N'
where name like '%오츠%'


select * from [dbo].[org_user] where name like '%물류%'
begin tran
update [dbo].[org_user]
set ex_display_yn = 'N'
where name like '%물류%'
commit


select * from [dbo].[org_user] where name like '%해외영업부%'
begin tran
update [dbo].[org_user]
set ex_display_yn = 'N'
where name like '%해외영업부%'
--commit

select * from [dbo].[org_user] where name like '%제품%'
begin tran
update [dbo].[org_user]
set ex_display_yn = 'N'
where name like '%제품%'
--commit

select * from [dbo].[org_user] where name like '%공장%'
begin tran
update [dbo].[org_user]
set ex_display_yn = 'N'
where name like '%공장%'

select * from [dbo].[org_user] where name like '%연구소%'
begin tran
update [dbo].[org_user]
set ex_display_yn = 'N'
where name like '%연구소%'


select * from [dbo].[org_user] where name like '%조합%'
begin tran
update [dbo].[org_user]
set ex_display_yn = 'N'
where name like '%조합%'
commit

rollback
select @@TRANCOUNT

