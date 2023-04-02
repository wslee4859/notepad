-- TR 회계 세부내역 조회
--
select count(*)
from SMS_SYSTEM.[dbo].[em_log_201708]
WHERE tran_status = '3'
	AND tran_rslt = '0'
	AND tran_type = '4'  
	AND tran_etc3 = 'TR'
	AND tran_msg like '%물품대금%'

select count(*)
from SMS_SYSTEM.[dbo].[em_log_201707]
WHERE tran_status = '3'
	AND tran_rslt = '0'
	AND tran_type = '4'  
	AND tran_etc3 = 'TR'
	AND tran_msg like '%가상계좌%'

select count(*)
from SMS_SYSTEM.[dbo].[em_log_201707]
WHERE tran_status = '3'
	AND tran_rslt = '0'
	AND tran_type = '4'  
	AND tran_etc3 = 'TR'
	AND tran_msg like '%법인카드%'

select count(*)
from SMS_SYSTEM.[dbo].[em_log_201707]
WHERE tran_status = '3'
	AND tran_rslt = '0'
	AND tran_type = '4'  
	AND tran_etc3 = 'TR'
	AND tran_msg like '%경비 송금%'

select count(*)
from SMS_SYSTEM.[dbo].[em_log_201707]
WHERE tran_status = '3'
	AND tran_rslt = '0'
	AND tran_type = '4'  
	AND tran_etc3 = 'TR'
	AND tran_msg like '%대금%'


select tran_msg
from (	select tran_msg
		from (
				select tran_msg
				from (select tran_msg
						from SMS_SYSTEM.[dbo].[em_log_201708]
						WHERE tran_status = '3'
							AND tran_rslt = '0'
							AND tran_type = '4'  
							AND tran_etc3 = 'TR'
							AND tran_msg not like '%법인카드%') AS A
				WHERE A.tran_msg not like '%가상계좌%' ) AS B
		WHERE B.tran_msg not like '%물품대금%' ) AS C
WHERE C.tran_msg not like '%경비 송금%'
