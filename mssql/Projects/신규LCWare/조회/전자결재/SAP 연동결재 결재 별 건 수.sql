use ewf


select * from [EWF].[WF].[FOLDER] 

-- ���� SAP ���ڰ��� �� ��ȵ� �� (�ݷ�����, ����, �Ϸ� ����)
select name, count(name) from  [WF].[PROCESS_INSTANCE] where FORM_ID in (select FORM_ID from [EWF].[WF].[FOLDER] where PARENT_FOLDER_ID = '1833') AND create_date > '2016-05-01'  
group by name


-- ���ڰ��� �� ��ȵ� �� (�ݷ�����, ����, �Ϸ� ����)
select name, count(name) from  [WF].[PROCESS_INSTANCE] where FORM_ID in (select FORM_ID from [EWF].[WF].[FOLDER] where PARENT_FOLDER_ID = '1833')
group by name


--(�ַ�) ���ڰ��� �� ��ȵ� �� (�ݷ�����, ����, �Ϸ� ����)
select name, count(name) from  [WF].[PROCESS_INSTANCE] where FORM_ID in (select FORM_ID from [EWF].[WF].[FOLDER] where PARENT_FOLDER_ID = '1911')
group by name

