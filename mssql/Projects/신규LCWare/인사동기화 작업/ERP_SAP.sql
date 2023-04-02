/**********************
-- -- ERP SAP 원본 ***
**********************/


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
--ERP 사용자 중 SAP을 사용하는 사용자(사원번호로 조인 가능)
SELECT
			RTRIM(U.UserID) AS UserID, RTRIM(U.EmpID) AS EmpID, U.UserName, RTRIM(U.Phone) AS Phone, RTRIM(U.[Address]) AS [Address],
			RTRIM(U.HandPhone) AS HandPhone, RTRIM(U.BirthDay) AS BirthDay, RTRIM(U.LunarYN) AS LunarYN, RTRIM(U.Jo) AS Jo, CASE WHEN U.SEX = '남자' then 'M' else 'F' end as SEX,
			RTRIM(U.PS) AS PS, RTRIM(U.EntDate) AS EntDate, U.EnableYN, U.GuBun,
			T.COMP_CD, T.DEPT_CD, T.JP_CD, T.EXTR_YN, T.COMP_NM, 
			T.GW_ID, T.SAP_ID, T.SAP_NM, T.DEPT_NM, T.JP_NM, 
			T.DJP_CD, T.DJP_NM, T.EMP_GU_CD, T.EMP_GU_NM, T.EXTR_COMP_CD,
			T.EXTR_COMP_NM, T.BRANCH_SCD, T.BRANCH_SNM, T.DEPT_SCD, T.DEPT_SNM,
			T.ORG_CD, T.KOSTL, T.GSBER, T.ZZEKO, T.ZZEKG,
			T.ZZWRK, T.ROUTE_NO, T.LGORT, T.WERKS, T.ORG_NM,
			T.KOSTL_NM, T.GSBER_NM, T.ZZEKO_NM, T.ZZEKG_NM,
			T.ZZWRK_NM, T.ROUTE_NM, T.LGORT_NM, T.WERKS_NM,
			T.LIFNR, T.LIFNR_NM, 'Y' AS SAP_YN, --SAP 테이블과 조인한 경우 통합웹 사용자임을 구분할 수 있도록 표시
			CASE WHEN LEN(RTRIM(U.EmpID)) > 5 THEN 'Y' ELSE 'N' END EMP_YN, --임직원 여부.사번이 5자리 이상인 경우 임직원
			RTRIM(ISNULL((SELECT DeptName FROM [ERPSQL1].[LeAcc].[dbo].[vwEKWDept] WHERE DeptCD = D.DeptCD), '기타사용자')) AS DeptName,
			RTRIM(ISNULL((SELECT DeptCD FROM [ERPSQL1].[LeAcc].[dbo].[vwEKWDept] WHERE DeptCD = D.DeptCD), 'ETC')) AS DeptCode,
			E.FullName
FROM		[ERPSQL1].[LeAcc].[dbo].[vwIMUSer] as  U
INNER JOIN	[im80].[dbo].[tsd_emp] T
ON			U.EmpID = T.EMP_ID
LEFT OUTER JOIN [ERPSQL1].[LeAcc].[dbo].[vwIMUserDept] D
ON			U.EmpID = D.EmpID
LEFT OUTER JOIN recursive_query  E  -- 사용자의 부서 풀네임을 가져오기위해서 추가 부분
ON			D.DeptCD = E.DeptCD
WHERE		U.GuBun = 'E'
AND			T.COMP_CD = '1000'
AND			LEN(RTRIM(U.EmpID)) > 0
UNION ALL
--ERP 사용자 중 SAP을 사용하는 사용자(사원번호로 조인이 안되므로 gw_id로 조인)
SELECT
			RTRIM(U.UserID) AS UserID, CASE WHEN LEN(RTRIM(U.EmpID)) = 0 THEN RTRIM(UserID) ELSE RTRIM(U.EmpID) END AS EmpID, 
			ISNULL(U.UserName, RTRIM(U.UserID)) AS UserName, RTRIM(U.Phone) AS Phone, RTRIM(U.[Address]) AS [Address],
			RTRIM(U.HandPhone) AS HandPhone, RTRIM(U.BirthDay) AS BirthDay, RTRIM(U.LunarYN) AS LunarYN, RTRIM(U.Jo) AS Jo, CASE WHEN U.SEX = '남자' then 'M' else 'F' end as SEX,
			RTRIM(U.PS) AS PS, RTRIM(U.EntDate) AS EntDate, U.EnableYN, U.GuBun,
			T.COMP_CD, T.DEPT_CD, T.JP_CD, T.EXTR_YN, T.COMP_NM, 
			T.GW_ID, T.SAP_ID, T.SAP_NM, T.DEPT_NM, T.JP_NM, 
			T.DJP_CD, T.DJP_NM, T.EMP_GU_CD, T.EMP_GU_NM, T.EXTR_COMP_CD,
			T.EXTR_COMP_NM, T.BRANCH_SCD, T.BRANCH_SNM, T.DEPT_SCD, T.DEPT_SNM,
			T.ORG_CD, T.KOSTL, T.GSBER, T.ZZEKO, T.ZZEKG,
			T.ZZWRK, T.ROUTE_NO, T.LGORT, T.WERKS, T.ORG_NM,
			T.KOSTL_NM, T.GSBER_NM, T.ZZEKO_NM, T.ZZEKG_NM,
			T.ZZWRK_NM, T.ROUTE_NM, T.LGORT_NM, T.WERKS_NM,
			T.LIFNR, T.LIFNR_NM, 'Y' AS SAP_YN, --SAP 테이블과 조인한 경우 통합웹 사용자임을 구분할 수 있도록 표시
			CASE WHEN LEN(RTRIM(U.EmpID)) > 5 THEN 'Y' ELSE 'N' END EMP_YN, --임직원 여부.사번이 5자리 이상인 경우 임직원
			RTRIM(ISNULL((SELECT DeptName FROM [ERPSQL1].[LeAcc].[dbo].[vwEKWDept] WHERE DeptCD = D.DeptCD), '기타사용자')) AS DeptName,
			RTRIM(ISNULL((SELECT DeptCD FROM [ERPSQL1].[LeAcc].[dbo].[vwEKWDept] WHERE DeptCD = D.DeptCD), 'ETC')) AS DeptCode,
			E.FullName
FROM		[ERPSQL1].[LeAcc].[dbo].[vwIMUSer] as  U
INNER JOIN	[im80].[dbo].[tsd_emp] T
ON			U.UserID = T.GW_ID
LEFT OUTER JOIN [ERPSQL1].[LeAcc].[dbo].[vwIMUserDept] D
ON			U.EmpID = D.EmpID
LEFT OUTER JOIN recursive_query  E  -- 사용자의 부서 풀네임을 가져오기위해서 추가 부분
ON			D.DeptCD = E.DeptCD
WHERE		U.GuBun = 'E'
AND			T.COMP_CD = '1000'
AND			LEN(RTRIM(U.EmpID)) = 0

















WITH recursive_query(DeptCD,ParentCD,Name,FullName) AS (
  SELECT 
         deptcd
       , parentdeptcd
       , deptname
       , convert(varchar(255), deptname) fullname
    FROM [HRSQLSERVER].[HRDB].[dbo].[vwEKWDept]
    WHERE parentdeptcd is  null
    UNION ALL
    SELECT
         b.deptcd
       , b.parentdeptcd
       , b.deptname
        , convert(varchar(255), convert(nvarchar,c.fullname) + ' > ' +  convert(varchar(255), b.deptname)) fullname
    FROM  [HRSQLSERVER].[HRDB].[dbo].[vwEKWDept] b, recursive_query c
    WHERE b.parentdeptcd = c.deptcd
) 
--ERP 사용자 중 SAP을 사용하는 사용자(사원번호로 조인 가능)
SELECT
			RTRIM(U.UserID) AS UserID, RTRIM(U.EmpID) AS EmpID, U.UserName, RTRIM(U.Phone) AS Phone, RTRIM(U.[Address]) AS [Address],
			RTRIM(U.HandPhone) AS HandPhone, RTRIM(U.BirthDay) AS BirthDay, RTRIM(U.LunarYN) AS LunarYN, RTRIM(U.Jo) AS Jo, CASE WHEN U.SEX = '남자' then 'M' else 'F' end as SEX,
			RTRIM(U.PS) AS PS, RTRIM(U.EntDate) AS EntDate, U.EnableYN, U.GuBun,
			T.COMP_CD, T.DEPT_CD, T.JP_CD, T.EXTR_YN, T.COMP_NM, 
			T.GW_ID, T.SAP_ID, T.SAP_NM, T.DEPT_NM, T.JP_NM, 
			T.DJP_CD, T.DJP_NM, T.EMP_GU_CD, T.EMP_GU_NM, T.EXTR_COMP_CD,
			T.EXTR_COMP_NM, T.BRANCH_SCD, T.BRANCH_SNM, T.DEPT_SCD, T.DEPT_SNM,
			T.ORG_CD, T.KOSTL, T.GSBER, T.ZZEKO, T.ZZEKG,
			T.ZZWRK, T.ROUTE_NO, T.LGORT, T.WERKS, T.ORG_NM,
			T.KOSTL_NM, T.GSBER_NM, T.ZZEKO_NM, T.ZZEKG_NM,
			T.ZZWRK_NM, T.ROUTE_NM, T.LGORT_NM, T.WERKS_NM,
			T.LIFNR, T.LIFNR_NM, 'Y' AS SAP_YN, --SAP 테이블과 조인한 경우 통합웹 사용자임을 구분할 수 있도록 표시
			CASE WHEN LEN(RTRIM(U.EmpID)) > 5 THEN 'Y' ELSE 'N' END EMP_YN, --임직원 여부.사번이 5자리 이상인 경우 임직원
			RTRIM(ISNULL((SELECT DeptName FROM [HRSQLSERVER].[HRDB].[dbo].[vwEKWDept] WHERE DeptCD = D.DeptCD), '기타사용자')) AS DeptName,
			RTRIM(ISNULL((SELECT DeptCD FROM [HRSQLSERVER].[HRDB].[dbo].[vwEKWDept] WHERE DeptCD = D.DeptCD), 'ETC')) AS DeptCode,
			E.FullName
FROM		[HRSQLSERVER].[HRDB].[dbo].[vwIMUSer] as  U
INNER JOIN	[im80].[dbo].[tsd_emp] T
ON			U.EmpID = T.EMP_ID
LEFT OUTER JOIN [HRSQLSERVER].[HRDB].[dbo].[vwIMUserDept] D
ON			U.EmpID = D.EmpID
LEFT OUTER JOIN recursive_query  E  -- 사용자의 부서 풀네임을 가져오기위해서 추가 부분
ON			D.DeptCD = E.DeptCD
WHERE		U.GuBun = 'E'
AND			T.COMP_CD = '1000'
AND			LEN(RTRIM(U.EmpID)) > 0
UNION ALL
--ERP 사용자 중 SAP을 사용하는 사용자(사원번호로 조인이 안되므로 gw_id로 조인)
SELECT
			RTRIM(U.UserID) AS UserID, CASE WHEN LEN(RTRIM(U.EmpID)) = 0 THEN RTRIM(UserID) ELSE RTRIM(U.EmpID) END AS EmpID, 
			ISNULL(U.UserName, RTRIM(U.UserID)) AS UserName, RTRIM(U.Phone) AS Phone, RTRIM(U.[Address]) AS [Address],
			RTRIM(U.HandPhone) AS HandPhone, RTRIM(U.BirthDay) AS BirthDay, RTRIM(U.LunarYN) AS LunarYN, RTRIM(U.Jo) AS Jo, CASE WHEN U.SEX = '남자' then 'M' else 'F' end as SEX,
			RTRIM(U.PS) AS PS, RTRIM(U.EntDate) AS EntDate, U.EnableYN, U.GuBun,
			T.COMP_CD, T.DEPT_CD, T.JP_CD, T.EXTR_YN, T.COMP_NM, 
			T.GW_ID, T.SAP_ID, T.SAP_NM, T.DEPT_NM, T.JP_NM, 
			T.DJP_CD, T.DJP_NM, T.EMP_GU_CD, T.EMP_GU_NM, T.EXTR_COMP_CD,
			T.EXTR_COMP_NM, T.BRANCH_SCD, T.BRANCH_SNM, T.DEPT_SCD, T.DEPT_SNM,
			T.ORG_CD, T.KOSTL, T.GSBER, T.ZZEKO, T.ZZEKG,
			T.ZZWRK, T.ROUTE_NO, T.LGORT, T.WERKS, T.ORG_NM,
			T.KOSTL_NM, T.GSBER_NM, T.ZZEKO_NM, T.ZZEKG_NM,
			T.ZZWRK_NM, T.ROUTE_NM, T.LGORT_NM, T.WERKS_NM,
			T.LIFNR, T.LIFNR_NM, 'Y' AS SAP_YN, --SAP 테이블과 조인한 경우 통합웹 사용자임을 구분할 수 있도록 표시
			CASE WHEN LEN(RTRIM(U.EmpID)) > 5 THEN 'Y' ELSE 'N' END EMP_YN, --임직원 여부.사번이 5자리 이상인 경우 임직원
			RTRIM(ISNULL((SELECT DeptName FROM [HRSQLSERVER].[HRDB].[dbo].[vwEKWDept] WHERE DeptCD = D.DeptCD), '기타사용자')) AS DeptName,
			RTRIM(ISNULL((SELECT DeptCD FROM [HRSQLSERVER].[HRDB].[dbo].[vwEKWDept] WHERE DeptCD = D.DeptCD), 'ETC')) AS DeptCode,
			E.FullName
FROM		[HRSQLSERVER].[HRDB].[dbo].[vwIMUSer] as  U
INNER JOIN	[im80].[dbo].[tsd_emp] T
ON			U.UserID = T.GW_ID
LEFT OUTER JOIN [HRSQLSERVER].[HRDB].[dbo].[vwIMUserDept] D
ON			U.EmpID = D.EmpID
LEFT OUTER JOIN recursive_query  E  -- 사용자의 부서 풀네임을 가져오기위해서 추가 부분
ON			D.DeptCD = E.DeptCD
WHERE		U.GuBun = 'E'
AND			T.COMP_CD = '1000'
AND			LEN(RTRIM(U.EmpID)) = 0