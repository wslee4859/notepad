


-- ���� ���� �˻� 
select U.UserName, U.UserID, DUH.DeptID from eManage.dbo.TB_USER AS U 
	left join eManage.[dbo].[TB_DEPT_USER_HISTORY] AS DUH 
	ON U.UserID = DUH.UserID AND EndDate > getdate()
	left join eManage.dbo.TB_DEPT AS D
	ON DUH.DeptID = D.DeptID
WHERE U.UserName = '�̿ϻ�' 
	AND EnableYN = 'Y'
	AND HRSyncYN = 'Y'





-- ������ : @strDFType = 'AP'
-- �Ϸ��� : @strDFType = 'CO'
-- ������ : 'PR'
-- UserID , UserDeptId ���� 
-- @nRowPerPage : ��ȯ�� ���ڵ� �� 
use eWFFORM
declare @p8 int
set @p8=0
exec dbo.UP_LIST_VW_WORKLIST_DOCUMENTLIST 
@strUserId='142911',@strUserDeptId='2987',@strDFType='PR',@nCurPage=1,@nRowPerPage='100',@strSortColumn='0',@strSortOrder='ASC',@iTotalCount=@p8 
output
select @p8



ZED002392DE5F47EC9714BF41DE8A9BA5
�� ġ-V/C-Ƽ�� ������