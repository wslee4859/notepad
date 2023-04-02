
-- 결재문서 양식  ekwsql (sa/ admin)
-- form_id
use ewfform
select * from dbo.WF_FORMS where form_name ='차량정비발생현황' 


-- 해당하는 결재문서 양식으로 생성한 결재문서 최근100개 
-- 결재 프로세스 아이디 PROCESS_ID
-- 결재 상황(대기3, 결재7) PROCESS_INSTANCE_STATE

use ewfform
select top 100 * from dbo.FORM_Y747BB57D3D334E53A0CA83F8BE4E379C
where 1=1 
	--AND U_SUBJECT_DETAIL_INPUT like '%커피%'
	AND CREATOR = '권중규'
order by suggestdate desc


select * from dbo.FORM_Y2B172D247B4B4E03A74ABC4B674FEA11
where suggestdate > '20140331' AND suggestdate < '20150501'


select top 100 * from dbo.FORM_Y747BB57D3D334E53A0CA83F8BE4E379C order by suggestdate DESC

select top 100 * from dbo.FORM_Y9818DD0694314EE3B0FD3157E6B21B81 order by suggestdate DESC


