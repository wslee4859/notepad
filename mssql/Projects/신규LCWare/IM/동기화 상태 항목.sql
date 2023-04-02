
-- 10.103.1.108
-- 동기화 상태 
--동기화 되고있는지 체크, 동기화 돌고있는 동안에 status에 정보 들어있음. 
-- 계속 동기화 될 경우 삭제해줘야 함. 
use im80
select * from [dbo].[app_status]


--삭제
begin tran 
delete dbo.app_status

commit

