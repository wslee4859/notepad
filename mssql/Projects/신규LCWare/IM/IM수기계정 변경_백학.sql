--백학음료 조직도(부서) 변경 건 
--9052	 생산담당(백학)  IM_00026
--9051    생산지원담당(백학) IM_00025
--5430    연천공장(백학) JJ_01544
--9054    영업물류담당(백학) IM_00028
--9053    환경기술담당(백학) IM_00027

-- select * from [dbo].[org_group] where name like '%(백학)'
select * from [dbo].[org_user] where domain_id = '11' AND name in  ('차의환','이강희')
select * from [dbo].[org_group_user] WHERE user_id = (select user_id from  [dbo].[org_user] where domain_id = '11' AND name = '차의환')

declare @name varchar(100),
			@sql nvarchar(1000)
set @name = '''이강희'',''차의환''';
select @name

select @sql = 'select * from [dbo].[org_user] where domain_id = ''11'' AND name in ('+@name+')'

exec sp_executesql @sql



차의환 73611
박지훈 73599
윤다혜 73602
김덕원 73612
이규호 73613
begin tran 

-- 부서 변경(orgUser)
update [dbo].[org_user]
set group_id = '9051'
WHERE  domain_id = '11' AND name = '차의환'

--부서 변경(orgGroup)
update [dbo].[org_group_user]
set group_id = '9051'
WHERE relation_type = '1' AND user_id = (select user_id from  [dbo].[org_user] where domain_id = '11' AND name = '차의환')

--부서 직책,직급 유지하기 위해 부서명만 변경
update [dbo].[org_group_user]
SET org_id = '9051'
WHERE relation_type= '4' AND user_id = (select user_id from  [dbo].[org_user] where domain_id = '11' AND name = '차의환')




rollback
commit