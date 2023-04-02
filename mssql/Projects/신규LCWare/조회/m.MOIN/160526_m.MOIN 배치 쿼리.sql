SELECT
u.code EmpNum, u.name KorName, u.ex_ename_f + ' ' + u.ex_ename_l EngName,
u.ex_ju_no RegNum,
g.code DeptCd,
'0010' Status,
u.ex_cur_post HomeZip,
u.ex_cur_addr1 HomeAddr1,
u.ex_cur_addr2 HomeAddr2,
'2' Officer,
--CASE u.user_type WHEN 'I' THEN '1' WHEN 'P' THEN  '2' END Officer,
u.login_id MMoinLoginID,
u.ex_phone OfficePhone,
u.login_id + '@lottechilsung.co.kr' Email,
u.mobile Mobile,
'' Fax,
'' OfficeAddr1,
'' OfficeAddr2,
'' OfficeZip,
dbo.Func_GetUserRelationsBev(u.user_id) Groups
FROM org_user u
INNER JOIN org_group g
ON u.group_id = g.group_id
INNER JOIN org_domain d
ON u.domain_id = d.domain_id
WHERE u.status = '1'
AND u.domain_id = '11'
and u.ex_mmoin_yn = 'Y'

union all

SELECT
u.code EmpNum, u.name KorName, u.ex_ename_f + ' ' + u.ex_ename_l EngName,
u.ex_ju_no RegNum,
g.code DeptCd,
'0010' Status,
u.ex_cur_post HomeZip,
u.ex_cur_addr1 HomeAddr1,
u.ex_cur_addr2 HomeAddr2,
'2' Officer,
--CASE u.user_type WHEN 'I' THEN '1' WHEN 'P' THEN  '2' END Officer,
u.login_id MMoinLoginID,
u.ex_phone OfficePhone,
u.login_id + '@lotteliquor.com' Email,
u.mobile Mobile,
'' Fax,
'' OfficeAddr1,
'' OfficeAddr2,
'' OfficeZip,
(select '1:' + code + ':::' from org_group where domain_id <> u.domain_id and group_id = (select top 1 group_id from org_group_user where user_id = u.user_id and relation_type = '2')) Groups
FROM org_user u
INNER JOIN org_group g
ON u.group_id = g.group_id
INNER JOIN org_domain d
ON u.domain_id = d.domain_id
WHERE u.status = '1'
and u.ex_mmoin_yn = 'Y'
and u.code = 'XXXXX'

union all

SELECT
u.code EmpNum, u.name KorName, u.ex_ename_f + ' ' + u.ex_ename_l EngName,
u.ex_ju_no RegNum,
g.code DeptCd,
'0010' Status,
u.ex_cur_post HomeZip,
u.ex_cur_addr1 HomeAddr1,
u.ex_cur_addr2 HomeAddr2,
'2' Officer,
--CASE u.user_type WHEN 'I' THEN '1' WHEN 'P' THEN  '2' END Officer,
u.login_id MMoinLoginID,
u.ex_phone OfficePhone,
u.login_id + '@lottechilsung.co.kr' Email,
u.mobile Mobile,
'' Fax,
'' OfficeAddr1,
'' OfficeAddr2,
'' OfficeZip,
dbo.Func_GetUserRelationsBev(u.user_id) Groups
FROM org_user u
INNER JOIN org_group g
ON u.group_id = g.group_id
INNER JOIN org_domain d
ON u.domain_id = d.domain_id
WHERE u.status = '1'
AND u.domain_id = '11'
AND ( u.ex_mmoin_yn ='N' or u.ex_mmoin_yn is null )
AND u.ex_lcware_yn ='L'
AND u.login_id is not null
AND g.code not in ('JJ_01174')
AND u.login_id not like '%test%'
AND u.login_id not like '%mail%'
AND u.login_id not like '%ewf%'
AND u.login_id not in ('mainserver','super','ewf1','asahi','forklift','idea','lottechilsung')
AND ( u.ex_display_yn ='Y' or u.ex_display_yn is null )