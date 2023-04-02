-- IM
select U.name,U.code,U.login_id, U.email, G.name  from org_user AS U
	inner join [dbo].[org_group] AS G
	ON U.group_id = G.group_id AND G.name like '%직매장'

select * from [dbo].[org_group] where name like '%직매장'