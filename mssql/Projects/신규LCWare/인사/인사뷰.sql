select * from [dbo].[org_rule_group] where rule_group_id = '1792'

select * from [dbo].[org_rule_user] where rule_group_id = '1792'


select * from [dbo].[org_user] where user_id in (select user_id from [dbo].[org_rule_user] where rule_group_id = '8215')


[dbo].[org_group]



[dbo].[org_group] where domain_id = '11' AND group_type_id = '1'





[HRSQLSERVER].[HRDB].[dbo].[vwIMCode] where classcode = '10JW' AND gubun  ='L'

[HRSQLSERVER].[HRDB].[dbo].[vwIMUSer] where UserName = '노승현'

[HRSQLSERVER].[HRDB].[dbo].[vwIMUserDept] where empid = '1101001'

[HRSQLSERVER].[HRDB].[dbo].[vwEKWDept] where deptcd = '00434'

sp_help [HRSQLSERVER].[HRDB].[dbo].[vwIMUSer]


[HRSQLSERVER].[HRDB].[dbo].[vwIMUSer] where UserName = '이길수'
[HRSQLSERVER].[HRDB].[dbo].[vwIMUserDept] where empid = '1101001'
[HRSQLSERVER].[HRDB].[dbo].[vwEKWDept]

HR050010	HR060010

SELECT
	DeptCd,
	DeptName,
	ParentDeptCd,
	Level,
	HasSubDept,
	SortKey,
	SEQ
	FROM 
[HRSQLSERVER].[HRDB].[dbo].[vwEKWDept]
