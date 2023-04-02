
select * FROM dbo.TB_USER where UserName = '안세인' OR UserName = '이완상'
-- 25102, 19026      142842   142911

select * from dbo.TB_DEPT_USER_HISTORY where UserID in ('142842','142911')
 
select * from dbo.TB_DEPT 
select * from dbo.TB_GROUP
select * from dbo.TB_DEPT_ORG
select * from dbo.TB_CONFIG
select * from dbo.TB_GROUP_WF
select * from dbo.TB_OBJECT
select * from dbo.TB_ORGMAP
select * from dbo.TB_USER_BUSINESS
select * from dbo.TB_USER_SAPID
select * from dbo.TB_YEAR
select * from eManage.EP_MENU_USE_LOG
--select * from dbo.TB_MONTH
--select * from dbo.TB_LOGON_TYPE
--select * from dbo.TB_LANGUAGE
--select * from dbo.TB_TRANS_BOARDINFO
--select * from dbo.TB_TIMELOG