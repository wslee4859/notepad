
-- ���� ID , ���� �μ�ID �� ������ ������ ��ȸ

declare @p8 int
set @p8 =4
exec dbo.UP_LIST_VW_WORKLIST_DOCUMENTLIST @strUserId='111354', @strUserDeptId = '3388', @strDFType='AP', 
	@nCurPage=1, @nRowPerPage=20, @strSortColumn='0',@strSortOrder='ASC',@iTotalCount=@p8
output
select @p8