/*****************************************
* ������ �����μ��� ���Ե� ���� ��ȸ 
* 
******************************************/

3818
select * from [IM].[VIEW_USER] AS U
where domain_code = '11'
AND (U.display_yn != 'N' OR U.display_yn is null)
AND user_name = '������'


AND U.email like '%@lottechilsung.co.kr'

select * from [IM].[VIEW_USER] AS U
where domain_code = '11'
AND (U.display_yn != 'N' OR U.display_yn is null)
AND U.user_name is null

select  * from [IM].[VIEW_ORG] where domain_code = '11'
-- 

--5382	����	509
--5379	����	2128
--5381	����	875
--5378	�İ�	77
--5380	��Ÿ	229
-- ������ ���Ե� �ο��� 

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
	--AND U.user_name = '������' 
	order by T.seq 



	