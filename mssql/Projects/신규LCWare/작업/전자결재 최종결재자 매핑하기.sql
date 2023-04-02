


use im80
select login_id, name, count(*) from dbo.org_user
where login_id is not null
group by login_id, name
having count(*) > 1

select top 100 * from [WF].[PROCESS_SIGNER] PROCESS_INSTANCE_OID oid = (select

select oid from  [WF].[PROCESS_INSTANCE] group by oid having count(*) > 1

select * from common.[IM].[VIEW_USER] where user_code = '175242'
[WF].[PROCESS_INSTANCE] 

select top 100 * from [WF].[PROCESS_SIGNER] where PROCESS_INSTANCE_OID in (select oid from  [WF].[PROCESS_INSTANCE]) AND SIGN_SEQ = '0'

select oid from  [WF].[PROCESS_INSTANCE] where OID = 'PCC7A344799C7447AA797E1721D304A75'
select top 100 * from [WF].[PROCESS_SIGNER] where PROCESS_INSTANCE_OID = 'PCC7A344799C7447AA797E1721D304A75'
--임시뷰 생성 PROCESS_INSTANCE_OID 가 들어가고 idx 가 들어가는 뷰 생성
-- drop table #PIO 
CREATE TABLE #PIO 
(	idx int IDENTITY(1,1),
	OID char(33) not null
)

-- [WF].[PROCESS_INSTANCE] 이관 idx 
select * from #PIO order by idx
insert into #PIO (OID) SELECT OID from [WF].[PROCESS_INSTANCE]


PCC7A344799C7447AA797E1721D304A75


-- USER_ID 랑 같은거 뽑아내기 
DECLARE @i int, @n int,
	@USER_ID nvarchar(50),
	@LastUser_ID nvarchar(50)

set @i = (select count(oid) from #PIO)
-- select * from [WF].[PROCESS_SIGNER] where PROCESS_INSTANCE_OID in (select oid from  #PIO where idx= 1)
-- set @i = 10;
set @n = 0;
--select @USER_ID select user_id from [WF].[PROCESS_SIGNER] where PROCESS_INSTANCE_OID in (select oid from  #PIO where idx= 1)  AND SIGN_SEQ = '0'
set @USER_ID =  (select user_id from [WF].[PROCESS_SIGNER] where PROCESS_INSTANCE_OID in (select oid from  #PIO where idx= 1)  AND SIGN_SEQ = '0')
set @LastUser_ID = (select top 1 user_id from [WF].[PROCESS_SIGNER] where PROCESS_INSTANCE_OID in (select oid from  #PIO where idx= 1) ORDER BY SIGN_SEQ dESC )
select @USER_ID, @LastUser_ID
--175242 ,50935

while(@n < @i )
begin
set @USER_ID =  (select user_id from [WF].[PROCESS_SIGNER] where PROCESS_INSTANCE_OID in (select oid from  #PIO where idx= @n)  AND SIGN_SEQ = '0')
set @LastUser_ID = (select top 1 user_id from [WF].[PROCESS_SIGNER] where PROCESS_INSTANCE_OID in (select oid from  #PIO where idx= @n) ORDER BY SIGN_SEQ DESC)
	if (@USER_ID = @LastUser_ID)
		begin 
		 SELECT '같은사용자  ' + convert(varchar(10), @n)
		end
set @n = @n+1 
END 





