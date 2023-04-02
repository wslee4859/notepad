/*메일 규칙 관리*/
 -- 1. 해당 직무가 포함된 규칙 찾기
select * from [dbo].[org_group] where group_id in ('2386')




-- 그룹 룰 역할 확인 표시 (seq nir2_4 : 부서, nir2_7 : 직무)
-- ex_type 0 : 하위 미포함, 1 : 하위 포함
select og1.name, orgx.*, og.name from [dbo].[org_rule_group_ex] AS orgx
INNER JOIN [dbo].[org_group] AS og
ON orgx.group_id = og.group_id
INNER JOIN [dbo].[org_group] AS og1  -- 메일그룹 이름.
ON orgx.rule_group_id = og1.group_id
where rule_group_id = '2405'
order by seq desc