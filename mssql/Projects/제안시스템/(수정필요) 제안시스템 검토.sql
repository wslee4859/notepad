--19501162


--����� ���� �˻� UserID, UserCD, UserName, UserAccount
select  U.UserID, U.UserCD, U.UserName, U.UserAccount, D.DeptName, D.DeptCd, D.DeptID from eManage.dbo.TB_USER AS U
	INNER JOIN eManage.[dbo].[TB_DEPT_USER_HISTORY] AS DUH
	ON DUH.UserID = U.UserID AND EndDate > getdate()
    INNER JOIN eManage.dbo.TB_DEPT AS D
	ON DUH.DeptID = D.DeptID
WHERE U.UserName='��â��' AND U.DELETEDATE > getdate()


-- �ɽ��� ���� ���̺� 
-- document_key  :  ���� ���� ��ȣ
-- evaluate_proctype : 1.���� , 2.����, 3.����, 4.����
-- evaluate_deptcd : �μ��ڵ� 
-- evaluate_deptnm : �μ� 
-- evaluate_userno : �ɻ��� UserCD
-- evaluate_done : �ɻ翩��
-- �ɻ� �ǿ� ���� ���� �ɻ������� ���̷��� ���� �ٸ� ������� �̰� ��Ű�� ���ؼ��� �μ���, �μ�, �ɻ��� ����� �ٲ���� �Ѵ�. 
-- ���� �׽�Ʈ �غ��� ����. �������� ���貲 ����� ����. 
select top 10000 * from LCS_ITHINK_DBF.dbo.INOC_EVALUATE_JUDGE_TBL 
where 1=1
	--AND evaluate_deptnm = '�ȼ�������' 
	--AND document_key = 'I20150500164'
	AND evaluate_proctype ='3'
	AND evaluate_done = 'N'




