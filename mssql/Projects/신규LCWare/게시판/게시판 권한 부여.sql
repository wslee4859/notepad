[BD].[BoardACL] WHERE ResourceID = '498'


/**************************************************
* �Խ��� ���� �μ� ��ȸ*
* MES   2519
* MES(SCADA)   2520 
* S&OP  2521
* SFA  2522
* DATALAKE  2523
***************************************************/

select B.ResourceID, BT.Korean,UnitID, B.UnitName, ORG.name [�ֽ�������] ,B.Permission
from [BD].[BoardACL] AS B
left join [BD].[BoardText] AS BT
ON B.ResourceID = BT.TextID 
left join [Common].[IM].[VIEW_ORG] AS ORG
on B.UnitID = ORG.group_code
---WHERE B.unitName != ORG.name
where BT.korean = 'MES'
 
 
select * from [BD].[BoardText] where Korean = 'MES'


select BT.* , *
from [BD].[BoardInfo] AS I
inner join [BD].[BoardText] AS BT
on I.BoardID = BT.TextID 
WHERE  1=1
AND I.BoardRootID = 'SITE06'


/*****************************
* ���� �߰� 
* 0 : ��ȸ���� 
* 1 : �ۼ� ����
* 3 : �����ڱ���
VALUES ('0', 'ResourceID', UnitID , UnitName, UnitType, Permission )
* select * from COMMON.[IM].[VIEW_ORG] WHERE group_code = '16451'
******************************/

/**************************************************
* �Խ��� ���� �μ� ��ȸ �ڵ� *
* MES   2519
* MES(SCADA)   2520 
* S&OP  2521
* SFA  2522
* DATALAKE  2523
('0', 'ResourceID', UnitID , UnitName, UnitType, Permission )

* UNITTYPE
 OGR : �μ� or DTL
***************************************************/
 
 -- LCWARE �μ�
select * from COMMON.[IM].[VIEW_ORG] WHERE group_code = '16491'

  -- LCWARE ���ѱ׷�
  select * from COMMON.[IM].[VIEW_DTL] where group_code = '16491'

  commit





BEGIN TRAN
INSERT INTO [portal].[BD].[BoardACL] 
VALUES 
('0','2519','16491','������Ʈ_����Ʈ_����','DTL',3),
('0','2520','16491','������Ʈ_����Ʈ_����','DTL',3),
('0','2521','16491','������Ʈ_����Ʈ_����','DTL',3),
('0','2522','16491','������Ʈ_����Ʈ_����','DTL',3),
('0','2523','16491','������Ʈ_����Ʈ_����','DTL',3)


select @@TRANCOUNT