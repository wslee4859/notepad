

/********************************************************
개인 진행함 조회 
********************************************************/
select * from common.[IM].[VIEW_USER] where user_name = '김창훈'

select * from WF.UV_WORK_LIST  WHERE PARTICIPANT_ID='25423'  AND STATE = 7  AND  PROCESS_INSTANCE_VIEW_STATE = 3 




/********************************************************
개인 결재함 조회 
********************************************************/
select * from WF.UV_WORK_LIST  WHERE PARTICIPANT_ID='25423'  AND STATE = 2  AND  PROCESS_INSTANCE_VIEW_STATE = 3 

