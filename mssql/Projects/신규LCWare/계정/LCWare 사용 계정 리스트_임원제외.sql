
-- LCWare ���� ���� (�ӿ� ������ ����Ʈ) 
select * from [IM].[VIEW_USER] AS U
left join [IM].[VIEW_ORG] AS G
ON U.group_code = G.group_code
where U.domain_code = '11'
	AND U.display_yn is null
	AND U.email like '%@lottechilsung.co.kr'
	--AND user_name = '������'
	AND U.classpos_name not like '%��%'
	AND U.classpos_name not like '%����%'
	AND U.classpos_name not like '%�ڹ�%'
	AND responsibility_name not like '%�ӿ�%'
order by G.seq
	



select * from [IM].[VIEW_ORG]
where domain_code = '11'
order by seq

select * from [IM].[VIEW_USER_GROUP]

[IM].[VIEW_ORG]