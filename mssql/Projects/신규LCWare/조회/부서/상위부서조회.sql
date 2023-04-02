select * from [dbo].[org_user] where group

use im80
select * from [dbo].[org_group] where name like '%호남%'
select * from [dbo].[org_group] where code like '%00301%'
select name, parent_id, group_id, domain_id from im80.[dbo].[org_group] where parent_id = (select parent_id from [dbo].[org_group] where name = '호남' AND group_type_id = '-1')


select * from [dbo].[org_group] where group_id = '00193'
select * from [dbo].[org_group] where group_id = '160'
select * from [dbo].[org_group] where group_id = '111'




select g1.name
, G2.name
, G3.name
, G4.name
from im80.[dbo].[org_group] AS G1
left join im80.[dbo].[org_group] AS G2
ON G1.parent_id = G2.group_id
left join im80.[dbo].[org_group] AS G3
ON G2.parent_id = G3.group_id
left join im80.[dbo].[org_group] AS G4
ON G3.parent_id = G4.group_id
left join im80.[dbo].[org_group] AS G5
ON G4.parent_id = G5.group_id
where G1.parent_id in (select parent_id from [dbo].[org_group] where name = '안산지점' AND group_type_id = '-1')


-- 하위부서 검색 
select * from [dbo].[org_group] where parent_id = '5426'
select * from [dbo].[org_group] where parent_id = '5443'



select g1.name
, G2.name
, G3.name
, G4.name
from im80.[dbo].[org_group] AS G1
left join im80.[dbo].[org_group] AS G2
ON G1.parent_id = G2.group_id
left join im80.[dbo].[org_group] AS G3
ON G2.parent_id = G3.group_id
left join im80.[dbo].[org_group] AS G4
ON G3.parent_id = G4.group_id
left join im80.[dbo].[org_group] AS G5
ON G4.parent_id = G5.group_id
where G1.parent_id = (select parent_id from [dbo].[org_group] where code = 'JJ_01223' AND group_type_id = '-1')




-- 상세부서 조회 쿼리 
WITH recursive_query(DeptCD,ParentCD,Name,FullName) AS (
  SELECT 
         deptcd
       , parentdeptcd
       , deptname
       , convert(varchar(255), deptname) fullname
    FROM [HRSQLSERVER].[HRDB].[dbo].[vwEKWDept]
    WHERE parentdeptcd is  null
    UNION ALL
    SELECT
         b.deptcd
       , b.parentdeptcd
       , b.deptname
        , convert(varchar(255), convert(nvarchar,c.fullname) + ' > ' +  convert(varchar(255), b.deptname)) fullname
    FROM  [HRSQLSERVER].[HRDB].[dbo].[vwEKWDept]  b,  recursive_query c
    WHERE b.parentdeptcd = c.deptcd
) 
select * from recursive_query

