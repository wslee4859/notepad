/**********
* ǰ���� ���̱׷��̼� �̷�
* �������˰��� -> �������˺Ϻ� (349->9841)
***********/
-- �μ� ��ȸ


select * from [common].[IM].[VIEW_USER] where user_name = ''
select * from [common].[IM].[VIEW_ORG] where group_code = '5613'
9841 - �������˺Ϻ���

-- ������ 5616 
-- �������Ʈ 9811
-- ������Ʈ 5615
-- BI/�λ� 5613
40474
466_A
use ewf
-- ǰ�� �Ϸ���
exec WF.USP_ApprovalList_Dept_Select @dept_id=N'260',@folder_type='A',@current_page=1,@row_page=4000,@key_column='',@keyword=N'',@orderby_column='CREATE_DATE',@orderby_state=0,@start_date=N'',@end_date=N'',@currentView=N'A',@reDraftId=N''

-- �߽� �Ϸ���
exec WF.USP_ApprovalList_Dept_Select @dept_id=N'5613',@folder_type='S',@current_page=1,@row_page=1000,@key_column='',@keyword=N'',@orderby_column='CREATE_DATE',@orderby_state=0,@start_date=N'',@end_date=N'',@currentView=N'S',@reDraftId=N''

-- ���� �Ϸ���
exec WF.USP_ApprovalList_Dept_Select @dept_id=N'5613',@folder_type='O',@current_page=1,@row_page=1000,@key_column='',@keyword=N'',@orderby_column='CREATE_DATE',@orderby_state=0,@start_date=N'',@end_date=N'',@currentView=N'O',@reDraftId=N''


-- ǰ�� �Ϸ��� ��ȸ
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

	  
	  select * from WF.PROCESS_INSTANCE where subject like '%���)%'
	  select * from WF.PROCESS_INSTANCE where creator like '%������%' order by create_date

	  /**************************************************
	   *********����� �μ� ǰ�ǿϷ��� �̰�**************
	   �̰��ؾ��� PARTICIPANT_ID (�����μ�) �� ��ġ�Ͽ� �űԺμ��� ������Ʈ 
	 
	  ex) ��� ����ڸ� �μ��� ���� �Ǿ��� ��� (������ ���������� ����������, ���������� ������)
	  begin tran
	  update WF.WORK_ITEM_CMPL
	  set PARTICIPANT_ID = '9347_A'
	  where 
	  PROCESS_INSTANCE_OID in (select OID from WF.PROCESS_INSTANCE  where creator in ('�����', '�����','�迵��','������','�缱��','����ö','������','�����','ä����','������','������') ) 
	  AND PARTICIPANT_ID = '218_A'
	  ***************************************************/
	  begin tran
	  update WF.WORK_ITEM_CMPL
	  set PARTICIPANT_ID = '5613_A'
	  where 
	  --PROCESS_INSTANCE_OID in (select OID from WF.PROCESS_INSTANCE  where creator in ('�����', '�����','�迵��','������','�缱��','����ö','������','�����','ä����','������','������') ) 
	  PARTICIPANT_ID = '9811_A'


	  commit
	  rollback



	  /************************
	  -- ���� �μ� ������ ��ȸ
	  *************************/
	  select * from WF.WORK_ITEM_CMPL  where 
	  PROCESS_INSTANCE_OID in (select OID from WF.PROCESS_INSTANCE  where creator in ('�����', '�����','�迵��','������','�缱��','����ö','������','�����','ä����','������','������') ) 
	  AND PARTICIPANT_ID = '218_A'


	  select * from WF.WORK_ITEM_CMPL  where 
	  PROCESS_INSTANCE_OID in (select OID from WF.PROCESS_INSTANCE  where creator = '�̿ϻ�' ) 
	  AND PARTICIPANT_ID = '9811_A'


	select * from WF.WORK_ITEM_CMPL where participant_id = '9811_A'