-- SYS 회계 세부내역 조회
---- 모듈별 전송 갯 수 ---
select distinct(tran_etc3), count(*)
from SMS_SYSTEM.[dbo].[em_log_201706]
WHERE tran_status = '3'
	AND tran_rslt = '0'
	AND tran_type = '4'  
GROUP BY tran_etc3

select distinct(tran_callback), count(*)
from SMS_SYSTEM.[dbo].[em_log_201706]
WHERE tran_status = '3'
	AND tran_rslt = '0'
	AND tran_type = '4'  
	AND tran_etc3 = 'SYS'
GROUP BY tran_callback


------------------------------------------------------------------------------------
--당직자
select *
from SMS_SYSTEM.[dbo].[em_log_201708]
WHERE tran_status = '3'
	AND tran_rslt = '0'
	AND tran_type = '4'  
	AND tran_etc3 = 'SYS'
	AND tran_msg like '%당직자%'

-- 당직자 외 
select *
from SMS_SYSTEM.[dbo].[em_log_201708]
WHERE tran_status = '3'
	AND tran_rslt = '0'
	AND tran_type = '4'  
	AND tran_etc3 = 'SYS'
	AND tran_msg not like '%당직자%'


------------------------------------------------------------------------------------------------------------------------------------------------------------------------
select tran_callback, tran_msg, tran_etc1
from (	select tran_callback,tran_msg, tran_etc1
		from (
				select tran_callback,tran_msg, tran_etc1
				from (select tran_callback ,tran_msg, tran_etc1
						from SMS_SYSTEM.[dbo].[em_log_201706]
						WHERE tran_status = '3'
							AND tran_rslt = '0'
							AND tran_type = '4'  
							AND tran_etc3 = 'SYS'
							AND tran_msg not like '%당직자%') AS A
				WHERE A.tran_callback != '0220501328' ) AS B
		WHERE B.tran_callback not in ('01020490366','0553848628','0316777743','0429308292','0625718876','0234799462','0317607972') ) AS C
WHERE tran_etc1 != '19644899'
