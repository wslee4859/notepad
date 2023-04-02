-- SD 회계 세부내역 조회
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
	AND tran_etc3 = 'SD'
GROUP BY tran_callback

select *
from SMS_SYSTEM.[dbo].[em_log_201706]
WHERE tran_status = '3'
	AND tran_rslt = '0'
	AND tran_type = '4'  
	AND tran_etc3 = 'SD'
	AND tran_callback in ('0226216756')


select *
from SMS_SYSTEM.[dbo].[em_log_201706]
WHERE tran_status = '3'
	AND tran_rslt = '0'
	AND tran_type = '4'  
	AND tran_etc3 = 'SD'
	AND tran_msg like '%출발합니다%'
------------------------------------------------------------------------------------
--콜센터
select *
from SMS_SYSTEM.[dbo].[em_log_201707]
WHERE tran_status = '3'
	AND tran_rslt = '0'
	AND tran_type = '4'  
	AND tran_etc3 = 'SD'
	AND tran_etc1 = '17200'

-- 판매카드 출금내역
select *
from SMS_SYSTEM.[dbo].[em_log_201707]
WHERE tran_status = '3'
	AND tran_rslt = '0'
	AND tran_type = '4'  
	AND tran_etc3 = 'SD'
	AND tran_callback = '0220501328'

-- 대리점 배송정보
select count(*)
from SMS_SYSTEM.[dbo].[em_log_201707]
WHERE tran_status = '3'
	AND tran_rslt = '0'
	AND tran_type = '4'  
	AND tran_etc3 = 'SD'
	AND tran_callback in ('01020490366','0553848628','0316777743','0429308292','0625718876','0234799462','0317607972')

-- 대리점 배송정보
select count(*)
from SMS_SYSTEM.[dbo].[em_log_201707]
WHERE tran_status = '3'
	AND tran_rslt = '0'
	AND tran_type = '4'  
	AND tran_etc3 = 'SD'
	AND tran_etc1 = '19644899'

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
							AND tran_etc3 = 'SD'
							AND tran_etc1 != '17200') AS A
				WHERE A.tran_callback != '0220501328' ) AS B
		WHERE B.tran_callback not in ('01020490366','0553848628','0316777743','0429308292','0625718876','0234799462','0317607972') ) AS C
WHERE tran_etc1 != '19644899'
