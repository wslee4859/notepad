	-- 구 전자결재 개인 완료함 조회 
use Common
select * from [Common].[IM].[VIEW_USER] where user_name = '박경민'
exec CM.usp_MemberMapping_select @id='28226'

-- userID 를 입력 
	use eWFFORM_MIG
	
	SELECT	 
		a.ITEMOID,   
		a.ISURGENT,       
		a.STATUS,   
		a.ISATTACHFILE,   
		a.POSTSCRIPT,   
		a.CATEGORYNAME,   
		REPLACE(replace(a.subject, char(13),''), char(10),''),
		a.DOC_LEVEL,   
		a.CREATOR,   
		a.CREATOR_DEPT,  
		a.VIEW_COMPLETE_DATE as VIEW_COMPLETE_DATE,  
		a.OPEN_YN,  
		a.OID,  
		a.REF_DOC,  
		a.ATTACH_EXTENSION,  
		a.CREATOR_ID,  
		a.DOC_NUMBER,   
		a.FORM_ID,
		a.CREATE_DATE,
		COUNT(*) OVER () AS [ROW_COUNT]       
	from dbo.VW_MIG_WORK_LIST as a
	WHERE PARTICIPANT_ID = '133736'  AND STATE = 7 AND PROCESS_INSTANCE_VIEW_STATE = 7  ORDER BY VIEW_COMPLETE_DATE DESC 


