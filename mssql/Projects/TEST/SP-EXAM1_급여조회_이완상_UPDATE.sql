ALTER PROCEDURE SP_EXAM1_�޿���ȸ_�̿ϻ�
	@pYear char(6),
	@pDeptCd char(5)
AS
IF @pYear = ANY(SELECT YearMM FROM PayMaster_NEW_�̿ϻ� GROUP BY YearMM)
	BEGIN
		IF @pDeptCd = ''
			BEGIN
				SELECT Em.EmpId AS [�����ȣ], 
						Em.EmpNm AS [�����],
						D.DeptNm AS [�μ���],
						Pg.PgNm AS [���޸�],
						Jp.JpNm AS [������],
						Pay.PgAmt AS [�⺻��],
						Pay.JpAmt AS [��������],
						Pay.Tax As [����],
						Pay.RealAmt AS [�Ǽ��ɾ�]
				FROM EmpMaster_�̿ϻ� AS Em
					LEFT JOIN DeptMaster_�̿ϻ� AS D
						ON Em.DeptCd = D.DeptCd
					LEFT JOIN PgMaster_�̿ϻ� AS Pg
						ON Em.PgCd = Pg.PgCd
					LEFT JOIN JpMaster_�̿ϻ� AS Jp
						ON Em.JpCd = Jp.JpCd
					LEFT JOIN PayMaster_NEW_�̿ϻ� AS Pay
						ON Em.EmpId = Pay.EmpId
					WHERE 1=1
						AND Pay.YearMM = @pYear
					ORDER BY Pay.RealAmt DESC
			END
		ELSE IF @pDeptCd = ANY(SELECT Em.DeptCd FROM PayMaster_NEW_�̿ϻ� AS Pay
									INNER JOIN EmpMaster_�̿ϻ� AS Em
									ON  Pay.EmpID = Em.EmpId 
									GROUP BY Em.DeptCd)
			BEGIN
				SELECT Em.EmpId AS [�����ȣ], 
						Em.EmpNm AS [�����],
						D.DeptNm AS [�μ���],
						Pg.PgNm AS [���޸�],
						Jp.JpNm AS [������],
						Pay.PgAmt AS [�⺻��],
						Pay.JpAmt AS [��������],
						Pay.Tax As [����],
						Pay.RealAmt AS [�Ǽ��ɾ�]
				FROM EmpMaster_�̿ϻ� AS Em
					LEFT JOIN DeptMaster_�̿ϻ� AS D
						ON Em.DeptCd = D.DeptCd
					LEFT JOIN PgMaster_�̿ϻ� AS Pg
						ON Em.PgCd = Pg.PgCd
					LEFT JOIN JpMaster_�̿ϻ� AS Jp
						ON Em.JpCd = Jp.JpCd
					LEFT JOIN PayMaster_NEW_�̿ϻ� AS Pay
						ON Em.EmpId = Pay.EmpId
					WHERE 1=1
						AND Em.DeptCd = @pDeptCd
						AND Pay.YearMM = @pYear
					ORDER BY Pay.RealAmt DESC
			END
		ELSE
			BEGIN
				RAISERROR('�������� �ʴ� �μ��ڵ� �Դϴ�!',11,2)
			END
				
	END
ELSE 
	BEGIN
		RAISERROR('��ȸ���� �Է��ϼ��� : (YYYYMM)',11,2)
		RETURN
	END
 

		
		


--	GROUP BY 


		
	