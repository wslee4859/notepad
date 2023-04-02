select * from INOC_EVALUATE_JUDGE_TBL where document_key = 'I20170500118'



/********************************************
* 1�� �������¿� �����ڰ� �θ��� ���̽� ã��
*********************************************/


select A.document_key, A.evaluate_deptnm, M.document_subject, M.document_writedate, U.user_nm AS [������], U1.user_nm AS [������]
from INOC_EVALUATE_JUDGE_TBL A
left join [dbo].[INOC_DOCUMENT_MASTER_TBL] M
ON A.document_key = M.document_key
inner join [dbo].[INOC_USER_TBL] U
ON M.document_writerno = U.user_no
inner join [dbo].[INOC_USER_TBL] U1
ON A.evaluate_userno = U1.user_no	
where A.evaluate_proctype = '1'  -- �����ܰ谡 1���� �� �߿� �ߺ����� ������ �� ã�� 
group by A.document_key, A.evaluate_deptnm, M.document_subject, M.document_writedate, U.user_nm, U1.user_nm
having count(A.document_key) > 1   
order by A.document_key 


/********************************************
* 1�� �������¿� �����ڰ� �θ��� ���̽����� �ι�° �����ڰ� �򰡸� ���� ���̽� ã��
*********************************************/

select A.document_key, A.evaluate_deptnm, M.document_subject, M.document_writedate, U.user_nm AS [������], U1.user_nm AS [������]
from INOC_EVALUATE_JUDGE_TBL A
left join [dbo].[INOC_DOCUMENT_MASTER_TBL] M
ON A.document_key = M.document_key
inner join [dbo].[INOC_USER_TBL] U
ON M.document_writerno = U.user_no
inner join [dbo].[INOC_USER_TBL] U1
ON A.evaluate_userno = U1.user_no
where A.evaluate_proctype = '1' AND A.evaluate_sort = '2' AND A.evaluate_done = 'N'    -- ��������
order by A.document_key 


I20170300399



select * from INOC_EVALUATE_JUDGE_TBL where document_key = 'I20170300399'




select A.document_key, A.evaluate_deptnm, M.document_subject, M.document_writedate, U.user_nm AS [������], U1.user_nm AS [������]
from INOC_EVALUATE_JUDGE_TBL A
left join [dbo].[INOC_DOCUMENT_MASTER_TBL] M
ON A.document_key = M.document_key
inner join [dbo].[INOC_USER_TBL] U
ON M.document_writerno = U.user_no
inner join [dbo].[INOC_USER_TBL] U1
ON A.evaluate_userno = U1.user_no	
where A.evaluate_proctype = '1'  -- �����ܰ谡 1���� �� �߿� �ߺ����� ������ �� ã�� 
group by A.document_key, A.evaluate_deptnm, M.document_subject, M.document_writedate, U.user_nm, U1.user_nm
having count(A.document_key) > 1   
order by A.document_key 




