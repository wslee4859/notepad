use mrbook
select * from [dbo].[roominfo] where roomNo = 8

begin tran 
update [dbo].[roominfo]
set floor = '4'
where roomNo = 8

commit

select @@TRANCOUNT