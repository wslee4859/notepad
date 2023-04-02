ALTER PROCEDURE SP_TEST04_PRINT
AS
SELECT De.DeptNm AS [부서명/직급명], ISNULL(E4.Amt, 0) AS [이사대우], 
		ISNULL(S1.Amt, 0) AS [S1], 
		ISNULL(S2.Amt, 0) AS [S2], 
		ISNULL(M1.Amt, 0) AS [M1], 
		ISNULL(M2.Amt,0) AS [M2], 
		ISNULL(SA_M.Amt, 0) AS [SA(남)], 
		ISNULL(SA_W.Amt, 0) AS [SA(여)], 
		ISNULL(A_M.Amt, 0) AS [A(남)], 
		ISNULL(T1.Amt, 0) AS [T1], 
		ISNULL(T2.Amt, 0) AS [T2], 
		ISNULL(T3.Amt, 0) AS [T3], 
		ISNULL(T4.Amt, 0) AS [T4]
	FROM DeptNm AS De
		LEFT JOIN E4
			ON De.DeptNm = E4.DeptNm 
		LEFT JOIN S1
			ON De.DeptNm = S1.DeptNm
		LEFT JOIN S2
			ON De.DeptNm = S2.DeptNm
		LEFT JOIN M1
			ON De.DeptNm = M1.DeptNm
		LEFT JOIN M2
			ON De.DeptNm = M2.DeptNm
		LEFT JOIN SA_M
			ON De.DeptNm = SA_M.DeptNm
		LEFT JOIN SA_W
			ON De.DeptNm = SA_W.DeptNm
		LEFT JOIN A_M
			ON De.DeptNm = A_M.DeptNm
		LEFT JOIN T1
			ON De.DeptNm = T1.DeptNm
		LEFT JOIN T2
			ON De.DeptNm = T2.DeptNm
		LEFT JOIN T3
			ON De.DeptNm = T3.DeptNm
		LEFT JOIN T4
			ON De.DeptNm = T4.DeptNm 