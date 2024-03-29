[dbo].[PROC_MST] WHERE PROJECT_ID = 'LT_BC'

select @@trancount
/***********************************************
*EAI IF INSERT(개발) BC_APPROVALDELETEQA
BC_APPROVALREVERSALQA
BC_APPROVALREVERSALQA
************************************************/
SELECT * FROM [dbo].[PROC_MST] WHERE IF_ID = 'BC_APPROVALRESULTFIQA'
SELECT * FROM [dbo].[PROC_MST] WHERE IF_ID = 'BC_APPROVALAUTOQA'
SELECT * FROM [dbo].[PROC_MST] WHERE IF_ID = 'BC_EVSRESULTQA'
SELECT * FROM [dbo].[PROC_MST] WHERE IF_ID = 'BC_APPROVALREVERSALQA'
SELECT * FROM [dbo].[PROC_MST] WHERE IF_ID = 'BC_APPROVALDELETEQA'
SELECT * FROM [dbo].[PROC_MST] WHERE IF_ID = 'BC_APPROVALLOADQA'
SELECT * FROM [dbo].[PROC_MST] WHERE IF_ID = 'BC_APPROVALRESULTNEW'
SELECT * FROM [dbo].[PROC_MST] WHERE PROJECT_ID = 'LT_BC'
rollback
--commit
BEGIN TRAN 
INSERT INTO [dbo].[PROC_MST] (
IF_ID, 
IF_NAME, 
PROJECT_ID, 
START_SUBJECT, 
RUN_MODE ,
FIRST_RUN_TIME,
INTERVAL_UNIT,
INTERVAL,
FILE_YN,
LAST_REMARK,
SOURCE_SYSTEM,
SOURCE_OBJECT,
TARGET_SYSTEM,
TARGET_OBJECT,
ALERT_GROUP,
NOTE,
USE_YN,
REWORK_YN,
CREATE_DTTM,
UPDATE_DTTM )
SELECT
'BC_APPROVADELETEQA',
'전자결재 호출 삭제(QA)',
PROJECT_ID,
START_SUBJECT, 
RUN_MODE ,
FIRST_RUN_TIME,
INTERVAL_UNIT,
INTERVAL,
FILE_YN,
LAST_REMARK,
'SAP',
'ZFI_GW_DELETE',
'EKW3',
'http://dev.lottechilsung.co.kr/Service/Interface.asmx?',
'BW_2',
NOTE,
USE_YN,
REWORK_YN,
getdate(),
getdate()
FROM [dbo].[PROC_MST]
WHERE IF_ID = 'BC_APPROVALLOADQA'
 


 
 begin tran
 update  [dbo].[PROC_MST]
 SET IF_ID = 'BC_APPROVALDELETEQA'
 WHERE IF_ID = 'BC_APPROVADELETEQA'