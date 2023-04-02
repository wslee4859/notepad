USE TestDB
DECLARE	@pEmpId char(8)  --변수 사번
		, @pPrint char(4)

/*변수 값 세팅 */
SELECT @pEmpId = '1771044A'  --변경 가능

--SET @pEmpId = '18104228'  --변경 가능
	SET @pPrint = '퇴직'

IF '퇴직' = (SELECT Ws.WsNm FROM WsMaster_이완상 Ws
					INNER JOIN EmpMaster_이완상 EM
						ON Ws.WsCd = EM.WsCd
					WHERE EM.EmpId = @pEmpId)
	BEGIN
		/*사원번호 출력 부분 */
		SELECT @pEmpId AS [사원번호:], @pPrint AS [근무 상태] 
	END

ELSE
	BEGIN
/*사원번호 출력 부분 */
		SELECT @pEmpId AS [사원번호:]
/*급여내역 출력 부분 */
SELECT EM.EmpId, EM.EmpNm AS [사원명], D.DeptNm AS [부서명], Pg.PgNm AS [직급명] , Jp.JpNm AS [직무명], 
		Ws.WsNm AS [근무상태], Pay.PbYm AS [급여월], Pay.PayAmt AS [급여액]
FROM EmpMaster_이완상 EM
INNER JOIN DeptMaster_이완상 D
	ON EM.DeptCd = D.DeptCd
INNER JOIN PgMaster_이완상 Pg
	ON EM.PgCd = Pg.PgCd
INNER JOIN JpMaster_이완상 Jp
	ON EM.JpCd = Jp.JpCd
INNER JOIN WsMaster_이완상 Ws
	ON EM.WsCd = Ws.WsCd
INNER JOIN PayMaster_이완상 Pay
	ON EM.EmpId = Pay.EmpId
WHERE EM.EmpId = @pEmpId
	END