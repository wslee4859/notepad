


-- 주류 근태담당자 리스트
select OU.group_id, OGU.group_id, OU.code, OU.name, OG1.name, OG2.name 
from [dbo].[org_group_user] AS OGU
left join [dbo].[org_user] AS OU
ON OU.user_id = OGU.user_id
left join [dbo].[org_group] AS OG1
ON OGU.group_id = OG1.group_id
left join [dbo].[org_group] AS OG2
ON OU.group_id = OG2.group_id
where OGU.group_id = '8994'
order by OU.name


