--19501162


--사용자 정보 검색 UserID, UserCD, UserName, UserAccount
select  U.UserID, U.UserCD, U.UserName, U.UserAccount, D.DeptName, D.DeptCd, D.DeptID from eManage.dbo.TB_USER AS U
	INNER JOIN eManage.[dbo].[TB_DEPT_USER_HISTORY] AS DUH
	ON DUH.UserID = U.UserID AND EndDate > getdate()
    INNER JOIN eManage.dbo.TB_DEPT AS D
	ON DUH.DeptID = D.DeptID
WHERE U.UserName='박창훈' AND U.DELETEDATE > getdate()


-- 심시자 관리 테이블 
-- document_key  :  제안 문서 번호
-- evaluate_proctype : 1.접수 , 2.원가, 3.검토, 4.승인
-- evaluate_deptcd : 부서코드 
-- evaluate_deptnm : 부서 
-- evaluate_userno : 심사자 UserCD
-- evaluate_done : 심사여부
-- 심사 건에 대해 아직 심사절차가 안이뤄진 것을 다른 사람으로 이관 시키기 위해서는 부서콛, 부서, 심사자 사번을 바꿔줘야 한다. 
-- 아직 테스트 해보지 않음. 남궁유진 선배께 물어보고 진행. 
select top 10000 * from LCS_ITHINK_DBF.dbo.INOC_EVALUATE_JUDGE_TBL 
where 1=1
	--AND evaluate_deptnm = '안성생산담당' 
	--AND document_key = 'I20150500164'
	AND evaluate_proctype ='3'
	AND evaluate_done = 'N'




