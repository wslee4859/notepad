/**********
* 품의함 마이그레이션 이력
* 유흥판촉강북 -> 유흥판촉북부 (349->9841)
***********/
-- 부서 조회


select * from [common].[IM].[VIEW_USER] where user_name = ''
select * from [common].[IM].[VIEW_ORG] where group_code = '5613'
9841 - 유흥판촉북부팀

-- 전산기술 5616 
-- 모바일파트 9811
-- 영업파트 5615
-- BI/인사 5613
40474
466_A
use ewf
-- 품의 완료함
exec WF.USP_ApprovalList_Dept_Select @dept_id=N'260',@folder_type='A',@current_page=1,@row_page=4000,@key_column='',@keyword=N'',@orderby_column='CREATE_DATE',@orderby_state=0,@start_date=N'',@end_date=N'',@currentView=N'A',@reDraftId=N''

-- 발신 완료함
exec WF.USP_ApprovalList_Dept_Select @dept_id=N'5613',@folder_type='S',@current_page=1,@row_page=1000,@key_column='',@keyword=N'',@orderby_column='CREATE_DATE',@orderby_state=0,@start_date=N'',@end_date=N'',@currentView=N'S',@reDraftId=N''

-- 수신 완료함
exec WF.USP_ApprovalList_Dept_Select @dept_id=N'5613',@folder_type='O',@current_page=1,@row_page=1000,@key_column='',@keyword=N'',@orderby_column='CREATE_DATE',@orderby_state=0,@start_date=N'',@end_date=N'',@currentView=N'O',@reDraftId=N''


-- 품의 완료함 조회
218-> 9347


	select            
     EXIST_ISURGENT,      
     UPPER(ATTACH_EXTENSION) as ATTACH_EXTENSION,      
     EXIST_COMMENT,         
     EXIST_REF_DOCUMENT,      
     NAME DOC_NAME,      
     [SUBJECT],      
     CREATOR,      
     CREATOR_DEPT,      
     EXIST_ATTACH,      
     CREATOR_ID,      
     PARENT_OID,      
     a.FORM_ID,           
     CURRENT_USER_NAME,      
     DOC_NUMBER=DOC_NAME,      
     a.DOC_LEVEL,           
     b.*, ROW_NUMBER() OVER ( ORDER BY A.CREATE_DATE desc) AS RowNum, COUNT(*) OVER ( ) AS [RowCount]      
      from WF.PROCESS_INSTANCE a      
      inner join       
      (      
       select       
       COMPLETED_DATE as CREATE_DATE, OPEN_YN, OID as WORK_ITEM_OID, PROCESS_INSTANCE_OID, WKITEM_ID, LOCATION      
       from WF.WORK_ITEM_CMPL      
       where PARTICIPANT_ID='5613_A' ) b       
      on A.OID = b.PROCESS_INSTANCE_OID      
      left outer join WF.WF_DOC_NUMBER c      
      on PROCESS_INSTANCE_OID = c.PROCESS_ID

	  
	  select * from WF.PROCESS_INSTANCE where subject like '%경산)%'
	  select * from WF.PROCESS_INSTANCE where creator like '%주은혜%' order by create_date

	  /**************************************************
	   *********사용자 부서 품의완료함 이관**************
	   이관해야할 PARTICIPANT_ID (이전부서) 를 서치하여 신규부서로 업데이트 
	 
	  ex) 몇몇 사용자만 부서가 변경 되었을 경우 (경산공장 생산팀에서 생산지원팀, 생산팀으로 나눠짐)
	  begin tran
	  update WF.WORK_ITEM_CMPL
	  set PARTICIPANT_ID = '9347_A'
	  where 
	  PROCESS_INSTANCE_OID in (select OID from WF.PROCESS_INSTANCE  where creator in ('김수자', '김상진','김영린','김정희','양선모','오영철','조성우','조재승','채성원','최진아','허진아') ) 
	  AND PARTICIPANT_ID = '218_A'
	  ***************************************************/
	  begin tran
	  update WF.WORK_ITEM_CMPL
	  set PARTICIPANT_ID = '5613_A'
	  where 
	  --PROCESS_INSTANCE_OID in (select OID from WF.PROCESS_INSTANCE  where creator in ('김수자', '김상진','김영린','김정희','양선모','오영철','조성우','조재승','채성원','최진아','허진아') ) 
	  PARTICIPANT_ID = '9811_A'


	  commit
	  rollback



	  /************************
	  -- 이전 부서 수신함 조회
	  *************************/
	  select * from WF.WORK_ITEM_CMPL  where 
	  PROCESS_INSTANCE_OID in (select OID from WF.PROCESS_INSTANCE  where creator in ('김수자', '김상진','김영린','김정희','양선모','오영철','조성우','조재승','채성원','최진아','허진아') ) 
	  AND PARTICIPANT_ID = '218_A'


	  select * from WF.WORK_ITEM_CMPL  where 
	  PROCESS_INSTANCE_OID in (select OID from WF.PROCESS_INSTANCE  where creator = '이완상' ) 
	  AND PARTICIPANT_ID = '9811_A'


	select * from WF.WORK_ITEM_CMPL where participant_id = '9811_A'