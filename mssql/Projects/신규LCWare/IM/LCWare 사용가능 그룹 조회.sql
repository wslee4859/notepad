select * from im80.[dbo].[org_user] where name = '������'

select * from [dbo].[org_group] where group_id ='1731'

select name, code from im80.[dbo].[org_group] 
where domain_id = '11' 
	AND group_type_id = '41'
 order by code 

--IM �׷� �� LCware ��� ���� Ȯ�� 
 select ex_use_yn from [dbo].[org_group] where group_id ='8323'

 im80.[dbo].[org_group] where name = '���ڰ��������'



-- IM �׷� LCWare ���ѱ׷�
select name, code from im80.[dbo].[org_group] 
where domain_id = '11' 
	AND group_type_id = '81'
 order by code 


-- �ַ� IM ���� �׷� 
select * from im80.[dbo].[org_group] 
where domain_id = '1' 
	AND name like '%SAP%'
	AND group_type_id = '41'