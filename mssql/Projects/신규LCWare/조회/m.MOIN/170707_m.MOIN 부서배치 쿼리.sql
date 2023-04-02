
/***********************************
*m.MOIN 음료 배치 부서 및 직급
************************************/
SELECT '0000' Code, [description] as Name, '' GroupAbbr, NULL ParentCode, '1' Seq, '01' GroupType, '1' status, '' email FROM org_domain where domain_id = '11'
UNION ALL

SELECT CASE WHEN g.group_type_id <> '2' then g.code else 'WOR_' + dbo.chiper_set(g.ex_sort_key,3,0) end Code,
CASE g.group_type_id WHEN '-1' THEN CASE WHEN p.code IS NULL THEN '' ELSE '' END + g.name ELSE g.name END Name,
'' GroupAbbr, 
case when p.parent_id = '0' and p.group_type_id = '-1' then '0000' else replace(p.code, '[' + d.name + ']', '[' + d.[description] + ']') end ParentCode, 
CASE WHEN g.group_type_id =  '-1' THEN g.ex_sort_key2 ELSE g.ex_sort_key END Seq,
CASE g.group_type_id WHEN '-1' THEN '01' WHEN '11' THEN '02' WHEN '1' THEN '03' WHEN '2' THEN '04' WHEN '41' THEN '07' END GroupType,
g.status Status, '' Email
FROM org_group g, org_group p, org_domain d
WHERE g.parent_id = p.group_id
AND g.domain_id = d.domain_id
AND g.group_type_id in ('1', '2', '11', '41')
AND g.status = '1'
AND g.domain_id = '11'
AND g.code <> 'RETIRED'
OR (g.parent_id = p.group_id AND g.domain_id = d.domain_id AND g.group_type_id in ('-1')
	AND g.status = '1' AND g.domain_id = '11' AND g.code <> 'RETIRED' AND g.ex_sort_key2 is not null )