--���� ���� ���� 
-- PROCESS_INSTANCE_OID = process_id
use eWF
select top 100 * from dbo.ACTIVITY_INSTANCE WHERE PROCESS_INSTANCE_OID = 'ZED002392DE5F47EC9714BF41DE8A9BA5'
order by create_date



-- ���� ����� ������ ���� 
-- process_id �� ���� ���� Ȯ�� 
use ewf
select top 100 *
from dbo.WORK_ITEM 
where 1=1 
	and process_instance_oid='Z2EA3F6741FED43EEB52863F3CCBCAF51'
ORDER BY CREATE_DATE 




-- ���� ���� 
select top 100 * from ewf.dbo.engine_approval
where process_instance_oid = 'ZB0D45947C5634F11AA6A63F9C024F829'
