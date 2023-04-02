
-- LCWare 메일 계정 (임원 제외한 리스트) 
select * from [IM].[VIEW_USER] AS U
left join [IM].[VIEW_ORG] AS G
ON U.group_code = G.group_code
where U.domain_code = '11'
	AND U.display_yn is null
	AND U.email like '%@lottechilsung.co.kr'
	--AND user_name = '이재혁'
	AND U.classpos_name not like '%상무%'
	AND U.classpos_name not like '%사장%'
	AND U.classpos_name not like '%자문%'
	AND responsibility_name not like '%임원%'
order by G.seq
	



select * from [IM].[VIEW_ORG]
where domain_code = '11'
order by seq

select * from [IM].[VIEW_USER_GROUP]

[IM].[VIEW_ORG]