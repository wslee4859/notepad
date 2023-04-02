use eWFFORM

-- 유저정보
select * from eManage.dbo.tb_user where userName = '박창훈' AND DeleteDate > getdate()

--사용자 정보 검색 UserID, UserCD, UserName, UserAccount
select  U.UserID, U.UserCD, U.UserName, U.UserAccount, D.DeptName, D.DeptCd, D.DeptID from eManage.dbo.TB_USER AS U
	INNER JOIN eManage.[dbo].[TB_DEPT_USER_HISTORY] AS DUH
	ON DUH.UserID = U.UserID AND EndDate > getdate()
    INNER JOIN eManage.dbo.TB_DEPT AS D
	ON DUH.DeptID = D.DeptID
WHERE U.UserName='박창훈' AND U.DELETEDATE > getdate()


--user ID로 유저 결재함 모두 확인
-- DELETE_DATE 가 NULL인것은 삭제안된것. 날짜가 있으면 삭제된 문서. 
select * from [eWF].[dbo].[WORK_ITEM] 
where PARTICIPANT_ID ='112079'     --userID
	--AND completed_date > '201202'
	AND PROCESS_INSTANCE_OID = 'ZD179DD9A175941FF906E4F7C46BB02AA'

-- select * from [eWF].[dbo].[WORK_ITEM] where PARTICIPANT_ID ='142911' AND DELETE_DATE is not null


-- DELETE DATE 를 NULL 로 바꿔주면 문서가 복원됨.
select @@trancount
begin tran
update [eWF].[dbo].[WORK_ITEM]
set DELETE_DATE = NULL
where PARTICIPANT_ID ='142911'
	AND DELETE_DATE is not null

--commit
--rollback


