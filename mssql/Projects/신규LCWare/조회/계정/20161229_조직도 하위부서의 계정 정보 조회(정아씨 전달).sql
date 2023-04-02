/*****************************************
* 조직도 하위부서에 포함된 계정 조회 
* 
******************************************/

3818
select * from [IM].[VIEW_USER] AS U
where domain_code = '11'
AND (U.display_yn != 'N' OR U.display_yn is null)
AND user_name = '조은애'


AND U.email like '%@lottechilsung.co.kr'

select * from [IM].[VIEW_USER] AS U
where domain_code = '11'
AND (U.display_yn != 'N' OR U.display_yn is null)
AND U.user_name is null

select  * from [IM].[VIEW_ORG] where domain_code = '11'
-- 

--5382	지원	509
--5379	영업	2128
--5381	생산	875
--5378	파견	77
--5380	기타	229
-- 지원에 포함된 인원수 

	WITH T_OU AS
	(
		SELECT 
			a.group_code,
			a.parent_code,
			a.name,
			a.status,
			a.seq,
			a.depth
		FROM [IM].[VIEW_ORG] AS A 
		WHERE A.group_code in ('88','142','96','97','100','104','108','8255','14561') AND A.status = '1'


		UNION ALL
		SELECT 
			a.group_code,
			a.parent_code,
			a.name,
			a.status,
			a.seq,
			a.depth
		FROM [IM].[VIEW_ORG] AS A 
			INNER JOIN T_OU AS B 
			ON A.parent_code = B.group_code
		    WHERE A.status = '1'       
	)
	select * from T_OU AS T
	LEFT join [IM].[VIEW_USER] AS U
	ON T.group_code = U.group_code
	WHERE 1=1
	AND U.user_name is not null
	AND (U.display_yn != 'N' OR U.display_yn is null)
	--AND U.user_name = '김태현' 
	order by T.seq 



	