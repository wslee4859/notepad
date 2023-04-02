


/******************************************************
*********  하위 부서 조회 쿼리 LCWare (부서명) ****************
*******************************************************/

WITH OU AS
	(
		SELECT 
			A.domain_code,
			A.group_code,	
			A.parent_code,		
			A.name,				
			1 as lvl, 
			A.seq,
			convert(varchar(250),'/' + a.name) AS path 
		FROM COMMON.[IM].[VIEW_ORG] AS A 
		WHERE	1=1
			AND A.domain_code = '1'
			AND A.name like ('%롯데주류%') -- 상위 부서 입력
			AND display_yn ='1'

		UNION ALL
		SELECT 
			A.domain_code,
			A.group_code,
			A.parent_code,				
			A.name,					
			1 as lvl,
			A.seq ,
			convert(varchar(250), path + '/' + a.name) AS path
		FROM COMMON.[IM].[VIEW_ORG] AS A INNER JOIN
			OU B ON A.parent_code = B.group_code
			AND display_yn ='1'
	) 
	-- select * from OU order by seq
	select parent_group_name, group_name, user_name, position_name, classpos_name, ou.path, employee_num, email, login_id, mobile
	from COMMON.[IM].[VIEW_USER] AS U
	right join OU 
	ON U.group_code = OU.group_code
	WHERE U.display_yn != 'N' OR U.display_yn is NULL 
	order by ou.seq, U.responsibility_seq

	COMMON.[IM].[VIEW_ORG] where name = '마케팅3팀'

	COMMON.[IM].[VIEW_USER] where user_name = '엄지영'

COMMON.[IM].[VIEW_ORG]