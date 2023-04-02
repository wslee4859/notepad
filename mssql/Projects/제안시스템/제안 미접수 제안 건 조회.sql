/**********************************
* 제안 미접수 처리된 리스트 조회
* 2016-12-30
***********************************/


-- 평가접수가 안된 제안시스템
SELECT 
M.document_key, 
M.document_workerno, 
U.user_nm,
M.document_deptnm,
M.document_subject,
M.document_evaluatedate,
M.document_writedate
FROM [dbo].[INOC_DOCUMENT_MASTER_TBL] AS M
LEFT JOIN [dbo].[INOC_EVALUATE_JUDGE_TBL] AS J
ON M.document_key = J.document_key
LEFT JOIN [dbo].[INOC_USER_TBL] AS U
ON M.document_workerno = U.user_no
WHERE J.document_key is null
AND document_writedate > '2016-01-01'
AND M.document_key like '%I2016%'
order by document_writedate desc

