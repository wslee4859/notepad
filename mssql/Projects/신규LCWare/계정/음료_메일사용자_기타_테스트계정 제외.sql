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
	AND parent_group_name not in ( '��������', '��Ÿ')
	AND group_name not like '%CH%'
	AND group_name not like '%��Ÿ%'
	AND login_id not like '%mail%'
	AND login_id not like '%ewf%'
	AND login_id not like '%test%'
	AND User_name not like '%����%'
	AND User_name not like '%����%'
	AND User_name not like '%�Ե�%'
	AND User_name not like '%���%'
	AND User_name not like '%�ƻ���%'
	AND User_name not like '%������%'
	AND User_name not like '%���%'
	AND User_name not like '%�ƽ�%'
	AND User_name not like '%�׽�Ʈ%'
	AND User_name not like '%����%'
	AND (display_yn != 'N' OR display_yn is null OR display_yn = NULL )	
order by User_name 


select * from [IM].[VIEW_USER] where domain_code = '11'  	AND email is not null AND parent_group_name like '%CH%'

select * from [IM].[VIEW_USER] where  User_name = '����ö'
select * from [IM].[VIEW_ORG] order by seq desc


	[IM].[VIEW_PLURAL]