select * from [WF].[FOLDER]


select * from [WF].[FOLDER] where class_code = 'SITE01' AND PARENT_FOLDER_ID = '1833'
select * from [WF].[FOLDER] where class_code ='site01' AND FOLDER_NAME = '��������ǰ�Ǽ�'   --1833
select * from [WF].[FOLDER] where class_code ='site01' AND FOLDER_ID = '1944'   -- SAP���������԰���Ȳ
select * from [WF].[FOLDER] where class_code ='site05'    
select * from [WF].[FOLDER]   


/***********************************************
���ڰ��� ���� ���� 
�����ϰ����ϴ� ������ parent_FOLDER_ID �Է� 
***********************************************/
use EWF
begin tran 
update EWF.[WF].[FOLDER]
set PARENT_FOLDER_ID = '1989', CLASS_CODE = 'SITE05', DEPTH ='3'
WHERE 1=1
		AND	class_code = 'SITE01'
		AND	FOLDER_ID = '2038'	   

commit



