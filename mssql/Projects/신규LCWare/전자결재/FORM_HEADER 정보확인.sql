


select * from [WF].[FOLDER] where class_code = 'site02' 
/***********************************************
전자결재 폴더 의 폼헤더 정보 확인  
***********************************************/
select * 
from [WF].[FOLDER] AS FD
left join [WF].[WF_FORMS] AS FM
on FD.FORM_ID = FM.FORM_ID
where class_code = 'site02' AND PARENT_FOLDER_ID = '746'
order by SORT_KEY 


