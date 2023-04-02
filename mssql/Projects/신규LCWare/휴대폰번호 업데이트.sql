-- 개인 SMS 등록
use common
declare @UserName nvarchar(100)
			,@Employee_num nvarchar(20)
			,@Mobile varchar(20)

set @UserName = '한상준'
set @Employee_num = '20112376'
set @Mobile = '010-9347-8251'

select domain_name, User_name, mobile, group_name  from [IM].[VIEW_USER] where user_name = @UserName AND employee_num = @Employee_num
select domain_name, User_name, mobile, group_name  from [IM].[VIEW_PLURAL] where user_name = @UserName AND employee_num = @Employee_num

begin tran 
update IM.ViEW_USER
set mobile = @Mobile
--,office_phone = null
where user_name = @UserName AND employee_num = @Employee_num

update [IM].[VIEW_PLURAL]
set mobile = @Mobile
--, office_phone = null
where user_name = @UserName AND employee_num = @Employee_num

select domain_name, User_name, mobile, group_name  from [IM].[VIEW_USER] where user_name = @UserName AND employee_num = @Employee_num
select domain_name, User_name, mobile, group_name  from [IM].[VIEW_PLURAL] where user_name = @UserName AND employee_num = @Employee_num


select @@trancount
--commit


