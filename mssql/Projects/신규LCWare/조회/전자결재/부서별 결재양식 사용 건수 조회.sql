
--select * from [WF].[FOLDER] where DEPTH = '2' AND CLASS_CODE = 'SITE01' ORDER BY CLASS_CODE, SORT_KEY 
--[Common].[IM].[VIEW_ORG] where name = '생산본부'

/***************************************************************** 
* 부서별 전자결재 (완료 건, 사용여부 Y) 양식별 사용건 수 확인 쿼리
*******************************************************************/
WITH LOW_FOLDER AS
	( 
		SELECT 
			A.group_code,
			A.name,
			A.parent_code,
			A.display_yn,
			A.seq  
		FROM [Common].[IM].[VIEW_ORG] AS A		
		WHERE A.group_code in ('5413')    --상위 FOLDER_ID 입력  5395 생산본부


		UNION ALL
		SELECT 
			A.group_code,
			A.name,
			A.parent_code,
			A.display_yn,
			A.seq
		FROM [Common].[IM].[VIEW_ORG] AS A 
		INNER JOIN LOW_FOLDER B 
		ON A.parent_code = B.group_code
	)

-- select * from LOW_FOLDER order by seq



select M.CREATOR_DEPT, M.name, count(M.NAME)
from [WF].[PROCESS_INSTANCE] AS M
left join [WF].[WF_FORMS] AS F
on M.FORM_ID = F.FORM_ID
where CREATOR_DEPT in (select name from LOW_FOLDER ) 
AND M.STATE = '7'
AND F.CURRENT_FORMS = 'Y'
group by M.CREATOR_DEPT, M.name
ORDER BY M.CREATOR_DEPT, M.name

--[WF].[WF_FORMS]

-- [WF].[WF_FORMS] where form_name = '대리점지점주문요청서'
