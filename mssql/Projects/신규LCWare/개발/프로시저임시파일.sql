USE [TEST]
GO
/****** Object:  StoredProcedure [IM].[ClosedUser_insert]    Script Date: 2017-02-17 오전 11:30:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		이완상
-- Create date: 2017-02-17
-- Description:	시스템 로그인한 로그 마스터 테이블
-- EXEC [IM].[mst_login_log_insert] 'wslee4859','lcware','10.120.40.25'
-- =============================================
ALTER PROCEDURE [IM].[mst_login_log_insert]
	-- Add the parameters for the stored procedure here
	@login_id varchar(30),
	@system varchar(30),
	@ip varchar(30)	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	-- Insert statements for procedure here	
	DECLARE @wrong_cnt smallint
	SET @wrong_cnt = (select top 1 wrong_cnt from [IM].[mst_login_log] where login_id = @login_id order by time desc)
	-- select top 1 wrong_cnt from [IM].[mst_login_log] where login_id = 'wslee4850' order by time desc
	--select @wrong_cnt = (select top 1 wrong_cnt from [IM].[mst_login_log] where login_id = 'wslee4850' order by time desc)
	--select @wrong_cnt
	IF @wrong_cnt IS NULL
		BEGIN
			INSERT INTO [IM].[mst_login_log] VALUES ( format(getdate(),'yyyy-MM-dd HH:mm:ss'), @login_id, @system, @ip, '1');
		END
	ELSE IF @wrong_cnt = '5'
		BEGIN
			EXEC [IM].[ClosedUser_insert] @login_id, @system;
			INSERT INTO [IM].[mst_login_log] VALUES ( format(getdate(),'yyyy-MM-dd HH:mm:ss'), @login_id, @system, @ip, @wrong_cnt);
		END
	ELSE 
		BEGIN 
			@wrong_cnt = @wrong_cnt + 1;
			INSERT INTO [IM].[mst_login_log] VALUES ( format(getdate(),'yyyy-MM-dd HH:mm:ss'), @login_id, @system, @ip, @wrong_cnt);
		END	
END


