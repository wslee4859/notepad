-- 음료 전사원 메일 계정 정보 ver 3
-- 전산팀 및 겸직자포함. 표시를 위해 조직도 테이블 조회
use Common
select 
U.employee_num,
P.user_name,
P.email,
P.mobile,
P.group_name,
P.parent_group_name,
P.position_name
from [IM].[VIEW_PLURAL] AS P
left join IM.VIEW_ORG AS O
on P.group_code = O.group_code
left join [IM].[VIEW_USER] AS U
on P.user_code = U.user_code
where P.domain_name = '롯데음료' 
AND (U.display_yn is null OR U.display_yn = 'Y')
AND (P.display_yn is null OR P.display_yn = 'Y')
AND U.email is not null
AND P.user_name = '이원표'
order by O.seq, P.classpos_seq, P.user_name



-- 겸직자 제외(실제 기획팀전달 2016-12-12 ver )
select
O.seq,
U.domain_name, 
U.parent_group_name,
U.group_name,
U.User_name,
U.responsibility_name,
U.position_name,
U.classpos_name,
U.email,
U.employee_num,
U.display_yn,
CASE WHEN EXISTS (select user_id from [10.103.1.108].im80.[dbo].[org_rule_user] where rule_group_id = '8215' AND user_id = U.user_code) THEN 'Y' 
WHEN EXISTS (select user_id from [10.103.1.108].im80.[dbo].[org_group_user] where group_id = '8215' AND user_id = U.user_code) THEN 'Y' ELSE 'N' END					AS MAIL
from [IM].[VIEW_USER] AS U
left join IM.VIEW_ORG AS O
on U.group_code = O.group_code
WHERE (U.display_yn = 'Y' OR U.display_yn is null)
AND U.domain_name = '롯데음료'
AND U.email is not null
--AND U.user_name = '장학영'
AND U.group_name not like '%신협%'
AND U.group_name not like '%프로젝트%'
AND U.parent_group_name not like '%프로젝트%'
AND (U.classpos_name not in ('전무','상무보A','상무보B','자문','상무','회장','사장','부사장','총괄회장') OR U.classpos_name is NULL) --2018-06-19 권윤희대리 요청
order by O.seq, U.classpos_seq

--음료 신협용(조직도 seq가 꼬여서 신협따로 추출)
select
O.seq,
U.domain_name, 
U.parent_group_name,
U.group_name,
U.User_name,
U.responsibility_name,
U.position_name,
U.classpos_name,
U.email,
U.employee_num,
U.display_yn,
CASE WHEN EXISTS (select user_id from [10.103.1.108].im80.[dbo].[org_rule_user] where rule_group_id = '8215' AND user_id = U.user_code) THEN 'Y' 
WHEN EXISTS (select user_id from [10.103.1.108].im80.[dbo].[org_group_user] where group_id = '8215' AND user_id = U.user_code) THEN 'Y' ELSE 'N' END					AS MAIL
from [IM].[VIEW_USER] AS U
left join IM.VIEW_ORG AS O
on U.group_code = O.group_code
WHERE (U.display_yn = 'Y' OR U.display_yn is null)
AND U.domain_name = '롯데음료'
AND U.email is not null
--AND U.user_name = '장학영'
AND U.group_name like '%신협%'
AND (U.classpos_name not in ('전무','상무보A','상무보B','자문','상무','회장','사장','부사장','총괄회장') OR U.classpos_name is NULL)
order by O.seq, U.classpos_seq






-- 주류 용
select
U.domain_name, 
U.parent_group_name,
U.group_name,
U.User_name,
U.responsibility_name,
U.position_name,
U.classpos_name,
U.email,
U.employee_num,
U.display_yn
from [IM].[VIEW_USER] AS U
left join IM.VIEW_ORG AS O
on U.group_code = O.group_code
WHERE (U.display_yn = 'Y' OR U.display_yn is null)
AND U.domain_name = '롯데주류'
AND U.email is not null
-- AND U.email  like '%@lotte.net' 충북소주 제외 용
AND employee_num not like '%CB%'
--AND U.user_name = '장학영'
order by O.seq, U.classpos_seq



-- 겸직자 조회
select domain_name, login_id, user_name, group_name, parent_group_name, position_name, email
from [IM].[VIEW_PLURAL] 
where user_code in (select user_code from  [IM].[VIEW_PLURAL] group by user_code  having count(user_code)>1 )
AND domain_name = '롯데음료'


-- 음료 겸직자만 
select domain_name, login_id, user_name, group_name, parent_group_name, position_name, email
from [IM].[VIEW_PLURAL] 
where user_code in (select user_code from  [IM].[VIEW_PLURAL] where domain_name = '롯데음료' group by user_code  having count(user_code)>1 )
AND domain_name = '롯데음료'


-- 겸직자 조회
select domain_name, login_id, user_name, group_name, parent_group_name, position_name, email
from [IM].[VIEW_PLURAL] 
where user_code in (select user_code from  [IM].[VIEW_PLURAL] where domain_name = '롯데주류' group by user_code  having count(user_code)>1 )
