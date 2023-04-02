-- �ش� �׷쿡 ���Ե� ��� ���� ��ȸ 
-- ���� ��å ��� 

use im80
select  og.name
, ou.code, ou.name, ou.login_id 
, JG.name AS [����]
, JW.name AS [����]
, JC.name AS [��å]
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
'����������',
'�����������',
'��õ����¡���',
'����������',
'ä�δ��',
'����������',
'�����������',
'ä�Ǵ��',
'EDS��',
'EDS��ȹ���',
'EDS�������',
'�Ǹ������',
'�����',
'�������',
'�����������',
'RTM���� TF',
'�ع��濵��',
'������',
'�������',
'��������TF',
'����������',
'�����������',
'�����ȹ���',
'ǰ����������',
'ǰ���������',
'EHS���',
'ǰ���������',
'���������',
'���1���',
'���2���',
'���3���',
'����������',
'�����ȭ��',
'����濵������',
'RGM��',
'����ȸ����',
'�ڱ��Ѱ����',
'�������Ʈ',
'���ߴ��',
'����������Ʈ',
'ȸ���λ���Ʈ',
'���Ż�����Ʈ',
'����',
'�濵����1���',
'�濵����2���',
'�����������',
'�Ż�����',
'RGM���',
'ZBB������',
'DT���� TF',
'�ѹ����',
'�����λ���',
'�������',
'�����ȭ���',
'�빫���',
'CSR���',
'�Ϲ�ȸ����',
'����ȸ����',
'����ȸ����',
'�����ڱݴ��',
'������',
'������ȹ��Ʈ')
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
