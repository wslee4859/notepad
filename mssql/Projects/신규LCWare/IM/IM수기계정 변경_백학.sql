--�������� ������(�μ�) ���� �� 
--9052	 ������(����)  IM_00026
--9051    �����������(����) IM_00025
--5430    ��õ����(����) JJ_01544
--9054    �����������(����) IM_00028
--9053    ȯ�������(����) IM_00027

-- select * from [dbo].[org_group] where name like '%(����)'
select * from [dbo].[org_user] where domain_id = '11' AND name in  ('����ȯ','�̰���')
select * from [dbo].[org_group_user] WHERE user_id = (select user_id from  [dbo].[org_user] where domain_id = '11' AND name = '����ȯ')

declare @name varchar(100),
			@sql nvarchar(1000)
set @name = '''�̰���'',''����ȯ''';
select @name

select @sql = 'select * from [dbo].[org_user] where domain_id = ''11'' AND name in ('+@name+')'

exec sp_executesql @sql



����ȯ 73611
������ 73599
������ 73602
����� 73612
�̱�ȣ 73613
begin tran 

-- �μ� ����(orgUser)
update [dbo].[org_user]
set group_id = '9051'
WHERE  domain_id = '11' AND name = '����ȯ'

--�μ� ����(orgGroup)
update [dbo].[org_group_user]
set group_id = '9051'
WHERE relation_type = '1' AND user_id = (select user_id from  [dbo].[org_user] where domain_id = '11' AND name = '����ȯ')

--�μ� ��å,���� �����ϱ� ���� �μ��� ����
update [dbo].[org_group_user]
SET org_id = '9051'
WHERE relation_type= '4' AND user_id = (select user_id from  [dbo].[org_user] where domain_id = '11' AND name = '����ȯ')




rollback
commit