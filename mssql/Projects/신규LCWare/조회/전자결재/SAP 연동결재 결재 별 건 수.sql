use ewf


select * from [EWF].[WF].[FOLDER] 

-- 음료 SAP 전자결재 총 기안된 수 (반려포함, 진행, 완료 포함)
select name, count(name) from  [WF].[PROCESS_INSTANCE] where FORM_ID in (select FORM_ID from [EWF].[WF].[FOLDER] where PARENT_FOLDER_ID = '1833') AND create_date > '2016-05-01'  
group by name


-- 전자결재 총 기안된 수 (반려포함, 진행, 완료 포함)
select name, count(name) from  [WF].[PROCESS_INSTANCE] where FORM_ID in (select FORM_ID from [EWF].[WF].[FOLDER] where PARENT_FOLDER_ID = '1833')
group by name


--(주류) 전자결재 총 기안된 수 (반려포함, 진행, 완료 포함)
select name, count(name) from  [WF].[PROCESS_INSTANCE] where FORM_ID in (select FORM_ID from [EWF].[WF].[FOLDER] where PARENT_FOLDER_ID = '1911')
group by name

