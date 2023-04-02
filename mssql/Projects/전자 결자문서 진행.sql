--전자 결재 진행 
-- PROCESS_INSTANCE_OID = process_id
use eWF
select top 100 * from dbo.ACTIVITY_INSTANCE WHERE PROCESS_INSTANCE_OID = 'ZED002392DE5F47EC9714BF41DE8A9BA5'
order by create_date



-- 결재 실행시 결재자 내역 
-- process_id 로 결재 문서 확인 
use ewf
select top 100 *
from dbo.WORK_ITEM 
where 1=1 
	and process_instance_oid='Z2EA3F6741FED43EEB52863F3CCBCAF51'
ORDER BY CREATE_DATE 




-- 결재 엔진 
select top 100 * from ewf.dbo.engine_approval
where process_instance_oid = 'ZB0D45947C5634F11AA6A63F9C024F829'
