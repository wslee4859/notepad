-- TR ȸ�� ���γ��� ��ȸ
--
select count(*)
from SMS_SYSTEM.[dbo].[em_log_201708]
WHERE tran_status = '3'
	AND tran_rslt = '0'
	AND tran_type = '4'  
	AND tran_etc3 = 'TR'
	AND tran_msg like '%��ǰ���%'

select count(*)
from SMS_SYSTEM.[dbo].[em_log_201707]
WHERE tran_status = '3'
	AND tran_rslt = '0'
	AND tran_type = '4'  
	AND tran_etc3 = 'TR'
	AND tran_msg like '%�������%'

select count(*)
from SMS_SYSTEM.[dbo].[em_log_201707]
WHERE tran_status = '3'
	AND tran_rslt = '0'
	AND tran_type = '4'  
	AND tran_etc3 = 'TR'
	AND tran_msg like '%����ī��%'

select count(*)
from SMS_SYSTEM.[dbo].[em_log_201707]
WHERE tran_status = '3'
	AND tran_rslt = '0'
	AND tran_type = '4'  
	AND tran_etc3 = 'TR'
	AND tran_msg like '%��� �۱�%'

select count(*)
from SMS_SYSTEM.[dbo].[em_log_201707]
WHERE tran_status = '3'
	AND tran_rslt = '0'
	AND tran_type = '4'  
	AND tran_etc3 = 'TR'
	AND tran_msg like '%���%'


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
							AND tran_msg not like '%����ī��%') AS A
				WHERE A.tran_msg not like '%�������%' ) AS B
		WHERE B.tran_msg not like '%��ǰ���%' ) AS C
WHERE C.tran_msg not like '%��� �۱�%'
