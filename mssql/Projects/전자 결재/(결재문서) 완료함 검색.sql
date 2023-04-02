
--완료함 검색. userID, UserDeptid 필요
use eWFFORM
declare @p8 int
set @p8=12
exec dbo.UP_LIST_VW_WORKLIST_DOCUMENTLIST @strUserId='142911',@strUserDeptId='2987',@strDFType='CO',@nCurPage=1,@nRowPerPage=14,@strSortColumn='0',@strSortOrder='ASC',@iTotalCount=@p8 output
select @p8


