
/*********************************
* 2018년 그룹 감사 대응 자료 
**********************************/

-- 주류 기안서 
select 
  F.DOC_NAME  AS '양식명'
,  PI.NAME
, F.ADD_FST_NUM + ' 제' + F.ADD_SCD_NUM + '-' + F.ADD_TRD_NUM +'호' AS [문서번호] 
, replace(replace(replace(replace(PI.SUBJECT , char(13),''),char(10),''),'“','"'),'”','"') AS 제목
, F.CREATOR AS 기안자
--, O1.name AS 상위부서
--, F.CREATOR_DEPT AS 부서
--, CASE PI.STATE WHEN '1' THEN '진행중' WHEN '7' THEN '완료' WHEN '8' THEN '반려' WHEN '9' THEN '회수' END AS '결재상태'
--, PI.CREATE_DATE		AS 상신일
--, PI.COMPLETED_DATE		AS 완료일
--, F.PROCESS_ID 
FROM [WF].[FORM_Y3BEB1A495B79447BB7631074BC8BB189] AS F
	INNER JOIN [WF].[PROCESS_INSTANCE] AS PI
	ON F.PROCESS_ID = PI.OID 
	LEFT JOIN Common.[IM].[VIEW_ORG] AS O
	ON F.CREATOR_DEPT_CODE = O.group_code
	LEFT JOIN Common.[IM].[VIEW_ORG] AS O1
	ON O.parent_code = O1.group_code	
	--WHERE PI.CREATE_DATE > '2015-11-15' AND PI.CREATE_DATE < '2015-11-30'     -- 10월까지 
ORDER BY PI.CREATE_DATE 

rollback

begin tran
update [WF].[PROCESS_INSTANCE] 
set SUBJECT = replace(subject,'“','"')
where subject like '%“%'

--commit

select * from [WF].[PROCESS_INSTANCE]  where subject like '%“%'
