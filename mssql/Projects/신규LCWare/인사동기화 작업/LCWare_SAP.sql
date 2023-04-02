
/**********************************************
****************** LCWare SAP 원본  *******************
***********************************************/
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
--LCWare 사용자 중 SAP을 사용하는 사용자(부서정보가 없는 사용자는 조회되지 않음)
SELECT
			RTRIM(U.EmpID) AS EmpID, U.UserName, RTRIM(U.Phone) AS Phone, RTRIM(U.[Address]) AS [Address],
			RTRIM(U.HandPhone) AS HandPhone, RTRIM(U.BirthDay) AS BirthDay, RTRIM(U.LunarYN) AS LunarYN, RTRIM(U.Jo) Jo, CASE WHEN U.SEX = '남자' then 'M' else 'F' end as SEX,
			RTRIM(U.PS) AS PS, RTRIM(U.EntDate) AS EntDate, U.EnableYN, RTRIM(O.DeptCd) AS DeptCd, RTRIM(D.DEPTNAME) AS DEPTNAME,
			RTRIM(O.JikGeupID) AS JikGeupID, RTRIM(O.JikMuID) AS JikMuID, RTRIM(O.JikChaekID) AS JikChaekID, U.GuBun,
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
			E.FullName
FROM		[ERPSQL1].[LeAcc].[dbo].[vwIMUSer] as  U
INNER JOIN	[ERPSQL1].[LeAcc].[dbo].[vwIMUserDept] as O
ON			U.[EmpID] = O.[EmpID]
INNER JOIN	[ERPSQL1].[LeAcc].[dbo].[vwEKWDept] as D
ON			O.DeptCD = D.DeptCD
INNER JOIN	[im80].[dbo].[tsd_emp] T
ON			U.EmpID = T.EMP_ID
LEFT OUTER JOIN recursive_query  E  -- 사용자의 부서 풀네임을 가져오기위해서 추가 부분
ON			O.DeptCD = E.DeptCD
WHERE		U.GuBun = 'L'
AND			O.[PositionOrder] = 1
AND			T.COMP_CD = '1000'




/**********************************************
****************** LCWare SAP 수정  *******************
***********************************************/



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
--LCWare 사용자 중 SAP을 사용하는 사용자(부서정보가 없는 사용자는 조회되지 않음)
SELECT
			RTRIM(U.EmpID) AS EmpID, U.UserName, RTRIM(U.Phone) AS Phone, RTRIM(U.[Address]) AS [Address],
			RTRIM(U.HandPhone) AS HandPhone, RTRIM(U.BirthDay) AS BirthDay, RTRIM(U.LunarYN) AS LunarYN, RTRIM(U.Jo) Jo, CASE WHEN U.SEX = '남자' then 'M' else 'F' end as SEX,
			RTRIM(U.PS) AS PS, RTRIM(U.EntDate) AS EntDate, U.EnableYN, RTRIM(O.DeptCd) AS DeptCd, RTRIM(D.DEPTNAME) AS DEPTNAME,
			RTRIM(O.JikGeupID) AS JikGeupID, RTRIM(O.JikMuID) AS JikMuID, RTRIM(O.JikChaekID) AS JikChaekID, U.GuBun,
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
			E.FullName
FROM		[HRSQLSERVER].[HRDB].[dbo].[vwIMUSer] as  U
INNER JOIN	[HRSQLSERVER].[HRDB].[dbo].[vwIMUserDept] as O
ON			U.[EmpID] = O.[EmpID]
INNER JOIN	[HRSQLSERVER].[HRDB].[dbo].[vwEKWDept] as D
ON			O.DeptCD = D.DeptCD
INNER JOIN	[im80].[dbo].[tsd_emp] T
ON			U.EmpID = T.EMP_ID
LEFT OUTER JOIN recursive_query  E  -- 사용자의 부서 풀네임을 가져오기위해서 추가 부분
ON			O.DeptCD = E.DeptCD
WHERE		U.GuBun = 'L'
AND			O.[PositionOrder] = 1
AND			T.COMP_CD = '1000'