/**********************************************
****************** LCWare Only ����  *******************
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
--LCWare ����� �� SAP�� ������� �ʴ� �����
SELECT
			RTRIM(U.EmpID) AS EmpID, U.UserName, RTRIM(U.Phone) AS Phone, RTRIM(U.[Address]) AS [Address],
			RTRIM(U.HandPhone) AS HandPhone, RTRIM(U.BirthDay) AS BirthDay, U.LunarYN, U.Jo, CASE WHEN U.SEX = '����' then 'M' else 'F' end as SEX,
			RTRIM(U.PS) AS PS, RTRIM(U.EntDate) AS EntDate, U.EnableYN, O.DeptCd, D.DEPTNAME,
			RTRIM(O.JikGeupID) AS JikGeupID, RTRIM(O.JikMuID) AS JikMuID, RTRIM(O.JikChaekID) AS JikChaekID, U.GuBun,
			'N' AS SAP_YN, --SAP ���̺�� ������ ��� ������ ��������� ������ �� �ֵ��� ǥ��
			CASE WHEN LEN(RTRIM(U.EmpID)) > 5 THEN 'Y' ELSE 'N' END EMP_YN, --������ ����.����� 5�ڸ� �̻��� ��� ������
			E.FullName
FROM		[ERPSQL1].[LeAcc].[dbo].[vwIMUSer] as  U
INNER JOIN	[ERPSQL1].[LeAcc].[dbo].[vwIMUserDept] as O
ON			U.[EmpID] = O.[EmpID]
INNER JOIN	[ERPSQL1].[LeAcc].[dbo].[vwEKWDept] as D
ON			O.DeptCD = D.DeptCD
LEFT OUTER JOIN recursive_query  E  -- ������� �μ� Ǯ������ �����������ؼ� �߰� �κ�
ON			O.DeptCD = E.DeptCD
WHERE		U.GuBun = 'L'
AND			O.[PositionOrder] = 1
AND			U.EmpID NOT IN (SELECT EMP_ID FROM [im80].[dbo].[tsd_emp] WHERE COMP_CD = '1000')








/**********************************************
****************** LCWare Only ����  *******************
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
--LCWare ����� �� SAP�� ������� �ʴ� �����
SELECT
			RTRIM(U.EmpID) AS EmpID, U.UserName, RTRIM(U.Phone) AS Phone, RTRIM(U.[Address]) AS [Address],
			RTRIM(U.HandPhone) AS HandPhone, RTRIM(U.BirthDay) AS BirthDay, U.LunarYN, U.Jo, CASE WHEN U.SEX = '����' then 'M' else 'F' end as SEX,
			RTRIM(U.PS) AS PS, RTRIM(U.EntDate) AS EntDate, U.EnableYN, O.DeptCd, D.DEPTNAME,
			RTRIM(O.JikGeupID) AS JikGeupID, RTRIM(O.JikMuID) AS JikMuID, RTRIM(O.JikChaekID) AS JikChaekID, U.GuBun,
			'N' AS SAP_YN, --SAP ���̺�� ������ ��� ������ ��������� ������ �� �ֵ��� ǥ��
			CASE WHEN LEN(RTRIM(U.EmpID)) > 5 THEN 'Y' ELSE 'N' END EMP_YN, --������ ����.����� 5�ڸ� �̻��� ��� ������
			E.FullName
FROM		[HRSQLSERVER].[HRDB].[dbo].[vwIMUSer] as  U
INNER JOIN	[HRSQLSERVER].[HRDB].[dbo].[vwIMUserDept] as O
ON			U.[EmpID] = O.[EmpID]
INNER JOIN	[HRSQLSERVER].[HRDB].[dbo].[vwEKWDept] as D
ON			O.DeptCD = D.DeptCD
LEFT OUTER JOIN recursive_query  E  -- ������� �μ� Ǯ������ �����������ؼ� �߰� �κ�
ON			O.DeptCD = E.DeptCD
WHERE		U.GuBun = 'L'
AND			O.[PositionOrder] = 1
AND			U.EmpID NOT IN (SELECT EMP_ID FROM [im80].[dbo].[tsd_emp] WHERE COMP_CD = '1000')