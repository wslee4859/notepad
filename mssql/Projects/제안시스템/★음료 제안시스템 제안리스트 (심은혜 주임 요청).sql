select
  DM.document_key AS 제안번호
, DM.document_writerno AS 제안자사번
, document_deptnm AS 제안자부서
, U.user_nm AS 제안자명
, U.user_workerlevelnm AS "제안자 직책"
, DM.document_subject AS 제안명
, DM.document_gradenm  AS 심사등급
, DM.document_evaluatedate AS 최종심사일
, DM.document_writedate AS 제안등록일
, C.categorynm_step1 AS "1차분류"
, C.categorynm_step2 AS "2차분류"
, C.categorynm_step3 AS "3차분류"
, CASE DM.document_sync WHEN '1' THEN '실시전' WHEN '2' THEN '실시후' END AS 실시구분
, DM.document_proctype AS 제안차수
, CASE DM.document_evaluatestep WHEN 'E' THEN '완료'  WHEN 'P' THEN '진행' WHEN 'R' THEN '대기' END AS "진행순서"
, DM.document_point AS  점수 
,CASE DE.document_effecttype  WHEN 'M' THEN '무형' WHEN 'U' THEN '유형'  END AS '효과방법'
, replace(DE.document_effect,char(13)+char(10),'') AS  기대효과
, DE.document_effectamt AS 유형효과금액
, E.evaluate_userno AS 평가자
from [dbo].[INOC_DOCUMENT_MASTER_TBL] AS DM
left join [dbo].[INOC_DOCUMENT_EFFECT_TBL] AS DE
ON DM.document_key = DE.document_key
left join [dbo].[INOC_USER_TBL] AS U
ON DM.document_writerno = U.user_no
left join [dbo].[INOC_CATEGORYSTEP_TBL]  AS C
ON DM.document_categorycd = C.category_code
left join [dbo].[INOC_EVALUATE_JUDGE_TBL] AS E
ON DM.document_key = E.document_key AND evaluate_done = 'N'

where document_writedate > '2017-01-01' AND document_writedate < '2017-03-31'
AND DM.document_subject like'%작업복%'
order by document_writedate


--[dbo].[INOC_DOCUMENT_EFFECT_TBL]


--[dbo].[INOC_DOCUMENT_DETAIL_TBL]

--
--[dbo].[INOC_DOCUMENT_MASTER_TBL]  where document_key = 'I20140800001'
 
--[dbo].[INOC_DOCUMENT_CATEGORY_TBL]
--[dbo].[INOC_CATEGORYSTEP_TBL]  
--[dbo].[INOC_USER_TBL]



--left join [dbo].[INOC_DOCUMENT_CATEGORY_TBL] AS DC_1
--ON DM.document_key = DC_1.document_key AND DC_1.document_sort = '1'
--left join [dbo].[INOC_DOCUMENT_CATEGORY_TBL] AS DC_2
--ON DM.document_key = DC_2.document_key AND DC_2.document_sort = '2'
--left join [dbo].[INOC_CATEGORYSTEP_TBL]   AS C1
--ON DC_1.document_categorycd = C1.category_code
--left join [dbo].[INOC_CATEGORYSTEP_TBL]   AS C2
--ON DC_2.document_categorycd = C2.category_code


-- 미평가자 지정
select
  DM.document_key AS 제안번호
, DM.document_writerno AS 제안자사번
, document_deptnm AS 제안자부서
, U.user_nm AS 제안자명
, U.user_workerlevelnm AS "제안자 직책"
, DM.document_subject AS 제안명
, DM.document_gradenm  AS 심사등급
, DM.document_evaluatedate AS 최종심사일
, DM.document_writedate AS 제안등록일
, C.categorynm_step1 AS "1차분류"
, C.categorynm_step2 AS "2차분류"
, C.categorynm_step3 AS "3차분류"
, CASE DM.document_sync WHEN '1' THEN '실시전' WHEN '2' THEN '실시후' END AS 실시구분
, DM.document_proctype AS 제안차수
, CASE DM.document_evaluatestep WHEN 'E' THEN '완료'  WHEN 'P' THEN '진행' WHEN 'R' THEN '대기' END AS "진행순서"
, DM.document_point AS  점수 
,CASE DE.document_effecttype  WHEN 'M' THEN '무형' WHEN 'U' THEN '유형'  END AS '효과방법'
, replace(DE.document_effect,char(13)+char(10),'') AS  기대효과
, DE.document_effectamt AS 유형효과금액
, E.evaluate_userno AS 평가자사번
, US.user_nm  AS 평가자
from [dbo].[INOC_DOCUMENT_MASTER_TBL] AS DM
left join [dbo].[INOC_DOCUMENT_EFFECT_TBL] AS DE
ON DM.document_key = DE.document_key
left join [dbo].[INOC_USER_TBL] AS U
ON DM.document_writerno = U.user_no
left join [dbo].[INOC_CATEGORYSTEP_TBL]  AS C
ON DM.document_categorycd = C.category_code
left join [dbo].[INOC_EVALUATE_JUDGE_TBL] AS E
ON DM.document_key = E.document_key AND evaluate_done = 'N'
LEFT JOIN [dbo].[INOC_USER_TBL] AS US
ON E.evaluate_userno = US.user_no
where document_writedate > '2017-01-01' AND document_writedate < '2017-03-31'
AND DM.document_subject like'%작업복%'
order by document_writedate

