[BD].[BoardACL] WHERE ResourceID = '498'


/**************************************************
* 게시판 관리 부서 조회*
* MES   2519
* MES(SCADA)   2520 
* S&OP  2521
* SFA  2522
* DATALAKE  2523
***************************************************/

select B.ResourceID, BT.Korean,UnitID, B.UnitName, ORG.name [최신조직도] ,B.Permission
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
* 권한 추가 
* 0 : 조회권한 
* 1 : 작성 권한
* 3 : 관리자권한
VALUES ('0', 'ResourceID', UnitID , UnitName, UnitType, Permission )
* select * from COMMON.[IM].[VIEW_ORG] WHERE group_code = '16451'
******************************/

/**************************************************
* 게시판 관리 부서 조회 코드 *
* MES   2519
* MES(SCADA)   2520 
* S&OP  2521
* SFA  2522
* DATALAKE  2523
('0', 'ResourceID', UnitID , UnitName, UnitType, Permission )

* UNITTYPE
 OGR : 부서 or DTL
***************************************************/
 
 -- LCWARE 부서
select * from COMMON.[IM].[VIEW_ORG] WHERE group_code = '16491'

  -- LCWARE 권한그룹
  select * from COMMON.[IM].[VIEW_DTL] where group_code = '16491'

  commit





BEGIN TRAN
INSERT INTO [portal].[BD].[BoardACL] 
VALUES 
('0','2519','16491','프로젝트_사이트_현업','DTL',3),
('0','2520','16491','프로젝트_사이트_현업','DTL',3),
('0','2521','16491','프로젝트_사이트_현업','DTL',3),
('0','2522','16491','프로젝트_사이트_현업','DTL',3),
('0','2523','16491','프로젝트_사이트_현업','DTL',3)


select @@TRANCOUNT