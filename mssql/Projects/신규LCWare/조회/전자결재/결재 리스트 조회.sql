

/****************************
* ���� ī�װ� ����Ʈ  ��ȸ 
*****************************/
USE EWF
select * from [WF].[FOLDER] where DEPTH = '2' ORDER BY CLASS_CODE, SORT_KEY
select * from [WF].[FOLDER] where DEPTH = '1' ORDER BY CLASS_CODE, SORT_KEY


/********************************************
*** ī�װ� ���� ���� ����Ʈ ��ȸ*********
*********************************************/
select * from [WF].[WF_FORMS] WHERE CLASSIFICATION = '1812' 



/****************************
* ���� ���ڰ��� ����Ʈ  ��ȸ 
*****************************/
	WITH LOW_FOLDER AS
	( 
		SELECT     
			A.FOLDER_ID,     
			A.TYPE,   
			A.CLASS_CODE,    
			A.FOLDER_NAME,	
			F.FORM_ENAME,
			F.CURRENT_FORMS AS [��뿩��],
			S.PERSON_AGREE_YN AS [��������],
			S.DEPT_AGREE_YN AS [�μ�����],
			S.AGREE_APPROVAL_USE_YN AS [���ǰ���],
			S.RCV_USE_YN AS [���Ű���],
			S.RCV_DEPT_NUM AS [���źμ�����],
			S.RECEPTION_DEPT AS [���źμ�],
			S.COOPERATION_YN AS [��������],
			S.DBAPPROVAL_USE_YN AS [��������] 		  
		FROM [WF].[FOLDER] AS A
		LEFT JOIN [WF].[WF_FORM_SCHEMA] AS S
		ON A.FORM_ID = S.FORM_ID
		LEFT JOIN  [WF].[WF_FORMS] AS F
		ON A.FORM_ID = F.FORM_ID
		WHERE A.FOLDER_ID in ('772')    --���� FOLDER_ID �Է�  	


		UNION ALL
		SELECT 
			A.FOLDER_ID,
			A.TYPE,
			A.CLASS_CODE,
			A.FOLDER_NAME,
			F.FORM_ENAME,
			F.CURRENT_FORMS AS [��뿩��],
			S.PERSON_AGREE_YN AS [��������],
			S.DEPT_AGREE_YN AS [�μ�����],
			S.AGREE_APPROVAL_USE_YN AS [���ǰ���],
			S.RCV_USE_YN AS [���Ű���],
			S.RCV_DEPT_NUM AS [���źμ�����],
			S.RECEPTION_DEPT AS [���źμ�],
			S.COOPERATION_YN AS [��������],
			S.DBAPPROVAL_USE_YN AS [��������] 		
		FROM [WF].[FOLDER] AS A 
		LEFT JOIN LOW_FOLDER B 
		ON A.PARENT_FOLDER_ID = B.FOLDER_ID
		INNER JOIN [WF].[WF_FORM_SCHEMA] AS S
		ON A.FORM_ID = S.FORM_ID	
		INNER JOIN [WF].[WF_FORMS] AS F
		ON A.FORM_ID = F.FORM_ID	    
	)
	select * from LOW_FOLDER WHERE ��뿩�� <> 'N' OR ��뿩�� is null
	 

select 
F.FORM_NAME, 
F.FORM_ENAME,
F.FORM_ALIAS,
S.PERSON_AGREE_YN AS [��������],
S.DEPT_AGREE_YN AS [�μ�����],
S.AGREE_APPROVAL_USE_YN AS [���ǰ���],
S.RCV_USE_YN AS [���Ű���],
S.RCV_DEPT_NUM AS [���źμ�����],
S.RECEPTION_DEPT AS [���źμ�],
S.COOPERATION_YN AS [��������],
S.DBAPPROVAL_USE_YN AS [��������] 
from [WF].[WF_FORMS] AS F
LEFT JOIN [WF].[WF_FORM_SCHEMA] AS S
ON F.FORM_ID = S.FORM_ID
WHERE CLASSIFICATION = '1928' 



[WF].[WF_FORM_SCHEMA]

[WF].[WF_FOLDER_TYPE]