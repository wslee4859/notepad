

select * from emanage.dbo.Tb_user where userid='111488' OR userName = '¿Ã∫¥ø¿'
select * from emanage.dbo.TB_DEPT_USER_HISTORY where userid='111488'


use eWFFORM
declare @p8 int
set @p8=4
exec dbo.UP_LIST_VW_WORKLIST_DOCUMENTLIST @strUserId='142612',@strUserDeptId='3388',@strDFType='AP',
@nCurPage=1,@nRowPerPage=20,@strSortColumn='0',@strSortOrder='ASC',@iToTalCount=@p8
output
select @p8