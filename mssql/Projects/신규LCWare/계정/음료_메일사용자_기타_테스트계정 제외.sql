select 
	employee_num,
	User_name,
	group_name,
	responsibility_name,
	position_name,
	classpos_name,
	login_id,
	email,
	display_yn
from [IM].[VIEW_USER]
where domain_code = '11' 
	AND email is not null
	AND parent_group_name not in ( '백학음료', '기타')
	AND group_name not like '%CH%'
	AND group_name not like '%기타%'
	AND login_id not like '%mail%'
	AND login_id not like '%ewf%'
	AND login_id not like '%test%'
	AND User_name not like '%지점%'
	AND User_name not like '%지사%'
	AND User_name not like '%롯데%'
	AND User_name not like '%상사%'
	AND User_name not like '%아사히%'
	AND User_name not like '%관리자%'
	AND User_name not like '%밴딩%'
	AND User_name not like '%탬스%'
	AND User_name not like '%테스트%'
	AND User_name not like '%오츠%'
	AND (display_yn != 'N' OR display_yn is null OR display_yn = NULL )	
order by User_name 


select * from [IM].[VIEW_USER] where domain_code = '11'  	AND email is not null AND parent_group_name like '%CH%'

select * from [IM].[VIEW_USER] where  User_name = '최중철'
select * from [IM].[VIEW_ORG] order by seq desc


	[IM].[VIEW_PLURAL]