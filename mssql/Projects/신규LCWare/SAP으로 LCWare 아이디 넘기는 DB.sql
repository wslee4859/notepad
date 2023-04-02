use LeCom
select * from LeCom.[dbo].[TZAUserGrp] where empID = '20120775'

select @@trancount
begin tran
update LeCom.[dbo].[TZAUserGrp]
set UserId = 'SJH0453'
where EmpID = '20150006'

--rollback
--commit


-- 계정 정보 
--TZAAuthorityBasis
--[TZAUserGrp]

select * from [erpsql1]..[LeCom].[dbo.TZAUserGrp] where EmpId = '20150669'
select * from TZAUserGrp where EmpId = '20112602'




warara
