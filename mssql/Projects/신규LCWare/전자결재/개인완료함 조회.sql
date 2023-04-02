

/***************************************************************
전자결재 개인완료함 검색**************************************
-- 개인완료함에 안나오는 경우
	1. b.DELETE_DATE 가 NULL 이 아닐 경우 


	개인완료함 조회 프로시저 USP_ApprovalList_Complete_Select

	select * from common.[IM].[VIEW_USER] where user_name = '김혜정'
****************************************************************/


SELECT
	EXIST_ISURGENT,
	UPPER(ATTACH_EXTENSION) as ATTACH_EXTENSION,
	EXIST_COMMENT,
	EXIST_REF_DOCUMENT,
	NAME as DOC_NAME,
	[SUBJECT],
	CREATOR,
	CREATOR_DEPT,
	EXIST_ATTACH,
	CREATOR_ID,
	PARENT_OID,
	FORM_ID,
	CURRENT_USER_NAME,
	CURRENT_DEPT_NAME,
	CURRENT_LEVEL,
	b.LOCATION,
	b.COMPLETED_DATE as CREATE_DATE,
	b.OPEN_YN,
	b.OID as WORK_ITEM_OID,
	b.PROCESS_INSTANCE_OID,
	b.WKITEM_ID,
	ROW_NUMBER() OVER ( ORDER BY a.CREATE_DATE desc ) AS RowNum, 
	COUNT(*) OVER ( ) AS [RowCount],
	DOC_NUMBER
FROM WF.PROCESS_INSTANCE a
	INNER JOIN WF.WORK_ITEM_CMPL b ON A.OID = b.PROCESS_INSTANCE_OID
	WHERE b.DELETE_DATE IS NULL AND b.PARTICIPANT_ID = '22726_CO'
	
	
	
	
	
/* 부서 발신완료함 */	
exec WF.USP_ApprovalList_Dept_Select @dept_id=N'5511',@folder_type='S',@current_page=1,@row_page=15,@key_column='',@keyword=N'',@orderby_column='CREATE_DATE',@orderby_state=0,@start_date=N'',@end_date=N'',@currentView=N'S',@reDraftId=N''



	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	