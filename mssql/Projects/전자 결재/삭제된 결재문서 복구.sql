use eWFFORM

-- ��������
select * from eManage.dbo.tb_user where userName = '��â��' AND DeleteDate > getdate()

--����� ���� �˻� UserID, UserCD, UserName, UserAccount
select  U.UserID, U.UserCD, U.UserName, U.UserAccount, D.DeptName, D.DeptCd, D.DeptID from eManage.dbo.TB_USER AS U
	INNER JOIN eManage.[dbo].[TB_DEPT_USER_HISTORY] AS DUH
	ON DUH.UserID = U.UserID AND EndDate > getdate()
    INNER JOIN eManage.dbo.TB_DEPT AS D
	ON DUH.DeptID = D.DeptID
WHERE U.UserName='��â��' AND U.DELETEDATE > getdate()


--user ID�� ���� ������ ��� Ȯ��
-- DELETE_DATE �� NULL�ΰ��� �����ȵȰ�. ��¥�� ������ ������ ����. 
select * from [eWF].[dbo].[WORK_ITEM] 
where PARTICIPANT_ID ='112079'     --userID
	--AND completed_date > '201202'
	AND PROCESS_INSTANCE_OID = 'ZD179DD9A175941FF906E4F7C46BB02AA'

-- select * from [eWF].[dbo].[WORK_ITEM] where PARTICIPANT_ID ='142911' AND DELETE_DATE is not null


-- DELETE DATE �� NULL �� �ٲ��ָ� ������ ������.
select @@trancount
begin tran
update [eWF].[dbo].[WORK_ITEM]
set DELETE_DATE = NULL
where PARTICIPANT_ID ='142911'
	AND DELETE_DATE is not null

--commit
--rollback


