
--SMS 조직도 계정 조회. 

select * from [dbo].[MobileCode] 
where smCode = '20150581'


-- SMS 조직도 ERP_EKW_DTS.dbo.TE_SMSMember_ERPUser에 인설트하는 SP 깐것. 
select DISTINCT
			E.DeptCD	as DeptID,
			Ltrim(Rtrim(E.EmpNm)) as UserName,
			E.EmpID,
			Ltrim(Rtrim(JC.MinorNm)) as JikChaek,
			Case
				When	ISNULL(REPLACE(M.TelNum, '-', ''), '') = ''	Then
					ISNULL(REPLACE(A.HPTel, '-', ''), '')
				Else
					ISNULL(REPLACE(M.TelNum, '-', ''), '')
			End	as PhoneNumber 
from LeAcc.dbo.TDAEmpMaster AS E
			Join	LeAcc.dbo.TDADept D
				On	D.DeptCD = E.DeptCD
			JOIN	LeAcc.dbo.TDAOrgQ Q
				ON	Q.DeptCD = D.DeptCD
				AND	Q.OrgType = '3'
			Join	LeAcc.dbo.TDAMinor JC
				On	JC.MinorCd = E.JPCD
				and	JC.MinorCd like '324%'
			Left Join [erpsql1\inst1].LeSale.dbo.TSBRouteEmp B
				On  B.BranchCD = E.DeptCD
				AND	B.RouteSalesMan = E.EmpID
				AND	CONVERT(CHAR(8), GETDATE(), 112) BETWEEN B.FRDate AND B.TODate
			Left Join	LeSfa.dbo.MobileCode M
				On	M.SMCode = E.EmpID
				and	M.BRCD = E.DeptCD
				and	M.MobileGCD1 = '1000'	-- 핸드폰
				and	M.UseFlag = 'Y'
			Left Join	LeAcc.DBO.THBAddr A
				On	A.EmpID = E.EmpID
			LEFT JOIN	LeAcc.dbo.vwEKWUser U
				ON	U.EmpID = E.EmpID
				AND	U.EnableYN = 'Y'
			where E.empId = '20150581'
				AND E.RetYN = '0'
				AND U.empID IS NULL


	-- 임시데이터 여기서 TB_SMSMember_ERPUser 로 
	select * from ekwsql.ERP_EKW_DTS.dbo.TE_SMSMember_ERPUser where empID = '20150501'

	-- 실제 데이터 
	select * from ekwsql.eGW.[dbo].[TB_SMSMember_ERPUser] where EmpID= '20150581' 

	select * from LeAcc.dbo.vwEKWUser where empID = '20150581'

	select * from LeAcc.DBO.THBAddr where empid = '20150501' 

	20150581
	정호영 20150501
