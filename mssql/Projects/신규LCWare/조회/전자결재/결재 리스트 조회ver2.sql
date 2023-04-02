

/****************************
* 결재 카테고리 리스트  조회 
*****************************/
USE EWF
select * from [WF].[FOLDER] where DEPTH = '2' ORDER BY CLASS_CODE, SORT_KEY
select * from [WF].[FOLDER] where DEPTH = '1' ORDER BY CLASS_CODE, SORT_KEY


/********************************************
*** 카테고리 하위 결재 리스트 조회*********
*********************************************/
select * from [WF].[WF_FORMS] WHERE CLASSIFICATION = '1810' 

select * from [WF].[FOLDER] where CLASS_CODE = 'SITE01' ORDER BY CLASS_CODE, SORT_KEY 

select * from [WF].[FOLDER] where DEPTH = '2' AND CLASS_CODE = 'SITE01' ORDER BY CLASS_CODE, SORT_KEY  

select * from [WF].[FOLDER] where DEPTH = '2' AND CLASS_CODE = 'SITE05' ORDER BY CLASS_CODE, SORT_KEY  





1989


772		롯데칠성음료	
1		롯데주류
1900	CH
1982	백학음료
1988	신협

 
/****************************
* 하위 전자결재 리스트  조회 
*****************************/
	WITH LOW_FOLDER AS
	( 
		SELECT     
			A.FOLDER_ID,     
			A.TYPE,   
			A.CLASS_CODE,    
			A.FOLDER_NAME,
			A.FORM_ID,
			A.SORT_KEY,
			A.DEPTH,
			A.PARENT_FOLDER_ID		  
		FROM [WF].[FOLDER] AS A		
		WHERE A.FOLDER_ID in ('1988')    --상위 FOLDER_ID 입력  	


		UNION ALL
		SELECT 
			A.FOLDER_ID,
			A.TYPE,
			A.CLASS_CODE,
			A.FOLDER_NAME,
			A.FORM_ID,
			A.SORT_KEY,
			A.DEPTH,
			A.PARENT_FOLDER_ID
		FROM [WF].[FOLDER] AS A 
		INNER JOIN LOW_FOLDER B 
		ON A.PARENT_FOLDER_ID = B.FOLDER_ID		
	)
	SELECT 
	--A.FOLDER_ID,
	--A.CLASS_CODE, 
	A_.FOLDER_NAME,
	A.FOLDER_NAME,	
	F.FORM_ENAME,
	F.FORM_ALIAS,
	S.FORM_ID, 
	F.CURRENT_FORMS AS [사용여부],
	S.PERSON_AGREE_YN AS [개인합의],
	S.DEPT_AGREE_YN AS [부서합의],
	S.AGREE_APPROVAL_USE_YN AS [합의결재],
	S.RCV_USE_YN AS [수신결재],
	S.RCV_DEPT_NUM AS [수신부서갯수],
	S.RECEPTION_DEPT AS [수신부서],
	S.COOPERATION_YN AS [협조결재],
	S.DBAPPROVAL_USE_YN AS [연동결재],
	A.SORT_KEY AS [정렬] ,
	I.FIELD_DEFAULT AS [보존년한]
	FROM LOW_FOLDER AS A
    LEFT JOIN [WF].[WF_FORM_SCHEMA] AS S
	ON A.FORM_ID = S.FORM_ID
	LEFT JOIN  [WF].[WF_FORMS] AS F
	ON A.FORM_ID = F.FORM_ID
	LEFT JOIN [WF].[WF_FORM_INFORM] AS I
	ON A.FORM_ID = I.FORM_ID AND FIELD_NAME = 'KEEP_YEAR'
	LEFT JOIN LOW_FOLDER AS A_
	ON A.PARENT_FOLDER_ID = A_.FOLDER_ID	
	WHERE F.CURRENT_FORMS <> 'N' OR F.CURRENT_FORMS is null
	order by A_.FOLDER_NAME, A.DEPTH, A.SORT_KEY
 

--select 
--F.FORM_NAME, 
--F.FORM_ENAME,
--F.FORM_ALIAS,
--S.PERSON_AGREE_YN AS [개인합의],
--S.DEPT_AGREE_YN AS [부서합의],
--S.AGREE_APPROVAL_USE_YN AS [합의결재],
--S.RCV_USE_YN AS [수신결재],
--S.RCV_DEPT_NUM AS [수신부서갯수],
--S.RECEPTION_DEPT AS [수신부서],
--S.COOPERATION_YN AS [협조결재],
--S.DBAPPROVAL_USE_YN AS [연동결재] 
--from [WF].[WF_FORMS] AS F
--LEFT JOIN [WF].[WF_FORM_SCHEMA] AS S
--ON F.FORM_ID = S.FORM_ID
--WHERE CLASSIFICATION = '1928' 



--[WF].[WF_FORM_SCHEMA]

--[WF].[WF_FOLDER_TYPE]

--SELECT     
--			A.FOLDER_ID,     
--			A.TYPE,   
--			A.CLASS_CODE,    
--			A.FOLDER_NAME,	
--			F.FORM_ENAME,
--			F.CURRENT_FORMS AS [사용여부],
--			S.PERSON_AGREE_YN AS [개인합의],
--			S.DEPT_AGREE_YN AS [부서합의],
--			S.AGREE_APPROVAL_USE_YN AS [합의결재],
--			S.RCV_USE_YN AS [수신결재],
--			S.RCV_DEPT_NUM AS [수신부서갯수],
--			S.RECEPTION_DEPT AS [수신부서],
--			S.COOPERATION_YN AS [협조결재],
--			S.DBAPPROVAL_USE_YN AS [연동결재] 		  
--		FROM [WF].[FOLDER] AS A
--		LEFT JOIN [WF].[WF_FORM_SCHEMA] AS S
--		ON A.FORM_ID = S.FORM_ID
--		LEFT JOIN  [WF].[WF_FORMS] AS F
--		ON A.FORM_ID = F.FORM_ID
--		WHERE A.FOLDER_ID in ('772')    --상위 FOLDER_ID 입력  	


--		UNION ALL
--		SELECT 
--			A.FOLDER_ID,
--			A.TYPE,
--			A.CLASS_CODE,
--			A.FOLDER_NAME,
--			F.FORM_ENAME,
--			F.CURRENT_FORMS AS [사용여부],
--			S.PERSON_AGREE_YN AS [개인합의],
--			S.DEPT_AGREE_YN AS [부서합의],
--			S.AGREE_APPROVAL_USE_YN AS [합의결재],
--			S.RCV_USE_YN AS [수신결재],
--			S.RCV_DEPT_NUM AS [수신부서갯수],
--			S.RECEPTION_DEPT AS [수신부서],
--			S.COOPERATION_YN AS [협조결재],
--			S.DBAPPROVAL_USE_YN AS [연동결재] 		
--		FROM [WF].[FOLDER] AS A 
--		LEFT JOIN LOW_FOLDER B 
--		ON A.PARENT_FOLDER_ID = B.FOLDER_ID
--		INNER JOIN [WF].[WF_FORM_SCHEMA] AS S
--		ON A.FORM_ID = S.FORM_ID	
--		INNER JOIN [WF].[WF_FORMS] AS F
--		ON A.FORM_ID = F.FORM_ID	 