

/***************************************************
�ֻ��� �μ� ��ȸ
select g1.name
, G2.name
, G3.name
, G4.name
from im80.[dbo].[org_group] AS G1
left join im80.[dbo].[org_group] AS G2
ON G1.parent_id = G2.group_id
left join im80.[dbo].[org_group] AS G3
ON G2.parent_id = G3.group_id
left join im80.[dbo].[org_group] AS G4
ON G3.parent_id = G4.group_id
left join im80.[dbo].[org_group] AS G5
ON G4.parent_id = G5.group_id
where G1.parent_id = (select parent_id from [dbo].[org_group] where name = '�̾Ḷ����繫��' AND group_type_id = '-1')
***************************************************/


--select * from im80.[dbo].[org_user] where name = '�ӵ���'

/***************************
m.MOIN ����� ����Ʈ ��ȸ
* ��ǰBU, �������� ���ݿ��� ����ó��
****************************/
use im80
select 
ou.code, 
ou.name, 
og.name,
ogu_pos.name AS ����, 
ogu_tit.name AS ����,
ogu_wor.name AS ��å,
ou.email,
ou.ex_mmoin_yn
from im80.[dbo].[org_user] as ou
left join im80.[dbo].[org_group] as og
ON ou.group_id = og.group_id
	left outer join 
	(select a.user_id, b.group_id, b.name, a.org_id, b.ex_sort_key from dbo.org_group_user a inner join dbo.org_group b
	 on a.group_id = b.group_id where b.group_type_id = '1')  as ogu_pos
	on ou.user_id = ogu_pos.user_id and ou.group_id = ogu_pos.org_id
	left outer join 
	(select a.user_id, b.group_id, b.name, a.org_id, b.ex_sort_key from dbo.org_group_user a inner join dbo.org_group b
	 on a.group_id = b.group_id where b.group_type_id = '11')  as ogu_tit 
	on ou.user_id = ogu_tit.user_id and ou.group_id = ogu_tit.org_id
	left outer join 
	(select a.user_id, b.group_id, b.name, a.org_id, b.ex_sort_key from dbo.org_group_user a inner join dbo.org_group b
	 on a.group_id = b.group_id where b.group_type_id = '2')  as ogu_wor
	on ou.user_id = ogu_wor.user_id and ou.group_id = ogu_wor.org_id
where ou.ex_mmoin_yn= 'Y' AND ou.status ='1' AND ou.domain_id = '11'
AND ou.code not in ('06035','17203','13097','09055','19026','11081','10091','15256','02144','02214','15253','14139','14047','13026','14141','15046','21262','15255','22079') -- ������ ����� ����(��û��)
AND ou.group_id not in ('10948') -- ��ǰBU�� ����� ����(��û�� ó��)
order by ou.name




/***************************
m.MOIN (����)�����  ��ȸ
****************************/
use im80
select 
ou.name, 
ou.code, 
og.name,
ogu_pos.name AS ����, 
ogu_tit.name AS ����,
ogu_wor.name AS ��å,
ou.email,
ou.ex_mmoin_yn
from im80.[dbo].[org_user] as ou
left join im80.[dbo].[org_group] as og
ON ou.group_id = og.group_id
	left outer join 
	(select a.user_id, b.group_id, b.name, a.org_id, b.ex_sort_key from dbo.org_group_user a inner join dbo.org_group b
	 on a.group_id = b.group_id where b.group_type_id = '1')  as ogu_pos
	on ou.user_id = ogu_pos.user_id and ou.group_id = ogu_pos.org_id
	left outer join 
	(select a.user_id, b.group_id, b.name, a.org_id, b.ex_sort_key from dbo.org_group_user a inner join dbo.org_group b
	 on a.group_id = b.group_id where b.group_type_id = '11')  as ogu_tit 
	on ou.user_id = ogu_tit.user_id and ou.group_id = ogu_tit.org_id
	left outer join 
	(select a.user_id, b.group_id, b.name, a.org_id, b.ex_sort_key from dbo.org_group_user a inner join dbo.org_group b
	 on a.group_id = b.group_id where b.group_type_id = '2')  as ogu_wor
	on ou.user_id = ogu_wor.user_id and ou.group_id = ogu_wor.org_id
where ou.ex_mmoin_yn= 'Y' AND ou.status ='1' AND ou.domain_id = '11'
AND ou.code not in ('06035','17203','13097','09055','19026','11081','10091','15256','02144','02214','15253','14141','15046','15255')
--AND ou.code in ('20080133','20333004','92118' )
AND ou.name in (
'������','������','������','������','������' )



order by ou.name
--im80.[dbo].[org_user] where code = '02144'
----ou.login_id in (
--'ysh1247',
--'xman2k',
--'ggawoo11',
--'ms6939',
--'overlapjh',
--'jhha1024',
--'hcnc12345',
--'gangsmania',
--'jjhxxx',
--'wwfyo',
--'khyosong',
--'jsy0118',
--'john0809',
--'seungeon',
--'ck6542',
--'cdh0316',
--'ikchoi',
--'jjsw105',
--'j9904',
--'jhlee3',
--'wodyddkqja',
--'msukim',
--'kspark',
--'614134',
--'cylee',
--'ksj77' )



/***************************
m.MOIN ����� ����Ʈ ��ȸ(�ַ�)
* ��ǰBU, �������� ���ݿ��� ����ó��
****************************/
use im80
select 
ou.code, 
ou.name, 
og.name,
ogu_pos.name AS ����, 
ogu_tit.name AS ����,
ogu_wor.name AS ��å,
ou.email,
ou.ex_mmoin_yn
from im80.[dbo].[org_user] as ou
left join im80.[dbo].[org_group] as og
ON ou.group_id = og.group_id
	left outer join 
	(select a.user_id, b.group_id, b.name, a.org_id, b.ex_sort_key from dbo.org_group_user a inner join dbo.org_group b
	 on a.group_id = b.group_id where b.group_type_id = '1')  as ogu_pos
	on ou.user_id = ogu_pos.user_id and ou.group_id = ogu_pos.org_id
	left outer join 
	(select a.user_id, b.group_id, b.name, a.org_id, b.ex_sort_key from dbo.org_group_user a inner join dbo.org_group b
	 on a.group_id = b.group_id where b.group_type_id = '11')  as ogu_tit 
	on ou.user_id = ogu_tit.user_id and ou.group_id = ogu_tit.org_id
	left outer join 
	(select a.user_id, b.group_id, b.name, a.org_id, b.ex_sort_key from dbo.org_group_user a inner join dbo.org_group b
	 on a.group_id = b.group_id where b.group_type_id = '2')  as ogu_wor
	on ou.user_id = ogu_wor.user_id and ou.group_id = ogu_wor.org_id
where ou.ex_mmoin_yn= 'Y' AND ou.status ='1' AND ou.domain_id = '1'
AND ou.code not in ('06035','17203','13097','09055','19026','11081','10091','15256','02144','02214','15253','14139','14047','13026','14141','15046') -- ������ ����� ����(��û��)
AND ou.group_id not in ('10948') -- ��ǰBU�� ����� ����(��û�� ó��)
order by ou.name





324
120
















