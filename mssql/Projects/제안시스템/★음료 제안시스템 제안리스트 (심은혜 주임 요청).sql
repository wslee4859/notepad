select
  DM.document_key AS ���ȹ�ȣ
, DM.document_writerno AS �����ڻ��
, document_deptnm AS �����ںμ�
, U.user_nm AS �����ڸ�
, U.user_workerlevelnm AS "������ ��å"
, DM.document_subject AS ���ȸ�
, DM.document_gradenm  AS �ɻ���
, DM.document_evaluatedate AS �����ɻ���
, DM.document_writedate AS ���ȵ����
, C.categorynm_step1 AS "1���з�"
, C.categorynm_step2 AS "2���з�"
, C.categorynm_step3 AS "3���з�"
, CASE DM.document_sync WHEN '1' THEN '�ǽ���' WHEN '2' THEN '�ǽ���' END AS �ǽñ���
, DM.document_proctype AS ��������
, CASE DM.document_evaluatestep WHEN 'E' THEN '�Ϸ�'  WHEN 'P' THEN '����' WHEN 'R' THEN '���' END AS "�������"
, DM.document_point AS  ���� 
,CASE DE.document_effecttype  WHEN 'M' THEN '����' WHEN 'U' THEN '����'  END AS 'ȿ�����'
, replace(DE.document_effect,char(13)+char(10),'') AS  ���ȿ��
, DE.document_effectamt AS ����ȿ���ݾ�
, E.evaluate_userno AS ����
from [dbo].[INOC_DOCUMENT_MASTER_TBL] AS DM
left join [dbo].[INOC_DOCUMENT_EFFECT_TBL] AS DE
ON DM.document_key = DE.document_key
left join [dbo].[INOC_USER_TBL] AS U
ON DM.document_writerno = U.user_no
left join [dbo].[INOC_CATEGORYSTEP_TBL]  AS C
ON DM.document_categorycd = C.category_code
left join [dbo].[INOC_EVALUATE_JUDGE_TBL] AS E
ON DM.document_key = E.document_key AND evaluate_done = 'N'

where document_writedate > '2017-01-01' AND document_writedate < '2017-03-31'
AND DM.document_subject like'%�۾���%'
order by document_writedate


--[dbo].[INOC_DOCUMENT_EFFECT_TBL]


--[dbo].[INOC_DOCUMENT_DETAIL_TBL]

--
--[dbo].[INOC_DOCUMENT_MASTER_TBL]  where document_key = 'I20140800001'
 
--[dbo].[INOC_DOCUMENT_CATEGORY_TBL]
--[dbo].[INOC_CATEGORYSTEP_TBL]  
--[dbo].[INOC_USER_TBL]



--left join [dbo].[INOC_DOCUMENT_CATEGORY_TBL] AS DC_1
--ON DM.document_key = DC_1.document_key AND DC_1.document_sort = '1'
--left join [dbo].[INOC_DOCUMENT_CATEGORY_TBL] AS DC_2
--ON DM.document_key = DC_2.document_key AND DC_2.document_sort = '2'
--left join [dbo].[INOC_CATEGORYSTEP_TBL]   AS C1
--ON DC_1.document_categorycd = C1.category_code
--left join [dbo].[INOC_CATEGORYSTEP_TBL]   AS C2
--ON DC_2.document_categorycd = C2.category_code


-- ������ ����
select
  DM.document_key AS ���ȹ�ȣ
, DM.document_writerno AS �����ڻ��
, document_deptnm AS �����ںμ�
, U.user_nm AS �����ڸ�
, U.user_workerlevelnm AS "������ ��å"
, DM.document_subject AS ���ȸ�
, DM.document_gradenm  AS �ɻ���
, DM.document_evaluatedate AS �����ɻ���
, DM.document_writedate AS ���ȵ����
, C.categorynm_step1 AS "1���з�"
, C.categorynm_step2 AS "2���з�"
, C.categorynm_step3 AS "3���з�"
, CASE DM.document_sync WHEN '1' THEN '�ǽ���' WHEN '2' THEN '�ǽ���' END AS �ǽñ���
, DM.document_proctype AS ��������
, CASE DM.document_evaluatestep WHEN 'E' THEN '�Ϸ�'  WHEN 'P' THEN '����' WHEN 'R' THEN '���' END AS "�������"
, DM.document_point AS  ���� 
,CASE DE.document_effecttype  WHEN 'M' THEN '����' WHEN 'U' THEN '����'  END AS 'ȿ�����'
, replace(DE.document_effect,char(13)+char(10),'') AS  ���ȿ��
, DE.document_effectamt AS ����ȿ���ݾ�
, E.evaluate_userno AS ���ڻ��
, US.user_nm  AS ����
from [dbo].[INOC_DOCUMENT_MASTER_TBL] AS DM
left join [dbo].[INOC_DOCUMENT_EFFECT_TBL] AS DE
ON DM.document_key = DE.document_key
left join [dbo].[INOC_USER_TBL] AS U
ON DM.document_writerno = U.user_no
left join [dbo].[INOC_CATEGORYSTEP_TBL]  AS C
ON DM.document_categorycd = C.category_code
left join [dbo].[INOC_EVALUATE_JUDGE_TBL] AS E
ON DM.document_key = E.document_key AND evaluate_done = 'N'
LEFT JOIN [dbo].[INOC_USER_TBL] AS US
ON E.evaluate_userno = US.user_no
where document_writedate > '2017-01-01' AND document_writedate < '2017-03-31'
AND DM.document_subject like'%�۾���%'
order by document_writedate

