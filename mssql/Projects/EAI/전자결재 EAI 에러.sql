﻿  

use EAI
SELECT *
  FROM TIF_LOG A JOIN PROC_MST B ON A.IF_ID = B.IF_ID
  WHERE START_DTTM > '2016-11-10 18:05:00.020'
  and A.IF_ID like '%BC_APPROVALNEW' 
  ORDER BY START_DTTM DESC 
  
  
  SELECT *
  FROM TIF_LOG A JOIN PROC_MST B ON A.IF_ID = B.IF_ID
  WHERE START_DTTM > '2016-11-10 18:05:00.020'
  and A.IF_ID like '%BC_EMPMASTER' 
  ORDER BY START_DTTM DESC   


-- SAP 인사배치 로그 
use EAI
select * from [dbo].[PROC_MST] where IF_NAME like '%인사%'

SELECT *
FROM TIF_LOG A JOIN PROC_MST B ON A.IF_ID = B.IF_ID
WHERE START_DTTM > '2017-02-02'
AND A.IF_ID = 'BC_EMPMASTER'
ORDER BY END_DTTM DESC


-- 전자결재(신협) 결재상태값 로그 
use EAI
select * from [dbo].[PROC_MST] where IF_NAME like '%결재%'

SELECT *
FROM TIF_LOG A JOIN PROC_MST B ON A.IF_ID = B.IF_ID
WHERE START_DTTM > '2017-02-02'
AND A.IF_ID = 'BC_APPROVALRESULTSHERP'
ORDER BY END_DTTM DESC


SELECT * FROM TIF_LOG WHERE IF_ID = 'BC_APPROVALRESULTSHERP' AND START_DTTM > '2017-07-07' ORDER BY END_DTTM DESC
