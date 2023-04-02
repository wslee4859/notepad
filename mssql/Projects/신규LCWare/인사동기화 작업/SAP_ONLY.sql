/**********************************************
****************** SAP Only    *****************
***********************************************/

--SAP 만 사용하는 사용자?
SELECT
			EMP_ID, EMP_NM,
			COMP_CD, DEPT_CD, JP_CD, EXTR_YN, COMP_NM, 
			GW_ID, SAP_ID, SAP_NM, DEPT_NM, JP_NM, 
			DJP_CD, DJP_NM, EMP_GU_CD, EMP_GU_NM, EXTR_COMP_CD,
			EXTR_COMP_NM, BRANCH_SCD, BRANCH_SNM, DEPT_SCD, DEPT_SNM,
			ORG_CD, KOSTL, GSBER, ZZEKO, ZZEKG,
			ZZWRK, ROUTE_NO, LGORT, WERKS, ORG_NM,
			KOSTL_NM, GSBER_NM, ZZEKO_NM, ZZEKG_NM,
			ZZWRK_NM, ROUTE_NM, LGORT_NM, WERKS_NM,
			LIFNR, LIFNR_NM, 'Y' AS SAP_YN, --SAP 테이블과 조인한 경우 통합웹 사용자임을 구분할 수 있도록 표시
			CASE WHEN LEN(RTRIM(EMP_ID)) > 5 THEN 'Y' ELSE 'N' END EMP_YN, --임직원 여부.사번이 5자리 이상인 경우 임직원
			ISNULL((SELECT DeptCD FROM [ERPSQL1].[LeAcc].[dbo].[vwEKWDept] WHERE DeptCD = T.DEPT_CD), 'ETC') AS DeptCode,
			ISNULL((SELECT DeptName FROM [ERPSQL1].[LeAcc].[dbo].[vwEKWDept] WHERE DeptCD = T.DEPT_CD), '기타') AS DeptName
FROM	[im80].[dbo].[tsd_emp] T WHERE COMP_CD = '1000' AND RTRIM(EMP_ID) NOT IN (SELECT RTRIM(EmpID) FROM [ERPSQL1].[LeAcc].[dbo].[vwIMUSer])
AND 1 = 2 --당분간 SAP Only 사용자는 조회되지 않도록 처리



/**********************************************
****************** SAP Only    *****************
***********************************************/
--SAP 만 사용하는 사용자?
SELECT
			EMP_ID, EMP_NM,
			COMP_CD, DEPT_CD, JP_CD, EXTR_YN, COMP_NM, 
			GW_ID, SAP_ID, SAP_NM, DEPT_NM, JP_NM, 
			DJP_CD, DJP_NM, EMP_GU_CD, EMP_GU_NM, EXTR_COMP_CD,
			EXTR_COMP_NM, BRANCH_SCD, BRANCH_SNM, DEPT_SCD, DEPT_SNM,
			ORG_CD, KOSTL, GSBER, ZZEKO, ZZEKG,
			ZZWRK, ROUTE_NO, LGORT, WERKS, ORG_NM,
			KOSTL_NM, GSBER_NM, ZZEKO_NM, ZZEKG_NM,
			ZZWRK_NM, ROUTE_NM, LGORT_NM, WERKS_NM,
			LIFNR, LIFNR_NM, 'Y' AS SAP_YN, --SAP 테이블과 조인한 경우 통합웹 사용자임을 구분할 수 있도록 표시
			CASE WHEN LEN(RTRIM(EMP_ID)) > 5 THEN 'Y' ELSE 'N' END EMP_YN, --임직원 여부.사번이 5자리 이상인 경우 임직원
			ISNULL((SELECT DeptCD FROM [HRSQLSERVER].[HRDB].[dbo].[vwEKWDept] WHERE DeptCD = T.DEPT_CD), 'ETC') AS DeptCode,
			ISNULL((SELECT DeptName FROM [HRSQLSERVER].[HRDB].[dbo].[vwEKWDept] WHERE DeptCD = T.DEPT_CD), '기타') AS DeptName
FROM	[im80].[dbo].[tsd_emp] T WHERE COMP_CD = '1000' AND RTRIM(EMP_ID) NOT IN (SELECT RTRIM(EmpID) FROM [HRSQLSERVER].[HRDB].[dbo].[vwIMUSer])
AND 1 = 2 --당분간 SAP Only 사용자는 조회되지 않도록 처리