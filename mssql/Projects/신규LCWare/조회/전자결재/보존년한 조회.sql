/*****************************
* ���ڰ��� �������� ��ȸ ����
*****************************/


select FOLDER_ID, FOLDER_NAME, FOLDER_ENG_NAME from [WF].[FOLDER] where class_code = 'SITE01' order by Depth, sort_key
1812	A	SITE01	00. �Ϲ�
1810	A	SITE01	01. �ѹ�
1811	A	SITE01	02. �λ�
1813	A	SITE01	04. ����
1814	A	SITE01	07. ����
1815	A	SITE01	06. ����


-- ���ڰ��� �������� �˻�
select F.FOLDER_ID, FH.FORM_NAME, FH.FORM_ENG_NAME, FI.FIELD_DEFAULT, F.FORM_ID, FH.CURRENT_FORMS from [WF].[FOLDER] AS F
left join [WF].[WF_FORM_INFORM] AS FI
ON F.FORM_ID = FI.FORM_ID AND FIELD_NAME = 'KEEP_YEAR'
left join [WF].[WF_FORMS] AS FH
ON F.FORM_ID = FH.FORM_ID
where F.class_code = 'SITE01' 
-- AND F.PARENT_FOLDER_ID = '1830'
ORDER BY F.DEPTH, F.SORT_KEY



select * from [WF].[WF_FORM_INFORM] where FIELD_NAME = 'KEEP_YEAR' AND FORM_ID in (select FORM_ID from [WF].[FOLDER] where class_code = 'SITE01' AND PARENT_FOLDER_ID = '1810')

[WF].[WF_FORMS]