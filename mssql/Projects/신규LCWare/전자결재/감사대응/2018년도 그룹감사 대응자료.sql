
/*********************************
* 2018�� �׷� ���� ���� �ڷ� 
**********************************/

-- �ַ� ��ȼ� 
select 
  F.DOC_NAME  AS '��ĸ�'
,  PI.NAME
, F.ADD_FST_NUM + ' ��' + F.ADD_SCD_NUM + '-' + F.ADD_TRD_NUM +'ȣ' AS [������ȣ] 
, replace(replace(replace(replace(PI.SUBJECT , char(13),''),char(10),''),'��','"'),'��','"') AS ����
, F.CREATOR AS �����
--, O1.name AS �����μ�
--, F.CREATOR_DEPT AS �μ�
--, CASE PI.STATE WHEN '1' THEN '������' WHEN '7' THEN '�Ϸ�' WHEN '8' THEN '�ݷ�' WHEN '9' THEN 'ȸ��' END AS '�������'
--, PI.CREATE_DATE		AS �����
--, PI.COMPLETED_DATE		AS �Ϸ���
--, F.PROCESS_ID 
FROM [WF].[FORM_Y3BEB1A495B79447BB7631074BC8BB189] AS F
	INNER JOIN [WF].[PROCESS_INSTANCE] AS PI
	ON F.PROCESS_ID = PI.OID 
	LEFT JOIN Common.[IM].[VIEW_ORG] AS O
	ON F.CREATOR_DEPT_CODE = O.group_code
	LEFT JOIN Common.[IM].[VIEW_ORG] AS O1
	ON O.parent_code = O1.group_code	
	--WHERE PI.CREATE_DATE > '2015-11-15' AND PI.CREATE_DATE < '2015-11-30'     -- 10������ 
ORDER BY PI.CREATE_DATE 

rollback

begin tran
update [WF].[PROCESS_INSTANCE] 
set SUBJECT = replace(subject,'��','"')
where subject like '%��%'

--commit

select * from [WF].[PROCESS_INSTANCE]  where subject like '%��%'
