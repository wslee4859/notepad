-- ERP Only
WITH recursive_query(DeptCD,ParentCD,Name,FullName) AS (
  SELECT 
         deptcd
       , parentdeptcd
       , deptname
       , convert(varchar(255), deptname) fullname
    FROM [ERPSQL1].[LeAcc].[dbo].[vwEKWDept]
    WHERE parentdeptcd is  null
    UNION ALL
    SELECT
         b.deptcd
       , b.parentdeptcd
       , b.deptname
        , convert(varchar(255), convert(nvarchar,c.fullname) + ' > ' +  convert(varchar(255), b.deptname)) fullname
    FROM  [ERPSQL1].[LeAcc].[dbo].[vwEKWDept] b, recursive_query c
    WHERE b.parentdeptcd = c.deptcd
) 
--ERP 사용자 중 SAP을 사용하지 않는 사용자
SELECT
			RTRIM(U.UserID) AS UserID, CASE WHEN LEN(RTRIM(U.EmpID)) = 0 THEN RTRIM(UserID) ELSE RTRIM(U.EmpID) END AS EmpID, 
			ISNULL(U.UserName, RTRIM(U.UserID)) AS UserName, RTRIM(U.Phone) AS Phone, RTRIM(U.[Address]) AS [Address],
			RTRIM(U.HandPhone) AS HandPhone, RTRIM(U.BirthDay) AS BirthDay, RTRIM(U.LunarYN) AS LunarYN, RTRIM(U.Jo) AS Jo, 
			CASE WHEN U.SEX = '남자' then 'M' else 'F' end as SEX,
			RTRIM(U.PS) AS PS, RTRIM(U.EntDate) AS EntDate, U.EnableYN, U.GuBun,
			'N' AS SAP_YN, --SAP 테이블과 조인한 경우 통합웹 사용자임을 구분할 수 있도록 표시
			CASE WHEN LEN(RTRIM(U.EmpID)) > 5 THEN 'Y' ELSE 'N' END EMP_YN, --임직원 여부.사번이 5자리 이상인 경우 임직원
			ISNULL((SELECT DeptName FROM [ERPSQL1].[LeAcc].[dbo].[vwEKWDept] WHERE DeptCD = D.DeptCD), '기타사용자') AS DeptName,
			RTRIM(ISNULL((SELECT DeptCD FROM [ERPSQL1].[LeAcc].[dbo].[vwEKWDept] WHERE DeptCD = D.DeptCD), 'ETC')) AS DeptCD,
			E.FullName
FROM		[ERPSQL1].[LeAcc].[dbo].[vwIMUSer] as  U
LEFT OUTER JOIN [ERPSQL1].[LeAcc].[dbo].[vwIMUserDept] D
ON			U.EmpID = D.EmpID
AND			D.Gubun = 'E'
LEFT OUTER JOIN recursive_query  E  -- 사용자의 부서 풀네임을 가져오기위해서 추가 부분
ON			D.DeptCD = E.DeptCD
WHERE		U.GuBun = 'E'
AND			U.EmpID NOT IN (SELECT EMP_ID FROM [im80].[dbo].[tsd_emp] WHERE COMP_CD = '1000')
AND			RTRIM(U.UserID) NOT IN (SELECT GW_ID FROM [im80].[dbo].[tsd_emp] WHERE COMP_CD = '1000')

