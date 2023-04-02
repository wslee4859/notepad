
USE IM80

-- 지사 업무담당자 그룹
SELECT OU.code, OU.name 
FROM [dbo].[org_user] AS OU
INNER JOIN [dbo].[org_rule_user] AS ORU
ON ORU.user_id = OU.user_id
WHERE ORU.rule_group_id = '2386'

-- 지점 업무담당자 그룹
SELECT OU.code, OU.name 
FROM [dbo].[org_user] AS OU
INNER JOIN [dbo].[org_rule_user] AS ORU
ON ORU.user_id = OU.user_id
--INNER JOIN [dbo].[org_group_user] AS OGU
--ON OGU.user_id = OU.user_id AND OGU.relation_type = '0'
WHERE ORU.rule_group_id = '2387' OR OGU.group_id = '2387'

-- 지사업무과장그룹
SELECT OU.code, OU.name 
FROM [dbo].[org_user] AS OU
INNER JOIN [dbo].[org_rule_user] AS ORU
ON ORU.user_id = OU.user_id
WHERE ORU.rule_group_id = '2408'

--지사 지점 업무그룹
SELECT OU.code, OU.name 
FROM [dbo].[org_user] AS OU
INNER JOIN [dbo].[org_rule_user] AS ORU
ON ORU.user_id = OU.user_id
WHERE ORU.rule_group_id = '12991'




[dbo].[org_group_user] WHERE group_id ='2387'




-- 지점 업무담당자 그룹
SELECT OU.code, OU.name 
FROM [dbo].[org_user] AS OU
--INNER JOIN [dbo].[org_rule_user] AS ORU
--ON ORU.user_id = OU.user_id
INNER JOIN [dbo].[org_group_user] AS OGU
ON OGU.user_id = OU.user_id AND OGU.relation_type = '0'
WHERE OGU.group_id = '2387'


-- 생산 업무담당자 그룹
SELECT OU.code, OU.name, OU.login_id, OG.name, ogu_pos.name, ogu_wor.name
FROM [dbo].[org_user] AS OU
INNER JOIN [dbo].[org_rule_user] AS ORU
ON ORU.user_id = OU.user_id
INNER JOIN [dbo].[org_group] AS OG
ON OU.group_id = OG.group_id
--INNER JOIN [dbo].[org_group_user] AS OGU
--ON OGU.user_id = OU.user_id AND OGU.relation_type = '0'
	left outer join 
		(select a.user_id, b.group_id, b.name, a.org_id, b.ex_sort_key from dbo.org_group_user a inner join dbo.org_group b
		 on a.group_id = b.group_id where b.group_type_id = '1')  as ogu_pos
		on ou.user_id = ogu_pos.user_id and ou.group_id = ogu_pos.org_id
		left outer join 
		(select a.user_id, b.group_id, b.name, a.org_id, b.ex_sort_key from dbo.org_group_user a inner join dbo.org_group b
		 on a.group_id = b.group_id where b.group_type_id = '11')  as ogu_tit 
		on ou.user_id = ogu_tit.user_id and ou.group_id = ogu_tit.org_id
		left outer join 
		(select a.user_id, b.group_id, b.name, a.org_id, b.ex_sort_key from dbo.org_group_user a inner join dbo.org_group b
		 on a.group_id = b.group_id where b.group_type_id = '2')  as ogu_wor
		on ou.user_id = ogu_wor.user_id and ou.group_id = ogu_wor.org_id
WHERE ORU.rule_group_id = '2391'
order by OG.ex_sort_key, ogu_wor.ex_sort_key
