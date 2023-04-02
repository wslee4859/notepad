select * from [IM].[VIEW_USER] where login_id = 'alwayskk' 

begin tran
delete [IM].[VIEW_PLURAL]
where user_name = '±èÅÂ¿ë' 
AND user_code = '23338'

--commit

select * from [IM].[VIEW_PLURAL] where user_name = '±èÅÂ¿ë' AND user_code = '23338'



select * from [IM].[VIEW_USER] where email like 'alwayskk%' 
