[CM].[MenuAuthority] where menuID = '10017' 

begin tran
delete [CM].[MenuAuthority] 
where menuID = '10017'

commit