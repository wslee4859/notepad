-- 유저 정보 검색 
use emanage
--select * from dbo.TB_USER where username='김미림'    --142910
--select * from dbo.TB_USER where username='김우중'    --141014
select * from dbo.TB_USER where username='백경화'    --133564


-- userid 로 사용자 결재함 확인
-- categoryname 결재문서 양식 
use ewfform
select top 100 * from dbo.VW_WORK_LIST where participant_id = '128577' order by create_date desc





-- 결재문서 양식  ekwsql (sa/ admin)
-- form_id
use ewfform
select * from dbo.WF_FORMS where form_name ='기안서(생산용)' 



-- 해당하는 결재문서 양식으로 생성한 결재문서 최근100개 
-- 결재 프로세스 아이디 PROCESS_ID
-- 결재 상황(대기3, 결재7) PROCESS_INSTANCE_STATE
use ewfform

select top 100 * from dbo.FORM_YA1EA79830D1742CEA53B545BD595FF28
where 1=1 
	and creator ='백경화'
order by suggestdate desc



-- 결재 실행시 결재자 내역(결재정보)
-- process_id 로 결재 문서 확인 

select *
from ewf.dbo.WORK_ITEM 
where 1=1 
	and process_instance_oid='ZEB9105C1EEF247F49FC544A76C40083C'
order by create_date


-- 해당 결재 문서 진행(에러메시지)
select oid,process_instance_oid, state, prc_datetime, retry_cnt, err_msg
from ewf.dbo.ENGINE_APPROVAL
where process_instance_oid = 'ZEB9105C1EEF247F49FC544A76C40083C'


select * from ewf.dbo.transition_instance
where process_instance_oid = 'ZEB9105C1EEF247F49FC544A76C40083C'
order by create_date


select * from ewf.dbo.activity_instance
where process_instance_oid = 'ZEB9105C1EEF247F49FC544A76C40083C'
order by create_date