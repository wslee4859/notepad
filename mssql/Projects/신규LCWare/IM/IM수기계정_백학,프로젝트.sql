-- ����/������Ʈ IM������� 

select * from [dbo].[org_user] where status = '1' AND sec_level = '2'  AND group_id in ('5389','9051','9052','9053','9054')
select U.name,U.login_id, U.code, G.name from [dbo].[org_user]  AS U
left join [dbo].[org_group] AS G
ON U.group_id = G.group_id
where U.status = '1' 
--AND U.group_id in ('9041','9042','9043','9044','9045') -- ������Ʈ 
AND U.group_id in ('5389','9051','9052','9053','9054') -- ����
order by g.name, u.name


select * from [dbo].[org_user] 
WHERE status = '1'
AND sec_level = '2'
AND group_id in ('5389','9051','9052','9053','9054')