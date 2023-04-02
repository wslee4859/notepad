-- IM 메일그룹 소속자 select 
select * from [dbo].[org_group] where name like '%클레임%'

select * from [dbo].[org_group] where group_id  like '%223%'
select 
GU.group_id,
U.user_id,
GU.sec_level, 
U.domain_id,
G.name AS 메일그룹,
G_USER.name AS 부서,
U.name,
U.code,
U.login_id,
U.email
 from [dbo].[org_group_user] AS GU
left  join [dbo].[org_user] AS U
ON GU.user_id = U.User_id
left join [dbo].[org_group] AS G
ON G.group_id = GU.group_id
left join [dbo].[org_group] AS G_USER
ON U.group_id = G_USER.group_id
 where G.group_id = '8233'
 order by 부서