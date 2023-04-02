


--ekwsql 
--eManage


-- 구erp, 스마트 SFA , SAP 등등 기간계 시스템 아이디 변경 SP
use eManage
DECLARE @a int, @b varchar(100), @c int EXEC UP_UPDATE_ACCOUNT '20112602','yjw0626','', @a OUTPUT, @b OUTPUT, @c OUTPUT SELECT @a, @b, @c


DECLARE @a int, @b varchar(100), @c int EXEC UP_UPDATE_ACCOUNT '20150411','ekzmtjsej','', @a OUTPUT, @b OUTPUT, @c OUTPUT SELECT @a, @b, @c