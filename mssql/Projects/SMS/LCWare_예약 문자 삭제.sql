--LCWare 예약 SMS 삭제

use SMS
-- 보낸 사람 번호 입력
select * from SMS.[dbo].[SMS_WAIT] WHERE CALLBACKNO = '01050931607'
select * from [dbo].[SMS_WAIT] where callbackno in ('0317647810', '0317607810')

begin tran
delete 
FROM SMS.[dbo].[SMS_WAIT]
WHERE callbackno in ('0317647810', '0317607810')
--rollback
--commit



---- 위는 옛날 버전

--현재는 [dbo].[em_tran] 데이터베이스에 쌓임

select * from SMS.[dbo].[em_tran] WHERE tran_callback = '01050931607'

commit
begin tran
delete SMS.[dbo].[em_tran]
WHERE tran_callback = '01050931607' AND tran_msg = '6/13(金) 탈의실 위생점검 예정입니다. 윗칸 위생복 이외에 밑으로 정리바랍니다.'