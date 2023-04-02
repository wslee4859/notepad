-- 오류 결재 조회
select * from [WF].[PROCESS_SIGNER] where process_instance_oid = 'P023DF476FF3E4201B55DAC2B5DB2FB6F' order by sign_seq

-- CASE 1. 
-- 다음결재자 create date 입력
-- ACTION_TYPE 01 현결재로 변경
begin tran 
update [WF].[PROCESS_SIGNER]
set CREATE_DATE = '2019-09-05 08:52:00.000' , SIGN_SEQ = '2', ACTION_TYPE = '01'
where SIGN_OID = 'S87B2833C5E6D410AA946285615CED291' 
--commit

begin tran
update [WF].[PROCESS_SIGNER] 
set SIGN_SEQ = '10'
where SIGN_OID = 'S87B2833C5E6D410AA946285615CED291'

update [WF].[PROCESS_SIGNER] 
set SIGN_SEQ = '4'
where SIGN_OID = 'S7783132E151A47DABE921ADF5575A951'



-- 오류 결재 삭제
begin tran
delete [WF].[PROCESS_SIGNER]
where SIGN_OID = 'SE3D275D81ACB4B06973BC68D9141D5D9'
--commit



-- CASE 2. 
-- work_item 수정해야 될 경우
select * from [WF].[WORK_ITEM] where process_instance_oid = 'P106CF8AE3A964E8495D1155A5718ABD7' order by create_date desc
select * from [WF].[WORK_ITEM] where OID = 'WAAE09AC5C94E4D38A55D0B22EC6ACC7B'

-- common.[IM].[VIEW_USER] where user_name = '유상훈'  

begin tran
update [WF].[WORK_ITEM]
SET PARTICIPANT_ID = '35726', PARTICIPANT_NAME = '유상훈'
where OID = 'WAAE09AC5C94E4D38A55D0B22EC6ACC7B'

commit
