select M.UserAccount, U.user_name, U.group_name, position_name from [dbo].[SMS_UserList] AS M
inner join COMMON.[IM].[VIEW_USER] AS U
on M.UserAccount = U.login_id

