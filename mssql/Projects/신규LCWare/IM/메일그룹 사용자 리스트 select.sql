-- IM ���ϱ׷� �Ҽ��� select 
select * from [dbo].[org_group] where name like '%Ŭ����%'

select * from [dbo].[org_group] where group_id  like '%223%'
select 
GU.group_id,
U.user_id,
GU.sec_level, 
U.domain_id,
G.name AS ���ϱ׷�,
G_USER.name AS �μ�,
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
 order by �μ�