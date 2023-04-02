select * from im80.[dbo].[org_user] where name = '이종곤'

select * from [dbo].[org_group] where group_id ='1731'

select name, code from im80.[dbo].[org_group] 
where domain_id = '11' 
	AND group_type_id = '41'
 order by code 

--IM 그룹 중 LCware 사용 여부 확인 
 select ex_use_yn from [dbo].[org_group] where group_id ='8323'

 im80.[dbo].[org_group] where name = '전자결재관리자'



-- IM 그룹 LCWare 권한그룹
select name, code from im80.[dbo].[org_group] 
where domain_id = '11' 
	AND group_type_id = '81'
 order by code 


-- 주류 IM 메일 그룹 
select * from im80.[dbo].[org_group] 
where domain_id = '1' 
	AND name like '%SAP%'
	AND group_type_id = '41'