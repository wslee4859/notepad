

사장,회장,부사장,전무,상무보A,M2(지점장),M2(영업),M1(영업),S2(영업),S1(영업),총괄회장,상무,M2,M1,S2,S1,상무보B,자문,고문,부회장


select * from [IM].[VIEW_USER] 
where (position_name in ( '사장','회장','부사장','전무','상무보A','상무보B','상무','총괄회장','자문','고문','부회장','대표이사')
	OR classpos_name in ('임원','사장','상무','사장','회장','부사장','전무','상무보A','상무보B','상무','총괄회장','자문','고문','부회장','대표이사'))
	AND login_id is not null
	order by domain_code desc , user_name 


	AND position_name is not null

	select * from [IM].[VIEW_USER] 
where user_name  ='윤희종'
