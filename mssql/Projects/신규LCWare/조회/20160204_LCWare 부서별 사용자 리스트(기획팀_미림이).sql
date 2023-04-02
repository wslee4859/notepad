-- LCWare 메일 계정 (임원 제외한 리스트) 
select user_name, group_name, parent_group_name, responsibility_name, U.email, G.name, G1.name, G2.name, G3.name, G4.name, G5.name, G6.name, G7.name
 from [IM].[VIEW_USER_201512] AS U
left join [IM].[VIEW_ORG_201512] AS G
ON U.group_code = G.group_code
left join [IM].[VIEW_ORG_201512] AS G1
ON G.parent_code = G1.group_code
left join [IM].[VIEW_ORG_201512] AS G2
ON G1.parent_code = G2.group_code
left join [IM].[VIEW_ORG_201512] AS G3
ON G2.parent_code = G3.group_code
left join [IM].[VIEW_ORG_201512] AS G4
ON G3.parent_code = G4.group_code
left join [IM].[VIEW_ORG_201512] AS G5
ON G4.parent_code = G5.group_code
left join [IM].[VIEW_ORG_201512] AS G6
ON G5.parent_code = G6.group_code
left join [IM].[VIEW_ORG_201512] AS G7
ON G6.parent_code = G7.group_code
where U.domain_code = '11'
	AND (U.display_yn != 'N' OR U.display_yn is null)
	AND U.email like '%@lottechilsung.co.kr'
	--AND user_name = '이재혁'
	--AND U.classpos_name not like '%상무%'
	--AND U.classpos_name not like '%사장%'
	--AND U.classpos_name not like '%자문%'
	--AND responsibility_name not like '%임원%'
order by G.seq

