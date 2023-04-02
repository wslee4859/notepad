select top 10 * from IM.VIEW_PLURAL where user_name = '이우근'



-- 겸직자 조회

select * from IM.VIEW_PLURAL AS P 
left join IM.VIEW_PLURAL AS P1
ON P.user_code = P1.user_code AND P.domain_code ='1'
left join IM.VIEW_PLURAL AS P2
ON P.user_code = P2.user_code AND P.domain_code ='11'
where login_id in (select login_id from IM.VIEW_PLURAL group by login_id having count(login_id) > 1) 
AND P1.domain_code = P2.domain_code 




-- 겸직자 조회(사업부간 겸직포함)
select domain_name, login_id, user_name, group_name, parent_group_name, position_name, email
from [IM].[VIEW_PLURAL] 
where user_code in (select user_code from  [IM].[VIEW_PLURAL] group by user_code  having count(user_code)>1 )
-- AND domain_name = '롯데음료'
-- AND group_name like '%KA%'
order by user_name


-- 음료 겸직자만 
select domain_name, login_id, user_name, group_name, parent_group_name, position_name, email
from [IM].[VIEW_PLURAL] 
where user_code in (select user_code from  [IM].[VIEW_PLURAL] where domain_name = '롯데음료' group by user_code  having count(user_code)>1 )
AND domain_name = '롯데음료'


-- 겸직자 조회(사업부간 겸직안됨)
select user_code, domain_name, login_id, user_name, group_name, parent_group_name, position_name, email
from [IM].[VIEW_PLURAL] 
where user_code in (select user_code from  [IM].[VIEW_PLURAL] where domain_name = '롯데주류' group by user_code  having count(user_code)>1 )



[IM].[VIEW_PLURAL] where user_name = '이원표'


