/****************************************
*
* 제안 현 평가자 조회 쿼리
******************************************/

select
M.document_key,
M.document_deptnm, 
M.document_workerno,
U.user_nm,
M.document_subject,
M.document_proctype,
E.evaluate_deptnm,
E.evaluate_userno,
U1.user_nm
from [dbo].[INOC_DOCUMENT_MASTER_TBL] AS M
INNER join [dbo].[INOC_EVALUATE_JUDGE_TBL]  AS E
on M.document_key = E.document_key AND E.evaluate_done = 'N'
INNER JOIN [dbo].[INOC_USER_TBL] AS U
on M.document_workerno = U.user_no
INNER JOIN [dbo].[INOC_USER_TBL] AS U1
on E.evaluate_userno = U1.user_no
WHERE 1=1
--M.document_writedate > '2018-01-01'
AND M.document_evaluatestep != 'E'
AND U1.user_nm = '김인복'
ORDER BY document_writedate desc



select * from [dbo].[INOC_EVALUATE_JUDGE_TBL] where document_key = 'I20161100099'
