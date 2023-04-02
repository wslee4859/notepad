USE TestDB
DECLARE	@pEmpId char(8)  --���� ���
		, @pPrint char(4)

/*���� �� ���� */
SELECT @pEmpId = '1771044A'  --���� ����

--SET @pEmpId = '18104228'  --���� ����
	SET @pPrint = '����'

IF '����' = (SELECT Ws.WsNm FROM WsMaster_�̿ϻ� Ws
					INNER JOIN EmpMaster_�̿ϻ� EM
						ON Ws.WsCd = EM.WsCd
					WHERE EM.EmpId = @pEmpId)
	BEGIN
		/*�����ȣ ��� �κ� */
		SELECT @pEmpId AS [�����ȣ:], @pPrint AS [�ٹ� ����] 
	END

ELSE
	BEGIN
/*�����ȣ ��� �κ� */
		SELECT @pEmpId AS [�����ȣ:]
/*�޿����� ��� �κ� */
SELECT EM.EmpId, EM.EmpNm AS [�����], D.DeptNm AS [�μ���], Pg.PgNm AS [���޸�] , Jp.JpNm AS [������], 
		Ws.WsNm AS [�ٹ�����], Pay.PbYm AS [�޿���], Pay.PayAmt AS [�޿���]
FROM EmpMaster_�̿ϻ� EM
INNER JOIN DeptMaster_�̿ϻ� D
	ON EM.DeptCd = D.DeptCd
INNER JOIN PgMaster_�̿ϻ� Pg
	ON EM.PgCd = Pg.PgCd
INNER JOIN JpMaster_�̿ϻ� Jp
	ON EM.JpCd = Jp.JpCd
INNER JOIN WsMaster_�̿ϻ� Ws
	ON EM.WsCd = Ws.WsCd
INNER JOIN PayMaster_�̿ϻ� Pay
	ON EM.EmpId = Pay.EmpId
WHERE EM.EmpId = @pEmpId
	END