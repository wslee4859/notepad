USE eManage
/*SELECT * FROM dbo.TB_DEPT_USER_HISTORY
SELECT * FROM dbo.TB_DEPT
SELECT * FROM dbo.TB_CODE_SUB
dbo.TB_USER
SELECT * FROM dbo.TB_LOGON_LOG*/

SELECT D.DeptName AS [부서], U.UserName , U.UserAccount, JikG.CodeName, 
		JikC.CodeName, JikW.CodeName, U.EmpID, 
		COUNT(LOGON.LogTime) AS [최근 3개월 로그인 횟수]
FROM dbo.TB_DEPT_USER_HISTORY AS DUH
	INNER JOIN dbo.TB_DEPT AS D
		ON DUH.DeptID = D.DeptID
	INNER JOIN dbo.TB_USER AS U
		ON DUH.UserID =U.UserID AND U.EnableYN = 'Y'AND U.HRSyncYn = 'Y' 
								AND U.MailAddress like '%@lottechilsung.co.kr' 	AND U.DeleteDate > getDate()
	left JOIN dbo.TB_CODE_SUB AS JikG
		ON DUH.JikGeupID = JikG.SubCode AND JikG.ClassCode = '10JG'
	left JOIN dbo.TB_CODE_SUB AS JikC
		ON DUH.JikChaekID = JikC.SubCode AND JikC.ClassCode = '10JC'
	left JOIN dbo.TB_CODE_SUB AS JikW
		ON DUH.JikWiID = JikW.SubCode AND JikW.ClassCode = '10JW'
	left JOIN dbo.TB_LOGON_LOG AS LOGON
		ON U.UserID = LOGON.UserID AND LOGON.LogTime > '2015'
WHERE DUH.EndDate > getDate()
	 AND u.username = '최윤희'
GROUP BY D.DeptName, U.UserName, U.UserAccount, JikG.CodeName, JikC.CodeName, JikW.CodeName, U.EmpID, D.Sortkey
ORDER BY D.Sortkey

-- GROUP BY 에 LogTime을 빼주니까 실행됨

-- 3개월 로그인 횟수   2629명             2853명 

