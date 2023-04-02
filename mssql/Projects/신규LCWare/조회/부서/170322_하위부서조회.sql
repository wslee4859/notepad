/****************************************
*********  ���� �μ� ��ȸ ���� **************
*****************************************/
	use im80


	WITH T_OU AS
	(
		SELECT 
			a.group_id,
			a.parent_id,
			a.name,
			a.status,
			a.ex_sort_key,
			1 as lvl, 
			convert(varchar(250),'/' + a.name) AS path
		FROM org_group AS A 
		WHERE A.group_id in ('5382') -- ���� �μ� �Է�

		UNION ALL
		SELECT 
			a.group_id,
			a.parent_id,
			a.name,
			a.status,
			a.ex_sort_key,
			lvl + 1 as lvl ,
			convert(varchar(250), path + '/' + a.name) AS path
		FROM org_group AS A INNER JOIN
			T_OU B ON A.parent_id = B.group_id		       
	)
	-- �Ʒ� order by ���� �ٲٸ� ������ ��ũ ������ �ٲ�
	select * from T_OU where status = '1' order by  ex_sort_key , lvl


	where parent_id <> '130' AND parent_id <> '131' AND group_id <> '130' AND group_id <> '131' 



/******************************************************
*********  ���� �μ� ��ȸ ����(�μ���) ****************
*******************************************************/
	use im80


	WITH T_OU AS
	(
		SELECT 
			a.group_id,
			a.parent_id,
			a.name,
			a.status,
			a.ex_sort_key,
			1 as lvl, 
			convert(varchar(250),'/' + a.name) AS path
		FROM org_group AS A 
		WHERE	group_type_id = '-1'
				AND A.domain_id = '1'
				AND A.name like ('%���ְ���%') -- ���� �μ� �Է�


		UNION ALL
		SELECT 
			a.group_id,
			a.parent_id,
			a.name,
			a.status,
			a.ex_sort_key,
			lvl + 1 as lvl ,
			convert(varchar(250), path + '/' + a.name) AS path
		FROM org_group AS A INNER JOIN
			T_OU B ON A.parent_id = B.group_id		       
	)
	select * from T_OU where status = '1' order by ex_sort_key  