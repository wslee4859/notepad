


-- 유저 정보 검색 
select U.UserName, U.UserID, DUH.DeptID from eManage.dbo.TB_USER AS U 
	left join eManage.[dbo].[TB_DEPT_USER_HISTORY] AS DUH 
	ON U.UserID = DUH.UserID AND EndDate > getdate()
	left join eManage.dbo.TB_DEPT AS D
	ON DUH.DeptID = D.DeptID
WHERE U.UserName = '이완상' 
	AND EnableYN = 'Y'
	AND HRSyncYN = 'Y'





-- 결재함 : @strDFType = 'AP'
-- 완료함 : @strDFType = 'CO'
-- 진행함 : 'PR'
-- UserID , UserDeptId 삽입 
-- @nRowPerPage : 반환할 레코드 수 
use eWFFORM
declare @p8 int
set @p8=0
exec dbo.UP_LIST_VW_WORKLIST_DOCUMENTLIST 
@strUserId='142911',@strUserDeptId='2987',@strDFType='PR',@nCurPage=1,@nRowPerPage='100',@strSortColumn='0',@strSortOrder='ASC',@iTotalCount=@p8 
output
select @p8



ZED002392DE5F47EC9714BF41DE8A9BA5
설 치-V/C-티바 서초점