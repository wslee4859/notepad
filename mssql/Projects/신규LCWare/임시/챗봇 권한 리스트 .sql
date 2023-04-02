-- 해당 그룹에 포함된 사원 정보 조회 
-- 직무 직책 사번 

use im80
select  og.name
, ou.code, ou.name, ou.login_id 
, JG.name AS [직급]
, JW.name AS [직무]
, JC.name AS [직책]
FROM [dbo].[org_group_user] AS ogu
left join [dbo].[org_user] AS ou
on ogu.user_id = ou.user_id 
left outer join 
	(select a.user_id, b.group_id, b.name, a.org_id, b.ex_sort_key from dbo.org_group_user a inner join dbo.org_group b
	 on a.group_id = b.group_id where b.group_type_id = '11')  as JG
	on ou.user_id = JG.user_id and ou.group_id = JG.org_id
	left outer join 
	(select a.user_id, b.group_id, b.name, a.org_id, b.ex_sort_key from dbo.org_group_user a inner join dbo.org_group b
	 on a.group_id = b.group_id where b.group_type_id = '1')  as JW
	on ou.user_id = JW.user_id and ou.group_id = JW.org_id
	left outer join 
	(select a.user_id, b.group_id, b.name, a.org_id, b.ex_sort_key from dbo.org_group_user a inner join dbo.org_group b
	 on a.group_id = b.group_id where b.group_type_id = '2')  as JC
	on ou.user_id = JC.user_id and ou.group_id = JC.org_id
left join [dbo].[org_group] AS  og
on og.group_id = ou.group_id
where ogu.user_id in (select user_id from [dbo].[org_group_user] where ogu.group_id = '8408' )



select * from 
[IM].[VIEW_USER] AS U
inner join [IM].[VIEW_ORG] AS O
on U.group_code = O.group_code
WHERE U.domain_code = '11'
AND U.group_name in (
'영업전략팀',
'영업전략담당',
'머천다이징담당',
'마켓조사담당',
'채널담당',
'영업지원팀',
'영업지원담당',
'채권담당',
'EDS팀',
'EDS기획담당',
'EDS지원담당',
'판매장비팀',
'장비담당',
'차량담당',
'자판전략담당',
'RTM추진 TF',
'준법경영팀',
'관재담당',
'법무담당',
'내부통제TF',
'생산지원팀',
'생산지원담당',
'생산기획담당',
'품질안전센터',
'품질보증담당',
'EHS담당',
'품질안전담당',
'기술지원팀',
'기술1담당',
'기술2담당',
'기술3담당',
'음료지원팀',
'기업문화팀',
'음료경영전략팀',
'RGM팀',
'음료회계팀',
'자금총괄담당',
'모바일파트',
'개발담당',
'영업물류파트',
'회계인사파트',
'구매생산파트',
'운영담당',
'경영전략1담당',
'경영전략2담당',
'정보전략담당',
'신사업담당',
'RGM담당',
'ZBB실행담당',
'DT추진 TF',
'총무담당',
'음료인사담당',
'교육담당',
'기업문화담당',
'노무담당',
'CSR담당',
'일반회계담당',
'법인회계담당',
'세무회계담당',
'음료자금담당',
'전산팀',
'정보기획파트')
order by O.seq, classpos_seq 





select * from 
[IM].[VIEW_USER] AS U
inner join [IM].[VIEW_ORG] AS O
on U.group_code = O.group_code
WHERE U.domain_code = '11'
AND U.employee_num in (
'20190398',
'20190404',
'20190359',
'20180552',
'20180514',
'20180418',
'20180293',
'20180294',
'20180147',
'20180121',
'20170473' )
order by O.seq, classpos_seq 


;
;
;
;
;
;
;
;
;
;
