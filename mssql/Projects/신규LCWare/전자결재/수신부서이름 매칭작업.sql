/*************************************
* 2018-01-06 작성자 이완상
* 전자결재 수신부서 명 다른거 검색
*
**************************************/

-- 조회
select WF.FORM_NAME, FS.FORM_ID, FS.RECEPTION_DEPT, FS.RECEPTION_DEPT_CODE, O.name AS 신규부서이름
from [WF].[WF_FORM_SCHEMA] AS FS
inner join common.[IM].[VIEW_ORG] AS O
ON FS.RECEPTION_DEPT_CODE = O.group_code
inner join [WF].[WF_FORMS] AS WF
ON FS.FORM_ID = WF.FORM_ID
WHERE RCV_USE_YN = 'Y'


-- 틀린 것만 조회 
select WF.FORM_NAME, FS.FORM_ID, FS.RECEPTION_DEPT, FS.RECEPTION_DEPT_CODE, O.name AS 신규부서이름
from [WF].[WF_FORM_SCHEMA] AS FS
inner join common.[IM].[VIEW_ORG] AS O
ON FS.RECEPTION_DEPT_CODE = O.group_code
inner join [WF].[WF_FORMS] AS WF
ON FS.FORM_ID = WF.FORM_ID
WHERE RCV_USE_YN = 'Y' AND FS.RECEPTION_DEPT ! = O.name




select * from [WF].[WF_FORM_SCHEMA] where reception_dept = '판매장비담당'
select reception_dept from [WF].[WF_FORM_SCHEMA] where reception_dept_code = '5540' AND RCV_USE_YN = 'Y'  -- RCV_USE_YN : 수신결재 사용여부


-- 부서 DB 업데이트 
rollback
begin tran
update [WF].[WF_FORM_SCHEMA]
set RECEPTION_DEPT = (select name from common.[IM].[VIEW_ORG] where group_code = '138')
where reception_dept_code = '138'


--commit

-- 예시 게시판 버전 --
update B
set B.unitname = ORG.name
from [BD].[BoardACL] AS B
	inner join [Common].[IM].[VIEW_ORG] AS ORG
	on B.UnitID = ORG.group_code
WHERE B.unitName != ORG.name