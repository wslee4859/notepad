select * from [WF].[FOLDER]


select * from [WF].[FOLDER] where class_code = 'SITE01' AND PARENT_FOLDER_ID = '1833'
select * from [WF].[FOLDER] where class_code ='site01' AND FOLDER_NAME = '여신증액품의서'   --1833
select * from [WF].[FOLDER] where class_code ='site01' AND FOLDER_ID = '1944'   -- SAP유가증권입고현황
select * from [WF].[FOLDER] where class_code ='site05'    
select * from [WF].[FOLDER]   


/***********************************************
전자결재 폴더 변경 
변경하고자하는 폴더의 parent_FOLDER_ID 입력 
***********************************************/
use EWF
begin tran 
update EWF.[WF].[FOLDER]
set PARENT_FOLDER_ID = '1989', CLASS_CODE = 'SITE05', DEPTH ='3'
WHERE 1=1
		AND	class_code = 'SITE01'
		AND	FOLDER_ID = '2038'	   

commit



