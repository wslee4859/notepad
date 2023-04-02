select * from INOC_EVALUATE_JUDGE_TBL where document_key = 'I20170500118'



/********************************************
* 1차 접수상태에 접수자가 두명인 케이스 찾기
*********************************************/


select A.document_key, A.evaluate_deptnm, M.document_subject, M.document_writedate, U.user_nm AS [제안자], U1.user_nm AS [접수자]
from INOC_EVALUATE_JUDGE_TBL A
left join [dbo].[INOC_DOCUMENT_MASTER_TBL] M
ON A.document_key = M.document_key
inner join [dbo].[INOC_USER_TBL] U
ON M.document_writerno = U.user_no
inner join [dbo].[INOC_USER_TBL] U1
ON A.evaluate_userno = U1.user_no	
where A.evaluate_proctype = '1'  -- 접수단계가 1번인 것 중에 중복으로 지정된 것 찾기 
group by A.document_key, A.evaluate_deptnm, M.document_subject, M.document_writedate, U.user_nm, U1.user_nm
having count(A.document_key) > 1   
order by A.document_key 


/********************************************
* 1차 접수상태에 접수자가 두명인 케이스에서 두번째 접수자가 평가를 안한 케이스 찾기
*********************************************/

select A.document_key, A.evaluate_deptnm, M.document_subject, M.document_writedate, U.user_nm AS [제안자], U1.user_nm AS [접수자]
from INOC_EVALUATE_JUDGE_TBL A
left join [dbo].[INOC_DOCUMENT_MASTER_TBL] M
ON A.document_key = M.document_key
inner join [dbo].[INOC_USER_TBL] U
ON M.document_writerno = U.user_no
inner join [dbo].[INOC_USER_TBL] U1
ON A.evaluate_userno = U1.user_no
where A.evaluate_proctype = '1' AND A.evaluate_sort = '2' AND A.evaluate_done = 'N'    -- 제안접수
order by A.document_key 


I20170300399



select * from INOC_EVALUATE_JUDGE_TBL where document_key = 'I20170300399'




select A.document_key, A.evaluate_deptnm, M.document_subject, M.document_writedate, U.user_nm AS [제안자], U1.user_nm AS [접수자]
from INOC_EVALUATE_JUDGE_TBL A
left join [dbo].[INOC_DOCUMENT_MASTER_TBL] M
ON A.document_key = M.document_key
inner join [dbo].[INOC_USER_TBL] U
ON M.document_writerno = U.user_no
inner join [dbo].[INOC_USER_TBL] U1
ON A.evaluate_userno = U1.user_no	
where A.evaluate_proctype = '1'  -- 접수단계가 1번인 것 중에 중복으로 지정된 것 찾기 
group by A.document_key, A.evaluate_deptnm, M.document_subject, M.document_writedate, U.user_nm, U1.user_nm
having count(A.document_key) > 1   
order by A.document_key 




