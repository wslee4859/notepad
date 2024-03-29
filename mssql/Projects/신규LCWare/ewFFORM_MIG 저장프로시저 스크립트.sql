USE [eWFFORM_MIG]
GO
/****** Object:  StoredProcedure [dbo].[aaa_bbb]    Script Date: 2015-10-15 오후 1:30:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

/*	--------------------------------------------------------------
	작성자: 임병태
	작성일: 2004.03.17
	수정일: 2005.08.31
	수정자: 김진시
	수정내용: DB결재 양식인지 구분할 FORM_TYPE 추가
	설명 : 결재폼 양식 데이터 정보를 가져온다
exec aaa_bbb 'Z53CB2555065C427494941B571FE2BB2C'

--------------------------------------------------------------	*/
/****** 개체: 저장 프로시저 dbo.UP_Select_FORMS_DATA    스크립트 날짜: 2007-10-30 오후 4:44:57 ******/
CREATE	Procedure	[dbo].[aaa_bbb]
		@PROCESS_ID	varchar(50)	-- 프로세스 ID


As

Set Transaction isolation level read uncommitted

	Declare	@vcFORM_ID	VARCHAR(50),		-- 결재 양식 폼 ID
			@nvcDY_SQL	NVARCHAR(4000),		-- 동적 양식 폼 조회 ID
			@cFOLDERTYPE	char(1),
			@intFOLDERID	int

	-- 프로세스 ID로 결재양식 폼 ID 가져오기
	Set	@vcFORM_ID = (Select	FORM_ID	From	dbo.WF_FORMS_PROP (NOLOCK)	Where	PROCESS_ID = @PROCESS_ID)

	Select	@intFOLDERID = FOLDERID
	From	WF_FOLDER_DETAIL (NOLOCK)
	Where	FORM_ID = @vcFORM_ID

	Select	@cFOLDERTYPE = FOLDERTYPE
	From	WF_FOLDER (NOLOCK)
	Where	FOLDERID = (Select	PARENTFOLDERID	From	WF_FOLDER (NOLOCK)	Where	FOLDERID = @intFOLDERID)
select 'test1'
	-- 1. 양식 폼 헤더 정보
	Select	* ,@cFOLDERTYPE FOLDER_TYPE
	From	dbo.WF_FORMS (NOLOCK)
	Where	FORM_ID= @vcFORM_ID

	-- 2. 양식 폼의 스키마 정보
	Select	 *
	From	dbo.WF_FORM_SCHEMA (NOLOCK)
	Where	FORM_ID= @vcFORM_ID

	-- 3. 양식폼의 필드정보
	Select	*
	From	dbo.WF_FORM_INFORM (NOLOCK)
	Where	FORM_ID= @vcFORM_ID

	--	4. 결재양식 폼에서 프로세스 ID에 해당하는 폼 데이터를 가져오는 SQL를 생성한다.
	--	Drop	Table	#WF_FORM_INFORM
	Declare	@wTotalRowCount	int

	Declare	@WF_FORM_INFORM	Table
	(
		Field_Name	varchar(30),
		Num			int	identity(1, 1)
	)

	Insert	Into	@WF_FORM_INFORM
			(Field_Name)
	Select	Field_Name
--	Select	Field_Name, identity(int, 1, 1) as Num
--	Into	#WF_FORM_INFORM
	From	dbo.WF_FORM_INFORM
	Where	Form_ID = @vcFORM_ID
	Order by Field_Name
select 'test2'
	Set	@wTotalRowCount = @@RowCount

	--	기안서 시리즈에 데이타 공유 작업
	Declare	@wU_AGREE_DEPT_Comment	varchar(8000),
			@wTongje				varchar(1000)

	Select	@wU_AGREE_DEPT_Comment = '',
			@wTongje = ''

	If	@vcFORM_ID in (Select	Form_ID	From	eWFForm.dbo.WF_Forms	Where	Form_EName in ('LC_DRAFT', 'LC_DRAFT_BRANCH', 'LC_SUPPORT_DRAFT'))
	Begin
select @vcFORM_ID
select @PROCESS_ID
select @wU_AGREE_DEPT_Comment
		Exec dbo.UP_Select_AgreeDept_Comment @vcFORM_ID, @PROCESS_ID, @wU_AGREE_DEPT_Comment output
--sp_help up_select_agreedept_comment
select 'test3'
		If	@vcFORM_ID in (Select	Form_ID	From	eWFForm.dbo.WF_Forms	Where	Form_EName in ('LC_DRAFT', 'LC_DRAFT_BRANCH'))
			Exec dbo.UP_SELECT_AGREEDEPT_TONGJE @vcFORM_ID, @PROCESS_ID, @wTongje output
select 'test4'
	End


	--	Select 쿼리 만드는 Loop 
	Declare	@wField_Name	varchar(1000),
			@wSql			varchar(8000),
			@wNum	int

	Select	@wField_Name = '',
			@wNum = 0,
			@wSql = ""

	While (1 = 1)
	Begin

		Select	Top 1
				@wNum = Num,
				@wField_Name = Field_Name
		From	@WF_FORM_INFORM
		Where	Num > @wNum
		Order by Num

		If	@@Rowcount = 0	Break

		If	@wField_Name = 'U_AGREE_DEPT_COMMENT'
			Set	@wSql = @wSql + '"' + IsNull(@wU_AGREE_DEPT_Comment, '') + '" as U_AGREE_DEPT_COMMENT'
		Else If	@wField_Name = 'TONGJE'
			Set	@wSql = @wSql + '"' + IsNull(@wTongje, '') + '" as TONGJE'
		Else

		Set	@wSql = @wSql + @wField_Name

--		If	@wNum < @wTotalRowCount
			Set	@wSql = @wSql + ', '

	End
select 'test4'
	--	첨언 테이블 조회
	Declare	@wComment	varchar(8000)

	Exec UP_Select_Signer_Comment @PROCESS_ID, @wComment output
--sp_help UP_Select_Signer_Comment
	IF	@wComment IS NULL
		SET	@wComment = "''"

	Set	@wSql = @wSql + @wComment + ' as U_Comment'

	--	조회
	Set	@wSql = "Select	" + @wSql + "	From	eWFForm.dbo.FORM_" + @vcFORM_ID + "	Where	Process_Id = '" + @PROCESS_ID + "'"
	print (@wSql)
	Exec (@wSql)

-- 	Begin
-- 
-- 		SET @nvcDY_SQL = N'Select	* From	dbo.FORM_' + @vcFORM_ID + ' (NOLOCK) Where	PROCESS_ID=@PROCESS_ID'
-- 		EXEC SP_EXECUTESQL  @nvcDY_SQL, N'@PROCESS_ID VARCHAR(50)', @PROCESS_ID
-- 
-- 	End



GO
/****** Object:  StoredProcedure [dbo].[Kang]    Script Date: 2015-10-15 오후 1:30:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE	Procedure	[dbo].[Kang]
		@pFormID	char(33)
/*

select	*	from	ewfform.dbo.wf_forms

select	HtmlDescription, suggestdate
from	ewfform.dbo.form_YE642705502F94481AE9024674E18A103	--	공통양식
order by suggestdate

select	HtmlDescription, suggestdate
from	ewfform.dbo.form_YAE2F85A901AF4B43BC6906EF06C8DB83	--	업무연락
order by suggestdate

select	HtmlDescription, suggestdate
from	ewfform.dbo.form_Y28B72F2F7EE54FB5BE13E8F2A3637978	--	기안용지
order by suggestdate

select	HtmlDescription, suggestdate
from	ewfform.dbo.form_YFA4BC440266849EB8DBA1A1FE7C55EE6	--	기안용지(지점용)
order by suggestdate

exec dbo.Kang 'YE642705502F94481AE9024674E18A103'
exec dbo.Kang 'YAE2F85A901AF4B43BC6906EF06C8DB83'
exec dbo.Kang 'Y9FA891C60DF54882BAE0DA51F233AF69'
exec dbo.Kang 'Y2C2E2C72B0B24A3782D8BCAA162C52E6'

*/

As

--	Drop	Table	#form
Create	Table	#form
(
	Process_ID		char(33),
	HtmlDescription	text,
	num				int	identity(1, 1)
)
if	exists	(Select	1	From	Tempdb..sysobjects	Where	name = '##html')
	Drop	Table	##html
Create	Table	##html
(
	FormID		char(33),
	Process_ID	char(33),
	InnerHtml	text
)

Declare	@wHtml	varchar(8000),
		@num	int,
		@wSql	varchar(8000),
		@wProcess_ID	char(33)

	Select	@num = 0

	Set	@wSql = "
		Insert	Into	#form
			Select	Process_ID, HtmlDescription
			From	ewfform.dbo.form_" + @pFormID

	Exec (@wSql)

	While	(1 = 1)
	Begin
	
		Select	Top	1
				@num = num,
				@wHtml = HtmlDescription,
				@wProcess_ID = Process_ID
		From	#form
		Where	num > @num
	
		If	@@rowcount = 0	Break
	
		If	CharIndex('<html>', @wHtml) <> 0	
		Begin
			Insert	Into	##html
				Select	@pFormID, @wProcess_ID, @wHtml
		End
		
	End
	
select	*	From	##html



GO
/****** Object:  StoredProcedure [dbo].[UP_COPY_APRLIST]    Script Date: 2015-10-15 오후 1:30:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[UP_COPY_APRLIST]
	/* Param List */	
	@strId varchar(100),
	@strNewId varchar(100),
	@strAprName varchar(50)
	
AS	
	
DECLARE	@UserID int
DECLARE	@FORM_ID varchar(33)
DECLARE @SIGNINFORM varchar(8000)
DECLARE @SIGNERLIST varchar(8000)
DECLARE @LISTTYPE char(10)
DECLARE @SORTKEY int
SET @SORTKEY = (@SORTKEY + 1)
INSERT INTO WF_SIGNER_LIST (ID,UserID,FORM_ID,SignListName,SignInform,SignerList,ListType,SortKey)
SELECT 	@strNewId ,
	UserID ,
 	FORM_ID , 
	@strAprName, 
	SignInform, 
	SignerList, 
	ListType,
	SortKey 
FROM    dbo.Wf_SIGNER_LIST
WHERE   (ID = @strId)
	
	
	
	
	
RETURN

GO
/****** Object:  StoredProcedure [dbo].[UP_COPY_FOLDER]    Script Date: 2015-10-15 오후 1:30:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UP_COPY_FOLDER]
(
	@vcfolderId			varchar(33)
)
AS
	/* SET NOCOUNT ON */
	DECLARE 
		@vcfolderName		VARCHAR(100),
		@vcfirstName		VARCHAR(100),
		@vclastName			VARCHAR(100)
		
	SET @vcfolderName = 
	(
		SELECT 
			FOLDERNAME 
		FROM 
			dbo.WF_FOLDER 
		WHERE 
			FOLDERID = @vcfolderId
	)
	
	SET @vcfirstName = SUBSTRING(@vcfolderName, 0, CHARINDEX(';', @vcfolderName)) + '_복사본'
	SET @vclastName  = SUBSTRING(@vcfolderName, CHARINDEX(';', @vcfolderName) + 1, LEN(@vcfolderName) - CHARINDEX(';', @vcfolderName) + 1) + '_COPY'
	SET @vcfolderName = @vcfirstName + ';' + @vclastName
	
	INSERT INTO dbo.WF_FOLDER
	SELECT 
		CLASSCODE,  
		@vcfolderName, 
		FOLDERTYPE, 
		ACLID, 
		ARCHIVECODE, 
		SORTKEY, 
		DEPTH, 
		PARENTFOLDERID, 
		HASSUBFOLDER, 
		GETDATE(),
		NULL, 
		''
	FROM 
		dbo.WF_FOLDER 
	WHERE 
		FOLDERID = @vcfolderId
		
	SELECT 
		LTRIM(CONVERT(VARCHAR(33), MAX(FOLDERID)))
	from 
		dbo.WF_FOLDER 
	where 
		FOLDERNAME = @vcfolderName
RETURN 

GO
/****** Object:  StoredProcedure [dbo].[UP_COPY_FORM]    Script Date: 2015-10-15 오후 1:30:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UP_COPY_FORM]
	(
		@vcsrcFormId			VARCHAR(33),
		@vcdestFormId			VARCHAR(33)
	)
AS 
	DECLARE
		@vcsrcFormTableName		VARCHAR(100),
		@vcdestFormTableName	VARCHAR(100),
		@vcpkName				VARCHAR(110),
		@sql					varchar(2000)
		
	SET @vcsrcFormTableName		= 'dbo.FORM_'  + @vcsrcFormId
	SET @vcdestFormTableName	= 'dbo.FORM_' + @vcdestFormId
	SET @vcpkName				= 'PK_FORM_' + @vcdestFormId
	EXEC ('SELECT * INTO ' + @vcdestFormTableName +  ' FROM ' + @vcsrcFormTableName + ' WHERE 1 > 2')
	EXEC('ALTER TABLE ' + @vcdestFormTableName + ' ADD CONSTRAINT ' + @vcpkName + '  PRIMARY KEY NONCLUSTERED  (PROCESS_ID)')
RETURN

GO
/****** Object:  StoredProcedure [dbo].[UP_COPY_FORMCOLUMN]    Script Date: 2015-10-15 오후 1:30:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UP_COPY_FORMCOLUMN]
	(
		@vcsrcformId			VARCHAR(33),
		@vcdestformId			VARCHAR(33)
	)
AS
	/* SET NOCOUNT ON */
	INSERT INTO dbo.WF_FORM_INFORM 
	(
		FORM_ID, 
		FIELD_ID, 
		FIELD_NAME, 
		FIELD_LABEL, 
		FIELD_TYPE, 
		FIELD_LENGTH, 
		FIELD_DEFAULT
	) 
	Select 
		@vcdestformId, 
		FIELD_ID, 
		FIELD_NAME, 
		FIELD_LABEL, 
		FIELD_TYPE, 
		FIELD_LENGTH, 
		FIELD_DEFAULT 
	FROM dbo.WF_FORM_INFORM
	WHERE FORM_ID  = @vcsrcformId
RETURN 
 

GO
/****** Object:  StoredProcedure [dbo].[UP_COPY_FORMHEADER]    Script Date: 2015-10-15 오후 1:30:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UP_COPY_FORMHEADER]
	(
		@vcformId						varchar(33)
	)
AS
	DECLARE
		@vcnewFormId					varchar(33)
	
	
	
	SET @vcnewFormId = (SELECT 'Y' +  REPLACE(NEWID(), '-', ''))
		
INSERT INTO  dbo.WF_FORMS 
select 
	@vcnewFormId, 
	Classification , 
	Form_Name + '_복사본', 
	Form_eName + '_COPY', 
	Def_OID, 
	Revision, 
	Current_Forms, 
	'', 
	GetDate(),
	NULL				-- FORM_ALIAS 는 복사하지 않는다.
From 
	dbo.WF_FORMS 
where 
	Form_ID = @vcformId
	
SELECT @vcnewFormId	
RETURN 

GO
/****** Object:  StoredProcedure [dbo].[UP_COPY_FORMSCHEMA]    Script Date: 2015-10-15 오후 1:30:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UP_COPY_FORMSCHEMA]
	(
		@vcsrcFormId		VARCHAR(33),
		@vcnewFormId		VARCHAR(33)
	)
AS
	/* SET NOCOUNT ON */
	INSERT INTO dbo.WF_FORM_SCHEMA
	(
		FORM_ID, 
		SMTP_SUFFIX, 
		EDM_USE_YN, 
		AUDIT_USER_USE_YN, 
		AUDIT_USER, 
		AUDIT_USER_CODE,
		AUDIT_DEPART_USE_YN,
		AUDIT_DEPART, 
		AUDIT_DEPART_CODE, 
		DRAFTBOX_USE_YN,
		PERSON_AGREE_YN, 
		DEPT_AGREE_YN, 
		RCV_USE_YN, 
		MULTI_RCV_YN, 
		MAIL_USE_YN,
		RECEPTION,	
		RECEPTION_CODE,
		SCREEN_ORIENTATION,
		SCREEN_WIDTH
	)
	SELECT 
		@vcnewFormId, 
		SMTP_SUFFIX, 
		EDM_USE_YN, 
		AUDIT_USER_USE_YN, 
		AUDIT_USER, 
		AUDIT_USER_CODE,
		AUDIT_DEPART_USE_YN,
		AUDIT_DEPART, 
		AUDIT_DEPART_CODE, 
		DRAFTBOX_USE_YN,
		PERSON_AGREE_YN, 
		DEPT_AGREE_YN, 
		RCV_USE_YN, 
		MULTI_RCV_YN, 
		MAIL_USE_YN,
		RECEPTION,	
		RECEPTION_CODE,
		SCREEN_ORIENTATION,
		SCREEN_WIDTH
	FROM 
		dbo.WF_FORM_SCHEMA
	WHERE 
		FORM_ID = @vcsrcFormId
	
RETURN 

GO
/****** Object:  StoredProcedure [dbo].[UP_CREATE_FORM]    Script Date: 2015-10-15 오후 1:30:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UP_CREATE_FORM]
(
	@vcformId		VARCHAR(33)
)
AS
DECLARE
	@vcfieldName		VARCHAR(100),	
	@vcfieldType		VARCHAR(100),
	@vcfieldLength		VARCHAR(100),
	@vcfieldDefault		VARCHAR(100),
	@vcSql				VARCHAR(5000)
DECLARE
	
	FIELD_Cursor  CURSOR FOR
		SELECT 
			FIELD_NAME, 
			FIELD_TYPE, 
			FIELD_LENGTH, 
			FIELD_DEFAULT 
		FROM 
			dbo.WF_FORM_DEFAULT_FIELD
	OPEN FIELD_Cursor
	FETCH NEXT FROM FIELD_Cursor INTO @vcfieldName, @vcfieldType, @vcfieldLength, @vcfieldDefault
	SET @vcSql = ''
	WHILE @@FETCH_STATUS  = 0
       	BEGIN	-- WHILE#1
			IF(@vcfieldType = 'INT' OR @vcfieldType = 'DATETIME' OR @vcfieldType = 'TEXT')
				SET @vcSql = @vcSql + @vcfieldName + N' ' + @vcfieldType + N'  NULL ,' + CHAR(10)
			ELSE
				SET @vcSql = @vcSql + @vcfieldName + N' ' + @vcfieldType + N'(' + @vcfieldLength + N')' + N' COLLATE Korean_Wansung_CI_AS  NULL ,' + CHAR(10)
			FETCH NEXT FROM FIELD_Cursor INTO @vcfieldName, @vcfieldType, @vcfieldLength, @vcfieldDefault
		END	-- end of WHILE#1
	SET @vcSql = LEFT(@vcSql, LEN(@vcSql) - 2) + char(10)
	SET @vcSql = N'CREATE TABLE dbo.FORM_' + @vcformId + '(' + char(10) + @vcSql + N')'
	EXEC (@vcSql)
	CLOSE FIELD_Cursor
	DEALLOCATE FIELD_Cursor
	SET @vcSql = N'ALTER TABLE dbo.FORM_' + @vcformId + ' ALTER COLUMN PROCESS_ID VARCHAR(33) NOT NULL'
	EXEC (@vcSql)
DECLARE
	ALTER_Cursor  CURSOR FOR
		SELECT 
			FIELD_NAME, 
			FIELD_TYPE, 
			FIELD_LENGTH, 
			FIELD_DEFAULT 
		FROM 
			dbo.WF_FORM_DEFAULT_FIELD 
		WHERE 
			FIELD_DEFAULT IS NOT NULL
	OPEN ALTER_Cursor
	FETCH NEXT FROM ALTER_Cursor into @vcfieldName, @vcfieldType, @vcfieldLength, @vcfieldDefault
	SET @vcSql = ''
	WHILE @@FETCH_STATUS  = 0
        BEGIN	-- WHILE#1
        
			IF @vcfieldDefault <> ''
				SET @vcSql = @vcSql + N' CONSTRAINT DF_FORM_' + @vcformId + N'_' + @vcfieldName + ' DEFAULT (''' + @vcfieldDefault + ''') FOR [' + @vcfieldName + '],' + CHAR(10)
			
			FETCH NEXT FROM ALTER_Cursor into @vcfieldName, @vcfieldType, @vcfieldLength, @vcfieldDefault
		END	-- end of WHILE#1
	SET @vcSql = @vcSql + N' CONSTRAINT PK_FORM_' + @vcformId + ' PRIMARY KEY  NONCLUSTERED (PROCESS_ID)'
	SET @vcSql = N'ALTER TABLE dbo.FORM_' + @vcformId + ' ADD' + char(10) + @vcSql
	Exec (@vcSql)
	CLOSE ALTER_Cursor
	DEALLOCATE ALTER_Cursor
RETURN
 

GO
/****** Object:  StoredProcedure [dbo].[UP_CREATEFORMHEADER_FORMS]    Script Date: 2015-10-15 오후 1:30:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
----------------------------------------------------------------------
----------------------------------------------------------------------
-- 작성자: 조성균
-- 작성일: 2004.03.06
-- 수정일: 2004.03.06
-- 설   명: 폼헤더 생성
--        	테스트 :
--		EXEC  UP_CREATEFORMHEADER_FORMS
----------------------------------------------------------------------
----------------------------------------------------------------------
-- 수정일 : 
-- 수정자 : 
-- 수정내용 : 
----------------------------------------------------------------------
----------------------------------------------------------------------
CREATE PROCEDURE [dbo].[UP_CREATEFORMHEADER_FORMS]
	(
		@vcformId					VARCHAR(33),
		@intClassification			INT,
		@vcKorFormName				VARCHAR(200),
		@vcEngFormName				VARCHAR(200),
		@vcDefId					VARCHAR(33),
		@cUserYn					CHAR(1),
		@vcDesc						VARCHAR(100),
		@vcformAlias				VARCHAR(10)
	)
AS
	DECLARE
		@intCount				int
		
	SET @intCount = 
	(
		SELECT 
			COUNT(*)
			AS Counts
		FROM dbo.WF_FORMS
		WHERE Form_Name = @vcKorFormName and Form_eName = @vcEngFormName
	)
	
	IF(@intCount > 0)
	BEGIN
		RETURN
	END 
	
	INSERT INTO dbo.WF_FORMS
		(
			Form_ID,
			Classification,
			Form_Name,
			Form_eName,
			Def_OID,
			Current_Forms,
			Form_Desc,
			Create_Date,
			FORM_ALIAS
		)
	VALUES
		(
			@vcformId,
			@intClassification,
			@vcKorFormName,
			@vcEngFormName,
			@vcDefId,
			@cUserYn,
			@vcDesc,
			GETDATE(),
			@vcformAlias
		)
RETURN 

GO
/****** Object:  StoredProcedure [dbo].[UP_CREATEFORMSCHEMA_FORMSCHEMA]    Script Date: 2015-10-15 오후 1:30:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
----------------------------------------------------------------------
----------------------------------------------------------------------
-- 작성자: 조성균
-- 작성일: 2004.03.08
-- 수정일: 2004.03.08
-- 설   명: 폼스키마 생성	
--        	테스트 :
--		EXEC  UP_CREATEFORMSCHEMA_FORMSCHEMA
----------------------------------------------------------------------
----------------------------------------------------------------------
-- 수정일 : 
-- 수정자 : 
-- 수정내용 : 
----------------------------------------------------------------------
----------------------------------------------------------------------
CREATE PROCEDURE [dbo].[UP_CREATEFORMSCHEMA_FORMSCHEMA]
	(
		@vcFormId				VARCHAR(33),
		@vcSmtp_Suffix			VARCHAR(100),
		@cEdm_UseYn				CHAR(1),
		@cAudit_UserUseYn		CHAR(1),
		@vcAudit_User			VARCHAR(100),
		@vcAudit_UserCode		VARCHAR(100),
		@cAudit_DeptUseYn		CHAR(1),
		@vcAudit_Depart			VARCHAR(100),
		@vcAudit_DeptCode		VARCHAR(100),
		@cDraftBox_UseYn		CHAR(1),
		@cPerson_AgreeYn		CHAR(1),
		@cDept_AgreeYn			CHAR(1),
		@cRcv_UseYn				CHAR(1),
		@cMulti_RcvYn			CHAR(1),
		@cMail_UseYn			CHAR(1),
		@vcDefaultRcvName		VARCHAR(500),
		@vcDefaultRcvCode		VARCHAR(500),
		@cScreen_Orientation	CHAR(1),
		@intScreen_Width			INT
	)
AS	
	IF(@vcSmtp_Suffix = '')
		SET @vcSmtp_Suffix = NULL
		
	IF(@vcAudit_User = '')
		SET @vcAudit_User = NULL
	IF(@vcAudit_Depart = '')
		SET @vcAudit_Depart = NULL
	
	IF(@vcDefaultRcvName = '')
		SET @vcDefaultRcvName = NULL
		
	IF(@vcDefaultRcvCode = '')
		SET @vcDefaultRcvCode = NULL
	
	INSERT INTO dbo.WF_FORM_SCHEMA
	(
		FORM_ID,
		SMTP_SUFFIX,
		EDM_USE_YN,
		AUDIT_USER_USE_YN,
		AUDIT_USER,	
		AUDIT_USER_CODE,
		AUDIT_DEPART_USE_YN,
		AUDIT_DEPART,
		AUDIT_DEPART_CODE,
		DRAFTBOX_USE_YN,
		PERSON_AGREE_YN,
		DEPT_AGREE_YN,
		RCV_USE_YN,
		MULTI_RCV_YN,
		MAIL_USE_YN,
		RECEPTION,
		RECEPTION_CODE,
		SCREEN_ORIENTATION,
		SCREEN_WIDTH
	)
	VALUES
	(
		@vcFormId,
		@vcSmtp_Suffix,
		@cEdm_UseYn,
		@cAudit_UserUseYn,
		@vcAudit_User,
		@vcAudit_UserCode,
		@cAudit_DeptUseYn,
		@vcAudit_Depart,
		@vcAudit_DeptCode,
		@cDraftBox_UseYn,
		@cPerson_AgreeYn,
		@cDept_AgreeYn,
		@cRcv_UseYn,
		@cMulti_RcvYn,
		@cMail_UseYn,
		@vcDefaultRcvName,
		@vcDefaultRcvCode,
		@cScreen_Orientation,
		@intScreen_Width
	)
RETURN 

GO
/****** Object:  StoredProcedure [dbo].[UP_DELETE_ALL_WORK_ITEM_STATE]    Script Date: 2015-10-15 오후 1:30:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE    PROCEDURE [dbo].[UP_DELETE_ALL_WORK_ITEM_STATE]
	@vcUID		VARCHAR(50), -- user ID
	@vcDFType	VARCHAR(5)
AS


IF (@vcDFType = 'CO')
	BEGIN
	UPDATE eWF.dbo.WORK_ITEM
	SET DELETE_DATE = GETDATE()
	WHERE PARTICIPANT_ID = @vcUID
	AND STATE = '7' 
	AND PROCESS_INSTANCE_VIEW_STATE = '7'
	AND DELETE_DATE is NULL
	END
ELSE IF  (@vcDFType = 'RE')
	BEGIN
	UPDATE eWF.dbo.WORK_ITEM
	SET DELETE_DATE = GETDATE()
	WHERE PARTICIPANT_ID = @vcUID
	AND STATE = '7' 
	AND PROCESS_INSTANCE_VIEW_STATE = '8'
	AND DELETE_DATE is NULL
	END
ELSE
	BEGIN
	-- 임시보관함 삭제(업데이트)	
	UPDATE eWFFORM.dbo.WF_FORM_STORAGE
	SET DELETE_DATE = GETDATE()
	WHERE USERID = @vcUID
	AND DELETE_DATE = '9999-12-31 00:00:00.000'	
	END



GO
/****** Object:  StoredProcedure [dbo].[UP_DELETE_APRLIST]    Script Date: 2015-10-15 오후 1:30:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[UP_DELETE_APRLIST]
	/* Param List */	
	
	
	@strId		varchar(100)
	
AS	
	
	/* SET NOCOUNT ON 	*/
	DELETE
	FROM dbo.WF_SIGNER_LIST
	WHERE ID = @strId
	
RETURN

GO
/****** Object:  StoredProcedure [dbo].[UP_DELETE_FOLDERDETAIL]    Script Date: 2015-10-15 오후 1:30:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UP_DELETE_FOLDERDETAIL]
(
	@vcfolderId			varchar(20)
)
AS
	/* SET NOCOUNT ON */
	DELETE FROM 
		dbo.WF_FOLDER_DETAIL
    WHERE FOLDERID = @vcfolderId
RETURN 

GO
/****** Object:  StoredProcedure [dbo].[UP_DELETE_FORM]    Script Date: 2015-10-15 오후 1:30:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UP_DELETE_FORM]
	(
		@vcformId			VARCHAR(33)
	)
AS 
	DECLARE
		@vcsql				VARCHAR(5000)
		
	SET @vcsql = N'DROP TABLE dbo.FORM_' + @vcformId
	
	EXEC (@vcsql)
RETURN

GO
/****** Object:  StoredProcedure [dbo].[UP_DELETE_FORMCOLUMN]    Script Date: 2015-10-15 오후 1:30:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UP_DELETE_FORMCOLUMN]
	(
		@vcformId			VARCHAR(33)
	)
AS
	/* SET NOCOUNT ON */
	DELETE FROM 
		dbo.WF_FORM_INFORM
    WHERE FORM_ID = @vcformId
    
RETURN 
 

GO
/****** Object:  StoredProcedure [dbo].[UP_DELETE_FORMDEFAULTFIELD]    Script Date: 2015-10-15 오후 1:30:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE 
PROCEDURE [dbo].[UP_DELETE_FORMDEFAULTFIELD]
         (@vcIDs    VARCHAR(8000) = ''
         )
       AS 
-- <pre-Step : 환경설정>
SET NOCOUNT ON
-- <Step-0-0 : 파라미터 확인>
IF(@vcIDs='') BEGIN
    RAISERROR('필수 파라미터가 부족합니다.[EC0]', 16, 1)
         WITH NOWAIT
    GOTO END_PROC
END
DECLARE @nCnt1 SMALLINT
DECLARE @nCnt2 SMALLINT
-- <Step-1-0 : 데이터 존재 확인>
SELECT @nCnt1 = COUNT(*)
  FROM dbo.UF_SPLIT_STRING(@vcIDs)
SELECT @nCnt2 = COUNT(*)
  FROM dbo.UF_SPLIT_STRING(@vcIDs) AS UFSS
       INNER JOIN Wf_FORM_DEFAULT_FIELD AS WFDF
          ON UFSS.FIELD_NAME = WFDF.FIELD_NAME
IF(@nCnt1 <> @nCnt2) BEGIN
    RAISERROR('삭제하려는 데이터가 존재하지 않습니다.[ED1]', 16, 1)
         WITH NOWAIT
    GOTO END_PROC
END
-- <Step-1-1 : 데이터 삭제>
DELETE Wf_FORM_DEFAULT_FIELD
  FROM Wf_FORM_DEFAULT_FIELD AS WFDF
       INNER JOIN dbo.UF_SPLIT_STRING(@vcIDs) AS UFSS
          ON UFSS.FIELD_NAME = WFDF.FIELD_NAME
IF @@ERROR <> 0 BEGIN
    RAISERROR('데이터삭제 작업중 오류가 발생했습니다.[ED2]', 16, 1)
         WITH NOWAIT
    GOTO END_PROC
END
END_PROC:
-- <post-Step : 환경설정>
SET NOCOUNT OFF
RETURN

GO
/****** Object:  StoredProcedure [dbo].[UP_DELETE_FORMHEADER]    Script Date: 2015-10-15 오후 1:30:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 CREATE PROCEDURE [dbo].[UP_DELETE_FORMHEADER]
	(
		@vcformId			VARCHAR(33)
	)
AS
	DELETE FROM dbo.WF_FORMS
	WHERE FORM_ID = @vcformId
RETURN 

GO
/****** Object:  StoredProcedure [dbo].[UP_DELETE_FORMSCHEMA]    Script Date: 2015-10-15 오후 1:30:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UP_DELETE_FORMSCHEMA]
	(
		@vcformId varchar(33)
	)
AS
	/* SET NOCOUNT ON */
	DELETE FROM 
		dbo.WF_FORM_SCHEMA 
	WHERE FORM_ID = @vcformId
RETURN 

GO
/****** Object:  StoredProcedure [dbo].[UP_DELETE_WF_ACL]    Script Date: 2015-10-15 오후 1:30:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


----------------------------------------------------------------------
----------------------------------------------------------------------
-- 작성자: 신상훈
-- 작성일: 2004.03.19
-- 수정일: 2004.03.19
-- 설  명: 타부서문서함 권한 삭제
-- 테스트: EXEC  UP_DELETE_WF_ACL_OTHER_DEPT
----------------------------------------------------------------------
-- 수정일: 
-- 수정자: 
-- 수정내용 : 
----------------------------------------------------------------------
----------------------------------------------------------------------
CREATE   Procedure [dbo].[UP_DELETE_WF_ACL]
	/* Param List */
	
	@intUserId			int,
	@intDeptId			int,
	@cUserType			Char(1)
	
AS
	DELETE 
	FROM	eWFFORM.dbo.WF_ACL_OTHER_DEPT
	WHERE	USERID = @intUserId AND DEPTID = @intDeptId AND USER_TYPE = @cUserType
	
	DELETE 
	FROM	eWFFORM.dbo.Wf_ACL_SPECIAL_FOLDER
	WHERE	USERID = @intUserId AND DEPTID = @intDeptId AND USER_TYPE = @cUserType
	
	DELETE 
	FROM	eWFFORM.dbo.WF_ACL_SUBDEPT
	WHERE	USERID = @intUserId AND DEPTID = @intDeptId AND USER_TYPE = @cUserType
	
	DELETE 
	FROM	eWFFORM.dbo.WF_ACL_FORM_LINE
	WHERE	USERID = @intUserId AND DEPTID = @intDeptId AND USER_TYPE = @cUserType
RETURN



GO
/****** Object:  StoredProcedure [dbo].[UP_DELETE_WF_ACL_GROUP]    Script Date: 2015-10-15 오후 1:30:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
----------------------------------------------------------------------
----------------------------------------------------------------------
-- 작성자: 신상훈
-- 작성일: 2004.03.19
-- 수정일: 2004.03.19
-- 설  명: 타부서문서함 권한 삭제
-- 테스트: EXEC  UP_DELETE_WF_ACL_OTHER_DEPT 'W1'
----------------------------------------------------------------------
-- 수정일: 
-- 수정자: 
-- 수정내용 : 
----------------------------------------------------------------------
----------------------------------------------------------------------
CREATE Procedure [dbo].[UP_DELETE_WF_ACL_GROUP]
	/* Param List */
	
	
	@vcGroupCode	varchar(4)
	
AS
	DELETE 
	FROM	eWFFORM.dbo.WF_ACL_GROUP
	WHERE	GROUP_CODE = @vcGroupCode

GO
/****** Object:  StoredProcedure [dbo].[UP_DELETE_WF_ACL_OTHER_DEPT]    Script Date: 2015-10-15 오후 1:30:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
----------------------------------------------------------------------
----------------------------------------------------------------------
-- 작성자: 신상훈
-- 작성일: 2004.03.19
-- 수정일: 2004.03.19
-- 설  명: 타부서문서함 권한 삭제
-- 테스트: EXEC  UP_DELETE_WF_ACL_OTHER_DEPT
----------------------------------------------------------------------
-- 수정일: 
-- 수정자: 
-- 수정내용 : 
----------------------------------------------------------------------
----------------------------------------------------------------------
CREATE Procedure [dbo].[UP_DELETE_WF_ACL_OTHER_DEPT]
	/* Param List */
	
	@intUserId			int,
	@intDeptId			int,
	@cUserType			Char(1)
	
AS
	DELETE 
	FROM	eWFFORM.dbo.WF_ACL_OTHER_DEPT
	WHERE	USERID = @intUserId AND DEPTID = @intDeptId AND USER_TYPE = @cUserType
	
RETURN

GO
/****** Object:  StoredProcedure [dbo].[UP_DELETE_WF_ACL_SPECIAL_FOLDER]    Script Date: 2015-10-15 오후 1:30:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
----------------------------------------------------------------------
----------------------------------------------------------------------
-- 작성자: 신상훈
-- 작성일: 2004.03.19
-- 수정일: 2004.03.19
-- 설  명: 특정권한문서함 삭제
-- 테스트: EXEC  UP_DELETE_WF_ACL_SPECIAL_FOLDER
----------------------------------------------------------------------
-- 수정일: 
-- 수정자: 
-- 수정내용 : 
----------------------------------------------------------------------
----------------------------------------------------------------------
CREATE Procedure [dbo].[UP_DELETE_WF_ACL_SPECIAL_FOLDER]
	/* Param List */
	
	@intUserId			int,
	@intDeptId			int,
	@cUserType			Char(1)
	
AS
	DELETE 
	FROM	eWFFORM.dbo.Wf_ACL_SPECIAL_FOLDER
	WHERE	USERID = @intUserId AND DEPTID = @intDeptId AND USER_TYPE = @cUserType
	
RETURN

GO
/****** Object:  StoredProcedure [dbo].[UP_DELETE_WF_ACL_SUBDEPT]    Script Date: 2015-10-15 오후 1:30:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
----------------------------------------------------------------------
----------------------------------------------------------------------
-- 작성자: 신상훈
-- 작성일: 2004.03.19
-- 수정일: 2004.03.19
-- 설  명: 타부서문서함 권한 삭제
-- 테스트: EXEC  UP_DELETE_WF_ACL_SUBDEPT
----------------------------------------------------------------------
-- 수정일: 
-- 수정자: 
-- 수정내용 : 
----------------------------------------------------------------------
----------------------------------------------------------------------
CREATE Procedure [dbo].[UP_DELETE_WF_ACL_SUBDEPT]
	/* Param List */
	
	@intUserId			int,
	@intDeptId			int,
	@cUserType			Char(1)
	
AS
	DELETE 
	FROM	eWFFORM.dbo.WF_ACL_SUBDEPT
	WHERE	USERID = @intUserId AND DEPTID = @intDeptId AND USER_TYPE = @cUserType

GO
/****** Object:  StoredProcedure [dbo].[UP_DELETE_WF_DOC_FOLDER]    Script Date: 2015-10-15 오후 1:30:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- 작성일: 2004.03.10
-- 수정일: 2004.03.10
-- 설  명: 문서함 삭제
-- 테스트: EXEC  UP_DELETE_WF_DOC_FOLDER
----------------------------------------------------------------------
-- 수정일: 
-- 수정자: 
-- 수정내용 : 
----------------------------------------------------------------------
----------------------------------------------------------------------
CREATE Procedure [dbo].[UP_DELETE_WF_DOC_FOLDER]
	/* Param List */	
	
	
	@intDocFolderId		int
	
AS	
	
	/* SET NOCOUNT ON 	*/
	Delete 
	From dbo.Wf_DOC_FOLDER	
	Where DOC_FOLDER_ID = @intDocFolderId
	
RETURN

GO
/****** Object:  StoredProcedure [dbo].[UP_DELETE_WF_FORM_STORAGE]    Script Date: 2015-10-15 오후 1:30:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  PROC [dbo].[UP_DELETE_WF_FORM_STORAGE]	
	@vcProcessID	varchar(33),
	@vcFormID	varchar(33)
AS
----------------------------------------------------------------------
----------------------------------------------------------------------
-- 작성자: 닷넷소프트 김문식
-- 작성일: 2004.03.23
-- 수정일: 2004.03.23
-- 설   명: 저장된 임시 결재문서 목록
-- 테스트 :
-- @vcFormId : YA8F6C070F99844E5BEEBB8307537BC4
-- EXEC dbo.UP_SELECT_FORM_STORAGE 0,1,3, 'YA8F6C070F99844E5BEEBB8307537BC4','',''
----------------------------------------------------------------------
-- 수정일 : 
-- 수정자 : 
-- 수정내용 : 
----------------------------------------------------------------------
----------------------------------------------------------------------
-- <pre-Step : 환경설정>
SET NOCOUNT ON
BEGIN 
	
	DELETE FROM dbo.WF_FORM_STORAGE
	WHERE
		PROCESS_ID = @vcProcessID
	AND
		FORM_ID = @vcFormID
IF @@ERROR <> 0 
	BEGIN
		RAISERROR('데이터삭제중 오류가 발생했습니다.', 16, 1)
             		WITH NOWAIT
		GOTO END_PROC
	END
END
END_PROC:
-- <post-Step : 환경설정>
SET NOCOUNT OFF
RETURN

GO
/****** Object:  StoredProcedure [dbo].[UP_DELETE_WF_NEXT_SIGNER_FOLDERS]    Script Date: 2015-10-15 오후 1:30:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO







CREATE        PROCEDURE [dbo].[UP_DELETE_WF_NEXT_SIGNER_FOLDERS]
(	
	@PROCESS_INSTANCE_OID	VARCHAR(33),	-- 프로세스 인스탄스 OID
	@SIGN_SEQ			INT		-- 현결재자의 결재순번
)
AS
-------------------------------------------------------------------------------------
-- 작성자: 신철호
-- 작성일: 2005.04.11
-- 수정일: 2005.04.11
-- 설명 : 현결재순번 이후 예결함을 삭제한다.
/*
     EXEC dbo.UP_DELETE_WF_NEXT_SIGNER_FOLDERS 'Z91E02970208846B7ABCD61656B09458B', ''
*/
-------------------------------------------------------------------------------------
	--현결재자의 결재상태를 기결재로 변경한다.
-- 	UPDATE dbo.WF_SIGNER_FOLDER
-- 	SET ACTION_TYPE = '0'	
-- 	WHERE PROCESS_INSTANCE_OID = @PROCESS_INSTANCE_OID
-- 	AND SIGN_SEQ = @SIGN_SEQ

	--이후결재자를 삭제한다.
	DELETE dbo.WF_SIGNER_FOLDER	
	WHERE PROCESS_INSTANCE_OID = @PROCESS_INSTANCE_OID
	AND SIGN_SEQ > @SIGN_SEQ

	





GO
/****** Object:  StoredProcedure [dbo].[UP_DELETE_WF_PROCESS_INSTANCE]    Script Date: 2015-10-15 오후 1:30:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

----------------------------------------------------------------------
----------------------------------------------------------------------
-- 작성자: LDCC 신상훈
-- 작성일: 2004.04.02
-- 수정일: 2004.04.02
-- 설  명: 결재문서 삭제(기능상삭제, 실제로는 DataDate를 UPDATE해줌)
-- 테스트: EXEC dbo.UP_DELETE_WF_PROCESS_INSTANCE 'Y2951AD910FBF4CFCBA00FF00316CACA8'
----------------------------------------------------------------------
-- 수정일 : 
-- 수정자 : 
-- 수정내용 : 
----------------------------------------------------------------------
----------------------------------------------------------------------
CREATE   PROC [dbo].[UP_DELETE_WF_PROCESS_INSTANCE]
    @vcProcessId	    varchar(33)    
AS
	UPDATE	eWF.dbo.PROCESS_INSTANCE
	SET		DELETE_DATE = getDate()
	WHERE	OID = @vcProcessId


GO
/****** Object:  StoredProcedure [dbo].[UP_DELETE_WORK_ITEM_STATE]    Script Date: 2015-10-15 오후 1:30:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE	PROCEDURE [dbo].[UP_DELETE_WORK_ITEM_STATE]
	@vcOID		VARCHAR(50), -- 프로세스 ID
	@vcDFType	VARCHAR(5)
AS
/*-------------------------------------------------------------------------------------
-- 작성자: 마성옥
-- 작성일: 2004.06.04
-- 수정일: 2004.06.05
-- 설명 : 결재자 WORK_ITEM 상태삭제(사실은 변경)
-- 
-- 실행순서
--     1.WORK_ITEM 테이블의 DELETE_DATE 필드를 업데이트 한다.
--     2.PROCESS_INSTANCE 테이블의 DELETE_DATE 필드를 업데이트 한다.
--     (WORK_ITEM 테이블에서 OID를 조건으로 PROCESS_INSTNACE_OID 를 가져와 이를 PROCESS_INSTANCE 테이블의 OID와 비교한다)

select	*
from	ewf.dbo.work_item
WHERE	PARTICIPANT_NAME = '부서합의'
ORDER BY process_instance_oid
where	process_instance_oid = 'Z1731235FF4354BC1AE6BD0AC3319318A'

SELECT	*
FROM	EWF.DBO.PROCESS_INSTANCE
WHERE	OID = 'Z1731235FF4354BC1AE6BD0AC3319318A'

SELECT	*
FROM	EWF.DBO.WORK_ITEM
WHERE	PROCESS_INSTANCE_OID = 'Z1731235FF4354BC1AE6BD0AC3319318A'
ORDER BY CREATE_DATE

SELECT	*
FROM	EWF.DBO.PROCESS_INSTANCE
WHERE	PARENT_OID = 'Z1731235FF4354BC1AE6BD0AC3319318A'

SELECT	process_instance_oid
FROM	EWF.DBO.WORK_ITEM
WHERE	OID = 'Z840D714DAE0D43DC9DE5F7E82F38E522'


-------------------------------------------------------------------------------------*/

IF (@vcDFType != 'ST')
BEGIN

	-- 1.WORK_ITEM 테이블의 DELETE_DATE 필드를 업데이트 한다.
	UPDATE	eWF.dbo.WORK_ITEM
	SET		DELETE_DATE = GETDATE()
	WHERE	OID = @vcOID

/*
	--	 기안자가 삭제하는 경우 문서전체 삭제
	DECLARE	@wProcess_Instance_OID			CHAR(33)

	SELECT	@wProcess_Instance_OID = PROCESS_INSTANCE_OID
	FROM	eWF.dbo.WORK_ITEM
	WHERE	OID = @vcOID

	IF	EXISTS	(SELECT	1	FROM	eWF.dbo.WORK_ITEM	WHERE	OID = @vcOID	AND	NAME LIKE '%기안%')
	BEGIN

		UPDATE	eWF.dbo.PROCESS_INSTANCE
		SET		DELETE_DATE = GETDATE()
		WHERE	OID = @wProcess_Instance_OID

--		DROP	TABLE	#Process_Instance_OID_CHILD
		SELECT	OID
		INTO	#Process_Instance_OID_CHILD
		FROM	eWF.dbo.PROCESS_INSTANCE
		WHERE	PARENT_OID = @wProcess_Instance_OID

		UPDATE	P
		SET		P.DELETE_DATE = GETDATE()
--		SELECT	*
		FROM	eWF.dbo.PROCESS_INSTANCE P
				JOIN	#Process_Instance_OID_CHILD C
					ON	C.OID = P.OID
	END
*/

	-- 2.PROCESS_INSTANCE 테이블의 DELETE_DATE 필드를 업데이트 한다.-2004년12월10일 수정사항 사용자는 ROCESS_INSTANCE 테이블의 DELETE_DATE 필드를 업데이트 하지 않는다(남형훈)
	-- (WORK_ITEM 테이블에서 OID를 조건으로 PROCESS_INSTNACE_OID 를 가져와 이를 PROCESS_INSTANCE 테이블의 OID와 비교한다)
	--UPDATE eWF.dbo.PROCESS_INSTANCE
	--SET DELETE_DATE = GETDATE()
	--WHERE OID = (SELECT PROCESS_INSTANCE_OID FROM eWF.dbo.WORK_ITEM WHERE OID = @vcOID)

END
ELSE
BEGIN

	-- 임시보관함 삭제(업데이트)	
	UPDATE eWFFORM.dbo.WF_FORM_STORAGE
	SET DELETE_DATE = GETDATE()
	WHERE PROCESS_ID = @vcOID
		
END



GO
/****** Object:  StoredProcedure [dbo].[UP_DELETESINGLE_FORMCOLUMN]    Script Date: 2015-10-15 오후 1:30:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UP_DELETESINGLE_FORMCOLUMN]
(
		@vcformId			VARCHAR(33),
		@vcfieldId			VARCHAR(33)
)
AS 
	DELETE dbo.WF_FORM_INFORM 
	WHERE FIELD_ID  = @vcfieldId AND FORM_ID = @vcformId
RETURN

GO
/****** Object:  StoredProcedure [dbo].[UP_GETFOLDERREAD_SELECT]    Script Date: 2015-10-15 오후 1:30:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  PROCEDURE [dbo].[UP_GETFOLDERREAD_SELECT]
	(
		@PFolderID varchar(20),
		@ClassCode varchar(20)
	)
AS
	/* SET NOCOUNT ON */
		SELECT FolderID,ClassCode,FolderName,FolderType,Depth,ParentFolderID,HasSubFolder,Description 
		FROM    dbo.Wf_FOLDER (NOLOCK) 
		WHERE ParentFolderID=@PFolderID AND ClassCode= @ClassCode
		AND DeleteDate is null             
		AND FolderType IN ('A')
		ORDER BY FolderName
RETURN 

GO
/****** Object:  StoredProcedure [dbo].[UP_GETFOLDERTYPE_SELECT]    Script Date: 2015-10-15 오후 1:30:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UP_GETFOLDERTYPE_SELECT]
/*
	(
		@parameter1 datatype = default value,
		@parameter2 datatype OUTPUT
	)
*/
AS
	/* SET NOCOUNT ON */
	SELECT 
		FolderType, 
		TypeName 
    FROM 
		dbo.Wf_FOLDER_TYPE (NOLOCK)
    Where 
		FOLDERTYPE <> 'C' AND 
		FOLDERTYPE <> 'D' AND
		FOLDERTYPE <> 'E'
    ORDER BY 
		FolderType
	RETURN 

GO
/****** Object:  StoredProcedure [dbo].[UP_GETHEADERREAD_SELECT]    Script Date: 2015-10-15 오후 1:30:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UP_GETHEADERREAD_SELECT]
	(
		@formId varchar(33)
	)
AS
	--DECLARE		@form_Id		varchar(33)
	/* SET NOCOUNT ON */
	--SET @form_Id = (SELECT Form_Id FROM WF_FOLDER_DETAIL (NOLOCK) WHERE folderId = @folderId)
	
	SELECT Classification, Form_Name, Form_eName, Def_OID, Current_Forms, Form_DESC
	FROM WF_FORMS (NOLOCK) WHERE Form_Id = @formId
RETURN 

GO
/****** Object:  StoredProcedure [dbo].[UP_GETPROCESSDEF_SELECT]    Script Date: 2015-10-15 오후 1:30:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UP_GETPROCESSDEF_SELECT]
AS
	/* SET NOCOUNT ON */
	SELECT oId, Name, Description, Create_Date, Author, Version, Revision, 
		Valid_From_Date, Valid_To_Date, Classification, Priority, State, Current_Process
	FROM PROCESS (NOLOCK)
RETURN 

GO
/****** Object:  StoredProcedure [dbo].[UP_GETRECEIVERLIST_SELECT]    Script Date: 2015-10-15 오후 1:30:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
----------------------------------------------------------------------
----------------------------------------------------------------------
-- 작성자: 박재용
-- 작성일: 2004.03.10
-- 수정일: 2004.03.11
-- 설  명: 협조처 정보 조회
-- 테스트: EXEC UP_GETRECEIVERLIST_SELECT '10007'
----------------------------------------------------------------------
-- 수정일 : 
-- 수정자 : 
-- 수정내용 : 
----------------------------------------------------------------------
----------------------------------------------------------------------
CREATE   PROCEDURE [dbo].[UP_GETRECEIVERLIST_SELECT]
(
	@intUSERID	int
)
AS
	SELECT ID, SIGNLISTNAME, SIGNINFORM, SIGNERLIST
	FROM dbo.WF_SIGNER_LIST(NOLOCK)
	WHERE USERID = @intUSERID  AND LISTTYPE = 'M'	
	RETURN

GO
/****** Object:  StoredProcedure [dbo].[UP_GETRECVINFO_SELECT]    Script Date: 2015-10-15 오후 1:30:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  PROC [dbo].[UP_GETRECVINFO_SELECT]
	@varID varchar(33)
AS
--------------------------------------------------------
-- 작성자 : 박재용
-- 작성일 : 2004.03.12
-- 수정일 : 2004.03.12
-- 설  명 :  협조처 정보 Select
--------------------------------------------------------
SET NOCOUNT ON
 SELECT   SIGNINFORM, SIGNERLIST
  FROM dbo.Wf_SIGNER_LIST(NOLOCK)
 WHERE ID = @varID

GO
/****** Object:  StoredProcedure [dbo].[UP_HASSUBFOLDER_SELECT]    Script Date: 2015-10-15 오후 1:30:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UP_HASSUBFOLDER_SELECT]
	(
		@parentFolderId varchar(20)
	)
AS
	/* SET NOCOUNT ON */
	
	SELECT  COUNT(*) totalCount
	FROM    dbo.Wf_FOLDER  (NOLOCK) 
	WHERE   ParentFolderID = @parentFolderID
	RETURN 

GO
/****** Object:  StoredProcedure [dbo].[UP_INITIALIZE]    Script Date: 2015-10-15 오후 1:30:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO








CREATE                    Procedure [dbo].[UP_INITIALIZE]
AS
-------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------
-- 작성자: 신철호
-- 작성일: 2004.09.16
-- 수정일: 2004.09.16
-- 설   명: eWF,eWFForm데이터베이스 초기화
-------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------
/*


SET NOCOUNT ON

----------------------------------------------------------
-- eWF.net V2 Workflow Engine Table Schema
----------------------------------------------------------
TRUNCATE TABLE eWF.dbo.V_ROLE_PARTICIPANT
TRUNCATE TABLE eWF.dbo.WORK_ITEM

TRUNCATE TABLE eWF.dbo.TRANSITION_INSTANCE

TRUNCATE TABLE eWF.dbo.ACTIVITY_ATTRIBUTE
TRUNCATE TABLE eWF.dbo.ACTIVITY_PARTICIPANT
DELETE FROM eWF.dbo.ACTIVITY_INSTANCE



TRUNCATE TABLE eWF.dbo.WORKITEM_SIGN_INFORM
TRUNCATE TABLE eWF.dbo.PROCESS_INSTANCE_FILE
TRUNCATE TABLE eWF.dbo.MONITORING
TRUNCATE TABLE eWF.dbo.PROCESS_SIGN_INFORM
TRUNCATE TABLE eWF.dbo.PROCESS_ATTRIBUTE
DELETE FROM eWF.dbo.PROCESS_INSTANCE

TRUNCATE TABLE eWF.dbo.ENGINE_APPROVAL


----------------------------------------------------------
-- eWF.net V2 Workflow Form Table Schema
----------------------------------------------------------
TRUNCATE TABLE eWFFORM.dbo.WF_FORMS_PROP 		-- 결재문서 속성
TRUNCATE TABLE eWFFORM.dbo.WF_FORM_REFERENCE 	-- 관련근거문서
TRUNCATE TABLE eWFFORM.dbo.WF_DBAPPROVAL 		-- DB연동결재
TRUNCATE TABLE eWFFORM.dbo.WF_SIGNER_FOLDER	-- 예결함



TRUNCATE TABLE eWFFORM.dbo.WF_FORM_STORAGE 	-- 임시저장


TRUNCATE TABLE eWFFORM.dbo.WF_ACL_OTHER_DEPT 	-- 타부서 문서함 권한
TRUNCATE TABLE eWFFORM.dbo.WF_ACL_SPECIAL_FOLDER 	-- 특정문서함 권한
TRUNCATE TABLE eWFFORM.dbo.WF_ACL_SUBDEPT 		-- 하위부서 권한
TRUNCATE TABLE eWFFORM.dbo.WF_SIGNER_LIST 		-- 개인결재선
TRUNCATE TABLE eWFFORM.dbo.WF_CONFIG_USER 		-- 개인환경설정






----------------------------------------------------------
-- 결재양식 초기화
----------------------------------------------------------
select * from eWFFORM.dbo.WF_Forms

TRUNCATE TABLE eWFFORM.dbo.FORM_Y44710705C8854F839AB58B893F196959		-- 일반휴가신청서
TRUNCATE TABLE eWFFORM.dbo.FORM_Y747BB57D3D334E53A0CA83F8BE4E379C	-- 변동예산신청서
TRUNCATE TABLE eWFFORM.dbo.FORM_YAE7EEC57433B4884AAC95B65128C3F0A	-- 거래선지원품의서
TRUNCATE TABLE eWFFORM.dbo.FORM_Y72AEB236B04E460FA3B81DAB9125D58E	-- 비품신청서
TRUNCATE TABLE eWFFORM.dbo.FORM_Y00651F8C793843BDB04C6DB25765FB41	--  전산처리의뢰서
TRUNCATE TABLE eWFFORM.dbo.FORM_YB79B69046B8A4AD396C1025A54A0DDB7	-- 인수증(지점용)
TRUNCATE TABLE eWFFORM.dbo.FORM_YAF16026C92BE458B889161598FD61B6B		-- 업무협조전
TRUNCATE TABLE eWFFORM.dbo.FORM_YED6DBAA11E71447B8875EB014623F2AD	-- 기안서
TRUNCATE TABLE eWFFORM.dbo.FORM_Y4C851AEE0EF94F128186BEB3A9111638		-- 판촉물신청서
TRUNCATE TABLE eWFFORM.dbo.FORM_YD4E2525FC2A948A1A5246B620E144734		-- 인수증(영업부용) 
TRUNCATE TABLE eWFFORM.dbo.FORM_YAE2F85A901AF4B43BC6906EF06C8DB83	-- 업무연락
TRUNCATE TABLE eWFFORM.dbo.FORM_Y916C53AF4A1B45C3A2E5110227D8530B		-- 전산소모품신청서
TRUNCATE TABLE eWFFORM.dbo.FORM_Y97D6742FAE98424D94B34107A1B900D1		-- 휴가원
TRUNCATE TABLE eWFFORM.dbo.FORM_Y7E5B0FAAB0674180B1172BA02147A81E		-- 입학축의금신청서
TRUNCATE TABLE eWFFORM.dbo.FORM_YBD2CE44674A7484ABCD9A4E72DAF77A7	-- 콘도이용신청서
TRUNCATE TABLE eWFFORM.dbo.FORM_Y54CFE93E9F684353B8861A1B4644EAEE		-- 판매용장비신청서
TRUNCATE TABLE eWFFORM.dbo.FORM_YD41B811540164160AD28E5655DB2A2AC	-- 테스트
TRUNCATE TABLE eWFFORM.dbo.FORM_YA97EEB2C70C141EDA9A553E0135C7A0C	-- 항목변경신청서
TRUNCATE TABLE eWFFORM.dbo.FORM_Y8D91E86CF319474BB4CB15B23F76C0A6	-- 판촉물신청서
TRUNCATE TABLE eWFFORM.dbo.FORM_YB8260780E3D44144AD24B38163F5AF88		-- 출고반납의뢰서



--로그삭제 
BACKUP LOG eWF with NO_LOG


--로그파일 사이즈 감소
DBCC SHRINKDATABASE (eWF ,TRUNCATEONLY)


--로그삭제 

BACKUP LOG eWFFORM with NO_LOG

--로그파일 사이즈 

DBCC SHRINKDATABASE (eWFFORM,TRUNCATEONLY)

*/



select count(*) from process_instance(nolock)









GO
/****** Object:  StoredProcedure [dbo].[UP_INSERT_DBAPPROVAL]    Script Date: 2015-10-15 오후 1:30:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE         PROCEDURE [dbo].[UP_INSERT_DBAPPROVAL]
(
	@PROCESS_ID			CHAR(33),	-- 프로세스 ID
	@GUBUN			CHAR(2),	-- 회사구분
	@MODULEID			CHAR(10),	-- ERP모듈ID
	@OBJECTID			VARCHAR(200),	-- ERP키값
	@APPROVALSTATUS		CHAR(1),	-- 결재상태
	@DOCTYPE			VARCHAR(200)	-- ERP키값	
)
AS
-------------------------------------------------------------------------------------
-- 작성자: 신철호
-- 작성일: 2004.09.06
-- 수정일: 2004.09.06
-- 설명 : DB결재문서속성을 내역을 등록한다.
-------------------------------------------------------------------------------------
	INSERT INTO dbo.WF_DBAPPROVAL (PROCESS_ID, GUBUN, MODULEID, OBJECTID, APPROVALSTATUS, DOCTYPE)
	VALUES (@PROCESS_ID, @GUBUN, @MODULEID, @OBJECTID, @APPROVALSTATUS, @DOCTYPE)

	INSERT INTO dbo.WF_DBAPPROVAL_LOG (PROCESS_ID, GUBUN, MODULEID, OBJECTID, APPROVALSTATUS, DOCTYPE)
	VALUES (@PROCESS_ID, @GUBUN, @MODULEID, @OBJECTID, @APPROVALSTATUS, @DOCTYPE)


GO
/****** Object:  StoredProcedure [dbo].[UP_INSERT_FORM_REFERENCE]    Script Date: 2015-10-15 오후 1:30:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UP_INSERT_FORM_REFERENCE]
(
	@PROCESS_ID		VARCHAR(50),
	@REF_PROCESS_ID	VARCHAR(50)
)
AS
-------------------------------------------------------------------------------------
-- 작성자: 임병태
-- 작성일: 2004.05.21
-- 수정일: 2004.05.21
-- 설명 : 관련근거 문서 내용을 등록한다.
-------------------------------------------------------------------------------------
	INSERT INTO dbo.WF_FORM_REFERENCE (PROCESS_ID, REF_PROCESS_ID)
		VALUES(@PROCESS_ID, @REF_PROCESS_ID)
		

GO
/****** Object:  StoredProcedure [dbo].[UP_INSERT_FORM_STORAGE]    Script Date: 2015-10-15 오후 1:30:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  PROCEDURE [dbo].[UP_INSERT_FORM_STORAGE]
(
	@vcPROCESS_ID			VARCHAR(50),	-- 결재 프로세스 ID
	@vcFORM_ID			VARCHAR(50),	-- 양식 폼 ID
	@vcSUBJECT			VARCHAR(500),	-- 제목
	@nUSERID			INT,			-- 사용자 ID
	@nDEPTID			INT,			-- 부서 ID
	@vcDESCRIPTION			VARCHAR(2000),	-- 저장 사유
	@tSIGN_CONTEXT		TEXT	-- 임시저장 결재선
) 
----------------------------------------------------
-- 작성자: 임병태
-- 작성일: 2004.04.07
-- 수정일: 2004.04.07
-- 설명 : 결재문서를 임시저장 원부에 헤더 정보를 저장한다.
----------------------------------------------------
AS
	INSERT INTO WF_FORM_STORAGE (PROCESS_ID, FORM_ID, SUBJECT, USERID, DEPTID, DESCRIPTION, CREATE_DATE,SIGN_CONTEXT)
	VALUES (@vcPROCESS_ID, @vcFORM_ID, @vcSUBJECT, @nUSERID, @nDEPTID, @vcDESCRIPTION, GETDATE(),@tSIGN_CONTEXT)

GO
/****** Object:  StoredProcedure [dbo].[UP_INSERT_FORMCOLUMN]    Script Date: 2015-10-15 오후 1:30:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 CREATE PROCEDURE [dbo].[UP_INSERT_FORMCOLUMN]
	(
		@vcformId			VARCHAR(33)
	)
AS 
	INSERT INTO dbo.WF_FORM_INFORM 
	(
		FORM_ID, 
		FIELD_ID, 
		FIELD_NAME, 
		FIELD_LABEL, 
		FIELD_TYPE, 
		FIELD_LENGTH, 
		FIELD_DEFAULT
	) 
	Select 
		@vcFormId, 
		FIELD_ID, 
		FIELD_NAME, 
		FIELD_LABEL, 
		FIELD_TYPE, 
		FIELD_LENGTH, 
		FIELD_DEFAULT 
	FROM dbo.WF_FORM_DEFAULT_FIELD
	
RETURN

GO
/****** Object:  StoredProcedure [dbo].[UP_INSERT_FORMDEFAULTFIELD]    Script Date: 2015-10-15 오후 1:30:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
   CREATE 
PROCEDURE [dbo].[UP_INSERT_FORMDEFAULTFIELD]
         (@vcFIELD_NAME    VARCHAR(30) = ''
         ,@cFIELD_CLASS       CHAR( 1) = ''
         ,@vcFIELD_LABEL   VARCHAR(30) = ''
         ,@vcFIELD_TYPE    VARCHAR(30) = ''
         ,@dFIELD_LENGTH   DECIMAL( 9) = -1
         ,@vcFEILD_DEFAULT VARCHAR(50)
         )
       AS 
-- <pre-Step : 환경설정>
SET NOCOUNT ON
-- <Step-0-0 : 파라미터 확인>
IF(@vcFIELD_NAME='' OR @cFIELD_CLASS='' OR @vcFIELD_LABEL='' OR
   @vcFIELD_TYPE='' OR @dFIELD_LENGTH<0) BEGIN
    RAISERROR('필수 파라미터가 부족합니다.[EC0]', 16, 1)
         WITH NOWAIT
    GOTO END_PROC
END
-- <Step-1-0 : 데이터 존재 확인>
IF EXISTS(SELECT * 
            FROM Wf_FORM_DEFAULT_FIELD (NOLOCK)
           WHERE FIELD_NAME = @vcFIELD_NAME) BEGIN
    RAISERROR('이미존재하는데이터입니다.[EC1]', 16, 1)
         WITH NOWAIT
    GOTO END_PROC
END
-- <Step-1-1 : 데이터 입력>
INSERT
  INTO Wf_FORM_DEFAULT_FIELD
      (FIELD_ID, FIELD_NAME,   FIELD_CLASS,   FIELD_LABEL,
       FIELD_TYPE,   FIELD_LENGTH,  FIELD_DEFAULT)
VALUES('Y' +  REPLACE(NEWID(), '-', ''), @vcFIELD_NAME,  @cFIELD_CLASS,  @vcFIELD_LABEL,
       @vcFIELD_TYPE,  @dFIELD_LENGTH, @vcFEILD_DEFAULT)
IF @@ERROR <> 0 BEGIN
    RAISERROR('데이터입력작업중 오류가 발생했습니다.[EI1]', 16, 1)
         WITH NOWAIT
    GOTO END_PROC
END
END_PROC:
-- <post-Step : 환경설정>
SET NOCOUNT OFF
RETURN

GO
/****** Object:  StoredProcedure [dbo].[UP_INSERT_FORMS_PROP]    Script Date: 2015-10-15 오후 1:30:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE   PROCEDURE [dbo].[UP_INSERT_FORMS_PROP]
(
	@PROCESS_ID			VARCHAR(50),	-- 프로세스 ID
	@FORM_ID			VARCHAR(50),	-- 폼 ID
	@INNERHTML			TEXT,			-- 문서내용
	@KEEP_YEAR			VARCHAR(50),	-- 보존연한
	@DOC_LEVEL			VARCHAR(50),	-- 문서등급
	@DOC_NAME			VARCHAR(50),	-- 문서명
	@SUBJECT			VARCHAR(500),	-- 문서제목
	@ISATTACHFILE		VARCHAR(50),	-- 첨부파일 여부
	@DOC_NUMBER			VARCHAR(100),	-- 문서번호
	@ADMISSION_QTY			VARCHAR(100),	-- 수량(판촉물신청서)
	@STATUS				VARCHAR(10),	-- 상태
	@ISURGENT			VARCHAR(10),	-- 긴급문서 여부
	@POSTSCRIPT			VARCHAR(10),	-- 첨언 여부
	@REF_DOC			VARCHAR(10),	-- 관련문서 존재여부
	@ATTACH_EXTENSION	VARCHAR(300)	-- 첨부파일 확장자 내역
)
AS
-------------------------------------------------------------------------------------
-- 작성자: 임병태
-- 작성일: 2004.04.21
-- 수정일: 2004.04.21
-- 설명 : 문서속성을 내역을 등록한다.
-------------------------------------------------------------------------------------
	INSERT INTO dbo.WF_FORMS_PROP (PROCESS_ID, FORM_ID, INNERHTML, KEEP_YEAR, DOC_LEVEL, DOC_NAME, SUBJECT, ISATTACHFILE, DOC_NUMBER, ADMISSION_QTY, STATUS, ISURGENT, POSTSCRIPT, REF_DOC, ATTACH_EXTENSION)
	VALUES (@PROCESS_ID, @FORM_ID, @INNERHTML, @KEEP_YEAR, @DOC_LEVEL, @DOC_NAME, @SUBJECT, @ISATTACHFILE, @DOC_NUMBER, @ADMISSION_QTY, @STATUS, @ISURGENT, @POSTSCRIPT, @REF_DOC, @ATTACH_EXTENSION)

----INSERT INTO dbo.WF_FORMS_PROP (PROCESS_ID, FORM_ID, INNERHTML, KEEP_YEAR, DOC_LEVEL, DOC_NAME, SUBJECT, ISATTACHFILE, DOC_NUMBER,  STATUS, ISURGENT, POSTSCRIPT, REF_DOC, ATTACH_EXTENSION)
	--VALUES (@PROCESS_ID, @FORM_ID, @INNERHTML, @KEEP_YEAR, @DOC_LEVEL, @DOC_NAME, @SUBJECT, @ISATTACHFILE, @DOC_NUMBER,  @STATUS, @ISURGENT, @POSTSCRIPT, @REF_DOC, @ATTACH_EXTENSION)



GO
/****** Object:  StoredProcedure [dbo].[UP_Insert_Signer_Comment]    Script Date: 2015-10-15 오후 1:30:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE	Procedure	[dbo].[UP_Insert_Signer_Comment]
		@pProcessID		char(33),
		@pWorkItemOID	char(33),
		@pComment		varchar(1000)
As

/*----------------------------------------------------
-- 작성자: 신철호
-- 작성일: 2004.03.05
-- 수정일: 2004.03.05
-- 설명 : 결재자정보를 추가한다
select	*	from	dbo.WF_Signer_Comment
update	dbo.WF_Signer_Comment
set		comment = replace(comment, '결재자', '!@결재자!@')
where	process_instance_oid = 'ZBB38CC59F3DD417CAFD0C1478821BEAB'


exec UP_Insert_Signer_Comment 'ZADCCB8A7FEE1493C8C5EB7CAA3C28348', 'ZADCCB8A7FEE1493C8C5EB7CAA3C28348', '키키키!@키키키!@키키키'
----------------------------------------------------*/

Set	Nocount On

--	If	@pComment <> ''

		Insert	Into	dbo.WF_Signer_Comment
				(Process_Instance_OID,		Work_Item_OID,	Comment,	CreateDate)
			Values
				(@pProcessID,				@pWorkItemOID,	Replace(@pComment, '"', '!@'),	GetDate())


GO
/****** Object:  StoredProcedure [dbo].[UP_INSERT_WF_ACL_FORMLINE]    Script Date: 2015-10-15 오후 1:30:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


----------------------------------------------------------------------
----------------------------------------------------------------------
-- 작성자: 신상훈
-- 작성일: 2004.10.18
-- 수정일: 2004.10.18
-- 설  명: 양식결재선 권한 추가
-- 테스트: EXEC  UP_INSERT_WF_ACL_FORMLINE
----------------------------------------------------------------------
-- 수정일: 2004.10.18 
-- 수정자: 신상훈
-- 수정내용 : DB스키마 변경으로 인한 변수이름 변경
----------------------------------------------------------------------
----------------------------------------------------------------------


CREATE   Procedure [dbo].[UP_INSERT_WF_ACL_FORMLINE]

	/* Param List */
	
	@intUserId			int,
	@intDeptId			int,
	@cUserType			Char(1),
	@cAclId			Char(1)	
	
AS

	INSERT INTO eWFFORM.dbo.WF_ACL_FORM_LINE(USERID, DEPTID, USER_TYPE, ACLID)
	VALUES (@intUserId, @intDeptId, @cUserType, @cAclId)

RETURN


GO
/****** Object:  StoredProcedure [dbo].[UP_INSERT_WF_ACL_GROUP]    Script Date: 2015-10-15 오후 1:30:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
----------------------------------------------------------------------
----------------------------------------------------------------------
-- 작성자: 신상훈
-- 작성일: 2004.05.20
-- 수정일: 2004.05.20
-- 설   명: 그룹권한 추가
-- 테스트: EXEC  UP_INSERT_WF_ACL_GROUP
----------------------------------------------------------------------
-- 수정일:
-- 수정자:
-- 수정내용 :
----------------------------------------------------------------------
----------------------------------------------------------------------
CREATE PROCEDURE [dbo].[UP_INSERT_WF_ACL_GROUP]
	/* Param List */
	
	@vcGroupCode		varchar(4),
	@cDocLevel		char(1)
	
AS
DECLARE
	@vcGroupType		varchar(4)
SET	@vcGroupType = 'JW'
	INSERT INTO eWFFORM.dbo.Wf_ACL_GROUP(GROUP_CODE, DOC_LEVEL, GROUP_TYPE)
	VALUES (@vcGroupCode, @cDocLevel, @vcGroupType)
RETURN

GO
/****** Object:  StoredProcedure [dbo].[UP_INSERT_WF_ACL_OTHER_DEPT]    Script Date: 2015-10-15 오후 1:30:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
----------------------------------------------------------------------
----------------------------------------------------------------------
-- 작성자: 신상훈
-- 작성일: 2004.03.08
-- 수정일: 2004.03.08
-- 설  명: 타부서문서함 조회권한 추가
-- 테스트: EXEC  UP_INSERT_WF_ACL_OTHER_DEPT
----------------------------------------------------------------------
-- 수정일: 2004.03.18 
-- 수정자: 신상훈
-- 수정내용 : DB스키마 변경으로 인한 변수이름 변경
----------------------------------------------------------------------
----------------------------------------------------------------------
CREATE Procedure [dbo].[UP_INSERT_WF_ACL_OTHER_DEPT]
	/* Param List */
	
	@intUserId			int,
	@intDeptId			int,
	@intOtherDeptId		int,
	@intDocFolderId		int,
	@cUserType			Char(1),
	@cAclId				Char(1)
	
AS
	INSERT INTO eWFFORM.dbo.Wf_ACL_OTHER_DEPT(USERID, DEPTID, OTHER_DEPTID, DOC_FOLDER_ID, USER_TYPE, ACLID)
	VALUES (@intUserId, @intDeptId, @intOtherDeptId, @intDocFolderId, @cUserType, @cAclId)
RETURN

GO
/****** Object:  StoredProcedure [dbo].[UP_INSERT_WF_ACL_SPECIAL_FOLDER]    Script Date: 2015-10-15 오후 1:30:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

----------------------------------------------------------------------
----------------------------------------------------------------------
-- 작성자: 신상훈
-- 작성일: 2004.03.08
-- 수정일: 2004.03.08
-- 설  명: 특정권한문서함 추가
-- 테스트: 
/*
EXEC  UP_INSERT_WF_ACL_SPECIAL_FOLDER 10007, 10007,9,'P','Y'


truncate table eWFFORM.dbo.Wf_ACL_SPECIAL_FOLDER

select * from eWFFORM.dbo.Wf_ACL_SPECIAL_FOLDER

select * from emanage.dbo.tb_user
where username = '신철호'

select * from emanage.dbo.TB_DEPT
where deptname = 'ewf.net'

*/
----------------------------------------------------------------------
-- 수정일: 2004.03.18 
-- 수정자: 신상훈
-- 수정내용 : DB스키마 변경으로 인한 변수이름 변경
----------------------------------------------------------------------
----------------------------------------------------------------------
CREATE  Procedure [dbo].[UP_INSERT_WF_ACL_SPECIAL_FOLDER]
	/* Param List */
	
	@intUserId			int,
	@intDeptId			int,
	@intDocFolderId		int,
	@cUserType			Char(1),
	@cAclId				Char(1)	
	
AS
	INSERT INTO eWFFORM.dbo.Wf_ACL_SPECIAL_FOLDER(USERID, DEPTID, DOC_FOLDER_ID, USER_TYPE, ACLID) 
	VALUES (@intUserId, @intDeptId, @intDocFolderId, @cUserType, @cAclId)
RETURN


GO
/****** Object:  StoredProcedure [dbo].[UP_INSERT_WF_ACL_SUBDEPT]    Script Date: 2015-10-15 오후 1:30:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
----------------------------------------------------------------------
----------------------------------------------------------------------
-- 작성자: 신상훈
-- 작성일: 2004.03.08
-- 수정일: 2004.03.08
-- 설  명: 하위부서문서함 조회권한 추가
-- 테스트: EXEC  UP_INSERT_WF_ACL_SUBDEPT
----------------------------------------------------------------------
-- 수정일: 2004.03.18 
-- 수정자: 신상훈
-- 수정내용 : DB스키마 변경으로 인한 변수이름 변경
----------------------------------------------------------------------
----------------------------------------------------------------------
CREATE Procedure [dbo].[UP_INSERT_WF_ACL_SUBDEPT]
	/* Param List */
	
	@intUserId			int,
	@intDeptId			int,
	@cUserType			Char(1),
	@cAclId			Char(1)	
	
AS
	INSERT INTO eWFFORM.dbo.Wf_ACL_SUBDEPT(USERID, DEPTID, USER_TYPE, ACLID)
	VALUES (@intUserId, @intDeptId, @cUserType, @cAclId)
RETURN

GO
/****** Object:  StoredProcedure [dbo].[UP_INSERT_WF_CONFIG_USER]    Script Date: 2015-10-15 오후 1:30:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

----------------------------------------------------------------------
----------------------------------------------------------------------
-- 작성자: 신상훈
-- 작성일: 2004.04.19
-- 수정일: 2004.04.19
-- 설  명: 사용자 결재환경 입력
-- 테스트: EXEC  UP_INSERT_WF_CONFIG_USER
----------------------------------------------------------------------
----------------------------------------------------------------------
----------------------------------------------------------------------
CREATE  Procedure [dbo].[UP_INSERT_WF_CONFIG_USER]
	/* Param List */
	
	@intUserId			int,
	@intDeptId			int
	
	
AS
	INSERT INTO eWFFORM.dbo.Wf_CONFIG_USER(USERID, DEPTID, NOTICEMAIL, ISABSENT, SIGN_ATTACHID,NOTICEMESSANGER)
	VALUES (@intUserId, @intDeptId, 'N', 'N', 0,'N')
RETURN


GO
/****** Object:  StoredProcedure [dbo].[UP_INSERT_WF_DOC_FOLDER]    Script Date: 2015-10-15 오후 1:30:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
----------------------------------------------------------------------
----------------------------------------------------------------------
-- 작성자: LDCC 신상훈
-- 작성일: 2004.04.02
-- 수정일: 2004.04.02
-- 설   명: 양식별 결재현황 조회
-- 테스트: EXEC dbo.UP_INSERT_WF_DOC_FOLDER 'LDCC','AA','P','상훈맨','G','N'
-- SELECT * FROM dbo.WF_DOC_FOLDER
-- TRUNCATE TABLE dbo.WF_DOC_FOLDER
----------------------------------------------------------------------
-- 수정일 : 
-- 수정자 : 
-- 수정내용 : 
----------------------------------------------------------------------
----------------------------------------------------------------------
CREATE Procedure [dbo].[UP_INSERT_WF_DOC_FOLDER]
	/* Param List */
	
	@strClassCode		VarChar(20),
	@strAprFolderCode	Char(2),
	@strAprFolderType	Char(1),
	@strDocFolderName	VarChar(50),
	@strDocFolderType	Char(1),
	@strUsage_YN		Char(1)
	
AS
DECLARE @intSortKey	int
SET @intSortKey = (SELECT MAX(SORTKEY) FROM dbo.WF_DOC_FOLDER)
 if @intSortKey is null 
begin
	set @intSortKey = 0
end
	INSERT INTO dbo.Wf_DOC_FOLDER(CLASSCODE, APR_FOLDER_ID, APR_FOLDER_TYPE, DOC_FOLDER_NAME, DOC_FOLDER_TYPE, USAGE_YN, SORTKEY) 
	VALUES (@strClassCode, @strAprFolderCode, @strAprFolderType, @strDocFolderName, @strDocFolderType, @strUsage_YN, @intSortKey+1)
RETURN

GO
/****** Object:  StoredProcedure [dbo].[UP_INSERT_WF_DOC_NUMBER]    Script Date: 2015-10-15 오후 1:30:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO







----------------------------------------------------------------------
----------------------------------------------------------------------
-- 작성자 : LDCC 신상훈
-- 작성일 : 2004.09.30
-- 수정일 : 2004.09.30
-- 설   명 : 문서발번
-- 테스트 : 
/*
exec dbo.UP_INSERT_WF_DOC_NUMBER '1167','Z7D9289A3FE8442EEB91189DDC0651F97','YCA3020E01B3845C5BB17651DD2B32731'


 SELECT * FROM eWFFORM.dbo.WF_DOC_NUMBER
 SELECT * FROM dbo.FORM_YCA3020E01B3845C5BB17651DD2B32731 WHERE Subject = '자바스크립트를 빼자'
 truncate table eWFFORM.dbo.WF_DOC_NUMBER







*/

----------------------------------------------------------------------
-- 수정일 : 
-- 수정자 : 
-- 수정내용 : 
----------------------------------------------------------------------
CREATE       PROCEDURE [dbo].[UP_INSERT_WF_DOC_NUMBER]

  @vcCreateDeptId	varchar(10),
  @vcProcessId		varchar(33),
  @vcFormId		varchar(33)

AS


DECLARE 
  @vcDeptKeyWord	varchar(50),	-- 부서약호
  @vcFormKeyWord	varchar(50),	-- 양식약호
  @vcDisplayWord	varchar(50),	-- 결재문서에 뿌려줄 문서번호
  @vcCastNumber		varchar(50),	-- 문서번호를 알맞은 포멧으로 변환
  @intDocNumber		int,		-- 실제 문서번호
  @nvcCountQuery       nvarchar(4000),
  @intChkValue		int

----------------------------------------------------------------------------------------
-- 설    명 : eManage.dbo.TB_DEPT에서 기안부서의 부서약호를 가져온다.
----------------------------------------------------------------------------------------
SET @vcDeptKeyWord = (SELECT DeptKeyWord FROM eManage.dbo.TB_DEPT WHERE DEPTID=@vcCreateDeptId)
SET @vcDeptKeyWord = RTRIM(@vcDeptKeyWord)

----------------------------------------------------------------------------------------
-- 설    명 : dbo.WF_FORMS 에서 해당양식의 양식키워드를 조회한다.
----------------------------------------------------------------------------------------
SET @vcFormKeyWord = (SELECT top 1 FORM_ALIAS FROM dbo.WF_FORMS WHERE FORM_ID = @vcFormId)

SET @vcFormKeyWord = RTRIM(@vcFormKeyWord)


----------------------------------------------------------------------------------------
-- 설    명 : 문서번호를 처음으로 발번하는 지 여부를 체크하고, 첫 발번이면 생성한다.
----------------------------------------------------------------------------------------

SET @intChkValue = (SELECT COUNT(DOC_NUM) FROM eWFFORM.dbo.WF_DOC_NUMBER WHERE DOC_YEAR=DATEPART(yy, getdate()) AND  DOC_KEYWORD = @vcDeptKeyWord AND  FORM_KEYWORD = @vcFormKeyWord)

if @intChkValue = 0
begin
	SET @intDocNumber = 0

	INSERT INTO eWFFORM.dbo.WF_DOC_NUMBER (DOC_YEAR, DOC_KEYWORD, FORM_KEYWORD , DOC_NUM)
	SELECT DATEPART(yy, getdate()), @vcDeptKeyWord, @vcFormKeyWord, @intDocNumber
end
----------------------------------------------------------------------------------------
-- 설    명 : 부서약호에 맞는 문서번호를 가져온다.(최종문서번호 + 1)
----------------------------------------------------------------------------------------
--SET @intDocNumber = (SELECT ISNULL(MAX(DOC_NUM), 0) + 1 FROM eWFFORM.dbo.WF_DOC_NUMBER WHERE DOC_YEAR=DATEPART(yy, getdate()) AND DOC_KEYWORD = @vcDeptKeyWord)
SET @intDocNumber = (SELECT DOC_NUM + 1 FROM eWFFORM.dbo.WF_DOC_NUMBER WHERE DOC_YEAR=DATEPART(yy, getdate()) AND DOC_KEYWORD = @vcDeptKeyWord AND  FORM_KEYWORD = @vcFormKeyWord)


----------------------------------------------------------------------------------------
-- 설    명 : 문서번호를 양식에 뿌려줄 알맞은 포맷(3자리)으로 변환한다.
----------------------------------------------------------------------------------------
if @intDocNumber < 10
begin
SET @vcCastNumber = '00' + cast(@intDocNumber as varchar(50))
end

if @intDocNumber >= 10 AND @intDocNumber < 100
begin
SET @vcCastNumber = '0' + cast(@intDocNumber as varchar(50))
end

if @intDocNumber >= 100
begin
SET @vcCastNumber = cast(@intDocNumber as varchar(50))
end

----------------------------------------------------------------------------------------
-- 설    명 : 결재양식에 최종적으로 뿌려질 문서번호를 구성한다.
----------------------------------------------------------------------------------------	          
SET @vcDisplayWord = @vcDeptKeyWord + '-' + @vcFormKeyWord + '-' + RIGHT(CAST(DATEPART(yy, getdate()) as varchar(50)), 2) + '-' + @vcCastNumber

----------------------------------------------------------------------------------------
-- 설    명 : eWFFORM.dbo.WF_DOC_NUMBER에 넣어준다.
----------------------------------------------------------------------------------------
INSERT INTO eWFFORM.dbo.WF_DOC_NUMBER (DOC_YEAR, DOC_KEYWORD, FORM_KEYWORD, DOC_NUM, DOC_NUM_DISPLAY)
SELECT DATEPART(yy, getdate()), @vcDeptKeyWord, @vcFormKeyWord, @intDocNumber, @vcDisplayWord

----------------------------------------------------------------------------------------
-- 설    명 : 양식테이블에 문서번호 저장
----------------------------------------------------------------------------------------

SET @nvcCountQuery = 	N'	UPDATE eWFFORM.dbo.FORM_' + @vcFormId
+			N'	SET DOC_NUMBER = ''' + @vcDisplayWord + ''''
+			N'	WHERE PROCESS_ID = ''' + @vcProcessId + ''''

exec (@nvcCountQuery)

----------------------------------------------------------------------------------------
-- 설    명 : eWFFORM.dbo.WF_FORMS_PROP에 넣어준다.
----------------------------------------------------------------------------------------
 
SET @nvcCountQuery = 	N'	UPDATE eWFFORM.dbo.WF_FORMS_PROP'
+			N'	SET DOC_NUMBER = ''' + @vcDisplayWord + ''''
+			N'	WHERE PROCESS_ID = ''' + @vcProcessId + ''''
exec (@nvcCountQuery)

DELETE FROM eWFFORM.dbo.WF_DOC_NUMBER 
	WHERE DOC_YEAR = DATEPART(yy, getdate()) 
	AND DOC_KEYWORD = @vcDeptKeyWord 
	AND FORM_KEYWORD = @vcFormKeyWord
	AND DOC_NUM = (@intDocNumber-1)

--  create table #temp(query text)
--  insert into #temp values(@nvcCountQuery)
--  select * from #temp
--  drop table #temp







GO
/****** Object:  StoredProcedure [dbo].[UP_INSERT_WF_SIGNER_FOLDER]    Script Date: 2015-10-15 오후 1:30:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




CREATE     PROCEDURE [dbo].[UP_INSERT_WF_SIGNER_FOLDER]
(	
	@SIGN_SEQ			INT,		-- 결재자순서
	@PROCESS_INSTANCE_OID	VARCHAR(33),	-- 프로세스 ID
	@USERID			INT,		-- 사용자ID
	@USERNAME			VARCHAR(50),	-- 사용자명
	@SIGN_CATEGORY		CHAR(2),	-- 결재유형(01:일반결재,02:수신결재,03:부서합의,04:개인합의)
	@SIGN_TYPE			CHAR(2),	-- 결재종류(01:일반결재,02:전결,03:결재안함,04:대결,05:후결,06:후열,11:병렬합의)
	@ACTION_TYPE			CHAR(1)		-- 결재처리구분 0:기결재,1:현결재,2:미결재
)
AS
-------------------------------------------------------------------------------------
-- 작성자: 신철호
-- 작성일: 2005.04.11
-- 수정일: 2005.04.11
-- 설명 : 결재자별 예결함을 등록한다.
/*
     EXEC dbo.UP_INSERT_WF_SIGNER_FOLDER 3,'ZC3ECFD85DD534BA080D3FD9E01E53675',10068,'eWF3','01','01','2'
*/
-------------------------------------------------------------------------------------
	INSERT INTO dbo.WF_SIGNER_FOLDER
	VALUES('Z' + REPLACE(NEWID(),'-',''),@SIGN_SEQ,@PROCESS_INSTANCE_OID,@USERID,@USERNAME,@SIGN_CATEGORY,@SIGN_TYPE,@ACTION_TYPE)





GO
/****** Object:  StoredProcedure [dbo].[UP_INSERT_WFSIGNERLIST]    Script Date: 2015-10-15 오후 1:30:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE   Procedure [dbo].[UP_INSERT_WFSIGNERLIST]
	/* Param List */	
	@strId varchar(33),
	@nUserId int,
	@strSignListName varchar(40),
	@strSignInform text,
	@strSignerList text,
	@strListType char(10)
	
	
AS	
DECLARE @nSortKey int
SET @nSortKey = 0
--SELECT SORTKEY = @nSortKey FROM WF_SIGNER_LIST WHERE
SET @nSortKey = (ISNULL(@nSortKey,0) + 1)
INSERT INTO WF_SIGNER_LIST (ID,UserID,SignListName,SignInform,SignerList,ListType,SortKey)
	VALUES(@strId,@nUserId,@strSignListName,@strSignInform,@strSignerList,@strListType,@nSortKey)
	
RETURN



GO
/****** Object:  StoredProcedure [dbo].[UP_INSERTSINGLE_FORMCOLUMN]    Script Date: 2015-10-15 오후 1:30:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UP_INSERTSINGLE_FORMCOLUMN]
	(
		@vcformId			VARCHAR(33),
		@vcfieldName		VARCHAR(30),
		@vcfieldLabel		VARCHAR(30),
		@vcfieldType		VARCHAR(30),
		@vcfieldLength		VARCHAR(9),
		@vcfieldDefault		VARCHAR(50)		
	)
AS 
 
	DECLARE	
		@vcfieldId			VARCHAR(33)
	SET @vcfieldId = 'Y' +  REPLACE(NEWID(), '-', '')
	
	INSERT INTO dbo.WF_FORM_INFORM 
		(
			FORM_ID, 
			FIELD_ID, 
			FIELD_NAME, 
			FIELD_LABEL, 
			FIELD_TYPE, 
			FIELD_LENGTH, 
			FIELD_DEFAULT
		) 
	VALUES
		(
			@vcFormId, 
			@vcFieldId, 
			@vcfieldName, 
			@vcfieldLabel, 
			@vcfieldType, 
			@vcfieldLength, 
			@vcfieldDefault 
		)
RETURN

GO
/****** Object:  StoredProcedure [dbo].[UP_ITSM_INSERT_REQUEST]    Script Date: 2015-10-15 오후 1:30:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE	Procedure	[dbo].[UP_ITSM_INSERT_REQUEST]
(	
	@cRID	char(33),
	@vcEmpID varchar(30),
	@vcSystemID	varchar(30),
	@vcModuleID	varchar(30),
	@vcDocType	varchar(30),
	@nvcXmlData	nvarchar(max)
)
As
-------------------------------------------------------------------------------------
-- 작성자: 신상훈
-- 작성일: 2014.11.27
-- 수정일: 2014.11.27
-- 설명 : WF_ITSM_REQUEST 테이블에 INSERT
/*
     EXEC dbo.UP_ITSM_SELECT_USERINFO_EMPID '20121375'
*/
-------------------------------------------------------------------------------------
INSERT INTO dbo.WF_ITSM_REQUEST
select @cRID, @vcEmpID, @vcSystemID, @vcModuleID, @vcDocType, @nvcXmlData, getdate()











GO
/****** Object:  StoredProcedure [dbo].[UP_ITSM_SELECT_ITSM_ISPROGRESS]    Script Date: 2015-10-15 오후 1:30:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





CREATE	Procedure	[dbo].[UP_ITSM_SELECT_ITSM_ISPROGRESS]
(
	@vcDocType varchar(30),
	@vcObjectId	varchar(50)
)
As
-------------------------------------------------------------------------------------
-- 작성자: 신상훈
-- 작성일: 2014.12.04
-- 수정일: 2014.12.04
-- 설명 : 진행중인 결재문서 존재여부 확인
/*
     EXEC dbo.[UP_ITSM_SELECT_ITSM_ISPROGRESS] 'A98', '123AAA'
	select * from dbo.FORM_Y2DFE91FBD2A2477EA06894E82C9582E4
*/
-------------------------------------------------------------------------------------
declare @nvcExecSql nvarchar(max),
		@cFormID char(33)


select @cFormID = FORM_ID FROM dbo.WF_FORMS
WHERE FORM_ALIAS = @vcDocType

SET @nvcExecSql = N'SELECT COUNT(*) CNT '
SET @nvcExecSql = @nvcExecSql + N' FROM dbo.FORM_' + @cFormID + N' AS A '
SET @nvcExecSql = @nvcExecSql + N' INNER JOIN eWF.dbo.PROCESS_INSTANCE AS B '
SET @nvcExecSql = @nvcExecSql + N' ON A.PROCESS_ID = B.OID '
SET @nvcExecSql = @nvcExecSql + N' WHERE A.DB_OBJECTID = ''' + @vcObjectId + ''' AND B.STATE in (1, 7) AND B.DELETE_DATE > getdate() '

print @nvcExecSql
exec (@nvcExecSql)














GO
/****** Object:  StoredProcedure [dbo].[UP_ITSM_SELECT_ITSM_REQUEST]    Script Date: 2015-10-15 오후 1:30:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE	Procedure	[dbo].[UP_ITSM_SELECT_ITSM_REQUEST]
(
	@cRID char(33)
)
As
-------------------------------------------------------------------------------------
-- 작성자: 신상훈
-- 작성일: 2014.12.01
-- 수정일: 2014.12.01
-- 설명 : RID로 ITSM_REQUEST 테이블 조회하기
/*
     EXEC dbo.UP_ITSM_SELECT_ITSM_REQUEST '20121375'
*/
-------------------------------------------------------------------------------------



select * from dbo.WF_ITSM_REQUEST
where rid = @cRID













GO
/****** Object:  StoredProcedure [dbo].[UP_ITSM_SELECT_USERINFO_EMPID]    Script Date: 2015-10-15 오후 1:30:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE	Procedure	[dbo].[UP_ITSM_SELECT_USERINFO_EMPID]
(
	@vcEmpID varchar(30)
)
As
-------------------------------------------------------------------------------------
-- 작성자: 신상훈
-- 작성일: 2014.11.27
-- 수정일: 2014.11.27
-- 설명 : 사번으로 사용자 정보 조회
/*
     EXEC dbo.UP_ITSM_SELECT_USERINFO_EMPID '20121375'
*/
-------------------------------------------------------------------------------------



select top 1 * from emanage.dbo.vw_user
where empid = @vcEmpID and enddate > getdate()
order by startdate












GO
/****** Object:  StoredProcedure [dbo].[UP_ITSM_UPDATE_APPROVAL_REJECT]    Script Date: 2015-10-15 오후 1:30:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE	Procedure	[dbo].[UP_ITSM_UPDATE_APPROVAL_REJECT]
(
	@cPID char(33)
)
As
-------------------------------------------------------------------------------------
-- 작성자: 신상훈
-- 작성일: 2014.12.04
-- 수정일: 2014.12.04
-- 설명 : 강제반려처리
/*
     EXEC dbo.UP_ITSM_UPDATE_APPROVAL_REJECT 'Z2337FE59F7D3408ABBE89F29AFBDE21E'
select * from ewf.dbo.work_item where process_instance_oid = 'Z2337FE59F7D3408ABBE89F29AFBDE21E'
order by create_date desc

select * from dbo.form_Y2DFE91FBD2A2477EA06894E82C9582E4
where process_id = 'Z2337FE59F7D3408ABBE89F29AFBDE21E'

update dbo.form_Y2DFE91FBD2A2477EA06894E82C9582E4
set process_instance_state = '8'
where process_id = 'Z2337FE59F7D3408ABBE89F29AFBDE21E'

select * From ewf.dbo.process_instance
where oid = 'ZE26F7C610CEA40BC9ABAABB87E4162E5'


select * from dbo.wf_forms_prop where process_id= 'Z2337FE59F7D3408ABBE89F29AFBDE21E'
*/
-------------------------------------------------------------------------------------

--declare @vcForm_ID char(33)
--,		@nvcExecSql nvarchar(max)
--Set	@vcFORM_ID = (Select	FORM_ID	From	dbo.WF_FORMS_PROP (NOLOCK)	Where	PROCESS_ID = @cPID)

UPDATE eWF.dbo.WORK_ITEM 
SET STATE = '7', PROCESS_INSTANCE_VIEW_STATE = '8'
WHERE PROCESS_INSTANCE_OID = @cPID

UPDATE eWF.dbo.PROCESS_INSTANCE
SET STATE = '7', COMPLETED_DATE = getdate()
WHERE OID = @cPID











GO
/****** Object:  StoredProcedure [dbo].[UP_ITSM_UPDATE_CONTENT_XML]    Script Date: 2015-10-15 오후 1:30:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




CREATE	Procedure	[dbo].[UP_ITSM_UPDATE_CONTENT_XML]
(
	@cPID char(33),
	@nvcXml nvarchar(max)
)
As
-------------------------------------------------------------------------------------
-- 작성자: 신상훈
-- 작성일: 2014.12.04
-- 수정일: 2014.12.04
-- 설명 : 본문내용 업데이트
/*
     EXEC dbo.UP_ITSM_UPDATE_CONTENT_XML 'Z2337FE59F7D3408ABBE89F29AFBDE21E', '12345'
*/
-------------------------------------------------------------------------------------

declare @vcForm_ID char(33)
,		@nvcExecSql nvarchar(max)
Set	@vcFORM_ID = (Select	FORM_ID	From	dbo.WF_FORMS_PROP (NOLOCK)	Where	PROCESS_ID = @cPID)

SET @nvcExecSql = N' UPDATE dbo.FORM_' + @vcForm_ID + N' SET DB_CONTENT_XML = ''' + @nvcXml + ''' '
SET @nvcExecSql = @nvcExecSql + N' WHERE PROCESS_ID = ''' + @cPID + ''' '


print @nvcExecSql
exec (@nvcExecSql)












GO
/****** Object:  StoredProcedure [dbo].[UP_LIST_ABSENT_WF_CONFIG_USER]    Script Date: 2015-10-15 오후 1:30:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO



----------------------------------------------------------------------
----------------------------------------------------------------------
-- 작성자: 신상훈
-- 작성일: 2004.04.19
-- 수정일: 2004.06.23
-- 수정자: 신상훈
-- 설  명: 사용자 결재환경 조회
-- 테스트: EXEC  UP_LIST_ABSENT_WF_CONFIG_USER 128574
-- 수  정 : Input Param으로 받는 DeptID를 제외시킴(겸직부서문제때문)
----------------------------------------------------------------------
----------------------------------------------------------------------
CREATE      PROCEDURE [dbo].[UP_LIST_ABSENT_WF_CONFIG_USER]
/*
	(
		@parameter1 datatype = default value,
		@parameter2 datatype OUTPUT
	)
*/
	@intUserId		int,	-- 사용자ID	
	@intDeptId		int
		
	AS
	
	DECLARE		@intDeputyId		int,		-- 업무대리자ID
				@intDeputyDeptId		int,		-- 업무대리자부서ID
				@vcDeputyName		varchar(30)	-- 업무대리자이름
		  
	SET @intDeputyId = (SELECT DEPUTYID FROM eWFFORM.dbo.WF_CONFIG_USER(NOLOCK) WHERE USERID = @intUserId and DEPTID = @intDeptId)
	SET @intDeputyDeptId = (SELECT DEPUTYDEPTID FROM eWFFORM.dbo.WF_CONFIG_USER(NOLOCK) WHERE USERID = @intUserId and DEPTID = @intDeptId)
	
	IF @intDeputyId IS NOT NULL	-- 업무대리자가 있을경우
	SET @vcDeputyName = (SELECT UserName FROM eManage.dbo.VW_USER(NOLOCK) WHERE UserId = @intDeputyId AND DeptId = @intDeputyDeptId  AND GetDate() < EndDate)

	
	ELSE -- 업무대리자가 없을경우
	begin
	SET @vcDeputyName = NULL
	end
	
	
SELECT		A.ISABSENT, 
			A.ABSENCE_REASON, 
			A.DEPUTYSTART, 
			A.DEPUTYEND, 
			A.DEPUTYID,
			A.DEPUTYDEPTID,
			A.AFTER_ACT,			 
			B.UserName, 
--			B.DeptName, 
			@vcDeputyName as DEPUTYNAME
	FROM  
			(Select		USERID, 
						ISABSENT, 
						ABSENCE_REASON, 
						DEPUTYID, 
						DEPUTYDEPTID, 
						DEPUTYSTART, 
						DEPUTYEND, 
						AFTER_ACT
			From		eWFFORM.dbo.Wf_CONFIG_USER(NOLOCK)
			WHERE		USERID = @intUserId and DEPTID = @intDeptId) as A
			INNER JOIN
			(SELECT DISTINCT UserID, UserName--, DeptName
			FROM	eManage.dbo.VW_USER(NOLOCK)
			WHERE	UserId = @intUserId) as B
				
			ON A.USERID = B.UserID




GO
/****** Object:  StoredProcedure [dbo].[UP_LIST_ADMINTREE]    Script Date: 2015-10-15 오후 1:30:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



----------------------------------------------------------------------
----------------------------------------------------------------------
-- 작성자: LDCC 신상훈
-- 작성일: 2004.03.31
-- 수정일: 2004.03.31
-- 설   명: 관리자 트리를 구성하는 DataSet
--        	테스트 :
--		EXEC  UP_LIST_ADMINTREE
----------------------------------------------------------------------
----------------------------------------------------------------------
-- 수정일 : 
-- 수정자 : 
-- 수정내용 : 
----------------------------------------------------------------------
----------------------------------------------------------------------
CREATE    PROCEDURE [dbo].[UP_LIST_ADMINTREE]
AS
	/* SET NOCOUNT ON */
DECLARE @cSeparator char(1)
SET		@cSeparator = '|'
	
SELECT 	A.FolderID, 
		A.FolderName, 
		A.Depth, 
		A.ParentFolderID, 
		B.Form_ID,
		A.FolderType,
		cast(A.FolderID as varchar(5)) + @cSeparator +  rtrim(Isnull(B.Form_ID,'X')) as TREE_ID	-- 트리에서 폴더ID와 폼ID를 사용하기 위해서
		
FROM	(SELECT FolderID, FolderName, Depth, ParentFolderID, FolderType
		FROM	eWFFORM.dbo.Wf_FOLDER (NOLOCK) 
		WHERE	DeleteDate is null AND 
				FolderType IN ('A', 'B', 'C', 'R')) as A
		LEFT OUTER JOIN
		(SELECT FOLDERID, 
				FORM_ID
		FROM	eWFFORM.dbo.WF_FOLDER_DETAIL(NOLOCK)) as B
		ON A.FolderID = B.FolderID
		
ORDER BY A.FolderType, A.FolderName DESC
RETURN




GO
/****** Object:  StoredProcedure [dbo].[UP_LIST_ALLFORMS]    Script Date: 2015-10-15 오후 1:30:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

----------------------------------------------------------------------
----------------------------------------------------------------------
-- 작성자: 김기수
-- 작성일: 2005.03.23
-- 수정일: 2004.03.23
-- 설  명: 모든 양식 조회
-- 테스트: EXEC  UP_LIST_ALLFORMS
----------------------------------------------------------------------
-- 수정일: 
-- 수정자: 
-- 수정내용 : 
----------------------------------------------------------------------

CREATE    PROCEDURE [dbo].[UP_LIST_ALLFORMS]
AS
    SET NOCOUNT ON

    SELECT FORM_ID,
           FORM_NAME
    FROM dbo.WF_FORMS(nolock)
	where CURRENT_FORMS = 'Y'
    ORDER BY FORM_NAME

    RETURN



GO
/****** Object:  StoredProcedure [dbo].[UP_LIST_APRSTATUSINFORM]    Script Date: 2015-10-15 오후 1:30:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

----------------------------------------------------------------------
----------------------------------------------------------------------
-- 작성자: 마성옥
-- 작성일: 2004.04.01
-- 수정일: 2004.04.01
-- 설   명: 결재현황조회(사용자) 결과를 가져옴
-- 테스트: EXEC  
----------------------------------------------------------------------
CREATE  PROCEDURE [dbo].[UP_LIST_APRSTATUSINFORM]
		@strUserId varchar(20),
		@strUserDeptId varchar(20),
		@strDFType varchar(5),
		@strSearchDate varchar(10)
--		@ClassCode varchar(20)
AS
	/* SET NOCOUNT ON */
	
if @strDFType = 'PR'
BEGIN
	--진행함
	SELECT  
		ITEMOID, 		
		CATEGORYNAME, 
		Status, 		
		SUBJECT, 
		CREATOR, 
		CREATOR_DEPT, 
		cast(CREATE_DATE as smalldatetime)
	FROM dbo.VW_WORK_LIST
	WHERE PARTICIPANT_ID = @strUserId
	AND STATE = '7'
	AND PROCESS_INSTANCE_VIEW_STATE = '3'
	AND ITEMSTATE = '1'
	ORDER BY CREATE_DATE DESC
END
else if @strDFType = 'CO' and @strSearchDate = ''
BEGIN
	--완료함
	SELECT
		ITEMOID, 				
		CATEGORYNAME, 		
		Status, 
		SUBJECT, 
		CREATOR, 
		CREATOR_DEPT, 
		CAST(COMPLETED_DATE as smalldatetime)
	FROM dbo.VW_WORK_LIST
	WHERE PARTICIPANT_ID = @strUserId
	AND STATE = '7'
	AND PROCESS_INSTANCE_VIEW_STATE = '7'
	ORDER BY VIEW_COMPLETE_DATE DESC
END
else if @strDFType = 'CO' and @strSearchDate <> ''
BEGIN
	SELECT	 
		ITEMOID, 				
		CATEGORYNAME, 		
		Status, 
		SUBJECT, 
		CREATOR, 
		CREATOR_DEPT, 
		COMPLETED_DATE
	FROM dbo.VW_WORK_LIST
	WHERE PARTICIPANT_ID = @strUserId
	AND STATE = '7'
	AND PROCESS_INSTANCE_VIEW_STATE = '7'
	AND (cast(CREATE_DATE as smalldatetime) >= convert(datetime, @strSearchDate + '-01') AND CAST(CREATE_DATE as smalldatetime) < dateadd(Month, 1, convert(datetime,@strSearchDate + '-01')))
	ORDER BY VIEW_COMPLETE_DATE DESC
END
RETURN


GO
/****** Object:  StoredProcedure [dbo].[UP_LIST_COMMONTREE]    Script Date: 2015-10-15 오후 1:30:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO














-- 
-- 
-- SELECT	OBJECT_ID('UP_LIST_COMMONTREE_TEST')
-- 
-- 
-- select	TOP 10 *
-- from	master.dbo.syscacheobjects
-- where	DBID = DB_ID('EWFFORM')
-- 	AND	OBJID = OBJECT_ID('UP_LIST_COMMONTREE')



----------------------------------------------------------------------
----------------------------------------------------------------------
-- 작성자: LDCC 신상훈
-- 작성일: 2004.04.27
-- 수정일: 2004.04.27
-- 설   명: 사용자 트리
-- 테스트 :-- 
/*

EXEC dbo.UP_LIST_COMMONTREE_TEST 111332,'MENUTREE'
EXEC dbo.UP_LIST_COMMONTREE 10007,'POPUPTREE'

truncate TABLE [dbo].#tree
DROP TABLE [dbo].#tree

*/

/*

		A.FolderID, 
		A.FolderName, 
		A.Depth, 
		A.ParentFolderID, 
		B.Form_ID,
		cast(A.FolderID as varchar(5)) + @cSeparator +  rtrim(Isnull(B.Form_ID,'X')) as TREE_ID	

select	*	from	emanage.dbo.tb_user	where	username = '김인복'

exec UP_LIST_COMMONTREE 111404, 'MENUTREE'

*/
----------------------------------------------------------------------
-- 수정일 : 
-- 수정자 : 
-- 수정내용 : 
----------------------------------------------------------------------


 
CREATE                    PROC [dbo].[UP_LIST_COMMONTREE]

	@intUserId		int, 			-- 사용자ID
	@vcTreeMode		varchar(10)		-- ('MENUTREE' : 좌측메뉴트리 / 'POPUPTREE' : 팝업메뉴)
AS

set transaction isolation level read uncommitted

	CREATE TABLE [dbo].#tree
(	[FOLDER_ID] [int] IDENTITY (1, 1) NOT NULL ,
	[FOLDER_NAME] [varchar] (50) COLLATE Korean_Wansung_CI_AS NOT NULL ,
	[DEPTH] [int] NOT NULL,
	[PARENT_FOLDER_ID] [int] NOT NULL,
	[APR_FOLDER_ID] [char](2),
	[DEPT_ID] [int],
	[AUTH_TYPE] [int],
	[TREE_ID] [varchar] (20) )

DECLARE	
		@intAuthType		int,		-- 권한유형('0' : 개인문서함 / '1' : 특정권한문서함권한 / '2' : 하위부서문서함권한 / '3' : 겸직부서문서함권한 / '4' : 겸직부서의하위부서문서함권한 / '5')
		@intMainDeptId		int,		-- 주부서ID
		@intSubDeptId		int,		-- 하위부서ID
		@intOtherDeptId		int,		-- 타부서ID
		@intPluralDeptId	int,		-- 겸직부서ID
		@intSubParentDeptId int,		-- 하위부서에서 사용할 ParentId
		@intExistParent		int,		-- Parent가 존재하는지 여부
		@intParentID		int,		-- PARENT_FOLDER_ID를 입력할 변수
		@intExistAcl		int,		-- 권한여부	('1' : 권한있음 / '0' : 권한없음)
		@intDepth			int,		-- 트리의 레벨정보
		@intLevel			int, 		-- 하위부서테이블에서 가져온 레벨정보
		@intGap				int, 		-- 레벨정보를 실제 트리에 맞게 변환하기 위해 사용하는 임시변수
		@cAclId				char(1),		-- 권한종류	('Y' : 허용 / 'N' : 거절 / NULL : 권한없음)			
		@cSeparator			char(1),			-- 구분자
		@cFolderType		char(1),			-- 폴더타입 ('P' : 개인결재함 / 'D' : 부서결재함 / 'F' : 폴더)
		@vcPluralDeptName	varchar(100),	
		@vcSubDeptName 		varchar(100),
		@vcOtherDeptName	varchar(100),
		@vcRootFolderName	varchar(50)		-- Root폴더명


/*
SET @intUserId = 10021
SET @vcTreeMode = 'MENUTREE'
*/

SET @vcRootFolderName = (SELECT DOC_FOLDER_NAME FROM eWFFORM.dbo.WF_DOC_FOLDER WHERE APR_FOLDER_ID = 'RT')
SET @cSeparator = '|'
----------------------------------------------------------------------------------------
-- 설    명 : 개인결재함의 Root는 회사 이름으로 한다.
----------------------------------------------------------------------------------------
SET @intAuthType = 0 -- Root의 AuthType은 0
SET @intDepth = 0 -- Root의 Depth는 0
SET @cFolderType = 'F'
INSERT INTO [dbo].#tree(FOLDER_NAME, DEPTH, PARENT_FOLDER_ID, AUTH_TYPE, TREE_ID)
-- SELECT DISTINCT '롯데정보통신(주)', @intDepth, 0, @intAuthType, 'XXX' + @cSeparator + 'XXX'	 + @cSeparator + @cFolderType	-- 부서ID나 APR_FOLDER_ID가 없을 경우 'XXX'로 넣는다. 'F'는 폴더를 의미한다.
SELECT DISTINCT @vcRootFolderName, @intDepth, 0, @intAuthType, 'XXX' + @cSeparator + 'XXX'	 + @cSeparator + @cFolderType	-- 부서ID나 APR_FOLDER_ID가 없을 경우 'XXX'로 넣는다. 'F'는 폴더를 의미한다.


----------------------------------------------------------------------------------------
-- 설    명 : 개인결재함의 Root는 사용자 이름으로 한다.
----------------------------------------------------------------------------------------
SET @intAuthType = 1	-- 개인결재함의 경우
SET @intDepth = 1
SET @cFolderType = 'F'

INSERT INTO [dbo].#tree(FOLDER_NAME, DEPTH, PARENT_FOLDER_ID, AUTH_TYPE, TREE_ID)
-- 겸직부서를 가지고 있는 사용자일 경우 결과가 2행이 나오기 때문에 DISTINCT 처리 함
SELECT DISTINCT UserName, @intDepth, 1, @intAuthType, 'XXX' + @cSeparator + 'XXX' + @cSeparator + @cFolderType
FROM eManage.dbo.VW_USER (NOLOCK)
WHERE UserId = @intUserId AND EndDate > getdate()

IF @vcTreeMode = 'MENUTREE'	
BEGIN	-- IF#1
----------------------------------------------------------------------------------------
-- 설    명 : 개인결재함을 구성하는 문서함을 테이블에 넣는다.
----------------------------------------------------------------------------------------

SET @intParentID = @@IDENTITY
SET @intDepth = 2
SET @cFolderType = 'P'
INSERT INTO [dbo].#tree(FOLDER_NAME, DEPTH, PARENT_FOLDER_ID, APR_FOLDER_ID, DEPT_ID, TREE_ID)
SELECT	DOC_FOLDER_NAME, @intDepth, @intParentID, APR_FOLDER_ID, @intMainDeptId, rtrim(Isnull(cast(@intMainDeptId as varchar(10)), 'XXX')) + @cSeparator +  rtrim(Isnull(APR_FOLDER_ID, 'XXX')) + @cSeparator + @cFolderType
FROM	eWFFORM.dbo.WF_DOC_FOLDER(NOLOCK)
WHERE	APR_FOLDER_TYPE = 'P' AND USAGE_YN = 'Y' and doc_folder_id !='16'
ORDER BY SORTKEY


END	-- end of IF#1

IF @vcTreeMode = 'POPUPTREE'	
BEGIN	-- IF#1-1
----------------------------------------------------------------------------------------
-- 설    명 : 관련근거문서용 트리구성
----------------------------------------------------------------------------------------

SET @intParentID = @@IDENTITY
SET @intDepth = 2
SET @cFolderType = 'P'
INSERT INTO [dbo].#tree(FOLDER_NAME, DEPTH, PARENT_FOLDER_ID, APR_FOLDER_ID, DEPT_ID, TREE_ID)
SELECT	DOC_FOLDER_NAME, @intDepth, @intParentID, APR_FOLDER_ID, @intMainDeptId, rtrim(Isnull(cast(@intMainDeptId as varchar(10)), 'XXX')) + @cSeparator +  rtrim(Isnull(APR_FOLDER_ID, 'XXX')) + @cSeparator + @cFolderType
FROM	eWFFORM.dbo.WF_DOC_FOLDER(NOLOCK)
WHERE	APR_FOLDER_TYPE = 'P' AND USAGE_YN = 'Y' AND APR_FOLDER_ID = 'CO'
ORDER BY SORTKEY

END	-- end of IF#1-1


----------------------------------------------------------------------------------------
-- 설    명 : 부서결재함의 Root는 자신이 소속되어 있는 주부서 이름으로 한다
----------------------------------------------------------------------------------------
SET @intAuthType = 2	-- 자기부서결재함의 경우
SET @intDepth = 1
SET @cFolderType = 'F'
INSERT INTO [dbo].#tree(FOLDER_NAME, DEPTH, PARENT_FOLDER_ID, DEPT_ID, AUTH_TYPE, TREE_ID)
SELECT	DeptName, @intDepth, 1, DeptId, @intAuthType, rtrim(Isnull(cast(@intMainDeptId as varchar(10)), 'XXX')) + @cSeparator +  'XXX' + @cSeparator + @cFolderType
  FROM	eManage.dbo.VW_USER(NOLOCK)
WHERE	PositionOrder = 1 
     AND  UserId = @intUserId and EndDate > getdate()

IF @vcTreeMode = 'MENUTREE' or @vcTreeMode = 'POPUPTREE'
BEGIN	-- IF#2
----------------------------------------------------------------------------------------
-- 설    명 : 부서결재함에서 권한이 없이도 볼 수 있는 문서함을 테이블에 넣는다(트리용)
----------------------------------------------------------------------------------------
SET @intParentID = @@IDENTITY
SET @intMainDeptId = (SELECT DEPT_ID FROM [dbo].#tree WHERE FOLDER_ID = @intParentID)
SET @intDepth = 2
SET @cFolderType = 'D'
INSERT INTO [dbo].#tree(FOLDER_NAME, DEPTH, PARENT_FOLDER_ID, APR_FOLDER_ID, DEPT_ID, TREE_ID)
SELECT	DOC_FOLDER_NAME, @intDepth, @intParentID, APR_FOLDER_ID, @intMainDeptId, rtrim(Isnull(cast(@intMainDeptId as varchar(10)), 'XXX')) + @cSeparator + rtrim(Isnull(APR_FOLDER_ID, 'XXX')) + @cSeparator + @cFolderType
FROM	eWFFORM.dbo.WF_DOC_FOLDER(NOLOCK)
WHERE	APR_FOLDER_TYPE = 'D' AND DOC_FOLDER_TYPE = 'G' AND USAGE_YN = 'Y'
ORDER BY	SORTKEY

----------------------------------------------------------------------------------------
-- 설    명: 로그인한 사용자와 그 사용자가 속한 부서가 특정권한문서함에 대한 권한을 가지고 있는지 여부를 조회한다.
--	   @intExistAcl = 1이면 권한이 있고, 0 이면 권한이 없는 것이다.(부서권한까지 중복체크한다.)
----------------------------------------------------------------------------------------
SET	@intExistAcl = 	(

	SELECT	COUNT(C.DeptId)
	FROM	(
		-- 사용자권한 조회
		SELECT		A.DeptId			
		FROM		eManage.dbo.VW_USER as A
				INNER JOIN	(
				SELECT		USERID, DEPTID 
				FROM		eWFFORM.dbo.WF_ACL_SPECIAL_FOLDER(NOLOCK)
				WHERE		USER_TYPE = 'D'			
				) as B
				ON A.DeptID = B.DEPTID
		WHERE		B.DeptId = @intMainDeptId and A.EndDate > getdate()
	
		UNION
		-- 부서권한 조회	
		SELECT		A.DeptId
		FROM		eManage.dbo.VW_USER as A
				INNER JOIN	(
				SELECT		USERID, DEPTID 
				FROM		eWFFORM.dbo.WF_ACL_SPECIAL_FOLDER(NOLOCK)
				WHERE		USER_TYPE = 'P'			
				) as B
				ON A.DeptID = B.DEPTID
		WHERE		B.UserId = @intUserId AND B.DeptId = @intMainDeptId and A.EndDate > getdate()
		)	as C
)



-- 권한이 있는 경우
IF	@intExistAcl = 1
BEGIN	-- IF#3
	SET @intDepth = 2
	INSERT INTO 	[dbo].#tree(FOLDER_NAME, DEPTH, PARENT_FOLDER_ID, APR_FOLDER_ID, DEPT_ID, TREE_ID)
	SELECT	D.DOC_FOLDER_NAME, @intDepth, @intParentID, D.APR_FOLDER_ID, @intMainDeptId, rtrim(Isnull(cast(@intMainDeptId as varchar(10)), 'XXX')) + @cSeparator + rtrim(Isnull(APR_FOLDER_ID, 'XXX')) + @cSeparator + @cFolderType
	FROM	(
		SELECT  DEPTID, DOC_FOLDER_ID, CASE AVG(ACLID) WHEN 0 THEN 'N' WHEN 1 THEN 'Y' END AS ACLID ,  APR_FOLDER_ID, DOC_FOLDER_NAME, SORTKEY
			FROM
			(
				SELECT		A.DEPTID, A.DOC_FOLDER_ID, A.ACLID, B.APR_FOLDER_ID, B.DOC_FOLDER_NAME, B.SORTKEY
					FROM
						(
							   SELECT	USERID, DEPTID, DOC_FOLDER_ID,	case ACLID  when 'Y' then 1 when 'N' then 0 end as aclid, USER_TYPE
							        FROM	eWFFORM.dbo.WF_ACL_SPECIAL_FOLDER(NOLOCK)
								WHERE	DEPTID = @intMainDeptId AND USER_TYPE = 'D'
						) as A
							  INNER JOIN
						(
							  SELECT 	DOC_FOLDER_NAME, DOC_FOLDER_ID, APR_FOLDER_ID, SORTKEY
							       FROM	eWFFORM.dbo.Wf_DOC_FOLDER(NOLOCK)
								WHERE	APR_FOLDER_TYPE = 'D' AND DOC_FOLDER_TYPE = 'S' AND USAGE_YN = 'Y'					
						) as B
						
							ON 	A.DOC_FOLDER_ID = B.DOC_FOLDER_ID
					
				UNION 
				
				SELECT		A.DEPTID, A.DOC_FOLDER_ID, case ACLID  when 'Y' then 1 when 'N' then 0 end as aclid, B.APR_FOLDER_ID, B.DOC_FOLDER_NAME, B.SORTKEY
					FROM 
						(
							SELECT		USERID, DEPTID, DOC_FOLDER_ID,	ACLID, USER_TYPE
							      FROM	eWFFORM.dbo.WF_ACL_SPECIAL_FOLDER(NOLOCK)
								WHERE	USERID = @intUserId AND DEPTID = @intMainDeptId AND USER_TYPE = 'P'
						) as A
							INNER JOIN
						(	
							SELECT		DOC_FOLDER_NAME, DOC_FOLDER_ID, APR_FOLDER_ID, SORTKEY
							      FROM	eWFFORM.dbo.Wf_DOC_FOLDER(NOLOCK)
								WHERE	APR_FOLDER_TYPE = 'D' AND DOC_FOLDER_TYPE = 'S' AND USAGE_YN = 'Y'					
						) as B
							ON 	A.DOC_FOLDER_ID = B.DOC_FOLDER_ID
			)	as C
					
		GROUP BY DEPTID, DOC_FOLDER_ID, APR_FOLDER_ID, DOC_FOLDER_NAME, SORTKEY		
		)	as D
	WHERE	D.ACLID = 'Y'

	ORDER BY D.SORTKEY

END	-- end of IF#3



----------------------------------------------------------------------------------------
-- 설    명: 로그인한 사용자가 하위부서에 대한 권한을 가지고 있는지 여부를 조회한다.(부서권한까지 중복체크한다.)
--	   @deptAclId = 'Y'이면 권한을 가진 부서이고 'N'이면 권한이 없는 부서이다.
----------------------------------------------------------------------------------------

SET	@cAclId =
	(
		-- 사용자/부서권한 중복체크 후 결과
		SELECT  CASE AVG(ACLID)  WHEN 0 THEN 'N' WHEN 1 THEN 'Y' END AS ACLID
		FROM
		(
			-- 사용자권한체크
			SELECT	DEPTID, CASE ACLID WHEN 'Y' THEN 1 WHEN 'N' THEN 0 END as ACLID
			FROM	eWFFORM.dbo.WF_ACL_SUBDEPT(NOLOCK)			
			WHERE	USERID = @intUserId AND DEPTID = @intMainDeptId AND USER_TYPE = 'P'
			
			UNION
			
			-- 부서권한체크
			SELECT	DEPTID,	CASE ACLID WHEN 'Y' THEN 1 WHEN 'N' THEN 0 END as ACLID
			FROM	eWFFORM.dbo.WF_ACL_SUBDEPT(NOLOCK)	
			WHERE	DEPTID = @intMainDeptId AND USER_TYPE = 'D'
		)	as A
		GROUP BY DEPTID
		
	)
-- 결과값이 없으면 @cAclId를 'N'으로 설정한다.
IF @cAclId IS NULL
BEGIN	-- IF#4
	SET @cAclId = 'N'
END	-- end of IF#4

IF @cAclId = 'Y'
BEGIN	-- IF#5
----------------------------------------------------------------------------------------
-- 설    명: 하위부서에 대한 권한이 있을 경우 소속부서의 최하위 부서까지 조회한다.
----------------------------------------------------------------------------------------
	
DECLARE
	subDept_Cursor  cursor for
		SELECT a.DeptName, a.ParentDeptID, a.DeptID, a.Level
		FROM eManage.dbo.UF_SELECT_SUBDEPT_ALL(@intMainDeptId) as a
		Left Join eManage.dbo.TB_DEPT as b
		on a.ParentDeptID = b.DeptID

	open subDept_Cursor

	FETCH NEXT FROM subDept_Cursor into @vcSubDeptName, @intSubParentDeptId, @intSubDeptId, @intLevel
	SET @intGap = 2 - @intLevel
	WHILE @@FETCH_STATUS  = 0
                begin	-- WHILE#1
		SET @intDepth = @intLevel + @intGap
		-- #tree 테이블에 Dept_ID가 해당행의 ParentDeptID인 행을 조회한다.		
		SET @intExistParent = (SELECT FOLDER_ID
		FROM [dbo].#tree
		WHERE Dept_ID = @intSubParentDeptId AND AUTH_TYPE = 2 AND APR_FOLDER_ID IS NULL)		

		IF @intExistParent IS NOT NULL
		BEGIN	-- IF#6			
			SET @intSubParentDeptId = @intExistParent
		END 	-- end of IF#6		

		SET @cFolderType = 'F'	-- 폴더
		INSERT INTO [dbo].#tree(FOLDER_NAME, DEPTH, PARENT_FOLDER_ID, DEPT_ID, AUTH_TYPE, TREE_ID)
		SELECT @vcSubDeptName, @intDepth, @intSubParentDeptId, @intSubDeptId, @intAuthType, 'XXX' + @cSeparator + 'XXX' + @cSeparator + @cFolderType
		SET @intParentID = @@IDENTITY

		SET @cFolderType = 'D'	-- 부서문서함
		SET @intDepth = @intDepth + 1
		INSERT INTO [dbo].#tree(FOLDER_NAME, DEPTH, PARENT_FOLDER_ID, APR_FOLDER_ID, DEPT_ID, TREE_ID)
		SELECT	DOC_FOLDER_NAME, @intDepth, @intParentID, APR_FOLDER_ID, @intSubDeptId, rtrim(Isnull(@intSubDeptId, 'XXX')) + @cSeparator + rtrim(Isnull(APR_FOLDER_ID, 'XXX')) + @cSeparator + @cFolderType
		FROM	eWFFORM.dbo.WF_DOC_FOLDER(NOLOCK)
		WHERE	APR_FOLDER_TYPE = 'D' AND DOC_FOLDER_TYPE = 'G' AND USAGE_YN = 'Y'
		ORDER BY SORTKEY

		FETCH NEXT FROM subDept_Cursor into @vcSubDeptName, @intSubParentDeptId, @intSubDeptId, @intLevel
	end	-- end of WHILE#1

close subDept_Cursor
DEALLOCATE subDept_Cursor

END	-- end of IF#5


----------------------------------------------------------------------------------------
-- 설    명: 로그인한 사용자가 겸직부서가 있는지 여부를 조회한다.
--	   @intExistAcl >= 1이면 겸직부서가 있는 사용자이고 0 이면 겸직부서가 없는 사용자이다.
----------------------------------------------------------------------------------------
SET @intAuthType = 3	-- 겸직부서의 결재함은 AUTH_TYPE을 3으로 설정한다.
SET @intExistAcl = 
(	SELECT COUNT(DeptId)
	FROM eManage.dbo.VW_USER(NOLOCK)
	WHERE UserId = @intUserId AND PositionOrder <> 1 AND EndDate > getdate()
)


IF @intExistAcl >= 1
	BEGIN	-- IF#7		
		DECLARE
		pluralDept_Cursor  cursor for
			SELECT DeptName, DeptId
			FROM eManage.dbo.VW_USER(NOLOCK)
			WHERE UserId = @intUserId AND PositionOrder <> 1 AND EndDate > getdate()		
		open pluralDept_Cursor

		FETCH NEXT FROM pluralDept_Cursor into @vcPluralDeptName, @intPluralDeptId

		WHILE @@FETCH_STATUS  = 0
		BEGIN	-- WHILE#2
		SET @intDepth = 1	-- 겸직부서는 개인결재함, 부서결재함과 동일한 레벨에 있다.	
		SET @cFolderType = 'F'	
			INSERT INTO [dbo].#tree(FOLDER_NAME, DEPTH, PARENT_FOLDER_ID, DEPT_ID, AUTH_TYPE, TREE_ID)
			SELECT @vcPluralDeptName, @intDepth, 1, @intPluralDeptId, @intAuthType, 'XXX' + @cSeparator + 'XXX' + @cSeparator + @cFolderType
			SET @intParentID = @@IDENTITY

			-- 권한이 없어도 볼 수 있는 부서문서함
			
			SET @intDepth = @intDepth + 1
			SET @cFolderType = 'D'
			INSERT INTO [dbo].#tree(FOLDER_NAME, DEPTH, PARENT_FOLDER_ID, APR_FOLDER_ID, DEPT_ID, TREE_ID)
			SELECT	DOC_FOLDER_NAME, @intDepth, @intParentID, APR_FOLDER_ID, @intPluralDeptId, rtrim(Isnull(cast(@intPluralDeptId as varchar(10)), 'XXX')) + @cSeparator + rtrim(Isnull(APR_FOLDER_ID, 'XXX')) + @cSeparator + @cFolderType
			FROM	eWFFORM.dbo.WF_DOC_FOLDER(NOLOCK)
			WHERE	APR_FOLDER_TYPE = 'D' AND DOC_FOLDER_TYPE = 'G' AND USAGE_YN = 'Y'
			ORDER BY SORTKEY

----------------------------------------------------------------------------------------
-- 설    명: 겸직부서와 겸직부서의 구성원인 사용자가 특정권한문서함에 대한 권한을 가지고 있는지 조회한다.
--	   @intExistAcl = 1이면 특정권한문서함을 볼 수 있고, 0 이면 볼 수 없다.
----------------------------------------------------------------------------------------		
				
			SET	@intExistAcl = 	(
				SELECT	COUNT(C.DeptId)
				FROM	(
					-- 겸직부서권한 조회
					SELECT		A.DeptId			
					FROM		eManage.dbo.VW_USER as A
					INNER JOIN	(
					SELECT		USERID, DEPTID 
					FROM		eWFFORM.dbo.WF_ACL_SPECIAL_FOLDER(NOLOCK)
					WHERE		USER_TYPE = 'D'			
					) as B
					ON A.DeptID = B.DEPTID
					WHERE		B.DeptId = @intPluralDeptId AND A.EndDate > getdate()
							
				UNION
					-- 겸직부서 사용자권한 조회	
					SELECT	A.DeptId
					FROM	
						eManage.dbo.VW_USER as A
						INNER JOIN	(
						SELECT		USERID, DEPTID 
						FROM		eWFFORM.dbo.WF_ACL_SPECIAL_FOLDER(NOLOCK)
						WHERE		USER_TYPE = 'P'			
						) as B
						ON A.DeptID = B.DEPTID
					WHERE		B.UserId = @intUserId AND B.DeptId = @intPluralDeptId AND A.EndDate > getdate()
				)	as C
			)

----------------------------------------------------------------------------------------
-- 설    명: 겸직부서와 겸직부서의 구성원인 사용자가 특정권한문서함에 대한 권한을 가지고 있는 경우
----------------------------------------------------------------------------------------				
				IF	@intExistAcl = 1
				BEGIN	-- IF#8
					SET @cFolderType = 'D'
					INSERT INTO 	[dbo].#tree(FOLDER_NAME, DEPTH, PARENT_FOLDER_ID, APR_FOLDER_ID, DEPT_ID, TREE_ID)
					SELECT	D.DOC_FOLDER_NAME, @intDepth, @intParentID, D.APR_FOLDER_ID, @intPluralDeptId, rtrim(Isnull(cast(@intPluralDeptId as varchar(10)), 'XXX')) + @cSeparator + rtrim(Isnull(APR_FOLDER_ID, 'XXX')) + @cSeparator + @cFolderType
					FROM	(
						SELECT  DEPTID, DOC_FOLDER_ID, CASE AVG(ACLID) WHEN 0 THEN 'N' WHEN 1 THEN 'Y' END AS ACLID ,  APR_FOLDER_ID, DOC_FOLDER_NAME, SORTKEY
							FROM
							(
							SELECT		A.DEPTID, A.DOC_FOLDER_ID, A.ACLID, B.APR_FOLDER_ID, B.DOC_FOLDER_NAME, B.SORTKEY
								FROM
									(
									SELECT		USERID, DEPTID, DOC_FOLDER_ID,	case ACLID  when 'Y' then 1 when 'N' then 0 end as aclid, USER_TYPE
									FROM		eWFFORM.dbo.WF_ACL_SPECIAL_FOLDER(NOLOCK)
									WHERE		DEPTID = @intPluralDeptId AND USER_TYPE = 'D'
									) as A
										INNER JOIN
									(
									SELECT 	DOC_FOLDER_NAME, DOC_FOLDER_ID, APR_FOLDER_ID, SORTKEY
									FROM	 	eWFFORM.dbo.Wf_DOC_FOLDER(NOLOCK)
									WHERE	APR_FOLDER_TYPE = 'D' AND DOC_FOLDER_TYPE = 'S' AND USAGE_YN = 'Y'
									) as B
									
										ON 	A.DOC_FOLDER_ID = B.DOC_FOLDER_ID
								
									UNION 
							
									SELECT		A.DEPTID, A.DOC_FOLDER_ID, case ACLID  when 'Y' then 1 when 'N' then 0 end as aclid, B.APR_FOLDER_ID, B.DOC_FOLDER_NAME, B.SORTKEY
									FROM 
									(
									SELECT		USERID, DEPTID, DOC_FOLDER_ID,	ACLID, USER_TYPE
									FROM		eWFFORM.dbo.WF_ACL_SPECIAL_FOLDER(NOLOCK)
									WHERE		USERID = @intUserId AND DEPTID = @intPluralDeptId AND USER_TYPE = 'P'
									) as A
										INNER JOIN
									(	
									SELECT		DOC_FOLDER_NAME, DOC_FOLDER_ID, APR_FOLDER_ID, SORTKEY
									FROM		eWFFORM.dbo.Wf_DOC_FOLDER(NOLOCK)
									WHERE	APR_FOLDER_TYPE = 'D' AND DOC_FOLDER_TYPE = 'S' AND USAGE_YN = 'Y'
									) as B
									ON 		A.DOC_FOLDER_ID = B.DOC_FOLDER_ID
							)	as C
									
						GROUP BY DEPTID, DOC_FOLDER_ID, APR_FOLDER_ID, DOC_FOLDER_NAME, SORTKEY		
						)	as D
					WHERE	D.ACLID = 'Y'
					ORDER BY SORTKEY
				END	-- end of IF#8


----------------------------------------------------------------------------------------
-- 설    명: 겸직부서와 겸직부서의 구성원인 사용자가 하위부서 문서함에 대한 권한을 가지고 있지 체크(부서권한중복체크)
----------------------------------------------------------------------------------------
			SET	@cAclId =
				(
					-- 사용자/부서권한 중복체크 후 결과
					SELECT  CASE AVG(ACLID)  WHEN 0 THEN 'N' WHEN 1 THEN 'Y' END AS ACLID
					FROM
					(
						-- 사용자권한체크
						SELECT	DEPTID, CASE ACLID WHEN 'Y' THEN 1 WHEN 'N' THEN 0 END as ACLID
						FROM	eWFFORM.dbo.WF_ACL_SUBDEPT(NOLOCK)			
						WHERE	USERID = @intUserId AND DEPTID = @intPluralDeptId AND USER_TYPE = 'P'
						
						UNION
						
						-- 부서권한체크
						SELECT	DEPTID,	CASE ACLID WHEN 'Y' THEN 1 WHEN 'N' THEN 0 END as ACLID
						FROM	eWFFORM.dbo.WF_ACL_SUBDEPT(NOLOCK)			
						WHERE	DEPTID = @intPluralDeptId AND USER_TYPE = 'D'			
					)	as A
					GROUP BY DEPTID
					
				)
			-- 결과값이 없으면 @cAclId를 'N'으로 설정한다.
			IF @cAclId IS NULL
			BEGIN	-- IF#9
				SET @cAclId = 'N'
			END	-- end of IF#9
	
			IF @cAclId = 'Y'
			BEGIN	-- IF#10
----------------------------------------------------------------------------------------
-- 설    명: 하위부서에 대한 권한이 있을 경우 겸직부서의 최하위 부서까지 조회한다.
----------------------------------------------------------------------------------------
				DECLARE
				pluralSubDept_Cursor  cursor for
					SELECT a.DeptName, a.ParentDeptID, a.DeptID, a.Level
					FROM eManage.dbo.UF_SELECT_SUBDEPT_ALL(@intPluralDeptId) as a
					Left Join eManage.dbo.TB_DEPT as b
					on a.ParentDeptID = b.DeptID
				
				open pluralSubDept_Cursor				
				FETCH NEXT FROM pluralSubDept_Cursor into @vcSubDeptName, @intSubParentDeptId, @intSubDeptId, @intLevel
				SET @intGap = 2 - @intLevel	-- 겸직부서의 첫번째 하위부서의 Depth를 2로 맞춰주기 위한 방법

				WHILE @@FETCH_STATUS  = 0
				BEGIN	-- WHILE#3
					SET @intDepth = @intLevel + @intGap
					-- #tree 테이블에 Dept_ID가 해당행의 ParentDeptID인 행을 조회한다.
					SET @intExistParent = (SELECT FOLDER_ID
					FROM [dbo].#tree
					WHERE Dept_ID = @intSubParentDeptId AND AUTH_TYPE = 3 AND APR_FOLDER_ID IS NULL)
				
					IF @intExistParent IS NOT NULL	-- 상위부서가 있는 경우
					BEGIN	-- IF#11				
						SET @intSubParentDeptId = @intExistParent	-- 상위부서의 FOLDER_ID를 자신의 Parent_Dept_Id로 변환한다.
						SET @intDepth = @intDepth + 1
					END 	-- end of IF#11			
							
					SET @cFolderType = 'F'
					INSERT INTO [dbo].#tree(FOLDER_NAME, DEPTH, PARENT_FOLDER_ID, DEPT_ID, AUTH_TYPE, TREE_ID)
					SELECT @vcSubDeptName, @intDepth, @intSubParentDeptId, @intSubDeptId, @intAuthType, 'XXX' + @cSeparator + 'XXX' + @cSeparator + @cFolderType
					SET @intParentID = @@IDENTITY
							
					SET @intDepth = @intDepth + 1
					SET @cFolderType = 'D'
					-- 하위부서의 문서함은 일반문서함만 볼 수 있다.
					INSERT INTO [dbo].#tree(FOLDER_NAME, DEPTH, PARENT_FOLDER_ID, APR_FOLDER_ID, DEPT_ID, TREE_ID)
					SELECT	DOC_FOLDER_NAME, @intDepth, @intParentID, APR_FOLDER_ID, @intSubDeptId, rtrim(Isnull(cast(@intSubDeptId as varchar(10)), 'XXX')) + @cSeparator + rtrim(Isnull(APR_FOLDER_ID, 'XXX')) + @cSeparator + @cFolderType
					FROM	eWFFORM.dbo.WF_DOC_FOLDER(NOLOCK)
					WHERE	APR_FOLDER_TYPE = 'D' AND DOC_FOLDER_TYPE = 'G' AND USAGE_YN = 'Y'	
					ORDER BY SORTKEY
				
					FETCH NEXT FROM pluralSubDept_Cursor into @vcSubDeptName, @intSubParentDeptId, @intSubDeptId, @IntLevel
				END	-- end of WHILE#3			
			CLOSE pluralSubDept_Cursor
			DEALLOCATE pluralSubDept_Cursor
			END	-- end of IF#10
					
	  	FETCH NEXT FROM pluralDept_Cursor into @vcPluralDeptName, @intPluralDeptId

		END	-- end of WHILE#2
		close pluralDept_Cursor
		DEALLOCATE pluralDept_Cursor

	END	-- end of IF#7


----------------------------------------------------------------------------------------
-- 설    명: 로그인한 사용자나 사용자가 속한 부서가 타부서에 대한 권한이 있는지 여부를 조회한다.
--	   @intExistAcl >= 1 이면 타부서의 권한이 있는 사용자나 부서이고 0 이면 권한이 없는 사용자나 부서이다.
----------------------------------------------------------------------------------------
SET @intExistAcl = 
		(
		SELECT	COUNT(*)
		FROM
			(
			-- 로그인한 사용자가 속한 주부서 및 겸직부서의 타부서문서함에 대한 사용자권한을 조회한다.
			SELECT A.UserId, A.DeptId, A.OTHER_DEPTID, A.DOC_FOLDER_ID, A.ACLID
			FROM
				(
				SELECT		USERID, DEPTID, OTHER_DEPTID, DOC_FOLDER_ID, ACLID
				FROM		eWFFORM.dbo.WF_ACL_OTHER_DEPT(NOLOCK)
				WHERE		USERID = @intUserId AND USER_TYPE = 'P'
				)	as A
		
				INNER JOIN
		
				(
				SELECT UserId, DeptId
				FROM eManage.dbo.VW_USER(NOLOCK)
				WHERE UserId = @intUserId AND EndDate > getdate()
				)	as B
				ON A.UserId = B.UserId AND A.DeptId = B.DeptId
				
			UNION 
		
			-- 로그인한 사용자가 속한 주부서 및 겸직부서의 타부서문서함에 대한 부서권한을 조회한다.
			SELECT A.UserId, A.DeptId, A.OTHER_DEPTID, A.DOC_FOLDER_ID, A.ACLID	
			FROM
				(
				SELECT		USERID, DEPTID, OTHER_DEPTID, DOC_FOLDER_ID, ACLID, USER_TYPE
				FROM		eWFFORM.dbo.WF_ACL_OTHER_DEPT(NOLOCK)
				)	as A
		
				INNER JOIN		
			
				(
				SELECT UserId, DeptId
				FROM eManage.dbo.VW_USER(NOLOCK)
				WHERE UserId = @intUserId AND EndDate > getdate()	-- 현재 실재하고 있는 겸직부서 조회
				)	as B
		
				ON A.USER_TYPE = 'D' AND A.DeptId = B.DeptId
			)	as C
		)

IF @intExistAcl > 0		-- 로그인한 사용자에게 타부서권한이 주어졌을 때
BEGIN	-- IF#12

----------------------------------------------------------------------------------------
-- 설    명: 권한중복체크를 통해 최종적으로 사용자가 볼 수 있는 타부서를 뽑아낸다.
--	   Cursor를 사용하여 타부서마다 볼수 있는 문서함정보를 #tree에 넣는다.
----------------------------------------------------------------------------------------
	DECLARE
		otherDept_Cursor  cursor for
			SELECT	DISTINCT OTHER_DEPTID, OTHER_DEPT_NAME
			FROM
				(			
				SELECT DISTINCT C.DEPTID, C.OTHER_DEPTID, D.DeptName as OTHER_DEPT_NAME, C.DOC_FOLDER_ID, C.ACLID
				FROM
					(
					-- 로그인한 사용자가 속한 주부서 및 겸직부서의 타부서문서함에 대한 사용자권한을 조회한다.
					SELECT	DISTINCT A.USERID, A.DEPTID, A.OTHER_DEPTID, A.DOC_FOLDER_ID, A.ACLID
					FROM	
						(
						-- 사용자의 타부서권한을 가져온다.
						SELECT	USERID, DEPTID, OTHER_DEPTID, DOC_FOLDER_ID, ACLID
						FROM 	eWFFORM.dbo.WF_ACL_OTHER_DEPT(NOLOCK)
						 -- 겸직부서의 사용자권한도 가져오기 위해 사용자의 DeptId는 검색조건에서 뺀다.
						WHERE	USERID = @intUserId AND USER_TYPE = 'P'	
						)	as A
						INNER JOIN
						(
						-- A 에서 가져온 결과중 실제로 겸직을 하고 있는(퇴직이나 겸직에서 빠지지 않은) 사용자의 부서를 가져온다.					
						SELECT UserId, DeptId, DeptName
						FROM eManage.dbo.VW_USER(NOLOCK)
						WHERE UserId = @intUserId AND EndDate > getdate()
						)	as B
						ON A.UserId = B.UserId AND A.DeptId = B.DeptId				
					)	as C
			
					INNER JOIN
			
					(
					-- 타부서의 이름을 가져오기 위해 VW_USER와 조인을 한다.
					SELECT 	DeptId, DeptName
					FROM	eManage.dbo.VW_DEPT(NOLOCK)	
					)	as D
					ON 	D.DeptId = C.OTHER_DEPTID	-- 타부서ID를 이용해 타부서 이름을 가져온다.				
					
				UNION 
			
				-- 로그인한 사용자가 속한 주부서 및 겸직부서의 타부서문서함에 대한 부서권한을 조회한다.
				SELECT DISTINCT C.DEPTID, C.OTHER_DEPTID, D.DeptName as OTHER_DEPT_NAME, C.DOC_FOLDER_ID, C.ACLID
				FROM
					(
					SELECT	DISTINCT A.DEPTID, A.OTHER_DEPTID, A.DOC_FOLDER_ID, A.ACLID
					FROM
						(
						SELECT		USERID, DEPTID, OTHER_DEPTID, DOC_FOLDER_ID, ACLID, USER_TYPE
						FROM		eWFFORM.dbo.WF_ACL_OTHER_DEPT(NOLOCK)
						WHERE		USER_TYPE = 'D'
						)	as A		
						INNER JOIN					
						(
						-- 타부서의 이름을 가져오기 위해 VW_USER와 조인을 한다.
						SELECT UserId, DeptId, DeptName
						FROM eManage.dbo.VW_USER(NOLOCK)
						WHERE UserId = @intUserId AND EndDate > getdate()	-- 현재 실재하고 있는 겸직부서 조회
						)	as B
						ON 	B.DeptId = A.DEPTID	-- 타부서ID를 이용해 타부서 이름을 가져온다.		
					)	as C
					
					INNER JOIN
			
					(
					-- 타부서의 이름을 가져오기 위해 VW_USER와 조인을 한다.
					SELECT 	DeptId, DeptName
					FROM	eManage.dbo.VW_DEPT(NOLOCK)	
					)	as D
					ON 	D.DeptId = C.OTHER_DEPTID	-- 타부서ID를 이용해 타부서 이름을 가져온다.		
	
				)	as E
			WHERE ACLID = 'Y'

		open otherDept_Cursor	-- 커서 시작

		FETCH NEXT FROM otherDept_Cursor into @intOtherDeptId, @vcOtherDeptName

		WHILE @@FETCH_STATUS  = 0
		BEGIN	-- WHILE#4
			SET @intAuthType = 4
			SET @intDepth = 1	-- 타부서의 레벨은 개인결재함, 부서결재함과 동일하다
			SET @cFolderType = 'F'
			INSERT INTO [dbo].#tree(FOLDER_NAME, DEPTH, PARENT_FOLDER_ID, DEPT_ID, AUTH_TYPE, TREE_ID)
			SELECT @vcOtherDeptName, @intDepth, 1, @intOtherDeptId, @intAuthType, 'XXX' + @cSeparator + 'XXX' + @cSeparator + @cFolderType
			SET @intParentID = @@IDENTITY			
			
----------------------------------------------------------------------------------------
-- 설    명: 사용자(주부서), 주부서, 사용자(겸직부서), 겸직부서의 4번의 중복체크를 통해서 
--	   로그인한 사용자가 볼 수 있는 문서함의 리스트를 가져와서 #tree에 넣는다.
----------------------------------------------------------------------------------------
			SET @intDepth = @intDepth + 1
			SET @cFolderType = 'D'
			INSERT INTO [dbo].#tree(FOLDER_NAME, DEPTH, PARENT_FOLDER_ID, APR_FOLDER_ID, DEPT_ID, TREE_ID)
			SELECT	DOC_FOLDER_NAME, @intDepth, @intParentID, APR_FOLDER_ID, OTHER_DEPTID, rtrim(Isnull(cast(OTHER_DEPTID as varchar(10)), 'XXX')) + @cSeparator + rtrim(Isnull(APR_FOLDER_ID, 'XXX')) + @cSeparator + @cFolderType			
			FROM
				(
					-- 권한이 0 이면 '거절', 1 이면 '허용' 이다.
					SELECT  OTHER_DEPTID, DOC_FOLDER_ID, CASE AVG(ACLID) WHEN 0 THEN 'N' WHEN 1 THEN 'Y' END AS ACLID ,  APR_FOLDER_ID, DOC_FOLDER_NAME, SORTKEY
					FROM	
					(		
					SELECT A.OTHER_DEPTID, A.DOC_FOLDER_ID, B.DOC_FOLDER_NAME, B.APR_FOLDER_ID, A.ACLID, B.SORTKEY
					FROM
						(
						SELECT		USERID, DEPTID, OTHER_DEPTID, DOC_FOLDER_ID, case ACLID  when 'Y' then 1 when 'N' then 0 end as ACLID
							FROM		eWFFORM.dbo.WF_ACL_OTHER_DEPT(NOLOCK)
								WHERE		USERID = @intUserId AND USER_TYPE = 'P'
						)	as A
				
						INNER JOIN
						
						(
						SELECT 	DOC_FOLDER_NAME, DOC_FOLDER_ID, APR_FOLDER_ID, SORTKEY
						FROM	 	eWFFORM.dbo.Wf_DOC_FOLDER(NOLOCK)
						WHERE	APR_FOLDER_TYPE = 'D' AND USAGE_YN = 'Y'
						) as B	
				
						ON 	A.DOC_FOLDER_ID = B.DOC_FOLDER_ID
								
					UNION ALL
						
					SELECT C.OTHER_DEPTID, C.DOC_FOLDER_ID, D.DOC_FOLDER_NAME, D.APR_FOLDER_ID,  C.ACLID, D.SORTKEY
					FROM		
						(
						SELECT A.USERID, A.DEPTID, A.OTHER_DEPTID, A.DOC_FOLDER_ID, A.ACLID
						FROM
							(
							SELECT		USERID, DEPTID, DOC_FOLDER_ID, OTHER_DEPTID, case ACLID  when 'Y' then 1 when 'N' then 0 end as ACLID, USER_TYPE
							FROM		eWFFORM.dbo.WF_ACL_OTHER_DEPT(NOLOCK)
							) as A
							
								INNER JOIN		
								
							(
							SELECT UserId, DeptId
							FROM eManage.dbo.VW_USER
							WHERE UserId = @intUserId AND EndDate > getdate()
							)	as B
							
							ON A.USER_TYPE = 'D' AND A.DeptId = B.DeptId
						)	as C
						
						INNER JOIN
						
						(
						SELECT 	DOC_FOLDER_NAME, DOC_FOLDER_ID, APR_FOLDER_ID, SORTKEY
						FROM	 	eWFFORM.dbo.Wf_DOC_FOLDER(NOLOCK)
						WHERE	APR_FOLDER_TYPE = 'D' AND USAGE_YN = 'Y'
						) as D	
				
						ON 	C.DOC_FOLDER_ID = D.DOC_FOLDER_ID
					)	as E
					
					GROUP BY OTHER_DEPTID, DOC_FOLDER_ID, APR_FOLDER_ID, DOC_FOLDER_NAME, SORTKEY		
				)	as F	
				WHERE	OTHER_DEPTID = @intOtherDeptId AND ACLID = 'Y' 
				ORDER BY SORTKEY

		FETCH NEXT FROM otherDept_Cursor into @intOtherDeptId, @vcOtherDeptName
			
		END	-- end of WHILE#4
		close otherDept_Cursor
		DEALLOCATE otherDept_Cursor
	END	-- end of IF#12
END	-- end of IF#2

SELECT	FOLDER_ID,  FOLDER_NAME + dbo.UF_DOCFOLDER_COUNT_TEMP(@intUserID, TREE_ID), DEPTH, PARENT_FOLDER_ID, APR_FOLDER_ID, DEPT_ID, AUTH_TYPE, TREE_ID
-- select	FOLDER_ID,  FOLDER_NAME + '', DEPTH, PARENT_FOLDER_ID, APR_FOLDER_ID, DEPT_ID, AUTH_TYPE, TREE_ID
FROM	#tree

-- IF @vcTreeMode = 'MENUTREE'
-- 	BEGIN	
-- 		select	FOLDER_ID, 
-- 			CASE APR_FOLDER_ID
-- 				WHEN 'AP' THEN FOLDER_NAME + dbo.UF_DOCFOLDER_COUNT(@intUserID, TREE_ID)
-- 				WHEN 'AF' THEN FOLDER_NAME + dbo.UF_DOCFOLDER_COUNT(@intUserID, TREE_ID)
-- 				WHEN 'R' THEN	FOLDER_NAME + dbo.UF_DOCFOLDER_COUNT(@intUserID, TREE_ID)
-- 				WHEN 'K' THEN	FOLDER_NAME + dbo.UF_DOCFOLDER_COUNT(@intUserID, TREE_ID)
-- 				ELSE FOLDER_NAME
-- 				END
-- 			,DEPTH, PARENT_FOLDER_ID, APR_FOLDER_ID, DEPT_ID, AUTH_TYPE, TREE_ID
-- 		FROM	#tree
-- 	END
-- 
-- ELSE
-- 	BEGIN
-- 		select	FOLDER_ID, 
-- 			CASE APR_FOLDER_ID
-- 				WHEN 'AP' THEN FOLDER_NAME + dbo.UF_DOCFOLDER_COUNT(@intUserID, TREE_ID)
-- 				WHEN 'AF' THEN FOLDER_NAME + dbo.UF_DOCFOLDER_COUNT(@intUserID, TREE_ID)
-- 				ELSE FOLDER_NAME
-- 				END
-- 			,DEPTH, PARENT_FOLDER_ID, APR_FOLDER_ID, DEPT_ID, AUTH_TYPE, TREE_ID
-- 		FROM	#tree
-- 		WHERE APR_FOLDER_ID is null OR APR_FOLDER_ID not in ('K','R')
-- 	END



DROP TABLE #tree

return
























GO
/****** Object:  StoredProcedure [dbo].[UP_LIST_COMMONTREE_T2]    Script Date: 2015-10-15 오후 1:30:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO












-- 
-- 
-- SELECT	OBJECT_ID('UP_LIST_COMMONTREE_TEST')
-- 
-- 
-- select	TOP 10 *
-- from	master.dbo.syscacheobjects
-- where	DBID = DB_ID('EWFFORM')
-- 	AND	OBJID = OBJECT_ID('UP_LIST_COMMONTREE')



----------------------------------------------------------------------
----------------------------------------------------------------------
-- 작성자: LDCC 신상훈
-- 작성일: 2004.04.27
-- 수정일: 2004.04.27
-- 설   명: 사용자 트리
-- 테스트 :-- 
/*

EXEC dbo.UP_LIST_COMMONTREE_TEST 111332,'MENUTREE'
EXEC dbo.UP_LIST_COMMONTREE 10007,'POPUPTREE'

truncate TABLE [dbo].#tree
DROP TABLE [dbo].#tree

*/

/*

		A.FolderID, 
		A.FolderName, 
		A.Depth, 
		A.ParentFolderID, 
		B.Form_ID,
		cast(A.FolderID as varchar(5)) + @cSeparator +  rtrim(Isnull(B.Form_ID,'X')) as TREE_ID	

select	*	from	emanage.dbo.tb_user	where	username = '남궁유진'

exec UP_LIST_COMMONTREE 111404, 'MENUTREE'
exec up_list_commontree 141015, 'MENUTREE'
*/
----------------------------------------------------------------------
-- 수정일 : 
-- 수정자 : 
-- 수정내용 : 
----------------------------------------------------------------------


 
CREATE                    PROC [dbo].[UP_LIST_COMMONTREE_T2]

	@intUserId		int, 			-- 사용자ID
	@vcTreeMode		varchar(10)		-- ('MENUTREE' : 좌측메뉴트리 / 'POPUPTREE' : 팝업메뉴)
AS

set transaction isolation level read uncommitted

	CREATE TABLE [dbo].#tree
(	[FOLDER_ID] [int] IDENTITY (1, 1) NOT NULL ,
	[FOLDER_NAME] [varchar] (50) COLLATE Korean_Wansung_CI_AS NOT NULL ,
	[DEPTH] [int] NOT NULL,
	[PARENT_FOLDER_ID] [int] NOT NULL,
	[APR_FOLDER_ID] [char](2),
	[DEPT_ID] [int],
	[AUTH_TYPE] [int],
	[TREE_ID] [varchar] (20) )

DECLARE	
		@intAuthType		int,		-- 권한유형('0' : 개인문서함 / '1' : 특정권한문서함권한 / '2' : 하위부서문서함권한 / '3' : 겸직부서문서함권한 / '4' : 겸직부서의하위부서문서함권한 / '5')
		@intMainDeptId		int,		-- 주부서ID
		@intSubDeptId		int,		-- 하위부서ID
		@intOtherDeptId		int,		-- 타부서ID
		@intPluralDeptId	int,		-- 겸직부서ID
		@intSubParentDeptId int,		-- 하위부서에서 사용할 ParentId
		@intExistParent		int,		-- Parent가 존재하는지 여부
		@intParentID		int,		-- PARENT_FOLDER_ID를 입력할 변수
		@intExistAcl		int,		-- 권한여부	('1' : 권한있음 / '0' : 권한없음)
		@intDepth			int,		-- 트리의 레벨정보
		@intLevel			int, 		-- 하위부서테이블에서 가져온 레벨정보
		@intGap				int, 		-- 레벨정보를 실제 트리에 맞게 변환하기 위해 사용하는 임시변수
		@cAclId				char(1),		-- 권한종류	('Y' : 허용 / 'N' : 거절 / NULL : 권한없음)			
		@cSeparator			char(1),			-- 구분자
		@cFolderType		char(1),			-- 폴더타입 ('P' : 개인결재함 / 'D' : 부서결재함 / 'F' : 폴더)
		@vcPluralDeptName	varchar(100),	
		@vcSubDeptName 		varchar(100),
		@vcOtherDeptName	varchar(100),
		@vcRootFolderName	varchar(50)		-- Root폴더명


/*
SET @intUserId = 10021
SET @vcTreeMode = 'MENUTREE'
*/

SET @vcRootFolderName = (SELECT DOC_FOLDER_NAME FROM eWFFORM.dbo.WF_DOC_FOLDER WHERE APR_FOLDER_ID = 'RT')
SET @cSeparator = '|'
----------------------------------------------------------------------------------------
-- 설    명 : 개인결재함의 Root는 회사 이름으로 한다.
----------------------------------------------------------------------------------------
SET @intAuthType = 0 -- Root의 AuthType은 0
SET @intDepth = 0 -- Root의 Depth는 0
SET @cFolderType = 'F'
INSERT INTO [dbo].#tree(FOLDER_NAME, DEPTH, PARENT_FOLDER_ID, AUTH_TYPE, TREE_ID)
-- SELECT DISTINCT '롯데정보통신(주)', @intDepth, 0, @intAuthType, 'XXX' + @cSeparator + 'XXX'	 + @cSeparator + @cFolderType	-- 부서ID나 APR_FOLDER_ID가 없을 경우 'XXX'로 넣는다. 'F'는 폴더를 의미한다.
SELECT DISTINCT @vcRootFolderName, @intDepth, 0, @intAuthType, 'XXX' + @cSeparator + 'XXX'	 + @cSeparator + @cFolderType	-- 부서ID나 APR_FOLDER_ID가 없을 경우 'XXX'로 넣는다. 'F'는 폴더를 의미한다.


----------------------------------------------------------------------------------------
-- 설    명 : 개인결재함의 Root는 사용자 이름으로 한다.
----------------------------------------------------------------------------------------
SET @intAuthType = 1	-- 개인결재함의 경우
SET @intDepth = 1
SET @cFolderType = 'F'

INSERT INTO [dbo].#tree(FOLDER_NAME, DEPTH, PARENT_FOLDER_ID, AUTH_TYPE, TREE_ID)
-- 겸직부서를 가지고 있는 사용자일 경우 결과가 2행이 나오기 때문에 DISTINCT 처리 함
SELECT DISTINCT UserName, @intDepth, 1, @intAuthType, 'XXX' + @cSeparator + 'XXX' + @cSeparator + @cFolderType
FROM eManage.dbo.VW_USER (NOLOCK)
WHERE UserId = @intUserId AND EndDate > getdate()

IF @vcTreeMode = 'MENUTREE'	
BEGIN	-- IF#1
----------------------------------------------------------------------------------------
-- 설    명 : 개인결재함을 구성하는 문서함을 테이블에 넣는다.
----------------------------------------------------------------------------------------

SET @intParentID = @@IDENTITY
SET @intDepth = 2
SET @cFolderType = 'P'
INSERT INTO [dbo].#tree(FOLDER_NAME, DEPTH, PARENT_FOLDER_ID, APR_FOLDER_ID, DEPT_ID, TREE_ID)
SELECT	DOC_FOLDER_NAME, @intDepth, @intParentID, APR_FOLDER_ID, @intMainDeptId, rtrim(Isnull(cast(@intMainDeptId as varchar(10)), 'XXX')) + @cSeparator +  rtrim(Isnull(APR_FOLDER_ID, 'XXX')) + @cSeparator + @cFolderType
FROM	eWFFORM.dbo.WF_DOC_FOLDER(NOLOCK)
WHERE	APR_FOLDER_TYPE = 'P' AND USAGE_YN = 'Y'
ORDER BY SORTKEY


END	-- end of IF#1

IF @vcTreeMode = 'POPUPTREE'	
BEGIN	-- IF#1-1
----------------------------------------------------------------------------------------
-- 설    명 : 관련근거문서용 트리구성
----------------------------------------------------------------------------------------

SET @intParentID = @@IDENTITY
SET @intDepth = 2
SET @cFolderType = 'P'
INSERT INTO [dbo].#tree(FOLDER_NAME, DEPTH, PARENT_FOLDER_ID, APR_FOLDER_ID, DEPT_ID, TREE_ID)
SELECT	DOC_FOLDER_NAME, @intDepth, @intParentID, APR_FOLDER_ID, @intMainDeptId, rtrim(Isnull(cast(@intMainDeptId as varchar(10)), 'XXX')) + @cSeparator +  rtrim(Isnull(APR_FOLDER_ID, 'XXX')) + @cSeparator + @cFolderType
FROM	eWFFORM.dbo.WF_DOC_FOLDER(NOLOCK)
WHERE	APR_FOLDER_TYPE = 'P' AND USAGE_YN = 'Y' AND APR_FOLDER_ID = 'CO'
ORDER BY SORTKEY

END	-- end of IF#1-1


----------------------------------------------------------------------------------------
-- 설    명 : 부서결재함의 Root는 자신이 소속되어 있는 주부서 이름으로 한다
----------------------------------------------------------------------------------------
SET @intAuthType = 2	-- 자기부서결재함의 경우
SET @intDepth = 1
SET @cFolderType = 'F'
INSERT INTO [dbo].#tree(FOLDER_NAME, DEPTH, PARENT_FOLDER_ID, DEPT_ID, AUTH_TYPE, TREE_ID)
SELECT	DeptName, @intDepth, 1, DeptId, @intAuthType, rtrim(Isnull(cast(@intMainDeptId as varchar(10)), 'XXX')) + @cSeparator +  'XXX' + @cSeparator + @cFolderType
  FROM	eManage.dbo.VW_USER(NOLOCK)
WHERE	PositionOrder = 1 
     AND  UserId = @intUserId and EndDate > getdate()

IF @vcTreeMode = 'MENUTREE' or @vcTreeMode = 'POPUPTREE'
BEGIN	-- IF#2
----------------------------------------------------------------------------------------
-- 설    명 : 부서결재함에서 권한이 없이도 볼 수 있는 문서함을 테이블에 넣는다(트리용)
----------------------------------------------------------------------------------------
SET @intParentID = @@IDENTITY
SET @intMainDeptId = (SELECT DEPT_ID FROM [dbo].#tree WHERE FOLDER_ID = @intParentID)
SET @intDepth = 2
SET @cFolderType = 'D'
INSERT INTO [dbo].#tree(FOLDER_NAME, DEPTH, PARENT_FOLDER_ID, APR_FOLDER_ID, DEPT_ID, TREE_ID)
SELECT	DOC_FOLDER_NAME, @intDepth, @intParentID, APR_FOLDER_ID, @intMainDeptId, rtrim(Isnull(cast(@intMainDeptId as varchar(10)), 'XXX')) + @cSeparator + rtrim(Isnull(APR_FOLDER_ID, 'XXX')) + @cSeparator + @cFolderType
FROM	eWFFORM.dbo.WF_DOC_FOLDER(NOLOCK)
WHERE	APR_FOLDER_TYPE = 'D' AND DOC_FOLDER_TYPE = 'G' AND USAGE_YN = 'Y'
ORDER BY	SORTKEY

----------------------------------------------------------------------------------------
-- 설    명: 로그인한 사용자와 그 사용자가 속한 부서가 특정권한문서함에 대한 권한을 가지고 있는지 여부를 조회한다.
--	   @intExistAcl = 1이면 권한이 있고, 0 이면 권한이 없는 것이다.(부서권한까지 중복체크한다.)
----------------------------------------------------------------------------------------
SET	@intExistAcl = 	(

	SELECT	COUNT(C.DeptId)
	FROM	(
		-- 사용자권한 조회
		SELECT		A.DeptId			
		FROM		eManage.dbo.VW_USER as A
				INNER JOIN	(
				SELECT		USERID, DEPTID 
				FROM		eWFFORM.dbo.WF_ACL_SPECIAL_FOLDER(NOLOCK)
				WHERE		USER_TYPE = 'D'			
				) as B
				ON A.DeptID = B.DEPTID
		WHERE		B.DeptId = @intMainDeptId and A.EndDate > getdate()
	
		UNION
		-- 부서권한 조회	
		SELECT		A.DeptId
		FROM		eManage.dbo.VW_USER as A
				INNER JOIN	(
				SELECT		USERID, DEPTID 
				FROM		eWFFORM.dbo.WF_ACL_SPECIAL_FOLDER(NOLOCK)
				WHERE		USER_TYPE = 'P'			
				) as B
				ON A.DeptID = B.DEPTID
		WHERE		B.UserId = @intUserId AND B.DeptId = @intMainDeptId and A.EndDate > getdate()
		)	as C
)



-- 권한이 있는 경우
IF	@intExistAcl = 1
BEGIN	-- IF#3
	SET @intDepth = 2
	INSERT INTO 	[dbo].#tree(FOLDER_NAME, DEPTH, PARENT_FOLDER_ID, APR_FOLDER_ID, DEPT_ID, TREE_ID)
	SELECT	D.DOC_FOLDER_NAME, @intDepth, @intParentID, D.APR_FOLDER_ID, @intMainDeptId, rtrim(Isnull(cast(@intMainDeptId as varchar(10)), 'XXX')) + @cSeparator + rtrim(Isnull(APR_FOLDER_ID, 'XXX')) + @cSeparator + @cFolderType
	FROM	(
		SELECT  DEPTID, DOC_FOLDER_ID, CASE AVG(ACLID) WHEN 0 THEN 'N' WHEN 1 THEN 'Y' END AS ACLID ,  APR_FOLDER_ID, DOC_FOLDER_NAME, SORTKEY
			FROM
			(
				SELECT		A.DEPTID, A.DOC_FOLDER_ID, A.ACLID, B.APR_FOLDER_ID, B.DOC_FOLDER_NAME, B.SORTKEY
					FROM
						(
							   SELECT	USERID, DEPTID, DOC_FOLDER_ID,	case ACLID  when 'Y' then 1 when 'N' then 0 end as aclid, USER_TYPE
							        FROM	eWFFORM.dbo.WF_ACL_SPECIAL_FOLDER(NOLOCK)
								WHERE	DEPTID = @intMainDeptId AND USER_TYPE = 'D'
						) as A
							  INNER JOIN
						(
							  SELECT 	DOC_FOLDER_NAME, DOC_FOLDER_ID, APR_FOLDER_ID, SORTKEY
							       FROM	eWFFORM.dbo.Wf_DOC_FOLDER(NOLOCK)
								WHERE	APR_FOLDER_TYPE = 'D' AND DOC_FOLDER_TYPE = 'S' AND USAGE_YN = 'Y'					
						) as B
						
							ON 	A.DOC_FOLDER_ID = B.DOC_FOLDER_ID
					
				UNION 
				
				SELECT		A.DEPTID, A.DOC_FOLDER_ID, case ACLID  when 'Y' then 1 when 'N' then 0 end as aclid, B.APR_FOLDER_ID, B.DOC_FOLDER_NAME, B.SORTKEY
					FROM 
						(
							SELECT		USERID, DEPTID, DOC_FOLDER_ID,	ACLID, USER_TYPE
							      FROM	eWFFORM.dbo.WF_ACL_SPECIAL_FOLDER(NOLOCK)
								WHERE	USERID = @intUserId AND DEPTID = @intMainDeptId AND USER_TYPE = 'P'
						) as A
							INNER JOIN
						(	
							SELECT		DOC_FOLDER_NAME, DOC_FOLDER_ID, APR_FOLDER_ID, SORTKEY
							      FROM	eWFFORM.dbo.Wf_DOC_FOLDER(NOLOCK)
								WHERE	APR_FOLDER_TYPE = 'D' AND DOC_FOLDER_TYPE = 'S' AND USAGE_YN = 'Y'					
						) as B
							ON 	A.DOC_FOLDER_ID = B.DOC_FOLDER_ID
			)	as C
					
		GROUP BY DEPTID, DOC_FOLDER_ID, APR_FOLDER_ID, DOC_FOLDER_NAME, SORTKEY		
		)	as D
	WHERE	D.ACLID = 'Y'

	ORDER BY D.SORTKEY

END	-- end of IF#3



----------------------------------------------------------------------------------------
-- 설    명: 로그인한 사용자가 하위부서에 대한 권한을 가지고 있는지 여부를 조회한다.(부서권한까지 중복체크한다.)
--	   @deptAclId = 'Y'이면 권한을 가진 부서이고 'N'이면 권한이 없는 부서이다.
----------------------------------------------------------------------------------------

SET	@cAclId =
	(
		-- 사용자/부서권한 중복체크 후 결과
		SELECT  CASE AVG(ACLID)  WHEN 0 THEN 'N' WHEN 1 THEN 'Y' END AS ACLID
		FROM
		(
			-- 사용자권한체크
			SELECT	DEPTID, CASE ACLID WHEN 'Y' THEN 1 WHEN 'N' THEN 0 END as ACLID
			FROM	eWFFORM.dbo.WF_ACL_SUBDEPT(NOLOCK)			
			WHERE	USERID = @intUserId AND DEPTID = @intMainDeptId AND USER_TYPE = 'P'
			
			UNION
			
			-- 부서권한체크
			SELECT	DEPTID,	CASE ACLID WHEN 'Y' THEN 1 WHEN 'N' THEN 0 END as ACLID
			FROM	eWFFORM.dbo.WF_ACL_SUBDEPT(NOLOCK)	
			WHERE	DEPTID = @intMainDeptId AND USER_TYPE = 'D'
		)	as A
		GROUP BY DEPTID
		
	)
-- 결과값이 없으면 @cAclId를 'N'으로 설정한다.
IF @cAclId IS NULL
BEGIN	-- IF#4
	SET @cAclId = 'N'
END	-- end of IF#4

IF @cAclId = 'Y'
BEGIN	-- IF#5
----------------------------------------------------------------------------------------
-- 설    명: 하위부서에 대한 권한이 있을 경우 소속부서의 최하위 부서까지 조회한다.
----------------------------------------------------------------------------------------
	
DECLARE
	subDept_Cursor  cursor for
		SELECT a.DeptName, a.ParentDeptID, a.DeptID, a.Level
		FROM eManage.dbo.UF_SELECT_SUBDEPT_ALL(@intMainDeptId) as a
		Left Join eManage.dbo.TB_DEPT as b
		on a.ParentDeptID = b.DeptID

	open subDept_Cursor

	FETCH NEXT FROM subDept_Cursor into @vcSubDeptName, @intSubParentDeptId, @intSubDeptId, @intLevel
	SET @intGap = 2 - @intLevel
	WHILE @@FETCH_STATUS  = 0
                begin	-- WHILE#1
		SET @intDepth = @intLevel + @intGap
		-- #tree 테이블에 Dept_ID가 해당행의 ParentDeptID인 행을 조회한다.		
		SET @intExistParent = (SELECT FOLDER_ID
		FROM [dbo].#tree
		WHERE Dept_ID = @intSubParentDeptId AND AUTH_TYPE = 2 AND APR_FOLDER_ID IS NULL)		

		IF @intExistParent IS NOT NULL
		BEGIN	-- IF#6			
			SET @intSubParentDeptId = @intExistParent
		END 	-- end of IF#6		

		SET @cFolderType = 'F'	-- 폴더
		INSERT INTO [dbo].#tree(FOLDER_NAME, DEPTH, PARENT_FOLDER_ID, DEPT_ID, AUTH_TYPE, TREE_ID)
		SELECT @vcSubDeptName, @intDepth, @intSubParentDeptId, @intSubDeptId, @intAuthType, 'XXX' + @cSeparator + 'XXX' + @cSeparator + @cFolderType
		SET @intParentID = @@IDENTITY

		SET @cFolderType = 'D'	-- 부서문서함
		SET @intDepth = @intDepth + 1
		INSERT INTO [dbo].#tree(FOLDER_NAME, DEPTH, PARENT_FOLDER_ID, APR_FOLDER_ID, DEPT_ID, TREE_ID)
		SELECT	DOC_FOLDER_NAME, @intDepth, @intParentID, APR_FOLDER_ID, @intSubDeptId, rtrim(Isnull(@intSubDeptId, 'XXX')) + @cSeparator + rtrim(Isnull(APR_FOLDER_ID, 'XXX')) + @cSeparator + @cFolderType
		FROM	eWFFORM.dbo.WF_DOC_FOLDER(NOLOCK)
		WHERE	APR_FOLDER_TYPE = 'D' AND DOC_FOLDER_TYPE = 'G' AND USAGE_YN = 'Y'
		ORDER BY SORTKEY

		FETCH NEXT FROM subDept_Cursor into @vcSubDeptName, @intSubParentDeptId, @intSubDeptId, @intLevel
	end	-- end of WHILE#1

close subDept_Cursor
DEALLOCATE subDept_Cursor

END	-- end of IF#5


----------------------------------------------------------------------------------------
-- 설    명: 로그인한 사용자가 겸직부서가 있는지 여부를 조회한다.
--	   @intExistAcl >= 1이면 겸직부서가 있는 사용자이고 0 이면 겸직부서가 없는 사용자이다.
----------------------------------------------------------------------------------------
SET @intAuthType = 3	-- 겸직부서의 결재함은 AUTH_TYPE을 3으로 설정한다.
SET @intExistAcl = 
(	SELECT COUNT(DeptId)
	FROM eManage.dbo.VW_USER(NOLOCK)
	WHERE UserId = @intUserId AND PositionOrder <> 1 AND EndDate > getdate()
)


IF @intExistAcl >= 1
	BEGIN	-- IF#7		
		DECLARE
		pluralDept_Cursor  cursor for
			SELECT DeptName, DeptId
			FROM eManage.dbo.VW_USER(NOLOCK)
			WHERE UserId = @intUserId AND PositionOrder <> 1 AND EndDate > getdate()		
		open pluralDept_Cursor

		FETCH NEXT FROM pluralDept_Cursor into @vcPluralDeptName, @intPluralDeptId

		WHILE @@FETCH_STATUS  = 0
		BEGIN	-- WHILE#2
		SET @intDepth = 1	-- 겸직부서는 개인결재함, 부서결재함과 동일한 레벨에 있다.	
		SET @cFolderType = 'F'	
			INSERT INTO [dbo].#tree(FOLDER_NAME, DEPTH, PARENT_FOLDER_ID, DEPT_ID, AUTH_TYPE, TREE_ID)
			SELECT @vcPluralDeptName, @intDepth, 1, @intPluralDeptId, @intAuthType, 'XXX' + @cSeparator + 'XXX' + @cSeparator + @cFolderType
			SET @intParentID = @@IDENTITY

			-- 권한이 없어도 볼 수 있는 부서문서함
			
			SET @intDepth = @intDepth + 1
			SET @cFolderType = 'D'
			INSERT INTO [dbo].#tree(FOLDER_NAME, DEPTH, PARENT_FOLDER_ID, APR_FOLDER_ID, DEPT_ID, TREE_ID)
			SELECT	DOC_FOLDER_NAME, @intDepth, @intParentID, APR_FOLDER_ID, @intPluralDeptId, rtrim(Isnull(cast(@intPluralDeptId as varchar(10)), 'XXX')) + @cSeparator + rtrim(Isnull(APR_FOLDER_ID, 'XXX')) + @cSeparator + @cFolderType
			FROM	eWFFORM.dbo.WF_DOC_FOLDER(NOLOCK)
			WHERE	APR_FOLDER_TYPE = 'D' AND DOC_FOLDER_TYPE = 'G' AND USAGE_YN = 'Y'
			ORDER BY SORTKEY

----------------------------------------------------------------------------------------
-- 설    명: 겸직부서와 겸직부서의 구성원인 사용자가 특정권한문서함에 대한 권한을 가지고 있는지 조회한다.
--	   @intExistAcl = 1이면 특정권한문서함을 볼 수 있고, 0 이면 볼 수 없다.
----------------------------------------------------------------------------------------		
				
			SET	@intExistAcl = 	(
				SELECT	COUNT(C.DeptId)
				FROM	(
					-- 겸직부서권한 조회
					SELECT		A.DeptId			
					FROM		eManage.dbo.VW_USER as A
					INNER JOIN	(
					SELECT		USERID, DEPTID 
					FROM		eWFFORM.dbo.WF_ACL_SPECIAL_FOLDER(NOLOCK)
					WHERE		USER_TYPE = 'D'			
					) as B
					ON A.DeptID = B.DEPTID
					WHERE		B.DeptId = @intPluralDeptId AND A.EndDate > getdate()
							
				UNION
					-- 겸직부서 사용자권한 조회	
					SELECT	A.DeptId
					FROM	
						eManage.dbo.VW_USER as A
						INNER JOIN	(
						SELECT		USERID, DEPTID 
						FROM		eWFFORM.dbo.WF_ACL_SPECIAL_FOLDER(NOLOCK)
						WHERE		USER_TYPE = 'P'			
						) as B
						ON A.DeptID = B.DEPTID
					WHERE		B.UserId = @intUserId AND B.DeptId = @intPluralDeptId AND A.EndDate > getdate()
				)	as C
			)

----------------------------------------------------------------------------------------
-- 설    명: 겸직부서와 겸직부서의 구성원인 사용자가 특정권한문서함에 대한 권한을 가지고 있는 경우
----------------------------------------------------------------------------------------				
				IF	@intExistAcl = 1
				BEGIN	-- IF#8
					SET @cFolderType = 'D'
					INSERT INTO 	[dbo].#tree(FOLDER_NAME, DEPTH, PARENT_FOLDER_ID, APR_FOLDER_ID, DEPT_ID, TREE_ID)
					SELECT	D.DOC_FOLDER_NAME, @intDepth, @intParentID, D.APR_FOLDER_ID, @intPluralDeptId, rtrim(Isnull(cast(@intPluralDeptId as varchar(10)), 'XXX')) + @cSeparator + rtrim(Isnull(APR_FOLDER_ID, 'XXX')) + @cSeparator + @cFolderType
					FROM	(
						SELECT  DEPTID, DOC_FOLDER_ID, CASE AVG(ACLID) WHEN 0 THEN 'N' WHEN 1 THEN 'Y' END AS ACLID ,  APR_FOLDER_ID, DOC_FOLDER_NAME, SORTKEY
							FROM
							(
							SELECT		A.DEPTID, A.DOC_FOLDER_ID, A.ACLID, B.APR_FOLDER_ID, B.DOC_FOLDER_NAME, B.SORTKEY
								FROM
									(
									SELECT		USERID, DEPTID, DOC_FOLDER_ID,	case ACLID  when 'Y' then 1 when 'N' then 0 end as aclid, USER_TYPE
									FROM		eWFFORM.dbo.WF_ACL_SPECIAL_FOLDER(NOLOCK)
									WHERE		DEPTID = @intPluralDeptId AND USER_TYPE = 'D'
									) as A
										INNER JOIN
									(
									SELECT 	DOC_FOLDER_NAME, DOC_FOLDER_ID, APR_FOLDER_ID, SORTKEY
									FROM	 	eWFFORM.dbo.Wf_DOC_FOLDER(NOLOCK)
									WHERE	APR_FOLDER_TYPE = 'D' AND DOC_FOLDER_TYPE = 'S' AND USAGE_YN = 'Y'
									) as B
									
										ON 	A.DOC_FOLDER_ID = B.DOC_FOLDER_ID
								
									UNION 
							
									SELECT		A.DEPTID, A.DOC_FOLDER_ID, case ACLID  when 'Y' then 1 when 'N' then 0 end as aclid, B.APR_FOLDER_ID, B.DOC_FOLDER_NAME, B.SORTKEY
									FROM 
									(
									SELECT		USERID, DEPTID, DOC_FOLDER_ID,	ACLID, USER_TYPE
									FROM		eWFFORM.dbo.WF_ACL_SPECIAL_FOLDER(NOLOCK)
									WHERE		USERID = @intUserId AND DEPTID = @intPluralDeptId AND USER_TYPE = 'P'
									) as A
										INNER JOIN
									(	
									SELECT		DOC_FOLDER_NAME, DOC_FOLDER_ID, APR_FOLDER_ID, SORTKEY
									FROM		eWFFORM.dbo.Wf_DOC_FOLDER(NOLOCK)
									WHERE	APR_FOLDER_TYPE = 'D' AND DOC_FOLDER_TYPE = 'S' AND USAGE_YN = 'Y'
									) as B
									ON 		A.DOC_FOLDER_ID = B.DOC_FOLDER_ID
							)	as C
									
						GROUP BY DEPTID, DOC_FOLDER_ID, APR_FOLDER_ID, DOC_FOLDER_NAME, SORTKEY		
						)	as D
					WHERE	D.ACLID = 'Y'
					ORDER BY SORTKEY
				END	-- end of IF#8


----------------------------------------------------------------------------------------
-- 설    명: 겸직부서와 겸직부서의 구성원인 사용자가 하위부서 문서함에 대한 권한을 가지고 있지 체크(부서권한중복체크)
----------------------------------------------------------------------------------------
			SET	@cAclId =
				(
					-- 사용자/부서권한 중복체크 후 결과
					SELECT  CASE AVG(ACLID)  WHEN 0 THEN 'N' WHEN 1 THEN 'Y' END AS ACLID
					FROM
					(
						-- 사용자권한체크
						SELECT	DEPTID, CASE ACLID WHEN 'Y' THEN 1 WHEN 'N' THEN 0 END as ACLID
						FROM	eWFFORM.dbo.WF_ACL_SUBDEPT(NOLOCK)			
						WHERE	USERID = @intUserId AND DEPTID = @intPluralDeptId AND USER_TYPE = 'P'
						
						UNION
						
						-- 부서권한체크
						SELECT	DEPTID,	CASE ACLID WHEN 'Y' THEN 1 WHEN 'N' THEN 0 END as ACLID
						FROM	eWFFORM.dbo.WF_ACL_SUBDEPT(NOLOCK)			
						WHERE	DEPTID = @intPluralDeptId AND USER_TYPE = 'D'			
					)	as A
					GROUP BY DEPTID
					
				)
			-- 결과값이 없으면 @cAclId를 'N'으로 설정한다.
			IF @cAclId IS NULL
			BEGIN	-- IF#9
				SET @cAclId = 'N'
			END	-- end of IF#9
	
			IF @cAclId = 'Y'
			BEGIN	-- IF#10
----------------------------------------------------------------------------------------
-- 설    명: 하위부서에 대한 권한이 있을 경우 겸직부서의 최하위 부서까지 조회한다.
----------------------------------------------------------------------------------------
				DECLARE
				pluralSubDept_Cursor  cursor for
					SELECT a.DeptName, a.ParentDeptID, a.DeptID, a.Level
					FROM eManage.dbo.UF_SELECT_SUBDEPT_ALL(@intPluralDeptId) as a
					Left Join eManage.dbo.TB_DEPT as b
					on a.ParentDeptID = b.DeptID
				
				open pluralSubDept_Cursor				
				FETCH NEXT FROM pluralSubDept_Cursor into @vcSubDeptName, @intSubParentDeptId, @intSubDeptId, @intLevel
				SET @intGap = 2 - @intLevel	-- 겸직부서의 첫번째 하위부서의 Depth를 2로 맞춰주기 위한 방법

				WHILE @@FETCH_STATUS  = 0
				BEGIN	-- WHILE#3
					SET @intDepth = @intLevel + @intGap
					-- #tree 테이블에 Dept_ID가 해당행의 ParentDeptID인 행을 조회한다.
					SET @intExistParent = (SELECT FOLDER_ID
					FROM [dbo].#tree
					WHERE Dept_ID = @intSubParentDeptId AND AUTH_TYPE = 3 AND APR_FOLDER_ID IS NULL)
				
					IF @intExistParent IS NOT NULL	-- 상위부서가 있는 경우
					BEGIN	-- IF#11				
						SET @intSubParentDeptId = @intExistParent	-- 상위부서의 FOLDER_ID를 자신의 Parent_Dept_Id로 변환한다.
						SET @intDepth = @intDepth + 1
					END 	-- end of IF#11			
							
					SET @cFolderType = 'F'
					INSERT INTO [dbo].#tree(FOLDER_NAME, DEPTH, PARENT_FOLDER_ID, DEPT_ID, AUTH_TYPE, TREE_ID)
					SELECT @vcSubDeptName, @intDepth, @intSubParentDeptId, @intSubDeptId, @intAuthType, 'XXX' + @cSeparator + 'XXX' + @cSeparator + @cFolderType
					SET @intParentID = @@IDENTITY
							
					SET @intDepth = @intDepth + 1
					SET @cFolderType = 'D'
					-- 하위부서의 문서함은 일반문서함만 볼 수 있다.
					INSERT INTO [dbo].#tree(FOLDER_NAME, DEPTH, PARENT_FOLDER_ID, APR_FOLDER_ID, DEPT_ID, TREE_ID)
					SELECT	DOC_FOLDER_NAME, @intDepth, @intParentID, APR_FOLDER_ID, @intSubDeptId, rtrim(Isnull(cast(@intSubDeptId as varchar(10)), 'XXX')) + @cSeparator + rtrim(Isnull(APR_FOLDER_ID, 'XXX')) + @cSeparator + @cFolderType
					FROM	eWFFORM.dbo.WF_DOC_FOLDER(NOLOCK)
					WHERE	APR_FOLDER_TYPE = 'D' AND DOC_FOLDER_TYPE = 'G' AND USAGE_YN = 'Y'	
					ORDER BY SORTKEY
				
					FETCH NEXT FROM pluralSubDept_Cursor into @vcSubDeptName, @intSubParentDeptId, @intSubDeptId, @IntLevel
				END	-- end of WHILE#3			
			CLOSE pluralSubDept_Cursor
			DEALLOCATE pluralSubDept_Cursor
			END	-- end of IF#10
					
	  	FETCH NEXT FROM pluralDept_Cursor into @vcPluralDeptName, @intPluralDeptId

		END	-- end of WHILE#2
		close pluralDept_Cursor
		DEALLOCATE pluralDept_Cursor

	END	-- end of IF#7


----------------------------------------------------------------------------------------
-- 설    명: 로그인한 사용자나 사용자가 속한 부서가 타부서에 대한 권한이 있는지 여부를 조회한다.
--	   @intExistAcl >= 1 이면 타부서의 권한이 있는 사용자나 부서이고 0 이면 권한이 없는 사용자나 부서이다.
----------------------------------------------------------------------------------------
SET @intExistAcl = 
		(
		SELECT	COUNT(*)
		FROM
			(
			-- 로그인한 사용자가 속한 주부서 및 겸직부서의 타부서문서함에 대한 사용자권한을 조회한다.
			SELECT A.UserId, A.DeptId, A.OTHER_DEPTID, A.DOC_FOLDER_ID, A.ACLID
			FROM
				(
				SELECT		USERID, DEPTID, OTHER_DEPTID, DOC_FOLDER_ID, ACLID
				FROM		eWFFORM.dbo.WF_ACL_OTHER_DEPT(NOLOCK)
				WHERE		USERID = @intUserId AND USER_TYPE = 'P'
				)	as A
		
				INNER JOIN
		
				(
				SELECT UserId, DeptId
				FROM eManage.dbo.VW_USER(NOLOCK)
				WHERE UserId = @intUserId AND EndDate > getdate()
				)	as B
				ON A.UserId = B.UserId AND A.DeptId = B.DeptId
				
			UNION 
		
			-- 로그인한 사용자가 속한 주부서 및 겸직부서의 타부서문서함에 대한 부서권한을 조회한다.
			SELECT A.UserId, A.DeptId, A.OTHER_DEPTID, A.DOC_FOLDER_ID, A.ACLID	
			FROM
				(
				SELECT		USERID, DEPTID, OTHER_DEPTID, DOC_FOLDER_ID, ACLID, USER_TYPE
				FROM		eWFFORM.dbo.WF_ACL_OTHER_DEPT(NOLOCK)
				)	as A
		
				INNER JOIN		
			
				(
				SELECT UserId, DeptId
				FROM eManage.dbo.VW_USER(NOLOCK)
				WHERE UserId = @intUserId AND EndDate > getdate()	-- 현재 실재하고 있는 겸직부서 조회
				)	as B
		
				ON A.USER_TYPE = 'D' AND A.DeptId = B.DeptId
			)	as C
		)

IF @intExistAcl > 0		-- 로그인한 사용자에게 타부서권한이 주어졌을 때
BEGIN	-- IF#12

----------------------------------------------------------------------------------------
-- 설    명: 권한중복체크를 통해 최종적으로 사용자가 볼 수 있는 타부서를 뽑아낸다.
--	   Cursor를 사용하여 타부서마다 볼수 있는 문서함정보를 #tree에 넣는다.
----------------------------------------------------------------------------------------
	DECLARE
		otherDept_Cursor  cursor for
			SELECT	DISTINCT OTHER_DEPTID, OTHER_DEPT_NAME
			FROM
				(			
				SELECT DISTINCT C.DEPTID, C.OTHER_DEPTID, D.DeptName as OTHER_DEPT_NAME, C.DOC_FOLDER_ID, C.ACLID
				FROM
					(
					-- 로그인한 사용자가 속한 주부서 및 겸직부서의 타부서문서함에 대한 사용자권한을 조회한다.
					SELECT	DISTINCT A.USERID, A.DEPTID, A.OTHER_DEPTID, A.DOC_FOLDER_ID, A.ACLID
					FROM	
						(
						-- 사용자의 타부서권한을 가져온다.
						SELECT	USERID, DEPTID, OTHER_DEPTID, DOC_FOLDER_ID, ACLID
						FROM 	eWFFORM.dbo.WF_ACL_OTHER_DEPT(NOLOCK)
						 -- 겸직부서의 사용자권한도 가져오기 위해 사용자의 DeptId는 검색조건에서 뺀다.
						WHERE	USERID = @intUserId AND USER_TYPE = 'P'	
						)	as A
						INNER JOIN
						(
						-- A 에서 가져온 결과중 실제로 겸직을 하고 있는(퇴직이나 겸직에서 빠지지 않은) 사용자의 부서를 가져온다.					
						SELECT UserId, DeptId, DeptName
						FROM eManage.dbo.VW_USER(NOLOCK)
						WHERE UserId = @intUserId AND EndDate > getdate()
						)	as B
						ON A.UserId = B.UserId AND A.DeptId = B.DeptId				
					)	as C
			
					INNER JOIN
			
					(
					-- 타부서의 이름을 가져오기 위해 VW_USER와 조인을 한다.
					SELECT 	DeptId, DeptName
					FROM	eManage.dbo.VW_DEPT(NOLOCK)	
					)	as D
					ON 	D.DeptId = C.OTHER_DEPTID	-- 타부서ID를 이용해 타부서 이름을 가져온다.				
					
				UNION 
			
				-- 로그인한 사용자가 속한 주부서 및 겸직부서의 타부서문서함에 대한 부서권한을 조회한다.
				SELECT DISTINCT C.DEPTID, C.OTHER_DEPTID, D.DeptName as OTHER_DEPT_NAME, C.DOC_FOLDER_ID, C.ACLID
				FROM
					(
					SELECT	DISTINCT A.DEPTID, A.OTHER_DEPTID, A.DOC_FOLDER_ID, A.ACLID
					FROM
						(
						SELECT		USERID, DEPTID, OTHER_DEPTID, DOC_FOLDER_ID, ACLID, USER_TYPE
						FROM		eWFFORM.dbo.WF_ACL_OTHER_DEPT(NOLOCK)
						WHERE		USER_TYPE = 'D'
						)	as A		
						INNER JOIN					
						(
						-- 타부서의 이름을 가져오기 위해 VW_USER와 조인을 한다.
						SELECT UserId, DeptId, DeptName
						FROM eManage.dbo.VW_USER(NOLOCK)
						WHERE UserId = @intUserId AND EndDate > getdate()	-- 현재 실재하고 있는 겸직부서 조회
						)	as B
						ON 	B.DeptId = A.DEPTID	-- 타부서ID를 이용해 타부서 이름을 가져온다.		
					)	as C
					
					INNER JOIN
			
					(
					-- 타부서의 이름을 가져오기 위해 VW_USER와 조인을 한다.
					SELECT 	DeptId, DeptName
					FROM	eManage.dbo.VW_DEPT(NOLOCK)	
					)	as D
					ON 	D.DeptId = C.OTHER_DEPTID	-- 타부서ID를 이용해 타부서 이름을 가져온다.		
	
				)	as E
			WHERE ACLID = 'Y'

		open otherDept_Cursor	-- 커서 시작

		FETCH NEXT FROM otherDept_Cursor into @intOtherDeptId, @vcOtherDeptName

		WHILE @@FETCH_STATUS  = 0
		BEGIN	-- WHILE#4
			SET @intAuthType = 4
			SET @intDepth = 1	-- 타부서의 레벨은 개인결재함, 부서결재함과 동일하다
			SET @cFolderType = 'F'
			INSERT INTO [dbo].#tree(FOLDER_NAME, DEPTH, PARENT_FOLDER_ID, DEPT_ID, AUTH_TYPE, TREE_ID)
			SELECT @vcOtherDeptName, @intDepth, 1, @intOtherDeptId, @intAuthType, 'XXX' + @cSeparator + 'XXX' + @cSeparator + @cFolderType
			SET @intParentID = @@IDENTITY			
			
----------------------------------------------------------------------------------------
-- 설    명: 사용자(주부서), 주부서, 사용자(겸직부서), 겸직부서의 4번의 중복체크를 통해서 
--	   로그인한 사용자가 볼 수 있는 문서함의 리스트를 가져와서 #tree에 넣는다.
----------------------------------------------------------------------------------------
			SET @intDepth = @intDepth + 1
			SET @cFolderType = 'D'
			INSERT INTO [dbo].#tree(FOLDER_NAME, DEPTH, PARENT_FOLDER_ID, APR_FOLDER_ID, DEPT_ID, TREE_ID)
			SELECT	DOC_FOLDER_NAME, @intDepth, @intParentID, APR_FOLDER_ID, OTHER_DEPTID, rtrim(Isnull(cast(OTHER_DEPTID as varchar(10)), 'XXX')) + @cSeparator + rtrim(Isnull(APR_FOLDER_ID, 'XXX')) + @cSeparator + @cFolderType			
			FROM
				(
					-- 권한이 0 이면 '거절', 1 이면 '허용' 이다.
					SELECT  OTHER_DEPTID, DOC_FOLDER_ID, CASE AVG(ACLID) WHEN 0 THEN 'N' WHEN 1 THEN 'Y' END AS ACLID ,  APR_FOLDER_ID, DOC_FOLDER_NAME, SORTKEY
					FROM	
					(		
					SELECT A.OTHER_DEPTID, A.DOC_FOLDER_ID, B.DOC_FOLDER_NAME, B.APR_FOLDER_ID, A.ACLID, B.SORTKEY
					FROM
						(
						SELECT		USERID, DEPTID, OTHER_DEPTID, DOC_FOLDER_ID, case ACLID  when 'Y' then 1 when 'N' then 0 end as ACLID
							FROM		eWFFORM.dbo.WF_ACL_OTHER_DEPT(NOLOCK)
								WHERE		USERID = @intUserId AND USER_TYPE = 'P'
						)	as A
				
						INNER JOIN
						
						(
						SELECT 	DOC_FOLDER_NAME, DOC_FOLDER_ID, APR_FOLDER_ID, SORTKEY
						FROM	 	eWFFORM.dbo.Wf_DOC_FOLDER(NOLOCK)
						WHERE	APR_FOLDER_TYPE = 'D' AND USAGE_YN = 'Y'
						) as B	
				
						ON 	A.DOC_FOLDER_ID = B.DOC_FOLDER_ID
								
					UNION ALL
						
					SELECT C.OTHER_DEPTID, C.DOC_FOLDER_ID, D.DOC_FOLDER_NAME, D.APR_FOLDER_ID,  C.ACLID, D.SORTKEY
					FROM		
						(
						SELECT A.USERID, A.DEPTID, A.OTHER_DEPTID, A.DOC_FOLDER_ID, A.ACLID
						FROM
							(
							SELECT		USERID, DEPTID, DOC_FOLDER_ID, OTHER_DEPTID, case ACLID  when 'Y' then 1 when 'N' then 0 end as ACLID, USER_TYPE
							FROM		eWFFORM.dbo.WF_ACL_OTHER_DEPT(NOLOCK)
							) as A
							
								INNER JOIN		
								
							(
							SELECT UserId, DeptId
							FROM eManage.dbo.VW_USER
							WHERE UserId = @intUserId AND EndDate > getdate()
							)	as B
							
							ON A.USER_TYPE = 'D' AND A.DeptId = B.DeptId
						)	as C
						
						INNER JOIN
						
						(
						SELECT 	DOC_FOLDER_NAME, DOC_FOLDER_ID, APR_FOLDER_ID, SORTKEY
						FROM	 	eWFFORM.dbo.Wf_DOC_FOLDER(NOLOCK)
						WHERE	APR_FOLDER_TYPE = 'D' AND USAGE_YN = 'Y'
						) as D	
				
						ON 	C.DOC_FOLDER_ID = D.DOC_FOLDER_ID
					)	as E
					
					GROUP BY OTHER_DEPTID, DOC_FOLDER_ID, APR_FOLDER_ID, DOC_FOLDER_NAME, SORTKEY		
				)	as F	
				WHERE	OTHER_DEPTID = @intOtherDeptId AND ACLID = 'Y' 
				ORDER BY SORTKEY

		FETCH NEXT FROM otherDept_Cursor into @intOtherDeptId, @vcOtherDeptName
			
		END	-- end of WHILE#4
		close otherDept_Cursor
		DEALLOCATE otherDept_Cursor
	END	-- end of IF#12
END	-- end of IF#2

SELECT	FOLDER_ID,  FOLDER_NAME + dbo.UF_DOCFOLDER_COUNT_TEMP(@intUserID, TREE_ID), DEPTH, PARENT_FOLDER_ID, APR_FOLDER_ID, DEPT_ID, AUTH_TYPE, TREE_ID
-- select	FOLDER_ID,  FOLDER_NAME + '', DEPTH, PARENT_FOLDER_ID, APR_FOLDER_ID, DEPT_ID, AUTH_TYPE, TREE_ID
FROM	#tree

-- IF @vcTreeMode = 'MENUTREE'
-- 	BEGIN	
-- 		select	FOLDER_ID, 
-- 			CASE APR_FOLDER_ID
-- 				WHEN 'AP' THEN FOLDER_NAME + dbo.UF_DOCFOLDER_COUNT(@intUserID, TREE_ID)
-- 				WHEN 'AF' THEN FOLDER_NAME + dbo.UF_DOCFOLDER_COUNT(@intUserID, TREE_ID)
-- 				WHEN 'R' THEN	FOLDER_NAME + dbo.UF_DOCFOLDER_COUNT(@intUserID, TREE_ID)
-- 				WHEN 'K' THEN	FOLDER_NAME + dbo.UF_DOCFOLDER_COUNT(@intUserID, TREE_ID)
-- 				ELSE FOLDER_NAME
-- 				END
-- 			,DEPTH, PARENT_FOLDER_ID, APR_FOLDER_ID, DEPT_ID, AUTH_TYPE, TREE_ID
-- 		FROM	#tree
-- 	END
-- 
-- ELSE
-- 	BEGIN
-- 		select	FOLDER_ID, 
-- 			CASE APR_FOLDER_ID
-- 				WHEN 'AP' THEN FOLDER_NAME + dbo.UF_DOCFOLDER_COUNT(@intUserID, TREE_ID)
-- 				WHEN 'AF' THEN FOLDER_NAME + dbo.UF_DOCFOLDER_COUNT(@intUserID, TREE_ID)
-- 				ELSE FOLDER_NAME
-- 				END
-- 			,DEPTH, PARENT_FOLDER_ID, APR_FOLDER_ID, DEPT_ID, AUTH_TYPE, TREE_ID
-- 		FROM	#tree
-- 		WHERE APR_FOLDER_ID is null OR APR_FOLDER_ID not in ('K','R')
-- 	END



DROP TABLE #tree

return






















GO
/****** Object:  StoredProcedure [dbo].[UP_LIST_COMMONTREE_TEST]    Script Date: 2015-10-15 오후 1:30:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*----------------------------------------------------------------------
-- 작성자: LDCC 신상훈
-- 작성일: 2004.04.27
-- 수정일: 2004.04.27
-- 설   명: 사용자 트리
-- 테스트 :-- 

EXEC dbo.UP_LIST_COMMONTREE_TEST 111332,'MENUTREE'
----------------------------------------------------------------------*/
CREATE	PROCEDURE	[dbo].[UP_LIST_COMMONTREE_TEST]
	@intUserId		int, 			-- 사용자ID
	@vcTreeMode		varchar(10)		-- ('MENUTREE' : 좌측메뉴트리 / 'POPUPTREE' : 팝업메뉴)
AS

set transaction isolation level read uncommitted

CREATE TABLE [dbo].#tree
(
	[FOLDER_ID] [int] IDENTITY (1, 1) NOT NULL ,
	[FOLDER_NAME] [varchar] (50) COLLATE Korean_Wansung_CI_AS NOT NULL ,
	[DEPTH] [int] NOT NULL,
	[PARENT_FOLDER_ID] [int] NOT NULL,
	[APR_FOLDER_ID] [char](2),
	[DEPT_ID] [int],
	[AUTH_TYPE] [int],
	[TREE_ID] [varchar] (20)
)

DECLARE	@intAuthType		int,		-- 권한유형('0' : 개인문서함 / '1' : 특정권한문서함권한 / '2' : 하위부서문서함권한 / '3' : 겸직부서문서함권한 / '4' : 겸직부서의하위부서문서함권한 / '5')
		@intMainDeptId		int,		-- 주부서ID
		@intSubDeptId		int,		-- 하위부서ID
		@intOtherDeptId		int,		-- 타부서ID
		@intPluralDeptId	int,		-- 겸직부서ID
		@intSubParentDeptId int,		-- 하위부서에서 사용할 ParentId
		@intExistParent		int,		-- Parent가 존재하는지 여부
		@intParentID		int,		-- PARENT_FOLDER_ID를 입력할 변수
		@intExistAcl		int,		-- 권한여부	('1' : 권한있음 / '0' : 권한없음)
		@intDepth			int,		-- 트리의 레벨정보
		@intLevel			int,		-- 하위부서테이블에서 가져온 레벨정보
		@intGap				int,		-- 레벨정보를 실제 트리에 맞게 변환하기 위해 사용하는 임시변수
		@cAclId				char(1),		-- 권한종류	('Y' : 허용 / 'N' : 거절 / NULL : 권한없음)			
		@cSeparator			char(1),			-- 구분자
		@cFolderType		char(1),			-- 폴더타입 ('P' : 개인결재함 / 'D' : 부서결재함 / 'F' : 폴더)
		@vcPluralDeptName	varchar(100),	
		@vcSubDeptName 		varchar(100),
		@vcOtherDeptName	varchar(100),
		@vcRootFolderName	varchar(50)		-- Root폴더명

/*
SET @intUserId = 10021
SET @vcTreeMode = 'MENUTREE'
*/

SET @vcRootFolderName = (SELECT DOC_FOLDER_NAME FROM eWFFORM.dbo.WF_DOC_FOLDER WHERE APR_FOLDER_ID = 'RT')
SET @cSeparator = '|'
----------------------------------------------------------------------------------------
-- 설    명 : 개인결재함의 Root는 회사 이름으로 한다.
----------------------------------------------------------------------------------------
SET @intAuthType = 0 -- Root의 AuthType은 0
SET @intDepth = 0 -- Root의 Depth는 0
SET @cFolderType = 'F'
INSERT INTO [dbo].#tree(FOLDER_NAME, DEPTH, PARENT_FOLDER_ID, AUTH_TYPE, TREE_ID)
-- SELECT DISTINCT '롯데정보통신(주)', @intDepth, 0, @intAuthType, 'XXX' + @cSeparator + 'XXX'	 + @cSeparator + @cFolderType	-- 부서ID나 APR_FOLDER_ID가 없을 경우 'XXX'로 넣는다. 'F'는 폴더를 의미한다.
SELECT DISTINCT @vcRootFolderName, @intDepth, 0, @intAuthType, 'XXX' + @cSeparator + 'XXX'	 + @cSeparator + @cFolderType	-- 부서ID나 APR_FOLDER_ID가 없을 경우 'XXX'로 넣는다. 'F'는 폴더를 의미한다.

----------------------------------------------------------------------------------------
-- 설    명 : 개인결재함의 Root는 사용자 이름으로 한다.
----------------------------------------------------------------------------------------
SET @intAuthType = 1	-- 개인결재함의 경우
SET @intDepth = 1
SET @cFolderType = 'F'

INSERT INTO [dbo].#tree(FOLDER_NAME, DEPTH, PARENT_FOLDER_ID, AUTH_TYPE, TREE_ID)
-- 겸직부서를 가지고 있는 사용자일 경우 결과가 2행이 나오기 때문에 DISTINCT 처리 함
SELECT DISTINCT UserName, @intDepth, 1, @intAuthType, 'XXX' + @cSeparator + 'XXX' + @cSeparator + @cFolderType
FROM eManage.dbo.VW_USER (NOLOCK)
WHERE UserId = @intUserId AND EndDate > getdate()

IF @vcTreeMode = 'MENUTREE'	
BEGIN	-- IF#1
----------------------------------------------------------------------------------------
-- 설    명 : 개인결재함을 구성하는 문서함을 테이블에 넣는다.
----------------------------------------------------------------------------------------

SET @intParentID = @@IDENTITY
SET @intDepth = 2
SET @cFolderType = 'P'
INSERT INTO [dbo].#tree(FOLDER_NAME, DEPTH, PARENT_FOLDER_ID, APR_FOLDER_ID, DEPT_ID, TREE_ID)
SELECT	DOC_FOLDER_NAME, @intDepth, @intParentID, APR_FOLDER_ID, @intMainDeptId, 
		rtrim(Isnull(cast(@intMainDeptId as varchar(10)), 'XXX')) + @cSeparator +  rtrim(Isnull(APR_FOLDER_ID, 'XXX')) + @cSeparator + @cFolderType
FROM	eWFFORM.dbo.WF_DOC_FOLDER(NOLOCK)
WHERE	APR_FOLDER_TYPE = 'P' AND USAGE_YN = 'Y'
ORDER BY SORTKEY


END	-- end of IF#1

IF @vcTreeMode = 'POPUPTREE'	
BEGIN	-- IF#1-1
----------------------------------------------------------------------------------------
-- 설    명 : 관련근거문서용 트리구성
----------------------------------------------------------------------------------------

SET @intParentID = @@IDENTITY
SET @intDepth = 2
SET @cFolderType = 'P'
INSERT INTO [dbo].#tree(FOLDER_NAME, DEPTH, PARENT_FOLDER_ID, APR_FOLDER_ID, DEPT_ID, TREE_ID)
SELECT	DOC_FOLDER_NAME, @intDepth, @intParentID, APR_FOLDER_ID, @intMainDeptId,
		rtrim(Isnull(cast(@intMainDeptId as varchar(10)), 'XXX')) + @cSeparator +  rtrim(Isnull(APR_FOLDER_ID, 'XXX')) + @cSeparator + @cFolderType
FROM	eWFFORM.dbo.WF_DOC_FOLDER(NOLOCK)
WHERE	APR_FOLDER_TYPE = 'P' AND USAGE_YN = 'Y' AND APR_FOLDER_ID = 'CO'
ORDER BY SORTKEY

END	-- end of IF#1-1


----------------------------------------------------------------------------------------
-- 설    명 : 부서결재함의 Root는 자신이 소속되어 있는 주부서 이름으로 한다
----------------------------------------------------------------------------------------
SET @intAuthType = 2	-- 자기부서결재함의 경우
SET @intDepth = 1
SET @cFolderType = 'F'
INSERT INTO [dbo].#tree(FOLDER_NAME, DEPTH, PARENT_FOLDER_ID, DEPT_ID, AUTH_TYPE, TREE_ID)
SELECT	DeptName, @intDepth, 1, DeptId, @intAuthType, rtrim(Isnull(cast(@intMainDeptId as varchar(10)), 'XXX')) + @cSeparator +  'XXX' + @cSeparator + @cFolderType
  FROM	eManage.dbo.VW_USER(NOLOCK)
WHERE	PositionOrder = 1 
     AND  UserId = @intUserId and EndDate > getdate()

IF @vcTreeMode = 'MENUTREE' or @vcTreeMode = 'POPUPTREE'
BEGIN	-- IF#2
----------------------------------------------------------------------------------------
-- 설    명 : 부서결재함에서 권한이 없이도 볼 수 있는 문서함을 테이블에 넣는다(트리용)
----------------------------------------------------------------------------------------
SET @intParentID = @@IDENTITY
SET @intMainDeptId = (SELECT DEPT_ID FROM [dbo].#tree WHERE FOLDER_ID = @intParentID)
SET @intDepth = 2
SET @cFolderType = 'D'
INSERT INTO [dbo].#tree(FOLDER_NAME, DEPTH, PARENT_FOLDER_ID, APR_FOLDER_ID, DEPT_ID, TREE_ID)
SELECT	DOC_FOLDER_NAME, @intDepth, @intParentID, APR_FOLDER_ID, @intMainDeptId, rtrim(Isnull(cast(@intMainDeptId as varchar(10)), 'XXX')) + @cSeparator + rtrim(Isnull(APR_FOLDER_ID, 'XXX')) + @cSeparator + @cFolderType
FROM	eWFFORM.dbo.WF_DOC_FOLDER(NOLOCK)
WHERE	APR_FOLDER_TYPE = 'D' AND DOC_FOLDER_TYPE = 'G' AND USAGE_YN = 'Y'
ORDER BY	SORTKEY

----------------------------------------------------------------------------------------
-- 설    명: 로그인한 사용자와 그 사용자가 속한 부서가 특정권한문서함에 대한 권한을 가지고 있는지 여부를 조회한다.
--	   @intExistAcl = 1이면 권한이 있고, 0 이면 권한이 없는 것이다.(부서권한까지 중복체크한다.)
----------------------------------------------------------------------------------------
SET	@intExistAcl = 	(

	SELECT	COUNT(C.DeptId)
	FROM	(
		-- 사용자권한 조회
		SELECT		A.DeptId			
		FROM		eManage.dbo.VW_USER as A
				INNER JOIN	(
				SELECT		USERID, DEPTID 
				FROM		eWFFORM.dbo.WF_ACL_SPECIAL_FOLDER(NOLOCK)
				WHERE		USER_TYPE = 'D'			
				) as B
				ON A.DeptID = B.DEPTID
		WHERE		B.DeptId = @intMainDeptId and A.EndDate > getdate()
	
		UNION
		-- 부서권한 조회	
		SELECT		A.DeptId
		FROM		eManage.dbo.VW_USER as A
				INNER JOIN	(
				SELECT		USERID, DEPTID 
				FROM		eWFFORM.dbo.WF_ACL_SPECIAL_FOLDER(NOLOCK)
				WHERE		USER_TYPE = 'P'			
				) as B
				ON A.DeptID = B.DEPTID
		WHERE		B.UserId = @intUserId AND B.DeptId = @intMainDeptId and A.EndDate > getdate()
		)	as C
)



-- 권한이 있는 경우
IF	@intExistAcl = 1
BEGIN	-- IF#3
	SET @intDepth = 2
	INSERT INTO 	[dbo].#tree(FOLDER_NAME, DEPTH, PARENT_FOLDER_ID, APR_FOLDER_ID, DEPT_ID, TREE_ID)
	SELECT	D.DOC_FOLDER_NAME, @intDepth, @intParentID, D.APR_FOLDER_ID, @intMainDeptId, rtrim(Isnull(cast(@intMainDeptId as varchar(10)), 'XXX')) + @cSeparator + rtrim(Isnull(APR_FOLDER_ID, 'XXX')) + @cSeparator + @cFolderType
	FROM	(
		SELECT  DEPTID, DOC_FOLDER_ID, CASE AVG(ACLID) WHEN 0 THEN 'N' WHEN 1 THEN 'Y' END AS ACLID ,  APR_FOLDER_ID, DOC_FOLDER_NAME, SORTKEY
			FROM
			(
				SELECT		A.DEPTID, A.DOC_FOLDER_ID, A.ACLID, B.APR_FOLDER_ID, B.DOC_FOLDER_NAME, B.SORTKEY
					FROM
						(
							   SELECT	USERID, DEPTID, DOC_FOLDER_ID,	case ACLID  when 'Y' then 1 when 'N' then 0 end as aclid, USER_TYPE
							        FROM	eWFFORM.dbo.WF_ACL_SPECIAL_FOLDER(NOLOCK)
								WHERE	DEPTID = @intMainDeptId AND USER_TYPE = 'D'
						) as A
							  INNER JOIN
						(
							  SELECT 	DOC_FOLDER_NAME, DOC_FOLDER_ID, APR_FOLDER_ID, SORTKEY
							       FROM	eWFFORM.dbo.Wf_DOC_FOLDER(NOLOCK)
								WHERE	APR_FOLDER_TYPE = 'D' AND DOC_FOLDER_TYPE = 'S' AND USAGE_YN = 'Y'					
						) as B
						
							ON 	A.DOC_FOLDER_ID = B.DOC_FOLDER_ID
					
				UNION 
				
				SELECT		A.DEPTID, A.DOC_FOLDER_ID, case ACLID  when 'Y' then 1 when 'N' then 0 end as aclid, B.APR_FOLDER_ID, B.DOC_FOLDER_NAME, B.SORTKEY
					FROM 
						(
							SELECT		USERID, DEPTID, DOC_FOLDER_ID,	ACLID, USER_TYPE
							      FROM	eWFFORM.dbo.WF_ACL_SPECIAL_FOLDER(NOLOCK)
								WHERE	USERID = @intUserId AND DEPTID = @intMainDeptId AND USER_TYPE = 'P'
						) as A
							INNER JOIN
						(	
							SELECT		DOC_FOLDER_NAME, DOC_FOLDER_ID, APR_FOLDER_ID, SORTKEY
							      FROM	eWFFORM.dbo.Wf_DOC_FOLDER(NOLOCK)
								WHERE	APR_FOLDER_TYPE = 'D' AND DOC_FOLDER_TYPE = 'S' AND USAGE_YN = 'Y'					
						) as B
							ON 	A.DOC_FOLDER_ID = B.DOC_FOLDER_ID
			)	as C
					
		GROUP BY DEPTID, DOC_FOLDER_ID, APR_FOLDER_ID, DOC_FOLDER_NAME, SORTKEY		
		)	as D
	WHERE	D.ACLID = 'Y'

	ORDER BY D.SORTKEY

END	-- end of IF#3



----------------------------------------------------------------------------------------
-- 설    명: 로그인한 사용자가 하위부서에 대한 권한을 가지고 있는지 여부를 조회한다.(부서권한까지 중복체크한다.)
--	   @deptAclId = 'Y'이면 권한을 가진 부서이고 'N'이면 권한이 없는 부서이다.
----------------------------------------------------------------------------------------

SET	@cAclId =
	(
		-- 사용자/부서권한 중복체크 후 결과
		SELECT  CASE AVG(ACLID)  WHEN 0 THEN 'N' WHEN 1 THEN 'Y' END AS ACLID
		FROM
		(
			-- 사용자권한체크
			SELECT	DEPTID, CASE ACLID WHEN 'Y' THEN 1 WHEN 'N' THEN 0 END as ACLID
			FROM	eWFFORM.dbo.WF_ACL_SUBDEPT(NOLOCK)			
			WHERE	USERID = @intUserId AND DEPTID = @intMainDeptId AND USER_TYPE = 'P'
			
			UNION
			
			-- 부서권한체크
			SELECT	DEPTID,	CASE ACLID WHEN 'Y' THEN 1 WHEN 'N' THEN 0 END as ACLID
			FROM	eWFFORM.dbo.WF_ACL_SUBDEPT(NOLOCK)	
			WHERE	DEPTID = @intMainDeptId AND USER_TYPE = 'D'
		)	as A
		GROUP BY DEPTID
		
	)
-- 결과값이 없으면 @cAclId를 'N'으로 설정한다.
IF @cAclId IS NULL
BEGIN	-- IF#4
	SET @cAclId = 'N'
END	-- end of IF#4


IF @cAclId = 'Y'
BEGIN	-- IF#5
----------------------------------------------------------------------------------------
-- 설    명: 하위부서에 대한 권한이 있을 경우 소속부서의 최하위 부서까지 조회한다.
----------------------------------------------------------------------------------------
	
DECLARE
	subDept_Cursor  cursor for
		SELECT a.DeptName, a.ParentDeptID, a.DeptID, a.Level
		FROM eManage.dbo.UF_SELECT_SUBDEPT_ALL(@intMainDeptId) as a
		Left Join eManage.dbo.TB_DEPT as b
		on a.ParentDeptID = b.DeptID

	open subDept_Cursor

	FETCH NEXT FROM subDept_Cursor into @vcSubDeptName, @intSubParentDeptId, @intSubDeptId, @intLevel
	SET @intGap = 2 - @intLevel
	WHILE @@FETCH_STATUS  = 0
                begin	-- WHILE#1
		SET @intDepth = @intLevel + @intGap
		-- #tree 테이블에 Dept_ID가 해당행의 ParentDeptID인 행을 조회한다.		
		SET @intExistParent = (SELECT FOLDER_ID
		FROM [dbo].#tree
		WHERE Dept_ID = @intSubParentDeptId AND AUTH_TYPE = 2 AND APR_FOLDER_ID IS NULL)		

		IF @intExistParent IS NOT NULL
		BEGIN	-- IF#6			
			SET @intSubParentDeptId = @intExistParent
		END 	-- end of IF#6		

		SET @cFolderType = 'F'	-- 폴더
		INSERT INTO [dbo].#tree(FOLDER_NAME, DEPTH, PARENT_FOLDER_ID, DEPT_ID, AUTH_TYPE, TREE_ID)
		SELECT @vcSubDeptName, @intDepth, @intSubParentDeptId, @intSubDeptId, @intAuthType, 'XXX' + @cSeparator + 'XXX' + @cSeparator + @cFolderType
		SET @intParentID = @@IDENTITY

		SET @cFolderType = 'D'	-- 부서문서함
		SET @intDepth = @intDepth + 1
		INSERT INTO [dbo].#tree(FOLDER_NAME, DEPTH, PARENT_FOLDER_ID, APR_FOLDER_ID, DEPT_ID, TREE_ID)
		SELECT	DOC_FOLDER_NAME, @intDepth, @intParentID, APR_FOLDER_ID, @intSubDeptId, rtrim(Isnull(@intSubDeptId, 'XXX')) + @cSeparator + rtrim(Isnull(APR_FOLDER_ID, 'XXX')) + @cSeparator + @cFolderType
		FROM	eWFFORM.dbo.WF_DOC_FOLDER(NOLOCK)
		WHERE	APR_FOLDER_TYPE = 'D' AND DOC_FOLDER_TYPE = 'G' AND USAGE_YN = 'Y'
		ORDER BY SORTKEY

		FETCH NEXT FROM subDept_Cursor into @vcSubDeptName, @intSubParentDeptId, @intSubDeptId, @intLevel
	end	-- end of WHILE#1

close subDept_Cursor
DEALLOCATE subDept_Cursor

END	-- end of IF#5


----------------------------------------------------------------------------------------
-- 설    명: 로그인한 사용자가 겸직부서가 있는지 여부를 조회한다.
--	   @intExistAcl >= 1이면 겸직부서가 있는 사용자이고 0 이면 겸직부서가 없는 사용자이다.
----------------------------------------------------------------------------------------
SET @intAuthType = 3	-- 겸직부서의 결재함은 AUTH_TYPE을 3으로 설정한다.
SET @intExistAcl = 
(	SELECT COUNT(DeptId)
	FROM eManage.dbo.VW_USER(NOLOCK)
	WHERE UserId = @intUserId AND PositionOrder <> 1 AND EndDate > getdate()
)


IF @intExistAcl >= 1
	BEGIN	-- IF#7		
		DECLARE
		pluralDept_Cursor  cursor for
			SELECT DeptName, DeptId
			FROM eManage.dbo.VW_USER(NOLOCK)
			WHERE UserId = @intUserId AND PositionOrder <> 1 AND EndDate > getdate()		
		open pluralDept_Cursor

		FETCH NEXT FROM pluralDept_Cursor into @vcPluralDeptName, @intPluralDeptId

		WHILE @@FETCH_STATUS  = 0
		BEGIN	-- WHILE#2
		SET @intDepth = 1	-- 겸직부서는 개인결재함, 부서결재함과 동일한 레벨에 있다.	
		SET @cFolderType = 'F'	
			INSERT INTO [dbo].#tree(FOLDER_NAME, DEPTH, PARENT_FOLDER_ID, DEPT_ID, AUTH_TYPE, TREE_ID)
			SELECT @vcPluralDeptName, @intDepth, 1, @intPluralDeptId, @intAuthType, 'XXX' + @cSeparator + 'XXX' + @cSeparator + @cFolderType
			SET @intParentID = @@IDENTITY

			-- 권한이 없어도 볼 수 있는 부서문서함
			
			SET @intDepth = @intDepth + 1
			SET @cFolderType = 'D'
			INSERT INTO [dbo].#tree(FOLDER_NAME, DEPTH, PARENT_FOLDER_ID, APR_FOLDER_ID, DEPT_ID, TREE_ID)
			SELECT	DOC_FOLDER_NAME, @intDepth, @intParentID, APR_FOLDER_ID, @intPluralDeptId, rtrim(Isnull(cast(@intPluralDeptId as varchar(10)), 'XXX')) + @cSeparator + rtrim(Isnull(APR_FOLDER_ID, 'XXX')) + @cSeparator + @cFolderType
			FROM	eWFFORM.dbo.WF_DOC_FOLDER(NOLOCK)
			WHERE	APR_FOLDER_TYPE = 'D' AND DOC_FOLDER_TYPE = 'G' AND USAGE_YN = 'Y'
			ORDER BY SORTKEY

----------------------------------------------------------------------------------------
-- 설    명: 겸직부서와 겸직부서의 구성원인 사용자가 특정권한문서함에 대한 권한을 가지고 있는지 조회한다.
--	   @intExistAcl = 1이면 특정권한문서함을 볼 수 있고, 0 이면 볼 수 없다.
----------------------------------------------------------------------------------------		
				
			SET	@intExistAcl = 	(
				SELECT	COUNT(C.DeptId)
				FROM	(
					-- 겸직부서권한 조회
					SELECT		A.DeptId			
					FROM		eManage.dbo.VW_USER as A
					INNER JOIN	(
					SELECT		USERID, DEPTID 
					FROM		eWFFORM.dbo.WF_ACL_SPECIAL_FOLDER(NOLOCK)
					WHERE		USER_TYPE = 'D'			
					) as B
					ON A.DeptID = B.DEPTID
					WHERE		B.DeptId = @intPluralDeptId AND A.EndDate > getdate()
							
				UNION
					-- 겸직부서 사용자권한 조회	
					SELECT	A.DeptId
					FROM	
						eManage.dbo.VW_USER as A
						INNER JOIN	(
						SELECT		USERID, DEPTID 
						FROM		eWFFORM.dbo.WF_ACL_SPECIAL_FOLDER(NOLOCK)
						WHERE		USER_TYPE = 'P'			
						) as B
						ON A.DeptID = B.DEPTID
					WHERE		B.UserId = @intUserId AND B.DeptId = @intPluralDeptId AND A.EndDate > getdate()
				)	as C
			)

----------------------------------------------------------------------------------------
-- 설    명: 겸직부서와 겸직부서의 구성원인 사용자가 특정권한문서함에 대한 권한을 가지고 있는 경우
----------------------------------------------------------------------------------------				
				IF	@intExistAcl = 1
				BEGIN	-- IF#8
					SET @cFolderType = 'D'
					INSERT INTO 	[dbo].#tree(FOLDER_NAME, DEPTH, PARENT_FOLDER_ID, APR_FOLDER_ID, DEPT_ID, TREE_ID)
					SELECT	D.DOC_FOLDER_NAME, @intDepth, @intParentID, D.APR_FOLDER_ID, @intPluralDeptId, rtrim(Isnull(cast(@intPluralDeptId as varchar(10)), 'XXX')) + @cSeparator + rtrim(Isnull(APR_FOLDER_ID, 'XXX')) + @cSeparator + @cFolderType
					FROM	(
						SELECT  DEPTID, DOC_FOLDER_ID, CASE AVG(ACLID) WHEN 0 THEN 'N' WHEN 1 THEN 'Y' END AS ACLID ,  APR_FOLDER_ID, DOC_FOLDER_NAME, SORTKEY
							FROM
							(
							SELECT		A.DEPTID, A.DOC_FOLDER_ID, A.ACLID, B.APR_FOLDER_ID, B.DOC_FOLDER_NAME, B.SORTKEY
								FROM
									(
									SELECT		USERID, DEPTID, DOC_FOLDER_ID,	case ACLID  when 'Y' then 1 when 'N' then 0 end as aclid, USER_TYPE
									FROM		eWFFORM.dbo.WF_ACL_SPECIAL_FOLDER(NOLOCK)
									WHERE		DEPTID = @intPluralDeptId AND USER_TYPE = 'D'
									) as A
										INNER JOIN
									(
									SELECT 	DOC_FOLDER_NAME, DOC_FOLDER_ID, APR_FOLDER_ID, SORTKEY
									FROM	 	eWFFORM.dbo.Wf_DOC_FOLDER(NOLOCK)
									WHERE	APR_FOLDER_TYPE = 'D' AND DOC_FOLDER_TYPE = 'S' AND USAGE_YN = 'Y'
									) as B
									
										ON 	A.DOC_FOLDER_ID = B.DOC_FOLDER_ID
								
									UNION 
							
									SELECT		A.DEPTID, A.DOC_FOLDER_ID, case ACLID  when 'Y' then 1 when 'N' then 0 end as aclid, B.APR_FOLDER_ID, B.DOC_FOLDER_NAME, B.SORTKEY
									FROM 
									(
									SELECT		USERID, DEPTID, DOC_FOLDER_ID,	ACLID, USER_TYPE
									FROM		eWFFORM.dbo.WF_ACL_SPECIAL_FOLDER(NOLOCK)
									WHERE		USERID = @intUserId AND DEPTID = @intPluralDeptId AND USER_TYPE = 'P'
									) as A
										INNER JOIN
									(	
									SELECT		DOC_FOLDER_NAME, DOC_FOLDER_ID, APR_FOLDER_ID, SORTKEY
									FROM		eWFFORM.dbo.Wf_DOC_FOLDER(NOLOCK)
									WHERE	APR_FOLDER_TYPE = 'D' AND DOC_FOLDER_TYPE = 'S' AND USAGE_YN = 'Y'
									) as B
									ON 		A.DOC_FOLDER_ID = B.DOC_FOLDER_ID
							)	as C
									
						GROUP BY DEPTID, DOC_FOLDER_ID, APR_FOLDER_ID, DOC_FOLDER_NAME, SORTKEY		
						)	as D
					WHERE	D.ACLID = 'Y'
					ORDER BY SORTKEY
				END	-- end of IF#8


----------------------------------------------------------------------------------------
-- 설    명: 겸직부서와 겸직부서의 구성원인 사용자가 하위부서 문서함에 대한 권한을 가지고 있지 체크(부서권한중복체크)
----------------------------------------------------------------------------------------
			SET	@cAclId =
				(
					-- 사용자/부서권한 중복체크 후 결과
					SELECT  CASE AVG(ACLID)  WHEN 0 THEN 'N' WHEN 1 THEN 'Y' END AS ACLID
					FROM
					(
						-- 사용자권한체크
						SELECT	DEPTID, CASE ACLID WHEN 'Y' THEN 1 WHEN 'N' THEN 0 END as ACLID
						FROM	eWFFORM.dbo.WF_ACL_SUBDEPT(NOLOCK)			
						WHERE	USERID = @intUserId AND DEPTID = @intPluralDeptId AND USER_TYPE = 'P'
						
						UNION
						
						-- 부서권한체크
						SELECT	DEPTID,	CASE ACLID WHEN 'Y' THEN 1 WHEN 'N' THEN 0 END as ACLID
						FROM	eWFFORM.dbo.WF_ACL_SUBDEPT(NOLOCK)			
						WHERE	DEPTID = @intPluralDeptId AND USER_TYPE = 'D'			
					)	as A
					GROUP BY DEPTID
					
				)
			-- 결과값이 없으면 @cAclId를 'N'으로 설정한다.
			IF @cAclId IS NULL
			BEGIN	-- IF#9
				SET @cAclId = 'N'
			END	-- end of IF#9
	
			IF @cAclId = 'Y'
			BEGIN	-- IF#10
----------------------------------------------------------------------------------------
-- 설    명: 하위부서에 대한 권한이 있을 경우 겸직부서의 최하위 부서까지 조회한다.
----------------------------------------------------------------------------------------
				DECLARE
				pluralSubDept_Cursor  cursor for
					SELECT a.DeptName, a.ParentDeptID, a.DeptID, a.Level
					FROM eManage.dbo.UF_SELECT_SUBDEPT_ALL(@intPluralDeptId) as a
					Left Join eManage.dbo.TB_DEPT as b
					on a.ParentDeptID = b.DeptID
				
				open pluralSubDept_Cursor				
				FETCH NEXT FROM pluralSubDept_Cursor into @vcSubDeptName, @intSubParentDeptId, @intSubDeptId, @intLevel
				SET @intGap = 2 - @intLevel	-- 겸직부서의 첫번째 하위부서의 Depth를 2로 맞춰주기 위한 방법

				WHILE @@FETCH_STATUS  = 0
				BEGIN	-- WHILE#3
					SET @intDepth = @intLevel + @intGap
					-- #tree 테이블에 Dept_ID가 해당행의 ParentDeptID인 행을 조회한다.
					SET @intExistParent = (SELECT FOLDER_ID
					FROM [dbo].#tree
					WHERE Dept_ID = @intSubParentDeptId AND AUTH_TYPE = 3 AND APR_FOLDER_ID IS NULL)
				
					IF @intExistParent IS NOT NULL	-- 상위부서가 있는 경우
					BEGIN	-- IF#11				
						SET @intSubParentDeptId = @intExistParent	-- 상위부서의 FOLDER_ID를 자신의 Parent_Dept_Id로 변환한다.
						SET @intDepth = @intDepth + 1
					END 	-- end of IF#11			
							
					SET @cFolderType = 'F'
					INSERT INTO [dbo].#tree(FOLDER_NAME, DEPTH, PARENT_FOLDER_ID, DEPT_ID, AUTH_TYPE, TREE_ID)
					SELECT @vcSubDeptName, @intDepth, @intSubParentDeptId, @intSubDeptId, @intAuthType, 'XXX' + @cSeparator + 'XXX' + @cSeparator + @cFolderType
					SET @intParentID = @@IDENTITY
							
					SET @intDepth = @intDepth + 1
					SET @cFolderType = 'D'
					-- 하위부서의 문서함은 일반문서함만 볼 수 있다.
					INSERT INTO [dbo].#tree(FOLDER_NAME, DEPTH, PARENT_FOLDER_ID, APR_FOLDER_ID, DEPT_ID, TREE_ID)
					SELECT	DOC_FOLDER_NAME, @intDepth, @intParentID, APR_FOLDER_ID, @intSubDeptId, rtrim(Isnull(cast(@intSubDeptId as varchar(10)), 'XXX')) + @cSeparator + rtrim(Isnull(APR_FOLDER_ID, 'XXX')) + @cSeparator + @cFolderType
					FROM	eWFFORM.dbo.WF_DOC_FOLDER(NOLOCK)
					WHERE	APR_FOLDER_TYPE = 'D' AND DOC_FOLDER_TYPE = 'G' AND USAGE_YN = 'Y'	
					ORDER BY SORTKEY
				
					FETCH NEXT FROM pluralSubDept_Cursor into @vcSubDeptName, @intSubParentDeptId, @intSubDeptId, @IntLevel
				END	-- end of WHILE#3			
			CLOSE pluralSubDept_Cursor
			DEALLOCATE pluralSubDept_Cursor
			END	-- end of IF#10
					
	  	FETCH NEXT FROM pluralDept_Cursor into @vcPluralDeptName, @intPluralDeptId

		END	-- end of WHILE#2
		close pluralDept_Cursor
		DEALLOCATE pluralDept_Cursor

	END	-- end of IF#7



----------------------------------------------------------------------------------------
-- 설    명: 로그인한 사용자나 사용자가 속한 부서가 타부서에 대한 권한이 있는지 여부를 조회한다.
--	   @intExistAcl >= 1 이면 타부서의 권한이 있는 사용자나 부서이고 0 이면 권한이 없는 사용자나 부서이다.
----------------------------------------------------------------------------------------
SET @intExistAcl = 
		(
		SELECT	COUNT(*)
		FROM
			(
			-- 로그인한 사용자가 속한 주부서 및 겸직부서의 타부서문서함에 대한 사용자권한을 조회한다.
			SELECT A.UserId, A.DeptId, A.OTHER_DEPTID, A.DOC_FOLDER_ID, A.ACLID
			FROM
				(
				SELECT		USERID, DEPTID, OTHER_DEPTID, DOC_FOLDER_ID, ACLID
				FROM		eWFFORM.dbo.WF_ACL_OTHER_DEPT(NOLOCK)
				WHERE		USERID = @intUserId AND USER_TYPE = 'P'
				)	as A
		
				INNER JOIN
		
				(
				SELECT UserId, DeptId
				FROM eManage.dbo.VW_USER(NOLOCK)
				WHERE UserId = @intUserId AND EndDate > getdate()
				)	as B
				ON A.UserId = B.UserId AND A.DeptId = B.DeptId
				
			UNION 
		
			-- 로그인한 사용자가 속한 주부서 및 겸직부서의 타부서문서함에 대한 부서권한을 조회한다.
			SELECT A.UserId, A.DeptId, A.OTHER_DEPTID, A.DOC_FOLDER_ID, A.ACLID	
			FROM
				(
				SELECT		USERID, DEPTID, OTHER_DEPTID, DOC_FOLDER_ID, ACLID, USER_TYPE
				FROM		eWFFORM.dbo.WF_ACL_OTHER_DEPT(NOLOCK)
				)	as A
		
				INNER JOIN		
			
				(
				SELECT UserId, DeptId
				FROM eManage.dbo.VW_USER(NOLOCK)
				WHERE UserId = @intUserId AND EndDate > getdate()	-- 현재 실재하고 있는 겸직부서 조회
				)	as B
		
				ON A.USER_TYPE = 'D' AND A.DeptId = B.DeptId
			)	as C
		)

IF @intExistAcl > 0		-- 로그인한 사용자에게 타부서권한이 주어졌을 때
BEGIN	-- IF#12

----------------------------------------------------------------------------------------
-- 설    명: 권한중복체크를 통해 최종적으로 사용자가 볼 수 있는 타부서를 뽑아낸다.
--	   Cursor를 사용하여 타부서마다 볼수 있는 문서함정보를 #tree에 넣는다.
----------------------------------------------------------------------------------------
	DECLARE
		otherDept_Cursor  cursor for
			SELECT	DISTINCT OTHER_DEPTID, OTHER_DEPT_NAME
			FROM
				(			
				SELECT DISTINCT C.DEPTID, C.OTHER_DEPTID, D.DeptName as OTHER_DEPT_NAME, C.DOC_FOLDER_ID, C.ACLID
				FROM
					(
					-- 로그인한 사용자가 속한 주부서 및 겸직부서의 타부서문서함에 대한 사용자권한을 조회한다.
					SELECT	DISTINCT A.USERID, A.DEPTID, A.OTHER_DEPTID, A.DOC_FOLDER_ID, A.ACLID
					FROM	
						(
						-- 사용자의 타부서권한을 가져온다.
						SELECT	USERID, DEPTID, OTHER_DEPTID, DOC_FOLDER_ID, ACLID
						FROM 	eWFFORM.dbo.WF_ACL_OTHER_DEPT(NOLOCK)
						 -- 겸직부서의 사용자권한도 가져오기 위해 사용자의 DeptId는 검색조건에서 뺀다.
						WHERE	USERID = @intUserId AND USER_TYPE = 'P'	
						)	as A
						INNER JOIN
						(
						-- A 에서 가져온 결과중 실제로 겸직을 하고 있는(퇴직이나 겸직에서 빠지지 않은) 사용자의 부서를 가져온다.					
						SELECT UserId, DeptId, DeptName
						FROM eManage.dbo.VW_USER(NOLOCK)
						WHERE UserId = @intUserId AND EndDate > getdate()
						)	as B
						ON A.UserId = B.UserId AND A.DeptId = B.DeptId				
					)	as C
			
					INNER JOIN
			
					(
					-- 타부서의 이름을 가져오기 위해 VW_USER와 조인을 한다.
					SELECT 	DeptId, DeptName
					FROM	eManage.dbo.VW_DEPT(NOLOCK)	
					)	as D
					ON 	D.DeptId = C.OTHER_DEPTID	-- 타부서ID를 이용해 타부서 이름을 가져온다.				
					
				UNION 
			
				-- 로그인한 사용자가 속한 주부서 및 겸직부서의 타부서문서함에 대한 부서권한을 조회한다.
				SELECT DISTINCT C.DEPTID, C.OTHER_DEPTID, D.DeptName as OTHER_DEPT_NAME, C.DOC_FOLDER_ID, C.ACLID
				FROM
					(
					SELECT	DISTINCT A.DEPTID, A.OTHER_DEPTID, A.DOC_FOLDER_ID, A.ACLID
					FROM
						(
						SELECT		USERID, DEPTID, OTHER_DEPTID, DOC_FOLDER_ID, ACLID, USER_TYPE
						FROM		eWFFORM.dbo.WF_ACL_OTHER_DEPT(NOLOCK)
						WHERE		USER_TYPE = 'D'
						)	as A		
						INNER JOIN					
						(
						-- 타부서의 이름을 가져오기 위해 VW_USER와 조인을 한다.
						SELECT UserId, DeptId, DeptName
						FROM eManage.dbo.VW_USER(NOLOCK)
						WHERE UserId = @intUserId AND EndDate > getdate()	-- 현재 실재하고 있는 겸직부서 조회
						)	as B
						ON 	B.DeptId = A.DEPTID	-- 타부서ID를 이용해 타부서 이름을 가져온다.		
					)	as C
					
					INNER JOIN
			
					(
					-- 타부서의 이름을 가져오기 위해 VW_USER와 조인을 한다.
					SELECT 	DeptId, DeptName
					FROM	eManage.dbo.VW_DEPT(NOLOCK)	
					)	as D
					ON 	D.DeptId = C.OTHER_DEPTID	-- 타부서ID를 이용해 타부서 이름을 가져온다.		
	
				)	as E
			WHERE ACLID = 'Y'

		open otherDept_Cursor	-- 커서 시작

		FETCH NEXT FROM otherDept_Cursor into @intOtherDeptId, @vcOtherDeptName

		WHILE @@FETCH_STATUS  = 0
		BEGIN	-- WHILE#4
			SET @intAuthType = 4
			SET @intDepth = 1	-- 타부서의 레벨은 개인결재함, 부서결재함과 동일하다
			SET @cFolderType = 'F'
			INSERT INTO [dbo].#tree(FOLDER_NAME, DEPTH, PARENT_FOLDER_ID, DEPT_ID, AUTH_TYPE, TREE_ID)
			SELECT @vcOtherDeptName, @intDepth, 1, @intOtherDeptId, @intAuthType, 'XXX' + @cSeparator + 'XXX' + @cSeparator + @cFolderType
			SET @intParentID = @@IDENTITY			
			
----------------------------------------------------------------------------------------
-- 설    명: 사용자(주부서), 주부서, 사용자(겸직부서), 겸직부서의 4번의 중복체크를 통해서 
--	   로그인한 사용자가 볼 수 있는 문서함의 리스트를 가져와서 #tree에 넣는다.
----------------------------------------------------------------------------------------
			SET @intDepth = @intDepth + 1
			SET @cFolderType = 'D'
			INSERT INTO [dbo].#tree(FOLDER_NAME, DEPTH, PARENT_FOLDER_ID, APR_FOLDER_ID, DEPT_ID, TREE_ID)
			SELECT	DOC_FOLDER_NAME, @intDepth, @intParentID, APR_FOLDER_ID, OTHER_DEPTID, rtrim(Isnull(cast(OTHER_DEPTID as varchar(10)), 'XXX')) + @cSeparator + rtrim(Isnull(APR_FOLDER_ID, 'XXX')) + @cSeparator + @cFolderType			
			FROM
				(
					-- 권한이 0 이면 '거절', 1 이면 '허용' 이다.
					SELECT  OTHER_DEPTID, DOC_FOLDER_ID, CASE AVG(ACLID) WHEN 0 THEN 'N' WHEN 1 THEN 'Y' END AS ACLID ,  APR_FOLDER_ID, DOC_FOLDER_NAME, SORTKEY
					FROM	
					(		
					SELECT A.OTHER_DEPTID, A.DOC_FOLDER_ID, B.DOC_FOLDER_NAME, B.APR_FOLDER_ID, A.ACLID, B.SORTKEY
					FROM
						(
						SELECT		USERID, DEPTID, OTHER_DEPTID, DOC_FOLDER_ID, case ACLID  when 'Y' then 1 when 'N' then 0 end as ACLID
							FROM		eWFFORM.dbo.WF_ACL_OTHER_DEPT(NOLOCK)
								WHERE		USERID = @intUserId AND USER_TYPE = 'P'
						)	as A
				
						INNER JOIN
						
						(
						SELECT 	DOC_FOLDER_NAME, DOC_FOLDER_ID, APR_FOLDER_ID, SORTKEY
						FROM	 	eWFFORM.dbo.Wf_DOC_FOLDER(NOLOCK)
						WHERE	APR_FOLDER_TYPE = 'D' AND USAGE_YN = 'Y'
						) as B	
				
						ON 	A.DOC_FOLDER_ID = B.DOC_FOLDER_ID
								
					UNION ALL
						
					SELECT C.OTHER_DEPTID, C.DOC_FOLDER_ID, D.DOC_FOLDER_NAME, D.APR_FOLDER_ID,  C.ACLID, D.SORTKEY
					FROM		
						(
						SELECT A.USERID, A.DEPTID, A.OTHER_DEPTID, A.DOC_FOLDER_ID, A.ACLID
						FROM
							(
							SELECT		USERID, DEPTID, DOC_FOLDER_ID, OTHER_DEPTID, case ACLID  when 'Y' then 1 when 'N' then 0 end as ACLID, USER_TYPE
							FROM		eWFFORM.dbo.WF_ACL_OTHER_DEPT(NOLOCK)
							) as A
							
								INNER JOIN		
								
							(
							SELECT UserId, DeptId
							FROM eManage.dbo.VW_USER
							WHERE UserId = @intUserId AND EndDate > getdate()
							)	as B
							
							ON A.USER_TYPE = 'D' AND A.DeptId = B.DeptId
						)	as C
						
						INNER JOIN
						
						(
						SELECT 	DOC_FOLDER_NAME, DOC_FOLDER_ID, APR_FOLDER_ID, SORTKEY
						FROM	 	eWFFORM.dbo.Wf_DOC_FOLDER(NOLOCK)
						WHERE	APR_FOLDER_TYPE = 'D' AND USAGE_YN = 'Y'
						) as D	
				
						ON 	C.DOC_FOLDER_ID = D.DOC_FOLDER_ID
					)	as E
					
					GROUP BY OTHER_DEPTID, DOC_FOLDER_ID, APR_FOLDER_ID, DOC_FOLDER_NAME, SORTKEY		
				)	as F	
				WHERE	OTHER_DEPTID = @intOtherDeptId AND ACLID = 'Y' 
				ORDER BY SORTKEY

		FETCH NEXT FROM otherDept_Cursor into @intOtherDeptId, @vcOtherDeptName
			
		END	-- end of WHILE#4
		close otherDept_Cursor
		DEALLOCATE otherDept_Cursor
	END	-- end of IF#12
END	-- end of IF#2


select	FOLDER_ID,  FOLDER_NAME + dbo.UF_DOCFOLDER_COUNT_TEMP(@intUserID, TREE_ID), DEPTH, PARENT_FOLDER_ID, APR_FOLDER_ID, DEPT_ID, AUTH_TYPE, TREE_ID
-- SELECT	FOLDER_ID,
-- 		FOLDER_NAME + '(0/0)',
-- 		CASE
-- 			WHEN	APR_FOLDER_ID = 'AP'	THEN
-- 				(SELECT	OPEN_Y, CNT
-- 				FROM	eWFFORM.dbo.VW_PARTICIPANT_BOX	with (nolock)
-- 				WHERE	PARTICIPANT_ID = @intUserID
-- 					AND	APR_FOLDER_CODE = 'AP')
-- 			WHEN	APR_FOLDER_ID = 'R'	THEN
-- 				(SELECT	CAST(OPEN_N as varchar) + '/' + CAST(CNT as varchar) 
-- 				FROM	eWFFORM.dbo.VW_PARTICIPANT_BOX
-- 				WHERE   PARTICIPANT_ID = DEPT_ID + '_R'
-- 					AND APR_FOLDER_CODE = 'R')
-- 			ELSE
-- 				''
-- 		END,
-- 		DEPTH, PARENT_FOLDER_ID, APR_FOLDER_ID, DEPT_ID, AUTH_TYPE, TREE_ID
FROM	#tree



DROP TABLE #tree
return




GO
/****** Object:  StoredProcedure [dbo].[UP_LIST_COUNT_DEPTDOCFOLDER_DOCUMENT]    Script Date: 2015-10-15 오후 1:30:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

----------------------------------------------------------------------
----------------------------------------------------------------------
-- 작성자: 신상훈
-- 작성일: 2004.06.07
-- 수정일: 2004.06.07
-- 설   명: 부서결재함에 있는 문서함들의 건수를 조회한다.
-- 테스트: EXEC  UP_LIST_COUNT_DEPTDOCFOLDER_DOCUMENT '1167'
----------------------------------------------------------------------
-- 수정일 : 
-- 수정자 : 
-- 수정내용 : 
----------------------------------------------------------------------
----------------------------------------------------------------------
CREATE  PROC [dbo].[UP_LIST_COUNT_DEPTDOCFOLDER_DOCUMENT]
	@vcDeptId	varchar(10)
AS
-- 부서 결재함 건수
SELECT 
	ISNULL(SUM (
		CASE RIGHT(RTRIM(PARTICIPANT_ID),1)	-- A : 품의함 건수
			WHEN 'A' THEN 
				CASE A.STATE
					WHEN 7 THEN
						CASE A.PROCESS_INSTANCE_VIEW_STATE
							WHEN 3 THEN 1
							ELSE 0
						END
					ELSE 0
				END
			ELSE 0
		END  ),0) A_CNT,
	ISNULL(SUM (
		CASE RIGHT(RTRIM(PARTICIPANT_ID),1)	-- C : 시행협조함 건수
			WHEN 'C' THEN 
				CASE A.STATE
					WHEN 7 THEN
						CASE A.PROCESS_INSTANCE_VIEW_STATE
							WHEN 3 THEN 1
							ELSE 0
						END
					ELSE 0
				END
			ELSE 0
		END  ) ,0) C_CNT,
	ISNULL(SUM (
		CASE RIGHT(RTRIM(PARTICIPANT_ID),1)	-- I : 합의함 건수
			WHEN 'H' THEN 
				CASE A.STATE
					WHEN 7 THEN
						CASE A.PROCESS_INSTANCE_VIEW_STATE
							WHEN 3 THEN 1
							ELSE 0
						END
					ELSE 0
				END
			ELSE 0
		END  ) ,0)  H_CNT,
	ISNULL(SUM (
		CASE RIGHT(RTRIM(PARTICIPANT_ID),1)	-- K : 감사함 건수
			WHEN 'K' THEN 
				CASE A.STATE
					WHEN 7 THEN
						CASE A.PROCESS_INSTANCE_VIEW_STATE
							WHEN 3 THEN 1
							ELSE 0
						END
					ELSE 0
				END
			ELSE 0
		END  ) ,0) K_CNT,
	ISNULL(SUM (
		CASE RIGHT(RTRIM(PARTICIPANT_ID),1)	-- P : 신청처리함 건수
			WHEN 'P' THEN 
				CASE A.STATE
					WHEN 7 THEN
						CASE A.PROCESS_INSTANCE_VIEW_STATE
							WHEN 3 THEN 1
							ELSE 0
						END
					ELSE 0
				END
			ELSE 0
		END  ),0) P_CNT,
	ISNULL(SUM (
		CASE RIGHT(RTRIM(PARTICIPANT_ID),1)	-- R : 수신함 건수
			WHEN 'R' THEN 
				CASE A.STATE
					WHEN 2 THEN
						CASE A.PROCESS_INSTANCE_VIEW_STATE
							WHEN 3 THEN 
								CASE UPPER(ISNULL(A.OPEN_YN,'N')) -- 열어본것
									WHEN 'Y' THEN 1
									ELSE 0
								END
							ELSE 0
						END
					ELSE 0
				END
			ELSE 0
		END  ) ,0) R_CNT_OPEN_Y,
	ISNULL(SUM (
		CASE RIGHT(RTRIM(PARTICIPANT_ID),1)	-- R : 수신함 건수
			WHEN 'R' THEN 
				CASE A.STATE
					WHEN 2 THEN
						CASE A.PROCESS_INSTANCE_VIEW_STATE
							WHEN 3 THEN 
								CASE UPPER(ISNULL(A.OPEN_YN,'N')) -- 안 열어본것
									WHEN 'N' THEN 1
									ELSE 0
								END
							ELSE 0
						END
					ELSE 0
				END
			ELSE 0
		END  ) ,0) R_CNT_OPEN_N,
	ISNULL(SUM (
		CASE RIGHT(RTRIM(PARTICIPANT_ID),1)	-- R : 수신함 건수
			WHEN 'R' THEN 
				CASE A.STATE
					WHEN 2 THEN
						CASE A.PROCESS_INSTANCE_VIEW_STATE
							WHEN 3 THEN 1
							ELSE 0
						END
					ELSE 0
				END
			ELSE 0
		END  ) ,0) R_CNT,
	ISNULL(SUM (
		CASE RIGHT(RTRIM(PARTICIPANT_ID),1)	-- S : 발신함 건수
			WHEN 'S' THEN 
				CASE A.STATE
					WHEN 7 THEN
						CASE A.PROCESS_INSTANCE_VIEW_STATE
							WHEN 3 THEN 1
							ELSE 0
						END
					ELSE 0
				END
			ELSE 0
		END  ) ,0)  S_CNT
   FROM eWF.dbo.WORK_ITEM A (NOLOCK), eWF.dbo.PROCESS_INSTANCE B (NOLOCK)
 WHERE A.PARTICIPANT_ID LIKE @vcDeptId + '_%'
     AND A.PROCESS_INSTANCE_OID = B.OID
     AND B.STATE IN (1,3,7,8)
     AND B.DELETE_DATE > getdate()


GO
/****** Object:  StoredProcedure [dbo].[UP_LIST_COUNT_PRIDOCFOLDER_DOCUMENT]    Script Date: 2015-10-15 오후 1:30:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



----------------------------------------------------------------------
----------------------------------------------------------------------
-- 작성자: 신상훈
-- 작성일: 2004.06.07
-- 수정일: 2004.06.07
-- 설   명: 개인결재함에 있는 문서함들의 건수를 조회한다.
-- 테스트: 
/*

EXEC  UP_LIST_COUNT_PRIDOCFOLDER_DOCUMENT '100305'
*/
-- SELECT * FROM eManage.dbo.VW_USER WHERE UserId = '100305'
----------------------------------------------------------------------
-- 수정일 : 
-- 수정자 : 
-- 수정내용 : 
----------------------------------------------------------------------
----------------------------------------------------------------------
CREATE     PROC [dbo].[UP_LIST_COUNT_PRIDOCFOLDER_DOCUMENT]	
	@vcUserId	varchar(10)
AS
-- 개인 결재함 건수
SELECT 
	AA.APR_CNT_OPEN_Y,	-- 결재함 (열어본것)
	AA.APR_CNT_OPEN_N,	-- 결재함 (안 열어본것)
	AA.APR_CNT,		-- 결재함 (모두)
	AA.ING_CNT,		-- 진행함
	AA.COMP_CNT,		-- 완료함
	AA.REJ_CNT,		-- 반려함
	BB.IMSI_CNT		-- 임시저장함
 FROM (
		SELECT  A.PARTICIPANT_ID,
			ISNULL(SUM(
				CASE A.STATE	-- 결재함 2,3 (열어본것)
					WHEN 2 THEN
						CASE A.PROCESS_INSTANCE_VIEW_STATE
							WHEN 3 THEN 
								CASE UPPER(ISNULL(A.OPEN_YN,'N')) -- 열어본것
									WHEN 'Y' THEN 1
									ELSE 0
								END
							ELSE 0
						END 
					ELSE 0
				END  ),0) AS APR_CNT_OPEN_Y,
			ISNULL(SUM(
				CASE A.STATE	-- 결재함 2,3 (안 열어본것)
					WHEN 2 THEN
						CASE A.PROCESS_INSTANCE_VIEW_STATE
							WHEN 3 THEN 
								CASE UPPER(ISNULL(A.OPEN_YN,'N')) -- 안 열어본것
									WHEN 'N' THEN 1
									ELSE 0
								END
							ELSE 0
						END 
					ELSE 0
				END  ),0) AS APR_CNT_OPEN_N,
			ISNULL(SUM(
				CASE A.STATE	-- 결재함 2,3 (모두)
					WHEN 2 THEN
						CASE A.PROCESS_INSTANCE_VIEW_STATE
							WHEN 3 THEN 1
							ELSE 0
						END 
					ELSE 0
				END  ),0) AS APR_CNT,
			ISNULL(SUM(
				CASE A.STATE	-- 진행함 7,3 (모두)
					WHEN 7 THEN
						CASE A.PROCESS_INSTANCE_VIEW_STATE
							WHEN 3 THEN 1
							ELSE 0
						END 
					ELSE 0
				END  ),0) AS ING_CNT,
		
			ISNULL(SUM(
				CASE A.STATE	-- 완료함 7,7
					WHEN 7 THEN
						CASE A.PROCESS_INSTANCE_VIEW_STATE
							WHEN 7 THEN 1
							ELSE 0
						END 
					ELSE 0
				END  ),0) AS COMP_CNT,
			ISNULL(SUM(
				CASE A.STATE	-- 반려함 8,7
					WHEN 7 THEN
						CASE A.PROCESS_INSTANCE_VIEW_STATE
							WHEN 8 THEN 1
							ELSE 0
						END 
					ELSE 0
				END  ),0) AS REJ_CNT 
		   FROM eWF.dbo.WORK_ITEM A (NOLOCK), eWF.dbo.PROCESS_INSTANCE B (NOLOCK)
 		 WHERE A.PARTICIPANT_ID = @vcUserId
		     AND A.PROCESS_INSTANCE_OID = B.OID
		     AND B.STATE IN (1,3,7,8)
		     AND B.DELETE_DATE > getdate()
		GROUP BY A.PARTICIPANT_ID
	) AA, (
		SELECT A.USERID, COUNT(*) IMSI_CNT
		  FROM eWFFORM.dbo.WF_FORM_STORAGE A (NOLOCK)
-- 		WHERE A.USERID = @vcUserId
-- 		  AND A.DELETE_DATE > getdate()
		GROUP BY A.USERID ) BB 
--WHERE AA.PARTICIPANT_ID = BB.USERID
SET QUOTED_IDENTIFIER ON 




GO
/****** Object:  StoredProcedure [dbo].[UP_LIST_DEPT_DOCUMENTLIST]    Script Date: 2015-10-15 오후 1:30:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





/*
686	1103	593

140	197	40


exec dbo.UP_LIST_DEPT_DOCUMENTLIST @pDocName = '전   체', @pSendFlag = '1', @pState = '9', @pYear = '2006', @pDeptYn = 'N'
exec dbo.UP_LIST_DEPT_DOCUMENTLIST @pDocName = '업무연락', @pSendFlag = '1', @pState = '9', @pYear = '2005', @pDeptYn = 'N'
exec dbo.UP_LIST_DEPT_DOCUMENTLIST @pDocName = ' 전   체 ', @pSendFlag = '0', @pState = '9', @pFrDate = '        ', @pToDate = '        ', @pDeptYn = 'N'

발신	:	업무연락은 Parent_Oid = ''
			신청서는 Creator_Dept

수신	:	업무연락은 Parent_Oid <> '' / Work_Item(Parent_Work_Item_Oid.Oid = Work_Item.Oid)의 ParticipantID
			신청서는 

select	*
from	eWF.dbo.PROCESS_INSTANCE p
		join	eWF.dbo.work_item w
			on	w.oid = p.parent_work_item_oid
where	p.parent_oid = 'ZAAAD6AC9C58B4E2BAB882A1A4255954E'

select	top 10 *
from	eWF.dbo.work_item p
where	oid = 'Z4B57B8DA756043E6B3A389C6D459CD2B'

select	Convert(char(6), p.Create_Date, 112), count(*)
from	eWF.dbo.PROCESS_INSTANCE p
where	p.name = '전산소모품신청서'
--	and	creator_dept_id in (2590, 2591, 2592)
group by Convert(char(6), p.Create_Date, 112) 
146 202 40

select	*
from	emanage.dbo.tb_dept

*/

CREATE	Procedure	[dbo].[UP_LIST_DEPT_DOCUMENTLIST]
		@pDocName	varchar(100),	--	0:발신함, 1:수신함
		@pSendFlag	char(1),	--	0:발신함, 1:수신함
		@pState		char(1),	--	9:전체, 0:미처리, 1:진행중, 7:완료
		@pYear		char(4),
		@pDeptYn	char(1)
As

	Select	@pDocName = Ltrim(Rtrim(@pDocName))

	--	Drop	Table	#TmpDeptList
	Create	Table	#TmpDeptList
	(
		Creator_Dept_Id	int,
		OID				varchar(33),
		Create_Date		char(8)
	)

-- select	148 + 41 + 202
-- select	277+282+456
-- 
-- select	288 + 284 + 476
-- 
-- select	Convert(char(6), p.Create_Date, 112), count(*)
-- from	eWF.dbo.PROCESS_INSTANCE p
-- where	p.name = '업무연락'
-- 	and	p.parent_oid = ''
-- --	and	creator_dept_id in (2590, 2591, 2592)
-- and	substring(convert(char(8), p.Create_Date, 112), 5, 2) = '09'
-- group by Convert(char(6), p.Create_Date, 112)
-- 
-- select	Convert(char(6), p.Create_Date, 112), count(*)
-- from	eWF.dbo.PROCESS_INSTANCE p
-- where	p.name <> '업무연락'
-- and	p.State <> '8' and p.State <> '13'
-- 	--	and	creator_dept_id in (2590, 2591, 2592)
-- and	substring(convert(char(8), p.Create_Date, 112), 5, 2) = '09'
-- group by Convert(char(6), p.Create_Date, 112)
-- 
-- Insert	Into	#TmpDeptList
-- Select	Case	When	Creator_Dept_Id='undefined'	Then	'0000'	else	Convert(int, Creator_Dept_Id)	End,
-- 						OID,
-- 						Convert(varchar(8), Create_Date, 112)
-- From	eWF.dbo.PROCESS_INSTANCE p
-- Where	p.[name] <> '업무연락'
-- 	and	p.State <> '8' and p.State <> '13'
-- 	and	Convert(char(4), p.Create_Date, 112) = '2005'
-- Insert	Into	#TmpDeptList
-- Select	Case
-- 			When	Creator_Dept_Id='undefined'	Then	'0000'	else	Convert(int, Creator_Dept_Id)	End,
-- 						OID,
-- 						Convert(varchar(8), Create_Date, 112)
-- From	eWF.dbo.PROCESS_INSTANCE p
-- Where	p.[name] = '업무연락'
-- 	and	p.State <> '8' and p.State <> '13'
-- 	and	Convert(char(4), p.Create_Date, 112) = '2005'
-- 	and	p.Parent_Oid = ''

	If	@pSendFlag = '0'	--	발신부서기준
	Begin

		Insert	Into	#TmpDeptList
			Select	Case	When	Creator_Dept_Id='undefined'	Then	'0000'	else	Convert(int, Creator_Dept_Id)	End,
					OID,
					Convert(varchar(8), Create_Date, 112)
			From	eWF.dbo.PROCESS_INSTANCE p
			Where	(@pDocName = '전   체' or p.[name] = @pDocName)
				and	((@pState = '9' and p.State <> '8' and p.State <> '13')	or	p.State = @pState)
				and	Convert(char(4), p.Create_Date, 112) = @pYear
				and	p.Parent_Oid = ''

--return
	End
	Else If	@pSendFlag = '1'	--	수신부서기준
	Begin

		If	(@pDocName = '전   체' or @pDocName = '업무연락')
			Insert	Into	#TmpDeptList
				Select	Left(i.Participant_Id, 4),
						p.OID,
						Convert(varchar(8), p.Create_Date, 112)
				From	eWF.dbo.PROCESS_INSTANCE p
						Join	eWF.dbo.WORK_ITEM i
							On	i.Oid = p.Parent_Work_Item_Oid
				Where	p.[name] = '업무연락'
					and	((@pState = '9' and p.State <> '8' and p.State <> '13')	or	p.State = @pState)
					and	Convert(char(4), p.Create_Date, 112) = @pYear
					and	p.Parent_Oid <> ''

		If	(@pDocName = '전   체' or @pDocName <> '업무연락')
		Begin

			Insert	Into	#TmpDeptList
				Select	Convert(int, Substring(v.Participant_ID, 1, 4)),
						v.ItemOid,
						Convert(varchar(8), v.Create_Date, 112)
				From	eWFForm.dbo.VW_WORK_LIST v
				Where	v.Participant_Name = '수신함'
					and	(
							(@pState = '9' or (@pState = '0' and (v.STATE = '2')))	or
							(@pState = '9' or (@pState = '1' and (v.STATE = '7' and v.PROCESS_INSTANCE_VIEW_STATE = '3')))	or
							(@pState = '9' or (@pState = '7' and (v.STATE = '7' and v.PROCESS_INSTANCE_VIEW_STATE = '7')))
						)
--					and	((@pState = '9' and v.PROCESS_INSTANCE_VIEW_STATE <> '8' and v.PROCESS_INSTANCE_VIEW_STATE <> '13')	or v.PROCESS_INSTANCE_VIEW_STATE = @pState)
					and	((@pDocName = '전   체' or v.CategoryName = @pDocName) and v.CategoryName <> '업무연락')
					and	Convert(char(4), v.Create_Date, 112) = @pYear

			Insert	Into	#TmpDeptList
				Select	Convert(int, Substring(i.Participant_ID, 1, 4)),
						p.Oid,
						Convert(varchar(8), i.Create_Date, 112)
				From	eWF.dbo.Process_Instance p
						Join	eWF.dbo.Work_Item i
							On	i.Process_Instance_Oid = p.Oid
				Where	i.Participant_Name = '부서합의'
					and	(
							(@pState = '9' or (@pState = '0' and (p.STATE = '1' and i.STATE = '2')))	or
							(@pState = '9' or (@pState = '1' and (p.STATE = '1' and i.STATE = '7')))	or
							(@pState = '9' or (@pState = '7' and (p.STATE = '7' and i.STATE = '7')))
						)
					and	(@pDocName = '전   체' or p.Name = @pDocName)
					and	Convert(char(4), i.Create_Date, 112) = @pYear

		End

	End

	--	Drop	Table	#TmpDeptMonthList
	Select	Creator_Dept_Id,
			Sum(Case	When	Substring(Create_Date, 5, 2) = '01'	Then	1	Else	0	End)	as Month01,
			Sum(Case	When	Substring(Create_Date, 5, 2) = '02'	Then	1	Else	0	End)	as Month02,
			Sum(Case	When	Substring(Create_Date, 5, 2) = '03'	Then	1	Else	0	End)	as Month03,
			Sum(Case	When	Substring(Create_Date, 5, 2) = '04'	Then	1	Else	0	End)	as Month04,
			Sum(Case	When	Substring(Create_Date, 5, 2) = '05'	Then	1	Else	0	End)	as Month05,
			Sum(Case	When	Substring(Create_Date, 5, 2) = '06'	Then	1	Else	0	End)	as Month06,
			Sum(Case	When	Substring(Create_Date, 5, 2) = '07'	Then	1	Else	0	End)	as Month07,
			Sum(Case	When	Substring(Create_Date, 5, 2) = '08'	Then	1	Else	0	End)	as Month08,
			Sum(Case	When	Substring(Create_Date, 5, 2) = '09'	Then	1	Else	0	End)	as Month09,
			Sum(Case	When	Substring(Create_Date, 5, 2) = '10'	Then	1	Else	0	End)	as Month10,
			Sum(Case	When	Substring(Create_Date, 5, 2) = '11'	Then	1	Else	0	End)	as Month11,
			Sum(Case	When	Substring(Create_Date, 5, 2) = '12'	Then	1	Else	0	End)	as Month12
	Into	#TmpDeptMonthList
	From	#TmpDeptList
	Group by Creator_Dept_Id


	If	@pDeptYn = 'N'

		Select	dd.DeptName,
				IsNull(Sum(s.Month01), 0),
				IsNull(Sum(s.Month02), 0),
				IsNull(Sum(s.Month03), 0),
				IsNull(Sum(s.Month04), 0),
				IsNull(Sum(s.Month05), 0),
				IsNull(Sum(s.Month06), 0),
				IsNull(Sum(s.Month07), 0),
				IsNull(Sum(s.Month08), 0),
				IsNull(Sum(s.Month09), 0),
				IsNull(Sum(s.Month10), 0),
				IsNull(Sum(s.Month11), 0),
				IsNull(Sum(s.Month12), 0),
				IsNull(Sum(s.Month01), 0) + IsNull(Sum(s.Month02), 0) + IsNull(Sum(s.Month03), 0) + IsNull(Sum(s.Month04), 0) +
				IsNull(Sum(s.Month05), 0) + IsNull(Sum(s.Month06), 0) + IsNull(Sum(s.Month07), 0) + IsNull(Sum(s.Month08), 0) +
				IsNull(Sum(s.Month09), 0) + IsNull(Sum(s.Month10), 0) + IsNull(Sum(s.Month11), 0) + IsNull(Sum(s.Month12), 0)
				,oo.SortKey	as ParentSortKey
				,'99'	as SortKey
		From	eManage.dbo.TB_Dept d
				Left Join	#TmpDeptMonthList s
					On	s.Creator_Dept_Id = d.DeptId
				Left Join	eManage.dbo.TB_Dept_Org o
					On	o.DeptId = d.DeptId
				Join	eManage.dbo.TB_Dept_Org oo
					On	oo.DeptId = o.ParentDeptId
				Join	eManage.dbo.TB_Dept dd
					On	dd.DeptId = oo.DeptId
		Where	d.EnableWF = 'Y'
		Group by dd.DeptName, oo.SortKey
		Union
		Select	'총계',
				IsNull(Sum(s.Month01), 0),
				IsNull(Sum(s.Month02), 0),
				IsNull(Sum(s.Month03), 0),
				IsNull(Sum(s.Month04), 0),
				IsNull(Sum(s.Month05), 0),
				IsNull(Sum(s.Month06), 0),
				IsNull(Sum(s.Month07), 0),
				IsNull(Sum(s.Month08), 0),
				IsNull(Sum(s.Month09), 0),
				IsNull(Sum(s.Month10), 0),
				IsNull(Sum(s.Month11), 0),
				IsNull(Sum(s.Month12), 0),
				IsNull(Sum(s.Month01), 0) + IsNull(Sum(s.Month02), 0) + IsNull(Sum(s.Month03), 0) + IsNull(Sum(s.Month04), 0) +
				IsNull(Sum(s.Month05), 0) + IsNull(Sum(s.Month06), 0) + IsNull(Sum(s.Month07), 0) + IsNull(Sum(s.Month08), 0) +
				IsNull(Sum(s.Month09), 0) + IsNull(Sum(s.Month10), 0) + IsNull(Sum(s.Month11), 0) + IsNull(Sum(s.Month12), 0)
				,'00'	as ParentSortKey
				,'00'	as SortKey
		From	eManage.dbo.TB_Dept d
				Join	eManage.dbo.TB_Dept dd
					On	dd.DeptId = d.ParentDeptId
				Left Join	#TmpDeptMonthList s
					On	s.Creator_Dept_Id = d.DeptId
		Where	d.EnableWF = 'Y'
		Order by oo.SortKey

	Else

		Select	dd.DeptName, d.DeptName,
				IsNull(s.Month01, 0),
				IsNull(s.Month02, 0),
				IsNull(s.Month03, 0),
				IsNull(s.Month04, 0),
				IsNull(s.Month05, 0),
				IsNull(s.Month06, 0),
				IsNull(s.Month07, 0),
				IsNull(s.Month08, 0),
				IsNull(s.Month09, 0),
				IsNull(s.Month10, 0),
				IsNull(s.Month11, 0),
				IsNull(s.Month12, 0),
				IsNull(s.Month01, 0) + IsNull(s.Month02, 0) + IsNull(s.Month03, 0) + IsNull(s.Month04, 0) + IsNull(s.Month05, 0) +
				IsNull(s.Month06, 0) + IsNull(s.Month07, 0) + IsNull(s.Month08, 0) + IsNull(s.Month09, 0) + IsNull(s.Month10, 0) +
				IsNull(s.Month11, 0) + IsNull(s.Month12, 0)
				,oo.SortKey	as ParentSortKey
				,o.SortKey	as SortKey
		From	eManage.dbo.TB_Dept d
				Left Join	#TmpDeptMonthList s
					On	s.Creator_Dept_Id = d.DeptId
				Left Join	eManage.dbo.TB_Dept_Org o
					On	o.DeptId = d.DeptId
				Join	eManage.dbo.TB_Dept_Org oo
					On	oo.DeptId = o.ParentDeptId
				Join	eManage.dbo.TB_Dept dd
					On	dd.DeptId = oo.DeptId
		Where	d.EnableWF = 'Y'

		Union
		Select	dd.DeptName, '합계',
				IsNull(Sum(s.Month01), 0),
				IsNull(Sum(s.Month02), 0),
				IsNull(Sum(s.Month03), 0),
				IsNull(Sum(s.Month04), 0),
				IsNull(Sum(s.Month05), 0),
				IsNull(Sum(s.Month06), 0),
				IsNull(Sum(s.Month07), 0),
				IsNull(Sum(s.Month08), 0),
				IsNull(Sum(s.Month09), 0),
				IsNull(Sum(s.Month10), 0),
				IsNull(Sum(s.Month11), 0),
				IsNull(Sum(s.Month12), 0),
				IsNull(Sum(s.Month01), 0) + IsNull(Sum(s.Month02), 0) + IsNull(Sum(s.Month03), 0) + IsNull(Sum(s.Month04), 0) +
				IsNull(Sum(s.Month05), 0) + IsNull(Sum(s.Month06), 0) + IsNull(Sum(s.Month07), 0) + IsNull(Sum(s.Month08), 0) +
				IsNull(Sum(s.Month09), 0) + IsNull(Sum(s.Month10), 0) + IsNull(Sum(s.Month11), 0) + IsNull(Sum(s.Month12), 0)
				,oo.SortKey	as ParentSortKey
				,'99'	as SortKey
		From	eManage.dbo.TB_Dept d
				Left Join	#TmpDeptMonthList s
					On	s.Creator_Dept_Id = d.DeptId
				Left Join	eManage.dbo.TB_Dept_Org o
					On	o.DeptId = d.DeptId
				Join	eManage.dbo.TB_Dept_Org oo
					On	oo.DeptId = o.ParentDeptId
				Join	eManage.dbo.TB_Dept dd
					On	dd.DeptId = oo.DeptId
		Where	d.EnableWF = 'Y'
		Group by dd.DeptName, oo.SortKey
		Union
		Select	'총계', '',
				IsNull(Sum(s.Month01), 0),
				IsNull(Sum(s.Month02), 0),
				IsNull(Sum(s.Month03), 0),
				IsNull(Sum(s.Month04), 0),
				IsNull(Sum(s.Month05), 0),
				IsNull(Sum(s.Month06), 0),
				IsNull(Sum(s.Month07), 0),
				IsNull(Sum(s.Month08), 0),
				IsNull(Sum(s.Month09), 0),
				IsNull(Sum(s.Month10), 0),
				IsNull(Sum(s.Month11), 0),
				IsNull(Sum(s.Month12), 0),
				IsNull(Sum(s.Month01), 0) + IsNull(Sum(s.Month02), 0) + IsNull(Sum(s.Month03), 0) + IsNull(Sum(s.Month04), 0) +
				IsNull(Sum(s.Month05), 0) + IsNull(Sum(s.Month06), 0) + IsNull(Sum(s.Month07), 0) + IsNull(Sum(s.Month08), 0) +
				IsNull(Sum(s.Month09), 0) + IsNull(Sum(s.Month10), 0) + IsNull(Sum(s.Month11), 0) + IsNull(Sum(s.Month12), 0)
				,'00'	as ParentSortKey
				,'00'	as SortKey
		From	eManage.dbo.TB_Dept d
				Join	eManage.dbo.TB_Dept dd
					On	dd.DeptId = d.ParentDeptId
				Left Join	#TmpDeptMonthList s
					On	s.Creator_Dept_Id = d.DeptId
		Where	d.EnableWF = 'Y'
		Order by oo.SortKey, o.SortKey



/*

Select	top 10
	substring(w.participant_id, 1, 4)
, *
From	eWFForm.dbo.VW_WORK_LIST w
		Join	eWF.dbo.PROCESS_INSTANCE p
			On	p.Oid = w.ItemOid
Where	Convert(varchar(8), w.ItemCreate_Date, 112) between '20050101' and '20051212'	--	@pItemCreate_Date
	and	w.CategoryName = '반납의뢰서'	--	@pDocName
	and	p.State = '7'		--	@pState
order by w.Create_Date


Select	top 100 *	From	eWF.dbo.PROCESS_INSTANCE v	Where	oid = 'ZB66BD11E1AB84F27BAAB78823DE41675'
Select	top 100 *	From	eWFForm.dbo.VW_WORK_LIST v	Where	itemoid = 'ZB66BD11E1AB84F27BAAB78823DE41675'

Select	top 100 *	From	eWF.dbo.PROCESS_INSTANCE v	Where	oid = 'Z07EC8FAD1AD846F4B3361EF80086AC52'

Select	top 100 *	From	eWFForm.dbo.VW_WORK_LIST v	Where	itemoid = 'Z07EC8FAD1AD846F4B3361EF80086AC52' order by create_date
Select	top 100 *	From	eWFForm.dbo.VW_WORK_LIST v	Where	itemoid = 'ZB66BD11E1AB84F27BAAB78823DE41675' order by create_date
Select	top 100 *	From	eWFForm.dbo.VW_WORK_LIST v	Where	itemoid = 'Z08FBBDDB0BB24E1C945F4D86325E3167' order by create_date
Select	top 100 *	From	eWFForm.dbo.VW_WORK_LIST v	Where	itemoid = 'ZE370EFA5404D4986887010D75AB2E47B' order by create_date

Select	top 100 *	From	eWF.dbo.PROCESS_INSTANCE v	Where	oid = 'ZE370EFA5404D4986887010D75AB2E47B'

Select	top 100 *
From	ewfform.dbo.FORM_Y916C53AF4A1B45C3A2E5110227D8530B
Where	process_id = 'Z28FAD3E8799244198B4012A7FE94DB7E'

*/


RETURN














GO
/****** Object:  StoredProcedure [dbo].[UP_LIST_DEPT_DOCUMENTLISTXXX]    Script Date: 2015-10-15 오후 1:30:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



/*
exec dbo.UP_LIST_DEPT_DOCUMENTLIST @pDocName = ' 전   체 ', @pSendFlag = '0', @pState = '9', @pFrDate = '20050101', @pToDate = '20051010', @pDeptYn = 'N'
exec dbo.UP_LIST_DEPT_DOCUMENTLIST @pDocName = ' 전   체 ', @pSendFlag = '0', @pState = '9', @pFrDate = '        ', @pToDate = '        ', @pDeptYn = 'N'

헤더색깔
날짜설정
합계데이타
조직도 조인
부.실 단위

select	*
from	emanage.dbo.tb_dept



*/



CREATE	Procedure	[dbo].[UP_LIST_DEPT_DOCUMENTLISTXXX]
		@pDocName	varchar(100),	--	0:발신함, 1:수신함
		@pSendFlag	char(1),	--	0:발신함, 1:수신함
		@pState		char(1),	--	9:전체, 0:미처리, 1:진행중, 7:완료
		@pFrDate	char(8),
		@pToDate	char(8),
		@pDeptYn	char(1)
as

	Select	@pDocName = Ltrim(Rtrim(@pDocName))

	If	Ltrim(Rtrim(@pFrDate)) = ''	Select	@pFrDate = Convert(char(6), getdate(), 112) + '01'
	If	Ltrim(Rtrim(@pToDate)) = ''	Select	@pToDate = Convert(char(8), getdate(), 112)

	--	Drop	Table	#TmpDeptList
	Create	Table	#TmpDeptList
	(
		Creator_Dept_Id	int,
		OID				varchar(33),
		Create_Date		char(8)
	)

	If	@pSendFlag = '0'	--	발신부서기준
	Begin

		Insert	Into	#TmpDeptList
			Select	Case	When	Creator_Dept_Id='undefined'	Then	'0000'	else	Convert(int, Creator_Dept_Id)	End,
					OID,
					Convert(varchar(8), Create_Date, 112)
			From	eWF.dbo.PROCESS_INSTANCE p
			Where	(@pDocName = '전   체' or p.[name] = @pDocName)
				and	(@pState = '9'	or	p.State = @pState)
				and	Convert(varchar(8), p.Create_Date, 112) between @pFrDate and @pToDate

	End
	Else If	@pSendFlag = '1'	--	수신부서기준
	Begin

		--	수신부서기준

		/*
		미처리 - 수신함상태가 '2'인것
		진행중 - 수신함 open_yn = 'y'이고 수신함상태가 '2'가 아닌것중에 '문서이관(수신)'이 없는것
		완료 - 수신함 open_yn = 'y'이고 '문서이관(수신)'이 있는것
		*/

		If	(@pState = '9'	or	@pState = '0')

			Insert	Into	#TmpDeptList
				Select	Convert(int, Substring(v.Participant_ID, 1, 4)),
						v.ItemOid,
						Convert(varchar(8), v.Create_Date, 112)
				From	eWFForm.dbo.VW_WORK_LIST v
				Where	v.Participant_Name = '수신함'
					and	v.State = '2'
					and	(@pDocName = '전   체' or v.CategoryName = @pDocName)
					and	Convert(varchar(8), v.Create_Date, 112) between @pFrDate and @pToDate

		If	(@pState = '9'	or	@pState = '1')
		Begin

--			Drop	Table	#tmpIng
			Select	Convert(int, Substring(v.Participant_ID, 1, 4)) as Creator_Dept_Id,
					v.ItemOid,
					Convert(varchar(8), v.Create_Date, 112)	as Create_Date
			Into	#tmpIng
			From	eWFForm.dbo.VW_WORK_LIST v
			Where	v.Participant_Name = '수신함'
				and	v.Open_YN = 'Y'
				and	v.State <> '2'
				and	(@pDocName = '전   체' or v.CategoryName = @pDocName)
				and	Convert(varchar(8), v.Create_Date, 112) between @pFrDate and @pToDate
		
			Insert	Into	#TmpDeptList
				Select	v.Creator_Dept_Id, v.ItemOid, v.Create_Date
				From	#tmpIng v
						Left Join	eWFForm.dbo.VW_WORK_LIST vv
							On	v.ItemOid = vv.ItemOid
							and	vv.Participant_Name = '문서이관(수신)'
				Where	vv.Oid is Null

		End
		
		If	(@pState = '9'	or	@pState = '7')

			Insert	Into	#TmpDeptList
				Select	Convert(int, Substring(v.Participant_ID, 1, 4)),
						v.ItemOid,
						Convert(varchar(8), vv.Completed_Date, 112)	as Create_Date
				From	eWFForm.dbo.VW_WORK_LIST v
						Join	eWFForm.dbo.VW_WORK_LIST vv
							On	v.ItemOid = vv.ItemOid
							and	vv.Participant_Name = '문서이관(수신)'
				Where	v.Participant_Name = '수신함'
					and	v.Open_YN = 'Y'
					and	v.State = '7'
					and	(@pDocName = '전   체' or v.CategoryName = @pDocName)
					and	Convert(varchar(8), vv.Completed_Date, 112) between @pFrDate and @pToDate

	End


	--	Drop	Table	#TmpDeptMonthList
	Select	Creator_Dept_Id,
			Sum(Case	When	Substring(Create_Date, 5, 2) = '01'	Then	1	Else	0	End)	as Month01,
			Sum(Case	When	Substring(Create_Date, 5, 2) = '02'	Then	1	Else	0	End)	as Month02,
			Sum(Case	When	Substring(Create_Date, 5, 2) = '03'	Then	1	Else	0	End)	as Month03,
			Sum(Case	When	Substring(Create_Date, 5, 2) = '04'	Then	1	Else	0	End)	as Month04,
			Sum(Case	When	Substring(Create_Date, 5, 2) = '05'	Then	1	Else	0	End)	as Month05,
			Sum(Case	When	Substring(Create_Date, 5, 2) = '06'	Then	1	Else	0	End)	as Month06,
			Sum(Case	When	Substring(Create_Date, 5, 2) = '07'	Then	1	Else	0	End)	as Month07,
			Sum(Case	When	Substring(Create_Date, 5, 2) = '08'	Then	1	Else	0	End)	as Month08,
			Sum(Case	When	Substring(Create_Date, 5, 2) = '09'	Then	1	Else	0	End)	as Month09,
			Sum(Case	When	Substring(Create_Date, 5, 2) = '10'	Then	1	Else	0	End)	as Month10,
			Sum(Case	When	Substring(Create_Date, 5, 2) = '11'	Then	1	Else	0	End)	as Month11,
			Sum(Case	When	Substring(Create_Date, 5, 2) = '12'	Then	1	Else	0	End)	as Month12
	Into	#TmpDeptMonthList
	From	#TmpDeptList
	Group by Creator_Dept_Id



	If	@pDeptYn = 'Y'

		Select	dd.DeptName, '',
				IsNull(Sum(s.Month01), 0),
				IsNull(Sum(s.Month02), 0),
				IsNull(Sum(s.Month03), 0),
				IsNull(Sum(s.Month04), 0),
				IsNull(Sum(s.Month05), 0),
				IsNull(Sum(s.Month06), 0),
				IsNull(Sum(s.Month07), 0),
				IsNull(Sum(s.Month08), 0),
				IsNull(Sum(s.Month09), 0),
				IsNull(Sum(s.Month10), 0),
				IsNull(Sum(s.Month11), 0),
				IsNull(Sum(s.Month12), 0),
				IsNull(Sum(s.Month01), 0) + IsNull(Sum(s.Month02), 0) + IsNull(Sum(s.Month03), 0) + IsNull(Sum(s.Month04), 0) +
				IsNull(Sum(s.Month05), 0) + IsNull(Sum(s.Month06), 0) + IsNull(Sum(s.Month07), 0) + IsNull(Sum(s.Month08), 0) +
				IsNull(Sum(s.Month09), 0) + IsNull(Sum(s.Month10), 0) + IsNull(Sum(s.Month11), 0) + IsNull(Sum(s.Month12), 0)
				,dd.SortKey	as ParentSortKey
				,'99'	as SortKey
		From	eManage.dbo.TB_Dept d
				Left Join	eManage.dbo.TB_Dept dd
					On	dd.DeptId = d.ParentDeptId
				Left Join	#TmpDeptMonthList s
					On	s.Creator_Dept_Id = d.DeptId
		Where	d.EnableWF = 'Y'
		Group by dd.DeptName,dd.SortKey
		Union
		Select	'', '합계',
				IsNull(Sum(s.Month01), 0),
				IsNull(Sum(s.Month02), 0),
				IsNull(Sum(s.Month03), 0),
				IsNull(Sum(s.Month04), 0),
				IsNull(Sum(s.Month05), 0),
				IsNull(Sum(s.Month06), 0),
				IsNull(Sum(s.Month07), 0),
				IsNull(Sum(s.Month08), 0),
				IsNull(Sum(s.Month09), 0),
				IsNull(Sum(s.Month10), 0),
				IsNull(Sum(s.Month11), 0),
				IsNull(Sum(s.Month12), 0),
				IsNull(Sum(s.Month01), 0) + IsNull(Sum(s.Month02), 0) + IsNull(Sum(s.Month03), 0) + IsNull(Sum(s.Month04), 0) +
				IsNull(Sum(s.Month05), 0) + IsNull(Sum(s.Month06), 0) + IsNull(Sum(s.Month07), 0) + IsNull(Sum(s.Month08), 0) +
				IsNull(Sum(s.Month09), 0) + IsNull(Sum(s.Month10), 0) + IsNull(Sum(s.Month11), 0) + IsNull(Sum(s.Month12), 0)
				,'99'	as ParentSortKey
				,'99'	as SortKey
		From	eManage.dbo.TB_Dept d
				Left Join	eManage.dbo.TB_Dept dd
					On	dd.DeptId = d.ParentDeptId
				Left Join	#TmpDeptMonthList s
					On	s.Creator_Dept_Id = d.DeptId
		Where	d.EnableWF = 'Y'
		Order by dd.SortKey, d.SortKey

	Else

		Select	dd.DeptName, d.DeptName,
				IsNull(s.Month01, 0),
				IsNull(s.Month02, 0),
				IsNull(s.Month03, 0),
				IsNull(s.Month04, 0),
				IsNull(s.Month05, 0),
				IsNull(s.Month06, 0),
				IsNull(s.Month07, 0),
				IsNull(s.Month08, 0),
				IsNull(s.Month09, 0),
				IsNull(s.Month10, 0),
				IsNull(s.Month11, 0),
				IsNull(s.Month12, 0),
				IsNull(s.Month01, 0) + IsNull(s.Month02, 0) + IsNull(s.Month03, 0) + IsNull(s.Month04, 0) + IsNull(s.Month05, 0) +
				IsNull(s.Month06, 0) + IsNull(s.Month07, 0) + IsNull(s.Month08, 0) + IsNull(s.Month09, 0) + IsNull(s.Month10, 0) +
				IsNull(s.Month11, 0) + IsNull(s.Month12, 0)
				,dd.SortKey	as ParentSortKey
				,d.SortKey	as SortKey
		From	eManage.dbo.TB_Dept d
				Left Join	eManage.dbo.TB_Dept dd
					On	dd.DeptId = d.ParentDeptId
				Left Join	#TmpDeptMonthList s
					On	s.Creator_Dept_Id = d.DeptId
		Where	d.EnableWF = 'Y'
		Union
		Select	dd.DeptName, '합계',
				IsNull(Sum(s.Month01), 0),
				IsNull(Sum(s.Month02), 0),
				IsNull(Sum(s.Month03), 0),
				IsNull(Sum(s.Month04), 0),
				IsNull(Sum(s.Month05), 0),
				IsNull(Sum(s.Month06), 0),
				IsNull(Sum(s.Month07), 0),
				IsNull(Sum(s.Month08), 0),
				IsNull(Sum(s.Month09), 0),
				IsNull(Sum(s.Month10), 0),
				IsNull(Sum(s.Month11), 0),
				IsNull(Sum(s.Month12), 0),
				IsNull(Sum(s.Month01), 0) + IsNull(Sum(s.Month02), 0) + IsNull(Sum(s.Month03), 0) + IsNull(Sum(s.Month04), 0) +
				IsNull(Sum(s.Month05), 0) + IsNull(Sum(s.Month06), 0) + IsNull(Sum(s.Month07), 0) + IsNull(Sum(s.Month08), 0) +
				IsNull(Sum(s.Month09), 0) + IsNull(Sum(s.Month10), 0) + IsNull(Sum(s.Month11), 0) + IsNull(Sum(s.Month12), 0)
				,dd.SortKey	as ParentSortKey
				,'99'	as SortKey
		From	eManage.dbo.TB_Dept d
				Left Join	eManage.dbo.TB_Dept dd
					On	dd.DeptId = d.ParentDeptId
				Left Join	#TmpDeptMonthList s
					On	s.Creator_Dept_Id = d.DeptId
		Where	d.EnableWF = 'Y'
		Group by dd.DeptName,dd.SortKey
		Union
		Select	'', '합계',
				IsNull(Sum(s.Month01), 0),
				IsNull(Sum(s.Month02), 0),
				IsNull(Sum(s.Month03), 0),
				IsNull(Sum(s.Month04), 0),
				IsNull(Sum(s.Month05), 0),
				IsNull(Sum(s.Month06), 0),
				IsNull(Sum(s.Month07), 0),
				IsNull(Sum(s.Month08), 0),
				IsNull(Sum(s.Month09), 0),
				IsNull(Sum(s.Month10), 0),
				IsNull(Sum(s.Month11), 0),
				IsNull(Sum(s.Month12), 0),
				IsNull(Sum(s.Month01), 0) + IsNull(Sum(s.Month02), 0) + IsNull(Sum(s.Month03), 0) + IsNull(Sum(s.Month04), 0) +
				IsNull(Sum(s.Month05), 0) + IsNull(Sum(s.Month06), 0) + IsNull(Sum(s.Month07), 0) + IsNull(Sum(s.Month08), 0) +
				IsNull(Sum(s.Month09), 0) + IsNull(Sum(s.Month10), 0) + IsNull(Sum(s.Month11), 0) + IsNull(Sum(s.Month12), 0)
				,'99'	as ParentSortKey
				,'99'	as SortKey
		From	eManage.dbo.TB_Dept d
				Left Join	eManage.dbo.TB_Dept dd
					On	dd.DeptId = d.ParentDeptId
				Left Join	#TmpDeptMonthList s
					On	s.Creator_Dept_Id = d.DeptId
		Where	d.EnableWF = 'Y'
		Order by dd.SortKey, d.SortKey


/*

Select	top 10
	substring(w.participant_id, 1, 4)
, *
From	eWFForm.dbo.VW_WORK_LIST w
		Join	eWF.dbo.PROCESS_INSTANCE p
			On	p.Oid = w.ItemOid
Where	Convert(varchar(8), w.ItemCreate_Date, 112) between '20050101' and '20051212'	--	@pItemCreate_Date
	and	w.CategoryName = '반납의뢰서'	--	@pDocName
	and	p.State = '7'		--	@pState
order by w.Create_Date


Select	top 100 *	From	eWF.dbo.PROCESS_INSTANCE v	Where	oid = 'ZB66BD11E1AB84F27BAAB78823DE41675'
Select	top 100 *	From	eWFForm.dbo.VW_WORK_LIST v	Where	itemoid = 'ZB66BD11E1AB84F27BAAB78823DE41675'

Select	top 100 *	From	eWF.dbo.PROCESS_INSTANCE v	Where	oid = 'Z07EC8FAD1AD846F4B3361EF80086AC52'

Select	top 100 *	From	eWFForm.dbo.VW_WORK_LIST v	Where	itemoid = 'Z07EC8FAD1AD846F4B3361EF80086AC52' order by create_date
Select	top 100 *	From	eWFForm.dbo.VW_WORK_LIST v	Where	itemoid = 'ZB66BD11E1AB84F27BAAB78823DE41675' order by create_date
Select	top 100 *	From	eWFForm.dbo.VW_WORK_LIST v	Where	itemoid = 'Z08FBBDDB0BB24E1C945F4D86325E3167' order by create_date
Select	top 100 *	From	eWFForm.dbo.VW_WORK_LIST v	Where	itemoid = 'ZE370EFA5404D4986887010D75AB2E47B' order by create_date

Select	top 100 *	From	eWF.dbo.PROCESS_INSTANCE v	Where	oid = 'ZE370EFA5404D4986887010D75AB2E47B'

Select	top 100 *
From	ewfform.dbo.FORM_Y916C53AF4A1B45C3A2E5110227D8530B
Where	process_id = 'Z28FAD3E8799244198B4012A7FE94DB7E'

*/


RETURN






GO
/****** Object:  StoredProcedure [dbo].[UP_LIST_DEPTFOLDER]    Script Date: 2015-10-15 오후 1:30:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

----------------------------------------------------------------------
----------------------------------------------------------------------
-- 작성자: LDCC 신상훈
-- 작성일: 2004.06.18
-- 수정일: 2004.06.18
-- 설  명: 자기부서의 부서문서함 조회	
-- 테스트: EXEC  UP_LIST_DEPTFOLDER '10021', '10007'
--	exec dbo.[UP_LIST_DEPTFOLDER_TEST] @vcUserId = '111332', @vcDeptId = '3009'

/*
SELECT	*	FROM	EMANAGE.DBO.VW_USER	WHERE	USERNAME = '강민성'
SELECT	*	FROM	eWFFORM.dbo.WF_DOC_FOLDER	
SELECT	*	FROM	eWFFORM.dbo.WF_ACL_SPECIAL_FOLDER	

		SELECT	APR_FOLDER_ID, 
				APR_FOLDER_TYPE, 
				DOC_FOLDER_NAME, 
				dbo.UF_DOCFOLDER_COUNT(CAST('111332' as int), '3009' + '|' + APR_FOLDER_ID + '|' + APR_FOLDER_TYPE) as CNT,
				SORTKEY
		FROM	eWFFORM.dbo.WF_DOC_FOLDER
		WHERE	APR_FOLDER_TYPE = 'D'
			AND DOC_FOLDER_TYPE = 'G'
			AND USAGE_YN = 'Y'

*/
----------------------------------------------------------------------
----------------------------------------------------------------------
CREATE	PROCEDURE	[dbo].[UP_LIST_DEPTFOLDER]
		@vcUserId	varchar(10),
		@vcDeptId	varchar(10)
AS

SELECT	C.APR_FOLDER_ID,  C. APR_FOLDER_TYPE, C.DOC_FOLDER_NAME,
--		substring(CNT, 2, Len(CNT)-2) as CNT,
		'' as CNT,
		C.SORTKEY
FROM	(SELECT APR_FOLDER_ID, 
				APR_FOLDER_TYPE, 
				DOC_FOLDER_NAME, 
--				dbo.UF_DOCFOLDER_COUNT(CAST(@vcUserId as int), @vcDeptId + '|' + APR_FOLDER_ID + '|' + APR_FOLDER_TYPE) as CNT,
				'' as CNT,
				SORTKEY
		FROM	eWFFORM.dbo.WF_DOC_FOLDER
		WHERE	APR_FOLDER_TYPE = 'D'
			AND DOC_FOLDER_TYPE = 'G'
			AND USAGE_YN = 'Y'
		UNION ALL
		SELECT	DISTINCT
				B.APR_FOLDER_ID,	-- 부서권한, 사용자권한이 겹칠경우 하나의 결재함만 표시한다
				B.APR_FOLDER_TYPE, 
				B.DOC_FOLDER_NAME, 
--				dbo.UF_DOCFOLDER_COUNT(10021, @vcDeptId + '|' + APR_FOLDER_ID + '|' + APR_FOLDER_TYPE) as CNT,
				'' as CNT,
				B.SORTKEY
		FROM	eWFFORM.dbo.WF_ACL_SPECIAL_FOLDER A (NOLOCK) , eWFFORM.dbo.Wf_DOC_FOLDER B (NOLOCK)
		WHERE	((A.USERID = @vcUserId	AND A.DEPTID  = @vcDeptId AND A.USER_TYPE = 'P')	-- 사용자권한 체크
					OR (A.USERID = @vcDeptId AND A.DEPTID  = @vcDeptId AND A.USER_TYPE = 'D'))	-- 부서권한 체크
			AND A.DOC_FOLDER_ID = B.DOC_FOLDER_ID
			AND B.USAGE_YN = 'Y'  -- 사용여부 	
			AND B.DOC_FOLDER_TYPE = 'S' 	
		) as C
ORDER BY C.SORTKEY

-- SELECT O.APR_FOLDER_ID, O.DOC_FOLDER_NAME, ISNULL(P.CNT, 0) TOTAL_CNT, ISNULL(P.OPEN_Y,0) OPEN_Y, ISNULL(P.OPEN_N,0) OPEN_N, O.SORTKEY
-- FROM
-- (
-- SELECT APR_FOLDER_ID, DOC_FOLDER_NAME, SORTKEY 
-- FROM eWFFORM.dbo.WF_DOC_FOLDER
-- WHERE APR_FOLDER_TYPE = 'D' AND USAGE_YN = 'Y'  --AND DOC_FOLDER_TYPE = 'G'
-- ) as O
-- 
-- LEFT OUTER JOIN
-- 
-- 조회건수가 들어있는 부서문서함 조회(권한체크 포함)
-- (
-- 	SELECT APR_FOLDER_CODE, OPEN_Y, OPEN_N, CNT
-- 		FROM eWFFORM.dbo.VW_PARTICIPANT_BOX
-- 			WHERE PARTICIPANT_ID IN (
-- 					SELECT	 @vcDeptId + '_' + APR_FOLDER_ID
-- 					      FROM	eWFFORM.dbo.WF_DOC_FOLDER(NOLOCK)
-- 					WHERE	APR_FOLDER_TYPE = 'D' AND DOC_FOLDER_TYPE = 'G' AND USAGE_YN = 'Y'																								
-- 			    	UNION ALL
-- 
-- 				SELECT @vcDeptId + '_' + D.APR_FOLDER_ID
-- 				      FROM
-- 				      (
-- 					-- 특정문서 , 부서/사용자 권한 내역
-- 					SELECT B.APR_FOLDER_ID,
-- 						CONVERT(INT, AVG (
-- 							CASE A.ACLID 
-- 								WHEN 'Y' THEN 1
-- 								ELSE 0
-- 							END )) AS ACLID
-- 					  FROM eWFFORM.dbo.WF_ACL_SPECIAL_FOLDER A (NOLOCK) , eWFFORM.dbo.Wf_DOC_FOLDER B (NOLOCK), eManage.dbo.VW_DEPT C (NOLOCK)
-- 					WHERE ((A.USERID = @vcUserId AND A.DEPTID  = @vcDeptId AND A.USER_TYPE = 'P')	-- 사용자권한 체크
-- 					    OR (A.USERID = @vcDeptId AND A.DEPTID  = @vcDeptId AND A.USER_TYPE = 'D'))	-- 부서권한 체크
-- 					    AND A.DOC_FOLDER_ID = B.DOC_FOLDER_ID
-- 					    AND B.USAGE_YN = 'Y'  -- 사용여부 							    
-- 					    AND A.DEPTID = C.DEPTID
-- 					GROUP BY A.DEPTID, C.DEPTNAME, B.DOC_FOLDER_ID, B.DOC_FOLDER_NAME, B.APR_FOLDER_ID											
-- 					) as D
-- 					WHERE D.ACLID = 1 )
-- 		AND APR_FOLDER_CODE NOT IN ('XXX')
-- ) as P
-- 
-- on O.APR_FOLDER_ID = P.APR_FOLDER_CODE
-- ORDER BY O.SORTKEY


GO
/****** Object:  StoredProcedure [dbo].[UP_LIST_DEPTFOLDER_TEST]    Script Date: 2015-10-15 오후 1:30:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

----------------------------------------------------------------------
----------------------------------------------------------------------
-- 작성자: LDCC 신상훈
-- 작성일: 2004.06.18
-- 수정일: 2004.06.18
-- 설  명: 자기부서의 부서문서함 조회	
-- 테스트: EXEC  UP_LIST_DEPTFOLDER '10021', '10007'
--	exec dbo.[UP_LIST_DEPTFOLDER_TEST] @vcUserId = '111332', @vcDeptId = '3009'

/*
SELECT	*	FROM	EMANAGE.DBO.VW_USER	WHERE	USERNAME = '강민성'
SELECT	*	FROM	eWFFORM.dbo.WF_DOC_FOLDER	
SELECT	*	FROM	eWFFORM.dbo.WF_ACL_SPECIAL_FOLDER	

		SELECT	APR_FOLDER_ID, 
				APR_FOLDER_TYPE, 
				DOC_FOLDER_NAME, 
				dbo.UF_DOCFOLDER_COUNT(CAST('111332' as int), '3009' + '|' + APR_FOLDER_ID + '|' + APR_FOLDER_TYPE) as CNT,
				SORTKEY
		FROM	eWFFORM.dbo.WF_DOC_FOLDER
		WHERE	APR_FOLDER_TYPE = 'D'
			AND DOC_FOLDER_TYPE = 'G'
			AND USAGE_YN = 'Y'

*/
----------------------------------------------------------------------
----------------------------------------------------------------------
CREATE	PROCEDURE	[dbo].[UP_LIST_DEPTFOLDER_TEST]
		@vcUserId	varchar(10),
		@vcDeptId	varchar(10)
AS

SELECT	C.APR_FOLDER_ID,  C. APR_FOLDER_TYPE, C.DOC_FOLDER_NAME,
--		substring(CNT, 2, Len(CNT)-2) as CNT,
		'' as CNT,
		C.SORTKEY
FROM	(SELECT APR_FOLDER_ID, 
				APR_FOLDER_TYPE, 
				DOC_FOLDER_NAME, 
--				dbo.UF_DOCFOLDER_COUNT(CAST(@vcUserId as int), @vcDeptId + '|' + APR_FOLDER_ID + '|' + APR_FOLDER_TYPE) as CNT,
				'' as CNT,
				SORTKEY
		FROM	eWFFORM.dbo.WF_DOC_FOLDER
		WHERE	APR_FOLDER_TYPE = 'D'
			AND DOC_FOLDER_TYPE = 'G'
			AND USAGE_YN = 'Y'
		UNION ALL
		SELECT	DISTINCT
				B.APR_FOLDER_ID,	-- 부서권한, 사용자권한이 겹칠경우 하나의 결재함만 표시한다
				B.APR_FOLDER_TYPE, 
				B.DOC_FOLDER_NAME, 
--				dbo.UF_DOCFOLDER_COUNT(10021, @vcDeptId + '|' + APR_FOLDER_ID + '|' + APR_FOLDER_TYPE) as CNT,
				'' as CNT,
				B.SORTKEY
		FROM	eWFFORM.dbo.WF_ACL_SPECIAL_FOLDER A (NOLOCK) , eWFFORM.dbo.Wf_DOC_FOLDER B (NOLOCK)
		WHERE	((A.USERID = @vcUserId	AND A.DEPTID  = @vcDeptId AND A.USER_TYPE = 'P')	-- 사용자권한 체크
					OR (A.USERID = @vcDeptId AND A.DEPTID  = @vcDeptId AND A.USER_TYPE = 'D'))	-- 부서권한 체크
			AND A.DOC_FOLDER_ID = B.DOC_FOLDER_ID
			AND B.USAGE_YN = 'Y'  -- 사용여부 	
			AND B.DOC_FOLDER_TYPE = 'S' 	
		) as C
ORDER BY C.SORTKEY

-- SELECT O.APR_FOLDER_ID, O.DOC_FOLDER_NAME, ISNULL(P.CNT, 0) TOTAL_CNT, ISNULL(P.OPEN_Y,0) OPEN_Y, ISNULL(P.OPEN_N,0) OPEN_N, O.SORTKEY
-- FROM
-- (
-- SELECT APR_FOLDER_ID, DOC_FOLDER_NAME, SORTKEY 
-- FROM eWFFORM.dbo.WF_DOC_FOLDER
-- WHERE APR_FOLDER_TYPE = 'D' AND USAGE_YN = 'Y'  --AND DOC_FOLDER_TYPE = 'G'
-- ) as O
-- 
-- LEFT OUTER JOIN
-- 
-- 조회건수가 들어있는 부서문서함 조회(권한체크 포함)
-- (
-- 	SELECT APR_FOLDER_CODE, OPEN_Y, OPEN_N, CNT
-- 		FROM eWFFORM.dbo.VW_PARTICIPANT_BOX
-- 			WHERE PARTICIPANT_ID IN (
-- 					SELECT	 @vcDeptId + '_' + APR_FOLDER_ID
-- 					      FROM	eWFFORM.dbo.WF_DOC_FOLDER(NOLOCK)
-- 					WHERE	APR_FOLDER_TYPE = 'D' AND DOC_FOLDER_TYPE = 'G' AND USAGE_YN = 'Y'																								
-- 			    	UNION ALL
-- 
-- 				SELECT @vcDeptId + '_' + D.APR_FOLDER_ID
-- 				      FROM
-- 				      (
-- 					-- 특정문서 , 부서/사용자 권한 내역
-- 					SELECT B.APR_FOLDER_ID,
-- 						CONVERT(INT, AVG (
-- 							CASE A.ACLID 
-- 								WHEN 'Y' THEN 1
-- 								ELSE 0
-- 							END )) AS ACLID
-- 					  FROM eWFFORM.dbo.WF_ACL_SPECIAL_FOLDER A (NOLOCK) , eWFFORM.dbo.Wf_DOC_FOLDER B (NOLOCK), eManage.dbo.VW_DEPT C (NOLOCK)
-- 					WHERE ((A.USERID = @vcUserId AND A.DEPTID  = @vcDeptId AND A.USER_TYPE = 'P')	-- 사용자권한 체크
-- 					    OR (A.USERID = @vcDeptId AND A.DEPTID  = @vcDeptId AND A.USER_TYPE = 'D'))	-- 부서권한 체크
-- 					    AND A.DOC_FOLDER_ID = B.DOC_FOLDER_ID
-- 					    AND B.USAGE_YN = 'Y'  -- 사용여부 							    
-- 					    AND A.DEPTID = C.DEPTID
-- 					GROUP BY A.DEPTID, C.DEPTNAME, B.DOC_FOLDER_ID, B.DOC_FOLDER_NAME, B.APR_FOLDER_ID											
-- 					) as D
-- 					WHERE D.ACLID = 1 )
-- 		AND APR_FOLDER_CODE NOT IN ('XXX')
-- ) as P
-- 
-- on O.APR_FOLDER_ID = P.APR_FOLDER_CODE
-- ORDER BY O.SORTKEY


GO
/****** Object:  StoredProcedure [dbo].[UP_LIST_LATEST_PROCESS_INSTANCE]    Script Date: 2015-10-15 오후 1:30:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

----------------------------------------------------------------------
----------------------------------------------------------------------
-- 작성자: 신상훈
-- 작성일: 2004.05.20
-- 수정일: 2004.05.20
-- 설   명: 사용자가 기안한 결재문서 중 미결재된 기안문서(RTC용)
-- 테스트: EXEC  UP_LIST_LATEST_PROCESS_INSTANCE '100575'
----------------------------------------------------------------------
-- 수정일 : 
-- 수정자 : 
-- 수정내용 : 
----------------------------------------------------------------------
----------------------------------------------------------------------
CREATE     PROCEDURE [dbo].[UP_LIST_LATEST_PROCESS_INSTANCE]
	@vcUserId	varchar(10)
AS
SELECT  TOP 5 NAME, SUBJECT, CONVERT(VARCHAR(16), CREATE_DATE,20) CREATE_DATE, OID
	FROM eWF.dbo.PROCESS_INSTANCE A (NOLOCK)
		WHERE CREATOR_ID = @vcUserId AND STATE IN (1,3) AND DELETE_DATE  > GetDate()
			ORDER BY CREATE_DATE DESC


GO
/****** Object:  StoredProcedure [dbo].[UP_LIST_MYUNSIGNEDDOC]    Script Date: 2015-10-15 오후 1:30:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



----------------------------------------------------------------------
----------------------------------------------------------------------
-- 작성자: 신상훈
-- 작성일: 2004.06.18
-- 수정일: 2004.06.18
-- 설   명: 사용자가 기안한 결재문서 중 미결재된 기안문서(Main Page용)
-- 테스트: EXEC  UP_LIST_MYUNSIGNEDDOC '1017'
----------------------------------------------------------------------
-- 수정일 : 
-- 수정자 : 
-- 수정내용 : 
----------------------------------------------------------------------
----------------------------------------------------------------------
CREATE      PROCEDURE [dbo].[UP_LIST_MYUNSIGNEDDOC]
	@vcUserId	varchar(10)
AS
SELECT  TOP 5 NAME, SUBJECT, CONVERT(VARCHAR(16), CREATE_DATE,20) CREATE_DATE, OID
	FROM eWF.dbo.PROCESS_INSTANCE A (NOLOCK)
		WHERE CREATOR_ID = @vcUserId AND STATE IN (1,3) AND DELETE_DATE > GetDate()
			AND PARENT_OID = ''
			ORDER BY CREATE_DATE DESC




GO
/****** Object:  StoredProcedure [dbo].[UP_LIST_PERSONALFOLDER]    Script Date: 2015-10-15 오후 1:30:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

----------------------------------------------------------------------
----------------------------------------------------------------------
-- 작성자: LDCC 신상훈
-- 작성일: 2004.06.18
-- 수정일: 2004.06.18
-- 설  명: 개인문서함 조회	
-- 테스트: EXEC  UP_LIST_PERSONALFOLDER '141015', '01314'
----------------------------------------------------------------------
----------------------------------------------------------------------
CREATE    PROCEDURE [dbo].[UP_LIST_PERSONALFOLDER]
		
	@vcUserId	varchar(10),
	@vcDeptId	varchar(10)	
AS
SELECT O.APR_FOLDER_ID, O.DOC_FOLDER_NAME, ISNULL(P.CNT, 0) TOTAL_CNT, ISNULL(P.OPEN_Y,0) OPEN_Y, ISNULL(P.OPEN_N,0) OPEN_N, O.SORTKEY
FROM
(
SELECT APR_FOLDER_ID, DOC_FOLDER_NAME, SORTKEY 
FROM eWFFORM.dbo.WF_DOC_FOLDER
WHERE APR_FOLDER_TYPE = 'P' AND USAGE_YN = 'Y' AND DOC_FOLDER_TYPE = 'G'
) as O
LEFT OUTER JOIN
(
	SELECT APR_FOLDER_CODE, OPEN_Y, OPEN_N, CNT
		FROM eWFFORM.dbo.VW_PARTICIPANT_BOX	
			WHERE PARTICIPANT_ID = @vcUserId
--	UNION ALL
--	SELECT 'ST' APR_FOLDER_CODE, COUNT(*) OPEN_Y, 0 OPEN_N, COUNT(*) CNT
--		FROM eWFFORM.dbo.WF_FORM_STORAGE
--			WHERE USERID = @vcUserId AND DEPTID = @vcDeptId
)	 as P
on O.APR_FOLDER_ID = P.APR_FOLDER_CODE
ORDER BY O.SORTKEY


GO
/****** Object:  StoredProcedure [dbo].[UP_LIST_PERSONALFOLDER_NEWPORTAL]    Script Date: 2015-10-15 오후 1:30:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

----------------------------------------------------------------------
----------------------------------------------------------------------
-- 작성자: LDCC 신상훈 --> 남궁유진
-- 작성일: 2004.06.18
-- 수정일: 2004.06.18
-- 설  명: 개인문서함 조회	
-- 남궁유진씨 작업 잘못하고 신상훈한테 뒤집어 씌움...(20150807.. 증인 많음)
-- 테스트: EXEC  UP_LIST_PERSONALFOLDER_NEWPORTAL '19501019'
----------------------------------------------------------------------
----------------------------------------------------------------------
CREATE    PROCEDURE [dbo].[UP_LIST_PERSONALFOLDER_NEWPORTAL]
	@vEmpID		varchar(10)
AS

Declare @vcUserId	varchar(10)
Declare @vcDeptId	varchar(10)

select @vcUserId = UserID from emanage.dbo.tb_user where EmpID = @vEmpID
select @vcDeptId = DeptCD from emanage.dbo.tb_dept Where deptid = ( select top 1 DeptID from emanage.dbo.tb_dept_user where userid = @vcUserId )

SELECT O.APR_FOLDER_ID, O.DOC_FOLDER_NAME, ISNULL(P.CNT, 0) TOTAL_CNT, ISNULL(P.OPEN_Y,0) OPEN_Y, ISNULL(P.OPEN_N,0) OPEN_N, O.SORTKEY
FROM
(
SELECT APR_FOLDER_ID, DOC_FOLDER_NAME, SORTKEY 
FROM eWFFORM.dbo.WF_DOC_FOLDER
WHERE APR_FOLDER_TYPE = 'P' AND USAGE_YN = 'Y' AND DOC_FOLDER_TYPE = 'G'
) as O
LEFT OUTER JOIN
(
	SELECT APR_FOLDER_CODE, OPEN_Y, OPEN_N, CNT
		FROM eWFFORM.dbo.VW_PARTICIPANT_BOX	
			WHERE PARTICIPANT_ID = @vcUserId
--	UNION ALL
--	SELECT 'ST' APR_FOLDER_CODE, COUNT(*) OPEN_Y, 0 OPEN_N, COUNT(*) CNT
--		FROM eWFFORM.dbo.WF_FORM_STORAGE
--			WHERE USERID = @vcUserId AND DEPTID = @vcDeptId
)	 as P
on O.APR_FOLDER_ID = P.APR_FOLDER_CODE
ORDER BY O.SORTKEY
GO
/****** Object:  StoredProcedure [dbo].[UP_LIST_PRIDOCFOLDER]    Script Date: 2015-10-15 오후 1:30:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
----------------------------------------------------------------------
----------------------------------------------------------------------
-- 작성자: 신상훈
-- 작성일: 2004.06.07
-- 수정일: 2004.06.07
-- 설   명: 개인결재함에 있는 문서함들의 건수를 조회한다.
-- 테스트: EXEC  UP_LIST_COUNT_PRIDOCFOLDER_DOCUMENT '10020'
----------------------------------------------------------------------
-- 수정일 : 
-- 수정자 : 
-- 수정내용 : 
----------------------------------------------------------------------
----------------------------------------------------------------------
CREATE   PROC [dbo].[UP_LIST_PRIDOCFOLDER]
	@vcUserId	varchar(5)
AS
-- 개인 결재함 건수
SELECT 
	AA.APR_CNT_OPEN_Y,	-- 결재함 (열어본것)
	AA.APR_CNT_OPEN_N,	-- 결재함 (안 열어본것)
	AA.APR_CNT,		-- 결재함 (모두)
	AA.ING_CNT,		-- 진행함
	AA.COMP_CNT,		-- 완료함
	AA.REJ_CNT,		-- 반려함
	BB.IMSI_CNT		-- 임시저장함
 FROM (
		SELECT  A.PARTICIPANT_ID,
			ISNULL(SUM(
				CASE A.STATE	-- 결재함 2,3 (열어본것)
					WHEN 2 THEN
						CASE A.PROCESS_INSTANCE_VIEW_STATE
							WHEN 3 THEN 
								CASE UPPER(ISNULL(A.OPEN_YN,'N')) -- 열어본것
									WHEN 'Y' THEN 1
									ELSE 0
								END
							ELSE 0
						END 
					ELSE 0
				END  ),0) AS APR_CNT_OPEN_Y,
			ISNULL(SUM(
				CASE A.STATE	-- 결재함 2,3 (안 열어본것)
					WHEN 2 THEN
						CASE A.PROCESS_INSTANCE_VIEW_STATE
							WHEN 3 THEN 
								CASE UPPER(ISNULL(A.OPEN_YN,'N')) -- 안 열어본것
									WHEN 'N' THEN 1
									ELSE 0
								END
							ELSE 0
						END 
					ELSE 0
				END  ),0) AS APR_CNT_OPEN_N,
			ISNULL(SUM(
				CASE A.STATE	-- 결재함 2,3 (모두)
					WHEN 2 THEN
						CASE A.PROCESS_INSTANCE_VIEW_STATE
							WHEN 3 THEN 1
							ELSE 0
						END 
					ELSE 0
				END  ),0) AS APR_CNT,
			ISNULL(SUM(
				CASE A.STATE	-- 진행함 7,3 (모두)
					WHEN 7 THEN
						CASE A.PROCESS_INSTANCE_VIEW_STATE
							WHEN 3 THEN 1
							ELSE 0
						END 
					ELSE 0
				END  ),0) AS ING_CNT,
		
			ISNULL(SUM(
				CASE A.STATE	-- 완료함 7,7
					WHEN 7 THEN
						CASE A.PROCESS_INSTANCE_VIEW_STATE
							WHEN 7 THEN 1
							ELSE 0
						END 
					ELSE 0
				END  ),0) AS COMP_CNT,
			ISNULL(SUM(
				CASE A.STATE	-- 반려함 8,7
					WHEN 7 THEN
						CASE A.PROCESS_INSTANCE_VIEW_STATE
							WHEN 8 THEN 1
							ELSE 0
						END 
					ELSE 0
				END  ),0) AS REJ_CNT
		   FROM eWF.dbo.WORK_ITEM A (NOLOCK), eWF.dbo.PROCESS_INSTANCE B (NOLOCK)
		 WHERE A.PARTICIPANT_ID = @vcUserId
		     AND A.PROCESS_INSTANCE_OID = B.OID
		     AND B.STATE IN (1,3,7,8)
		     AND B.DELETE_DATE IS NULL
		GROUP BY A.PARTICIPANT_ID
	) AA, (
		SELECT A.USERID, COUNT(*) IMSI_CNT
		  FROM eWFFORM.dbo.WF_FORM_STORAGE A (NOLOCK)
		WHERE A.USERID = @vcUserId
		  AND A.DELETE_DATE IS NULL
		GROUP BY A.USERID ) BB 
WHERE AA.PARTICIPANT_ID = BB.USERID
SET QUOTED_IDENTIFIER ON 

GO
/****** Object:  StoredProcedure [dbo].[UP_LIST_RECDEPTFOLDER]    Script Date: 2015-10-15 오후 1:30:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

----------------------------------------------------------------------
----------------------------------------------------------------------
-- 작성자: LDCC 신상훈
-- 작성일: 2004.06.08
-- 수정일: 2004.06.08
-- 설  명: 자기부서의 특정권한문서함 조회	
-- 테스트: EXEC  UP_LIST_RECDEPTFOLDER 100575, 1167
-- SELECT * FROM eManage.dbo.VW_USER WHERE username='신상훈'

----------------------------------------------------------------------
----------------------------------------------------------------------
CREATE  PROCEDURE [dbo].[UP_LIST_RECDEPTFOLDER]
		
	@intUserId	int,	
	@intDeptId	int
AS
SELECT D.DEPTID, D.DEPTNAME, D.DOC_FOLDER_ID, D.DOC_FOLDER_NAME, D.ACLID
FROM
(
-- 특정문서 , 부서/사용자 권한 내역
SELECT A.DEPTID, C.DEPTNAME, B.DOC_FOLDER_ID, B.DOC_FOLDER_NAME, 
	CONVERT(INT, AVG (
		CASE A.ACLID 
			WHEN 'Y' THEN 1
			ELSE 0
		END )) AS ACLID
  FROM eWFFORM.dbo.WF_ACL_SPECIAL_FOLDER A (NOLOCK) , eWFFORM.dbo.Wf_DOC_FOLDER B (NOLOCK), eManage.dbo.VW_DEPT C (NOLOCK)
WHERE ((A.USERID = @intUserId AND A.DEPTID  = @intDeptId AND A.USER_TYPE = 'P')
 	 OR (A.USERID = @intUserId AND A.DEPTID  IN ( -- 겸직부서 내역 조회
		SELECT DeptID
		FROM eManage.dbo.VW_USER
		WHERE UserID = @intUserId AND EndDate > GetDate()
		) ))
    AND A.DOC_FOLDER_ID = B.DOC_FOLDER_ID
    AND B.USAGE_YN = 'Y'  -- 사용여부
    AND B.APR_FOLDER_ID = 'R' -- 수신함
    AND A.DEPTID = C.DEPTID   
GROUP BY A.DEPTID, C.DEPTNAME, B.DOC_FOLDER_ID, B.DOC_FOLDER_NAME
UNION ALL
-- 타부서 부서/사용자 권한 내역
-- WF_ACL_OTHER_DEPT : 타부서 권한 테이블
-- Wf_DOC_FOLDER : 문서함 테이블
SELECT  A.OTHER_DEPTID,C.DEPTNAME,   B.DOC_FOLDER_ID, B.DOC_FOLDER_NAME,
	CONVERT(INT, AVG (
		CASE A.ACLID 
			WHEN 'Y' THEN 1
			ELSE 0
		END )) AS ACLID
  FROM eWFFORM.dbo.WF_ACL_OTHER_DEPT A (NOLOCK), eWFFORM.dbo.Wf_DOC_FOLDER B (NOLOCK), eManage.dbo.VW_DEPT C
WHERE (A.USERID = @intUserId 
 	 OR A.DEPTID  IN ( -- 겸직부서 내역 조회
		SELECT DeptID
		FROM eManage.dbo.VW_USER
		WHERE UserID = @intUserId AND EndDate > GetDate()
		) )
    AND A.DOC_FOLDER_ID = B.DOC_FOLDER_ID
    AND B.USAGE_YN = 'Y'  -- 사용여부
    AND APR_FOLDER_ID = 'R' -- 수신함
    AND A.OTHER_DEPTID = C.DEPTID
GROUP BY A.OTHER_DEPTID, C.DEPTNAME, B.DOC_FOLDER_ID, B.DOC_FOLDER_NAME
) as D
WHERE D.ACLID = 1
SET QUOTED_IDENTIFIER ON 


GO
/****** Object:  StoredProcedure [dbo].[UP_LIST_SPECIAL_APPROVALLIST]    Script Date: 2015-10-15 오후 1:30:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*

<USER>
<ITEM><PARENT>일반결재_1.1</PARENT><SEQ>1</SEQ><ALIAS>113500</ALIAS><DISPLAYNAME>김동수</DISPLAYNAME><DEPARTNAME>F/S팀</DEPARTNAME><TITLE>사원</TITLE><STATUS>지점업무</STATUS><POSITION>200</POSITION><COMMENT><![CDATA[]]></COMMENT><SIGNTYPE>일반결재</SIGNTYPE><RECEIVEDDATE><![CDATA[2006-01-31 17:49:01]]></RECEIVEDDATE><SIGNDATE>2006-01-31 17:54:31</SIGNDATE><SIGNSTATUS>결재</SIGNSTATUS><SIGNIMAGE><![CDATA[<IMG WIDTH="39" HEIGHT="45" SRC="http://lcware.lottechilsung.co.kr/ekwv2/Data/eWF/SignImg/2005/7/D431A8F4-14BD-4439-8.JPG">]]></SIGNIMAGE><DEPARTID>2707</DEPARTID></ITEM>
<ITEM><PARENT>일반결재_2.1</PARENT><SEQ>1</SEQ><ALIAS>112648</ALIAS><DISPLAYNAME>나한채</DISPLAYNAME><DEPARTNAME>F/S팀</DEPARTNAME><TITLE>팀장</TITLE><STATUS>팀장</STATUS><POSITION>90</POSITION><COMMENT><![CDATA[]]></COMMENT><SIGNTYPE>일반결재</SIGNTYPE><RECEIVEDDATE>2006-01-31 17:54:31</RECEIVEDDATE><SIGNDATE>2006-01-31 20:10:33</SIGNDATE><SIGNSTATUS>결재</SIGNSTATUS><SIGNIMAGE><![CDATA[<IMG WIDTH="39" HEIGHT="45" SRC="http://lcware.lottechilsung.co.kr/ekwv2/Data/eWF/SignImg/2005/7/54488368-1DFE-4B20-9.JPG">]]></SIGNIMAGE><DEPARTID>2707</DEPARTID></ITEM>
<ITEM><PARENT>일반결재_3.1</PARENT><SEQ>1</SEQ><ALIAS>111678</ALIAS><DISPLAYNAME>김상태</DISPLAYNAME><DEPARTNAME>특수영업부</DEPARTNAME><TITLE>부장</TITLE><STATUS>부장</STATUS><POSITION>80</POSITION><COMMENT><![CDATA[]]></COMMENT><SIGNTYPE>일반결재</SIGNTYPE><RECEIVEDDATE>2006-01-31 20:10:33</RECEIVEDDATE><SIGNDATE>2006-01-31 20:23:18</SIGNDATE><SIGNSTATUS>결재</SIGNSTATUS><SIGNIMAGE><![CDATA[<IMG WIDTH="39" HEIGHT="45" SRC="http://lcware.lottechilsung.co.kr/ekwv2/Data/eWF/SignImg/2005/7/B7D77DC2-B73F-475E-8.JPG">]]></SIGNIMAGE><DEPARTID>2580</DEPARTID></ITEM>
<ITEM><PARENT>수신결재_1.1</PARENT><SEQ>1</SEQ><ALIAS>111373</ALIAS><DISPLAYNAME>이경섭</DISPLAYNAME><DEPARTNAME>노무후생과</DEPARTNAME><TITLE>주임</TITLE><STATUS>사무직</STATUS><POSITION>160</POSITION><COMMENT><![CDATA[]]></COMMENT><SIGNTYPE>일반결재</SIGNTYPE><RECEIVEDDATE>2006-02-03 08:57:52</RECEIVEDDATE><SIGNDATE>2006-02-03 09:25:29</SIGNDATE><SIGNSTATUS>결재</SIGNSTATUS><SIGNIMAGE><![CDATA[<IMG WIDTH="39" HEIGHT="45" SRC="http://lcware.lottechilsung.co.kr/ekwv2/Data/eWF/SignImg/2005/7/8048E450-9C77-49E5-A.JPG">]]></SIGNIMAGE><DEPARTID>2561</DEPARTID></ITEM>
<ITEM><PARENT>수신결재_1.1</PARENT><SEQ>2</SEQ><ALIAS>111376</ALIAS><DISPLAYNAME>이영찬</DISPLAYNAME><DEPARTNAME>노무후생과</DEPARTNAME><TITLE>과장</TITLE><STATUS>과장</STATUS><POSITION>120</POSITION><COMMENT><![CDATA[]]></COMMENT><SIGNTYPE>전결</SIGNTYPE><RECEIVEDDATE>2006-02-03 09:25:29</RECEIVEDDATE><SIGNDATE>2006-02-03 09:40:08</SIGNDATE><SIGNSTATUS>결재</SIGNSTATUS><SIGNIMAGE><![CDATA[<IMG WIDTH="39" HEIGHT="45" SRC="http://lcware.lottechilsung.co.kr/ekwv2/Data/eWF/SignImg/2005/7/3B81AA1E-236D-4F46-A.JPG">]]></SIGNIMAGE><DEPARTID>2561</DEPARTID></ITEM>
<ITEM><PARENT>수신결재_1.1</PARENT><SEQ>3</SEQ><ALIAS>111374</ALIAS><DISPLAYNAME>김선호</DISPLAYNAME><DEPARTNAME>총무부</DEPARTNAME><TITLE>이사</TITLE><STATUS>관리직</STATUS><POSITION>50</POSITION><COMMENT></COMMENT><SIGNTYPE>결재안함</SIGNTYPE><RECEIVEDDATE></RECEIVEDDATE><SIGNDATE></SIGNDATE><SIGNSTATUS>대기</SIGNSTATUS><SIGNIMAGE></SIGNIMAGE><DEPARTID>2560</DEPARTID></ITEM>
<ITEM><PARENT>수신결재_1.1</PARENT><SEQ>4</SEQ><ALIAS>111283</ALIAS><DISPLAYNAME>이재혁</DISPLAYNAME><DEPARTNAME>임원실</DEPARTNAME><TITLE>상무</TITLE><STATUS>관리본부장</STATUS><POSITION>40</POSITION><COMMENT></COMMENT><SIGNTYPE>결재안함</SIGNTYPE><RECEIVEDDATE></RECEIVEDDATE><SIGNDATE></SIGNDATE><SIGNSTATUS>대기</SIGNSTATUS><SIGNIMAGE></SIGNIMAGE><DEPARTID>2539</DEPARTID></ITEM>
<ITEM><PARENT>수신결재_1.1</PARENT><SEQ>5</SEQ><ALIAS>111280</ALIAS><DISPLAYNAME>이종원</DISPLAYNAME><DEPARTNAME>임원실</DEPARTNAME><TITLE>대표이사</TITLE><STATUS>대표이사</STATUS><POSITION>10</POSITION><COMMENT></COMMENT><SIGNTYPE>결재안함</SIGNTYPE><RECEIVEDDATE></RECEIVEDDATE><SIGNDATE></SIGNDATE><SIGNSTATUS>대기</SIGNSTATUS><SIGNIMAGE></SIGNIMAGE><DEPARTID>2539</DEPARTID></ITEM>
</USER>

select	*	from	emanage.dbo.tb_user	where	username = '이광훈'

kh001
kh007
두개중에 하나 어떤건지 수미한테 물어보구 <ALIAS>111280</ALIAS>를 <ALIAS>UserID</ALIAS>로 바꿔주고
실행해
ㅇㅋ?네

*/

CREATE	Procedure	[dbo].[UP_LIST_SPECIAL_APPROVALLIST]
		@pFrDate	char(8) = '',
		@pToDate	char(8) = ''

As


	If	Len(@pFrDate) <> 8	or	Len(@pToDate) <> 8
	Begin
		Raiserror('조회일자오류', 1, 1)
		Return
	End

	Drop	Table	#Oid
	Select	p.Oid,
			p.State,
			Max(w.Create_Date) LastAppDate
	Into	#Oid
	From	eWF.dbo.Process_Instance p
			Join	eWF.dbo.Process_Sign_Inform s
				On	s.PROCESS_INSTANCE_OID = p.Oid
			Join	eWF.dbo.Work_Item w
				On	w.Process_Instance_Oid = p.Oid
				and	w.Name = '일반결재자'
	Where	Convert(char(8), p.Create_Date, 112) between @pFrDate and @pToDate
		and	s.Sign_Context like '%<ALIAS>133482</ALIAS>%'
	Group by p.Oid,	p.State

	Drop	Table	#tmp
	Select	o.Oid,
			Identity(int, 1, 1) as Num
	Into	#tmp
	From	#Oid o
			Join	eWF.dbo.Work_Item w
				On	w.Process_Instance_Oid = o.Oid
				and	w.Create_Date = o.LastAppDate
	Where	o.State = '1'
		or	(o.State in ('7', '8') and w.PARTICIPANT_ID = '133482')

Drop	Table	#3
Create	Table	#3
(
	num	int	identity(1, 1),
	ListNum	int,
	Oid		char(33),
	UserId	int,
	ComDate	char(8)
)

Drop	Table	#tmp2
Create	Table	#tmp2
(
	Num		int,
	ListNum	int,
	Oid		char(33),
	UserId	int,
	ComDate	char(8)
)


	Declare	@num	int,
			@oid	char(33)
	Set	@num = 0

	While	(1 = 1)
	Begin

		Select	Top 1
				@num = Num,
				@oid = Oid
		From	#tmp
		Where	Num > @num

		If	@@rowcount = 0	Break

		Insert	Into	#3
			(ListNum,	Oid,	UserId,	ComDate)
			Select	s.num, s.Oid, w.Participant_Id, Convert(char(8), w.COMPLETED_DATE, 112)	ComDate
			From	#tmp s
					Join	eWF.dbo.Work_Item w
						On	w.Process_Instance_Oid = s.Oid
						and	w.Name = '일반결재자'
			Where	s.Oid = @oid
			Order by w.Create_Date

		Insert	Into	#tmp2
			Select	*
			From	#3

		Truncate	Table	#3

	End

	Drop	Table	#SignList
	Select	Oid,
			sum(case	when	num = 1		then	UserId	else	0	end)	as UserId1,
			sum(case	when	num = 2		then	UserId	else	0	end)	as UserId2,
			sum(case	when	num = 3		then	UserId	else	0	end)	as UserId3,
			sum(case	when	num = 4		then	UserId	else	0	end)	as UserId4,
			sum(case	when	num = 5		then	UserId	else	0	end)	as UserId5,
			sum(case	when	num = 6		then	UserId	else	0	end)	as UserId6,
			sum(case	when	num = 7		then	UserId	else	0	end)	as UserId7,
			sum(case	when	num = 8		then	UserId	else	0	end)	as UserId8,
			sum(case	when	num = 9		then	UserId	else	0	end)	as UserId9,
			sum(case	when	num = 10	then	UserId	else	0	end)	as UserId10,
			
			sum(case	when	num = 1		then	IsNull(ComDate, 0)	else	0	end)	as UserDate1,
			sum(case	when	num = 2		then	IsNull(ComDate, 0)	else	0	end)	as UserDate2,
			sum(case	when	num = 3		then	IsNull(ComDate, 0)	else	0	end)	as UserDate3,
			sum(case	when	num = 4		then	IsNull(ComDate, 0)	else	0	end)	as UserDate4,
			sum(case	when	num = 5		then	IsNull(ComDate, 0)	else	0	end)	as UserDate5,
			sum(case	when	num = 6		then	IsNull(ComDate, 0)	else	0	end)	as UserDate6,
			sum(case	when	num = 7		then	IsNull(ComDate, 0)	else	0	end)	as UserDate7,
			sum(case	when	num = 8		then	IsNull(ComDate, 0)	else	0	end)	as UserDate8,
			sum(case	when	num = 9		then	IsNull(ComDate, 0)	else	0	end)	as UserDate9,
			sum(case	when	num = 10	then	IsNull(ComDate, 0)	else	0	end)	as UserDate10
	Into	#SignList
	From	#tmp2
	Group by Oid

/*
--	부,실
select	i.Name,
		dd.DeptName,
		Case	i.State
			When	1	Then	'진행중'
			When	7	Then	'결재완료'
			When	8	Then	'반려'
			When	13	Then	'기안취소'
			Else	''
		End,
		count(*)
from	#signlist s
		Join	Process_Instance i
			On	i.Oid = s.Oid
		Left Join	eManage.dbo.TB_Dept d
			On	d.DeptId = i.Creator_Dept_Id
		Left Join	eManage.dbo.TB_Dept dd
			On	dd.DeptId = d.ParentDeptId
Group by i.Name,
		dd.DeptName,
		Case	i.State
			When	1	Then	'진행중'
			When	7	Then	'결재완료'
			When	8	Then	'반려'
			When	13	Then	'기안취소'
			Else	''
		End
*/

--	과, 팀
Select	case
			when	i.Name = '기안용지'	then
				'기안서'
			when	i.Name = '기안용지(지점용)'	then
				'기안서(지점용)'
			else
				i.Name
		end,
		dd.DeptName,
		d.DeptName,
		Case	i.State
			When	1	Then	'진행중'
			When	7	Then	'결재완료'
			When	8	Then	'반려'
			When	13	Then	'기안취소'
			Else	''
		End,
		count(*),
		d.sortkey,
		dd.sortkey
From	#SignList s
		Join	eWF.dbo.Process_Instance i
			On	i.Oid = s.Oid
		Left Join	eManage.dbo.TB_Dept d
			On	d.DeptId = i.Creator_Dept_Id
		Left Join	eManage.dbo.TB_Dept dd
			On	dd.DeptId = d.ParentDeptId
Group by case
			when	i.Name = '기안용지'	then
				'기안서'
			when	i.Name = '기안용지(지점용)'	then
				'기안서(지점용)'
			else
				i.Name
		end,
		dd.DeptName,
		d.DeptName,
		Case	i.State
			When	1	Then	'진행중'
			When	7	Then	'결재완료'
			When	8	Then	'반려'
			When	13	Then	'기안취소'
			Else	''
		End,
		d.sortkey, dd.sortkey
Order by Case
			when	i.Name = '기안용지'	then
				'기안서'
			when	i.Name = '기안용지(지점용)'	then
				'기안서(지점용)'
			else
				i.Name
		end,
		d.sortkey, dd.sortkey,
		Case	i.State
			When	1	Then	'진행중'
			When	7	Then	'결재완료'
			When	8	Then	'반려'
			When	13	Then	'기안취소'
			Else	''
		End

--	결재선
Select	case
			when	i.Name = '기안용지'	then
				'기안서'
			when	i.Name = '기안용지(지점용)'	then
				'기안서(지점용)'
			else
				i.Name
		end,
		dd.DeptName,
		d.DeptName,
		i.Creator,
		Case	i.State
			When	1	Then	'진행중'
			When	7	Then	'결재완료'
			When	8	Then	'반려'
			When	13	Then	'기안취소'
			Else	''
		End,
		IsNull(u1.UserName, '')	UserNm1,
		Case	When	convert(char(1), UserDate1) = '0'	Then	''	Else	convert(char(8), UserDate1)	End,
		IsNull(u2.UserName, '')	UserNm2,
		Case	When	convert(char(1), UserDate2) = '0'	Then	''	Else	convert(char(8), UserDate2)	End,
		IsNull(u3.UserName, '')	UserNm3,
		Case	When	convert(char(1), UserDate3) = '0'	Then	''	Else	convert(char(8), UserDate3)	End,
		IsNull(u4.UserName, '')	UserNm4,
		Case	When	convert(char(1), UserDate4) = '0'	Then	''	Else	convert(char(8), UserDate4)	End,
		IsNull(u5.UserName, '')	UserNm5,
		Case	When	convert(char(1), UserDate5) = '0'	Then	''	Else	convert(char(8), UserDate5)	End,
		IsNull(u6.UserName, '')	UserNm6,
		Case	When	convert(char(1), UserDate6) = '0'	Then	''	Else	convert(char(8), UserDate6)	End,
		IsNull(u7.UserName, '')	UserNm7,
		Case	When	convert(char(1), UserDate7) = '0'	Then	''	Else	convert(char(8), UserDate7)	End,
		IsNull(u8.UserName, '')	UserNm8,
		Case	When	convert(char(1), UserDate8) = '0'	Then	''	Else	convert(char(8), UserDate8)	End,
		IsNull(u9.UserName, '')	UserNm9,
		Case	When	convert(char(1), UserDate9) = '0'	Then	''	Else	convert(char(8), UserDate9)	End,
		IsNull(u10.UserName, '')	UserNm10,
		Case	When	convert(char(1), UserDate10) = '0'	Then	''	Else	convert(char(8), UserDate10)	End
From	#SignList s
		Join	eWF.dbo.Process_Instance i
			On	i.Oid = s.Oid
		Left Join	eManage.dbo.tb_User u1
			On	u1.UserId = s.UserId1
		Left Join	eManage.dbo.tb_User u2
			On	u2.UserId = s.UserId2
		Left Join	eManage.dbo.tb_User u3
			On	u3.UserId = s.UserId3
		Left Join	eManage.dbo.tb_User u4
			On	u4.UserId = s.UserId4
		Left Join	eManage.dbo.tb_User u5
			On	u5.UserId = s.UserId5
		Left Join	eManage.dbo.tb_User u6
			On	u6.UserId = s.UserId6
		Left Join	eManage.dbo.tb_User u7
			On	u7.UserId = s.UserId7
		Left Join	eManage.dbo.tb_User u8
			On	u8.UserId = s.UserId8
		Left Join	eManage.dbo.tb_User u9
			On	u9.UserId = s.UserId9
		Left Join	eManage.dbo.tb_User u10
			On	u10.UserId = s.UserId10
		Left Join	eManage.dbo.TB_Dept d
			On	d.DeptId = i.Creator_Dept_Id
		Left Join	eManage.dbo.TB_Dept dd
			On	dd.DeptId = d.ParentDeptId
Order by Case
			when	i.Name = '기안용지'	then
				'기안서'
			when	i.Name = '기안용지(지점용)'	then
				'기안서(지점용)'
			else
				i.Name
		end,
		d.sortkey, dd.sortkey,
		Case	i.State
			When	1	Then	'진행중'
			When	7	Then	'결재완료'
			When	8	Then	'반려'
			When	13	Then	'기안취소'
			Else	''
		End





GO
/****** Object:  StoredProcedure [dbo].[UP_LIST_USEFORMS]    Script Date: 2015-10-15 오후 1:30:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*	----------------------------------------------------------------------
-- 작성자: 김기수
-- 작성일: 2005.03.23
-- 수정일: 2004.03.23
-- 설  명: 양식 조회
-- 테스트: EXEC  UP_LIST_ALLFORMS
----------------------------------------------------------------------
-- 수정일: 
-- 수정자: 
-- 수정내용 : 

select	*	from	dbo.WF_FORMS	where	form_id = 'YAE2F85A901AF4B43BC6906EF06C8DB83'
select	*	from	dbo.WF_FOLDER	where	folderid in ('10328', '10542')
select	*	from	dbo.WF_FOLDER_DETAIL	where	form_id = 'YAE2F85A901AF4B43BC6906EF06C8DB83'

----------------------------------------------------------------------	*/

CREATE	Procedure	[dbo].[UP_LIST_USEFORMS]
As

Set Nocount On


	Select	m.Form_id, m.Form_Name, f.FolderName
	From	eWFFORM.dbo.WF_FORMS m
			Join	eWFFORM.dbo.WF_FOLDER_DETAIL d
				On	d.Form_Id = m.Form_Id
			Join	eWFFORM.dbo.WF_FOLDER f
				On	f.FolderId = d.FolderId
			Join	eWFFORM.dbo.WF_FOLDER ff
				On	ff.FolderId = f.ParentFolderId
	Where	m.Current_forms = 'Y'
	--	and	m.Form_Id = 'YAE2F85A901AF4B43BC6906EF06C8DB83'
	Order by ff.FolderName, f.FolderId



Return



GO
/****** Object:  StoredProcedure [dbo].[UP_LIST_VW_WORKLIST_DOCUMENTLIST]    Script Date: 2015-10-15 오후 1:30:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO


CREATE	PROCEDURE	[dbo].[UP_LIST_VW_WORKLIST_DOCUMENTLIST]
		-- 사용자ID,사용자부서ID,결재함종류,현재페이지,블록(페이지)당표시건수,정렬필드,정렬방법,전체결재건수(Output)
		@strUserId varchar(10),
		@strUserDeptId varchar(20),
		@strDFType varchar(5),
		@nCurPage int, 
		@nRowPerPage int,
		@strSortColumn varchar(20),
		@strSortOrder varchar(5),
		@iTotalCount int output

AS

/*----------------------------------------------------------------------
-- 작성자: 마성옥
-- 작성일: 2004.03.10
-- 수정일: 2004.07.02
-- 설  명: 각 결재함 리스트 쿼리
-- 테스트: 

-- 사용자ID,사용자부서ID,결재함종류,현재페이지,블록(페이지)당표시건수,정렬필드,정렬방법,전체결재건수(Output)
select * from emanage.dbo.tb_user(nolock) where username = '정원탁'
select * from emanage.dbo.tb_dept(nolock) where deptname = '임원실'

--	대표이사 결재함
DECLARE @총건수 int 
EXEC  UP_LIST_VW_WORKLIST_DOCUMENTLIST '133342','','RF',1,100,'CREATE_DATE','ASC',@iTotalCount=@총건수 output

--	전무님 완료함
DECLARE @총건수 int 
EXEC  UP_LIST_VW_WORKLIST_DOCUMENTLIST '132139','','co', 5, 1000,'view_complete_DATE','ASC',@iTotalCount=@총건수 output

declare @P1 int
set @P1=116
exec dbo.UP_LIST_VW_WORKLIST_DOCUMENTLIST @strUserId = '133342', @strUserDeptId = '2972', @strDFType = 'RF', @nCurPage = 3, @nRowPerPage = 50, @strSortColumn = '0', @strSortOrder = 'DESC', @iTotalCount = @P1 output
select @P1

----------------------------------------------------------------------*/

DECLARE @iNum1 INT
DECLARE @iNum2 INT
DECLARE @sQuery VARCHAR(8000)
DECLARE @strOrderBy VARCHAR(100)
DECLARE @strOrderByRevers VARCHAR(100)
DECLARE @strSortOrderRevers CHAR(4)
DECLARE @nUserId INT
DECLARE @nSelectRecord INT		-- 실제로 반환할 레코드 수

SET @iNum1 = @nCurPage * @nRowPerPage
SET @iNum2 = (@nCurPage-1) * @nRowPerPage
SET @nSelectRecord = @nRowPerPage

IF	@strDFType = 'AP'
BEGIN

	--결재함 
	-- 전체 레코드 Count 를 Output 으로 리턴함
	SET @iTotalCount = 
					(	SELECT count(*) 
						FROM dbo.VW_WORK_LIST 
						WHERE PARTICIPANT_ID = @strUserId 
							AND STATE = '2' 
							AND PROCESS_INSTANCE_VIEW_STATE = '3' 
							AND ITEMSTATE = '1'	)

	----------------------실제로 조회해야할 레코드 카운트 계산----------------------*
	/* 
	총 레코드 카운트가 이론적인 총 레코드 카운트(현재페이지*페이지사이즈)보다 작을때 
	총 레코드 수에서 이전 페이지까지의 레코드 수를 빼서 나머지 필요한 레코드 카운트를 구한다.
	*/

	IF	@iTotalCount < (@iNum1)
	BEGIN
		SET @nSelectRecord = @iTotalCount - ((@nCurPage - 1) * @nRowPerPage)
	END

	----------------------반환할 레코드 카운트가 1 미만인 경우----------------------
	IF @nSelectRecord < 1
	BEGIN
		SET @nSelectRecord = 0
		SET @iNum1 =0
	END

	-- 소팅컬럼의 값이 0이 넘어오면 기본값으로 정렬
	if @strSortColumn = '0'	
		Begin
			SET @strOrderBy = ' ORDER BY CREATE_DATE DESC'
		end
	else
		begin
			SET @strOrderBy = ' ORDER BY '+@strSortColumn+' '+@strSortOrder+ ' , ITEMCREATE_DATE DESC'
		end
		
	-------------------------------[공통]---------------------------------------------------
	-- 소팅컬럼의 값이 0이 넘어오면 기본값으로 정렬
	if @strSortColumn = '0'	
		Begin
			SET @strOrderByRevers = ' ORDER BY CREATE_DATE ASC'
		end
	else
		begin
			SET @strSortOrderRevers =
			(
				CASE @strSortOrder
					WHEN 'ASC'		
							THEN	'DESC'
					WHEN 'DESC'	
							THEN	'ASC'				
				END 
			)	
			
			SET @strOrderByRevers = ' ORDER BY '+@strSortColumn+' '+@strSortOrderRevers+ ' , ITEMCREATE_DATE ASC'
		end	
	-------------------------------[공통]---------------------------------------------------		

	SET @sQuery =	
				'SELECT 
					a.ITEMOID,
					a.IsUrgent, 
					a.Status, 
					a.ISATTACHFILE, 
					a.PostScript, 
					a.CATEGORYNAME, 
					a.SUBJECT, 
					a.DOC_LEVEL, 
					a.CREATOR, 
					a.CREATOR_DEPT, 
					SUBSTRING(CONVERT(varchar,a.CREATE_DATE,21),0,20) as CREATE_DATE,					
					a.OPEN_YN,
					a.OID,
					a.Ref_Doc,
					a.ATTACH_EXTENSION,
					a.CREATOR_ID,
					a.DOC_NUMBER				

				FROM  (
					select top ' + CAST(@nSelectRecord AS VARCHAR) + ' * 
					from (
						select top ' + CAST(@iNum1 AS VARCHAR) + ' * 
						from dbo.VW_WORK_LIST 
						where Participant_id = '''+@strUserId+'''  
						AND STATE = ''2''  
						AND PROCESS_INSTANCE_VIEW_STATE = ''3''			
						AND ITEMSTATE = ''1''
						' +@strOrderBy+ '

						) a
					' +@strOrderByRevers+ '
		   			) a
				' +@strOrderBy

END
Else if @strDFType = 'AF'
Begin

	--후결함 
    -- 전체 레코드 Count 를 Output 으로 리턴함
	SET @iTotalCount = 
					(	SELECT count(*) 
						FROM dbo.VW_WORK_LIST 

						WHERE PARTICIPANT_ID = @strUserId 
							AND STATE = '2' 
							AND PROCESS_INSTANCE_VIEW_STATE = '9' 
							AND ITEMSTATE = '1'	)

	----------------------실제로 조회해야할 레코드 카운트 계산----------------------*
	/* 
	총 레코드 카운트가 이론적인 총 레코드 카운트(현재페이지*페이지사이즈)보다 작을때 
	총 레코드 수에서 이전 페이지까지의 레코드 수를 빼서 나머지 필요한 레코드 카운트를 구한다.
	*/

	IF @iTotalCount < (@iNum1)
	BEGIN
		SET @nSelectRecord = @iTotalCount - ( (@nCurPage - 1) * @nRowPerPage )
	END

	----------------------반환할 레코드 카운트가 1 미만인 경우----------------------
	IF @nSelectRecord < 1
	BEGIN
		SET @nSelectRecord = 0
		SET @iNum1 =0
	END


	-- 소팅컬럼의 값이 0이 넘어오면 기본값으로 정렬
	if @strSortColumn = '0'	
		Begin
			SET @strOrderBy = ' ORDER BY CREATE_DATE DESC'
		end
	else
		begin
			SET @strOrderBy = ' ORDER BY '+@strSortColumn+' '+@strSortOrder+ ' , ITEMCREATE_DATE DESC'
		end

	-------------------------------[공통]---------------------------------------------------
	-- 소팅컬럼의 값이 0이 넘어오면 기본값으로 정렬
	if @strSortColumn = '0'	
		Begin
			SET @strOrderByRevers = ' ORDER BY CREATE_DATE ASC'
		end
	else
		begin
			SET @strSortOrderRevers =
			(
				CASE @strSortOrder
					WHEN 'ASC'		
							THEN	'DESC'
					WHEN 'DESC'	
							THEN	'ASC'				
				END 
			)	
			
			SET @strOrderByRevers = ' ORDER BY '+@strSortColumn+' '+@strSortOrderRevers+ ' , ITEMCREATE_DATE ASC'
		end	
	-------------------------------[공통]---------------------------------------------------	

	SET @sQuery =	
				'SELECT	 
					a.ITEMOID,				
					a.IsUrgent, 
					a.Status, 
					a.ISATTACHFILE, 
					a.PostScript, 
					a.CATEGORYNAME, 
					a.SUBJECT, 					
					a.DOC_LEVEL, 
					a.CREATOR, 
					a.CREATOR_DEPT, 
					SUBSTRING(CONVERT(varchar,a.CREATE_DATE,21),0,20) as CREATE_DATE,					
					a.OPEN_YN,
					a.OID,
					a.Ref_Doc,
					a.ATTACH_EXTENSION,
					a.CREATOR_ID,
					a.DOC_NUMBER	
					
				FROM  (
					select top ' + CAST(@nSelectRecord AS VARCHAR) + ' * 
					from (
						select top ' + CAST(@iNum1 AS VARCHAR) + ' * 
						from dbo.VW_WORK_LIST 
						where Participant_id = '''+@strUserId+'''  
						AND STATE = ''2''  
						AND PROCESS_INSTANCE_VIEW_STATE = ''9''			
						AND ITEMSTATE = ''1''
						' +@strOrderBy+ '
						) a
					' +@strOrderByRevers+ '
		   			) a
				' +@strOrderBy					

End
Else if @strDFType = 'PR'
Begin
	--진행함
    -- 전체 레코드 Count 를 Output 으로 리턴함		
	SET @iTotalCount = (
						SELECT  count(*) 
						FROM dbo.VW_WORK_LIST 
						WHERE PARTICIPANT_ID = @strUserId 
						AND STATE = '7' 
						AND PROCESS_INSTANCE_VIEW_STATE = '3' 
						AND ITEMSTATE = '1'
						)

----------------------실제로 조회해야할 레코드 카운트 계산----------------------*
/* 
총 레코드 카운트가 이론적인 총 레코드 카운트(현재페이지*페이지사이즈)보다 작을때 
총 레코드 수에서 이전 페이지까지의 레코드 수를 빼서 나머지 필요한 레코드 카운트를 구한다.
*/

IF @iTotalCount < (@iNum1)
BEGIN
	SET @nSelectRecord = @iTotalCount - ( (@nCurPage - 1) * @nRowPerPage )
END

----------------------반환할 레코드 카운트가 1 미만인 경우----------------------
IF @nSelectRecord < 1
BEGIN
	SET @nSelectRecord = 0
	SET @iNum1 =0
END

	-- 소팅컬럼의 값이 0이 넘어오면 기본값으로 정렬
	if @strSortColumn = '0'	
		Begin
			SET @strOrderBy = ' ORDER BY COMPLETED_DATE DESC'
		end
	else
		begin
			SET @strOrderBy = ' ORDER BY '+@strSortColumn+' '+@strSortOrder+' , ITEMCREATE_DATE DESC'
		end

	-------------------------------[공통]---------------------------------------------------
	-- 소팅컬럼의 값이 0이 넘어오면 기본값으로 정렬
	if @strSortColumn = '0'	
		Begin
			SET @strOrderByRevers = ' ORDER BY COMPLETED_DATE ASC'
		end
	else
		begin
			SET @strSortOrderRevers =

			(
				CASE @strSortOrder
					WHEN 'ASC'		
							THEN	'DESC'
					WHEN 'DESC'	
							THEN	'ASC'				
				END 
			)	
			
			SET @strOrderByRevers = ' ORDER BY '+@strSortColumn+' '+@strSortOrderRevers+ ' , ITEMCREATE_DATE ASC'
		end	
	-------------------------------[공통]---------------------------------------------------
	
	SET @sQuery =	
		'SELECT	 
				a.ITEMOID,	
				a.IsUrgent, 

				a.Status, 
				a.ISATTACHFILE, 
				a.PostScript,
				a.CATEGORYNAME, 
				a.SUBJECT, 
				a.DOC_LEVEL, 
				a.CREATOR, 
				a.CREATOR_DEPT, 
				SUBSTRING(CONVERT(VARCHAR,a.COMPLETED_DATE,21),0,20) as COMPLETED_DATE,
				a.OPEN_YN,
				a.OID,
				a.Ref_Doc,
				a.ATTACH_EXTENSION,
				a.CREATOR_ID,
				a.DOC_NUMBER						
		FROM  (
			select top ' + CAST(@nSelectRecord AS VARCHAR) + ' * 
			from (
				select top ' + CAST(@iNum1 AS VARCHAR) + ' * 
				from dbo.VW_WORK_LIST 
				where Participant_id = '''+@strUserId+'''  
				AND STATE = ''7''  
				AND PROCESS_INSTANCE_VIEW_STATE = ''3''			
				AND ITEMSTATE = ''1''
				' +@strOrderBy+ '
				) a
			' +@strOrderByRevers+ '
		   	) a
		' +@strOrderBy	

End
Else if @strDFType = 'CO'
Begin

	--완료함
    -- 전체 레코드 Count 를 Output 으로 리턴함		
	SET @iTotalCount = (
						SELECT  count(*) 
						FROM dbo.VW_WORK_LIST 
						WHERE PARTICIPANT_ID = @strUserId 
							AND STATE = '7' 
							AND PROCESS_INSTANCE_VIEW_STATE = '7')

----------------------실제로 조회해야할 레코드 카운트 계산----------------------*
/* 
총 레코드 카운트가 이론적인 총 레코드 카운트(현재페이지*페이지사이즈)보다 작을때 
총 레코드 수에서 이전 페이지까지의 레코드 수를 빼서 나머지 필요한 레코드 카운트를 구한다.
*/

IF @iTotalCount < (@iNum1)
BEGIN
	SET @nSelectRecord = @iTotalCount - ( (@nCurPage - 1) * @nRowPerPage )
END

----------------------반환할 레코드 카운트가 1 미만인 경우----------------------
IF @nSelectRecord < 1
BEGIN
	SET @nSelectRecord = 0
	SET @iNum1 =0
END

	--[공통]---------------------------------------------------		
	-- 소팅컬럼의 값이 0이 넘어오면 기본값으로 정렬
	if @strSortColumn = '0'	
		Begin
			SET @strOrderBy = ' ORDER BY VIEW_COMPLETE_DATE DESC'
		end

	else
		begin
			SET @strOrderBy = ' ORDER BY '+@strSortColumn+' '+@strSortOrder+ ' , ITEMCREATE_DATE DESC'
		end

	-- 소팅컬럼의 값이 0이 넘어오면 기본값으로 정렬
	if @strSortColumn = '0'	
		Begin
			SET @strOrderByRevers = ' ORDER BY VIEW_COMPLETE_DATE ASC'
		end

	else
		begin
			SET @strSortOrderRevers =
			(
				CASE @strSortOrder
					WHEN 'ASC'		
							THEN	'DESC'
					WHEN 'DESC'	
							THEN	'ASC'				
				END 
			)	
			
			SET @strOrderByRevers = ' ORDER BY '+@strSortColumn+' '+@strSortOrderRevers+ ' , ITEMCREATE_DATE ASC'
		end	
	--[공통]---------------------------------------------------

	SET @sQuery =	
				'SELECT	
						a.ITEMOID,	
						a.IsUrgent,				 
						a.Status, 
						a.ISATTACHFILE, 
						a.PostScript, 
						a.CATEGORYNAME, 
						a.SUBJECT, 
						a.DOC_LEVEL, 
						a.CREATOR, 
						a.CREATOR_DEPT, 
						SUBSTRING(CONVERT(VARCHAR,a.VIEW_COMPLETE_DATE,21),0,20) as VIEW_COMPLETE_DATE,
						a.OPEN_YN,
						a.OID,
						a.Ref_Doc,
						a.ATTACH_EXTENSION,
						a.CREATOR_ID,
						a.DOC_NUMBER	
				FROM	(
						select top ' + CAST(@nSelectRecord AS VARCHAR) + ' * 
						from (
							select top ' + CAST(@iNum1 AS VARCHAR) + ' * 
							from dbo.VW_WORK_LIST 
							where Participant_id = '''+@strUserId+'''  
							AND STATE = ''7''  
							AND PROCESS_INSTANCE_VIEW_STATE = ''7''			
							' +@strOrderBy+ '
						) a
					' +@strOrderByRevers+ '
		   			) a
				' +@strOrderBy							
						
END

else if @strDFType = 'RE'

BEGIN
--반려함

	-- 전체 레코드 Count 를 Output 으로 리턴함
	SET @iTotalCount = (
			SELECT  count(*) 
			FROM dbo.VW_WORK_LIST 
			WHERE PARTICIPANT_ID = @strUserId 
				AND STATE = '7' 
				AND PROCESS_INSTANCE_VIEW_STATE = '8' 
				AND ITEMSTATE = '7'
			)



----------------------실제로 조회해야할 레코드 카운트 계산----------------------*
/* 
총 레코드 카운트가 이론적인 총 레코드 카운트(현재페이지*페이지사이즈)보다 작을때 
총 레코드 수에서 이전 페이지까지의 레코드 수를 빼서 나머지 필요한 레코드 카운트를 구한다.
*/

IF @iTotalCount < (@iNum1)
BEGIN
	SET @nSelectRecord = @iTotalCount - ( (@nCurPage - 1) * @nRowPerPage )
END

----------------------반환할 레코드 카운트가 1 미만인 경우----------------------
IF @nSelectRecord < 1
BEGIN
	SET @nSelectRecord = 0
	SET @iNum1 =0
END

	--[공통]---------------------------------------------------		
	-- 소팅컬럼의 값이 0이 넘어오면 기본값으로 정렬
	if @strSortColumn = '0'	
		Begin
			SET @strOrderBy = ' ORDER BY VIEW_COMPLETE_DATE DESC'
		end

	else
		begin
			SET @strOrderBy = ' ORDER BY '+@strSortColumn+' '+@strSortOrder+ ' , ITEMCREATE_DATE DESC'
		end

	-- 소팅컬럼의 값이 0이 넘어오면 기본값으로 정렬
	if @strSortColumn = '0'	
		Begin
			SET @strOrderByRevers = ' ORDER BY VIEW_COMPLETE_DATE ASC'
		end

	else
		begin
			SET @strSortOrderRevers =
			(
				CASE @strSortOrder
					WHEN 'ASC'		
							THEN	'DESC'
					WHEN 'DESC'	
							THEN	'ASC'				
				END 
			)	
			
			SET @strOrderByRevers = ' ORDER BY '+@strSortColumn+' '+@strSortOrderRevers+ ' , ITEMCREATE_DATE ASC'
		end	
	--[공통]---------------------------------------------------


	
	SET @sQuery =	
		'SELECT	 
			a.ITEMOID,	
			a.IsUrgent, 
			a.Status, 
			a.ISATTACHFILE, 
			a.PostScript, 
			a.CATEGORYNAME, 
			a.SUBJECT, 
			a.DOC_LEVEL, 
			a.CREATOR, 
			a.CREATOR_DEPT, 
			SUBSTRING(CONVERT(VARCHAR,a.VIEW_COMPLETE_DATE,21),0,20) as VIEW_COMPLETE_DATE,
			a.OPEN_YN,
			a.OID,
			a.Ref_Doc,
			a.ATTACH_EXTENSION,
			a.CREATOR_ID,
			a.DOC_NUMBER	
			
		FROM  (
			select top ' + CAST(@nSelectRecord AS VARCHAR) + ' * 
			from (
				select top ' + CAST(@iNum1 AS VARCHAR) + ' * 
				from dbo.VW_WORK_LIST 
				where Participant_id = '''+@strUserId+'''  
				AND STATE = ''7''  
				AND PROCESS_INSTANCE_VIEW_STATE = ''8''		
				AND ITEMSTATE = ''7''	
				' +@strOrderBy+ '
				) a
			' +@strOrderByRevers+ '
		   	) a
		' +@strOrderBy							


END

else if @strDFType = 'ST'
-- 임시보관함



BEGIN

	-- 소팅컬럼의 값이 0이 넘어오면 기본값으로 정렬
	if @strSortColumn = '0'	
		Begin
			SET @strOrderBy = ' ORDER BY CREATE_DATE DESC'
		end
	else
		begin
			SET @strOrderBy = ' ORDER BY '+@strSortColumn+' '+@strSortOrder
		end	
		
		

		SET @sQuery = 
		N'	SELECT  bb.PROCESS_ID,
					(SELECT Form_Name FROM dbo.WF_FORMS s WHERE s.FORM_ID = bb.FORM_ID) as FORM_ID,
					bb.USERID,
					bb.SUBJECT,
					bb.DEPTID,
					bb.DESCRIPTION,
					SUBSTRING(CONVERT(VARCHAR,bb.CREATE_DATE,21),0,20) as CREATE_DATE

			FROM 
				(	SELECT a.*  
					FROM 
						(
							SELECT top ' + CAST(@iNum1 AS VARCHAR) + ' Process_ID, CREATE_DATE
							FROM WF_FORM_STORAGE(NOLOCK)
							WHERE UserId = '''+@strUserId+'''
								AND DELETE_DATE = cast(''9999-12-31 00:00:00.000'' as datetime)
								'+@strOrderBy+'
						) a
						LEFT OUTER JOIN(
							SELECT Top ' + CAST(@iNum2 AS VARCHAR) + ' Process_ID, CREATE_DATE
							FROM WF_FORM_STORAGE(NOLOCK)
							WHERE UserID = '''+@strUserId+'''
								AND DELETE_DATE = cast(''9999-12-31 00:00:00.000'' as datetime)
								'+@strOrderBy+'
 						) b
						on a.Process_ID = b.Process_ID
						WHERE b.Process_ID Is null

				) aa 
			INNER join WF_FORM_STORAGE bb (nolock)  
			ON bb.PROCESS_ID = aa.PROCESS_ID  
			WHERE bb.DELETE_DATE = cast(''9999-12-31 00:00:00.000'' as datetime) '
			
			
			
    -- 전체 레코드 Count 를 Output 으로 리턴함
	SET @iTotalCount = (
				SELECT count(*)  
				FROM WF_FORM_STORAGE(NOLOCK) 
				WHERE DELETE_DATE = cast('9999-12-31 00:00:00.000' as datetime) 
				AND UserID =  CAST(@strUserId AS int)
	)


END


else if @strDFType = 'P'
	--업무협조함
BEGIN


    -- 전체 레코드 Count 를 Output 으로 리턴함
	SET @iTotalCount = (
			SELECT	count(*) 
			FROM dbo.VW_WORK_LIST 
			WHERE  PARTICIPANT_ID = @strUserDeptId+'_'+@strDFType	
				AND STATE = '7'	
				AND PROCESS_INSTANCE_VIEW_STATE = '3'
			)

----------------------실제로 조회해야할 레코드 카운트 계산----------------------*
/* 
총 레코드 카운트가 이론적인 총 레코드 카운트(현재페이지*페이지사이즈)보다 작을때 
총 레코드 수에서 이전 페이지까지의 레코드 수를 빼서 나머지 필요한 레코드 카운트를 구한다.
*/

IF @iTotalCount < (@iNum1)
BEGIN
	SET @nSelectRecord = @iTotalCount - ( (@nCurPage - 1) * @nRowPerPage )

END

----------------------반환할 레코드 카운트가 1 미만인 경우----------------------
IF @nSelectRecord < 1
BEGIN
	SET @nSelectRecord = 0
	SET @iNum1 =0
END




	-- 소팅컬럼의 값이 0이 넘어오면 기본값으로 정렬
	if @strSortColumn = '0'	
		Begin
			SET @strOrderBy = ' ORDER BY COMPLETED_DATE DESC'
		end
	else
		begin
			SET @strOrderBy = ' ORDER BY '+@strSortColumn+' '+@strSortOrder+' , ITEMCREATE_DATE DESC'
		end
		
		
		
	-------------------------------[공통]---------------------------------------------------
	-- 소팅컬럼의 값이 0이 넘어오면 기본값으로 정렬
	if @strSortColumn = '0'	
		Begin
			SET @strOrderByRevers = ' ORDER BY COMPLETED_DATE ASC'
		end
	else
		begin
			SET @strSortOrderRevers =
			(
				CASE @strSortOrder
					WHEN 'ASC'		
							THEN	'DESC'
					WHEN 'DESC'	
							THEN	'ASC'				
				END 
			)	
			
			SET @strOrderByRevers = ' ORDER BY '+@strSortColumn+' '+@strSortOrderRevers+ ' , ITEMCREATE_DATE ASC'
		end	
	-------------------------------[공통]---------------------------------------------------

		
	
	SET @sQuery =	
		'SELECT	 
			a.ITEMOID,	
			a.IsUrgent, 
			a.Status, 
			a.ISATTACHFILE, 
			a.PostScript, 
			a.CATEGORYNAME, 
			a.SUBJECT, 
			a.DOC_LEVEL, 
			a.CREATOR, 
			a.CREATOR_DEPT, 
			SUBSTRING(CONVERT(VARCHAR,a.COMPLETED_DATE,21),0,20) as COMPLETED_DATE,
			a.OPEN_YN,
			a.OID,
			a.Ref_Doc,
			a.ATTACH_EXTENSION,
			a.CREATOR_ID,
			a.DOC_NUMBER						
			
		FROM  (
			select top ' + CAST(@nSelectRecord AS VARCHAR) + ' * 
			from (
				select top ' + CAST(@iNum1 AS VARCHAR) + ' * 
				from dbo.VW_WORK_LIST 
				where Participant_id = '''+@strUserDeptId+'_'+@strDFType+''' 
				AND STATE = ''7''  
				AND PROCESS_INSTANCE_VIEW_STATE = ''3''		
				' +@strOrderBy+ '
				) a
			' +@strOrderByRevers+ '
		   	) a
		' +@strOrderBy							


END


else if @strDFType = 'S'
	--발신함
BEGIN


    -- 전체 레코드 Count 를 Output 으로 리턴함
	SET @iTotalCount = (
				SELECT	count(*) 
				FROM dbo.VW_WORK_LIST 
				WHERE  PARTICIPANT_ID = @strUserDeptId+'_'+@strDFType	
					AND STATE = '7'	
					AND PROCESS_INSTANCE_VIEW_STATE = '3')



----------------------실제로 조회해야할 레코드 카운트 계산----------------------*
/* 
총 레코드 카운트가 이론적인 총 레코드 카운트(현재페이지*페이지사이즈)보다 작을때 
총 레코드 수에서 이전 페이지까지의 레코드 수를 빼서 나머지 필요한 레코드 카운트를 구한다.
*/

IF @iTotalCount < (@iNum1)
BEGIN
	SET @nSelectRecord = @iTotalCount - ( (@nCurPage - 1) * @nRowPerPage )
END

----------------------반환할 레코드 카운트가 1 미만인 경우----------------------
IF @nSelectRecord < 1
BEGIN
	SET @nSelectRecord = 0
	SET @iNum1 =0
END


	-- 소팅컬럼의 값이 0이 넘어오면 기본값으로 정렬
	if @strSortColumn = '0'	
		Begin
			SET @strOrderBy = ' ORDER BY COMPLETED_DATE DESC'
		end
	else
		begin
			SET @strOrderBy = ' ORDER BY '+@strSortColumn+' '+@strSortOrder+' , ITEMCREATE_DATE DESC'
		end
		
		
		
	-------------------------------[공통]---------------------------------------------------
	-- 소팅컬럼의 값이 0이 넘어오면 기본값으로 정렬
	if @strSortColumn = '0'	
		Begin
			SET @strOrderByRevers = ' ORDER BY COMPLETED_DATE ASC'
		end
	else
		begin
			SET @strSortOrderRevers =
			(
				CASE @strSortOrder
					WHEN 'ASC'		
							THEN	'DESC'
					WHEN 'DESC'	
							THEN	'ASC'				
				END 
			)	
			
			SET @strOrderByRevers = ' ORDER BY '+@strSortColumn+' '+@strSortOrderRevers+ ' , ITEMCREATE_DATE ASC'
		end	
	-------------------------------[공통]---------------------------------------------------

	
	
	SET @sQuery =	
		'SELECT	 
			a.ITEMOID,	
			a.IsUrgent, 
			a.Status, 
			a.ISATTACHFILE, 
			a.PostScript, 
			a.CATEGORYNAME, 
			a.SUBJECT,  
			a.DOC_LEVEL, 
			a.CREATOR, 
			a.CREATOR_DEPT, 
			SUBSTRING(CONVERT(VARCHAR,a.COMPLETED_DATE,21),0,20) as COMPLETED_DATE,
			a.OPEN_YN,
			a.OID,
			a.Ref_Doc,
			a.ATTACH_EXTENSION,
			a.CREATOR_ID,
			a.DOC_NUMBER	
					
			
		FROM  (
			select top ' + CAST(@nSelectRecord AS VARCHAR) + ' * 

			from (
				select top ' + CAST(@iNum1 AS VARCHAR) + ' * 
				from dbo.VW_WORK_LIST 

				where Participant_id = '''+@strUserDeptId+'_'+@strDFType+''' 
				AND STATE = ''7''  
				AND PROCESS_INSTANCE_VIEW_STATE = ''3''		
				' +@strOrderBy+ '
				) a
			' +@strOrderByRevers+ '
		   	) a
		' +@strOrderBy							

			

END

else if @strDFType = 'A'
	--	
BEGIN



    -- 전체 레코드 Count 를 Output 으로 리턴함
	SET @iTotalCount = (
			SELECT	count(*) 
			FROM dbo.VW_WORK_LIST 
			WHERE  PARTICIPANT_ID = @strUserDeptId+'_'+@strDFType	
				AND STATE = '7'	
				AND PROCESS_INSTANCE_VIEW_STATE = '3'
		)



----------------------실제로 조회해야할 레코드 카운트 계산----------------------*
/* 
총 레코드 카운트가 이론적인 총 레코드 카운트(현재페이지*페이지사이즈)보다 작을때 
총 레코드 수에서 이전 페이지까지의 레코드 수를 빼서 나머지 필요한 레코드 카운트를 구한다.
*/

IF @iTotalCount < (@iNum1)
BEGIN
	SET @nSelectRecord = @iTotalCount - ( (@nCurPage - 1) * @nRowPerPage )
END

----------------------반환할 레코드 카운트가 1 미만인 경우----------------------
IF @nSelectRecord < 1
BEGIN
	SET @nSelectRecord = 0
	SET @iNum1 =0
END

	-- 소팅컬럼의 값이 0이 넘어오면 기본값으로 정렬
	if @strSortColumn = '0'	
		Begin
			SET @strOrderBy = ' ORDER BY COMPLETED_DATE DESC'
		end
	else
		begin
			SET @strOrderBy = ' ORDER BY '+@strSortColumn+' '+@strSortOrder+' , ITEMCREATE_DATE DESC'
		end
		
		
		
	-------------------------------[공통]---------------------------------------------------
	-- 소팅컬럼의 값이 0이 넘어오면 기본값으로 정렬
	if @strSortColumn = '0'	
		Begin
			SET @strOrderByRevers = ' ORDER BY COMPLETED_DATE ASC'
		end
	else
		begin
			SET @strSortOrderRevers =
			(
				CASE @strSortOrder
					WHEN 'ASC'		
							THEN	'DESC'
					WHEN 'DESC'	
							THEN	'ASC'				
				END 
			)	
			
			SET @strOrderByRevers = ' ORDER BY '+@strSortColumn+' '+@strSortOrderRevers+ ' , ITEMCREATE_DATE ASC'
		end	
	-------------------------------[공통]---------------------------------------------------

	
	
	SET @sQuery =	'SELECT	 
			a.ITEMOID,	
			a.IsUrgent, 
			a.Status, 
			a.ISATTACHFILE, 
			a.PostScript, 
			a.CATEGORYNAME, 
			a.SUBJECT,  
			a.DOC_LEVEL, 
			a.CREATOR, 
			a.CREATOR_DEPT, 
			SUBSTRING(CONVERT(VARCHAR,a.COMPLETED_DATE,21),0,20) as COMPLETED_DATE,
			a.OPEN_YN,
			a.OID,
			a.Ref_Doc,
			a.ATTACH_EXTENSION,
			a.CREATOR_ID,
			a.DOC_NUMBER	
			
			
		FROM  (
			select top ' + CAST(@nSelectRecord AS VARCHAR) + ' * 
			from (
				select top ' + CAST(@iNum1 AS VARCHAR) + ' * 
				from dbo.VW_WORK_LIST 
				where Participant_id = '''+@strUserDeptId+'_'+@strDFType+''' 
				AND STATE = ''7''  
				AND PROCESS_INSTANCE_VIEW_STATE = ''3''		
				' +@strOrderBy+ '
				) a
			' +@strOrderByRevers+ '
		   	) a
		' +@strOrderBy							

END

else if @strDFType = 'R' or @strDFType = 'K'
	--수신함
BEGIN

 -- 전체 레코드 Count 를 Output 으로 리턴함
	SET @iTotalCount = (
			SELECT	count(*) 
			FROM dbo.VW_WORK_LIST 
			WHERE  PARTICIPANT_ID = @strUserDeptId+'_'+@strDFType	
				AND STATE = '2'	
				AND PROCESS_INSTANCE_VIEW_STATE = '3')

----------------------실제로 조회해야할 레코드 카운트 계산----------------------*
/* 
총 레코드 카운트가 이론적인 총 레코드 카운트(현재페이지*페이지사이즈)보다 작을때 
총 레코드 수에서 이전 페이지까지의 레코드 수를 빼서 나머지 필요한 레코드 카운트를 구한다.
*/

IF @iTotalCount < (@iNum1)
BEGIN
	SET @nSelectRecord = @iTotalCount - ( (@nCurPage - 1) * @nRowPerPage )
END

----------------------반환할 레코드 카운트가 1 미만인 경우----------------------
IF @nSelectRecord < 1
BEGIN
	SET @nSelectRecord = 0
	SET @iNum1 =0
END

	-- 소팅컬럼의 값이 0이 넘어오면 기본값으로 정렬
	if @strSortColumn = '0'	
		Begin
			SET @strOrderBy = ' ORDER BY CREATE_DATE DESC'
		end
	else
		begin
			SET @strOrderBy = ' ORDER BY '+@strSortColumn+' '+@strSortOrder+' , ITEMCREATE_DATE DESC'
		end

	-------------------------------[공통]---------------------------------------------------
	-- 소팅컬럼의 값이 0이 넘어오면 기본값으로 정렬
	if @strSortColumn = '0'	
		Begin
			SET @strOrderByRevers = ' ORDER BY CREATE_DATE ASC'
		end
	Else
		begin
			SET @strSortOrderRevers =
			(
				CASE @strSortOrder
					WHEN 'ASC'		
							THEN	'DESC'
					WHEN 'DESC'	
							THEN	'ASC'				
				END 
			)	
			
			SET @strOrderByRevers = ' ORDER BY '+@strSortColumn+' '+@strSortOrderRevers+ ' , ITEMCREATE_DATE ASC'
		end	

	-------------------------------[공통]---------------------------------------------------
	SET @sQuery =	'SELECT	 
			a.ITEMOID,	 	
			a.IsUrgent, 
			a.Status, 
			a.ISATTACHFILE, 
			a.PostScript, 
			a.CATEGORYNAME, 
			a.SUBJECT,  
			a.DOC_LEVEL, 
			a.CREATOR, 
			a.CREATOR_DEPT, 
			SUBSTRING(CONVERT(VARCHAR,a.CREATE_DATE,21),0,20) as CREATE_DATE,
			a.OPEN_YN,
			a.OID,
			a.Ref_Doc,
			a.ATTACH_EXTENSION,
			a.CREATOR_ID,
			a.DOC_NUMBER	
					
			
		FROM  (
			select top ' + CAST(@nSelectRecord AS VARCHAR) + ' * 
			from (
				select top ' + CAST(@iNum1 AS VARCHAR) + ' * 
				from dbo.VW_WORK_LIST 
				where Participant_id = '''+@strUserDeptId+'_'+@strDFType+''' 
				AND STATE = ''2''  
				AND PROCESS_INSTANCE_VIEW_STATE = ''3''		
				' +@strOrderBy+ '
				) a
			' +@strOrderByRevers+ '
		   	) a
		' +@strOrderBy							

End
Else If	@strDFType = 'PA'	--예결함
Begin

	-- 임원그룹에 포함이 되었을 경우 --> 없는 데이터 테이블을 날린다.
	IF	1 = (
			Select	1
			From	eManage.dbo.TB_Group_User
			Where	GroupID = '10000'
				and	UserID = @strUserId
		)
	BEGIN

			-- 전체 레코드 Count 를 Output 으로 리턴함
			SET @iTotalCount = (
					SELECT count(*)
					FROM dbo.VW_PR_LIST(nolock)
					where USER_ID = @strUserId	--해당 사용자
					AND ACTION_TYPE = '3'  		--예결함조건			
					AND SIGN_TYPE != '03' --2006.07.13 임상록 결재종류 추가 --'결재안함'이 아닐때
					)
			
			----------------------실제로 조회해야할 레코드 카운트 계산----------------------*
			IF @iTotalCount < (@iNum1)
			BEGIN
				SET @nSelectRecord = @iTotalCount - ( (@nCurPage - 1) * @nRowPerPage )
			END
			
			----------------------반환할 레코드 카운트가 1 미만인 경우----------------------
			IF @nSelectRecord < 1
			BEGIN
				SET @nSelectRecord = 0
				SET @iNum1 =0
			END

				-- 소팅컬럼의 값이 0이 넘어오면 기본값으로 정렬
				if @strSortColumn = '0'	
					Begin
						SET @strOrderBy = ' ORDER BY CREATE_DATE DESC'
					end
			
				else if @strSortColumn = 'CREATE_DATE'	
					begin
						SET @strOrderBy = ' ORDER BY '+@strSortColumn+' '+@strSortOrder
					end
				
				else
					begin
						SET @strOrderBy = ' ORDER BY '+@strSortColumn+' '+@strSortOrder+' , CREATE_DATE DESC'
					end

				-------------------------------[공통]---------------------------------------------------
				-- 소팅컬럼의 값이 0이 넘어오면 기본값으로 정렬
				If	@strSortColumn = '0'	
					Begin
						Set	@strOrderByRevers = ' ORDER BY CREATE_DATE ASC'
					End
				Else
					Begin
						Set	@strSortOrderRevers =
						(
							CASE @strSortOrder
								WHEN 'ASC'		
										THEN	'DESC'
								WHEN 'DESC'	
										THEN	'ASC'				
							END 
						)	
						
						if @strSortColumn = 'CREATE_DATE'
						   BEGIN	
							SET @strOrderByRevers = ' ORDER BY '+@strSortColumn+' '+@strSortOrderRevers
						   END
						else
						   BEGIN	
							SET @strOrderByRevers = ' ORDER BY '+@strSortColumn+' '+@strSortOrderRevers+ ' , CREATE_DATE ASC'
						   END
			
					end	
				-------------------------------[공통]---------------------------------------------------

				SET @sQuery =	'SELECT	 
						a.ITEMOID,	 	
						a.ISURGENT, 
						a.STATUS, 
						a.ISATTACHFILE, 
						a.POSTSCRIPT, 
						a.CATEGORYNAME, 
						a.SUBJECT,  
						a.DOC_LEVEL, 
						a.CREATOR, 
						a.CREATOR_DEPT, 
						SUBSTRING(CONVERT(VARCHAR,a.CREATE_DATE,21),0,20) as CREATE_DATE,
						'''' as OPEN_YN,
						'''' as OID,
						a.REF_DOC,
						a.ATTACH_EXTENSION,
						a.CREATOR_ID,
						a.DOC_NUMBER						
						
					FROM  (
						select top ' + CAST(@nSelectRecord AS VARCHAR) + ' * 
						from (
							select top ' + CAST(@iNum1 AS VARCHAR) + ' * 
							from dbo.VW_PR_LIST(nolock)
							where USER_ID = '''+@strUserId+''' 
							AND ACTION_TYPE = ''3''
							AND SIGN_TYPE != ''03''  

							' +@strOrderBy+ '
							) a
						where USER_ID = '''+@strUserId+'''
						' +@strOrderByRevers+ '
					   	) a
					where USER_ID = '''+@strUserId+'''
					' +@strOrderBy		

	END
	ELSE --임원그룹에 포함 안되었을 때 
	BEGIN
			-- 전체 레코드 Count 를 Output 으로 리턴함
			SET @iTotalCount = (
					SELECT count(*)
					FROM dbo.VW_PR_LIST(nolock)
					where USER_ID = @strUserId	--해당 사용자
					AND ACTION_TYPE = '2'  		--예결함조건			
					AND SIGN_TYPE != '03' --2006.07.13 임상록 결재종류 추가 --'결재안함'이 아닐때
					)
			
			----------------------실제로 조회해야할 레코드 카운트 계산----------------------*
			IF @iTotalCount < (@iNum1)
			BEGIN
				SET @nSelectRecord = @iTotalCount - ( (@nCurPage - 1) * @nRowPerPage )
			END

			----------------------반환할 레코드 카운트가 1 미만인 경우----------------------
			IF @nSelectRecord < 1
			BEGIN
				SET @nSelectRecord = 0
				SET @iNum1 =0
			END

				-- 소팅컬럼의 값이 0이 넘어오면 기본값으로 정렬
				if @strSortColumn = '0'	
					Begin
						SET @strOrderBy = ' ORDER BY CREATE_DATE DESC'
					end
			
				else if @strSortColumn = 'CREATE_DATE'	
					begin
						SET @strOrderBy = ' ORDER BY '+@strSortColumn+' '+@strSortOrder
					end
				
				else
					begin
						SET @strOrderBy = ' ORDER BY '+@strSortColumn+' '+@strSortOrder+' , CREATE_DATE DESC'
					end

				-------------------------------[공통]---------------------------------------------------
				-- 소팅컬럼의 값이 0이 넘어오면 기본값으로 정렬
				if @strSortColumn = '0'	
					Begin
						SET @strOrderByRevers = ' ORDER BY CREATE_DATE ASC'
					end
			
				else
					begin
						SET @strSortOrderRevers =
						(
							CASE @strSortOrder
								WHEN 'ASC'		
										THEN	'DESC'
								WHEN 'DESC'	
										THEN	'ASC'				
							END 
						)	
						
						if @strSortColumn = 'CREATE_DATE'
						   BEGIN	
							SET @strOrderByRevers = ' ORDER BY '+@strSortColumn+' '+@strSortOrderRevers
						   END
						else
						   BEGIN	
							SET @strOrderByRevers = ' ORDER BY '+@strSortColumn+' '+@strSortOrderRevers+ ' , CREATE_DATE ASC'
						   END
			
					end	

				-------------------------------[공통]---------------------------------------------------
				SET @sQuery =	'SELECT	 
						a.ITEMOID,	 	
						a.ISURGENT, 
						a.STATUS, 
						a.ISATTACHFILE, 
						a.POSTSCRIPT, 
						a.CATEGORYNAME, 
						a.SUBJECT,  
						a.DOC_LEVEL, 
						a.CREATOR, 
						a.CREATOR_DEPT, 
						SUBSTRING(CONVERT(VARCHAR,a.CREATE_DATE,21),0,20) as CREATE_DATE,
						'''' as OPEN_YN,
						'''' as OID,
						a.REF_DOC,
						a.ATTACH_EXTENSION,
						a.CREATOR_ID,
						a.DOC_NUMBER						
						
					FROM  (
						select top ' + CAST(@nSelectRecord AS VARCHAR) + ' * 
						from (
							select top ' + CAST(@iNum1 AS VARCHAR) + ' * 
							from dbo.VW_PR_LIST(nolock)
							where USER_ID = '''+@strUserId+''' 
							AND ACTION_TYPE = ''2''
							AND SIGN_TYPE != ''03''  
							' +@strOrderBy+ '
							) a
						where USER_ID = '''+@strUserId+'''
						' +@strOrderByRevers+ '
					   	) a
					where USER_ID = '''+@strUserId+'''
					' +@strOrderBy		

	END	

End
Else If	@strDFType = 'RF'	--	회람문서함
Begin

	Declare	@wFormID	varchar(33),
			@CreateDate	datetime
	
	Select	@sQuery = '',
			@CreateDate	= ''

--	Drop	Table	#List
	Create	Table	#List
	(
		ProcessID					char(33),
		Process_Instance_View_State	char(33)
	)

	While (1 = 1)
	Begin
	
		Select	Top 1
				@wFormID	= f.Form_ID,
				@CreateDate	= f.Create_Date
		From	eWFForm.dbo.WF_Forms f
		Where	f.Current_Forms = 'Y'
			and	f.Create_Date > @CreateDate
		Order by f.Create_Date

		If	@@RowCount = 0	Break

		Set	@sQuery = "
			Insert	Into #List
				Select	Process_ID, Process_Instance_State
				From	eWFForm.dbo.Form_" + @wFormID + "
				Where	Referencer_Code like '%" + Convert(char(6), @strUserId) + "%'
			"

		print @sQuery
		Exec (@sQuery)
	End

	/*----------------------실제로 조회해야할 레코드 카운트 계산----------------------
	총 레코드 카운트가 이론적인 총 레코드 카운트(현재페이지*페이지사이즈)보다 작을때 
	총 레코드 수에서 이전 페이지까지의 레코드 수를 빼서 나머지 필요한 레코드 카운트를 구한다.
	*/

	IF	@iTotalCount < (@iNum1)
	BEGIN
		SET @nSelectRecord = @iTotalCount - ((@nCurPage - 1) * @nRowPerPage)
	END

	----------------------반환할 레코드 카운트가 1 미만인 경우----------------------
	IF @nSelectRecord < 1
	BEGIN
		SET @nSelectRecord = 0
		SET @iNum1 =0
	END

	-- 소팅컬럼의 값이 0이 넘어오면 기본값으로 정렬
	IF	@strSortColumn = '0' or @strSortColumn = '12'
	BEGIN
		SET	@strOrderBy = ' Order By Create_Date ' + @strSortOrder
	END
	ELSE
	BEGIN
		Set	@strOrderBy = ' Order By ' + @strSortColumn + ' ' + @strSortOrder

		IF	@strSortColumn <> '12'
			SET	@strOrderBy = @strOrderBy + ', Create_Date ' + @strSortOrder
	END

	-------------------------------[공통]---------------------------------------------------
	SET	@strSortOrderRevers =
		(
			Case	@strSortOrder
				When	'ASC'		
						Then	'DESC'
				When	'DESC'	
						Then	'ASC'				
			End
		)

	-- 소팅컬럼의 값이 0이 넘어오면 기본값으로 정렬
	IF	@strSortColumn = '0' or @strSortColumn = '12'
	BEGIN
		SET	@strOrderByRevers = ' Order By Create_Date ' + @strSortOrderRevers
	END
	ELSE
	BEGIN
		SET	@strOrderByRevers = ' Order By ' + @strSortColumn + ' ' + @strSortOrderRevers
		SET	@strOrderByRevers = @strOrderByRevers + ', Create_Date ' + @strSortOrderRevers
	End	

	Set	@sQuery	= "
		Select	Count(*)
		From	#List l
				Join	eWF.dbo.Process_Instance p (nolock)
					On	p.Oid = l.ProcessID
				Join	eWFForm.dbo.Wf_Forms_Prop f (nolock)
					On	f.Process_ID = l.ProcessID
		"

	CREATE	TABLE	#tTotalCount
	(
		nTotalCount	int
	)

	INSERT	INTO	#tTotalCount
		EXEC	(@sQuery)

	SELECT	@iTotalCount = nTotalCount
	FROM	#tTotalCount

	DROP	TABLE	#tTotalCount

	Set	@sQuery	= "
		Select	ITEMOID, 	Referencer_Confirm_YN,	ISURGENT,			STATUS,	ISATTACHFILE,	POSTSCRIPT,	CATEGORYNAME,	SUBJECT,
				Case
					When	Process_Instance_View_State	in ('1', '3')	Then
						'진행'
					When	Process_Instance_View_State	in ('7')	Then
						'완료'
					When	Process_Instance_View_State	in ('8')	Then
						'반려'
					ELSE	''
				End	State,
				CREATOR, 	CREATOR_DEPT,
		 		SUBSTRING(CONVERT(VARCHAR(20), CREATE_DATE, 21), 3, 14)		AS CREATE_DATE,
		 		SUBSTRING(CONVERT(VARCHAR(20), COMPLETED_DATE, 21), 3, 14)	AS COMPLETED_DATE,
			 	OPEN_YN,	OID,	REF_DOC,	ATTACH_EXTENSION,	CREATOR_ID,	DOC_NUMBER	--	,	
		From	(
				Select	Top " + CAST(@nSelectRecord AS VARCHAR) + " *
				From	(
						Select	Top " + CAST(@iNum1 AS VARCHAR) + "
								p.OID as ITEMOID,
								CASE
									WHEN	C.Process_Instance_OID IS NULL	THEN	''
									ELSE	'확인'
								END	Referencer_Confirm_YN,
								f.ISURGENT,
								f.STATUS,
								f.ISATTACHFILE,
								f.POSTSCRIPT,
								f.DOC_NAME as CATEGORYNAME,
								f.SUBJECT,
								f.DOC_LEVEL,
								p.CREATOR, 
								p.CREATOR_DEPT, 
								p.CREATE_DATE,
								p.COMPLETED_DATE,
								'N'	as OPEN_YN,
								p.OID	as OID,
								f.REF_DOC,
								f.ATTACH_EXTENSION,
								p.CREATOR_ID,
								f.DOC_NUMBER,
								l.Process_Instance_View_State
						From	#List l
								Join	eWF.dbo.Process_Instance p (nolock)
									On	p.Oid = l.ProcessID
								Join	eWFForm.dbo.Wf_Forms_Prop f (nolock)
									On	f.Process_ID = l.ProcessID
								LEFT OUTER JOIN	eWFForm.dbo.WF_Referencer_Confirm C (NOLOCK)
									ON	C.Process_Instance_OID = l.ProcessID
						" + @strOrderBy
					+  ") a
				" + @strOrderByRevers
			+  ") a
		" + @strOrderBy

End
Else
Begin

    -- 전체 레코드 Count 를 Output 으로 리턴함
	SET @iTotalCount = (
			SELECT	count(*) 
			FROM dbo.VW_WORK_LIST 
			WHERE  PARTICIPANT_ID = @strUserDeptId+'_'+@strDFType	
				AND STATE = '7'	
				AND PROCESS_INSTANCE_VIEW_STATE = '3')

	----------------------실제로 조회해야할 레코드 카운트 계산----------------------*
	IF @iTotalCount < (@iNum1)
	BEGIN
		SET @nSelectRecord = @iTotalCount - ( (@nCurPage - 1) * @nRowPerPage )
	END

	----------------------반환할 레코드 카운트가 1 미만인 경우----------------------
	IF @nSelectRecord < 1
	BEGIN
		SET @nSelectRecord = 0
		SET @iNum1 =0
	END

	-- 소팅컬럼의 값이 0이 넘어오면 기본값으로 정렬
	if @strSortColumn = '0'	
		Begin
			SET @strOrderBy = ' ORDER BY COMPLETED_DATE DESC'
		end
	else if @strSortColumn = 'COMPLETED_DATE'
		Begin
			SET @strOrderBy = ' ORDER BY '+@strSortColumn+' '+@strSortOrder
		End		
	else
		begin
			SET @strOrderBy = ' ORDER BY '+@strSortColumn+' '+@strSortOrder+' , COMPLETED_DATE DESC'
		end

	-------------------------------[공통]---------------------------------------------------
	-- 소팅컬럼의 값이 0이 넘어오면 기본값으로 정렬
	if @strSortColumn = '0'	
		Begin
			SET @strOrderByRevers = ' ORDER BY COMPLETED_DATE ASC'
		end
	else if @strSortColumn = 'COMPLETED_DATE'
		Begin
			SET @strOrderByRevers = ' '
		End		
	else
		begin
			SET @strSortOrderRevers =
			(
				CASE @strSortOrder
					WHEN 'ASC'		
							THEN	'DESC'
					WHEN 'DESC'	
							THEN	'ASC'				
				END 
			)	

			SET @strOrderByRevers = ' ORDER BY '+@strSortColumn+' '+@strSortOrderRevers+ ' , COMPLETED_DATE ASC'
		end	
	-------------------------------[공통]---------------------------------------------------

	SET @sQuery =	
		'SELECT	 
			a.ITEMOID,	
			a.IsUrgent, 
			a.Status, 
			a.ISATTACHFILE, 
			a.PostScript, 
			a.CATEGORYNAME, 
			a.SUBJECT, 
			a.DOC_LEVEL, 
			a.CREATOR, 
			a.CREATOR_DEPT, 
			SUBSTRING(CONVERT(VARCHAR,a.COMPLETED_DATE,21),0,20) as COMPLETED_DATE,
			a.OPEN_YN,
			a.OID,
			a.Ref_Doc,
			a.ATTACH_EXTENSION,
			a.CREATOR_ID,
			a.DOC_NUMBER	
			
			
		FROM  (
			select top ' + CAST(@nSelectRecord AS VARCHAR) + ' * 
			from (
				select top ' + CAST(@iNum1 AS VARCHAR) + ' * 
				from dbo.VW_WORK_LIST 
				where Participant_id = '''+@strUserDeptId+'_'+@strDFType+''' 
				AND STATE = ''7''  
				AND PROCESS_INSTANCE_VIEW_STATE = ''3''		
				' +@strOrderBy+ '
				) a
			' +@strOrderByRevers+ '
		   	) a
		' +@strOrderBy							

END

print @sQuery
Exec (@sQuery)


RETURN









GO
/****** Object:  StoredProcedure [dbo].[UP_LIST_VW_WORKLIST_DOCUMENTLIST_TEST]    Script Date: 2015-10-15 오후 1:30:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO









-- declare @P1 int
-- set @P1=202
-- exec dbo.UP_LIST_VW_WORKLIST_DOCUMENTLIST_TEST @strUserId = '111459', @strUserDeptId = '2739', @strDFType = 'RE', @nCurPage = 1, @nRowPerPage = 30, @strSortColumn = '0', @strSortOrder = 'ASC', @iTotalCount = @P1 output
-- select @P1
-- 









CREATE	PROCEDURE [dbo].[UP_LIST_VW_WORKLIST_DOCUMENTLIST_TEST]

		-- 사용자ID,사용자부서ID,결재함종류,현재페이지,블록(페이지)당표시건수,정렬필드,정렬방법,전체결재건수(Output)
		@strUserId varchar(10),
		@strUserDeptId varchar(20),
		@strDFType varchar(5),
		@nCurPage int, 
		@nRowPerPage int,
		@strSortColumn varchar(20),
		@strSortOrder varchar(5),
		@iTotalCount int output
AS


----------------------------------------------------------------------
----------------------------------------------------------------------
-- 작성자: 마성옥
-- 작성일: 2004.03.10
-- 수정일: 2004.07.02
-- 설  명: 각 결재함 리스트 쿼리
-- 테스트: 
/*


48	이영호	마케팅 이사님
47	여명재	중앙연구소 상무님
1	김태환	상품개발실장
2	나한채	상품개발1담당
9	신중희	유통지원실장
41	박윤기	마케팅전략팀장
7	박헌영	디자인팀
3	김종근	상품개발1담당
4	정원희	상품개발1담당
5	김태선	상품개발2담당
6	신보수	상품개발3담당
8	허지원	디자인팀
10	김영삼	신유통2팀장
11	최종환	신유통2팀
12	장서원	신유통2팀
13	박민기	신유통2팀
14	유동근	신유통2팀
15	윤제웅	신유통2팀
16	송현철	신유통2팀
17	강창석	신유통2팀
18	서인환	KA팀장
19	임승석	KA팀
20	김성진	내자팀
21	전동남	외자팀
22	김윤정	전산실 생산물류담당
23	류형구	회계팀
24	남상현	회계팀
25	정연천	물류담당
26	이동광	물류담당
27	한태성	생산관리팀
28	정찬우	외주관리팀
29	김형수	외주관리팀
30	이택희	외주관리팀
31	이두현	외주관리팀
32	류승무	품질관리팀
33	김영호	품질관리팀
34	서한솔	품질관리팀
35	김준영	중앙연구소 커피담당
36	최태근	상품개발1담당
37	임석희	법무팀
38	김민국	법무팀
39	이양수	프로모션담당
40	김종승	프로모션담당
42	이현준	마케팅전략팀
43	송인욱	광고팀장
44	권선인	광고팀
45	임근탁	광고팀
46	김자원	광고팀
49	김유근	여성음료TFT
50	서수현	중앙연구소
51	이승민	중앙연구소
52	이예나	여성음료TFT

select	mailserver, *
from	emanage.dbo.vw_user
where	username = '이예나'
	and	enddate > getdate()


-- 사용자ID,사용자부서ID,결재함종류,현재페이지,블록(페이지)당표시건수,정렬필드,정렬방법,전체결재건수(Output)
select * from emanage.dbo.tb_user(nolock) where username = '신철호'
--10007
select * from emanage.dbo.tb_dept_user where userid = '10007'

DECLARE @총건수 int 
--EXEC  UP_LIST_VW_WORKLIST_DOCUMENTLIST '10067','10007','ST',1,10,'0','',@iTotalCount=@총건수 output
--예결함
EXEC  UP_LIST_VW_WORKLIST_DOCUMENTLIST '10007','10007','A',1,10,'CREATE_DATE','ASC',@iTotalCount=@총건수 output

*/
----------------------------------------------------------------------

DECLARE @iNum1 INT
DECLARE @iNum2 INT
DECLARE @sQuery VARCHAR(1500)
DECLARE @strOrderBy VARCHAR(100)
DECLARE @strOrderByRevers VARCHAR(100)
DECLARE @strSortOrderRevers CHAR(4)
DECLARE @nUserId INT
DECLARE @nSelectRecord INT		-- 실제로 반환할 레코드 수

SET @iNum1 = @nCurPage * @nRowPerPage
SET @iNum2 = (@nCurPage-1) * @nRowPerPage
SET @nSelectRecord = @nRowPerPage



if @strDFType = 'AP'

BEGIN
	--결재함 

	-- 전체 레코드 Count 를 Output 으로 리턴함
	SET @iTotalCount = 
					(	SELECT count(*) 
						FROM dbo.VW_WORK_LIST 
						WHERE PARTICIPANT_ID = @strUserId 
							AND STATE = '2' 
							AND PROCESS_INSTANCE_VIEW_STATE = '3' 
							AND ITEMSTATE = '1'	)

	----------------------실제로 조회해야할 레코드 카운트 계산----------------------*
	/* 
	총 레코드 카운트가 이론적인 총 레코드 카운트(현재페이지*페이지사이즈)보다 작을때 
	총 레코드 수에서 이전 페이지까지의 레코드 수를 빼서 나머지 필요한 레코드 카운트를 구한다.
	*/

	IF @iTotalCount < (@iNum1)
	BEGIN
		SET @nSelectRecord = @iTotalCount - ( (@nCurPage - 1) * @nRowPerPage )
	END

	----------------------반환할 레코드 카운트가 1 미만인 경우----------------------
	IF @nSelectRecord < 1
	BEGIN
		SET @nSelectRecord = 0
		SET @iNum1 =0
	END



	-- 소팅컬럼의 값이 0이 넘어오면 기본값으로 정렬
	if @strSortColumn = '0'	
		Begin
			SET @strOrderBy = ' ORDER BY CREATE_DATE DESC'
		end

	else
		begin
			SET @strOrderBy = ' ORDER BY '+@strSortColumn+' '+@strSortOrder+ ' , ITEMCREATE_DATE DESC'
		end
		
		
		
	-------------------------------[공통]---------------------------------------------------
	-- 소팅컬럼의 값이 0이 넘어오면 기본값으로 정렬
	if @strSortColumn = '0'	
		Begin
			SET @strOrderByRevers = ' ORDER BY CREATE_DATE ASC'
		end

	else
		begin
			SET @strSortOrderRevers =
			(
				CASE @strSortOrder
					WHEN 'ASC'		
							THEN	'DESC'
					WHEN 'DESC'	
							THEN	'ASC'				
				END 
			)	
			
			SET @strOrderByRevers = ' ORDER BY '+@strSortColumn+' '+@strSortOrderRevers+ ' , ITEMCREATE_DATE ASC'
		end	
	-------------------------------[공통]---------------------------------------------------		

	SET @sQuery =	
				'SELECT 
					a.ITEMOID,
					a.IsUrgent, 
					a.Status, 
					a.ISATTACHFILE, 
					a.PostScript, 
					a.CATEGORYNAME, 
					a.SUBJECT, 
					a.DOC_LEVEL, 
					a.CREATOR, 
					a.CREATOR_DEPT, 
					SUBSTRING(CONVERT(varchar,a.CREATE_DATE,21),0,20) as CREATE_DATE,					
					a.OPEN_YN,
					a.OID,
					a.Ref_Doc,
					a.ATTACH_EXTENSION,
					a.CREATOR_ID,
					a.DOC_NUMBER				

				FROM  (
					select top ' + CAST(@nSelectRecord AS VARCHAR) + ' * 
					from (
						select top ' + CAST(@iNum1 AS VARCHAR) + ' * 
						from dbo.VW_WORK_LIST 
						where Participant_id = '''+@strUserId+'''  
						AND STATE = ''2''  
						AND PROCESS_INSTANCE_VIEW_STATE = ''3''			
						AND ITEMSTATE = ''1''
						' +@strOrderBy+ '
						) a
					' +@strOrderByRevers+ '
		   			) a
				' +@strOrderBy
	

END

else if @strDFType = 'AF'

BEGIN
	--후결함 


    -- 전체 레코드 Count 를 Output 으로 리턴함
	SET @iTotalCount = 
					(	SELECT count(*) 
						FROM dbo.VW_WORK_LIST 
						WHERE PARTICIPANT_ID = @strUserId 
							AND STATE = '2' 
							AND PROCESS_INSTANCE_VIEW_STATE = '9' 
							AND ITEMSTATE = '1'	)


	----------------------실제로 조회해야할 레코드 카운트 계산----------------------*
	/* 
	총 레코드 카운트가 이론적인 총 레코드 카운트(현재페이지*페이지사이즈)보다 작을때 
	총 레코드 수에서 이전 페이지까지의 레코드 수를 빼서 나머지 필요한 레코드 카운트를 구한다.
	*/

	IF @iTotalCount < (@iNum1)
	BEGIN
		SET @nSelectRecord = @iTotalCount - ( (@nCurPage - 1) * @nRowPerPage )
	END

	----------------------반환할 레코드 카운트가 1 미만인 경우----------------------
	IF @nSelectRecord < 1
	BEGIN
		SET @nSelectRecord = 0
		SET @iNum1 =0
	END


	-- 소팅컬럼의 값이 0이 넘어오면 기본값으로 정렬
	if @strSortColumn = '0'	
		Begin
			SET @strOrderBy = ' ORDER BY CREATE_DATE DESC'
		end
	else
		begin
			SET @strOrderBy = ' ORDER BY '+@strSortColumn+' '+@strSortOrder+ ' , ITEMCREATE_DATE DESC'
		end
		
		
		
	-------------------------------[공통]---------------------------------------------------
	-- 소팅컬럼의 값이 0이 넘어오면 기본값으로 정렬
	if @strSortColumn = '0'	
		Begin
			SET @strOrderByRevers = ' ORDER BY CREATE_DATE ASC'
		end
	else
		begin
			SET @strSortOrderRevers =
			(
				CASE @strSortOrder
					WHEN 'ASC'		
							THEN	'DESC'
					WHEN 'DESC'	
							THEN	'ASC'				
				END 
			)	
			
			SET @strOrderByRevers = ' ORDER BY '+@strSortColumn+' '+@strSortOrderRevers+ ' , ITEMCREATE_DATE ASC'
		end	
	-------------------------------[공통]---------------------------------------------------	


	SET @sQuery =	
				'SELECT	 
					a.ITEMOID,				
					a.IsUrgent, 
					a.Status, 
					a.ISATTACHFILE, 
					a.PostScript, 
					a.CATEGORYNAME, 
					a.SUBJECT, 					
					a.DOC_LEVEL, 
					a.CREATOR, 
					a.CREATOR_DEPT, 
					SUBSTRING(CONVERT(varchar,a.CREATE_DATE,21),0,20) as CREATE_DATE,					
					a.OPEN_YN,
					a.OID,
					a.Ref_Doc,
					a.ATTACH_EXTENSION,
					a.CREATOR_ID,
					a.DOC_NUMBER	
					
				FROM  (
					select top ' + CAST(@nSelectRecord AS VARCHAR) + ' * 
					from (
						select top ' + CAST(@iNum1 AS VARCHAR) + ' * 
						from dbo.VW_WORK_LIST 
						where Participant_id = '''+@strUserId+'''  
						AND STATE = ''2''  
						AND PROCESS_INSTANCE_VIEW_STATE = ''9''			
						AND ITEMSTATE = ''1''
						' +@strOrderBy+ '
						) a
					' +@strOrderByRevers+ '
		   			) a
				' +@strOrderBy					

END

else if @strDFType = 'PR'

BEGIN
	--진행함


    -- 전체 레코드 Count 를 Output 으로 리턴함		
	SET @iTotalCount = (
						SELECT  count(*) 
						FROM dbo.VW_WORK_LIST 
						WHERE PARTICIPANT_ID = @strUserId 
						AND STATE = '7' 
						AND PROCESS_INSTANCE_VIEW_STATE = '3' 
						AND ITEMSTATE = '1'
						)


----------------------실제로 조회해야할 레코드 카운트 계산----------------------*
/* 
총 레코드 카운트가 이론적인 총 레코드 카운트(현재페이지*페이지사이즈)보다 작을때 
총 레코드 수에서 이전 페이지까지의 레코드 수를 빼서 나머지 필요한 레코드 카운트를 구한다.
*/

IF @iTotalCount < (@iNum1)
BEGIN
	SET @nSelectRecord = @iTotalCount - ( (@nCurPage - 1) * @nRowPerPage )
END

----------------------반환할 레코드 카운트가 1 미만인 경우----------------------
IF @nSelectRecord < 1
BEGIN
	SET @nSelectRecord = 0
	SET @iNum1 =0
END



	-- 소팅컬럼의 값이 0이 넘어오면 기본값으로 정렬
	if @strSortColumn = '0'	
		Begin
			SET @strOrderBy = ' ORDER BY COMPLETED_DATE DESC'
		end
	else
		begin
			SET @strOrderBy = ' ORDER BY '+@strSortColumn+' '+@strSortOrder+' , ITEMCREATE_DATE DESC'
		end
		
		
		
	-------------------------------[공통]---------------------------------------------------
	-- 소팅컬럼의 값이 0이 넘어오면 기본값으로 정렬
	if @strSortColumn = '0'	
		Begin
			SET @strOrderByRevers = ' ORDER BY COMPLETED_DATE ASC'
		end
	else
		begin
			SET @strSortOrderRevers =
			(
				CASE @strSortOrder
					WHEN 'ASC'		
							THEN	'DESC'
					WHEN 'DESC'	
							THEN	'ASC'				
				END 
			)	
			
			SET @strOrderByRevers = ' ORDER BY '+@strSortColumn+' '+@strSortOrderRevers+ ' , ITEMCREATE_DATE ASC'
		end	
	-------------------------------[공통]---------------------------------------------------


	
	SET @sQuery =	
		'SELECT	 
				a.ITEMOID,	
				a.IsUrgent, 
				a.Status, 
				a.ISATTACHFILE, 
				a.PostScript,
				a.CATEGORYNAME, 
				a.SUBJECT, 
				a.DOC_LEVEL, 
				a.CREATOR, 
				a.CREATOR_DEPT, 
				SUBSTRING(CONVERT(VARCHAR,a.COMPLETED_DATE,21),0,20) as COMPLETED_DATE,
				a.OPEN_YN,
				a.OID,
				a.Ref_Doc,
				a.ATTACH_EXTENSION,
				a.CREATOR_ID,
				a.DOC_NUMBER						
		FROM  (
			select top ' + CAST(@nSelectRecord AS VARCHAR) + ' * 
			from (
				select top ' + CAST(@iNum1 AS VARCHAR) + ' * 
				from dbo.VW_WORK_LIST 
				where Participant_id = '''+@strUserId+'''  
				AND STATE = ''7''  
				AND PROCESS_INSTANCE_VIEW_STATE = ''3''			
				AND ITEMSTATE = ''1''
				' +@strOrderBy+ '
				) a
			' +@strOrderByRevers+ '
		   	) a
		' +@strOrderBy	


END

else if @strDFType = 'CO'

BEGIN
	--완료함
	
    -- 전체 레코드 Count 를 Output 으로 리턴함		
	SET @iTotalCount = (
						SELECT  count(*) 
						FROM dbo.VW_WORK_LIST 
						WHERE PARTICIPANT_ID = @strUserId 
							AND STATE = '7' 
							AND PROCESS_INSTANCE_VIEW_STATE = '7'
					   )



----------------------실제로 조회해야할 레코드 카운트 계산----------------------*
/* 
총 레코드 카운트가 이론적인 총 레코드 카운트(현재페이지*페이지사이즈)보다 작을때 
총 레코드 수에서 이전 페이지까지의 레코드 수를 빼서 나머지 필요한 레코드 카운트를 구한다.
*/

IF @iTotalCount < (@iNum1)
BEGIN
	SET @nSelectRecord = @iTotalCount - ( (@nCurPage - 1) * @nRowPerPage )
END

----------------------반환할 레코드 카운트가 1 미만인 경우----------------------
IF @nSelectRecord < 1
BEGIN
	SET @nSelectRecord = 0
	SET @iNum1 =0
END




	--[공통]---------------------------------------------------		
	-- 소팅컬럼의 값이 0이 넘어오면 기본값으로 정렬
	if @strSortColumn = '0'	
		Begin
			SET @strOrderBy = ' ORDER BY VIEW_COMPLETE_DATE DESC'
		end

	else
		begin
			SET @strOrderBy = ' ORDER BY '+@strSortColumn+' '+@strSortOrder+ ' , ITEMCREATE_DATE DESC'
		end

	-- 소팅컬럼의 값이 0이 넘어오면 기본값으로 정렬
	if @strSortColumn = '0'	
		Begin
			SET @strOrderByRevers = ' ORDER BY VIEW_COMPLETE_DATE ASC'
		end

	else
		begin
			SET @strSortOrderRevers =
			(
				CASE @strSortOrder
					WHEN 'ASC'		
							THEN	'DESC'
					WHEN 'DESC'	
							THEN	'ASC'				
				END 
			)	
			
			SET @strOrderByRevers = ' ORDER BY '+@strSortColumn+' '+@strSortOrderRevers+ ' , ITEMCREATE_DATE ASC'
		end	
	--[공통]---------------------------------------------------

	SET @sQuery =	
				'SELECT	
						a.ITEMOID,	
						a.IsUrgent,				 
						a.Status, 
						a.ISATTACHFILE, 
						a.PostScript, 
						a.CATEGORYNAME, 
						a.SUBJECT, 
						a.DOC_LEVEL, 
						a.CREATOR, 
						a.CREATOR_DEPT, 
						SUBSTRING(CONVERT(VARCHAR,a.VIEW_COMPLETE_DATE,21),0,20) as VIEW_COMPLETE_DATE,
						a.OPEN_YN,
						a.OID,
						a.Ref_Doc,
						a.ATTACH_EXTENSION,
						a.CREATOR_ID,
						a.DOC_NUMBER	
						
						
				FROM  (
					select top ' + CAST(@nSelectRecord AS VARCHAR) + ' * 
					from (
						select top ' + CAST(@iNum1 AS VARCHAR) + ' * 
						from dbo.VW_WORK_LIST 
						where Participant_id = '''+@strUserId+'''  
						AND STATE = ''7''  
						AND PROCESS_INSTANCE_VIEW_STATE = ''7''			
						' +@strOrderBy+ '
						) a
					' +@strOrderByRevers+ '
		   			) a
				' +@strOrderBy							
						
END

else if @strDFType = 'RE'

BEGIN
--반려함

	-- 전체 레코드 Count 를 Output 으로 리턴함
	SET @iTotalCount = (
			SELECT  count(*) 
			FROM dbo.VW_WORK_LIST 
			WHERE PARTICIPANT_ID = @strUserId 
				AND STATE = '7' 
				AND PROCESS_INSTANCE_VIEW_STATE = '8' 
				AND ITEMSTATE = '7'
			)

select	@iTotalCount
return


----------------------실제로 조회해야할 레코드 카운트 계산----------------------*
/* 
총 레코드 카운트가 이론적인 총 레코드 카운트(현재페이지*페이지사이즈)보다 작을때 
총 레코드 수에서 이전 페이지까지의 레코드 수를 빼서 나머지 필요한 레코드 카운트를 구한다.
*/

IF @iTotalCount < (@iNum1)
BEGIN
	SET @nSelectRecord = @iTotalCount - ( (@nCurPage - 1) * @nRowPerPage )
END

----------------------반환할 레코드 카운트가 1 미만인 경우----------------------
IF @nSelectRecord < 1
BEGIN
	SET @nSelectRecord = 0
	SET @iNum1 =0
END

	--[공통]---------------------------------------------------		
	-- 소팅컬럼의 값이 0이 넘어오면 기본값으로 정렬
	if @strSortColumn = '0'	
		Begin
			SET @strOrderBy = ' ORDER BY VIEW_COMPLETE_DATE DESC'
		end

	else
		begin
			SET @strOrderBy = ' ORDER BY '+@strSortColumn+' '+@strSortOrder+ ' , ITEMCREATE_DATE DESC'
		end

	-- 소팅컬럼의 값이 0이 넘어오면 기본값으로 정렬
	if @strSortColumn = '0'	
		Begin
			SET @strOrderByRevers = ' ORDER BY VIEW_COMPLETE_DATE ASC'
		end

	else
		begin
			SET @strSortOrderRevers =
			(
				CASE @strSortOrder
					WHEN 'ASC'		
							THEN	'DESC'
					WHEN 'DESC'	
							THEN	'ASC'				
				END 
			)	
			
			SET @strOrderByRevers = ' ORDER BY '+@strSortColumn+' '+@strSortOrderRevers+ ' , ITEMCREATE_DATE ASC'
		end	
	--[공통]---------------------------------------------------


	
	SET @sQuery =	
		'SELECT	 
			a.ITEMOID,	
			a.IsUrgent, 
			a.Status, 
			a.ISATTACHFILE, 
			a.PostScript, 
			a.CATEGORYNAME, 
			a.SUBJECT, 
			a.DOC_LEVEL, 
			a.CREATOR, 
			a.CREATOR_DEPT, 
			SUBSTRING(CONVERT(VARCHAR,a.VIEW_COMPLETE_DATE,21),0,20) as VIEW_COMPLETE_DATE,
			a.OPEN_YN,
			a.OID,
			a.Ref_Doc,
			a.ATTACH_EXTENSION,
			a.CREATOR_ID,
			a.DOC_NUMBER	
			
		FROM  (
			select top ' + CAST(@nSelectRecord AS VARCHAR) + ' * 
			from (
				select top ' + CAST(@iNum1 AS VARCHAR) + ' * 
				from dbo.VW_WORK_LIST 
				where Participant_id = '''+@strUserId+'''  
				AND STATE = ''7''  
				AND PROCESS_INSTANCE_VIEW_STATE = ''8''		
				AND ITEMSTATE = ''7''	
				' +@strOrderBy+ '
				) a
			' +@strOrderByRevers+ '
		   	) a
		' +@strOrderBy							


END

else if @strDFType = 'ST'
-- 임시보관함



BEGIN

	-- 소팅컬럼의 값이 0이 넘어오면 기본값으로 정렬
	if @strSortColumn = '0'	
		Begin
			SET @strOrderBy = ' ORDER BY CREATE_DATE DESC'
		end
	else
		begin
			SET @strOrderBy = ' ORDER BY '+@strSortColumn+' '+@strSortOrder
		end	
		
		

		SET @sQuery = 
		N'	SELECT  bb.PROCESS_ID,
					(SELECT Form_Name FROM dbo.WF_FORMS s WHERE s.FORM_ID = bb.FORM_ID) as FORM_ID,
					bb.USERID,
					bb.SUBJECT,
					bb.DEPTID,
					bb.DESCRIPTION,
					SUBSTRING(CONVERT(VARCHAR,bb.CREATE_DATE,21),0,20) as CREATE_DATE

			FROM 
				(	SELECT a.*  
					FROM 
						(
							SELECT top ' + CAST(@iNum1 AS VARCHAR) + ' Process_ID, CREATE_DATE
							FROM WF_FORM_STORAGE(NOLOCK)
							WHERE UserId = '''+@strUserId+'''
								AND DELETE_DATE = cast(''9999-12-31 00:00:00.000'' as datetime)
								'+@strOrderBy+'
						) a
						LEFT OUTER JOIN(
							SELECT Top ' + CAST(@iNum2 AS VARCHAR) + ' Process_ID, CREATE_DATE
							FROM WF_FORM_STORAGE(NOLOCK)
							WHERE UserID = '''+@strUserId+'''
								AND DELETE_DATE = cast(''9999-12-31 00:00:00.000'' as datetime)
								'+@strOrderBy+'
 						) b
						on a.Process_ID = b.Process_ID
						WHERE b.Process_ID Is null

				) aa 
			INNER join WF_FORM_STORAGE bb (nolock)  
			ON bb.PROCESS_ID = aa.PROCESS_ID  
			WHERE bb.DELETE_DATE = cast(''9999-12-31 00:00:00.000'' as datetime) '
			
			
			
    -- 전체 레코드 Count 를 Output 으로 리턴함
	SET @iTotalCount = (
				SELECT count(*)  
				FROM WF_FORM_STORAGE(NOLOCK) 
				WHERE DELETE_DATE = cast('9999-12-31 00:00:00.000' as datetime) 
				AND UserID =  CAST(@strUserId AS int)
	)


END


else if @strDFType = 'P'
	--업무협조함
BEGIN


    -- 전체 레코드 Count 를 Output 으로 리턴함
	SET @iTotalCount = (
			SELECT	count(*) 
			FROM dbo.VW_WORK_LIST 
			WHERE  PARTICIPANT_ID = @strUserDeptId+'_'+@strDFType	
				AND STATE = '7'	
				AND PROCESS_INSTANCE_VIEW_STATE = '3'
			)



----------------------실제로 조회해야할 레코드 카운트 계산----------------------*
/* 
총 레코드 카운트가 이론적인 총 레코드 카운트(현재페이지*페이지사이즈)보다 작을때 
총 레코드 수에서 이전 페이지까지의 레코드 수를 빼서 나머지 필요한 레코드 카운트를 구한다.
*/

IF @iTotalCount < (@iNum1)
BEGIN
	SET @nSelectRecord = @iTotalCount - ( (@nCurPage - 1) * @nRowPerPage )
END

----------------------반환할 레코드 카운트가 1 미만인 경우----------------------
IF @nSelectRecord < 1
BEGIN
	SET @nSelectRecord = 0
	SET @iNum1 =0
END




	-- 소팅컬럼의 값이 0이 넘어오면 기본값으로 정렬
	if @strSortColumn = '0'	
		Begin
			SET @strOrderBy = ' ORDER BY COMPLETED_DATE DESC'
		end
	else
		begin
			SET @strOrderBy = ' ORDER BY '+@strSortColumn+' '+@strSortOrder+' , ITEMCREATE_DATE DESC'
		end
		
		
		
	-------------------------------[공통]---------------------------------------------------
	-- 소팅컬럼의 값이 0이 넘어오면 기본값으로 정렬
	if @strSortColumn = '0'	
		Begin
			SET @strOrderByRevers = ' ORDER BY COMPLETED_DATE ASC'
		end
	else
		begin
			SET @strSortOrderRevers =
			(
				CASE @strSortOrder
					WHEN 'ASC'		
							THEN	'DESC'
					WHEN 'DESC'	
							THEN	'ASC'				
				END 
			)	
			
			SET @strOrderByRevers = ' ORDER BY '+@strSortColumn+' '+@strSortOrderRevers+ ' , ITEMCREATE_DATE ASC'
		end	
	-------------------------------[공통]---------------------------------------------------

		
	
	SET @sQuery =	
		'SELECT	 
			a.ITEMOID,	
			a.IsUrgent, 
			a.Status, 
			a.ISATTACHFILE, 
			a.PostScript, 
			a.CATEGORYNAME, 
			a.SUBJECT, 
			a.DOC_LEVEL, 
			a.CREATOR, 
			a.CREATOR_DEPT, 
			SUBSTRING(CONVERT(VARCHAR,a.COMPLETED_DATE,21),0,20) as COMPLETED_DATE,
			a.OPEN_YN,
			a.OID,
			a.Ref_Doc,
			a.ATTACH_EXTENSION,
			a.CREATOR_ID,
			a.DOC_NUMBER						
			
		FROM  (
			select top ' + CAST(@nSelectRecord AS VARCHAR) + ' * 
			from (
				select top ' + CAST(@iNum1 AS VARCHAR) + ' * 
				from dbo.VW_WORK_LIST 
				where Participant_id = '''+@strUserDeptId+'_'+@strDFType+''' 
				AND STATE = ''7''  
				AND PROCESS_INSTANCE_VIEW_STATE = ''3''		
				' +@strOrderBy+ '
				) a
			' +@strOrderByRevers+ '
		   	) a
		' +@strOrderBy							


END


else if @strDFType = 'S'
	--발신함
BEGIN


    -- 전체 레코드 Count 를 Output 으로 리턴함
	SET @iTotalCount = (
				SELECT	count(*) 
				FROM dbo.VW_WORK_LIST 
				WHERE  PARTICIPANT_ID = @strUserDeptId+'_'+@strDFType	
					AND STATE = '7'	
					AND PROCESS_INSTANCE_VIEW_STATE = '3')



----------------------실제로 조회해야할 레코드 카운트 계산----------------------*
/* 
총 레코드 카운트가 이론적인 총 레코드 카운트(현재페이지*페이지사이즈)보다 작을때 
총 레코드 수에서 이전 페이지까지의 레코드 수를 빼서 나머지 필요한 레코드 카운트를 구한다.
*/

IF @iTotalCount < (@iNum1)
BEGIN
	SET @nSelectRecord = @iTotalCount - ( (@nCurPage - 1) * @nRowPerPage )
END

----------------------반환할 레코드 카운트가 1 미만인 경우----------------------
IF @nSelectRecord < 1
BEGIN
	SET @nSelectRecord = 0
	SET @iNum1 =0
END


	-- 소팅컬럼의 값이 0이 넘어오면 기본값으로 정렬
	if @strSortColumn = '0'	
		Begin
			SET @strOrderBy = ' ORDER BY COMPLETED_DATE DESC'
		end
	else
		begin
			SET @strOrderBy = ' ORDER BY '+@strSortColumn+' '+@strSortOrder+' , ITEMCREATE_DATE DESC'
		end
		
		
		
	-------------------------------[공통]---------------------------------------------------
	-- 소팅컬럼의 값이 0이 넘어오면 기본값으로 정렬
	if @strSortColumn = '0'	
		Begin
			SET @strOrderByRevers = ' ORDER BY COMPLETED_DATE ASC'
		end
	else
		begin
			SET @strSortOrderRevers =
			(
				CASE @strSortOrder
					WHEN 'ASC'		
							THEN	'DESC'
					WHEN 'DESC'	
							THEN	'ASC'				
				END 
			)	
			
			SET @strOrderByRevers = ' ORDER BY '+@strSortColumn+' '+@strSortOrderRevers+ ' , ITEMCREATE_DATE ASC'
		end	
	-------------------------------[공통]---------------------------------------------------

	
	
	SET @sQuery =	
		'SELECT	 
			a.ITEMOID,	
			a.IsUrgent, 
			a.Status, 
			a.ISATTACHFILE, 
			a.PostScript, 
			a.CATEGORYNAME, 
			a.SUBJECT,  
			a.DOC_LEVEL, 
			a.CREATOR, 
			a.CREATOR_DEPT, 
			SUBSTRING(CONVERT(VARCHAR,a.COMPLETED_DATE,21),0,20) as COMPLETED_DATE,
			a.OPEN_YN,
			a.OID,
			a.Ref_Doc,
			a.ATTACH_EXTENSION,
			a.CREATOR_ID,
			a.DOC_NUMBER	
					
			
		FROM  (
			select top ' + CAST(@nSelectRecord AS VARCHAR) + ' * 
			from (
				select top ' + CAST(@iNum1 AS VARCHAR) + ' * 
				from dbo.VW_WORK_LIST 
				where Participant_id = '''+@strUserDeptId+'_'+@strDFType+''' 
				AND STATE = ''7''  
				AND PROCESS_INSTANCE_VIEW_STATE = ''3''		
				' +@strOrderBy+ '
				) a
			' +@strOrderByRevers+ '
		   	) a
		' +@strOrderBy							

			

END

else if @strDFType = 'A'
	--	
BEGIN



    -- 전체 레코드 Count 를 Output 으로 리턴함
	SET @iTotalCount = (
			SELECT	count(*) 
			FROM dbo.VW_WORK_LIST 
			WHERE  PARTICIPANT_ID = @strUserDeptId+'_'+@strDFType	
				AND STATE = '7'	
				AND PROCESS_INSTANCE_VIEW_STATE = '3'
		)



----------------------실제로 조회해야할 레코드 카운트 계산----------------------*
/* 
총 레코드 카운트가 이론적인 총 레코드 카운트(현재페이지*페이지사이즈)보다 작을때 
총 레코드 수에서 이전 페이지까지의 레코드 수를 빼서 나머지 필요한 레코드 카운트를 구한다.
*/

IF @iTotalCount < (@iNum1)
BEGIN
	SET @nSelectRecord = @iTotalCount - ( (@nCurPage - 1) * @nRowPerPage )
END

----------------------반환할 레코드 카운트가 1 미만인 경우----------------------
IF @nSelectRecord < 1
BEGIN
	SET @nSelectRecord = 0
	SET @iNum1 =0
END



	-- 소팅컬럼의 값이 0이 넘어오면 기본값으로 정렬
	if @strSortColumn = '0'	
		Begin
			SET @strOrderBy = ' ORDER BY COMPLETED_DATE DESC'
		end
	else
		begin
			SET @strOrderBy = ' ORDER BY '+@strSortColumn+' '+@strSortOrder+' , ITEMCREATE_DATE DESC'
		end
		
		
		
	-------------------------------[공통]---------------------------------------------------
	-- 소팅컬럼의 값이 0이 넘어오면 기본값으로 정렬
	if @strSortColumn = '0'	
		Begin
			SET @strOrderByRevers = ' ORDER BY COMPLETED_DATE ASC'
		end
	else
		begin
			SET @strSortOrderRevers =
			(
				CASE @strSortOrder
					WHEN 'ASC'		
							THEN	'DESC'
					WHEN 'DESC'	
							THEN	'ASC'				
				END 
			)	
			
			SET @strOrderByRevers = ' ORDER BY '+@strSortColumn+' '+@strSortOrderRevers+ ' , ITEMCREATE_DATE ASC'
		end	
	-------------------------------[공통]---------------------------------------------------

	
	
	SET @sQuery =	'SELECT	 
			a.ITEMOID,	
			a.IsUrgent, 
			a.Status, 
			a.ISATTACHFILE, 
			a.PostScript, 
			a.CATEGORYNAME, 
			a.SUBJECT,  
			a.DOC_LEVEL, 
			a.CREATOR, 
			a.CREATOR_DEPT, 
			SUBSTRING(CONVERT(VARCHAR,a.COMPLETED_DATE,21),0,20) as COMPLETED_DATE,
			a.OPEN_YN,
			a.OID,
			a.Ref_Doc,
			a.ATTACH_EXTENSION,
			a.CREATOR_ID,
			a.DOC_NUMBER	
			
			
		FROM  (
			select top ' + CAST(@nSelectRecord AS VARCHAR) + ' * 
			from (
				select top ' + CAST(@iNum1 AS VARCHAR) + ' * 
				from dbo.VW_WORK_LIST 
				where Participant_id = '''+@strUserDeptId+'_'+@strDFType+''' 
				AND STATE = ''7''  
				AND PROCESS_INSTANCE_VIEW_STATE = ''3''		
				' +@strOrderBy+ '
				) a
			' +@strOrderByRevers+ '
		   	) a
		' +@strOrderBy							
		
			



END

else if @strDFType = 'R' or @strDFType = 'K'
	--수신함
BEGIN

 -- 전체 레코드 Count 를 Output 으로 리턴함
	SET @iTotalCount = (
			SELECT	count(*) 
			FROM dbo.VW_WORK_LIST 
			WHERE  PARTICIPANT_ID = @strUserDeptId+'_'+@strDFType	
				AND STATE = '2'	
				AND PROCESS_INSTANCE_VIEW_STATE = '3')


----------------------실제로 조회해야할 레코드 카운트 계산----------------------*
/* 
총 레코드 카운트가 이론적인 총 레코드 카운트(현재페이지*페이지사이즈)보다 작을때 
총 레코드 수에서 이전 페이지까지의 레코드 수를 빼서 나머지 필요한 레코드 카운트를 구한다.
*/

IF @iTotalCount < (@iNum1)
BEGIN
	SET @nSelectRecord = @iTotalCount - ( (@nCurPage - 1) * @nRowPerPage )
END

----------------------반환할 레코드 카운트가 1 미만인 경우----------------------
IF @nSelectRecord < 1
BEGIN
	SET @nSelectRecord = 0
	SET @iNum1 =0
END


   




	-- 소팅컬럼의 값이 0이 넘어오면 기본값으로 정렬
	if @strSortColumn = '0'	
		Begin
			SET @strOrderBy = ' ORDER BY CREATE_DATE DESC'
		end
	else
		begin
			SET @strOrderBy = ' ORDER BY '+@strSortColumn+' '+@strSortOrder+' , ITEMCREATE_DATE DESC'
		end
		
		
		
	-------------------------------[공통]---------------------------------------------------
	-- 소팅컬럼의 값이 0이 넘어오면 기본값으로 정렬
	if @strSortColumn = '0'	
		Begin
			SET @strOrderByRevers = ' ORDER BY CREATE_DATE ASC'
		end

	else
		begin
			SET @strSortOrderRevers =
			(
				CASE @strSortOrder
					WHEN 'ASC'		
							THEN	'DESC'
					WHEN 'DESC'	
							THEN	'ASC'				
				END 
			)	
			
			SET @strOrderByRevers = ' ORDER BY '+@strSortColumn+' '+@strSortOrderRevers+ ' , ITEMCREATE_DATE ASC'
		end	
	-------------------------------[공통]---------------------------------------------------

	
	SET @sQuery =	'SELECT	 
			a.ITEMOID,	 	
			a.IsUrgent, 
			a.Status, 
			a.ISATTACHFILE, 
			a.PostScript, 
			a.CATEGORYNAME, 
			a.SUBJECT,  
			a.DOC_LEVEL, 
			a.CREATOR, 
			a.CREATOR_DEPT, 
			SUBSTRING(CONVERT(VARCHAR,a.CREATE_DATE,21),0,20) as CREATE_DATE,
			a.OPEN_YN,
			a.OID,
			a.Ref_Doc,
			a.ATTACH_EXTENSION,
			a.CREATOR_ID,
			a.DOC_NUMBER	
					
			
		FROM  (
			select top ' + CAST(@nSelectRecord AS VARCHAR) + ' * 
			from (
				select top ' + CAST(@iNum1 AS VARCHAR) + ' * 
				from dbo.VW_WORK_LIST 
				where Participant_id = '''+@strUserDeptId+'_'+@strDFType+''' 
				AND STATE = ''2''  
				AND PROCESS_INSTANCE_VIEW_STATE = ''3''		
				' +@strOrderBy+ '
				) a
			' +@strOrderByRevers+ '
		   	) a
		' +@strOrderBy							

			
		
END	



else if @strDFType = 'PA'
	--예결함
BEGIN

 -- 전체 레코드 Count 를 Output 으로 리턴함
	SET @iTotalCount = (
			SELECT count(*)
			FROM dbo.VW_PR_LIST(nolock)
			where USER_ID = @strUserId	--해당 사용자
			AND ACTION_TYPE = '2'  		--예결함조건			
			)

----------------------실제로 조회해야할 레코드 카운트 계산----------------------*
/* 
총 레코드 카운트가 이론적인 총 레코드 카운트(현재페이지*페이지사이즈)보다 작을때 
총 레코드 수에서 이전 페이지까지의 레코드 수를 빼서 나머지 필요한 레코드 카운트를 구한다.
*/

IF @iTotalCount < (@iNum1)
BEGIN
	SET @nSelectRecord = @iTotalCount - ( (@nCurPage - 1) * @nRowPerPage )
END

----------------------반환할 레코드 카운트가 1 미만인 경우----------------------
IF @nSelectRecord < 1
BEGIN
	SET @nSelectRecord = 0
	SET @iNum1 =0
END


   


	-- 소팅컬럼의 값이 0이 넘어오면 기본값으로 정렬
	if @strSortColumn = '0'	
		Begin
			SET @strOrderBy = ' ORDER BY CREATE_DATE DESC'
		end

	else if @strSortColumn = 'CREATE_DATE'	
		begin
			SET @strOrderBy = ' ORDER BY '+@strSortColumn+' '+@strSortOrder
		end
	
	else
		begin
			SET @strOrderBy = ' ORDER BY '+@strSortColumn+' '+@strSortOrder+' , CREATE_DATE DESC'
		end
		
		
		
	-------------------------------[공통]---------------------------------------------------
	-- 소팅컬럼의 값이 0이 넘어오면 기본값으로 정렬
	if @strSortColumn = '0'	
		Begin
			SET @strOrderByRevers = ' ORDER BY CREATE_DATE ASC'
		end

	else
		begin
			SET @strSortOrderRevers =
			(
				CASE @strSortOrder
					WHEN 'ASC'		
							THEN	'DESC'
					WHEN 'DESC'	
							THEN	'ASC'				
				END 
			)	
			
			if @strSortColumn = 'CREATE_DATE'
			   BEGIN	
				SET @strOrderByRevers = ' ORDER BY '+@strSortColumn+' '+@strSortOrderRevers
			   END
			else
			   BEGIN	
				SET @strOrderByRevers = ' ORDER BY '+@strSortColumn+' '+@strSortOrderRevers+ ' , CREATE_DATE ASC'
			   END

		end	
	-------------------------------[공통]---------------------------------------------------

	
	SET @sQuery =	'SELECT	 
			a.ITEMOID,	 	
			a.ISURGENT, 
			a.STATUS, 
			a.ISATTACHFILE, 
			a.POSTSCRIPT, 
			a.CATEGORYNAME, 
			a.SUBJECT,  
			a.DOC_LEVEL, 
			a.CREATOR, 
			a.CREATOR_DEPT, 
			SUBSTRING(CONVERT(VARCHAR,a.CREATE_DATE,21),0,20) as CREATE_DATE,
			'''' as OPEN_YN,
			'''' as OID,
			a.REF_DOC,
			a.ATTACH_EXTENSION,
			a.CREATOR_ID,
			a.DOC_NUMBER						
			
		FROM  (
			select top ' + CAST(@nSelectRecord AS VARCHAR) + ' * 
			from (
				select top ' + CAST(@iNum1 AS VARCHAR) + ' * 
				from dbo.VW_PR_LIST(nolock)
				where USER_ID = '''+@strUserId+''' 
				AND ACTION_TYPE = ''2''  
				' +@strOrderBy+ '
				) a
			where USER_ID = '''+@strUserId+'''
			' +@strOrderByRevers+ '
		   	) a
		where USER_ID = '''+@strUserId+'''
		' +@strOrderBy		

	
		
END	


else

	--기타.
BEGIN


    -- 전체 레코드 Count 를 Output 으로 리턴함
	SET @iTotalCount = (
			SELECT	count(*) 
			FROM dbo.VW_WORK_LIST 
			WHERE  PARTICIPANT_ID = @strUserDeptId+'_'+@strDFType	
				AND STATE = '7'	
				AND PROCESS_INSTANCE_VIEW_STATE = '3'
			)



	----------------------실제로 조회해야할 레코드 카운트 계산----------------------*
	/* 
	총 레코드 카운트가 이론적인 총 레코드 카운트(현재페이지*페이지사이즈)보다 작을때 
	총 레코드 수에서 이전 페이지까지의 레코드 수를 빼서 나머지 필요한 레코드 카운트를 구한다.
	*/

	IF @iTotalCount < (@iNum1)
	BEGIN
		SET @nSelectRecord = @iTotalCount - ( (@nCurPage - 1) * @nRowPerPage )
	END

	----------------------반환할 레코드 카운트가 1 미만인 경우----------------------
	IF @nSelectRecord < 1
	BEGIN
		SET @nSelectRecord = 0
		SET @iNum1 =0
	END



	-- 소팅컬럼의 값이 0이 넘어오면 기본값으로 정렬
	if @strSortColumn = '0'	
		Begin
			SET @strOrderBy = ' ORDER BY COMPLETED_DATE DESC'
		end
	else if @strSortColumn = 'COMPLETED_DATE'
		Begin
			SET @strOrderBy = ' ORDER BY '+@strSortColumn+' '+@strSortOrder
		End		
	else
		begin
			SET @strOrderBy = ' ORDER BY '+@strSortColumn+' '+@strSortOrder+' , COMPLETED_DATE DESC'
		end
		
		
		
	-------------------------------[공통]---------------------------------------------------
	-- 소팅컬럼의 값이 0이 넘어오면 기본값으로 정렬
	if @strSortColumn = '0'	
		Begin
			SET @strOrderByRevers = ' ORDER BY COMPLETED_DATE ASC'
		end
	else if @strSortColumn = 'COMPLETED_DATE'
		Begin
			SET @strOrderByRevers = ' '
		End		
	else
		begin
			SET @strSortOrderRevers =
			(
				CASE @strSortOrder
					WHEN 'ASC'		
							THEN	'DESC'
					WHEN 'DESC'	
							THEN	'ASC'				
				END 
			)	
			
			SET @strOrderByRevers = ' ORDER BY '+@strSortColumn+' '+@strSortOrderRevers+ ' , COMPLETED_DATE ASC'
		end	
	-------------------------------[공통]---------------------------------------------------

	
	SET @sQuery =	
		'SELECT	 
			a.ITEMOID,	
			a.IsUrgent, 
			a.Status, 
			a.ISATTACHFILE, 
			a.PostScript, 
			a.CATEGORYNAME, 
			a.SUBJECT, 
			a.DOC_LEVEL, 
			a.CREATOR, 
			a.CREATOR_DEPT, 
			SUBSTRING(CONVERT(VARCHAR,a.COMPLETED_DATE,21),0,20) as COMPLETED_DATE,
			a.OPEN_YN,
			a.OID,
			a.Ref_Doc,
			a.ATTACH_EXTENSION,
			a.CREATOR_ID,
			a.DOC_NUMBER	
			
			
		FROM  (
			select top ' + CAST(@nSelectRecord AS VARCHAR) + ' * 
			from (
				select top ' + CAST(@iNum1 AS VARCHAR) + ' * 
				from dbo.VW_WORK_LIST 
				where Participant_id = '''+@strUserDeptId+'_'+@strDFType+''' 
				AND STATE = ''7''  
				AND PROCESS_INSTANCE_VIEW_STATE = ''3''		
				' +@strOrderBy+ '
				) a
			' +@strOrderByRevers+ '
		   	) a
		' +@strOrderBy							
		
END


--ALTER  table #tem(sql text)
--insert #tem(sql) values(@sQuery+@strOrderBy)
--select * from #tem
--drop table #tem

--print @sQuery
exec(@sQuery)


RETURN



























GO
/****** Object:  StoredProcedure [dbo].[UP_LIST_VW_WORKLIST_DOCUMENTLISTSEARCH]    Script Date: 2015-10-15 오후 1:30:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO



CREATE	PROCEDURE	[dbo].[UP_LIST_VW_WORKLIST_DOCUMENTLISTSEARCH]
  -- 사용자ID,사용자부서ID,결재함종류,현재페이지,블록(페이지)당표시건수,정렬필드,정렬방법,전체결재건수(Output)
		@strUserId varchar(20),
		@strUserDeptId varchar(20),
		@strDFType varchar(5),
		@strCondition varchar(20),
		@strKeyword varchar(50),
		@nCurPage int, 
		@nRowPerPage int,
		@strSortColumn varchar(20),
		@strSortOrder varchar(5),
		@strFormsId varchar(1000),    --양식별 검색(신철호)
		@iTotalCount int output

AS
/* SET NOCOUNT ON */

/*
select userid, * from emanage.dbo.tb_user where username = 'ewf1'
select * from emanage.dbo.tb_dept_user where userid = 133342
select	*	from	ewfform.dbo.wf_forms

declare @P1 int
set @P1=12
exec dbo.UP_LIST_VW_WORKLIST_DOCUMENTLISTSEARCH @strUserId = '133342', @strUserDeptId = '2972', @strDFType = 'RF', @strCondition = '|/E', @strKeyword = '', @nCurPage = 2, @nRowPerPage = 10, @strSortColumn = '0', @strSortOrder = 'DESC', @strFormsId = '"Y91A030E57A8A46C091231D1FB5D01360"', @iTotalCount = @P1 output
select @P1

declare @P1 int
set @P1=100
exec dbo.UP_LIST_VW_WORKLIST_DOCUMENTLISTSEARCH @strUserId = '111332', @strUserDeptId = '2974', @strDFType = 'CO', @strCondition = 'SUBJECT', @strKeyword = '전산', @nCurPage = 1, @nRowPerPage = 50, @strSortColumn = '0', @strSortOrder = 'ASC', @strFormsId = 'ALLFORM', @iTotalCount = @P1 output
select @P1

declare @P1 int
set @P1=65
exec dbo.UP_LIST_VW_WORKLIST_DOCUMENTLISTSEARCH @strUserId = '133342', @strUserDeptId = '2974', @strDFType = 'CO', @strCondition = 'SUBJECT', @strKeyword = '전산', @nCurPage = 1, @nRowPerPage = 50, @strSortColumn = '0', @strSortOrder = 'ASC', @strFormsId = 'ALLFORM', @iTotalCount = @P1 output
select @P1

*/
	
DECLARE @iNum1 	INT
DECLARE @iNum2 	INT
DECLARE @sQuery VARCHAR(8000)
DECLARE @strOrderBy VARCHAR(100)
DECLARE @sCountQuery VARCHAR(3000)
--DECLARE @like VARCHAR(100)
DECLARE @strOrderByRevers VARCHAR(100)
DECLARE @strSortOrderRevers CHAR(4)
DECLARE @nSelectRecord INT		-- 실제로 반환할 레코드 수
DECLARE @strWhereForFormsId VARCHAR(1000) --양식별 검색조건 문(신철호)
DECLARE @strWhereForCondition VARCHAR(500) --키워드 검색조건 문(신철호)

-- @strCondition 파라메터에 검색조건과 결재진행상태, 날짜조건이 같이 넘어오므로 문자열을 분리한다.
-- declare	@strCondition	varchar(100)
-- set		@strCondition = 'CREATOR_DEPT|7/S'	
DECLARE	@wState		VARCHAR(10)

IF	CHARINDEX('|', @strCondition) <> 0
	SELECT	@wState	= SUBSTRING(@strCondition, CHARINDEX('|', @strCondition)+1, 1),
			@strCondition = SUBSTRING(@strCondition, 1, CHARINDEX('|', @strCondition)-1)
--select @wState, @strCondition
		
--		@nCNT   		int

SET @iNum1 = @nCurPage * @nRowPerPage
SET @iNum2 = (@nCurPage-1) * @nRowPerPage
SET @nSelectRecord = @nRowPerPage



-- FORM_ID WHERE 조건 구문을 만든다.
IF @strFormsId = 'ALLFORM'
    BEGIN
        SET @strWhereForFormsId = ''
    END
ELSE
    BEGIN
        SET @strWhereForFormsId = 'AND FORM_ID in (' + @strFormsId + ')'
    END

SET @strWhereForFormsId = REPLACE(@strWhereForFormsId,'"','''')


--검색조건이 없을 경우, 구문을 뺀다.
IF @strCondition = ''
    BEGIN
        SET @strWhereForCondition = ''
    END
ELSE
    BEGIN
        SET @strWhereForCondition = ' AND '+@strCondition+' LIKE ''%'+@strKeyword+'%'''	
    END



IF @strDFType = 'AP'

BEGIN
	--결재함
	
    -- 전체 레코드 Count 를 Output 으로 리턴함
	SET @sCountQuery = 'SELECT count(*) 
						FROM dbo.VW_WORK_LIST 
						WHERE PARTICIPANT_ID = '''+@strUserId+''' 
						AND STATE = ''2'' 
						AND PROCESS_INSTANCE_VIEW_STATE = ''3'' 
						AND ITEMSTATE = ''1''
                     					' + @strWhereForFormsId	
						+ @strWhereForCondition
	
	--임시테이블 생성후 카운트 쿼리 실행시켜 INSERT 하고
	CREATE     TABLE #temp(sql int)
	INSERT INTO #temp exec(@sCountQuery)
	SELECT @iTotalCount = sql FROM #temp
	DROP TABLE #temp
	
	
	----------------------실제로 조회해야할 레코드 카운트 계산----------------------
	--총 레코드 카운트가 이론적인 총 레코드 카운트(현재페이지*페이지사이즈)보다 작을때 
	--총 레코드 수에서 이전 페이지까지의 레코드 수를 빼서 나머지 필요한 레코드 카운트를 구한다.
	
	IF @iTotalCount < (@iNum1)
	BEGIN
		SET @nSelectRecord = @iTotalCount - ( (@nCurPage - 1) * @nRowPerPage )
	END
	----------------------반환할 레코드 카운트가 1 미만인 경우----------------------
	IF @nSelectRecord < 1
	BEGIN
		SET @nSelectRecord = 0
		SET @iNum1 =0
	END
	
	
	
	--[공통]---------------------------------------------------		
	-- 소팅컬럼의 값이 0이 넘어오면 기본값으로 정렬
	if @strSortColumn = '0'	
		Begin
			SET @strOrderBy = ' ORDER BY CREATE_DATE DESC'
		end

	else
		begin
			SET @strOrderBy = ' ORDER BY '+@strSortColumn+' '+@strSortOrder+ ' , ITEMCREATE_DATE DESC'
		end

	-- 소팅컬럼의 값이 0이 넘어오면 기본값으로 정렬
	if @strSortColumn = '0'	
		Begin
			SET @strOrderByRevers = ' ORDER BY CREATE_DATE ASC'
		end

	else
		begin
			SET @strSortOrderRevers =
			(
				CASE @strSortOrder
					WHEN 'ASC'		
							THEN	'DESC'
					WHEN 'DESC'	
							THEN	'ASC'				
				END 

			)	
			

			SET @strOrderByRevers = ' ORDER BY '+@strSortColumn+' '+@strSortOrderRevers+ ' , ITEMCREATE_DATE ASC'
		end	
	--[공통]---------------------------------------------------
	

	SET @sQuery ='SELECT '+
					'a.ITEMOID,'+
					'a.IsUrgent,'+ 
					'a.Status,'+
					'a.ISATTACHFILE,'+
					'a.PostScript,'+
					'a.CATEGORYNAME,'+
					'a.SUBJECT,'+
					'a.DOC_LEVEL,'+        -- 2005.03.08 KJJ : DOC_LEVEL 을 DOC_NUMBER로 변경
					'a.CREATOR,'+

					'a.CREATOR_DEPT,'+
					'SUBSTRING(CONVERT(varchar,a.CREATE_DATE,21),0,17) as CREATE_DATE,'+
					'a.OPEN_YN,'+
					'a.OID,'+
					'a.Ref_Doc, '+
					'a.ATTACH_EXTENSION, '+
					'a.CREATOR_ID, '+
					'a.DOC_NUMBER '+
                  
				'FROM  (
					select top ' + CAST(@nSelectRecord AS VARCHAR) + ' * 
					from (
						select top ' + CAST(@iNum1 AS VARCHAR) + ' * 
						from dbo.VW_WORK_LIST 
						where Participant_id = '''+@strUserId+'''  
						AND STATE = ''2''  
						AND PROCESS_INSTANCE_VIEW_STATE = ''3''			
						AND ITEMSTATE = ''1''
                       					' + @strWhereForFormsId + '
						' + @strWhereForCondition + '						
						' +@strOrderBy+ '
						) a
					where Participant_id = '''+@strUserId+'''  
					AND STATE = ''2''  
					AND PROCESS_INSTANCE_VIEW_STATE = ''3''			
					AND ITEMSTATE = ''1''
                    				' + @strWhereForFormsId + '
					' + @strWhereForCondition + '						
					' +@strOrderByRevers+ '
		   			) a
				where Participant_id = '''+@strUserId+'''  
				AND STATE = ''2''  
				AND PROCESS_INSTANCE_VIEW_STATE = ''3''			
				AND ITEMSTATE = ''1''
               			' + @strWhereForFormsId + '
				' + @strWhereForCondition + '						
				' +@strOrderBy				
					
END


ELSE IF @strDFType = 'AF'

BEGIN
	--후결함
	
    -- 전체 레코드 Count 를 Output 으로 리턴함
	SET @sCountQuery = 'SELECT count(*) 
						FROM dbo.VW_WORK_LIST 
						WHERE PARTICIPANT_ID = '''+@strUserId+''' 
						AND STATE = ''2'' 
						AND PROCESS_INSTANCE_VIEW_STATE = ''9'' 
						AND ITEMSTATE = ''1''
                      					' + @strWhereForFormsId + '
						' + @strWhereForCondition					
					
						
						
	--임시테이블 생성후 카운트 쿼리 실행시켜 INSERT 하고
	CREATE TABLE #temp1(sql int)
	INSERT INTO #temp1 exec(@sCountQuery)
	SELECT @iTotalCount = sql FROM #temp1
	DROP TABLE #temp1							
	
	----------------------실제로 조회해야할 레코드 카운트 계산----------------------
	--총 레코드 카운트가 이론적인 총 레코드 카운트(현재페이지*페이지사이즈)보다 작을때 
	--총 레코드 수에서 이전 페이지까지의 레코드 수를 빼서 나머지 필요한 레코드 카운트를 구한다.
	
	IF @iTotalCount < (@iNum1)
	BEGIN
		SET @nSelectRecord = @iTotalCount - ( (@nCurPage - 1) * @nRowPerPage )
	END
	----------------------반환할 레코드 카운트가 1 미만인 경우----------------------
	IF @nSelectRecord < 1
	BEGIN
		SET @nSelectRecord = 0
		SET @iNum1 =0
	END
	
	
	
	--[공통]---------------------------------------------------		
	-- 소팅컬럼의 값이 0이 넘어오면 기본값으로 정렬
	if @strSortColumn = '0'	
		Begin
			SET @strOrderBy = ' ORDER BY CREATE_DATE DESC'
		end

	else
		begin
			SET @strOrderBy = ' ORDER BY '+@strSortColumn+' '+@strSortOrder+ ' , ITEMCREATE_DATE DESC'
		end

	-- 소팅컬럼의 값이 0이 넘어오면 기본값으로 정렬
	if @strSortColumn = '0'	
		Begin
			SET @strOrderByRevers = ' ORDER BY CREATE_DATE ASC'
		end

	else
		begin
			SET @strSortOrderRevers =
			(
				CASE @strSortOrder
					WHEN 'ASC'		
							THEN	'DESC'
					WHEN 'DESC'	
							THEN	'ASC'				
				END 
			)	
			
			SET @strOrderByRevers = ' ORDER BY '+@strSortColumn+' '+@strSortOrderRevers+ ' , ITEMCREATE_DATE ASC'
		end	
	--[공통]---------------------------------------------------

	


	SET @sQuery ='SELECT '+
					'a.ITEMOID,'+
					'a.IsUrgent,'+ 
					'a.Status,'+
					'a.ISATTACHFILE,'+
					'a.PostScript,'+
					'a.CATEGORYNAME,'+
					'a.SUBJECT,'+
					'a.DOC_LEVEL,'+        -- 2005.03.08 KJJ : DOC_LEVEL 을 DOC_NUMBER로 변경
					'a.CREATOR,'+
					'a.CREATOR_DEPT,'+
					'SUBSTRING(CONVERT(varchar,a.CREATE_DATE,21),0,17) as CREATE_DATE,'+
					'a.OPEN_YN,'+


					'a.OID,'+
					'a.Ref_Doc, '+
					'a.ATTACH_EXTENSION, '+
					'a.CREATOR_ID, '+
					'a.DOC_NUMBER '+
              
				'FROM  (
					select top ' + CAST(@nSelectRecord AS VARCHAR) + ' * 
					from (
						select top ' + CAST(@iNum1 AS VARCHAR) + ' * 
						from dbo.VW_WORK_LIST 
						where Participant_id = '''+@strUserId+'''  
						AND STATE = ''2''  
						AND PROCESS_INSTANCE_VIEW_STATE = ''9''			
						AND ITEMSTATE = ''1''
                       ' + @strWhereForFormsId + '
						' + @strWhereForCondition + '						
						' +@strOrderBy+ '
						) a
					where Participant_id = '''+@strUserId+'''  
					AND STATE = ''2''  
					AND PROCESS_INSTANCE_VIEW_STATE = ''9''			
					AND ITEMSTATE = ''1''
                   ' + @strWhereForFormsId + '
						' + @strWhereForCondition + '						
						' +@strOrderByRevers+ '
		   			) a
				where Participant_id = '''+@strUserId+'''  
				AND STATE = ''2''  
				AND PROCESS_INSTANCE_VIEW_STATE = ''9''			
				AND ITEMSTATE = ''1''
               ' + @strWhereForFormsId + '
						' + @strWhereForCondition + '						
						' +@strOrderBy

END


ELSE IF @strDFType = 'PR'

BEGIN
	--진행함


    -- 전체 레코드 Count 를 Output 으로 리턴함		
	SET @sCountQuery = 'SELECT  count(*) 
						FROM dbo.VW_WORK_LIST 
						WHERE PARTICIPANT_ID = '''+@strUserId+'''
						AND STATE = ''7'' 
						AND PROCESS_INSTANCE_VIEW_STATE = ''3'' 
						AND ITEMSTATE = ''1''
                        ' + @strWhereForFormsId + '
						' + @strWhereForCondition		
	
	--임시테이블 생성후 카운트 쿼리 실행시켜 INSERT 하고
	CREATE TABLE #temp2(sql int)
	INSERT INTO #temp2 exec(@sCountQuery)
	SELECT @iTotalCount = sql FROM #temp2
	DROP TABLE #temp2	
	
	
	----------------------실제로 조회해야할 레코드 카운트 계산----------------------
	--총 레코드 카운트가 이론적인 총 레코드 카운트(현재페이지*페이지사이즈)보다 작을때 
	--총 레코드 수에서 이전 페이지까지의 레코드 수를 빼서 나머지 필요한 레코드 카운트를 구한다.
	
	IF @iTotalCount < (@iNum1)
	BEGIN
		SET @nSelectRecord = @iTotalCount - ( (@nCurPage - 1) * @nRowPerPage )
	END
	----------------------반환할 레코드 카운트가 1 미만인 경우----------------------
	IF @nSelectRecord < 1
	BEGIN
		SET @nSelectRecord = 0
		SET @iNum1 =0
	END
	
		
	
	--[공통]---------------------------------------------------		
	-- 소팅컬럼의 값이 0이 넘어오면 기본값으로 정렬
	if @strSortColumn = '0'	
		Begin
			SET @strOrderBy = ' ORDER BY COMPLETED_DATE DESC'
		end

	else
		begin
			SET @strOrderBy = ' ORDER BY '+@strSortColumn+' '+@strSortOrder+ ' , ITEMCREATE_DATE DESC'
		end

	-- 소팅컬럼의 값이 0이 넘어오면 기본값으로 정렬
	if @strSortColumn = '0'	
		Begin
			SET @strOrderByRevers = ' ORDER BY COMPLETED_DATE ASC'
		end

	else
		begin
			SET @strSortOrderRevers =
			(
				CASE @strSortOrder
					WHEN 'ASC'		
							THEN	'DESC'
					WHEN 'DESC'	
							THEN	'ASC'				
				END 
			)	
			
			SET @strOrderByRevers = ' ORDER BY '+@strSortColumn+' '+@strSortOrderRevers+ ' , ITEMCREATE_DATE ASC'
		end	
	--[공통]---------------------------------------------------


	SET @sQuery =	
		'SELECT	'+
				'a.ITEMOID,'+
				'a.IsUrgent,'+ 
				'a.Status,'+
				'a.ISATTACHFILE,'+
				'a.PostScript,'+
				'a.CATEGORYNAME,'+
				'a.SUBJECT,'+
				'a.DOC_LEVEL,'+        -- 2005.03.08 KJJ : DOC_LEVEL 을 DOC_NUMBER로 변경
				'a.CREATOR,'+
				'a.CREATOR_DEPT,'+
				'SUBSTRING(CONVERT(VARCHAR,a.COMPLETED_DATE,21),0,17) as COMPLETED_DATE,'+
				'a.OPEN_YN,'+
				'a.OID,'+
				'a.Ref_Doc, '+
				'a.ATTACH_EXTENSION, '+
				'a.CREATOR_ID, '+
				'a.DOC_NUMBER '+
         		
		'FROM  (
			select top ' + CAST(@nSelectRecord AS VARCHAR) + ' * 
			from (
				select top ' + CAST(@iNum1 AS VARCHAR) + ' * 
				from dbo.VW_WORK_LIST 
				where Participant_id = '''+@strUserId+'''  
				AND STATE = ''7''  
				AND PROCESS_INSTANCE_VIEW_STATE = ''3''			
				AND ITEMSTATE = ''1''
                ' + @strWhereForFormsId + '
						' + @strWhereForCondition + '						
						' +@strOrderBy+ '
				) a
			where Participant_id = '''+@strUserId+'''  
			AND STATE = ''7''  
			AND PROCESS_INSTANCE_VIEW_STATE = ''3''			
			AND ITEMSTATE = ''1''
            ' + @strWhereForFormsId + '
						' + @strWhereForCondition + '						
						' +@strOrderByRevers+ '
		   	) a
		where Participant_id = '''+@strUserId+'''  
		AND STATE = ''7''  
		AND PROCESS_INSTANCE_VIEW_STATE = ''3''			
		AND ITEMSTATE = ''1''
         ' + @strWhereForFormsId + '
						' + @strWhereForCondition + '						
						' +@strOrderBy

END

ELSE IF @strDFType = 'CO'

BEGIN
	--완료함
	
    -- 전체 레코드 Count 를 Output 으로 리턴함		
	SET @sCountQuery = 'SELECT count(*) 
						FROM dbo.VW_WORK_LIST 
						WHERE PARTICIPANT_ID = '''+@strUserId+'''
							AND STATE = ''7'' 
							AND PROCESS_INSTANCE_VIEW_STATE = ''7''
                           ' + @strWhereForFormsId + '
						' + @strWhereForCondition		
							
	--임시테이블 생성후 카운트 쿼리 실행시켜 INSERT 하고
	CREATE TABLE #temp3(sql int)
	INSERT INTO #temp3 exec(@sCountQuery)
	SELECT @iTotalCount = sql FROM #temp3
	DROP TABLE #temp3
	
	
	----------------------실제로 조회해야할 레코드 카운트 계산----------------------
	--총 레코드 카운트가 이론적인 총 레코드 카운트(현재페이지*페이지사이즈)보다 작을때 
	--총 레코드 수에서 이전 페이지까지의 레코드 수를 빼서 나머지 필요한 레코드 카운트를 구한다.
	
	IF @iTotalCount < (@iNum1)
	BEGIN
		SET @nSelectRecord = @iTotalCount - ( (@nCurPage - 1) * @nRowPerPage )
	END
	----------------------반환할 레코드 카운트가 1 미만인 경우----------------------
	IF @nSelectRecord < 1
	BEGIN
		SET @nSelectRecord = 0
		SET @iNum1 =0
	END
								
	--[공통]---------------------------------------------------		
	-- 소팅컬럼의 값이 0이 넘어오면 기본값으로 정렬
	if @strSortColumn = '0'	
		Begin
			SET @strOrderBy = ' ORDER BY VIEW_COMPLETE_DATE DESC'
		end

	else
		begin
			SET @strOrderBy = ' ORDER BY '+@strSortColumn+' '+@strSortOrder+ ' , ITEMCREATE_DATE DESC'
		end

	-- 소팅컬럼의 값이 0이 넘어오면 기본값으로 정렬
	if @strSortColumn = '0'	
		Begin
			SET @strOrderByRevers = ' ORDER BY VIEW_COMPLETE_DATE ASC'
		end

	else
		begin
			SET @strSortOrderRevers =
			(
				CASE @strSortOrder
					WHEN 'ASC'		
							THEN	'DESC'
					WHEN 'DESC'	
							THEN	'ASC'				
				END 
			)	
			
			SET @strOrderByRevers = ' ORDER BY '+@strSortColumn+' '+@strSortOrderRevers+ ' , ITEMCREATE_DATE ASC'
		end	
	--[공통]---------------------------------------------------
								
	
	
	
	SET @sQuery =	
				'SELECT	'+
						'a.ITEMOID,'+
						'a.IsUrgent,'+ 
						'a.Status,'+
						'a.ISATTACHFILE,'+
						'a.PostScript,'+
						'a.CATEGORYNAME,'+
						'a.SUBJECT,'+
						'a.DOC_LEVEL,'+        -- 2005.03.08 KJJ : DOC_LEVEL 을 DOC_NUMBER로 변경
						'a.CREATOR,'+
						'a.CREATOR_DEPT,'+ 
						'SUBSTRING(CONVERT(VARCHAR,a.VIEW_COMPLETE_DATE,21),0,17) as VIEW_COMPLETE_DATE,'+
						'a.OPEN_YN,'+
						'a.OID,'+
						'a.Ref_Doc, '+
						'a.ATTACH_EXTENSION, '+
						'a.CREATOR_ID, '+
						'a.DOC_NUMBER '+
                   			
				'FROM  (
					select top ' + CAST(@nSelectRecord AS VARCHAR) + ' * 
					from (
						select top ' + CAST(@iNum1 AS VARCHAR) + ' * 
						from dbo.VW_WORK_LIST 
						where Participant_id = '''+@strUserId+'''  
						AND STATE = ''7''  
						AND PROCESS_INSTANCE_VIEW_STATE = ''7''	
                        ' + @strWhereForFormsId + '
						' + @strWhereForCondition + '						
						' +@strOrderBy+ '
						) a
					where Participant_id = '''+@strUserId+'''  
					AND STATE = ''7''  
					AND PROCESS_INSTANCE_VIEW_STATE = ''7''	
                     ' + @strWhereForFormsId + '
						' + @strWhereForCondition + '						
						' +@strOrderByRevers+ '
		   			) a
				where Participant_id = '''+@strUserId+'''  
				AND STATE = ''7''  
				AND PROCESS_INSTANCE_VIEW_STATE = ''7''
                 ' + @strWhereForFormsId + '
						' + @strWhereForCondition + '						
						' +@strOrderBy

END

ELSE IF @strDFType = 'RE'

BEGIN
	--반려함
	
    -- 전체 레코드 Count 를 Output 으로 리턴함
	SET @sCountQuery = 'SELECT  count(*)
			FROM dbo.VW_WORK_LIST
			WHERE PARTICIPANT_ID = '''+@strUserId+'''
				AND STATE = ''7''
				AND PROCESS_INSTANCE_VIEW_STATE = ''8''
				AND ITEMSTATE = ''7''
               ' + @strWhereForFormsId + '
						' + @strWhereForCondition		
	
	
	--임시테이블 생성후 카운트 쿼리 실행시켜 INSERT 하고
	CREATE TABLE #temp4(sql int)
	INSERT INTO #temp4 exec(@sCountQuery)
	SELECT @iTotalCount = sql FROM #temp4
	DROP TABLE #temp4
	
	
	----------------------실제로 조회해야할 레코드 카운트 계산----------------------
	--총 레코드 카운트가 이론적인 총 레코드 카운트(현재페이지*페이지사이즈)보다 작을때 
	--총 레코드 수에서 이전 페이지까지의 레코드 수를 빼서 나머지 필요한 레코드 카운트를 구한다.
	
	IF @iTotalCount < (@iNum1)
	BEGIN
		SET @nSelectRecord = @iTotalCount - ( (@nCurPage - 1) * @nRowPerPage )
	END
	----------------------반환할 레코드 카운트가 1 미만인 경우----------------------
	IF @nSelectRecord < 1
	BEGIN
		SET @nSelectRecord = 0
		SET @iNum1 =0
	END
	
	
	
	--[공통]---------------------------------------------------		
	-- 소팅컬럼의 값이 0이 넘어오면 기본값으로 정렬
	if @strSortColumn = '0'	
		Begin
			SET @strOrderBy = ' ORDER BY VIEW_COMPLETE_DATE DESC'
		end

	else
		begin
			SET @strOrderBy = ' ORDER BY '+@strSortColumn+' '+@strSortOrder+ ' , ITEMCREATE_DATE DESC'
		end

	-- 소팅컬럼의 값이 0이 넘어오면 기본값으로 정렬
	if @strSortColumn = '0'	
		Begin
			SET @strOrderByRevers = ' ORDER BY VIEW_COMPLETE_DATE ASC'
		end

	else
		begin
			SET @strSortOrderRevers =
			(
				CASE @strSortOrder
					WHEN 'ASC'		
							THEN	'DESC'
					WHEN 'DESC'	
							THEN	'ASC'				
				END 
			)	
			
			SET @strOrderByRevers = ' ORDER BY '+@strSortColumn+' '+@strSortOrderRevers+ ' , ITEMCREATE_DATE ASC'
		end	
	--[공통]---------------------------------------------------
	

	
	
	SET @sQuery ='SELECT '+
			'a.ITEMOID,'+
			'a.IsUrgent,'+ 
			'a.Status,'+
			'a.ISATTACHFILE,'+ 
			'a.PostScript,'+
			'a.CATEGORYNAME,'+
			'a.SUBJECT,'+
			'a.DOC_LEVEL,'+         -- 2005.03.08 KJJ : DOC_LEVEL 을 DOC_NUMBER로 변경
			'a.CREATOR,'+
			'a.CREATOR_DEPT,'+
			'SUBSTRING(CONVERT(VARCHAR,a.VIEW_COMPLETE_DATE,21),0,17) as VIEW_COMPLETE_DATE,'+
			'a.OPEN_YN,'+
			'a.OID,'+
			'a.Ref_Doc, '+
			'a.ATTACH_EXTENSION, '+			
			'a.CREATOR_ID, '+
			'a.DOC_NUMBER '+
      
		'FROM  (
			select top ' + CAST(@nSelectRecord AS VARCHAR) + ' * 
			from (
				select top ' + CAST(@iNum1 AS VARCHAR) + ' * 
				from dbo.VW_WORK_LIST 
				where Participant_id = '''+@strUserId+'''  
				AND STATE = ''7''  
				AND PROCESS_INSTANCE_VIEW_STATE = ''8''		
				AND ITEMSTATE = ''7''	
                 ' + @strWhereForFormsId + '
						' + @strWhereForCondition + '						
						' +@strOrderBy+ '
				) a
			where Participant_id = '''+@strUserId+'''  
			AND STATE = ''7''  
			AND PROCESS_INSTANCE_VIEW_STATE = ''8''		
			AND ITEMSTATE = ''7''	
            ' + @strWhereForFormsId + '
						' + @strWhereForCondition + '						
						' +@strOrderByRevers+ '
		   	) a
		where Participant_id = '''+@strUserId+'''  
		AND STATE = ''7''  
		AND PROCESS_INSTANCE_VIEW_STATE = ''8''		
		AND ITEMSTATE = ''7''	
         ' + @strWhereForFormsId + '
						' + @strWhereForCondition + '						
						' +@strOrderBy

END


ELSE IF @strDFType = 'ST'

BEGIN
-- 임시보관함

    -- 전체 레코드 Count 를 Output 으로 리턴함
	SET @sCountQuery = 'SELECT count(*)  
			FROM WF_FORM_STORAGE ST(NOLOCK)
			inner join dbo.WF_FORMS WF
				on ST.FORM_ID = WF.FORM_ID
			WHERE  DELETE_DATE = ''9999-12-31 00:00:00.000''
				AND UserID = '''+@strUserId+''' 
               			' + @strWhereForFormsId + '
						' + @strWhereForCondition	

	--임시테이블 생성후 카운트 쿼리 실행시켜 INSERT 하고
	CREATE TABLE #temp5(sql int)
	INSERT INTO #temp5 exec(@sCountQuery)
	SELECT @iTotalCount = sql FROM #temp5
	DROP TABLE #temp5			
				

	-- 소팅컬럼의 값이 0이 넘어오면 기본값으로 정렬
	/*IF @strSortColumn = '0'	
		BEGIN
			SET @strOrderBy = ' ORDER BY CREATE_DATE  DESC'	
		END
	ELSE
		BEGIN
			SET @strOrderBy = ' ORDER BY '+@strSortColumn+' '+@strSortOrder
		END
*/

----------------------실제로 조회해야할 레코드 카운트 계산----------------------
	--총 레코드 카운트가 이론적인 총 레코드 카운트(현재페이지*페이지사이즈)보다 작을때 
	--총 레코드 수에서 이전 페이지까지의 레코드 수를 빼서 나머지 필요한 레코드 카운트를 구한다.
	
	IF @iTotalCount < (@iNum1)
	BEGIN
		SET @nSelectRecord = @iTotalCount - ( (@nCurPage - 1) * @nRowPerPage )
	END
	----------------------반환할 레코드 카운트가 1 미만인 경우----------------------
	IF @nSelectRecord < 1
	BEGIN
		SET @nSelectRecord = 0
		SET @iNum1 =0
	END
	
	
	
	--[공통]---------------------------------------------------		
	-- 소팅컬럼의 값이 0이 넘어오면 기본값으로 정렬
	if @strSortColumn = '0'	
		Begin
			SET @strOrderBy = ' ORDER BY CREATE_DATE DESC'
		end

	else
		begin
			SET @strOrderBy = ' ORDER BY '+@strSortColumn+' '+@strSortOrder
		end

	
	--[공통]---------------------------------------------------


	SET @sQuery = 'SELECT  bb.PROCESS_ID,'+
					'(SELECT Form_Name FROM dbo.WF_FORMS s WHERE s.FORM_ID = bb.FORM_ID) as FORM_NAME,'+
					'bb.USERID,'+
					'bb.SUBJECT,'+
					'bb.DEPTID,'+
					'bb.DESCRIPTION,'+
					'SUBSTRING(CONVERT(VARCHAR,bb.CREATE_DATE,21),0,17) as CREATE_DATE '+
			'FROM 
				(	SELECT a.*  
					FROM 
						(
							SELECT top ' + CAST(@iNum1 AS VARCHAR) + ' ST.Process_ID, ST.CREATE_DATE as CREATE_DATE
							FROM WF_FORM_STORAGE ST(NOLOCK)
							inner join dbo.WF_FORMS WF
								on ST.FORM_ID = WF.FORM_ID
							WHERE UserID = '''+@strUserId+'''
								AND DELETE_DATE = ''9999-12-31 00:00:00.000''
                                						 ' + @strWhereForFormsId + '
						' + @strWhereForCondition + '
					   		' +@strOrderBy+ '
						) a
						LEFT OUTER JOIN(
							SELECT Top ' + CAST(@iNum2 AS VARCHAR) + ' ST.Process_ID, ST.CREATE_DATE as CREATE_DATE
							FROM WF_FORM_STORAGE ST(NOLOCK)
							inner join dbo.WF_FORMS WF
								on ST.FORM_ID = WF.FORM_ID
							WHERE UserID = '''+@strUserId+'''
								AND DELETE_DATE = ''9999-12-31 00:00:00.000''
                                						 ' + @strWhereForFormsId + '
						' + @strWhereForCondition + '
		   					' +@strOrderBy+ '
 						) b
						on a.Process_ID = b.Process_ID
						WHERE b.Process_ID Is null
				) aa 
			INNER join WF_FORM_STORAGE bb (nolock)  
			ON bb.PROCESS_ID = aa.PROCESS_ID  
			WHERE bb.DELETE_DATE = ''9999-12-31 00:00:00.000'''
			



END

ELSE IF @strDFType = 'P'
	
BEGIN
--업무협조함

    -- 전체 레코드 Count 를 Output 으로 리턴함
	SET @sCountQuery = 'SELECT count(*) 
			FROM dbo.VW_WORK_LIST 
			WHERE  PARTICIPANT_ID = '''+@strUserDeptId+'_'+@strDFType+'''
				AND STATE = ''7''	
				AND PROCESS_INSTANCE_VIEW_STATE = ''3''
               ' + @strWhereForFormsId + '
						' + @strWhereForCondition		



	--임시테이블 생성후 카운트 쿼리 실행시켜 INSERT 하고
	CREATE TABLE #temp6(sql int)
	INSERT INTO #temp6 exec(@sCountQuery)
	SELECT @iTotalCount = sql FROM #temp6
	DROP TABLE #temp6
	
	
	----------------------실제로 조회해야할 레코드 카운트 계산----------------------
	--총 레코드 카운트가 이론적인 총 레코드 카운트(현재페이지*페이지사이즈)보다 작을때 
	--총 레코드 수에서 이전 페이지까지의 레코드 수를 빼서 나머지 필요한 레코드 카운트를 구한다.
	
	IF @iTotalCount < (@iNum1)
	BEGIN
		SET @nSelectRecord = @iTotalCount - ( (@nCurPage - 1) * @nRowPerPage )
	END
	----------------------반환할 레코드 카운트가 1 미만인 경우----------------------
	IF @nSelectRecord < 1
	BEGIN
		SET @nSelectRecord = 0
		SET @iNum1 =0
	END
	
	
	
	--[공통]---------------------------------------------------		
	-- 소팅컬럼의 값이 0이 넘어오면 기본값으로 정렬
	if @strSortColumn = '0'	
		Begin
			SET @strOrderBy = ' ORDER BY COMPLETED_DATE DESC'
		end

	else
		begin
			SET @strOrderBy = ' ORDER BY '+@strSortColumn+' '+@strSortOrder+ ' , ITEMCREATE_DATE DESC'
		end

	-- 소팅컬럼의 값이 0이 넘어오면 기본값으로 정렬
	if @strSortColumn = '0'	
		Begin
			SET @strOrderByRevers = ' ORDER BY COMPLETED_DATE ASC'
		end

	else
		begin
			SET @strSortOrderRevers =
			(
				CASE @strSortOrder
					WHEN 'ASC'		
							THEN	'DESC'
					WHEN 'DESC'	
							THEN	'ASC'				
				END 
			)	
			
			SET @strOrderByRevers = ' ORDER BY '+@strSortColumn+' '+@strSortOrderRevers+ ' , ITEMCREATE_DATE ASC'
		end	
	--[공통]---------------------------------------------------
	

	SET @sQuery =	

		'SELECT	'+
			'a.ITEMOID,'+ 
			'a.IsUrgent,'+ 
			'a.Status,'+
			'a.ISATTACHFILE,'+
			'a.PostScript,'+
			'a.CATEGORYNAME,'+
			'a.SUBJECT,'+
			'a.DOC_LEVEL,'+        -- 2005.03.08 KJJ : DOC_LEVEL 을 DOC_NUMBER로 변경
			'a.CREATOR,'+
			'a.CREATOR_DEPT,'+
			'SUBSTRING(CONVERT(VARCHAR,a.COMPLETED_DATE,21),0,17) as COMPLETED_DATE,'+
			'a.OPEN_YN,'+
			'a.OID,'+
			'a.Ref_Doc, '+
			'a.ATTACH_EXTENSION, '+			
			'a.CREATOR_ID, '+
			'a.DOC_NUMBER '+
          --  'a.U_SLIP_NUMBER '+			
		'FROM  (
			select top ' + CAST(@nSelectRecord AS VARCHAR) + ' * 
			from (
				select top ' + CAST(@iNum1 AS VARCHAR) + ' * 
				from dbo.VW_WORK_LIST 
				where Participant_id = '''+@strUserDeptId+'_'+@strDFType+''' 
				AND STATE = ''7''  
				AND PROCESS_INSTANCE_VIEW_STATE = ''3''
                ' + @strWhereForFormsId + '
						' + @strWhereForCondition + '
				' +@strOrderBy+ '
				) a
			where Participant_id = '''+@strUserDeptId+'_'+@strDFType+''' 
			AND STATE = ''7''  
			AND PROCESS_INSTANCE_VIEW_STATE = ''3''
             ' + @strWhereForFormsId + '
						' + @strWhereForCondition + '				
			' +@strOrderByRevers+ '
		   	) a
		where Participant_id = '''+@strUserDeptId+'_'+@strDFType+''' 
		AND STATE = ''7''  
		AND PROCESS_INSTANCE_VIEW_STATE = ''3''	
         ' + @strWhereForFormsId + '
						' + @strWhereForCondition + '		   	
		' +@strOrderBy	
			




			

END


ELSE IF @strDFType = 'S'
	--발신함
BEGIN

    -- 전체 레코드 Count 를 Output 으로 리턴함
	SET @sCountQuery = 'SELECT	count(*) 
				FROM dbo.VW_WORK_LIST 
				WHERE  PARTICIPANT_ID = '''+@strUserDeptId+'_'+@strDFType+'''
					AND STATE = ''7''	
					AND PROCESS_INSTANCE_VIEW_STATE = ''3''
                    ' + @strWhereForFormsId + '
						' + @strWhereForCondition		


	--임시테이블 생성후 카운트 쿼리 실행시켜 INSERT 하고
	CREATE TABLE #temp7(sql int)
	INSERT INTO #temp7 exec(@sCountQuery)
	SELECT @iTotalCount = sql FROM #temp7
	DROP TABLE #temp7
	
	
	----------------------실제로 조회해야할 레코드 카운트 계산----------------------
	--총 레코드 카운트가 이론적인 총 레코드 카운트(현재페이지*페이지사이즈)보다 작을때 
	--총 레코드 수에서 이전 페이지까지의 레코드 수를 빼서 나머지 필요한 레코드 카운트를 구한다.
	
	IF @iTotalCount < (@iNum1)
	BEGIN
		SET @nSelectRecord = @iTotalCount - ( (@nCurPage - 1) * @nRowPerPage )
	END
	----------------------반환할 레코드 카운트가 1 미만인 경우----------------------
	IF @nSelectRecord < 1
	BEGIN
		SET @nSelectRecord = 0
		SET @iNum1 =0
	END
	
	
	
	-- 소팅컬럼의 값이 0이 넘어오면 기본값으로 정렬
	if @strSortColumn = '0'	
		Begin
			SET @strOrderBy = ' ORDER BY COMPLETED_DATE DESC'
		end
	
	else
		begin
			SET @strOrderBy = ' ORDER BY '+@strSortColumn+' '+@strSortOrder+' , ITEMCREATE_DATE DESC'
		end
		
		
		
	-------------------------------[공통]---------------------------------------------------
	-- 소팅컬럼의 값이 0이 넘어오면 기본값으로 정렬
	if @strSortColumn = '0'	
		Begin
			SET @strOrderByRevers = ' ORDER BY COMPLETED_DATE ASC'
		end
		
	else
		begin
			SET @strSortOrderRevers =
			(
				CASE @strSortOrder
					WHEN 'ASC'		
							THEN	'DESC'
					WHEN 'DESC'	
							THEN	'ASC'				
				END 
			)	
			
			SET @strOrderByRevers = ' ORDER BY '+@strSortColumn+' '+@strSortOrderRevers+ ' , ITEMCREATE_DATE ASC'
		end	
	-------------------------------[공통]---------------------------------------------------
	


	SET @sQuery ='SELECT '+
			'a.ITEMOID,'+ 
			'a.IsUrgent,'+ 
			'a.Status,'+
			'a.ISATTACHFILE,'+
			'a.PostScript,'+
			'a.CATEGORYNAME,'+
			'a.SUBJECT,'+
			'a.DOC_LEVEL,'+         -- 2005.03.08 KJJ : DOC_LEVEL 을 DOC_NUMBER로 변경
			'a.CREATOR,'+
			'a.CREATOR_DEPT,'+
			'SUBSTRING(CONVERT(VARCHAR,a.COMPLETED_DATE,21),0,17) as COMPLETED_DATE,'+
			'a.OPEN_YN,'+
			'a.OID,'+
			'a.Ref_Doc, '+
			'a.ATTACH_EXTENSION, '+			
			'a.CREATOR_ID, '+
			'a.DOC_NUMBER '+
   		'FROM  (
			select top ' + CAST(@nSelectRecord AS VARCHAR) + ' * 
			from (
				select top ' + CAST(@iNum1 AS VARCHAR) + ' * 
				from dbo.VW_WORK_LIST 
				where Participant_id = '''+@strUserDeptId+'_'+@strDFType+''' 
				AND STATE = ''7''  
				AND PROCESS_INSTANCE_VIEW_STATE = ''3''
                ' + @strWhereForFormsId + '
						' + @strWhereForCondition + '
				' +@strOrderBy+ '
				) a
			where Participant_id = '''+@strUserDeptId+'_'+@strDFType+''' 

			AND STATE = ''7''  
			AND PROCESS_INSTANCE_VIEW_STATE = ''3''
            ' + @strWhereForFormsId + '
						' + @strWhereForCondition + '			
			' +@strOrderByRevers+ '
		   	) a
		where Participant_id = '''+@strUserDeptId+'_'+@strDFType+''' 
		AND STATE = ''7''  
		AND PROCESS_INSTANCE_VIEW_STATE = ''3''
         ' + @strWhereForFormsId + '
						' + @strWhereForCondition + '	   	
		' +@strOrderBy


							

END

ELSE IF @strDFType = 'A'
--품의함
BEGIN

    -- 전체 레코드 Count 를 Output 으로 리턴함
	SET @sCountQuery = 'SELECT	count(*) 
			FROM dbo.VW_WORK_LIST 
			WHERE  PARTICIPANT_ID = '''+@strUserDeptId+'_'+@strDFType+'''
				AND STATE = ''7''	
				AND PROCESS_INSTANCE_VIEW_STATE = ''3''
                ' + @strWhereForFormsId + '
						' + @strWhereForCondition		

	--임시테이블 생성후 카운트 쿼리 실행시켜 INSERT 하고
	CREATE TABLE #temp8(sql int)
	INSERT INTO #temp8 exec(@sCountQuery)
	SELECT @iTotalCount = sql FROM #temp8
	DROP TABLE #temp8
	
	
	----------------------실제로 조회해야할 레코드 카운트 계산----------------------
	--총 레코드 카운트가 이론적인 총 레코드 카운트(현재페이지*페이지사이즈)보다 작을때 
	--총 레코드 수에서 이전 페이지까지의 레코드 수를 빼서 나머지 필요한 레코드 카운트를 구한다.
	
	IF @iTotalCount < (@iNum1)
	BEGIN
		SET @nSelectRecord = @iTotalCount - ( (@nCurPage - 1) * @nRowPerPage )
	END
	----------------------반환할 레코드 카운트가 1 미만인 경우----------------------
	IF @nSelectRecord < 1
	BEGIN
		SET @nSelectRecord = 0
		SET @iNum1 =0
	END
	
	
	
	-- 소팅컬럼의 값이 0이 넘어오면 기본값으로 정렬
	if @strSortColumn = '0'	
		Begin
			SET @strOrderBy = ' ORDER BY COMPLETED_DATE DESC'
		end
	
	else
		begin
			SET @strOrderBy = ' ORDER BY '+@strSortColumn+' '+@strSortOrder+' , ITEMCREATE_DATE DESC'
		end
		
		
		
	-------------------------------[공통]---------------------------------------------------
	-- 소팅컬럼의 값이 0이 넘어오면 기본값으로 정렬
	if @strSortColumn = '0'	
		Begin
			SET @strOrderByRevers = ' ORDER BY COMPLETED_DATE ASC'
		end
		
	else
		begin
			SET @strSortOrderRevers =
			(
				CASE @strSortOrder
					WHEN 'ASC'		
							THEN	'DESC'
					WHEN 'DESC'	
							THEN	'ASC'				
				END 
			)	
			
			SET @strOrderByRevers = ' ORDER BY '+@strSortColumn+' '+@strSortOrderRevers+ ' , ITEMCREATE_DATE ASC'
		end	
	-------------------------------[공통]---------------------------------------------------
	



	SET @sQuery ='SELECT '+	 
			'a.ITEMOID,'+
			'a.IsUrgent,'+ 
			'a.Status,'+
			'a.ISATTACHFILE,'+
			'a.PostScript,'+
			'a.CATEGORYNAME,'+ 
			'a.SUBJECT,'+
			'a.DOC_LEVEL,'+         -- 2005.03.08 KJJ : DOC_LEVEL 을 DOC_NUMBER로 변경
			'a.CREATOR,'+
			'a.CREATOR_DEPT,'+
			'SUBSTRING(CONVERT(VARCHAR,a.COMPLETED_DATE,21),0,17) as COMPLETED_DATE,'+
			'a.OPEN_YN,'+
			'a.OID,'+
			'a.Ref_Doc, '+
			'a.ATTACH_EXTENSION, '+			
			'a.CREATOR_ID, '+
			'a.DOC_NUMBER '+
          --  'a.U_SLIP_NUMBER '+			
		'FROM  (
			select top ' + CAST(@nSelectRecord AS VARCHAR) + ' * 
			from (
				select top ' + CAST(@iNum1 AS VARCHAR) + ' * 
				from dbo.VW_WORK_LIST 
				where Participant_id = '''+@strUserDeptId+'_'+@strDFType+''' 
				AND STATE = ''7''  
				AND PROCESS_INSTANCE_VIEW_STATE = ''3''
                ' + @strWhereForFormsId + '
						' + @strWhereForCondition + '
				' +@strOrderBy+ '
				) a
			where Participant_id = '''+@strUserDeptId+'_'+@strDFType+''' 
			AND STATE = ''7''  
			AND PROCESS_INSTANCE_VIEW_STATE = ''3''	
            ' + @strWhereForFormsId + '
						' + @strWhereForCondition + '
			' +@strOrderByRevers+ '			

		   	) a 
		where Participant_id = '''+@strUserDeptId+'_'+@strDFType+''' 
		AND STATE = ''7''  
		AND PROCESS_INSTANCE_VIEW_STATE = ''3''	
        ' + @strWhereForFormsId + '
						' + @strWhereForCondition + '	   	
		' +@strOrderBy	

END



ELSE IF @strDFType = 'R' or @strDFType = 'K'
	--수신함
BEGIN

    -- 전체 레코드 Count 를 Output 으로 리턴함
	SET @sCountQuery = 'SELECT count(*) 
						FROM dbo.VW_WORK_LIST 
						WHERE  PARTICIPANT_ID = '''+@strUserDeptId+'_'+@strDFType+'''
							AND STATE = ''2''
							AND PROCESS_INSTANCE_VIEW_STATE = ''3''
                           ' + @strWhereForFormsId + '
						' + @strWhereForCondition		


	--임시테이블 생성후 카운트 쿼리 실행시켜 INSERT 하고
	CREATE TABLE #temp9(sql int)
	INSERT INTO #temp9 exec(@sCountQuery)
	SELECT @iTotalCount = sql FROM #temp9
	DROP TABLE #temp9
	
	
	----------------------실제로 조회해야할 레코드 카운트 계산----------------------
	--총 레코드 카운트가 이론적인 총 레코드 카운트(현재페이지*페이지사이즈)보다 작을때 
	--총 레코드 수에서 이전 페이지까지의 레코드 수를 빼서 나머지 필요한 레코드 카운트를 구한다.
	
	IF @iTotalCount < (@iNum1)
	BEGIN
		SET @nSelectRecord = @iTotalCount - ( (@nCurPage - 1) * @nRowPerPage )
	END
	----------------------반환할 레코드 카운트가 1 미만인 경우----------------------
	IF @nSelectRecord < 1
	BEGIN
		SET @nSelectRecord = 0
		SET @iNum1 =0
	END
	
	
	
	--[공통]---------------------------------------------------		

	-- 소팅컬럼의 값이 0이 넘어오면 기본값으로 정렬
	if @strSortColumn = '0'	
		Begin
			SET @strOrderBy = ' ORDER BY CREATE_DATE DESC'
		end

	else
		begin
			SET @strOrderBy = ' ORDER BY '+@strSortColumn+' '+@strSortOrder+ ' , ITEMCREATE_DATE DESC'
		end

	-- 소팅컬럼의 값이 0이 넘어오면 기본값으로 정렬
	if @strSortColumn = '0'	
		Begin
			SET @strOrderByRevers = ' ORDER BY CREATE_DATE ASC'
		end

	else
		begin
			SET @strSortOrderRevers =
			(
				CASE @strSortOrder
					WHEN 'ASC'		
							THEN	'DESC'
					WHEN 'DESC'	
							THEN	'ASC'				
				END 
			)	
			
			SET @strOrderByRevers = ' ORDER BY '+@strSortColumn+' '+@strSortOrderRevers+ ' , ITEMCREATE_DATE ASC'
		end	
	--[공통]---------------------------------------------------
	

	
	SET @sQuery ='SELECT '+
			'a.ITEMOID,'+
			'a.IsUrgent,'+ 
			'a.Status,'+
			'a.ISATTACHFILE,'+
			'a.PostScript,'+
			'a.CATEGORYNAME,'+ 
			'a.SUBJECT,'+
			'a.DOC_LEVEL,'+        -- 2005.03.08 KJJ : DOC_LEVEL 을 DOC_NUMBER로 변경
			'a.CREATOR,'+
			'a.CREATOR_DEPT,'+
			'SUBSTRING(CONVERT(VARCHAR,a.CREATE_DATE,21),0,17) as CREATE_DATE,'+
			'a.OPEN_YN,'+
			'a.OID,'+
			'a.Ref_Doc, '+
			'a.ATTACH_EXTENSION, '+			
			'a.CREATOR_ID, '+
			'a.DOC_NUMBER '+
          --  'a.U_SLIP_NUMBER '+			
		'FROM  (
			select top ' + CAST(@nSelectRecord AS VARCHAR) + ' * 
			from (
				select top ' + CAST(@iNum1 AS VARCHAR) + ' * 
				from dbo.VW_WORK_LIST 
				where Participant_id = '''+@strUserDeptId+'_'+@strDFType+''' 
				AND STATE = ''2''  
				AND PROCESS_INSTANCE_VIEW_STATE = ''3''
                ' + @strWhereForFormsId + '
						' + @strWhereForCondition + '
				' +@strOrderBy+ '
				) a
			where Participant_id = '''+@strUserDeptId+'_'+@strDFType+''' 
			AND STATE = ''2''  
			AND PROCESS_INSTANCE_VIEW_STATE = ''3''
            ' + @strWhereForFormsId + '
						' + @strWhereForCondition + '				
			' +@strOrderByRevers+ '
		   	) a
		where Participant_id = '''+@strUserDeptId+'_'+@strDFType+''' 
		AND STATE = ''2''  
		AND PROCESS_INSTANCE_VIEW_STATE = ''3''
         ' + @strWhereForFormsId + '
						' + @strWhereForCondition + '		   	
		' +@strOrderBy

END
ELSE IF @strDFType = 'PA'
	--예결함
BEGIN

    -- 전체 레코드 Count 를 Output 으로 리턴함
	SET @sCountQuery = 	'SELECT count(*)
				FROM dbo.VW_PR_LIST(nolock)
				where USER_ID = ''' + @strUserId + '''	
				AND ACTION_TYPE = ''2''  		
                           			' + @strWhereForFormsId + '
						' + @strWhereForCondition		

	--임시테이블 생성후 카운트 쿼리 실행시켜 INSERT 하고
	CREATE TABLE #temp10(sql int)
	INSERT INTO #temp10 exec(@sCountQuery)
	SELECT @iTotalCount = sql FROM #temp10
	DROP TABLE #temp10

	----------------------실제로 조회해야할 레코드 카운트 계산----------------------
	--총 레코드 카운트가 이론적인 총 레코드 카운트(현재페이지*페이지사이즈)보다 작을때 
	--총 레코드 수에서 이전 페이지까지의 레코드 수를 빼서 나머지 필요한 레코드 카운트를 구한다.
	
	IF @iTotalCount < (@iNum1)
	BEGIN
		SET @nSelectRecord = @iTotalCount - ( (@nCurPage - 1) * @nRowPerPage )
	END
	----------------------반환할 레코드 카운트가 1 미만인 경우----------------------
	IF @nSelectRecord < 1
	BEGIN
		SET @nSelectRecord = 0
		SET @iNum1 =0
	END
	
	
	
	-- 소팅컬럼의 값이 0이 넘어오면 기본값으로 정렬
	if @strSortColumn = '0'	
		Begin
			SET @strOrderBy = ' ORDER BY CREATE_DATE DESC'
		end

	else if @strSortColumn = 'CREATE_DATE'	
		begin
			SET @strOrderBy = ' ORDER BY '+@strSortColumn+' '+@strSortOrder
		end
	
	else
		begin
			SET @strOrderBy = ' ORDER BY '+@strSortColumn+' '+@strSortOrder+' , CREATE_DATE DESC'
		end
		
		
		
	-------------------------------[공통]---------------------------------------------------
	-- 소팅컬럼의 값이 0이 넘어오면 기본값으로 정렬
	if @strSortColumn = '0'	
		Begin
			SET @strOrderByRevers = ' ORDER BY CREATE_DATE ASC'
		end

	else
		begin
			SET @strSortOrderRevers =
			(
				CASE @strSortOrder
					WHEN 'ASC'		
							THEN	'DESC'
					WHEN 'DESC'	
							THEN	'ASC'				
				END 
			)	
			
			if @strSortColumn = 'CREATE_DATE'
			   BEGIN	
				SET @strOrderByRevers = ' ORDER BY '+@strSortColumn+' '+@strSortOrderRevers
			   END
			else
			   BEGIN	
				SET @strOrderByRevers = ' ORDER BY '+@strSortColumn+' '+@strSortOrderRevers+ ' , CREATE_DATE ASC'
			   END

		end	
	-------------------------------[공통]---------------------------------------------------

	SET @sQuery =	'SELECT	 
			a.ITEMOID,	 	
			a.ISURGENT, 
			a.STATUS, 
			a.ISATTACHFILE, 
			a.POSTSCRIPT, 
			a.CATEGORYNAME, 
			a.SUBJECT,  
			a.DOC_LEVEL, 
			a.CREATOR, 
			a.CREATOR_DEPT, 
			SUBSTRING(CONVERT(VARCHAR,a.CREATE_DATE,21),0,20) as CREATE_DATE,
			'''' as OPEN_YN,
			'''' as OID,
			a.REF_DOC,
			a.ATTACH_EXTENSION,
			a.CREATOR_ID,
			a.DOC_NUMBER 			
			
		FROM  (
			select top ' + CAST(@nSelectRecord AS VARCHAR) + ' * 
			from (
				select top ' + CAST(@iNum1 AS VARCHAR) + ' * 
				from dbo.VW_PR_LIST(nolock)
				where USER_ID = '''+@strUserId+''' 
				AND ACTION_TYPE = ''2''
				' + @strWhereForFormsId + '
				' + @strWhereForCondition + '  
				' +@strOrderBy+ '
				) a
			where USER_ID = '''+@strUserId+'''
			' + @strWhereForFormsId + '
			' + @strWhereForCondition + '
			' +@strOrderByRevers+ '
		   	) a
		where USER_ID = '''+@strUserId+'''
		' + @strWhereForFormsId + '
		' + @strWhereForCondition + '
		' +@strOrderBy		

END
Else If	@strDFType = 'RF'	--	회람문서함
Begin

	Declare	@wFormID	varchar(33),
			@CreateDate	datetime

	Select	@sQuery = '',
			@CreateDate	= ''
	
	--	7:완료, 8:반려, 1:진행(3도 포함)
	IF	@wState = '1'
		SET	@wState = "'1','3'"
	ELSE IF	@wState IN ('7', '8')
		SET	@wState = "'" + @wState + "'"
	ELSE
		SET	@wState = ""

--	Drop	Table	#List
	Create	Table	#List
	(
		ProcessID					char(33),
		Process_Instance_View_State	char(33)
	)

	If	@strFormsId = 'ALLFORM'
	Begin

		While (1 = 1)
		Begin
		
			Select	Top 1
					@wFormID	= f.Form_ID,
					@CreateDate	= f.Create_Date
			From	eWFForm.dbo.WF_Forms f
			Where	f.Current_Forms = 'Y'
				and	f.Create_Date > @CreateDate
			Order by f.Create_Date
	
			If	@@RowCount = 0	Break
	
			Set	@sQuery = "
				Insert	Into #List
					Select	Process_ID, Process_Instance_State
					From	eWFForm.dbo.Form_" + @wFormID + "
					Where	Referencer_Code like '%" + Convert(char(6), @strUserId) + "%'
				"

			--	상태조건 추가
			IF	@wState <> ''
				Set	@sQuery = @sQuery + 'and	Process_Instance_State in (' + @wState + ')'

			--	검색조건 추가
			IF	@strCondition <> ''
				Set	@sQuery = @sQuery + "	AND	" + @strCondition + " LIKE '%" + @strKeyword + "%'"
	
		--	print @sQuery
			Exec (@sQuery)
	
		End

	End
	Else
	Begin

		Set	@strFormsId = Replace(@strFormsId, '"', '')

		Set	@sQuery = "
			Insert	Into #List
				Select	Process_ID, Process_Instance_State
				From	eWFForm.dbo.Form_" + @strFormsId + "
				Where	Referencer_Code like '%" + Convert(char(6), @strUserId) + "%'
			"

		--	상태조건 추가
		IF	@wState <> ''
			Set	@sQuery = @sQuery + 'and	Process_Instance_State in (' + @wState + ')'

			--	검색조건 추가
		IF	@strCondition <> ''
			Set	@sQuery = @sQuery + "	AND	" + @strCondition + " LIKE '%" + @strKeyword + "%'"

	--	print @sQuery
		Exec (@sQuery)

	End

	/*----------------------실제로 조회해야할 레코드 카운트 계산----------------------
	총 레코드 카운트가 이론적인 총 레코드 카운트(현재페이지*페이지사이즈)보다 작을때 
	총 레코드 수에서 이전 페이지까지의 레코드 수를 빼서 나머지 필요한 레코드 카운트를 구한다.
	*/

	IF	@iTotalCount < (@iNum1)
	BEGIN
		SET @nSelectRecord = @iTotalCount - ((@nCurPage - 1) * @nRowPerPage)
	END

	----------------------반환할 레코드 카운트가 1 미만인 경우----------------------
	IF @nSelectRecord < 1
	BEGIN
		SET @nSelectRecord = 0
		SET @iNum1 =0
	END

	-- 소팅컬럼의 값이 0이 넘어오면 기본값으로 정렬
	IF	@strSortColumn = '0' or @strSortColumn = '12'
		Begin
			Set	@strOrderBy = ' Order By Create_Date ' + @strSortOrder
		End
	Else
		Begin
			Set	@strOrderBy = ' Order By ' + @strSortColumn + ' ' + @strSortOrder

			If	@strSortColumn <> '12'
				Set	@strOrderBy = @strOrderBy + ', Create_Date ' + @strSortOrder
		End

	-------------------------------[공통]---------------------------------------------------
	Set	@strSortOrderRevers =
	(
		Case	@strSortOrder
			When	'ASC'		
					Then	'DESC'
			When	'DESC'	
					Then	'ASC'				
		End
	)
	-- 소팅컬럼의 값이 0이 넘어오면 기본값으로 정렬
	IF	@strSortColumn = '0' or @strSortColumn = '12'
	Begin
		Set	@strOrderByRevers = ' Order By Create_Date ' + @strSortOrderRevers
	End
	Else
	Begin
		Set	@strOrderByRevers = ' Order By ' + @strSortColumn + ' ' + @strSortOrderRevers
		Set	@strOrderByRevers = @strOrderByRevers + ', Create_Date ' + @strSortOrder
	END

	Set	@sQuery	= "
		Select	Count(*)
		From	#List l
				Join	eWF.dbo.Process_Instance p (nolock)
					On	p.Oid = l.ProcessID
				Join	eWFForm.dbo.Wf_Forms_Prop f (nolock)
					On	f.Process_ID = l.ProcessID
		"
	--	Set	@sQuery	= @sQuery + @strWhereForCondition

	CREATE TABLE #RFtemp(sql int)
	INSERT INTO #RFtemp exec(@sQuery)
	SELECT @iTotalCount = sql FROM #RFtemp
	DROP TABLE #RFtemp

	Set	@sQuery	= "
		Select	ITEMOID, 	Referencer_Confirm_YN,	ISURGENT,			STATUS,	ISATTACHFILE,	POSTSCRIPT,	CATEGORYNAME,	SUBJECT,
				Case
					When	Process_Instance_View_State	in ('1', '3')	Then
						'진행'
					When	Process_Instance_View_State	in ('7')	Then
						'완료'
					When	Process_Instance_View_State	in ('8')	Then
						'반려'
					ELSE
						''
				End	State,
				CREATOR, 	CREATOR_DEPT,
		 		SUBSTRING(CONVERT(VARCHAR(20), CREATE_DATE, 21), 3, 14)		AS CREATE_DATE,
		 		SUBSTRING(CONVERT(VARCHAR(20), COMPLETED_DATE, 21), 3, 14)	AS COMPLETED_DATE,
			 	OPEN_YN,	OID,	REF_DOC,	ATTACH_EXTENSION,	CREATOR_ID,	DOC_NUMBER	--	,	
		From	(
				Select	Top " + CAST(@nSelectRecord AS VARCHAR) + " *
				From	(
						Select	Top " + CAST(@iNum1 AS VARCHAR) + "
								p.OID as ITEMOID,
								CASE
									WHEN	C.Process_Instance_OID IS NULL	THEN	''
									ELSE	'확인'
								END	Referencer_Confirm_YN, 
								f.ISURGENT,
								f.STATUS,
								f.ISATTACHFILE,
								f.POSTSCRIPT,
								f.DOC_NAME as CATEGORYNAME,
								f.SUBJECT,
								f.DOC_LEVEL,
								p.CREATOR, 
								p.CREATOR_DEPT, 
								p.CREATE_DATE, 
								p.COMPLETED_DATE,
								'N'	as OPEN_YN,
								p.OID	as OID,
								f.REF_DOC,
								f.ATTACH_EXTENSION,
								p.CREATOR_ID,
								f.DOC_NUMBER,
								l.Process_Instance_View_State
						From	#List l
								Join	eWF.dbo.Process_Instance p (nolock)
									On	p.Oid = l.ProcessID
								Join	eWFForm.dbo.Wf_Forms_Prop f (nolock)
									On	f.Process_ID = l.ProcessID
								LEFT OUTER JOIN	eWFForm.dbo.WF_Referencer_Confirm C (NOLOCK)
									ON	C.Process_Instance_OID = l.ProcessID
						" + @strOrderBy
					+  ") a
				" + @strOrderByRevers
			+  ") a
		" + @strOrderBy

End
ELSE
	--기타
BEGIN

    -- 전체 레코드 Count 를 Output 으로 리턴함
	SET @sCountQuery = 'SELECT	count(*) 
				FROM dbo.VW_WORK_LIST 
				WHERE  PARTICIPANT_ID = '''+@strUserDeptId+'_'+@strDFType+'''
					AND STATE = ''7''	
					AND PROCESS_INSTANCE_VIEW_STATE = ''3''
                    ' + @strWhereForFormsId + '
						' + @strWhereForCondition		

	--임시테이블 생성후 카운트 쿼리 실행시켜 INSERT 하고
	CREATE TABLE #temp0(sql int)
	INSERT INTO #temp0 exec(@sCountQuery)
	SELECT @iTotalCount = sql FROM #temp0
	DROP TABLE #temp0
	
	
	----------------------실제로 조회해야할 레코드 카운트 계산----------------------
	--총 레코드 카운트가 이론적인 총 레코드 카운트(현재페이지*페이지사이즈)보다 작을때 
	--총 레코드 수에서 이전 페이지까지의 레코드 수를 빼서 나머지 필요한 레코드 카운트를 구한다.
	
	IF @iTotalCount < (@iNum1)
	BEGIN
		SET @nSelectRecord = @iTotalCount - ( (@nCurPage - 1) * @nRowPerPage )
	END
	----------------------반환할 레코드 카운트가 1 미만인 경우----------------------
	IF @nSelectRecord < 1
	BEGIN
		SET @nSelectRecord = 0
		SET @iNum1 =0
	END
	
	
	
	--[공통]---------------------------------------------------		

	-- 소팅컬럼의 값이 0이 넘어오면 기본값으로 정렬
	if @strSortColumn = '0'	
		Begin
			SET @strOrderBy = ' ORDER BY COMPLETED_DATE DESC'
		end

	else
		begin
			SET @strOrderBy = ' ORDER BY '+@strSortColumn+' '+@strSortOrder+ ' , ITEMCREATE_DATE DESC'
		end

	-- 소팅컬럼의 값이 0이 넘어오면 기본값으로 정렬
	if @strSortColumn = '0'	
		Begin
			SET @strOrderByRevers = ' ORDER BY COMPLETED_DATE ASC'
		end

	else
		begin
			SET @strSortOrderRevers =
			(
				CASE @strSortOrder
					WHEN 'ASC'		
							THEN	'DESC'
					WHEN 'DESC'	
							THEN	'ASC'				
				END 
			)	
			
			SET @strOrderByRevers = ' ORDER BY '+@strSortColumn+' '+@strSortOrderRevers+ ' , ITEMCREATE_DATE ASC'
		end	

	--[공통]---------------------------------------------------
	
	

	SET @sQuery ='SELECT '+
			'a.ITEMOID,'+
			'a.IsUrgent,'+ 
			'a.Status,'+
			'a.ISATTACHFILE,'+
			'a.PostScript,'+
			'a.CATEGORYNAME,'+
			'a.SUBJECT,'+
			'a.DOC_LEVEL,'+        -- 2005.03.08 KJJ : DOC_LEVEL 을 DOC_NUMBER로 변경
			'a.CREATOR,'+
			'a.CREATOR_DEPT,'+
			'SUBSTRING(CONVERT(VARCHAR,a.COMPLETED_DATE,21),0,17) as COMPLETED_DATE,'+
			'a.OPEN_YN,'+
			'a.OID,'+
			'a.Ref_Doc, '+
			'a.ATTACH_EXTENSION, '+			
			'a.CREATOR_ID, '+
			'a.DOC_NUMBER '+
      --      'a.U_SLIP_NUMBER '+			
		'FROM  (
			select top ' + CAST(@nSelectRecord AS VARCHAR) + ' * 
			from (
				select top ' + CAST(@iNum1 AS VARCHAR) + ' * 
				from dbo.VW_WORK_LIST 
				where Participant_id = '''+@strUserDeptId+'_'+@strDFType+''' 
				AND STATE = ''7''  
				AND PROCESS_INSTANCE_VIEW_STATE = ''3''
                ' + @strWhereForFormsId + '
						' + @strWhereForCondition + '
				' +@strOrderBy+ '
				) a
			where Participant_id = '''+@strUserDeptId+'_'+@strDFType+''' 
			AND STATE = ''7''  
			AND PROCESS_INSTANCE_VIEW_STATE = ''3''
            ' + @strWhereForFormsId + '
						' + @strWhereForCondition + '			
			' +@strOrderByRevers+ '
		   	) a
		where Participant_id = '''+@strUserDeptId+'_'+@strDFType+''' 
		AND STATE = ''7''  
		AND PROCESS_INSTANCE_VIEW_STATE = ''3''
        ' + @strWhereForFormsId + '
						' + @strWhereForCondition + '	   	
		' +@strOrderBy	
						
END


--EXEC (@sQuery + @like + @strOrderBy)


--임시테이블 생성후 카운트 쿼리 실행시켜 INSERT 하고
--CREATE TABLE #temp(sql int)
--INSERT INTO #temp exec(@sCountQuery)
--SELECT @iTotalCount = sql FROM #temp
--DROP TABLE #temp

print (@sQuery)
EXEC (@sQuery)

RETURN




GO
/****** Object:  StoredProcedure [dbo].[UP_LIST_VW_WORKLIST_DOCUMENTLISTSEARCH_DATE]    Script Date: 2015-10-15 오후 1:30:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO




/*----------------------------------------------------------------------
-- 작성자: 마성옥
-- 작성일: 2004.03.10
-- 수정일: 2004.07.02
-- 설  명: 각 결재함 리스트 쿼리
-- 테스트: 

--사용자ID,사용자부서ID,결재함종류,검색조건,검색어,현재페이지,블록(페이지)당표시건수,정렬필드,정렬방법,전체결재건수(Output)
declare @P1 int
set @P1=0
exec dbo.UP_LIST_VW_WORKLIST_DOCUMENTLISTSEARCH_DATE @strUserId = '133342', @strUserDeptId = '2972', @strDFType = 'RF', @strCondition = 'CREATOR_DEPT|7/E', @strKeyword = '전', @nCurPage = 1, @nRowPerPage = 50, @strSortColumn = '0', @strSortOrder = 'ASC', @strSDate = '2008-01-01', @strEDate = '2008-11-21', @strFormsId = 'ALLFORM', @iTotalCount = @P1 output
select @P1

declare @P1 int
set @P1=34
exec dbo.UP_LIST_VW_WORKLIST_DOCUMENTLISTSEARCH_DATE @strUserId = '133342', @strUserDeptId = '2972', @strDFType = 'RF', @strCondition = '|/E', @strKeyword = '', @nCurPage = 2, @nRowPerPage = 10, @strSortColumn = '0', @strSortOrder = 'DESC', @strSDate = '2007-10-01', @strEDate = '2008-12-31', @strFormsId = 'ALLFORM', @iTotalCount = @P1 output
select @P1

----------------------------------------------------------------------*/
CREATE	PROCEDURE	[dbo].[UP_LIST_VW_WORKLIST_DOCUMENTLISTSEARCH_DATE]
		-- 사용자ID,사용자부서ID,결재함종류,검색조건,검색어,현재페이지,블록(페이지)당표시건수,정렬필드,정렬방법,전체결재건수(Output)
		@strUserId varchar(20),
		@strUserDeptId varchar(20),
		@strDFType varchar(5),
		@strCondition varchar(20),
		@strKeyword varchar(50),
		@nCurPage int, 
		@nRowPerPage int,
		@strSortColumn varchar(20),
		@strSortOrder varchar(5),
		@strSDate varchar(50),
		@strEDate varchar(50),
		@strFormsId varchar(1000),    --양식별 검색(신철호)
		@iTotalCount int output

AS
SET NOCOUNT ON

DECLARE @iNum1 	INT
DECLARE @iNum2 	INT
DECLARE @sQuery VARCHAR(8000)
DECLARE @strOrderBy VARCHAR(100)
DECLARE @sCountQuery VARCHAR(3000)

DECLARE @strOrderByRevers VARCHAR(100)
DECLARE @strSortOrderRevers CHAR(4)
DECLARE @nSelectRecord INT		-- 실제로 반환할 레코드 수
DECLARE @strWhereForFormsId VARCHAR(1000) --양식별 검색조건 문(신철호)

-- @strCondition 파라메터에 검색조건과 결재진행상태, 날짜조건이 같이 넘어오므로 문자열을 분리한다.
-- declare	@strCondition	varchar(100)
-- set		@strCondition = 'CREATOR_DEPT|7/S'	
DECLARE	@wState		VARCHAR(10),
		@wDateType	VARCHAR(20)
SELECT	@wDateType	= SUBSTRING(@strCondition, CHARINDEX('/', @strCondition)+1, 1),
		@wState	= SUBSTRING(@strCondition, CHARINDEX('|', @strCondition)+1, 1),
		@strCondition = SUBSTRING(@strCondition, 1, CHARINDEX('|', @strCondition)-1)

--select	@wDateType, @wState, @strCondition
--	@nCNT	int
SET @iNum1 = @nCurPage * @nRowPerPage
SET @iNum2 = (@nCurPage-1) * @nRowPerPage
SET @nSelectRecord = @nRowPerPage

--	FORM_ID WHERE 조건 구문을 만든다.
IF	@strFormsId = 'ALLFORM'
    SET @strWhereForFormsId = ''
ELSE
    SET @strWhereForFormsId = 'AND FORM_ID in (' + @strFormsId + ')'

SET @strWhereForFormsId = REPLACE(@strWhereForFormsId,'"','''')

IF @strDFType = 'AP'
BEGIN
	--결재함
    -- 전체 레코드 Count 를 Output 으로 리턴함
	SET @sCountQuery = 'SELECT count(*) 
						FROM dbo.VW_WORK_LIST 
						WHERE PARTICIPANT_ID = '''+@strUserId+''' 
						AND STATE = ''2'' 
						AND PROCESS_INSTANCE_VIEW_STATE = ''3'' 
						AND ITEMSTATE = ''1''	
                        ' + @strWhereForFormsId + '	
                        AND CREATE_DATE >= '''+@strSDate+''' AND CREATE_DATE <= '''+@strEDate+' 23:59:59'''

	--임시테이블 생성후 카운트 쿼리 실행시켜 INSERT 하고
	CREATE       TABLE #temp(sql int)
	INSERT INTO #temp exec(@sCountQuery)
	SELECT @iTotalCount = sql FROM #temp
	DROP TABLE #temp

	----------------------실제로 조회해야할 레코드 카운트 계산----------------------
	--총 레코드 카운트가 이론적인 총 레코드 카운트(현재페이지*페이지사이즈)보다 작을때 
	--총 레코드 수에서 이전 페이지까지의 레코드 수를 빼서 나머지 필요한 레코드 카운트를 구한다.
	IF @iTotalCount < (@iNum1)
	BEGIN
		SET @nSelectRecord = @iTotalCount - ( (@nCurPage - 1) * @nRowPerPage )
	END
	----------------------반환할 레코드 카운트가 1 미만인 경우----------------------
	IF @nSelectRecord < 1
	BEGIN
		SET @nSelectRecord = 0
		SET @iNum1 =0
	END

	--[공통]---------------------------------------------------		
	-- 소팅컬럼의 값이 0이 넘어오면 기본값으로 정렬
	if @strSortColumn = '0'	
		SET @strOrderBy = ' ORDER BY CREATE_DATE DESC'
	else
		SET @strOrderBy = ' ORDER BY '+@strSortColumn+' '+@strSortOrder+ ' , ITEMCREATE_DATE DESC'

	-- 소팅컬럼의 값이 0이 넘어오면 기본값으로 정렬
	if @strSortColumn = '0'	
		Begin
			SET @strOrderByRevers = ' ORDER BY CREATE_DATE ASC'
		end

	else
		begin
			SET @strSortOrderRevers =
			(
				CASE @strSortOrder
					WHEN 'ASC'		
							THEN	'DESC'
					WHEN 'DESC'	
							THEN	'ASC'				
				END 
			)	
			
			SET @strOrderByRevers = ' ORDER BY '+@strSortColumn+' '+@strSortOrderRevers+ ' , ITEMCREATE_DATE ASC'
		end	

	--[공통]---------------------------------------------------
	SET @sQuery ='SELECT '+
					'a.ITEMOID,'+
					'a.IsUrgent,'+ 
					'a.Status,'+
					'a.ISATTACHFILE,'+
					'a.PostScript,'+
					'a.CATEGORYNAME,'+
					'a.SUBJECT,'+
					'a.DOC_LEVEL,'+        -- 2005.03.08 KJJ : DOC_LEVEL 을 DOC_NUMBER로 변경
					'a.CREATOR,'+
					'a.CREATOR_DEPT,'+
					'SUBSTRING(CONVERT(varchar,a.CREATE_DATE,21),0,17) as CREATE_DATE,'+
					'a.OPEN_YN,'+
					'a.OID,'+
					'a.Ref_Doc, '+
					'a.ATTACH_EXTENSION, '+
					'a.CREATOR_ID '+
                  --  'a.U_SLIP_NUMBER '+
				'FROM  (
					select top ' + CAST(@nSelectRecord AS VARCHAR) + ' * 
					from (
						select top ' + CAST(@iNum1 AS VARCHAR) + ' * 
						from dbo.VW_WORK_LIST 
						where Participant_id = '''+@strUserId+'''  
						AND STATE = ''2''  
						AND PROCESS_INSTANCE_VIEW_STATE = ''3''			
						AND ITEMSTATE = ''1''
                        ' + @strWhereForFormsId + '	
                        AND CREATE_DATE >= '''+@strSDate+''' AND CREATE_DATE <= '''+@strEDate+' 23:59:59''
						' +@strOrderBy+ '
						) a
					where Participant_id = '''+@strUserId+'''  
					AND STATE = ''2''  
					AND PROCESS_INSTANCE_VIEW_STATE = ''3''			
					AND ITEMSTATE = ''1''
                    ' + @strWhereForFormsId + '	
                    AND CREATE_DATE >= '''+@strSDate+''' AND CREATE_DATE <= '''+@strEDate+' 23:59:59''
					' +@strOrderByRevers+ '
		   			) a
				where Participant_id = '''+@strUserId+'''  
				AND STATE = ''2''  
				AND PROCESS_INSTANCE_VIEW_STATE = ''3''			
				AND ITEMSTATE = ''1''
                ' + @strWhereForFormsId + '	
                AND CREATE_DATE >= '''+@strSDate+''' AND CREATE_DATE <= '''+@strEDate+' 23:59:59''
				' +@strOrderBy					
					
END
ELSE IF @strDFType = 'AF'
BEGIN

	--후결함
    -- 전체 레코드 Count 를 Output 으로 리턴함
	SET @sCountQuery = 'SELECT count(*) 
						FROM dbo.VW_WORK_LIST 
						WHERE PARTICIPANT_ID = '''+@strUserId+''' 
						AND STATE = ''2'' 
						AND PROCESS_INSTANCE_VIEW_STATE = ''9'' 
						AND ITEMSTATE = ''1''	
                        ' + @strWhereForFormsId + '	
                        AND CREATE_DATE >= '''+@strSDate+''' AND CREATE_DATE <= '''+@strEDate+' 23:59:59'''						
--AND '+@strCondition+' LIKE ''%'+@strKeyword+'%'''
						
						
	--임시테이블 생성후 카운트 쿼리 실행시켜 INSERT 하고
	CREATE TABLE #temp1(sql int)
	INSERT INTO #temp1 exec(@sCountQuery)
	SELECT @iTotalCount = sql FROM #temp1
	DROP TABLE #temp1							
	
	----------------------실제로 조회해야할 레코드 카운트 계산----------------------
	--총 레코드 카운트가 이론적인 총 레코드 카운트(현재페이지*페이지사이즈)보다 작을때 
	--총 레코드 수에서 이전 페이지까지의 레코드 수를 빼서 나머지 필요한 레코드 카운트를 구한다.
	
	IF @iTotalCount < (@iNum1)
	BEGIN
		SET @nSelectRecord = @iTotalCount - ( (@nCurPage - 1) * @nRowPerPage )
	END
	----------------------반환할 레코드 카운트가 1 미만인 경우----------------------
	IF @nSelectRecord < 1
	BEGIN
		SET @nSelectRecord = 0
		SET @iNum1 =0
	END
	
	
	
	--[공통]---------------------------------------------------		
	-- 소팅컬럼의 값이 0이 넘어오면 기본값으로 정렬
	if @strSortColumn = '0'	
		Begin
			SET @strOrderBy = ' ORDER BY CREATE_DATE DESC'
		end

	else
		begin
			SET @strOrderBy = ' ORDER BY '+@strSortColumn+' '+@strSortOrder+ ' , ITEMCREATE_DATE DESC'
		end

	-- 소팅컬럼의 값이 0이 넘어오면 기본값으로 정렬
	if @strSortColumn = '0'	
		Begin
			SET @strOrderByRevers = ' ORDER BY CREATE_DATE ASC'
		end

	else
		begin
			SET @strSortOrderRevers =
			(
				CASE @strSortOrder
					WHEN 'ASC'		
							THEN	'DESC'
					WHEN 'DESC'	
							THEN	'ASC'				
				END 

			)	
			
			SET @strOrderByRevers = ' ORDER BY '+@strSortColumn+' '+@strSortOrderRevers+ ' , ITEMCREATE_DATE ASC'
		end	
	--[공통]---------------------------------------------------

	


	SET @sQuery ='SELECT '+
					'a.ITEMOID,'+
					'a.IsUrgent,'+ 
					'a.Status,'+
					'a.ISATTACHFILE,'+
					'a.PostScript,'+
					'a.CATEGORYNAME,'+
					'a.SUBJECT,'+
					'a.DOC_LEVEL,'+        -- 2005.03.08 KJJ : DOC_LEVEL 을 DOC_NUMBER로 변경
					'a.CREATOR,'+
					'a.CREATOR_DEPT,'+
					'SUBSTRING(CONVERT(varchar,a.CREATE_DATE,21),0,17) as CREATE_DATE,'+
					'a.OPEN_YN,'+
					'a.OID,'+
					'a.Ref_Doc, '+
					'a.ATTACH_EXTENSION, '+
					'a.CREATOR_ID '+
                  --  'a.U_SLIP_NUMBER '+
				'FROM  (
					select top ' + CAST(@nSelectRecord AS VARCHAR) + ' * 
					from (
						select top ' + CAST(@iNum1 AS VARCHAR) + ' * 
						from dbo.VW_WORK_LIST 
						where Participant_id = '''+@strUserId+'''  
						AND STATE = ''2''  
						AND PROCESS_INSTANCE_VIEW_STATE = ''9''			
						AND ITEMSTATE = ''1''
                        ' + @strWhereForFormsId + '	
						AND CREATE_DATE >= '''+@strSDate+''' AND CREATE_DATE <= '''+@strEDate+' 23:59:59''
						' +@strOrderBy+ '
						) a
					where Participant_id = '''+@strUserId+'''  
					AND STATE = ''2''  
					AND PROCESS_INSTANCE_VIEW_STATE = ''9''			
					AND ITEMSTATE = ''1''
                    ' + @strWhereForFormsId + '	
                    AND CREATE_DATE >= '''+@strSDate+''' AND CREATE_DATE <= '''+@strEDate+' 23:59:59''				
					' +@strOrderByRevers+ '
		   			) a
				where Participant_id = '''+@strUserId+'''  
				AND STATE = ''2''  
				AND PROCESS_INSTANCE_VIEW_STATE = ''9''			
				AND ITEMSTATE = ''1''
                ' + @strWhereForFormsId + '	
                AND CREATE_DATE >= '''+@strSDate+''' AND CREATE_DATE <= '''+@strEDate+' 23:59:59''	   			
				' +@strOrderBy	

END


ELSE IF @strDFType = 'PR'

BEGIN
	--진행함


    -- 전체 레코드 Count 를 Output 으로 리턴함		
	SET @sCountQuery = 'SELECT  count(*) 
						FROM dbo.VW_WORK_LIST 
						WHERE PARTICIPANT_ID = '''+@strUserId+'''
						AND STATE = ''7'' 
						AND PROCESS_INSTANCE_VIEW_STATE = ''3'' 
						AND ITEMSTATE = ''1''
                        ' + @strWhereForFormsId + '	
						AND COMPLETED_DATE >= '''+@strSDate+''' AND COMPLETED_DATE <= '''+@strEDate+' 23:59:59'''
	
	--임시테이블 생성후 카운트 쿼리 실행시켜 INSERT 하고
	CREATE TABLE #temp2(sql int)
	INSERT INTO #temp2 exec(@sCountQuery)
	SELECT @iTotalCount = sql FROM #temp2
	DROP TABLE #temp2	
	
	
	----------------------실제로 조회해야할 레코드 카운트 계산----------------------
	--총 레코드 카운트가 이론적인 총 레코드 카운트(현재페이지*페이지사이즈)보다 작을때 
	--총 레코드 수에서 이전 페이지까지의 레코드 수를 빼서 나머지 필요한 레코드 카운트를 구한다.
	
	IF @iTotalCount < (@iNum1)
	BEGIN
		SET @nSelectRecord = @iTotalCount - ( (@nCurPage - 1) * @nRowPerPage )
	END
	----------------------반환할 레코드 카운트가 1 미만인 경우----------------------
	IF @nSelectRecord < 1
	BEGIN
		SET @nSelectRecord = 0
		SET @iNum1 =0
	END
	
		
	
	--[공통]---------------------------------------------------		
	-- 소팅컬럼의 값이 0이 넘어오면 기본값으로 정렬
	if @strSortColumn = '0'	
		Begin
			SET @strOrderBy = ' ORDER BY COMPLETED_DATE DESC'
		end

	else
		begin
			SET @strOrderBy = ' ORDER BY '+@strSortColumn+' '+@strSortOrder+ ' , ITEMCREATE_DATE DESC'
		end

	-- 소팅컬럼의 값이 0이 넘어오면 기본값으로 정렬
	if @strSortColumn = '0'	
		Begin
			SET @strOrderByRevers = ' ORDER BY COMPLETED_DATE ASC'
		end

	else
		begin
			SET @strSortOrderRevers =
			(
				CASE @strSortOrder
					WHEN 'ASC'		
							THEN	'DESC'
					WHEN 'DESC'	
							THEN	'ASC'				
				END 
			)	
			
			SET @strOrderByRevers = ' ORDER BY '+@strSortColumn+' '+@strSortOrderRevers+ ' , ITEMCREATE_DATE ASC'
		end	
	--[공통]---------------------------------------------------



	SET @sQuery =	
		'SELECT	'+
				'a.ITEMOID,'+
				'a.IsUrgent,'+ 
				'a.Status,'+
				'a.ISATTACHFILE,'+
				'a.PostScript,'+
				'a.CATEGORYNAME,'+
				'a.SUBJECT,'+
				'a.DOC_LEVEL,'+            -- 2005.03.08 KJJ : DOC_LEVEL 을 DOC_NUMBER로 변경
				'a.CREATOR,'+
				'a.CREATOR_DEPT,'+
				'SUBSTRING(CONVERT(VARCHAR,a.COMPLETED_DATE,21),0,17) as COMPLETED_DATE,'+
				'a.OPEN_YN,'+
				'a.OID,'+
				'a.Ref_Doc, '+
				'a.ATTACH_EXTENSION, '+
				'a.CREATOR_ID '+
             --   'a.U_SLIP_NUMBER '+				
		'FROM  (
			select top ' + CAST(@nSelectRecord AS VARCHAR) + ' * 
			from (
				select top ' + CAST(@iNum1 AS VARCHAR) + ' * 
				from dbo.VW_WORK_LIST 
				where Participant_id = '''+@strUserId+'''  
				AND STATE = ''7''  
				AND PROCESS_INSTANCE_VIEW_STATE = ''3''			
				AND ITEMSTATE = ''1''
                ' + @strWhereForFormsId + '	
				AND COMPLETED_DATE >= '''+@strSDate+''' AND COMPLETED_DATE <= '''+@strEDate+' 23:59:59''
				' +@strOrderBy+ '
				) a
			where Participant_id = '''+@strUserId+'''  
			AND STATE = ''7''  
			AND PROCESS_INSTANCE_VIEW_STATE = ''3''			
			AND ITEMSTATE = ''1''
            ' + @strWhereForFormsId + '	
			AND COMPLETED_DATE >= '''+@strSDate+''' AND COMPLETED_DATE <= '''+@strEDate+' 23:59:59''	
			' +@strOrderByRevers+ '
		   	) a
		where Participant_id = '''+@strUserId+'''  
		AND STATE = ''7''  
		AND PROCESS_INSTANCE_VIEW_STATE = ''3''			
		AND ITEMSTATE = ''1''
        ' + @strWhereForFormsId + '	
		AND COMPLETED_DATE >= '''+@strSDate+''' AND COMPLETED_DATE <= '''+@strEDate+' 23:59:59''  	
		' +@strOrderBy	

END

ELSE IF @strDFType = 'CO'

BEGIN
	--완료함
	
    -- 전체 레코드 Count 를 Output 으로 리턴함		
	SET @sCountQuery = 'SELECT count(*) 
						FROM dbo.VW_WORK_LIST 
						WHERE PARTICIPANT_ID = '''+@strUserId+'''
							AND STATE = ''7'' 
							AND PROCESS_INSTANCE_VIEW_STATE = ''7''
                            ' + @strWhereForFormsId + '
							AND VIEW_COMPLETE_DATE >= '''+@strSDate+''' AND VIEW_COMPLETE_DATE <= '''+@strEDate+' 23:59:59'''
							
	--임시테이블 생성후 카운트 쿼리 실행시켜 INSERT 하고
	CREATE TABLE #temp3(sql int)
	INSERT INTO #temp3 exec(@sCountQuery)
	SELECT @iTotalCount = sql FROM #temp3
	DROP TABLE #temp3
	
	
	----------------------실제로 조회해야할 레코드 카운트 계산----------------------
	--총 레코드 카운트가 이론적인 총 레코드 카운트(현재페이지*페이지사이즈)보다 작을때 
	--총 레코드 수에서 이전 페이지까지의 레코드 수를 빼서 나머지 필요한 레코드 카운트를 구한다.
	
	IF @iTotalCount < (@iNum1)
	BEGIN
		SET @nSelectRecord = @iTotalCount - ( (@nCurPage - 1) * @nRowPerPage )
	END
	----------------------반환할 레코드 카운트가 1 미만인 경우----------------------
	IF @nSelectRecord < 1
	BEGIN
		SET @nSelectRecord = 0
		SET @iNum1 =0
	END
								
	--[공통]---------------------------------------------------		
	-- 소팅컬럼의 값이 0이 넘어오면 기본값으로 정렬
	if @strSortColumn = '0'	
		Begin
			SET @strOrderBy = ' ORDER BY VIEW_COMPLETE_DATE DESC'
		end

	else
		begin
			SET @strOrderBy = ' ORDER BY '+@strSortColumn+' '+@strSortOrder+ ' , ITEMCREATE_DATE DESC'
		end

	-- 소팅컬럼의 값이 0이 넘어오면 기본값으로 정렬
	if @strSortColumn = '0'	
		Begin
			SET @strOrderByRevers = ' ORDER BY VIEW_COMPLETE_DATE ASC'
		end

	else
		begin
			SET @strSortOrderRevers =
			(
				CASE @strSortOrder
					WHEN 'ASC'		
							THEN	'DESC'
					WHEN 'DESC'	
							THEN	'ASC'				
				END 
			)	
			
			SET @strOrderByRevers = ' ORDER BY '+@strSortColumn+' '+@strSortOrderRevers+ ' , ITEMCREATE_DATE ASC'
		end	
	--[공통]---------------------------------------------------
								
	
	
	
	SET @sQuery =	
				'SELECT	'+
						'a.ITEMOID,'+
						'a.IsUrgent,'+ 
						'a.Status,'+
						'a.ISATTACHFILE,'+
						'a.PostScript,'+
						'a.CATEGORYNAME,'+
						'a.SUBJECT,'+
						'a.DOC_LEVEL,'+        -- 2005.03.08 KJJ : DOC_LEVEL 을 DOC_NUMBER로 변경
						'a.CREATOR,'+
						'a.CREATOR_DEPT,'+ 
						'SUBSTRING(CONVERT(VARCHAR,a.VIEW_COMPLETE_DATE,21),0,17) as VIEW_COMPLETE_DATE,'+
						'a.OPEN_YN,'+

						'a.OID,'+
						'a.Ref_Doc, '+
						'a.ATTACH_EXTENSION, '+
    					'a.CREATOR_ID '+
                   --     'a.U_SLIP_NUMBER '+				
				'FROM  (
					select top ' + CAST(@nSelectRecord AS VARCHAR) + ' * 
					from (
						select top ' + CAST(@iNum1 AS VARCHAR) + ' * 

						from dbo.VW_WORK_LIST 
						where Participant_id = '''+@strUserId+'''  
						AND STATE = ''7''  
						AND PROCESS_INSTANCE_VIEW_STATE = ''7''	
                        ' + @strWhereForFormsId + '
						AND VIEW_COMPLETE_DATE >= '''+@strSDate+''' AND VIEW_COMPLETE_DATE <= '''+@strEDate+' 23:59:59''	
						' +@strOrderBy+ '
						) a
					where Participant_id = '''+@strUserId+'''  
					AND STATE = ''7''  
					AND PROCESS_INSTANCE_VIEW_STATE = ''7''	
                    ' + @strWhereForFormsId + '
					AND VIEW_COMPLETE_DATE >= '''+@strSDate+''' AND VIEW_COMPLETE_DATE <= '''+@strEDate+' 23:59:59''						
					' +@strOrderByRevers+ '
		   			) a
				where Participant_id = '''+@strUserId+'''  
				AND STATE = ''7''  
				AND PROCESS_INSTANCE_VIEW_STATE = ''7''
                ' + @strWhereForFormsId + '	
				AND VIEW_COMPLETE_DATE >= '''+@strSDate+''' AND VIEW_COMPLETE_DATE <= '''+@strEDate+' 23:59:59''		   			
				' +@strOrderBy	

END

ELSE IF @strDFType = 'RE'

BEGIN
	--반려함
	
    -- 전체 레코드 Count 를 Output 으로 리턴함
	SET @sCountQuery = 'SELECT  count(*)
			FROM dbo.VW_WORK_LIST
			WHERE PARTICIPANT_ID = '''+@strUserId+'''
				AND STATE = ''7''
				AND PROCESS_INSTANCE_VIEW_STATE = ''8''
				AND ITEMSTATE = ''7''
                ' + @strWhereForFormsId + '
				AND VIEW_COMPLETE_DATE >= '''+@strSDate+''' AND VIEW_COMPLETE_DATE <= '''+@strEDate+' 23:59:59'''
	
	
	--임시테이블 생성후 카운트 쿼리 실행시켜 INSERT 하고
	CREATE TABLE #temp4(sql int)
	INSERT INTO #temp4 exec(@sCountQuery)
	SELECT @iTotalCount = sql FROM #temp4
	DROP TABLE #temp4
	
	
	----------------------실제로 조회해야할 레코드 카운트 계산----------------------
	--총 레코드 카운트가 이론적인 총 레코드 카운트(현재페이지*페이지사이즈)보다 작을때 
	--총 레코드 수에서 이전 페이지까지의 레코드 수를 빼서 나머지 필요한 레코드 카운트를 구한다.
	
	IF @iTotalCount < (@iNum1)
	BEGIN
		SET @nSelectRecord = @iTotalCount - ( (@nCurPage - 1) * @nRowPerPage )
	END
	----------------------반환할 레코드 카운트가 1 미만인 경우----------------------
	IF @nSelectRecord < 1
	BEGIN
		SET @nSelectRecord = 0
		SET @iNum1 =0
	END
	
	
	
	--[공통]---------------------------------------------------		
	-- 소팅컬럼의 값이 0이 넘어오면 기본값으로 정렬
	if @strSortColumn = '0'	
		Begin
			SET @strOrderBy = ' ORDER BY VIEW_COMPLETE_DATE DESC'
		end

	else
		begin
			SET @strOrderBy = ' ORDER BY '+@strSortColumn+' '+@strSortOrder+ ' , ITEMCREATE_DATE DESC'
		end

	-- 소팅컬럼의 값이 0이 넘어오면 기본값으로 정렬
	if @strSortColumn = '0'	
		Begin
			SET @strOrderByRevers = ' ORDER BY VIEW_COMPLETE_DATE ASC'
		end

	else
		begin
			SET @strSortOrderRevers =
			(
				CASE @strSortOrder
					WHEN 'ASC'		
							THEN	'DESC'
					WHEN 'DESC'	
							THEN	'ASC'				
				END 
			)	
			
			SET @strOrderByRevers = ' ORDER BY '+@strSortColumn+' '+@strSortOrderRevers+ ' , ITEMCREATE_DATE ASC'
		end	
	--[공통]---------------------------------------------------
	

	
	
	SET @sQuery ='SELECT '+
			'a.ITEMOID,'+
			'a.IsUrgent,'+ 
			'a.Status,'+
			'a.ISATTACHFILE,'+ 
			'a.PostScript,'+
			'a.CATEGORYNAME,'+
			'a.SUBJECT,'+
			'a.DOC_LEVEL,'+         -- 2005.03.08 KJJ : DOC_LEVEL 을 DOC_NUMBER로 변경
			'a.CREATOR,'+
			'a.CREATOR_DEPT,'+
			'SUBSTRING(CONVERT(VARCHAR,a.VIEW_COMPLETE_DATE,21),0,17) as VIEW_COMPLETE_DATE,'+
			'a.OPEN_YN,'+
			'a.OID,'+
			'a.Ref_Doc, '+
			'a.ATTACH_EXTENSION, '+			
			'a.CREATOR_ID '+
         --   'a.U_SLIP_NUMBER '+		
		'FROM  (
			select top ' + CAST(@nSelectRecord AS VARCHAR) + ' * 
			from (
				select top ' + CAST(@iNum1 AS VARCHAR) + ' * 
				from dbo.VW_WORK_LIST 
				where Participant_id = '''+@strUserId+'''  
				AND STATE = ''7''  
				AND PROCESS_INSTANCE_VIEW_STATE = ''8''		
				AND ITEMSTATE = ''7''	
                ' + @strWhereForFormsId + '

				AND VIEW_COMPLETE_DATE >= '''+@strSDate+''' AND VIEW_COMPLETE_DATE <= '''+@strEDate+' 23:59:59''
				' +@strOrderBy+ '
				) a
			where Participant_id = '''+@strUserId+'''  
			AND STATE = ''7''  
			AND PROCESS_INSTANCE_VIEW_STATE = ''8''		
			AND ITEMSTATE = ''7''	
            ' + @strWhereForFormsId + '
			AND VIEW_COMPLETE_DATE >= '''+@strSDate+''' AND VIEW_COMPLETE_DATE <= '''+@strEDate+' 23:59:59''		
			' +@strOrderByRevers+ '
		   	) a
		where Participant_id = '''+@strUserId+'''  
		AND STATE = ''7''  
		AND PROCESS_INSTANCE_VIEW_STATE = ''8''		
		AND ITEMSTATE = ''7''	
        ' + @strWhereForFormsId + '
		AND VIEW_COMPLETE_DATE >= '''+@strSDate+''' AND VIEW_COMPLETE_DATE <= '''+@strEDate+' 23:59:59''	   	
		' +@strOrderBy	

END


ELSE IF @strDFType = 'ST'

BEGIN
-- 임시보관함

    -- 전체 레코드 Count 를 Output 으로 리턴함
	SET @sCountQuery = 'SELECT count(*)  
			FROM WF_FORM_STORAGE(NOLOCK) 
			WHERE DELETE_DATE = ''9999-12-31 00:00:00.000''
				AND UserID = '''+@strUserId+''' 
                ' + @strWhereForFormsId + '
				AND CREATE_DATE >= '''+@strSDate+''' AND CREATE_DATE <= '''+@strEDate+' 23:59:59'''
	
	--임시테이블 생성후 카운트 쿼리 실행시켜 INSERT 하고
	CREATE TABLE #temp5(sql int)
	INSERT INTO #temp5 exec(@sCountQuery)
	SELECT @iTotalCount = sql FROM #temp5
	DROP TABLE #temp5			
				

	----------------------실제로 조회해야할 레코드 카운트 계산----------------------
	--총 레코드 카운트가 이론적인 총 레코드 카운트(현재페이지*페이지사이즈)보다 작을때 
	--총 레코드 수에서 이전 페이지까지의 레코드 수를 빼서 나머지 필요한 레코드 카운트를 구한다.
	
	IF @iTotalCount < (@iNum1)
	BEGIN
		SET @nSelectRecord = @iTotalCount - ( (@nCurPage - 1) * @nRowPerPage )
	END
	----------------------반환할 레코드 카운트가 1 미만인 경우----------------------
	IF @nSelectRecord < 1
	BEGIN
		SET @nSelectRecord = 0
		SET @iNum1 =0
	END
	
	
	
	--[공통]---------------------------------------------------		
	-- 소팅컬럼의 값이 0이 넘어오면 기본값으로 정렬
	if @strSortColumn = '0'	
		Begin
			SET @strOrderBy = ' ORDER BY CREATE_DATE DESC'
		end

	else
		begin
			SET @strOrderBy = ' ORDER BY '+@strSortColumn+' '+@strSortOrder
		end


	SET @sQuery = 'SELECT  bb.PROCESS_ID,'+
					'(SELECT Form_Name FROM dbo.WF_FORMS s WHERE s.FORM_ID = bb.FORM_ID) as FORM_ID,'+
					'bb.USERID,'+
					'bb.SUBJECT,'+
					'bb.DEPTID,'+
					'bb.DESCRIPTION,'+
					'SUBSTRING(CONVERT(VARCHAR,bb.CREATE_DATE,21),0,17) as CREATE_DATE '+
			'FROM 
				(	SELECT a.*  
					FROM 
						(
							SELECT top ' + CAST(@iNum1 AS VARCHAR) + ' Process_ID, CREATE_DATE
							FROM WF_FORM_STORAGE(NOLOCK)
							WHERE UserID = '''+@strUserId+'''
								AND DELETE_DATE = ''9999-12-31 00:00:00.000''
                                ' + @strWhereForFormsId + '
								AND CREATE_DATE >= '''+@strSDate+''' AND CREATE_DATE <= '''+@strEDate+' 23:59:59''
					   		' +@strOrderBy+ '

						) a
						LEFT OUTER JOIN(
							SELECT Top ' + CAST(@iNum2 AS VARCHAR) + ' Process_ID, CREATE_DATE
							FROM WF_FORM_STORAGE(NOLOCK)
							WHERE UserID = '''+@strUserId+'''
								AND DELETE_DATE = ''9999-12-31 00:00:00.000''
                                ' + @strWhereForFormsId + '
								AND CREATE_DATE >= '''+@strSDate+''' AND CREATE_DATE <= '''+@strEDate+' 23:59:59''
		   					' +@strOrderBy+ '
 						) b
						on a.Process_ID = b.Process_ID
						WHERE b.Process_ID Is null
				) aa 
			INNER join WF_FORM_STORAGE bb (nolock)  
			ON bb.PROCESS_ID = aa.PROCESS_ID  
			WHERE bb.DELETE_DATE = ''9999-12-31 00:00:00.000'''
			



END

ELSE IF @strDFType = 'P'
	
BEGIN
--업무협조함

    -- 전체 레코드 Count 를 Output 으로 리턴함
	SET @sCountQuery = 'SELECT count(*) 
			FROM dbo.VW_WORK_LIST 
			WHERE  PARTICIPANT_ID = '''+@strUserDeptId+'_'+@strDFType+'''
				AND STATE = ''7''	
				AND PROCESS_INSTANCE_VIEW_STATE = ''3''
                ' + @strWhereForFormsId + '
				AND COMPLETED_DATE >= '''+@strSDate+''' AND COMPLETED_DATE <= '''+@strEDate+' 23:59:59'''



	--임시테이블 생성후 카운트 쿼리 실행시켜 INSERT 하고
	CREATE TABLE #temp6(sql int)
	INSERT INTO #temp6 exec(@sCountQuery)
	SELECT @iTotalCount = sql FROM #temp6
	DROP TABLE #temp6
	
	
	----------------------실제로 조회해야할 레코드 카운트 계산----------------------
	--총 레코드 카운트가 이론적인 총 레코드 카운트(현재페이지*페이지사이즈)보다 작을때 
	--총 레코드 수에서 이전 페이지까지의 레코드 수를 빼서 나머지 필요한 레코드 카운트를 구한다.
	
	IF @iTotalCount < (@iNum1)
	BEGIN
		SET @nSelectRecord = @iTotalCount - ( (@nCurPage - 1) * @nRowPerPage )
	END
	----------------------반환할 레코드 카운트가 1 미만인 경우----------------------
	IF @nSelectRecord < 1
	BEGIN
		SET @nSelectRecord = 0
		SET @iNum1 =0
	END
	
	
	
	--[공통]---------------------------------------------------		
	-- 소팅컬럼의 값이 0이 넘어오면 기본값으로 정렬
	if @strSortColumn = '0'	
		Begin
			SET @strOrderBy = ' ORDER BY COMPLETED_DATE DESC'
		end

	else
		begin
			SET @strOrderBy = ' ORDER BY '+@strSortColumn+' '+@strSortOrder+ ' , ITEMCREATE_DATE DESC'
		end

	-- 소팅컬럼의 값이 0이 넘어오면 기본값으로 정렬
	if @strSortColumn = '0'	
		Begin
			SET @strOrderByRevers = ' ORDER BY COMPLETED_DATE ASC'
		end

	else
		begin
			SET @strSortOrderRevers =
			(
				CASE @strSortOrder
					WHEN 'ASC'		
							THEN	'DESC'
					WHEN 'DESC'	
							THEN	'ASC'				
				END 
			)	
			
			SET @strOrderByRevers = ' ORDER BY '+@strSortColumn+' '+@strSortOrderRevers+ ' , ITEMCREATE_DATE ASC'
		end	
	--[공통]---------------------------------------------------
	

	SET @sQuery =	
		'SELECT	'+
			'a.ITEMOID,'+ 
			'a.IsUrgent,'+ 
			'a.Status,'+
			'a.ISATTACHFILE,'+
			'a.PostScript,'+
			'a.CATEGORYNAME,'+
			'a.SUBJECT,'+
			'a.DOC_LEVEL,'+        -- 2005.03.08 KJJ : DOC_LEVEL 을 DOC_NUMBER로 변경
			'a.CREATOR,'+
			'a.CREATOR_DEPT,'+
			'SUBSTRING(CONVERT(VARCHAR,a.COMPLETED_DATE,21),0,17) as COMPLETED_DATE,'+
			'a.OPEN_YN,'+
			'a.OID,'+
			'a.Ref_Doc, '+
			'a.ATTACH_EXTENSION, '+			
			'a.CREATOR_ID '+
       --     'a.U_SLIP_NUMBER '+			
		'FROM  (
			select top ' + CAST(@nSelectRecord AS VARCHAR) + ' * 
			from (
				select top ' + CAST(@iNum1 AS VARCHAR) + ' * 
				from dbo.VW_WORK_LIST 
				where Participant_id = '''+@strUserDeptId+'_'+@strDFType+''' 
				AND STATE = ''7''  
				AND PROCESS_INSTANCE_VIEW_STATE = ''3''	
                ' + @strWhereForFormsId + '
				AND COMPLETED_DATE >= '''+@strSDate+''' AND COMPLETED_DATE <= '''+@strEDate+' 23:59:59''	
				' +@strOrderBy+ '
				) a
			where Participant_id = '''+@strUserDeptId+'_'+@strDFType+''' 
			AND STATE = ''7''  
			AND PROCESS_INSTANCE_VIEW_STATE = ''3''	
            ' + @strWhereForFormsId + '
			AND COMPLETED_DATE >= '''+@strSDate+''' AND COMPLETED_DATE <= '''+@strEDate+' 23:59:59''				
			' +@strOrderByRevers+ '
		   	) a
		where Participant_id = '''+@strUserDeptId+'_'+@strDFType+''' 
		AND STATE = ''7''  
		AND PROCESS_INSTANCE_VIEW_STATE = ''3''	
        ' + @strWhereForFormsId + '
		AND COMPLETED_DATE >= '''+@strSDate+''' AND COMPLETED_DATE <= '''+@strEDate+' 23:59:59''			   	
		' +@strOrderBy	
			




			

END


ELSE IF @strDFType = 'S'
	--발신함
BEGIN

    -- 전체 레코드 Count 를 Output 으로 리턴함
	SET @sCountQuery = 'SELECT	count(*) 
				FROM dbo.VW_WORK_LIST 
				WHERE  PARTICIPANT_ID = '''+@strUserDeptId+'_'+@strDFType+'''
					AND STATE = ''7''	
					AND PROCESS_INSTANCE_VIEW_STATE = ''3''
                    ' + @strWhereForFormsId + '
					AND COMPLETED_DATE >= '''+@strSDate+''' AND COMPLETED_DATE <= '''+@strEDate+' 23:59:59'''


	--임시테이블 생성후 카운트 쿼리 실행시켜 INSERT 하고
	CREATE TABLE #temp7(sql int)
	INSERT INTO #temp7 exec(@sCountQuery)
	SELECT @iTotalCount = sql FROM #temp7
	DROP TABLE #temp7
	
	
	----------------------실제로 조회해야할 레코드 카운트 계산----------------------
	--총 레코드 카운트가 이론적인 총 레코드 카운트(현재페이지*페이지사이즈)보다 작을때 
	--총 레코드 수에서 이전 페이지까지의 레코드 수를 빼서 나머지 필요한 레코드 카운트를 구한다.
	
	IF @iTotalCount < (@iNum1)
	BEGIN
		SET @nSelectRecord = @iTotalCount - ( (@nCurPage - 1) * @nRowPerPage )
	END
	----------------------반환할 레코드 카운트가 1 미만인 경우----------------------
	IF @nSelectRecord < 1
	BEGIN
		SET @nSelectRecord = 0
		SET @iNum1 =0
	END
	

	
	
	-- 소팅컬럼의 값이 0이 넘어오면 기본값으로 정렬
	if @strSortColumn = '0'	
		Begin
			SET @strOrderBy = ' ORDER BY COMPLETED_DATE DESC'
		end
	
	else
		begin
			SET @strOrderBy = ' ORDER BY '+@strSortColumn+' '+@strSortOrder+' , ITEMCREATE_DATE DESC'
		end
		
		
		
	-------------------------------[공통]---------------------------------------------------
	-- 소팅컬럼의 값이 0이 넘어오면 기본값으로 정렬
	if @strSortColumn = '0'	
		Begin
			SET @strOrderByRevers = ' ORDER BY COMPLETED_DATE ASC'
		end
		
	else
		begin
			SET @strSortOrderRevers =
			(
				CASE @strSortOrder
					WHEN 'ASC'		
							THEN	'DESC'
					WHEN 'DESC'	
							THEN	'ASC'				
				END 
			)	
			
			SET @strOrderByRevers = ' ORDER BY '+@strSortColumn+' '+@strSortOrderRevers+ ' , ITEMCREATE_DATE ASC'
		end	
	-------------------------------[공통]---------------------------------------------------
	


	SET @sQuery ='SELECT '+
			'a.ITEMOID,'+ 
			'a.IsUrgent,'+ 
			'a.Status,'+
			'a.ISATTACHFILE,'+
			'a.PostScript,'+
			'a.CATEGORYNAME,'+
			'a.SUBJECT,'+
			'a.DOC_LEVEL,'+         -- 2005.03.08 KJJ : DOC_LEVEL 을 DOC_NUMBER로 변경
			'a.CREATOR,'+
			'a.CREATOR_DEPT,'+
			'SUBSTRING(CONVERT(VARCHAR,a.COMPLETED_DATE,21),0,17) as COMPLETED_DATE,'+
			'a.OPEN_YN,'+
			'a.OID,'+
			'a.Ref_Doc, '+
			'a.ATTACH_EXTENSION, '+			
			'a.CREATOR_ID '+
        --    'a.U_SLIP_NUMBER '+		
		'FROM  (
			select top ' + CAST(@nSelectRecord AS VARCHAR) + ' * 
			from (
				select top ' + CAST(@iNum1 AS VARCHAR) + ' * 
				from dbo.VW_WORK_LIST 
				where Participant_id = '''+@strUserDeptId+'_'+@strDFType+''' 
				AND STATE = ''7''  
				AND PROCESS_INSTANCE_VIEW_STATE = ''3''		
                ' + @strWhereForFormsId + '
				AND COMPLETED_DATE >= '''+@strSDate+''' AND COMPLETED_DATE <= '''+@strEDate+' 23:59:59'' 
				' +@strOrderBy+ '
				) a
			where Participant_id = '''+@strUserDeptId+'_'+@strDFType+''' 
			AND STATE = ''7''  
			AND PROCESS_INSTANCE_VIEW_STATE = ''3''		
            ' + @strWhereForFormsId + '
			AND COMPLETED_DATE >= '''+@strSDate+''' AND COMPLETED_DATE <= '''+@strEDate+' 23:59:59''				
			' +@strOrderByRevers+ '
		   	) a
		where Participant_id = '''+@strUserDeptId+'_'+@strDFType+''' 
		AND STATE = ''7''  
		AND PROCESS_INSTANCE_VIEW_STATE = ''3''		
        ' + @strWhereForFormsId + '
		AND COMPLETED_DATE >= '''+@strSDate+''' AND COMPLETED_DATE <= '''+@strEDate+' 23:59:59''		   	
		' +@strOrderBy


							

END

ELSE IF @strDFType = 'A'
--품의함
BEGIN

    -- 전체 레코드 Count 를 Output 으로 리턴함
	SET @sCountQuery = 'SELECT	count(*) 
			FROM dbo.VW_WORK_LIST 
			WHERE  PARTICIPANT_ID = '''+@strUserDeptId+'_'+@strDFType+'''
				AND STATE = ''7''	
				AND PROCESS_INSTANCE_VIEW_STATE = ''3''
                ' + @strWhereForFormsId + '
				AND COMPLETED_DATE >= '''+@strSDate+''' AND COMPLETED_DATE <= '''+@strEDate+' 23:59:59'''

	--임시테이블 생성후 카운트 쿼리 실행시켜 INSERT 하고
	CREATE TABLE #temp8(sql int)
	INSERT INTO #temp8 exec(@sCountQuery)
	SELECT @iTotalCount = sql FROM #temp8
	DROP TABLE #temp8
	
	
	----------------------실제로 조회해야할 레코드 카운트 계산----------------------
	--총 레코드 카운트가 이론적인 총 레코드 카운트(현재페이지*페이지사이즈)보다 작을때 
	--총 레코드 수에서 이전 페이지까지의 레코드 수를 빼서 나머지 필요한 레코드 카운트를 구한다.
	
	IF @iTotalCount < (@iNum1)
	BEGIN
		SET @nSelectRecord = @iTotalCount - ( (@nCurPage - 1) * @nRowPerPage )
	END
	----------------------반환할 레코드 카운트가 1 미만인 경우----------------------
	IF @nSelectRecord < 1
	BEGIN
		SET @nSelectRecord = 0
		SET @iNum1 =0
	END
	
	
	
	-- 소팅컬럼의 값이 0이 넘어오면 기본값으로 정렬
	if @strSortColumn = '0'	
		Begin
			SET @strOrderBy = ' ORDER BY COMPLETED_DATE DESC'
		end
	
	else
		begin
			SET @strOrderBy = ' ORDER BY '+@strSortColumn+' '+@strSortOrder+' , ITEMCREATE_DATE DESC'
		end
		
		
		
	-------------------------------[공통]---------------------------------------------------
	-- 소팅컬럼의 값이 0이 넘어오면 기본값으로 정렬
	if @strSortColumn = '0'	
		Begin
			SET @strOrderByRevers = ' ORDER BY COMPLETED_DATE ASC'
		end
		
	else
		begin
			SET @strSortOrderRevers =
			(
				CASE @strSortOrder
					WHEN 'ASC'		
							THEN	'DESC'
					WHEN 'DESC'	
							THEN	'ASC'				
				END 
			)	
			
			SET @strOrderByRevers = ' ORDER BY '+@strSortColumn+' '+@strSortOrderRevers+ ' , ITEMCREATE_DATE ASC'
		end	
	-------------------------------[공통]---------------------------------------------------
	



	SET @sQuery ='SELECT '+	 
			'a.ITEMOID,'+
			'a.IsUrgent,'+ 
			'a.Status,'+
			'a.ISATTACHFILE,'+
			'a.PostScript,'+
			'a.CATEGORYNAME,'+ 
			'a.SUBJECT,'+
			'a.DOC_LEVEL,'+         -- 2005.03.08 KJJ : DOC_LEVEL 을 DOC_NUMBER로 변경
			'a.CREATOR,'+
			'a.CREATOR_DEPT,'+
			'SUBSTRING(CONVERT(VARCHAR,a.COMPLETED_DATE,21),0,17) as COMPLETED_DATE,'+
			'a.OPEN_YN,'+
			'a.OID,'+
			'a.Ref_Doc, '+
			'a.ATTACH_EXTENSION, '+			
			'a.CREATOR_ID '+
        --    'a.U_SLIP_NUMBER '+		
		'FROM  (
			select top ' + CAST(@nSelectRecord AS VARCHAR) + ' * 
			from (
				select top ' + CAST(@iNum1 AS VARCHAR) + ' * 

				from dbo.VW_WORK_LIST 
				where Participant_id = '''+@strUserDeptId+'_'+@strDFType+''' 
				AND STATE = ''7''  
				AND PROCESS_INSTANCE_VIEW_STATE = ''3''		
                ' + @strWhereForFormsId + '
				AND COMPLETED_DATE >= '''+@strSDate+''' AND COMPLETED_DATE <= '''+@strEDate+' 23:59:59''
				' +@strOrderBy+ '
				) a
			where Participant_id = '''+@strUserDeptId+'_'+@strDFType+''' 
			AND STATE = ''7''  
			AND PROCESS_INSTANCE_VIEW_STATE = ''3''		
            ' + @strWhereForFormsId + '
			AND COMPLETED_DATE >= '''+@strSDate+''' AND COMPLETED_DATE <= '''+@strEDate+' 23:59:59''
			' +@strOrderByRevers+ '			

		   	) a 
		where Participant_id = '''+@strUserDeptId+'_'+@strDFType+''' 
		AND STATE = ''7''  
		AND PROCESS_INSTANCE_VIEW_STATE = ''3''		
        ' + @strWhereForFormsId + '
		AND COMPLETED_DATE >= '''+@strSDate+''' AND COMPLETED_DATE <= '''+@strEDate+' 23:59:59'' 		   	
		' +@strOrderBy	

END



ELSE IF @strDFType = 'R' or @strDFType = 'K'
	--수신함
BEGIN

    -- 전체 레코드 Count 를 Output 으로 리턴함
	SET @sCountQuery = 'SELECT count(*) 
						FROM dbo.VW_WORK_LIST 
						WHERE  PARTICIPANT_ID = '''+@strUserDeptId+'_'+@strDFType+'''
							AND STATE = ''2''
							AND PROCESS_INSTANCE_VIEW_STATE = ''3''
                            ' + @strWhereForFormsId + '
							AND CREATE_DATE >= '''+@strSDate+''' AND CREATE_DATE <= '''+@strEDate+' 23:59:59'''


	--임시테이블 생성후 카운트 쿼리 실행시켜 INSERT 하고
	CREATE TABLE #temp9(sql int)
	INSERT INTO #temp9 exec(@sCountQuery)
	SELECT @iTotalCount = sql FROM #temp9
	DROP TABLE #temp9
	
	
	----------------------실제로 조회해야할 레코드 카운트 계산----------------------
	--총 레코드 카운트가 이론적인 총 레코드 카운트(현재페이지*페이지사이즈)보다 작을때 
	--총 레코드 수에서 이전 페이지까지의 레코드 수를 빼서 나머지 필요한 레코드 카운트를 구한다.
	
	IF @iTotalCount < (@iNum1)
	BEGIN
		SET @nSelectRecord = @iTotalCount - ( (@nCurPage - 1) * @nRowPerPage )
	END
	----------------------반환할 레코드 카운트가 1 미만인 경우----------------------
	IF @nSelectRecord < 1
	BEGIN
		SET @nSelectRecord = 0
		SET @iNum1 =0
	END
	
	
	
	--[공통]---------------------------------------------------		
	-- 소팅컬럼의 값이 0이 넘어오면 기본값으로 정렬
	if @strSortColumn = '0'	
		Begin
			SET @strOrderBy = ' ORDER BY CREATE_DATE DESC'
		end

	else
		begin
			SET @strOrderBy = ' ORDER BY '+@strSortColumn+' '+@strSortOrder+ ' , ITEMCREATE_DATE DESC'
		end

	-- 소팅컬럼의 값이 0이 넘어오면 기본값으로 정렬
	if @strSortColumn = '0'	
		Begin
			SET @strOrderByRevers = ' ORDER BY CREATE_DATE ASC'
		end

	else
		begin
			SET @strSortOrderRevers =
			(
				CASE @strSortOrder
					WHEN 'ASC'		
							THEN	'DESC'
					WHEN 'DESC'	
							THEN	'ASC'				
				END 
			)	
			
			SET @strOrderByRevers = ' ORDER BY '+@strSortColumn+' '+@strSortOrderRevers+ ' , ITEMCREATE_DATE ASC'
		end	
	--[공통]---------------------------------------------------
	

	
	SET @sQuery ='SELECT '+
			'a.ITEMOID,'+
			'a.IsUrgent,'+ 
			'a.Status,'+
			'a.ISATTACHFILE,'+
			'a.PostScript,'+
			'a.CATEGORYNAME,'+ 
			'a.SUBJECT,'+
			'a.DOC_LEVEL,'+        -- 2005.03.08 KJJ : DOC_LEVEL 을 DOC_NUMBER로 변경
			'a.CREATOR,'+
			'a.CREATOR_DEPT,'+
			'SUBSTRING(CONVERT(VARCHAR,a.CREATE_DATE,21),0,17) as CREATE_DATE,'+
			'a.OPEN_YN,'+
			'a.OID,'+
			'a.Ref_Doc, '+
			'a.ATTACH_EXTENSION, '+			
			'a.CREATOR_ID '+
          --  'a.U_SLIP_NUMBER '+		
		'FROM  (
			select top ' + CAST(@nSelectRecord AS VARCHAR) + ' * 
			from (
				select top ' + CAST(@iNum1 AS VARCHAR) + ' * 
				from dbo.VW_WORK_LIST 
				where Participant_id = '''+@strUserDeptId+'_'+@strDFType+''' 
				AND STATE = ''2''  
				AND PROCESS_INSTANCE_VIEW_STATE = ''3''	
                ' + @strWhereForFormsId + '
				AND CREATE_DATE >= '''+@strSDate+''' AND CREATE_DATE <= '''+@strEDate+' 23:59:59''
				' +@strOrderBy+ '
				) a
			where Participant_id = '''+@strUserDeptId+'_'+@strDFType+''' 
			AND STATE = ''2''  
			AND PROCESS_INSTANCE_VIEW_STATE = ''3''	
            ' + @strWhereForFormsId + '
			AND CREATE_DATE >= '''+@strSDate+''' AND CREATE_DATE <= '''+@strEDate+' 23:59:59''				
			' +@strOrderByRevers+ '
		   	) a
		where Participant_id = '''+@strUserDeptId+'_'+@strDFType+''' 
		AND STATE = ''2''  
		AND PROCESS_INSTANCE_VIEW_STATE = ''3''	
        ' + @strWhereForFormsId + '
		AND CREATE_DATE >= '''+@strSDate+''' AND CREATE_DATE <= '''+@strEDate+' 23:59:59'' 			   	
		' +@strOrderBy

END
ELSE IF @strDFType = 'PA'
	--예결함
BEGIN

    -- 전체 레코드 Count 를 Output 으로 리턴함
	SET @sCountQuery =  	'SELECT count(*)
				FROM dbo.VW_PR_LIST(nolock)
				where USER_ID = ''' + @strUserId + '''	
				AND ACTION_TYPE = ''2''  		
                           			' + @strWhereForFormsId + '	
				AND CREATE_DATE >= '''+@strSDate+''' AND CREATE_DATE <= '''+@strEDate+' 23:59:59'''					


	--임시테이블 생성후 카운트 쿼리 실행시켜 INSERT 하고
	CREATE TABLE #temp10(sql int)
	INSERT INTO #temp10 exec(@sCountQuery)
	SELECT @iTotalCount = sql FROM #temp10
	DROP TABLE #temp10
	
	
	----------------------실제로 조회해야할 레코드 카운트 계산----------------------
	--총 레코드 카운트가 이론적인 총 레코드 카운트(현재페이지*페이지사이즈)보다 작을때 
	--총 레코드 수에서 이전 페이지까지의 레코드 수를 빼서 나머지 필요한 레코드 카운트를 구한다.
	
	IF @iTotalCount < (@iNum1)
	BEGIN
		SET @nSelectRecord = @iTotalCount - ( (@nCurPage - 1) * @nRowPerPage )
	END
	----------------------반환할 레코드 카운트가 1 미만인 경우----------------------
	IF @nSelectRecord < 1
	BEGIN
		SET @nSelectRecord = 0
		SET @iNum1 =0
	END
	
	
	
	--[공통]---------------------------------------------------		
	-- 소팅컬럼의 값이 0이 넘어오면 기본값으로 정렬
	if @strSortColumn = '0'	
		Begin
			SET @strOrderBy = ' ORDER BY CREATE_DATE DESC'
		end

	else if @strSortColumn = 'CREATE_DATE'	
		begin
			SET @strOrderBy = ' ORDER BY '+@strSortColumn+' '+@strSortOrder
		end
	
	else
		begin
			SET @strOrderBy = ' ORDER BY '+@strSortColumn+' '+@strSortOrder+' , CREATE_DATE DESC'
		end
		
		
		
	-------------------------------[공통]---------------------------------------------------
	-- 소팅컬럼의 값이 0이 넘어오면 기본값으로 정렬
	if @strSortColumn = '0'	
		Begin
			SET @strOrderByRevers = ' ORDER BY CREATE_DATE ASC'
		end

	else
		begin
			SET @strSortOrderRevers =
			(
				CASE @strSortOrder
					WHEN 'ASC'		
							THEN	'DESC'
					WHEN 'DESC'	
							THEN	'ASC'				
				END 
			)	
			
			if @strSortColumn = 'CREATE_DATE'
			   BEGIN	
				SET @strOrderByRevers = ' ORDER BY '+@strSortColumn+' '+@strSortOrderRevers
			   END
			else
			   BEGIN	
				SET @strOrderByRevers = ' ORDER BY '+@strSortColumn+' '+@strSortOrderRevers+ ' , CREATE_DATE ASC'
			   END

		end	
	-------------------------------[공통]---------------------------------------------------
	
	SET @sQuery =	'SELECT	 
			a.ITEMOID,	 	
			a.ISURGENT, 
			a.STATUS, 
			a.ISATTACHFILE, 
			a.POSTSCRIPT, 
			a.CATEGORYNAME, 
			a.SUBJECT,  
			a.DOC_LEVEL, 
			a.CREATOR, 
			a.CREATOR_DEPT, 
			SUBSTRING(CONVERT(VARCHAR,a.CREATE_DATE,21),0,20) as CREATE_DATE,
			'''' as OPEN_YN,
			'''' as OID,
			a.REF_DOC,
			a.ATTACH_EXTENSION,
			a.CREATOR_ID			
			
		FROM  (
			select top ' + CAST(@nSelectRecord AS VARCHAR) + ' * 
			from (
				select top ' + CAST(@iNum1 AS VARCHAR) + ' * 
				from dbo.VW_PR_LIST(nolock)
				where USER_ID = '''+@strUserId+''' 
				AND ACTION_TYPE = ''2''
				' + @strWhereForFormsId + '
				AND CREATE_DATE >= '''+@strSDate+''' AND CREATE_DATE <= '''+@strEDate+' 23:59:59''  
				' +@strOrderBy+ '
				) a
			where USER_ID = '''+@strUserId+'''
			' + @strWhereForFormsId + '
			AND CREATE_DATE >= '''+@strSDate+''' AND CREATE_DATE <= '''+@strEDate+' 23:59:59''
			' +@strOrderByRevers+ '
		   	) a
		where USER_ID = '''+@strUserId+'''
		' + @strWhereForFormsId + '
		AND CREATE_DATE >= '''+@strSDate+''' AND CREATE_DATE <= '''+@strEDate+' 23:59:59''
		' +@strOrderBy	

END
Else If	@strDFType = 'RF'	--	회람문서함
Begin

	Declare	@wFormID	varchar(33),
			@CreateDate	datetime,
			@wSqlWhere_Date	varchar(200)

	Select	@sQuery = '',
			@CreateDate	= ''

	--	7:완료, 8:반려, 1:진행(3도 포함)
	IF	@wState = '1'
		SET	@wState = "'1','3'"
	ELSE IF	@wState IN ('7', '8')
		SET	@wState = "'" + @wState + "'"
	ELSE
		SET	@wState = ""

	--	검색날짜 설정 (S:CREATE_DATE, E:COMPLETED_DATE)
	IF	@wDateType = 'S'
		SET	@wDateType = 'CREATE_DATE'
	ELSE
		SET	@wDateType = 'COMPLETED_DATE'

	SET	@wSqlWhere_Date = "	and	p." + @wDateType + " >= '" + @strSDate + "' and P." + @wDateType + " <= '" + @strEDate + " 23:59:59'"

--	Drop	Table	#List
	Create	Table	#List
	(
		ProcessID					char(33),
		Process_Instance_View_State	char(33)
	)

	If	@strFormsId = 'ALLFORM'
	Begin

		While (1 = 1)
		Begin
		
			Select	Top 1
					@wFormID	= f.Form_ID,
					@CreateDate	= f.Create_Date
			From	eWFForm.dbo.WF_Forms f
			Where	f.Current_Forms = 'Y'
				and	f.Create_Date > @CreateDate
			Order by f.Create_Date
	
			If	@@RowCount = 0	Break
	
			Set	@sQuery = "
				Insert	Into #List
					Select	Process_ID, Process_Instance_State
					From	eWFForm.dbo.Form_" + @wFormID + "
					Where	Referencer_Code like '%" + Convert(char(6), @strUserId) + "%'
				"

			--	상태조건 추가
			IF	@wState <> ''
				Set	@sQuery = @sQuery + 'and	Process_Instance_State in (' + @wState + ')'

			--	검색조건 추가
			IF	(@strCondition = 'CREATOR' OR @strCondition = 'CREATOR_DEPT' OR @strCondition = 'SUBJECT')
				Set	@sQuery = @sQuery + "	AND	" + @strCondition + " LIKE '%" + @strKeyword + "%'"

			--print @sQuery
			Exec (@sQuery)
		End
	End
	Else
	Begin

		Set	@strFormsId = Replace(@strFormsId, '"', '')

		Set	@sQuery = "
			Insert	Into #List
				Select	Process_ID, Process_Instance_State
				From	eWFForm.dbo.Form_" + @strFormsId + "
				Where	Referencer_Code like '%" + Convert(char(6), @strUserId) + "%'
			"

		--	상태조건 추가
		IF	@wState <> ''
			Set	@sQuery = @sQuery + 'and	Process_Instance_State in (' + @wState + ')'

			--	검색조건 추가
		IF	(@strCondition = 'CREATOR' OR @strCondition = 'CREATOR_DEPT' OR @strCondition = 'SUBJECT')
			Set	@sQuery = @sQuery + "	AND	" + @strCondition + " LIKE '%" + @strKeyword + "%'"

		--print @sQuery
		Exec (@sQuery)
	End

	-- 소팅컬럼의 값이 0이 넘어오면 기본값으로 정렬
	IF	@strSortColumn = '0' or @strSortColumn = '12' or @strSortColumn = '13'
	BEGIN
		SET	@strOrderBy = ' Order By ' + @wDateType + ' ' + @strSortOrder
	END
	ELSE
	BEGIN
		Set	@strOrderBy = ' Order By ' + @strSortColumn + ' ' + @strSortOrder

		IF	@strSortColumn <> '12'
			SET	@strOrderBy = @strOrderBy + ', Create_Date ' + @strSortOrder
	END

	-------------------------------[공통]---------------------------------------------------
	SET	@strSortOrderRevers =
		(
			Case	@strSortOrder
				When	'ASC'		
						Then	'DESC'
				When	'DESC'	
						Then	'ASC'				
			End
		)

	-- 소팅컬럼의 값이 0이 넘어오면 기본값으로 정렬
	IF	@strSortColumn = '0' or @strSortColumn = '12' or @strSortColumn = '13'
	BEGIN
		SET	@strOrderByRevers = ' Order By ' + @wDateType + ' ' + @strSortOrderRevers
	END
	ELSE
	BEGIN
		Set	@strOrderByRevers = ' Order By ' + @strSortColumn + ' ' + @strSortOrderRevers
		SET	@strOrderByRevers = @strOrderByRevers + ', Create_Date ' + @strSortOrderRevers
	End	

	Set	@sQuery	= "
		Select	Count(*)
		From	#List l
				Join	eWF.dbo.Process_Instance p (nolock)
					On	p.Oid = l.ProcessID
				Join	eWFForm.dbo.Wf_Forms_Prop f (nolock)
					On	f.Process_ID = l.ProcessID
				"
	Set	@sQuery	= @sQuery + @wSqlWhere_Date


	CREATE TABLE #RFtemp(sql int)
	INSERT INTO #RFtemp exec(@sQuery)
	SELECT @iTotalCount = sql FROM #RFtemp
	DROP TABLE #RFtemp

	/*----------------------실제로 조회해야할 레코드 카운트 계산----------------------
	총 레코드 카운트가 이론적인 총 레코드 카운트(현재페이지*페이지사이즈)보다 작을때 
	총 레코드 수에서 이전 페이지까지의 레코드 수를 빼서 나머지 필요한 레코드 카운트를 구한다.
	*/

	IF	@iTotalCount < (@iNum1)
	BEGIN
		SET @nSelectRecord = @iTotalCount - ((@nCurPage - 1) * @nRowPerPage)
	END

	----------------------반환할 레코드 카운트가 1 미만인 경우----------------------
	IF @nSelectRecord < 1
	BEGIN
		SET @nSelectRecord = 0
		SET @iNum1 =0
	END



	Set	@sQuery	= "
		Select	ITEMOID, 	Referencer_Confirm_YN,	ISURGENT,			STATUS,	ISATTACHFILE,	POSTSCRIPT,	CATEGORYNAME,	SUBJECT,
				Case
					When	Process_Instance_View_State	in ('1', '3')	Then
						'진행'
					When	Process_Instance_View_State	in ('7')	Then
						'완료'
					When	Process_Instance_View_State	in ('8')	Then
						'반려'
					ELSE
						''
				End	State,
				CREATOR, 	CREATOR_DEPT,
		 		SUBSTRING(CONVERT(VARCHAR(20), CREATE_DATE, 21), 3, 14)		AS CREATE_DATE,
		 		SUBSTRING(CONVERT(VARCHAR(20), COMPLETED_DATE, 21), 3, 14)	AS COMPLETED_DATE,
			 	OPEN_YN,	OID,	REF_DOC,	ATTACH_EXTENSION,	CREATOR_ID,	DOC_NUMBER
		From	(
				Select	Top " + CAST(@nSelectRecord AS VARCHAR) + " *
				From	(
						Select	Top " + CAST(@iNum1 AS VARCHAR) + "
								p.OID as ITEMOID,
								CASE
									WHEN	C.Process_Instance_OID IS NULL	THEN	''
									ELSE	'확인'
								END	Referencer_Confirm_YN, 
								f.ISURGENT,
								f.STATUS,
								f.ISATTACHFILE,
								f.POSTSCRIPT,
								f.DOC_NAME as CATEGORYNAME,
								f.SUBJECT,
								f.DOC_LEVEL,
								p.CREATOR, 
								p.CREATOR_DEPT, 
								p.CREATE_DATE,
								p.COMPLETED_DATE,
								'N'	as OPEN_YN,
								p.OID	as OID,
								f.REF_DOC,
								f.ATTACH_EXTENSION,
								p.CREATOR_ID,
								f.DOC_NUMBER,
								l.Process_Instance_View_State
						From	#List l
								Join	eWF.dbo.Process_Instance p (nolock)
									On	p.Oid = l.ProcessID
								Join	eWFForm.dbo.Wf_Forms_Prop f (nolock)
									On	f.Process_ID = l.ProcessID
								LEFT OUTER JOIN	eWFForm.dbo.WF_Referencer_Confirm C (NOLOCK)
									ON	C.Process_Instance_OID = l.ProcessID
						WHERE	1 = 1
						" + @wSqlWhere_Date + "
						" + @strOrderBy
					+  ") a
				" + @strOrderByRevers
			+  ") a
		" + @strOrderBy

End
ELSE
BEGIN

    -- 전체 레코드 Count 를 Output 으로 리턴함
	SET @sCountQuery = 'SELECT	count(*) 
				FROM dbo.VW_WORK_LIST 
				WHERE  PARTICIPANT_ID = '''+@strUserDeptId+'_'+@strDFType+'''
					AND STATE = ''7''	
					AND PROCESS_INSTANCE_VIEW_STATE = ''3''
                    ' + @strWhereForFormsId + '
					AND COMPLETED_DATE >= '''+@strSDate+''' AND COMPLETED_DATE <= '''+@strEDate+' 23:59:59'''

	--임시테이블 생성후 카운트 쿼리 실행시켜 INSERT 하고
	CREATE TABLE #temp0(sql int)
	INSERT INTO #temp0 exec(@sCountQuery)
	SELECT @iTotalCount = sql FROM #temp0
	DROP TABLE #temp0
	
	
	----------------------실제로 조회해야할 레코드 카운트 계산----------------------
	--총 레코드 카운트가 이론적인 총 레코드 카운트(현재페이지*페이지사이즈)보다 작을때 
	--총 레코드 수에서 이전 페이지까지의 레코드 수를 빼서 나머지 필요한 레코드 카운트를 구한다.
	
	IF @iTotalCount < (@iNum1)
	BEGIN
		SET @nSelectRecord = @iTotalCount - ( (@nCurPage - 1) * @nRowPerPage )
	END
	----------------------반환할 레코드 카운트가 1 미만인 경우----------------------
	IF @nSelectRecord < 1
	BEGIN
		SET @nSelectRecord = 0
		SET @iNum1 =0
	END
	
	
	
	--[공통]---------------------------------------------------		
	-- 소팅컬럼의 값이 0이 넘어오면 기본값으로 정렬
	if @strSortColumn = '0'	
		Begin
			SET @strOrderBy = ' ORDER BY COMPLETED_DATE DESC'
		end

	else
		begin
			SET @strOrderBy = ' ORDER BY '+@strSortColumn+' '+@strSortOrder+ ' , ITEMCREATE_DATE DESC'
		end

	-- 소팅컬럼의 값이 0이 넘어오면 기본값으로 정렬
	if @strSortColumn = '0'	
		Begin
			SET @strOrderByRevers = ' ORDER BY COMPLETED_DATE ASC'
		end

	else
		begin
			SET @strSortOrderRevers =
			(
				CASE @strSortOrder
					WHEN 'ASC'		
							THEN	'DESC'
					WHEN 'DESC'	
							THEN	'ASC'				
				END 
			)	
			
			SET @strOrderByRevers = ' ORDER BY '+@strSortColumn+' '+@strSortOrderRevers+ ' , ITEMCREATE_DATE ASC'
		end	

	--[공통]---------------------------------------------------
	SET @sQuery ='SELECT '+
			'a.ITEMOID,'+
			'a.IsUrgent,'+ 
			'a.Status,'+
			'a.ISATTACHFILE,'+
			'a.PostScript,'+
			'a.CATEGORYNAME,'+
			'a.SUBJECT,'+
			'a.DOC_LEVEL,'+        -- 2005.03.08 KJJ : DOC_LEVEL 을 DOC_NUMBER로 변경
			'a.CREATOR,'+
			'a.CREATOR_DEPT,'+
			'SUBSTRING(CONVERT(VARCHAR,a.COMPLETED_DATE,21),0,17) as COMPLETED_DATE,'+
			'a.OPEN_YN,'+
			'a.OID,'+
			'a.Ref_Doc, '+
			'a.ATTACH_EXTENSION, '+			
			'a.CREATOR_ID '+
           -- 'a.U_SLIP_NUMBER '+		
		'FROM  (
			select top ' + CAST(@nSelectRecord AS VARCHAR) + ' * 
			from (
				select top ' + CAST(@iNum1 AS VARCHAR) + ' * 
				from dbo.VW_WORK_LIST 
				where Participant_id = '''+@strUserDeptId+'_'+@strDFType+''' 
				AND STATE = ''7''  
				AND PROCESS_INSTANCE_VIEW_STATE = ''3''		
                ' + @strWhereForFormsId + '
				AND COMPLETED_DATE >= '''+@strSDate+''' AND COMPLETED_DATE <= '''+@strEDate+' 23:59:59''
				' +@strOrderBy+ '
				) a
			where Participant_id = '''+@strUserDeptId+'_'+@strDFType+''' 
			AND STATE = ''7''  
			AND PROCESS_INSTANCE_VIEW_STATE = ''3''		
            ' + @strWhereForFormsId + '
			AND COMPLETED_DATE >= '''+@strSDate+''' AND COMPLETED_DATE <= '''+@strEDate+' 23:59:59'' 				
			' +@strOrderByRevers+ '
		   	) a
		where Participant_id = '''+@strUserDeptId+'_'+@strDFType+''' 
		AND STATE = ''7''  
		AND PROCESS_INSTANCE_VIEW_STATE = ''3''		
        ' + @strWhereForFormsId + '
		AND COMPLETED_DATE >= '''+@strSDate+''' AND COMPLETED_DATE <= '''+@strEDate+' 23:59:59'' 		   	
		' +@strOrderBy	

END

print (@sQuery)
EXEC (@sQuery)

RETURN








GO
/****** Object:  StoredProcedure [dbo].[UP_LIST_VW_WORKLIST_DOCUMENTLISTSEARCH_DATE_test]    Script Date: 2015-10-15 오후 1:30:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO



/*----------------------------------------------------------------------
-- 작성자: 마성옥
-- 작성일: 2004.03.10
-- 수정일: 2004.07.02
-- 설  명: 각 결재함 리스트 쿼리
-- 테스트: 

--사용자ID,사용자부서ID,결재함종류,검색조건,검색어,현재페이지,블록(페이지)당표시건수,정렬필드,정렬방법,전체결재건수(Output)
declare @P1 int
set @P1=0
exec dbo.UP_LIST_VW_WORKLIST_DOCUMENTLISTSEARCH_DATE @strUserId = '133342', @strUserDeptId = '2972', @strDFType = 'RF', @strCondition = 'CREATOR_DEPT|7/E', @strKeyword = '전', @nCurPage = 1, @nRowPerPage = 50, @strSortColumn = '0', @strSortOrder = 'ASC', @strSDate = '2008-01-01', @strEDate = '2008-11-21', @strFormsId = 'ALLFORM', @iTotalCount = @P1 output
select @P1

declare @P1 int
set @P1=0
exec dbo.UP_LIST_VW_WORKLIST_DOCUMENTLISTSEARCH_DATE_test @strUserId = '133342', @strUserDeptId = '2974', @strDFType = 'RF', @strCondition = '|/E', @strKeyword = '', @nCurPage = 1, @nRowPerPage = 100, @strSortColumn = '0', @strSortOrder = 'ASC', @strSDate = '2008-12-01', @strEDate = '2008-12-31', @strFormsId = 'ALLFORM', @iTotalCount = @P1 output
select @P1

----------------------------------------------------------------------*/
CREATE	PROCEDURE	[dbo].[UP_LIST_VW_WORKLIST_DOCUMENTLISTSEARCH_DATE_test]
		-- 사용자ID,사용자부서ID,결재함종류,검색조건,검색어,현재페이지,블록(페이지)당표시건수,정렬필드,정렬방법,전체결재건수(Output)
		@strUserId varchar(20),
		@strUserDeptId varchar(20),
		@strDFType varchar(5),
		@strCondition varchar(20),
		@strKeyword varchar(50),
		@nCurPage int, 
		@nRowPerPage int,
		@strSortColumn varchar(20),
		@strSortOrder varchar(5),
		@strSDate varchar(50),
		@strEDate varchar(50),
		@strFormsId varchar(1000),    --양식별 검색(신철호)
		@iTotalCount int output

AS
SET NOCOUNT ON

DECLARE @iNum1 	INT
DECLARE @iNum2 	INT
DECLARE @sQuery VARCHAR(3500)
DECLARE @strOrderBy VARCHAR(100)
DECLARE @sCountQuery VARCHAR(3000)

DECLARE @strOrderByRevers VARCHAR(100)
DECLARE @strSortOrderRevers CHAR(4)
DECLARE @nSelectRecord INT		-- 실제로 반환할 레코드 수
DECLARE @strWhereForFormsId VARCHAR(1000) --양식별 검색조건 문(신철호)

-- @strCondition 파라메터에 검색조건과 결재진행상태, 날짜조건이 같이 넘어오므로 문자열을 분리한다.
-- declare	@strCondition	varchar(100)
-- set		@strCondition = 'CREATOR_DEPT|7/S'	
DECLARE	@wState		VARCHAR(10),
		@wDateType	VARCHAR(20)
SELECT	@wDateType	= SUBSTRING(@strCondition, CHARINDEX('/', @strCondition)+1, 1),
		@wState	= SUBSTRING(@strCondition, CHARINDEX('|', @strCondition)+1, 1),
		@strCondition = SUBSTRING(@strCondition, 1, CHARINDEX('|', @strCondition)-1)

--select	@wDateType, @wState, @strCondition
--	@nCNT	int
SET @iNum1 = @nCurPage * @nRowPerPage
SET @iNum2 = (@nCurPage-1) * @nRowPerPage
SET @nSelectRecord = @nRowPerPage

--	FORM_ID WHERE 조건 구문을 만든다.
IF	@strFormsId = 'ALLFORM'
    SET @strWhereForFormsId = ''
ELSE
    SET @strWhereForFormsId = 'AND FORM_ID in (' + @strFormsId + ')'

SET @strWhereForFormsId = REPLACE(@strWhereForFormsId,'"','''')

IF @strDFType = 'AP'
BEGIN
	--결재함
    -- 전체 레코드 Count 를 Output 으로 리턴함
	SET @sCountQuery = 'SELECT count(*) 
						FROM dbo.VW_WORK_LIST 
						WHERE PARTICIPANT_ID = '''+@strUserId+''' 
						AND STATE = ''2'' 
						AND PROCESS_INSTANCE_VIEW_STATE = ''3'' 
						AND ITEMSTATE = ''1''	
                        ' + @strWhereForFormsId + '	
                        AND CREATE_DATE >= '''+@strSDate+''' AND CREATE_DATE <= '''+@strEDate+' 23:59:59'''

	--임시테이블 생성후 카운트 쿼리 실행시켜 INSERT 하고
	create      TABLE #temp(sql int)
	INSERT INTO #temp exec(@sCountQuery)
	SELECT @iTotalCount = sql FROM #temp
	DROP TABLE #temp

	----------------------실제로 조회해야할 레코드 카운트 계산----------------------
	--총 레코드 카운트가 이론적인 총 레코드 카운트(현재페이지*페이지사이즈)보다 작을때 
	--총 레코드 수에서 이전 페이지까지의 레코드 수를 빼서 나머지 필요한 레코드 카운트를 구한다.
	IF @iTotalCount < (@iNum1)
	BEGIN
		SET @nSelectRecord = @iTotalCount - ( (@nCurPage - 1) * @nRowPerPage )
	END
	----------------------반환할 레코드 카운트가 1 미만인 경우----------------------
	IF @nSelectRecord < 1
	BEGIN
		SET @nSelectRecord = 0
		SET @iNum1 =0
	END

	--[공통]---------------------------------------------------		
	-- 소팅컬럼의 값이 0이 넘어오면 기본값으로 정렬
	if @strSortColumn = '0'	
		SET @strOrderBy = ' ORDER BY CREATE_DATE DESC'
	else
		SET @strOrderBy = ' ORDER BY '+@strSortColumn+' '+@strSortOrder+ ' , ITEMCREATE_DATE DESC'

	-- 소팅컬럼의 값이 0이 넘어오면 기본값으로 정렬
	if @strSortColumn = '0'	
		Begin
			SET @strOrderByRevers = ' ORDER BY CREATE_DATE ASC'
		end

	else
		begin
			SET @strSortOrderRevers =
			(
				CASE @strSortOrder
					WHEN 'ASC'		
							THEN	'DESC'
					WHEN 'DESC'	
							THEN	'ASC'				
				END 
			)	
			
			SET @strOrderByRevers = ' ORDER BY '+@strSortColumn+' '+@strSortOrderRevers+ ' , ITEMCREATE_DATE ASC'
		end	

	--[공통]---------------------------------------------------
	SET @sQuery ='SELECT '+
					'a.ITEMOID,'+
					'a.IsUrgent,'+ 
					'a.Status,'+
					'a.ISATTACHFILE,'+
					'a.PostScript,'+
					'a.CATEGORYNAME,'+
					'a.SUBJECT,'+
					'a.DOC_LEVEL,'+        -- 2005.03.08 KJJ : DOC_LEVEL 을 DOC_NUMBER로 변경
					'a.CREATOR,'+
					'a.CREATOR_DEPT,'+
					'SUBSTRING(CONVERT(varchar,a.CREATE_DATE,21),0,17) as CREATE_DATE,'+
					'a.OPEN_YN,'+
					'a.OID,'+
					'a.Ref_Doc, '+
					'a.ATTACH_EXTENSION, '+
					'a.CREATOR_ID '+
                  --  'a.U_SLIP_NUMBER '+
				'FROM  (
					select top ' + CAST(@nSelectRecord AS VARCHAR) + ' * 
					from (
						select top ' + CAST(@iNum1 AS VARCHAR) + ' * 
						from dbo.VW_WORK_LIST 
						where Participant_id = '''+@strUserId+'''  
						AND STATE = ''2''  
						AND PROCESS_INSTANCE_VIEW_STATE = ''3''			
						AND ITEMSTATE = ''1''
                        ' + @strWhereForFormsId + '	
                        AND CREATE_DATE >= '''+@strSDate+''' AND CREATE_DATE <= '''+@strEDate+' 23:59:59''
						' +@strOrderBy+ '
						) a
					where Participant_id = '''+@strUserId+'''  
					AND STATE = ''2''  
					AND PROCESS_INSTANCE_VIEW_STATE = ''3''			
					AND ITEMSTATE = ''1''
                    ' + @strWhereForFormsId + '	
                    AND CREATE_DATE >= '''+@strSDate+''' AND CREATE_DATE <= '''+@strEDate+' 23:59:59''
					' +@strOrderByRevers+ '
		   			) a
				where Participant_id = '''+@strUserId+'''  
				AND STATE = ''2''  
				AND PROCESS_INSTANCE_VIEW_STATE = ''3''			
				AND ITEMSTATE = ''1''
                ' + @strWhereForFormsId + '	
                AND CREATE_DATE >= '''+@strSDate+''' AND CREATE_DATE <= '''+@strEDate+' 23:59:59''
				' +@strOrderBy					
					
END
ELSE IF @strDFType = 'AF'
BEGIN

	--후결함
    -- 전체 레코드 Count 를 Output 으로 리턴함
	SET @sCountQuery = 'SELECT count(*) 
						FROM dbo.VW_WORK_LIST 
						WHERE PARTICIPANT_ID = '''+@strUserId+''' 
						AND STATE = ''2'' 
						AND PROCESS_INSTANCE_VIEW_STATE = ''9'' 
						AND ITEMSTATE = ''1''	
                        ' + @strWhereForFormsId + '	
                        AND CREATE_DATE >= '''+@strSDate+''' AND CREATE_DATE <= '''+@strEDate+' 23:59:59'''						
--AND '+@strCondition+' LIKE ''%'+@strKeyword+'%'''
						
						
	--임시테이블 생성후 카운트 쿼리 실행시켜 INSERT 하고
	CREATE TABLE #temp1(sql int)
	INSERT INTO #temp1 exec(@sCountQuery)
	SELECT @iTotalCount = sql FROM #temp1
	DROP TABLE #temp1							
	
	----------------------실제로 조회해야할 레코드 카운트 계산----------------------
	--총 레코드 카운트가 이론적인 총 레코드 카운트(현재페이지*페이지사이즈)보다 작을때 
	--총 레코드 수에서 이전 페이지까지의 레코드 수를 빼서 나머지 필요한 레코드 카운트를 구한다.
	
	IF @iTotalCount < (@iNum1)
	BEGIN
		SET @nSelectRecord = @iTotalCount - ( (@nCurPage - 1) * @nRowPerPage )
	END
	----------------------반환할 레코드 카운트가 1 미만인 경우----------------------
	IF @nSelectRecord < 1
	BEGIN
		SET @nSelectRecord = 0
		SET @iNum1 =0
	END
	
	
	
	--[공통]---------------------------------------------------		
	-- 소팅컬럼의 값이 0이 넘어오면 기본값으로 정렬
	if @strSortColumn = '0'	
		Begin
			SET @strOrderBy = ' ORDER BY CREATE_DATE DESC'
		end

	else
		begin
			SET @strOrderBy = ' ORDER BY '+@strSortColumn+' '+@strSortOrder+ ' , ITEMCREATE_DATE DESC'
		end

	-- 소팅컬럼의 값이 0이 넘어오면 기본값으로 정렬
	if @strSortColumn = '0'	
		Begin
			SET @strOrderByRevers = ' ORDER BY CREATE_DATE ASC'
		end

	else
		begin
			SET @strSortOrderRevers =
			(
				CASE @strSortOrder
					WHEN 'ASC'		
							THEN	'DESC'
					WHEN 'DESC'	
							THEN	'ASC'				
				END 

			)	
			
			SET @strOrderByRevers = ' ORDER BY '+@strSortColumn+' '+@strSortOrderRevers+ ' , ITEMCREATE_DATE ASC'
		end	
	--[공통]---------------------------------------------------

	


	SET @sQuery ='SELECT '+
					'a.ITEMOID,'+
					'a.IsUrgent,'+ 
					'a.Status,'+
					'a.ISATTACHFILE,'+
					'a.PostScript,'+
					'a.CATEGORYNAME,'+
					'a.SUBJECT,'+
					'a.DOC_LEVEL,'+        -- 2005.03.08 KJJ : DOC_LEVEL 을 DOC_NUMBER로 변경
					'a.CREATOR,'+
					'a.CREATOR_DEPT,'+
					'SUBSTRING(CONVERT(varchar,a.CREATE_DATE,21),0,17) as CREATE_DATE,'+
					'a.OPEN_YN,'+
					'a.OID,'+
					'a.Ref_Doc, '+
					'a.ATTACH_EXTENSION, '+
					'a.CREATOR_ID '+
                  --  'a.U_SLIP_NUMBER '+
				'FROM  (
					select top ' + CAST(@nSelectRecord AS VARCHAR) + ' * 
					from (
						select top ' + CAST(@iNum1 AS VARCHAR) + ' * 
						from dbo.VW_WORK_LIST 
						where Participant_id = '''+@strUserId+'''  
						AND STATE = ''2''  
						AND PROCESS_INSTANCE_VIEW_STATE = ''9''			
						AND ITEMSTATE = ''1''
                        ' + @strWhereForFormsId + '	
						AND CREATE_DATE >= '''+@strSDate+''' AND CREATE_DATE <= '''+@strEDate+' 23:59:59''
						' +@strOrderBy+ '
						) a
					where Participant_id = '''+@strUserId+'''  
					AND STATE = ''2''  
					AND PROCESS_INSTANCE_VIEW_STATE = ''9''			
					AND ITEMSTATE = ''1''
                    ' + @strWhereForFormsId + '	
                    AND CREATE_DATE >= '''+@strSDate+''' AND CREATE_DATE <= '''+@strEDate+' 23:59:59''				
					' +@strOrderByRevers+ '
		   			) a
				where Participant_id = '''+@strUserId+'''  
				AND STATE = ''2''  
				AND PROCESS_INSTANCE_VIEW_STATE = ''9''			
				AND ITEMSTATE = ''1''
                ' + @strWhereForFormsId + '	
                AND CREATE_DATE >= '''+@strSDate+''' AND CREATE_DATE <= '''+@strEDate+' 23:59:59''	   			
				' +@strOrderBy	

END


ELSE IF @strDFType = 'PR'

BEGIN
	--진행함


    -- 전체 레코드 Count 를 Output 으로 리턴함		
	SET @sCountQuery = 'SELECT  count(*) 
						FROM dbo.VW_WORK_LIST 
						WHERE PARTICIPANT_ID = '''+@strUserId+'''
						AND STATE = ''7'' 
						AND PROCESS_INSTANCE_VIEW_STATE = ''3'' 
						AND ITEMSTATE = ''1''
                        ' + @strWhereForFormsId + '	
						AND COMPLETED_DATE >= '''+@strSDate+''' AND COMPLETED_DATE <= '''+@strEDate+' 23:59:59'''
	
	--임시테이블 생성후 카운트 쿼리 실행시켜 INSERT 하고
	CREATE TABLE #temp2(sql int)
	INSERT INTO #temp2 exec(@sCountQuery)
	SELECT @iTotalCount = sql FROM #temp2
	DROP TABLE #temp2	
	
	
	----------------------실제로 조회해야할 레코드 카운트 계산----------------------
	--총 레코드 카운트가 이론적인 총 레코드 카운트(현재페이지*페이지사이즈)보다 작을때 
	--총 레코드 수에서 이전 페이지까지의 레코드 수를 빼서 나머지 필요한 레코드 카운트를 구한다.
	
	IF @iTotalCount < (@iNum1)
	BEGIN
		SET @nSelectRecord = @iTotalCount - ( (@nCurPage - 1) * @nRowPerPage )
	END
	----------------------반환할 레코드 카운트가 1 미만인 경우----------------------
	IF @nSelectRecord < 1
	BEGIN
		SET @nSelectRecord = 0
		SET @iNum1 =0
	END
	
		
	
	--[공통]---------------------------------------------------		
	-- 소팅컬럼의 값이 0이 넘어오면 기본값으로 정렬
	if @strSortColumn = '0'	
		Begin
			SET @strOrderBy = ' ORDER BY COMPLETED_DATE DESC'
		end

	else
		begin
			SET @strOrderBy = ' ORDER BY '+@strSortColumn+' '+@strSortOrder+ ' , ITEMCREATE_DATE DESC'
		end

	-- 소팅컬럼의 값이 0이 넘어오면 기본값으로 정렬
	if @strSortColumn = '0'	
		Begin
			SET @strOrderByRevers = ' ORDER BY COMPLETED_DATE ASC'
		end

	else
		begin
			SET @strSortOrderRevers =
			(
				CASE @strSortOrder
					WHEN 'ASC'		
							THEN	'DESC'
					WHEN 'DESC'	
							THEN	'ASC'				
				END 
			)	
			
			SET @strOrderByRevers = ' ORDER BY '+@strSortColumn+' '+@strSortOrderRevers+ ' , ITEMCREATE_DATE ASC'
		end	
	--[공통]---------------------------------------------------



	SET @sQuery =	
		'SELECT	'+
				'a.ITEMOID,'+
				'a.IsUrgent,'+ 
				'a.Status,'+
				'a.ISATTACHFILE,'+
				'a.PostScript,'+
				'a.CATEGORYNAME,'+
				'a.SUBJECT,'+
				'a.DOC_LEVEL,'+            -- 2005.03.08 KJJ : DOC_LEVEL 을 DOC_NUMBER로 변경
				'a.CREATOR,'+
				'a.CREATOR_DEPT,'+
				'SUBSTRING(CONVERT(VARCHAR,a.COMPLETED_DATE,21),0,17) as COMPLETED_DATE,'+
				'a.OPEN_YN,'+
				'a.OID,'+
				'a.Ref_Doc, '+
				'a.ATTACH_EXTENSION, '+
				'a.CREATOR_ID '+
             --   'a.U_SLIP_NUMBER '+				
		'FROM  (
			select top ' + CAST(@nSelectRecord AS VARCHAR) + ' * 
			from (
				select top ' + CAST(@iNum1 AS VARCHAR) + ' * 
				from dbo.VW_WORK_LIST 
				where Participant_id = '''+@strUserId+'''  
				AND STATE = ''7''  
				AND PROCESS_INSTANCE_VIEW_STATE = ''3''			
				AND ITEMSTATE = ''1''
                ' + @strWhereForFormsId + '	
				AND COMPLETED_DATE >= '''+@strSDate+''' AND COMPLETED_DATE <= '''+@strEDate+' 23:59:59''
				' +@strOrderBy+ '
				) a
			where Participant_id = '''+@strUserId+'''  
			AND STATE = ''7''  
			AND PROCESS_INSTANCE_VIEW_STATE = ''3''			
			AND ITEMSTATE = ''1''
            ' + @strWhereForFormsId + '	
			AND COMPLETED_DATE >= '''+@strSDate+''' AND COMPLETED_DATE <= '''+@strEDate+' 23:59:59''	
			' +@strOrderByRevers+ '
		   	) a
		where Participant_id = '''+@strUserId+'''  
		AND STATE = ''7''  
		AND PROCESS_INSTANCE_VIEW_STATE = ''3''			
		AND ITEMSTATE = ''1''
        ' + @strWhereForFormsId + '	
		AND COMPLETED_DATE >= '''+@strSDate+''' AND COMPLETED_DATE <= '''+@strEDate+' 23:59:59''  	
		' +@strOrderBy	

END

ELSE IF @strDFType = 'CO'

BEGIN
	--완료함
	
    -- 전체 레코드 Count 를 Output 으로 리턴함		
	SET @sCountQuery = 'SELECT count(*) 
						FROM dbo.VW_WORK_LIST 
						WHERE PARTICIPANT_ID = '''+@strUserId+'''
							AND STATE = ''7'' 
							AND PROCESS_INSTANCE_VIEW_STATE = ''7''
                            ' + @strWhereForFormsId + '
							AND VIEW_COMPLETE_DATE >= '''+@strSDate+''' AND VIEW_COMPLETE_DATE <= '''+@strEDate+' 23:59:59'''
							
	--임시테이블 생성후 카운트 쿼리 실행시켜 INSERT 하고
	CREATE TABLE #temp3(sql int)
	INSERT INTO #temp3 exec(@sCountQuery)
	SELECT @iTotalCount = sql FROM #temp3
	DROP TABLE #temp3
	
	
	----------------------실제로 조회해야할 레코드 카운트 계산----------------------
	--총 레코드 카운트가 이론적인 총 레코드 카운트(현재페이지*페이지사이즈)보다 작을때 
	--총 레코드 수에서 이전 페이지까지의 레코드 수를 빼서 나머지 필요한 레코드 카운트를 구한다.
	
	IF @iTotalCount < (@iNum1)
	BEGIN
		SET @nSelectRecord = @iTotalCount - ( (@nCurPage - 1) * @nRowPerPage )
	END
	----------------------반환할 레코드 카운트가 1 미만인 경우----------------------
	IF @nSelectRecord < 1
	BEGIN
		SET @nSelectRecord = 0
		SET @iNum1 =0
	END
								
	--[공통]---------------------------------------------------		
	-- 소팅컬럼의 값이 0이 넘어오면 기본값으로 정렬
	if @strSortColumn = '0'	
		Begin
			SET @strOrderBy = ' ORDER BY VIEW_COMPLETE_DATE DESC'
		end

	else
		begin
			SET @strOrderBy = ' ORDER BY '+@strSortColumn+' '+@strSortOrder+ ' , ITEMCREATE_DATE DESC'
		end

	-- 소팅컬럼의 값이 0이 넘어오면 기본값으로 정렬
	if @strSortColumn = '0'	
		Begin
			SET @strOrderByRevers = ' ORDER BY VIEW_COMPLETE_DATE ASC'
		end

	else
		begin
			SET @strSortOrderRevers =
			(
				CASE @strSortOrder
					WHEN 'ASC'		
							THEN	'DESC'
					WHEN 'DESC'	
							THEN	'ASC'				
				END 
			)	
			
			SET @strOrderByRevers = ' ORDER BY '+@strSortColumn+' '+@strSortOrderRevers+ ' , ITEMCREATE_DATE ASC'
		end	
	--[공통]---------------------------------------------------
								
	
	
	
	SET @sQuery =	
				'SELECT	'+
						'a.ITEMOID,'+
						'a.IsUrgent,'+ 
						'a.Status,'+
						'a.ISATTACHFILE,'+
						'a.PostScript,'+
						'a.CATEGORYNAME,'+
						'a.SUBJECT,'+
						'a.DOC_LEVEL,'+        -- 2005.03.08 KJJ : DOC_LEVEL 을 DOC_NUMBER로 변경
						'a.CREATOR,'+
						'a.CREATOR_DEPT,'+ 
						'SUBSTRING(CONVERT(VARCHAR,a.VIEW_COMPLETE_DATE,21),0,17) as VIEW_COMPLETE_DATE,'+
						'a.OPEN_YN,'+

						'a.OID,'+
						'a.Ref_Doc, '+
						'a.ATTACH_EXTENSION, '+
    					'a.CREATOR_ID '+
                   --     'a.U_SLIP_NUMBER '+				
				'FROM  (
					select top ' + CAST(@nSelectRecord AS VARCHAR) + ' * 
					from (
						select top ' + CAST(@iNum1 AS VARCHAR) + ' * 

						from dbo.VW_WORK_LIST 
						where Participant_id = '''+@strUserId+'''  
						AND STATE = ''7''  
						AND PROCESS_INSTANCE_VIEW_STATE = ''7''	
                        ' + @strWhereForFormsId + '
						AND VIEW_COMPLETE_DATE >= '''+@strSDate+''' AND VIEW_COMPLETE_DATE <= '''+@strEDate+' 23:59:59''	
						' +@strOrderBy+ '
						) a
					where Participant_id = '''+@strUserId+'''  
					AND STATE = ''7''  
					AND PROCESS_INSTANCE_VIEW_STATE = ''7''	
                    ' + @strWhereForFormsId + '
					AND VIEW_COMPLETE_DATE >= '''+@strSDate+''' AND VIEW_COMPLETE_DATE <= '''+@strEDate+' 23:59:59''						
					' +@strOrderByRevers+ '
		   			) a
				where Participant_id = '''+@strUserId+'''  
				AND STATE = ''7''  
				AND PROCESS_INSTANCE_VIEW_STATE = ''7''
                ' + @strWhereForFormsId + '	
				AND VIEW_COMPLETE_DATE >= '''+@strSDate+''' AND VIEW_COMPLETE_DATE <= '''+@strEDate+' 23:59:59''		   			
				' +@strOrderBy	

END

ELSE IF @strDFType = 'RE'

BEGIN
	--반려함
	
    -- 전체 레코드 Count 를 Output 으로 리턴함
	SET @sCountQuery = 'SELECT  count(*)
			FROM dbo.VW_WORK_LIST
			WHERE PARTICIPANT_ID = '''+@strUserId+'''
				AND STATE = ''7''
				AND PROCESS_INSTANCE_VIEW_STATE = ''8''
				AND ITEMSTATE = ''7''
                ' + @strWhereForFormsId + '
				AND VIEW_COMPLETE_DATE >= '''+@strSDate+''' AND VIEW_COMPLETE_DATE <= '''+@strEDate+' 23:59:59'''
	
	
	--임시테이블 생성후 카운트 쿼리 실행시켜 INSERT 하고
	CREATE TABLE #temp4(sql int)
	INSERT INTO #temp4 exec(@sCountQuery)
	SELECT @iTotalCount = sql FROM #temp4
	DROP TABLE #temp4
	
	
	----------------------실제로 조회해야할 레코드 카운트 계산----------------------
	--총 레코드 카운트가 이론적인 총 레코드 카운트(현재페이지*페이지사이즈)보다 작을때 
	--총 레코드 수에서 이전 페이지까지의 레코드 수를 빼서 나머지 필요한 레코드 카운트를 구한다.
	
	IF @iTotalCount < (@iNum1)
	BEGIN
		SET @nSelectRecord = @iTotalCount - ( (@nCurPage - 1) * @nRowPerPage )
	END
	----------------------반환할 레코드 카운트가 1 미만인 경우----------------------
	IF @nSelectRecord < 1
	BEGIN
		SET @nSelectRecord = 0
		SET @iNum1 =0
	END
	
	
	
	--[공통]---------------------------------------------------		
	-- 소팅컬럼의 값이 0이 넘어오면 기본값으로 정렬
	if @strSortColumn = '0'	
		Begin
			SET @strOrderBy = ' ORDER BY VIEW_COMPLETE_DATE DESC'
		end

	else
		begin
			SET @strOrderBy = ' ORDER BY '+@strSortColumn+' '+@strSortOrder+ ' , ITEMCREATE_DATE DESC'
		end

	-- 소팅컬럼의 값이 0이 넘어오면 기본값으로 정렬
	if @strSortColumn = '0'	
		Begin
			SET @strOrderByRevers = ' ORDER BY VIEW_COMPLETE_DATE ASC'
		end

	else
		begin
			SET @strSortOrderRevers =
			(
				CASE @strSortOrder
					WHEN 'ASC'		
							THEN	'DESC'
					WHEN 'DESC'	
							THEN	'ASC'				
				END 
			)	
			
			SET @strOrderByRevers = ' ORDER BY '+@strSortColumn+' '+@strSortOrderRevers+ ' , ITEMCREATE_DATE ASC'
		end	
	--[공통]---------------------------------------------------
	

	
	
	SET @sQuery ='SELECT '+
			'a.ITEMOID,'+
			'a.IsUrgent,'+ 
			'a.Status,'+
			'a.ISATTACHFILE,'+ 
			'a.PostScript,'+
			'a.CATEGORYNAME,'+
			'a.SUBJECT,'+
			'a.DOC_LEVEL,'+         -- 2005.03.08 KJJ : DOC_LEVEL 을 DOC_NUMBER로 변경
			'a.CREATOR,'+
			'a.CREATOR_DEPT,'+
			'SUBSTRING(CONVERT(VARCHAR,a.VIEW_COMPLETE_DATE,21),0,17) as VIEW_COMPLETE_DATE,'+
			'a.OPEN_YN,'+
			'a.OID,'+
			'a.Ref_Doc, '+
			'a.ATTACH_EXTENSION, '+			
			'a.CREATOR_ID '+
         --   'a.U_SLIP_NUMBER '+		
		'FROM  (
			select top ' + CAST(@nSelectRecord AS VARCHAR) + ' * 
			from (
				select top ' + CAST(@iNum1 AS VARCHAR) + ' * 
				from dbo.VW_WORK_LIST 
				where Participant_id = '''+@strUserId+'''  
				AND STATE = ''7''  
				AND PROCESS_INSTANCE_VIEW_STATE = ''8''		
				AND ITEMSTATE = ''7''	
                ' + @strWhereForFormsId + '

				AND VIEW_COMPLETE_DATE >= '''+@strSDate+''' AND VIEW_COMPLETE_DATE <= '''+@strEDate+' 23:59:59''
				' +@strOrderBy+ '
				) a
			where Participant_id = '''+@strUserId+'''  
			AND STATE = ''7''  
			AND PROCESS_INSTANCE_VIEW_STATE = ''8''		
			AND ITEMSTATE = ''7''	
            ' + @strWhereForFormsId + '
			AND VIEW_COMPLETE_DATE >= '''+@strSDate+''' AND VIEW_COMPLETE_DATE <= '''+@strEDate+' 23:59:59''		
			' +@strOrderByRevers+ '
		   	) a
		where Participant_id = '''+@strUserId+'''  
		AND STATE = ''7''  
		AND PROCESS_INSTANCE_VIEW_STATE = ''8''		
		AND ITEMSTATE = ''7''	
        ' + @strWhereForFormsId + '
		AND VIEW_COMPLETE_DATE >= '''+@strSDate+''' AND VIEW_COMPLETE_DATE <= '''+@strEDate+' 23:59:59''	   	
		' +@strOrderBy	

END


ELSE IF @strDFType = 'ST'

BEGIN
-- 임시보관함

    -- 전체 레코드 Count 를 Output 으로 리턴함
	SET @sCountQuery = 'SELECT count(*)  
			FROM WF_FORM_STORAGE(NOLOCK) 
			WHERE DELETE_DATE = ''9999-12-31 00:00:00.000''
				AND UserID = '''+@strUserId+''' 
                ' + @strWhereForFormsId + '
				AND CREATE_DATE >= '''+@strSDate+''' AND CREATE_DATE <= '''+@strEDate+' 23:59:59'''
	
	--임시테이블 생성후 카운트 쿼리 실행시켜 INSERT 하고
	CREATE TABLE #temp5(sql int)
	INSERT INTO #temp5 exec(@sCountQuery)
	SELECT @iTotalCount = sql FROM #temp5
	DROP TABLE #temp5			
				

	----------------------실제로 조회해야할 레코드 카운트 계산----------------------
	--총 레코드 카운트가 이론적인 총 레코드 카운트(현재페이지*페이지사이즈)보다 작을때 
	--총 레코드 수에서 이전 페이지까지의 레코드 수를 빼서 나머지 필요한 레코드 카운트를 구한다.
	
	IF @iTotalCount < (@iNum1)
	BEGIN
		SET @nSelectRecord = @iTotalCount - ( (@nCurPage - 1) * @nRowPerPage )
	END
	----------------------반환할 레코드 카운트가 1 미만인 경우----------------------
	IF @nSelectRecord < 1
	BEGIN
		SET @nSelectRecord = 0
		SET @iNum1 =0
	END
	
	
	
	--[공통]---------------------------------------------------		
	-- 소팅컬럼의 값이 0이 넘어오면 기본값으로 정렬
	if @strSortColumn = '0'	
		Begin
			SET @strOrderBy = ' ORDER BY CREATE_DATE DESC'
		end

	else
		begin
			SET @strOrderBy = ' ORDER BY '+@strSortColumn+' '+@strSortOrder
		end


	SET @sQuery = 'SELECT  bb.PROCESS_ID,'+
					'(SELECT Form_Name FROM dbo.WF_FORMS s WHERE s.FORM_ID = bb.FORM_ID) as FORM_ID,'+
					'bb.USERID,'+
					'bb.SUBJECT,'+
					'bb.DEPTID,'+
					'bb.DESCRIPTION,'+
					'SUBSTRING(CONVERT(VARCHAR,bb.CREATE_DATE,21),0,17) as CREATE_DATE '+
			'FROM 
				(	SELECT a.*  
					FROM 
						(
							SELECT top ' + CAST(@iNum1 AS VARCHAR) + ' Process_ID, CREATE_DATE
							FROM WF_FORM_STORAGE(NOLOCK)
							WHERE UserID = '''+@strUserId+'''
								AND DELETE_DATE = ''9999-12-31 00:00:00.000''
                                ' + @strWhereForFormsId + '
								AND CREATE_DATE >= '''+@strSDate+''' AND CREATE_DATE <= '''+@strEDate+' 23:59:59''
					   		' +@strOrderBy+ '

						) a
						LEFT OUTER JOIN(
							SELECT Top ' + CAST(@iNum2 AS VARCHAR) + ' Process_ID, CREATE_DATE
							FROM WF_FORM_STORAGE(NOLOCK)
							WHERE UserID = '''+@strUserId+'''
								AND DELETE_DATE = ''9999-12-31 00:00:00.000''
                                ' + @strWhereForFormsId + '
								AND CREATE_DATE >= '''+@strSDate+''' AND CREATE_DATE <= '''+@strEDate+' 23:59:59''
		   					' +@strOrderBy+ '
 						) b
						on a.Process_ID = b.Process_ID
						WHERE b.Process_ID Is null
				) aa 
			INNER join WF_FORM_STORAGE bb (nolock)  
			ON bb.PROCESS_ID = aa.PROCESS_ID  
			WHERE bb.DELETE_DATE = ''9999-12-31 00:00:00.000'''
			



END

ELSE IF @strDFType = 'P'
	
BEGIN
--업무협조함

    -- 전체 레코드 Count 를 Output 으로 리턴함
	SET @sCountQuery = 'SELECT count(*) 
			FROM dbo.VW_WORK_LIST 
			WHERE  PARTICIPANT_ID = '''+@strUserDeptId+'_'+@strDFType+'''
				AND STATE = ''7''	
				AND PROCESS_INSTANCE_VIEW_STATE = ''3''
                ' + @strWhereForFormsId + '
				AND COMPLETED_DATE >= '''+@strSDate+''' AND COMPLETED_DATE <= '''+@strEDate+' 23:59:59'''



	--임시테이블 생성후 카운트 쿼리 실행시켜 INSERT 하고
	CREATE TABLE #temp6(sql int)
	INSERT INTO #temp6 exec(@sCountQuery)
	SELECT @iTotalCount = sql FROM #temp6
	DROP TABLE #temp6
	
	
	----------------------실제로 조회해야할 레코드 카운트 계산----------------------
	--총 레코드 카운트가 이론적인 총 레코드 카운트(현재페이지*페이지사이즈)보다 작을때 
	--총 레코드 수에서 이전 페이지까지의 레코드 수를 빼서 나머지 필요한 레코드 카운트를 구한다.
	
	IF @iTotalCount < (@iNum1)
	BEGIN
		SET @nSelectRecord = @iTotalCount - ( (@nCurPage - 1) * @nRowPerPage )
	END
	----------------------반환할 레코드 카운트가 1 미만인 경우----------------------
	IF @nSelectRecord < 1
	BEGIN
		SET @nSelectRecord = 0
		SET @iNum1 =0
	END
	
	
	
	--[공통]---------------------------------------------------		
	-- 소팅컬럼의 값이 0이 넘어오면 기본값으로 정렬
	if @strSortColumn = '0'	
		Begin
			SET @strOrderBy = ' ORDER BY COMPLETED_DATE DESC'
		end

	else
		begin
			SET @strOrderBy = ' ORDER BY '+@strSortColumn+' '+@strSortOrder+ ' , ITEMCREATE_DATE DESC'
		end

	-- 소팅컬럼의 값이 0이 넘어오면 기본값으로 정렬
	if @strSortColumn = '0'	
		Begin
			SET @strOrderByRevers = ' ORDER BY COMPLETED_DATE ASC'
		end

	else
		begin
			SET @strSortOrderRevers =
			(
				CASE @strSortOrder
					WHEN 'ASC'		
							THEN	'DESC'
					WHEN 'DESC'	
							THEN	'ASC'				
				END 
			)	
			
			SET @strOrderByRevers = ' ORDER BY '+@strSortColumn+' '+@strSortOrderRevers+ ' , ITEMCREATE_DATE ASC'
		end	
	--[공통]---------------------------------------------------
	

	SET @sQuery =	
		'SELECT	'+
			'a.ITEMOID,'+ 
			'a.IsUrgent,'+ 
			'a.Status,'+
			'a.ISATTACHFILE,'+
			'a.PostScript,'+
			'a.CATEGORYNAME,'+
			'a.SUBJECT,'+
			'a.DOC_LEVEL,'+        -- 2005.03.08 KJJ : DOC_LEVEL 을 DOC_NUMBER로 변경
			'a.CREATOR,'+
			'a.CREATOR_DEPT,'+
			'SUBSTRING(CONVERT(VARCHAR,a.COMPLETED_DATE,21),0,17) as COMPLETED_DATE,'+
			'a.OPEN_YN,'+
			'a.OID,'+
			'a.Ref_Doc, '+
			'a.ATTACH_EXTENSION, '+			
			'a.CREATOR_ID '+
       --     'a.U_SLIP_NUMBER '+			
		'FROM  (
			select top ' + CAST(@nSelectRecord AS VARCHAR) + ' * 
			from (
				select top ' + CAST(@iNum1 AS VARCHAR) + ' * 
				from dbo.VW_WORK_LIST 
				where Participant_id = '''+@strUserDeptId+'_'+@strDFType+''' 
				AND STATE = ''7''  
				AND PROCESS_INSTANCE_VIEW_STATE = ''3''	
                ' + @strWhereForFormsId + '
				AND COMPLETED_DATE >= '''+@strSDate+''' AND COMPLETED_DATE <= '''+@strEDate+' 23:59:59''	
				' +@strOrderBy+ '
				) a
			where Participant_id = '''+@strUserDeptId+'_'+@strDFType+''' 
			AND STATE = ''7''  
			AND PROCESS_INSTANCE_VIEW_STATE = ''3''	
            ' + @strWhereForFormsId + '
			AND COMPLETED_DATE >= '''+@strSDate+''' AND COMPLETED_DATE <= '''+@strEDate+' 23:59:59''				
			' +@strOrderByRevers+ '
		   	) a
		where Participant_id = '''+@strUserDeptId+'_'+@strDFType+''' 
		AND STATE = ''7''  
		AND PROCESS_INSTANCE_VIEW_STATE = ''3''	
        ' + @strWhereForFormsId + '
		AND COMPLETED_DATE >= '''+@strSDate+''' AND COMPLETED_DATE <= '''+@strEDate+' 23:59:59''			   	
		' +@strOrderBy	
			




			

END


ELSE IF @strDFType = 'S'
	--발신함
BEGIN

    -- 전체 레코드 Count 를 Output 으로 리턴함
	SET @sCountQuery = 'SELECT	count(*) 
				FROM dbo.VW_WORK_LIST 
				WHERE  PARTICIPANT_ID = '''+@strUserDeptId+'_'+@strDFType+'''
					AND STATE = ''7''	
					AND PROCESS_INSTANCE_VIEW_STATE = ''3''
                    ' + @strWhereForFormsId + '
					AND COMPLETED_DATE >= '''+@strSDate+''' AND COMPLETED_DATE <= '''+@strEDate+' 23:59:59'''


	--임시테이블 생성후 카운트 쿼리 실행시켜 INSERT 하고
	CREATE TABLE #temp7(sql int)
	INSERT INTO #temp7 exec(@sCountQuery)
	SELECT @iTotalCount = sql FROM #temp7
	DROP TABLE #temp7
	
	
	----------------------실제로 조회해야할 레코드 카운트 계산----------------------
	--총 레코드 카운트가 이론적인 총 레코드 카운트(현재페이지*페이지사이즈)보다 작을때 
	--총 레코드 수에서 이전 페이지까지의 레코드 수를 빼서 나머지 필요한 레코드 카운트를 구한다.
	
	IF @iTotalCount < (@iNum1)
	BEGIN
		SET @nSelectRecord = @iTotalCount - ( (@nCurPage - 1) * @nRowPerPage )
	END
	----------------------반환할 레코드 카운트가 1 미만인 경우----------------------
	IF @nSelectRecord < 1
	BEGIN
		SET @nSelectRecord = 0
		SET @iNum1 =0
	END
	

	
	
	-- 소팅컬럼의 값이 0이 넘어오면 기본값으로 정렬
	if @strSortColumn = '0'	
		Begin
			SET @strOrderBy = ' ORDER BY COMPLETED_DATE DESC'
		end
	
	else
		begin
			SET @strOrderBy = ' ORDER BY '+@strSortColumn+' '+@strSortOrder+' , ITEMCREATE_DATE DESC'
		end
		
		
		
	-------------------------------[공통]---------------------------------------------------
	-- 소팅컬럼의 값이 0이 넘어오면 기본값으로 정렬
	if @strSortColumn = '0'	
		Begin
			SET @strOrderByRevers = ' ORDER BY COMPLETED_DATE ASC'
		end
		
	else
		begin
			SET @strSortOrderRevers =
			(
				CASE @strSortOrder
					WHEN 'ASC'		
							THEN	'DESC'
					WHEN 'DESC'	
							THEN	'ASC'				
				END 
			)	
			
			SET @strOrderByRevers = ' ORDER BY '+@strSortColumn+' '+@strSortOrderRevers+ ' , ITEMCREATE_DATE ASC'
		end	
	-------------------------------[공통]---------------------------------------------------
	


	SET @sQuery ='SELECT '+
			'a.ITEMOID,'+ 
			'a.IsUrgent,'+ 
			'a.Status,'+
			'a.ISATTACHFILE,'+
			'a.PostScript,'+
			'a.CATEGORYNAME,'+
			'a.SUBJECT,'+
			'a.DOC_LEVEL,'+         -- 2005.03.08 KJJ : DOC_LEVEL 을 DOC_NUMBER로 변경
			'a.CREATOR,'+
			'a.CREATOR_DEPT,'+
			'SUBSTRING(CONVERT(VARCHAR,a.COMPLETED_DATE,21),0,17) as COMPLETED_DATE,'+
			'a.OPEN_YN,'+
			'a.OID,'+
			'a.Ref_Doc, '+
			'a.ATTACH_EXTENSION, '+			
			'a.CREATOR_ID '+
        --    'a.U_SLIP_NUMBER '+		
		'FROM  (
			select top ' + CAST(@nSelectRecord AS VARCHAR) + ' * 
			from (
				select top ' + CAST(@iNum1 AS VARCHAR) + ' * 
				from dbo.VW_WORK_LIST 
				where Participant_id = '''+@strUserDeptId+'_'+@strDFType+''' 
				AND STATE = ''7''  
				AND PROCESS_INSTANCE_VIEW_STATE = ''3''		
                ' + @strWhereForFormsId + '
				AND COMPLETED_DATE >= '''+@strSDate+''' AND COMPLETED_DATE <= '''+@strEDate+' 23:59:59'' 
				' +@strOrderBy+ '
				) a
			where Participant_id = '''+@strUserDeptId+'_'+@strDFType+''' 
			AND STATE = ''7''  
			AND PROCESS_INSTANCE_VIEW_STATE = ''3''		
            ' + @strWhereForFormsId + '
			AND COMPLETED_DATE >= '''+@strSDate+''' AND COMPLETED_DATE <= '''+@strEDate+' 23:59:59''				
			' +@strOrderByRevers+ '
		   	) a
		where Participant_id = '''+@strUserDeptId+'_'+@strDFType+''' 
		AND STATE = ''7''  
		AND PROCESS_INSTANCE_VIEW_STATE = ''3''		
        ' + @strWhereForFormsId + '
		AND COMPLETED_DATE >= '''+@strSDate+''' AND COMPLETED_DATE <= '''+@strEDate+' 23:59:59''		   	
		' +@strOrderBy


							

END

ELSE IF @strDFType = 'A'
--품의함
BEGIN

    -- 전체 레코드 Count 를 Output 으로 리턴함
	SET @sCountQuery = 'SELECT	count(*) 
			FROM dbo.VW_WORK_LIST 
			WHERE  PARTICIPANT_ID = '''+@strUserDeptId+'_'+@strDFType+'''
				AND STATE = ''7''	
				AND PROCESS_INSTANCE_VIEW_STATE = ''3''
                ' + @strWhereForFormsId + '
				AND COMPLETED_DATE >= '''+@strSDate+''' AND COMPLETED_DATE <= '''+@strEDate+' 23:59:59'''

	--임시테이블 생성후 카운트 쿼리 실행시켜 INSERT 하고
	CREATE TABLE #temp8(sql int)
	INSERT INTO #temp8 exec(@sCountQuery)
	SELECT @iTotalCount = sql FROM #temp8
	DROP TABLE #temp8
	
	
	----------------------실제로 조회해야할 레코드 카운트 계산----------------------
	--총 레코드 카운트가 이론적인 총 레코드 카운트(현재페이지*페이지사이즈)보다 작을때 
	--총 레코드 수에서 이전 페이지까지의 레코드 수를 빼서 나머지 필요한 레코드 카운트를 구한다.
	
	IF @iTotalCount < (@iNum1)
	BEGIN
		SET @nSelectRecord = @iTotalCount - ( (@nCurPage - 1) * @nRowPerPage )
	END
	----------------------반환할 레코드 카운트가 1 미만인 경우----------------------
	IF @nSelectRecord < 1
	BEGIN
		SET @nSelectRecord = 0
		SET @iNum1 =0
	END
	
	
	
	-- 소팅컬럼의 값이 0이 넘어오면 기본값으로 정렬
	if @strSortColumn = '0'	
		Begin
			SET @strOrderBy = ' ORDER BY COMPLETED_DATE DESC'
		end
	
	else
		begin
			SET @strOrderBy = ' ORDER BY '+@strSortColumn+' '+@strSortOrder+' , ITEMCREATE_DATE DESC'
		end
		
		
		
	-------------------------------[공통]---------------------------------------------------
	-- 소팅컬럼의 값이 0이 넘어오면 기본값으로 정렬
	if @strSortColumn = '0'	
		Begin
			SET @strOrderByRevers = ' ORDER BY COMPLETED_DATE ASC'
		end
		
	else
		begin
			SET @strSortOrderRevers =
			(
				CASE @strSortOrder
					WHEN 'ASC'		
							THEN	'DESC'
					WHEN 'DESC'	
							THEN	'ASC'				
				END 
			)	
			
			SET @strOrderByRevers = ' ORDER BY '+@strSortColumn+' '+@strSortOrderRevers+ ' , ITEMCREATE_DATE ASC'
		end	
	-------------------------------[공통]---------------------------------------------------
	



	SET @sQuery ='SELECT '+	 
			'a.ITEMOID,'+
			'a.IsUrgent,'+ 
			'a.Status,'+
			'a.ISATTACHFILE,'+
			'a.PostScript,'+
			'a.CATEGORYNAME,'+ 
			'a.SUBJECT,'+
			'a.DOC_LEVEL,'+         -- 2005.03.08 KJJ : DOC_LEVEL 을 DOC_NUMBER로 변경
			'a.CREATOR,'+
			'a.CREATOR_DEPT,'+
			'SUBSTRING(CONVERT(VARCHAR,a.COMPLETED_DATE,21),0,17) as COMPLETED_DATE,'+
			'a.OPEN_YN,'+
			'a.OID,'+
			'a.Ref_Doc, '+
			'a.ATTACH_EXTENSION, '+			
			'a.CREATOR_ID '+
        --    'a.U_SLIP_NUMBER '+		
		'FROM  (
			select top ' + CAST(@nSelectRecord AS VARCHAR) + ' * 
			from (
				select top ' + CAST(@iNum1 AS VARCHAR) + ' * 

				from dbo.VW_WORK_LIST 
				where Participant_id = '''+@strUserDeptId+'_'+@strDFType+''' 
				AND STATE = ''7''  
				AND PROCESS_INSTANCE_VIEW_STATE = ''3''		
                ' + @strWhereForFormsId + '
				AND COMPLETED_DATE >= '''+@strSDate+''' AND COMPLETED_DATE <= '''+@strEDate+' 23:59:59''
				' +@strOrderBy+ '
				) a
			where Participant_id = '''+@strUserDeptId+'_'+@strDFType+''' 
			AND STATE = ''7''  
			AND PROCESS_INSTANCE_VIEW_STATE = ''3''		
            ' + @strWhereForFormsId + '
			AND COMPLETED_DATE >= '''+@strSDate+''' AND COMPLETED_DATE <= '''+@strEDate+' 23:59:59''
			' +@strOrderByRevers+ '			

		   	) a 
		where Participant_id = '''+@strUserDeptId+'_'+@strDFType+''' 
		AND STATE = ''7''  
		AND PROCESS_INSTANCE_VIEW_STATE = ''3''		
        ' + @strWhereForFormsId + '
		AND COMPLETED_DATE >= '''+@strSDate+''' AND COMPLETED_DATE <= '''+@strEDate+' 23:59:59'' 		   	
		' +@strOrderBy	

END



ELSE IF @strDFType = 'R' or @strDFType = 'K'
	--수신함
BEGIN

    -- 전체 레코드 Count 를 Output 으로 리턴함
	SET @sCountQuery = 'SELECT count(*) 
						FROM dbo.VW_WORK_LIST 
						WHERE  PARTICIPANT_ID = '''+@strUserDeptId+'_'+@strDFType+'''
							AND STATE = ''2''
							AND PROCESS_INSTANCE_VIEW_STATE = ''3''
                            ' + @strWhereForFormsId + '
							AND CREATE_DATE >= '''+@strSDate+''' AND CREATE_DATE <= '''+@strEDate+' 23:59:59'''


	--임시테이블 생성후 카운트 쿼리 실행시켜 INSERT 하고
	CREATE TABLE #temp9(sql int)
	INSERT INTO #temp9 exec(@sCountQuery)
	SELECT @iTotalCount = sql FROM #temp9
	DROP TABLE #temp9
	
	
	----------------------실제로 조회해야할 레코드 카운트 계산----------------------
	--총 레코드 카운트가 이론적인 총 레코드 카운트(현재페이지*페이지사이즈)보다 작을때 
	--총 레코드 수에서 이전 페이지까지의 레코드 수를 빼서 나머지 필요한 레코드 카운트를 구한다.
	
	IF @iTotalCount < (@iNum1)
	BEGIN
		SET @nSelectRecord = @iTotalCount - ( (@nCurPage - 1) * @nRowPerPage )
	END
	----------------------반환할 레코드 카운트가 1 미만인 경우----------------------
	IF @nSelectRecord < 1
	BEGIN
		SET @nSelectRecord = 0
		SET @iNum1 =0
	END
	
	
	
	--[공통]---------------------------------------------------		
	-- 소팅컬럼의 값이 0이 넘어오면 기본값으로 정렬
	if @strSortColumn = '0'	
		Begin
			SET @strOrderBy = ' ORDER BY CREATE_DATE DESC'
		end

	else
		begin
			SET @strOrderBy = ' ORDER BY '+@strSortColumn+' '+@strSortOrder+ ' , ITEMCREATE_DATE DESC'
		end

	-- 소팅컬럼의 값이 0이 넘어오면 기본값으로 정렬
	if @strSortColumn = '0'	
		Begin
			SET @strOrderByRevers = ' ORDER BY CREATE_DATE ASC'
		end

	else
		begin
			SET @strSortOrderRevers =
			(
				CASE @strSortOrder
					WHEN 'ASC'		
							THEN	'DESC'
					WHEN 'DESC'	
							THEN	'ASC'				
				END 
			)	
			
			SET @strOrderByRevers = ' ORDER BY '+@strSortColumn+' '+@strSortOrderRevers+ ' , ITEMCREATE_DATE ASC'
		end	
	--[공통]---------------------------------------------------
	

	
	SET @sQuery ='SELECT '+
			'a.ITEMOID,'+
			'a.IsUrgent,'+ 
			'a.Status,'+
			'a.ISATTACHFILE,'+
			'a.PostScript,'+
			'a.CATEGORYNAME,'+ 
			'a.SUBJECT,'+
			'a.DOC_LEVEL,'+        -- 2005.03.08 KJJ : DOC_LEVEL 을 DOC_NUMBER로 변경
			'a.CREATOR,'+
			'a.CREATOR_DEPT,'+
			'SUBSTRING(CONVERT(VARCHAR,a.CREATE_DATE,21),0,17) as CREATE_DATE,'+
			'a.OPEN_YN,'+
			'a.OID,'+
			'a.Ref_Doc, '+
			'a.ATTACH_EXTENSION, '+			
			'a.CREATOR_ID '+
          --  'a.U_SLIP_NUMBER '+		
		'FROM  (
			select top ' + CAST(@nSelectRecord AS VARCHAR) + ' * 
			from (
				select top ' + CAST(@iNum1 AS VARCHAR) + ' * 
				from dbo.VW_WORK_LIST 
				where Participant_id = '''+@strUserDeptId+'_'+@strDFType+''' 
				AND STATE = ''2''  
				AND PROCESS_INSTANCE_VIEW_STATE = ''3''	
                ' + @strWhereForFormsId + '
				AND CREATE_DATE >= '''+@strSDate+''' AND CREATE_DATE <= '''+@strEDate+' 23:59:59''
				' +@strOrderBy+ '
				) a
			where Participant_id = '''+@strUserDeptId+'_'+@strDFType+''' 
			AND STATE = ''2''  
			AND PROCESS_INSTANCE_VIEW_STATE = ''3''	
            ' + @strWhereForFormsId + '
			AND CREATE_DATE >= '''+@strSDate+''' AND CREATE_DATE <= '''+@strEDate+' 23:59:59''				
			' +@strOrderByRevers+ '
		   	) a
		where Participant_id = '''+@strUserDeptId+'_'+@strDFType+''' 
		AND STATE = ''2''  
		AND PROCESS_INSTANCE_VIEW_STATE = ''3''	
        ' + @strWhereForFormsId + '
		AND CREATE_DATE >= '''+@strSDate+''' AND CREATE_DATE <= '''+@strEDate+' 23:59:59'' 			   	
		' +@strOrderBy

END
ELSE IF @strDFType = 'PA'
	--예결함
BEGIN

    -- 전체 레코드 Count 를 Output 으로 리턴함
	SET @sCountQuery =  	'SELECT count(*)
				FROM dbo.VW_PR_LIST(nolock)
				where USER_ID = ''' + @strUserId + '''	
				AND ACTION_TYPE = ''2''  		
                           			' + @strWhereForFormsId + '	
				AND CREATE_DATE >= '''+@strSDate+''' AND CREATE_DATE <= '''+@strEDate+' 23:59:59'''					


	--임시테이블 생성후 카운트 쿼리 실행시켜 INSERT 하고
	CREATE TABLE #temp10(sql int)
	INSERT INTO #temp10 exec(@sCountQuery)
	SELECT @iTotalCount = sql FROM #temp10
	DROP TABLE #temp10
	
	
	----------------------실제로 조회해야할 레코드 카운트 계산----------------------
	--총 레코드 카운트가 이론적인 총 레코드 카운트(현재페이지*페이지사이즈)보다 작을때 
	--총 레코드 수에서 이전 페이지까지의 레코드 수를 빼서 나머지 필요한 레코드 카운트를 구한다.
	
	IF @iTotalCount < (@iNum1)
	BEGIN
		SET @nSelectRecord = @iTotalCount - ( (@nCurPage - 1) * @nRowPerPage )
	END
	----------------------반환할 레코드 카운트가 1 미만인 경우----------------------
	IF @nSelectRecord < 1
	BEGIN
		SET @nSelectRecord = 0
		SET @iNum1 =0
	END
	
	
	
	--[공통]---------------------------------------------------		
	-- 소팅컬럼의 값이 0이 넘어오면 기본값으로 정렬
	if @strSortColumn = '0'	
		Begin
			SET @strOrderBy = ' ORDER BY CREATE_DATE DESC'
		end

	else if @strSortColumn = 'CREATE_DATE'	
		begin
			SET @strOrderBy = ' ORDER BY '+@strSortColumn+' '+@strSortOrder
		end
	
	else
		begin
			SET @strOrderBy = ' ORDER BY '+@strSortColumn+' '+@strSortOrder+' , CREATE_DATE DESC'
		end
		
		
		
	-------------------------------[공통]---------------------------------------------------
	-- 소팅컬럼의 값이 0이 넘어오면 기본값으로 정렬
	if @strSortColumn = '0'	
		Begin
			SET @strOrderByRevers = ' ORDER BY CREATE_DATE ASC'
		end

	else
		begin
			SET @strSortOrderRevers =
			(
				CASE @strSortOrder
					WHEN 'ASC'		
							THEN	'DESC'
					WHEN 'DESC'	
							THEN	'ASC'				
				END 
			)	
			
			if @strSortColumn = 'CREATE_DATE'
			   BEGIN	
				SET @strOrderByRevers = ' ORDER BY '+@strSortColumn+' '+@strSortOrderRevers
			   END
			else
			   BEGIN	
				SET @strOrderByRevers = ' ORDER BY '+@strSortColumn+' '+@strSortOrderRevers+ ' , CREATE_DATE ASC'
			   END

		end	
	-------------------------------[공통]---------------------------------------------------
	
	SET @sQuery =	'SELECT	 
			a.ITEMOID,	 	
			a.ISURGENT, 
			a.STATUS, 
			a.ISATTACHFILE, 
			a.POSTSCRIPT, 
			a.CATEGORYNAME, 
			a.SUBJECT,  
			a.DOC_LEVEL, 
			a.CREATOR, 
			a.CREATOR_DEPT, 
			SUBSTRING(CONVERT(VARCHAR,a.CREATE_DATE,21),0,20) as CREATE_DATE,
			'''' as OPEN_YN,
			'''' as OID,
			a.REF_DOC,
			a.ATTACH_EXTENSION,
			a.CREATOR_ID			
			
		FROM  (
			select top ' + CAST(@nSelectRecord AS VARCHAR) + ' * 
			from (
				select top ' + CAST(@iNum1 AS VARCHAR) + ' * 
				from dbo.VW_PR_LIST(nolock)
				where USER_ID = '''+@strUserId+''' 
				AND ACTION_TYPE = ''2''
				' + @strWhereForFormsId + '
				AND CREATE_DATE >= '''+@strSDate+''' AND CREATE_DATE <= '''+@strEDate+' 23:59:59''  
				' +@strOrderBy+ '
				) a
			where USER_ID = '''+@strUserId+'''
			' + @strWhereForFormsId + '
			AND CREATE_DATE >= '''+@strSDate+''' AND CREATE_DATE <= '''+@strEDate+' 23:59:59''
			' +@strOrderByRevers+ '
		   	) a
		where USER_ID = '''+@strUserId+'''
		' + @strWhereForFormsId + '
		AND CREATE_DATE >= '''+@strSDate+''' AND CREATE_DATE <= '''+@strEDate+' 23:59:59''
		' +@strOrderBy	

END
Else If	@strDFType = 'RF'	--	회람문서함
Begin

	Declare	@wFormID	varchar(33),
			@CreateDate	datetime,
			@wSqlWhere_Date	varchar(200)

	Select	@sQuery = '',
			@CreateDate	= ''

	--	7:완료, 8:반려, 1:진행(3도 포함)
	IF	@wState = '1'
		SET	@wState = "'1','3'"
	ELSE IF	@wState IN ('7', '8')
		SET	@wState = "'" + @wState + "'"
	ELSE
		SET	@wState = ""

	--	검색날짜 설정 (S:CREATE_DATE, E:COMPLETED_DATE)
	IF	@wDateType = 'S'
		SET	@wDateType = 'CREATE_DATE'
	ELSE
		SET	@wDateType = 'COMPLETED_DATE'

	SET	@wSqlWhere_Date = "	and	p." + @wDateType + " >= '" + @strSDate + "' and P." + @wDateType + " <= '" + @strEDate + " 23:59:59'"

--	Drop	Table	#List
	Create	Table	#List
	(
		ProcessID					char(33),
		Process_Instance_View_State	char(33)
	)

	If	@strFormsId = 'ALLFORM'
	Begin

		While (1 = 1)
		Begin
		
			Select	Top 1
					@wFormID	= f.Form_ID,
					@CreateDate	= f.Create_Date
			From	eWFForm.dbo.WF_Forms f
			Where	f.Current_Forms = 'Y'
				and	f.Create_Date > @CreateDate
			Order by f.Create_Date
	
			If	@@RowCount = 0	Break
	
			Set	@sQuery = "
				Insert	Into #List
					Select	Process_ID, Process_Instance_State
					From	eWFForm.dbo.Form_" + @wFormID + "
					Where	Referencer_Code like '%" + Convert(char(6), @strUserId) + "%'
				"

			--	상태조건 추가
			IF	@wState <> ''
				Set	@sQuery = @sQuery + 'and	Process_Instance_State in (' + @wState + ')'

			--	검색조건 추가
			IF	(@strCondition = 'CREATOR' OR @strCondition = 'CREATOR_DEPT' OR @strCondition = 'SUBJECT')
				Set	@sQuery = @sQuery + "	AND	" + @strCondition + " LIKE '%" + @strKeyword + "%'"

			--print @sQuery
			Exec (@sQuery)
		End
	End
	Else
	Begin

		Set	@strFormsId = Replace(@strFormsId, '"', '')

		Set	@sQuery = "
			Insert	Into #List
				Select	Process_ID, Process_Instance_State
				From	eWFForm.dbo.Form_" + @strFormsId + "
				Where	Referencer_Code like '%" + Convert(char(6), @strUserId) + "%'
			"

		--	상태조건 추가
		IF	@wState <> ''
			Set	@sQuery = @sQuery + 'and	Process_Instance_State in (' + @wState + ')'

			--	검색조건 추가
		IF	(@strCondition = 'CREATOR' OR @strCondition = 'CREATOR_DEPT' OR @strCondition = 'SUBJECT')
			Set	@sQuery = @sQuery + "	AND	" + @strCondition + " LIKE '%" + @strKeyword + "%'"

		--print @sQuery
		Exec (@sQuery)
	End

	-- 소팅컬럼의 값이 0이 넘어오면 기본값으로 정렬
	IF	@strSortColumn = '0' or @strSortColumn = '11' or @strSortColumn = '12'
	BEGIN
		SET	@strOrderBy = ' Order By ' + @wDateType + ' ' + @strSortOrder
	END
	ELSE
	BEGIN
		Set	@strOrderBy = ' Order By ' + @strSortColumn + ' ' + @strSortOrder

		IF	@strSortColumn <> '11'
			SET	@strOrderBy = @strOrderBy + ', Create_Date ' + @strSortOrder
	END
select	@strSortColumn, @strSortOrder
	-------------------------------[공통]---------------------------------------------------
	-- 소팅컬럼의 값이 0이 넘어오면 기본값으로 정렬
	IF	@strSortColumn = '0' or @strSortColumn = '11' or @strSortColumn = '12'
	BEGIN
		SET	@strOrderByRevers = ' Order By ' + @wDateType + ' ' + @strSortOrder
	END
	ELSE
	BEGIN
		SET	@strSortOrderRevers =
			(
				Case	@strSortOrder
					When	'ASC'		
							Then	'DESC'
					When	'DESC'	
							Then	'ASC'				
				End
			)

		Set	@strOrderByRevers = ' Order By ' + @strSortColumn + ' ' + @strSortOrderRevers

		IF	@strSortColumn <> '11'
			SET	@strOrderByRevers = @strOrderByRevers + ', Create_Date ' + @strSortOrderRevers
	End	

	Set	@sQuery	= "
		Select	Count(*)
		From	#List l
				Join	eWF.dbo.Process_Instance p (nolock)
					On	p.Oid = l.ProcessID
				Join	eWFForm.dbo.Wf_Forms_Prop f (nolock)
					On	f.Process_ID = l.ProcessID
				"
	Set	@sQuery	= @sQuery + @wSqlWhere_Date


	CREATE TABLE #RFtemp(sql int)
	INSERT INTO #RFtemp exec(@sQuery)
	SELECT @iTotalCount = sql FROM #RFtemp
	DROP TABLE #RFtemp

select	@wSqlWhere_Date, @strOrderBy, @strOrderByRevers

	Set	@sQuery	= "
		Select	ITEMOID, 	ISURGENT,			STATUS,	ISATTACHFILE,	POSTSCRIPT,	CATEGORYNAME,	SUBJECT,
				Case
					When	Process_Instance_View_State	in ('1', '3')	Then
						'진행'
					When	Process_Instance_View_State	in ('7')	Then
						'완료'
					When	Process_Instance_View_State	in ('8')	Then
						'반려'
					ELSE
						''
				End	State,
				CREATOR, 	CREATOR_DEPT,
		 		SUBSTRING(CONVERT(VARCHAR(20), CREATE_DATE, 21), 3, 14)		AS CREATE_DATE,
		 		SUBSTRING(CONVERT(VARCHAR(20), COMPLETED_DATE, 21), 3, 14)	AS COMPLETED_DATE,
			 	OPEN_YN,	OID,	REF_DOC,	ATTACH_EXTENSION,	CREATOR_ID,	DOC_NUMBER
		From	(
				Select	Top " + CAST(@nSelectRecord AS VARCHAR) + " *
				From	(
						Select	Top " + CAST(@iNum1 AS VARCHAR) + "
								p.OID as ITEMOID, 
								f.ISURGENT,
								f.STATUS,
								f.ISATTACHFILE,
								f.POSTSCRIPT,
								f.DOC_NAME as CATEGORYNAME,
								f.SUBJECT,
								f.DOC_LEVEL,
								p.CREATOR, 
								p.CREATOR_DEPT, 
								p.CREATE_DATE,
								p.COMPLETED_DATE,
								'N'	as OPEN_YN,
								p.OID	as OID,
								f.REF_DOC,
								f.ATTACH_EXTENSION,
								p.CREATOR_ID,
								f.DOC_NUMBER,
								l.Process_Instance_View_State
						From	#List l
								Join	eWF.dbo.Process_Instance p (nolock)
									On	p.Oid = l.ProcessID
								Join	eWFForm.dbo.Wf_Forms_Prop f (nolock)
									On	f.Process_ID = l.ProcessID
						" + @wSqlWhere_Date + "
						" + @strOrderBy
					+  ") a
				" + @strOrderByRevers
			+  ") a
		" + @strOrderBy

End
ELSE
BEGIN

    -- 전체 레코드 Count 를 Output 으로 리턴함
	SET @sCountQuery = 'SELECT	count(*) 
				FROM dbo.VW_WORK_LIST 
				WHERE  PARTICIPANT_ID = '''+@strUserDeptId+'_'+@strDFType+'''
					AND STATE = ''7''	
					AND PROCESS_INSTANCE_VIEW_STATE = ''3''
                    ' + @strWhereForFormsId + '
					AND COMPLETED_DATE >= '''+@strSDate+''' AND COMPLETED_DATE <= '''+@strEDate+' 23:59:59'''

	--임시테이블 생성후 카운트 쿼리 실행시켜 INSERT 하고
	CREATE TABLE #temp0(sql int)
	INSERT INTO #temp0 exec(@sCountQuery)
	SELECT @iTotalCount = sql FROM #temp0
	DROP TABLE #temp0
	
	
	----------------------실제로 조회해야할 레코드 카운트 계산----------------------
	--총 레코드 카운트가 이론적인 총 레코드 카운트(현재페이지*페이지사이즈)보다 작을때 
	--총 레코드 수에서 이전 페이지까지의 레코드 수를 빼서 나머지 필요한 레코드 카운트를 구한다.
	
	IF @iTotalCount < (@iNum1)
	BEGIN
		SET @nSelectRecord = @iTotalCount - ( (@nCurPage - 1) * @nRowPerPage )
	END
	----------------------반환할 레코드 카운트가 1 미만인 경우----------------------
	IF @nSelectRecord < 1
	BEGIN
		SET @nSelectRecord = 0
		SET @iNum1 =0
	END
	
	
	
	--[공통]---------------------------------------------------		
	-- 소팅컬럼의 값이 0이 넘어오면 기본값으로 정렬
	if @strSortColumn = '0'	
		Begin
			SET @strOrderBy = ' ORDER BY COMPLETED_DATE DESC'
		end

	else
		begin
			SET @strOrderBy = ' ORDER BY '+@strSortColumn+' '+@strSortOrder+ ' , ITEMCREATE_DATE DESC'
		end

	-- 소팅컬럼의 값이 0이 넘어오면 기본값으로 정렬
	if @strSortColumn = '0'	
		Begin
			SET @strOrderByRevers = ' ORDER BY COMPLETED_DATE ASC'
		end

	else
		begin
			SET @strSortOrderRevers =
			(
				CASE @strSortOrder
					WHEN 'ASC'		
							THEN	'DESC'
					WHEN 'DESC'	
							THEN	'ASC'				
				END 
			)	
			
			SET @strOrderByRevers = ' ORDER BY '+@strSortColumn+' '+@strSortOrderRevers+ ' , ITEMCREATE_DATE ASC'
		end	

	--[공통]---------------------------------------------------
	SET @sQuery ='SELECT '+
			'a.ITEMOID,'+
			'a.IsUrgent,'+ 
			'a.Status,'+
			'a.ISATTACHFILE,'+
			'a.PostScript,'+
			'a.CATEGORYNAME,'+
			'a.SUBJECT,'+
			'a.DOC_LEVEL,'+        -- 2005.03.08 KJJ : DOC_LEVEL 을 DOC_NUMBER로 변경
			'a.CREATOR,'+
			'a.CREATOR_DEPT,'+
			'SUBSTRING(CONVERT(VARCHAR,a.COMPLETED_DATE,21),0,17) as COMPLETED_DATE,'+
			'a.OPEN_YN,'+
			'a.OID,'+
			'a.Ref_Doc, '+
			'a.ATTACH_EXTENSION, '+			
			'a.CREATOR_ID '+
           -- 'a.U_SLIP_NUMBER '+		
		'FROM  (
			select top ' + CAST(@nSelectRecord AS VARCHAR) + ' * 
			from (
				select top ' + CAST(@iNum1 AS VARCHAR) + ' * 
				from dbo.VW_WORK_LIST 
				where Participant_id = '''+@strUserDeptId+'_'+@strDFType+''' 
				AND STATE = ''7''  
				AND PROCESS_INSTANCE_VIEW_STATE = ''3''		
                ' + @strWhereForFormsId + '
				AND COMPLETED_DATE >= '''+@strSDate+''' AND COMPLETED_DATE <= '''+@strEDate+' 23:59:59''
				' +@strOrderBy+ '
				) a
			where Participant_id = '''+@strUserDeptId+'_'+@strDFType+''' 
			AND STATE = ''7''  
			AND PROCESS_INSTANCE_VIEW_STATE = ''3''		
            ' + @strWhereForFormsId + '
			AND COMPLETED_DATE >= '''+@strSDate+''' AND COMPLETED_DATE <= '''+@strEDate+' 23:59:59'' 				
			' +@strOrderByRevers+ '
		   	) a
		where Participant_id = '''+@strUserDeptId+'_'+@strDFType+''' 
		AND STATE = ''7''  
		AND PROCESS_INSTANCE_VIEW_STATE = ''3''		
        ' + @strWhereForFormsId + '
		AND COMPLETED_DATE >= '''+@strSDate+''' AND COMPLETED_DATE <= '''+@strEDate+' 23:59:59'' 		   	
		' +@strOrderBy	

END

print (@sQuery)
EXEC (@sQuery)

RETURN







GO
/****** Object:  StoredProcedure [dbo].[UP_LIST_WF_ACL]    Script Date: 2015-10-15 오후 1:30:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
























----------------------------------------------------------------------
----------------------------------------------------------------------
-- 작성자: 신상훈
-- 작성일: 2004.03.08
-- 수정일: 2004.03.08
-- 설  명: 사용자/부서권한 조회(리스트)
--		 : 리스트에는 사용자의 경우 소속부서와 직위, 이름만 나타난다.
--		 : 부서의 경우 부서이름만 나타난다.
-- 테스트: 
-- EXEC  dbo.UP_LIST_WF_ACL 0,1,100,'P','deptname','전자' 
-- EXEC  dbo.UP_LIST_WF_ACL 0,1,100,'P','','전자' 
--  EXEC  dbo.UP_LIST_WF_ACL 0,1,100,'P','username','' 
-- EXEC  dbo.UP_LIST_WF_ACL 0,1,100,'D','',''
-- EXEC  dbo.UP_LIST_WF_ACL 0,1,100,'P','',''
----------------------------------------------------------------------
-- 수정일 : 
-- 수정자 : 
-- 수정내용 : 
----------------------------------------------------------------------
----------------------------------------------------------------------
CREATE                         PROC [dbo].[UP_LIST_WF_ACL]

	@intTotalCount 			int OUTPUT,	
	@intPageNum			int,
	@intNumPerPage      		int,
	@cUserType			char(1),
	@vcSearchColumn		varchar(20),
	@vcSearchText       		varchar(50)
	
AS

DECLARE
	
	@vcQuery			varchar(8000),
	@nvcCountQuery      		nvarchar(4000)


----------------------------------------------------------------------
-- 내용 : 총 게시물 수
----------------------------------------------------------------------
-- SET @nvcCountQuery = 	N'	SELECT	@nCnt = COUNT(*) '
-- +			N'	      FROM	'
-- +			N'	      (	'
-- +			N'	            SELECT		USERID, DEPTID'
-- +			N'		      FROM	eWFFORM.dbo.WF_ACL_SPECIAL_FOLDER(NOLOCK)		'
-- +			N'		            WHERE	USER_TYPE = ''' + @cUserType + ''''
-- +			N'	      UNION  '
-- +			N'	            SELECT		USERID, 	DEPTID'		
-- +			N'		      FROM	eWFFORM.dbo.WF_ACL_OTHER_DEPT(NOLOCK)		'
-- +			N'		            WHERE	USER_TYPE = ''' + @cUserType + ''''		
-- +			N'	      UNION  '
-- +			N'	            SELECT		USERID, 	DEPTID'		
-- +			N'		      FROM	eWFFORM.dbo.WF_ACL_SUBDEPT(NOLOCK)		'
-- +			N'		      WHERE	USER_TYPE = ''' + @cUserType + ''''
-- +			N'	      UNION  '
-- +			N'	            SELECT		USERID, 	DEPTID'		
-- +			N'		      FROM	eWFFORM.dbo.WF_ACL_FORM_LINE(NOLOCK)		'
-- +			N'		      WHERE	USER_TYPE = ''' + @cUserType + ''''
-- +			N'	      ) as A'
-- 
-- EXEC sp_executesql @nvcCountQuery, N'@nCnt INT OUTPUT', @nCNT = @intTotalCount OUTPUT
IF @cUserType = 'P' 
BEGIN
SET @nvcCountQuery =    N' SELECT @nCnt = COUNT(*) '
+		             N'   FROM  '
+		             N' ( SELECT DISTINCT  eWFFORM.dbo.UF_ACL_CHECK(A.DeptId, A.UserID, ''' + @cUserType + ''''
+		             N' ) as ABC ,A.UserName, A.DeptName '         
+                                         N' FROM eManage.dbo.VW_USER as A '      
+		             N' INNER JOIN ' 
+		             N' ( ' 
+		             N' 	SELECT  USERID,  DEPTID '                  
+			N'     	 FROM eWFFORM.dbo.WF_ACL_SPECIAL_FOLDER(NOLOCK)    '   
+			N' 		WHERE  USER_TYPE = ''' + @cUserType + ''''
+			N' 	UNION ALL    '
+ 			N'	SELECT  USERID,  DEPTID      '
+			N'     	      FROM  eWFFORM.dbo.WF_ACL_OTHER_DEPT(NOLOCK)    '
+			N' 		WHERE  USER_TYPE = ''' + @cUserType + ''''   
+			N'	UNION ALL     '
+			N'	SELECT  USERID,  DEPTID '
+			N'                    FROM  eWFFORM.dbo.WF_ACL_SUBDEPT(NOLOCK) '
+			N' 		WHERE  USER_TYPE = ''' + @cUserType + ''''   
+			N'    	UNION ALL      '
+			N'	SELECT  USERID,  DEPTID   '
+			N'         	      FROM  eWFFORM.dbo.WF_ACL_FORM_LINE(NOLOCK)      '
+			N'  		 WHERE  USER_TYPE = ''' + @cUserType + ''''
+			N'  ) as B      '
+			N'  ON A.UserID = B.USERID AND A.DeptID = B.DEPTID '


--검색항목이 있을 경우
if(@vcSearchColumn != '')
SET @nvcCountQuery = @nvcCountQuery +N' AND A.'+@vcSearchColumn+' like ''%'+@vcSearchText+'%'''
SET @nvcCountQuery = @nvcCountQuery +N' )as C '
END

IF @cUserType = 'D' 
BEGIN
SET @nvcCountQuery =    N' SELECT @nCnt = COUNT(*) '
+		             N'   FROM  '
+		             N' ( SELECT DISTINCT  eWFFORM.dbo.UF_ACL_CHECK(A.DeptId, A.DeptId,  ''' + @cUserType + ''''
+		             N' ) as ABC , A.DeptName '         
+                                         N' FROM eManage.dbo.VW_USER as A '      
+		             N' INNER JOIN ' 
+		             N' ( ' 
+		             N' 	SELECT    DEPTID '                  
+			N'     	 FROM eWFFORM.dbo.WF_ACL_SPECIAL_FOLDER(NOLOCK)    '   
+			N' 		WHERE  USER_TYPE = ''' + @cUserType + ''''
+			N' 	UNION ALL    '
+ 			N'	SELECT    DEPTID      '
+			N'     	      FROM  eWFFORM.dbo.WF_ACL_OTHER_DEPT(NOLOCK)    '
+			N' 		WHERE  USER_TYPE = ''' + @cUserType + ''''   
+			N'	UNION ALL     '
+			N'	SELECT    DEPTID '
+			N'                    FROM  eWFFORM.dbo.WF_ACL_SUBDEPT(NOLOCK) '
+			N' 		WHERE  USER_TYPE = ''' + @cUserType + ''''   
+			N'    	UNION ALL      '
+			N'	SELECT    DEPTID   '
+			N'         	      FROM  eWFFORM.dbo.WF_ACL_FORM_LINE(NOLOCK)      '
+			N'  		 WHERE  USER_TYPE = ''' + @cUserType + ''''
+			N'  ) as B      '
+			N'  ON A.DeptID = B.DEPTID' 


--검색항목이 있을 경우
if(@vcSearchColumn != '')
SET @nvcCountQuery = @nvcCountQuery +N' AND A.'+@vcSearchColumn+' like ''%'+@vcSearchText+'%'''
SET @nvcCountQuery = @nvcCountQuery +N' )as C '
END

EXEC sp_executesql @nvcCountQuery, N'@nCnt INT OUTPUT', @nCNT = @intTotalCount OUTPUT

	



IF @cUserType = 'P' 
BEGIN
----------------------------------------------------------------------
-- 내용 : 리스트 구성
----------------------------------------------------------------------


	SET @vcQuery =	'	SELECT  
					C.DeptName, 
					C.JikWi, 
					C.UserName, 
					CASE substring(C.ABC, 1, 1) WHEN ''Y'' THEN ''권한있음'' ELSE  ''권한없음'' END as SPEDOCFOLDER_AUTH, 
					CASE substring(C.ABC, 2, 1) WHEN ''Y'' THEN ''권한있음'' ELSE  ''권한없음'' END as OTHERFOLDER_AUTH, 
					CASE substring(C.ABC, 3, 1) WHEN ''Y'' THEN ''권한있음'' ELSE  ''권한없음'' END as SUBFOLDER_AUTH,
					CASE substring(C.ABC, 4, 1) WHEN ''Y'' THEN ''권한있음'' ELSE  ''권한없음'' END as FORMLINE_AUTH,
					C.UserID,
					C.DeptID 
				FROM ('

	SET @vcQuery =	@vcQuery + '	 SELECT DISTINCT	 	TOP '+CAST(@intPageNum * @intNumPerPage AS varchar) + '
					A.DeptName,
						A.JikWi, 
						A.UserName, 										
						eWFFORM.dbo.UF_ACL_CHECK(A.DeptId, A.UserID, ''' + @cUserType + ''') as ABC,
						A.UserID, 
						A.DeptID
			     	      FROM	eManage.dbo.VW_USER as A

				INNER JOIN
				(
				SELECT		USERID, 	DEPTID 
			      	      FROM	eWFFORM.dbo.WF_ACL_SPECIAL_FOLDER(NOLOCK)
					WHERE		USER_TYPE = ''' + @cUserType + '''
				UNION ALL
				SELECT		USERID, 	DEPTID
				      FROM		eWFFORM.dbo.WF_ACL_OTHER_DEPT(NOLOCK)
					WHERE		USER_TYPE =  ''' + @cUserType + '''
				UNION ALL
				SELECT		USERID, 	DEPTID
				      FROM		eWFFORM.dbo.WF_ACL_SUBDEPT(NOLOCK)
					WHERE		USER_TYPE =  ''' + @cUserType + '''
				UNION ALL
				SELECT		USERID, 	DEPTID
				      FROM		eWFFORM.dbo.WF_ACL_FORM_LINE(NOLOCK)
					WHERE		USER_TYPE =  ''' + @cUserType + ''') as B
				ON A.UserID = B.USERID AND A.DeptID = B.DEPTID' 
if(@vcSearchColumn != '')

SET @vcQuery = @vcQuery + ' AND A.'+@vcSearchColumn+' like ''%'+@vcSearchText+'%'''
SET @vcQuery = @vcQuery + ' ORDER BY A.DeptID, A.UserID'

SET @vcQuery =	@vcQuery + ' ) as C
		LEFT OUTER JOIN
			(SELECT	 DISTINCT TOP '+CAST((@intPageNum-1) * @intNumPerPage AS varchar) + '
					A.DeptName,
						A.JikWi, 
						A.UserName, 				
						eWFFORM.dbo.UF_ACL_CHECK(A.DeptId, A.UserID, ''' + @cUserType + ''') as ABC,
						A.UserID, 
						A.DeptID
			     	      FROM	eManage.dbo.VW_USER as A

				INNER JOIN
				(
				SELECT		USERID, 	DEPTID 
			      	      FROM	eWFFORM.dbo.WF_ACL_SPECIAL_FOLDER(NOLOCK)
					WHERE		USER_TYPE = ''' + @cUserType + '''
				UNION ALL
				SELECT		USERID, 	DEPTID
				      FROM		eWFFORM.dbo.WF_ACL_OTHER_DEPT(NOLOCK)
					WHERE		USER_TYPE = ''' + @cUserType + '''
				UNION ALL
				SELECT		USERID, 	DEPTID
				      FROM		eWFFORM.dbo.WF_ACL_SUBDEPT(NOLOCK)
					WHERE		USER_TYPE = ''' + @cUserType + '''
				UNION ALL
				SELECT		USERID, 	DEPTID
				      FROM		eWFFORM.dbo.WF_ACL_FORM_LINE(NOLOCK)
					WHERE		USER_TYPE = ''' + @cUserType + ''') as B
				ON A.UserID = B.USERID AND A.DeptID = B.DEPTID'
if(@vcSearchColumn != '')

	SET @vcQuery = @vcQuery +' AND A.'+@vcSearchColumn+' like ''%'+@vcSearchText+'%'''
	SET @vcQuery = @vcQuery +' ORDER BY A.DeptID, A.UserID )as D ON C.UserID = D.USERID AND C.DeptId = D.DeptId
		WHERE D.UserID IS NULL AND D.DeptId IS NULL'
END

IF @cUserType = 'D' 
BEGIN

SET @vcQuery =	'SELECT    C.DeptName, 					
				CASE substring(C.ABC, 1, 1) WHEN ''Y'' THEN ''권한있음'' ELSE  ''권한없음'' END as SPEDOCFOLDER_AUTH, 
				CASE substring(C.ABC, 2, 1) WHEN ''Y'' THEN ''권한있음'' ELSE  ''권한없음'' END as OTHERFOLDER_AUTH, 
				CASE substring(C.ABC, 3, 1) WHEN ''Y'' THEN ''권한있음'' ELSE  ''권한없음'' END as SUBFOLDER_AUTH,
				CASE substring(C.ABC, 4, 1) WHEN ''Y'' THEN ''권한있음'' ELSE  ''권한없음'' END as FORMLINE_AUTH,
				C.DeptID 
				FROM ('

	SET @vcQuery =	@vcQuery + ' SELECT DISTINCT TOP '+CAST(@intPageNum * @intNumPerPage AS varchar) + '
					A.DeptName,
														
						eWFFORM.dbo.UF_ACL_CHECK(A.DeptId, A.DeptId, ''' + @cUserType + ''') as ABC,						
						A.DeptID
			     	      FROM	eManage.dbo.VW_DEPT as A

				INNER JOIN
				(
				SELECT			DEPTID 
			      	      FROM	eWFFORM.dbo.WF_ACL_SPECIAL_FOLDER(NOLOCK)
					WHERE		USER_TYPE = ''' + @cUserType + '''
				UNION ALL
				SELECT			DEPTID
				      FROM		eWFFORM.dbo.WF_ACL_OTHER_DEPT(NOLOCK)
					WHERE		USER_TYPE =  ''' + @cUserType + '''
				UNION ALL
				SELECT			DEPTID
				      FROM		eWFFORM.dbo.WF_ACL_SUBDEPT(NOLOCK)
					WHERE		USER_TYPE =  ''' + @cUserType + '''
				UNION ALL
				SELECT			DEPTID
				      FROM		eWFFORM.dbo.WF_ACL_FORM_LINE(NOLOCK)
					WHERE		USER_TYPE =  ''' + @cUserType + ''') as B
				ON A.DeptID = B.DEPTID'
if(@vcSearchColumn != '')

SET @vcQuery = @vcQuery + ' AND A.'+@vcSearchColumn+' like ''%'+@vcSearchText+'%'''
SET @vcQuery =	@vcQuery + ' ORDER BY A.DeptID'
	SET @vcQuery =	@vcQuery + ' ) as C
		LEFT OUTER JOIN
			(SELECT	 DISTINCT	TOP '+CAST((@intPageNum-1) * @intNumPerPage AS varchar) + '
					A.DeptName,
								
						eWFFORM.dbo.UF_ACL_CHECK(A.DeptId, A.DeptId, ''' + @cUserType + ''') as ABC,						
						A.DeptID
			     	      FROM	eManage.dbo.VW_DEPT as A

				INNER JOIN
				(
				SELECT			DEPTID 
			      	      FROM	eWFFORM.dbo.WF_ACL_SPECIAL_FOLDER(NOLOCK)
					WHERE		USER_TYPE = ''' + @cUserType + '''
				UNION ALL
				SELECT			DEPTID
				      FROM		eWFFORM.dbo.WF_ACL_OTHER_DEPT(NOLOCK)
					WHERE		USER_TYPE = ''' + @cUserType + '''
				UNION ALL
				SELECT			DEPTID
				      FROM		eWFFORM.dbo.WF_ACL_SUBDEPT(NOLOCK)
					WHERE		USER_TYPE = ''' + @cUserType + '''
				UNION ALL
				SELECT			DEPTID
				      FROM		eWFFORM.dbo.WF_ACL_FORM_LINE(NOLOCK)
					WHERE		USER_TYPE = ''' + @cUserType + ''') as B
				ON A.DeptID = B.DEPTID'
if(@vcSearchColumn != '')

SET @vcQuery = @vcQuery + ' AND A.'+@vcSearchColumn+' like ''%'+@vcSearchText+'%'''
SET @vcQuery = @vcQuery + ' ORDER BY A.DeptID) as D ON C.DeptId = D.DeptId WHERE D.DeptId IS NULL ORDER BY D.DeptName'


END



EXEC(@vcQuery)



-- EXEC  dbo.UP_LIST_WF_ACL 0,1,100,'D','','' 
 -- EXEC  dbo.UP_LIST_WF_ACL 0,1,100,'P','','' 


--EXEC sp_executesql @nvcCountQuery, N'@nCnt INT OUTPUT', @nCNT = @intTotalCount OUTPUT 

	-- create table #temp(query text)
	-- insert into #temp values(@nvcCountQuery)
	-- select * from #temp
	-- drop table #temp
























GO
/****** Object:  StoredProcedure [dbo].[UP_LIST_WF_ACL_DOCLEVEL]    Script Date: 2015-10-15 오후 1:30:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
----------------------------------------------------------------------
----------------------------------------------------------------------
-- 작성자: 신상훈
-- 작성일: 2004.05.20
-- 수정일: 2004.05.20
-- 설   명: 그룹별 문서등급 조회
-- 테스트: EXEC  UP_LIST_WF_ACL_DOCLEVEL 'W4'
----------------------------------------------------------------------
-- 수정일 : 
-- 수정자 : 
-- 수정내용 : 
----------------------------------------------------------------------
----------------------------------------------------------------------
CREATE PROC [dbo].[UP_LIST_WF_ACL_DOCLEVEL]
	@vcGroupCode	varchar(4)
AS
SELECT A.DOC_LEVEL, B.CodeName
      FROM
      (
	(
	      SELECT DOC_LEVEL FROM eWFFORM.dbo.WF_ACL_GROUP WHERE GROUP_CODE = @vcGroupCode
	) as A
		INNER JOIN
	(
	      SELECT SubCode, CodeName FROM eManage.dbo.TB_CODE_SUB WHERE ClassCode = '11FL'
	) as B
		ON A.DOC_LEVEL = B.SubCode
      )
	ORDER BY A.DOC_LEVEL

GO
/****** Object:  StoredProcedure [dbo].[UP_LIST_WF_ACL_GROUP]    Script Date: 2015-10-15 오후 1:30:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


----------------------------------------------------------------------
----------------------------------------------------------------------
-- 작성자: 신상훈
-- 작성일: 2004.05.19
-- 수정일: 2004.05.19
-- 설  명: 그룹권한조회
-- 테스트: EXEC  UP_LIST_WF_ACL_GROUP
----------------------------------------------------------------------
-- 수정일 : 
-- 수정자 : 
-- 수정내용 : 
----------------------------------------------------------------------
----------------------------------------------------------------------
CREATE    PROC [dbo].[UP_LIST_WF_ACL_GROUP]
AS
-------------------------------------------------------------------------------
-- 내용 : WF_ACL_GROUP 의 데이터를 리스트에 맞게 구성하기 위하여 TempTable 사용
-------------------------------------------------------------------------------
CREATE TABLE [dbo].#GROUP_AUTH (
	[GROUP_ACLID] [int] IDENTITY (1, 1) NOT NULL ,
	[GROUP_CODE] [varchar] (10) COLLATE Korean_Wansung_CI_AS NOT NULL ,
	[GROUP_NAME] [varchar] (10) COLLATE Korean_Wansung_CI_AS NOT NULL ,
	[GROUP_AUTH] [varchar] (100) COLLATE Korean_Wansung_CI_AS NOT NULL 
) ON [PRIMARY]
DECLARE
		@vcGroupCode	varchar(10),		-- 직위코드
		@vcGroupName	varchar(10),	-- 직위이름
		@vcGroupAuthName varchar(100),	-- 문서등급내용들
		@vcDocLevel	varchar(4),			-- 문서등급코드
		@intStartFlag	int				-- 플래그
-------------------------------------------------------------------------------
-- 내용 : 커서를 사용하여 권한이 주어진 그룹에 대해 권한을 조회한다.
-------------------------------------------------------------------------------
DECLARE
	groupCode_Cursor  cursor for
		SELECT        DISTINCT GROUP_CODE
		      FROM     eWFFORM.dbo.WF_ACL_GROUP
	open groupCode_Cursor
	FETCH NEXT FROM groupCode_Cursor into @vcGroupCode
	WHILE @@FETCH_STATUS  = 0
	begin	-- WHILE#1
	
-------------------------------------------------------------------------------
-- 내용 : 그룹의 이름을 코드성테이블에서 가져온다.
-------------------------------------------------------------------------------
		SET @vcGroupName = 
			(SELECT CodeName 
				FROM eManage.dbo.TB_CODE_SUB
					WHERE SubCode = @vcGroupCode AND ClassCode = '10JW')
------------------------------------------------------------------------------------------------
-- 내용 : 커서를 사용하여 그룹에 맞는 권한(문서등급)을 조회한다.
------------------------------------------------------------------------------------------------
		DECLARE 
			docLevel_Cursor cursor for		
				SELECT DOC_LEVEL
					FROM eWFFORM.dbo.WF_ACL_GROUP
						WHERE GROUP_CODE = @vcGroupCode
							ORDER BY DOC_LEVEL
			open docLevel_Cursor
			FETCH NEXT FROM docLevel_Cursor into @vcDocLevel
			SET @intStartFlag = 0
-------------------------------------------------------------------------------
-- 내용 : 조회한 데이터를 그리드에 뿌려줄 형태로 구성한다.
-------------------------------------------------------------------------------
			WHILE @@FETCH_STATUS = 0			
			begin			
				IF @intStartFlag = 0
 				BEGIN				
				SET @vcGroupAuthName = (SELECT CodeName FROM eManage.dbo.TB_CODE_SUB WHERE SubCode = @vcDocLevel AND ClassCode = '11FL')			
				END
				IF @intStartFlag <> 0			
				BEGIN						
				SET @vcGroupAuthName = @vcGroupAuthName + ', ' + (SELECT CodeName FROM eManage.dbo.TB_CODE_SUB WHERE SubCode = @vcDocLevel AND ClassCode = '11FL')
				END
				SET @intStartFlag = @intStartFlag + 1
			
				FETCH NEXT FROM docLevel_Cursor into @vcDocLevel
			end
			close docLevel_Cursor
			deallocate docLevel_Cursor
-------------------------------------------------------------------------------
-- 내용 : TempTable에 구성된 데이터를 입력한다.
-------------------------------------------------------------------------------
		INSERT INTO [dbo].#GROUP_AUTH(GROUP_CODE, GROUP_NAME, GROUP_AUTH)
		SELECT @vcGroupCode, @vcGroupName, @vcGroupAuthName 
		FETCH NEXT FROM groupCode_Cursor into @vcGroupCode
	end	
close groupCode_Cursor
DEALLOCATE groupCode_Cursor
SELECT * FROM #GROUP_AUTH
DROP TABLE #GROUP_AUTH



GO
/****** Object:  StoredProcedure [dbo].[UP_LIST_WF_ACL_OTHER_DEPT]    Script Date: 2015-10-15 오후 1:30:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
----------------------------------------------------------------------
----------------------------------------------------------------------
-- 작성자: 신상훈
-- 작성일: 2004.03.08
-- 수정일: 2004.03.08
-- 설  명: 타부서 부서문서함 조회
-- 테스트: EXEC  UP_LIST_WF_ACL_OTHER_DEPT
----------------------------------------------------------------------
-- 수정일: 2004.03.18 
-- 수정자: 신상훈
-- 수정내용 : DB스키마 변경으로 인한 변수이름 변경
----------------------------------------------------------------------
----------------------------------------------------------------------
CREATE PROC [dbo].[UP_LIST_WF_ACL_OTHER_DEPT]
	@intUserId	int,	-- 사용자/부서ID
	@intDeptId	int,	-- 소속부서ID
	@cUserType Char(1)
	
AS
IF @cUserType = 'P'	-- 사용자권한관리
SELECT		DISTINCT	
			D.DeptId,
			D.DeptName, 
			C.DOC_FOLDER_ID,
			C.DOC_FOLDER_NAME, 
			C.ACLID
FROM		(SELECT		B.DOC_FOLDER_ID,
						B.DOC_FOLDER_NAME,
						A.ACLID,
						A.OTHER_DEPTID						
			FROM		(SELECT		DOC_FOLDER_ID,
									OTHER_DEPTID,
									ACLID
						FROM		eWFFORM.dbo.WF_ACL_OTHER_DEPT(NOLOCK)
						WHERE		USERID = @intUserId AND 
									DEPTID = @intDeptId AND 
									USER_TYPE = @cUserType) as A
						INNER JOIN
						(SELECT		DOC_FOLDER_NAME, 
									DOC_FOLDER_ID						
						FROM 		eWFFORM.dbo.Wf_DOC_FOLDER(NOLOCK)) as B	
						ON A.DOC_FOLDER_ID = B.DOC_FOLDER_ID) as C
			INNER JOIN
			(SELECT DeptID, 
					DeptName
			FROM eManage.dbo.VW_USER(NOLOCK)) as D
			ON D.DeptID = C.OTHER_DEPTID
ELSE	-- 부서권한관리
SELECT		DISTINCT	
			D.DeptId,
			D.DeptName, 
			C.DOC_FOLDER_ID,
			C.DOC_FOLDER_NAME, 
			C.ACLID
FROM		(SELECT		B.DOC_FOLDER_ID,
						B.DOC_FOLDER_NAME,
						A.ACLID,
						A.OTHER_DEPTID						
			FROM		(SELECT		DOC_FOLDER_ID,
									OTHER_DEPTID,
									ACLID
						FROM		eWFFORM.dbo.WF_ACL_OTHER_DEPT(NOLOCK)
						WHERE		DEPTID = @intDeptId AND 
									USER_TYPE = @cUserType) as A
						INNER JOIN
						(SELECT		DOC_FOLDER_NAME, 
									DOC_FOLDER_ID						
						FROM 		eWFFORM.dbo.Wf_DOC_FOLDER(NOLOCK)) as B	
						ON A.DOC_FOLDER_ID = B.DOC_FOLDER_ID) as C
			INNER JOIN
			(SELECT DeptID, 
					DeptName
			FROM eManage.dbo.VW_USER(NOLOCK)) as D
			ON D.DeptID = C.OTHER_DEPTID

GO
/****** Object:  StoredProcedure [dbo].[UP_LIST_WF_ACL_SEARCH]    Script Date: 2015-10-15 오후 1:30:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


















----------------------------------------------------------------------
----------------------------------------------------------------------
-- 작성자: 신상훈
-- 작성일: 2004.03.08
-- 수정일: 2004.03.08
-- 설  명: 사용자/부서권한 조회(리스트)
--		 : 리스트에는 사용자의 경우 소속부서와 직위, 이름만 나타난다.
--		 : 부서의 경우 부서이름만 나타난다.
-- 테스트: 
-- EXEC  dbo.UP_LIST_WF_ACL_SEARCH 0,1,100,'P','deptname','전자' 
--  EXEC  dbo.UP_LIST_WF_ACL_SEARCH 0,1,100,'P','username','신' 
-- EXEC  dbo.UP_LIST_WF_ACL_SEARCH 0,1,100,'D','deptname','전자'
----------------------------------------------------------------------
-- 수정일 : 
-- 수정자 : 
-- 수정내용 : 
----------------------------------------------------------------------
----------------------------------------------------------------------
CREATE                   PROC [dbo].[UP_LIST_WF_ACL_SEARCH]

	@intTotalCount 			int OUTPUT,	
	@intPageNum			int,
	@intNumPerPage      		int,
	@cUserType			char(1),
	@vcSearchColumn		varchar(20),
	@vcSearchText       		varchar(50)
	
AS

DECLARE
	
	@vcQuery			varchar(8000),
	@nvcCountQuery      		nvarchar(4000)


----------------------------------------------------------------------
-- 내용 : 총 게시물 수
----------------------------------------------------------------------
-- SET @nvcCountQuery = 	N'	SELECT	@nCnt = COUNT(*) '
-- +			N'	      FROM	'
-- +			N'	      (	'
-- +			N'	            SELECT		USERID, DEPTID'
-- +			N'		      FROM	eWFFORM.dbo.WF_ACL_SPECIAL_FOLDER(NOLOCK)		'
-- +			N'		            WHERE	USER_TYPE = ''' + @cUserType + ''''
-- +			N'	      UNION  '
-- +			N'	            SELECT		USERID, 	DEPTID'		
-- +			N'		      FROM	eWFFORM.dbo.WF_ACL_OTHER_DEPT(NOLOCK)		'
-- +			N'		            WHERE	USER_TYPE = ''' + @cUserType + ''''		
-- +			N'	      UNION  '
-- +			N'	            SELECT		USERID, 	DEPTID'		
-- +			N'		      FROM	eWFFORM.dbo.WF_ACL_SUBDEPT(NOLOCK)		'
-- +			N'		      WHERE	USER_TYPE = ''' + @cUserType + ''''
-- +			N'	      UNION  '
-- +			N'	            SELECT		USERID, 	DEPTID'		
-- +			N'		      FROM	eWFFORM.dbo.WF_ACL_FORM_LINE(NOLOCK)		'
-- +			N'		      WHERE	USER_TYPE = ''' + @cUserType + ''''
-- +			N'	      ) as A'
-- 
-- EXEC sp_executesql @nvcCountQuery, N'@nCnt INT OUTPUT', @nCNT = @intTotalCount OUTPUT



IF @cUserType = 'P' 
BEGIN
----------------------------------------------------------------------
-- 내용 : 리스트 구성
----------------------------------------------------------------------


	SET @vcQuery =	'	SELECT  C.DeptName, 
					C.JikWi, 
					C.UserName, 
					CASE substring(C.ABC, 1, 1) WHEN ''Y'' THEN ''권한있음'' ELSE  ''권한없음'' END as SPEDOCFOLDER_AUTH, 
					CASE substring(C.ABC, 2, 1) WHEN ''Y'' THEN ''권한있음'' ELSE  ''권한없음'' END as OTHERFOLDER_AUTH, 
					CASE substring(C.ABC, 3, 1) WHEN ''Y'' THEN ''권한있음'' ELSE  ''권한없음'' END as SUBFOLDER_AUTH,
					CASE substring(C.ABC, 4, 1) WHEN ''Y'' THEN ''권한있음'' ELSE  ''권한없음'' END as FORMLINE_AUTH,
					C.UserID,
					C.DeptID 
				FROM ('

	SET @vcQuery =	@vcQuery + '	 SELECT DISTINCT	 	TOP '+CAST(@intPageNum * @intNumPerPage AS varchar) + '
					A.DeptName,
						A.JikWi, 
						A.UserName, 										
						eWFFORM.dbo.UF_ACL_CHECK(A.DeptId, A.UserID, ''' + @cUserType + ''') as ABC,
						A.UserID, 
						A.DeptID
			     	      FROM	eManage.dbo.VW_USER as A

				INNER JOIN
				(
				SELECT		USERID, 	DEPTID 
			      	      FROM	eWFFORM.dbo.WF_ACL_SPECIAL_FOLDER(NOLOCK)
					WHERE		USER_TYPE = ''' + @cUserType + '''
				UNION ALL
				SELECT		USERID, 	DEPTID
				      FROM		eWFFORM.dbo.WF_ACL_OTHER_DEPT(NOLOCK)
					WHERE		USER_TYPE =  ''' + @cUserType + '''
				UNION ALL
				SELECT		USERID, 	DEPTID
				      FROM		eWFFORM.dbo.WF_ACL_SUBDEPT(NOLOCK)
					WHERE		USER_TYPE =  ''' + @cUserType + '''
				UNION ALL
				SELECT		USERID, 	DEPTID
				      FROM		eWFFORM.dbo.WF_ACL_FORM_LINE(NOLOCK)
					WHERE		USER_TYPE =  ''' + @cUserType + ''') as B
				ON A.UserID = B.USERID AND A.DeptID = B.DEPTID AND A.'+@vcSearchColumn+' like ''%'+@vcSearchText+'%''
				ORDER BY A.DeptID, A.UserID'
	SET @vcQuery =	@vcQuery + ' ) as C
		LEFT OUTER JOIN
			(SELECT	 DISTINCT TOP '+CAST((@intPageNum-1) * @intNumPerPage AS varchar) + '
					A.DeptName,
						A.JikWi, 
						A.UserName, 				
						eWFFORM.dbo.UF_ACL_CHECK(A.DeptId, A.UserID, ''' + @cUserType + ''') as ABC,
						A.UserID, 
						A.DeptID
			     	      FROM	eManage.dbo.VW_USER as A

				INNER JOIN
				(
				SELECT		USERID, 	DEPTID 
			      	      FROM	eWFFORM.dbo.WF_ACL_SPECIAL_FOLDER(NOLOCK)
					WHERE		USER_TYPE = ''' + @cUserType + '''
				UNION ALL
				SELECT		USERID, 	DEPTID
				      FROM		eWFFORM.dbo.WF_ACL_OTHER_DEPT(NOLOCK)
					WHERE		USER_TYPE = ''' + @cUserType + '''
				UNION ALL
				SELECT		USERID, 	DEPTID
				      FROM		eWFFORM.dbo.WF_ACL_SUBDEPT(NOLOCK)
					WHERE		USER_TYPE = ''' + @cUserType + '''
				UNION ALL
				SELECT		USERID, 	DEPTID
				      FROM		eWFFORM.dbo.WF_ACL_FORM_LINE(NOLOCK)
					WHERE		USER_TYPE = ''' + @cUserType + ''') as B
				ON A.UserID = B.USERID AND A.DeptID = B.DEPTID AND A.'+@vcSearchColumn+' like ''%'+@vcSearchText+'%''
				ORDER BY A.DeptID, A.UserID) as D
		ON 	C.UserID = D.USERID AND C.DeptId = D.DeptId
		WHERE D.UserID IS NULL AND D.DeptId IS NULL'
END

IF @cUserType = 'D' 
BEGIN

SET @vcQuery =	'SELECT  C.DeptName, 					
				CASE substring(C.ABC, 1, 1) WHEN ''Y'' THEN ''권한있음'' ELSE  ''권한없음'' END as SPEDOCFOLDER_AUTH, 
				CASE substring(C.ABC, 2, 1) WHEN ''Y'' THEN ''권한있음'' ELSE  ''권한없음'' END as OTHERFOLDER_AUTH, 
				CASE substring(C.ABC, 3, 1) WHEN ''Y'' THEN ''권한있음'' ELSE  ''권한없음'' END as SUBFOLDER_AUTH,
				CASE substring(C.ABC, 4, 1) WHEN ''Y'' THEN ''권한있음'' ELSE  ''권한없음'' END as FORMLINE_AUTH,
				C.DeptID 
				FROM ('

	SET @vcQuery =	@vcQuery + ' SELECT DISTINCT TOP '+CAST(@intPageNum * @intNumPerPage AS varchar) + '
					A.DeptName,
														
						eWFFORM.dbo.UF_ACL_CHECK(A.DeptId, A.DeptId, ''' + @cUserType + ''') as ABC,						
						A.DeptID
			     	      FROM	eManage.dbo.VW_DEPT as A

				INNER JOIN
				(
				SELECT			DEPTID 
			      	      FROM	eWFFORM.dbo.WF_ACL_SPECIAL_FOLDER(NOLOCK)
					WHERE		USER_TYPE = ''' + @cUserType + '''
				UNION ALL
				SELECT			DEPTID
				      FROM		eWFFORM.dbo.WF_ACL_OTHER_DEPT(NOLOCK)
					WHERE		USER_TYPE =  ''' + @cUserType + '''
				UNION ALL
				SELECT			DEPTID
				      FROM		eWFFORM.dbo.WF_ACL_SUBDEPT(NOLOCK)
					WHERE		USER_TYPE =  ''' + @cUserType + '''
				UNION ALL
				SELECT			DEPTID
				      FROM		eWFFORM.dbo.WF_ACL_FORM_LINE(NOLOCK)
					WHERE		USER_TYPE =  ''' + @cUserType + ''') as B
				ON A.DeptID = B.DEPTID AND A.'+@vcSearchColumn+' like ''%'+@vcSearchText+'%''
				ORDER BY A.DeptID'
	SET @vcQuery =	@vcQuery + ' ) as C
		LEFT OUTER JOIN
			(SELECT	 DISTINCT	TOP '+CAST((@intPageNum-1) * @intNumPerPage AS varchar) + '
					A.DeptName,
								
						eWFFORM.dbo.UF_ACL_CHECK(A.DeptId, A.DeptId, ''' + @cUserType + ''') as ABC,						
						A.DeptID
			     	      FROM	eManage.dbo.VW_DEPT as A

				INNER JOIN
				(
				SELECT			DEPTID 
			      	      FROM	eWFFORM.dbo.WF_ACL_SPECIAL_FOLDER(NOLOCK)
					WHERE		USER_TYPE = ''' + @cUserType + '''
				UNION ALL
				SELECT			DEPTID
				      FROM		eWFFORM.dbo.WF_ACL_OTHER_DEPT(NOLOCK)
					WHERE		USER_TYPE = ''' + @cUserType + '''
				UNION ALL
				SELECT			DEPTID
				      FROM		eWFFORM.dbo.WF_ACL_SUBDEPT(NOLOCK)
					WHERE		USER_TYPE = ''' + @cUserType + '''
				UNION ALL
				SELECT			DEPTID
				      FROM		eWFFORM.dbo.WF_ACL_FORM_LINE(NOLOCK)
					WHERE		USER_TYPE = ''' + @cUserType + ''') as B
				ON A.DeptID = B.DEPTID AND A.'+@vcSearchColumn+' like ''%'+@vcSearchText+'%''
				ORDER BY A.DeptID) as D
		ON 	C.DeptId = D.DeptId
		WHERE	D.DeptId IS NULL
		ORDER BY D.DeptName'


END



--EXEC(@vcQuery)


--SELECT @intTotalCount = @@ROWCOUNT
 
--EXEC sp_executesql @nvcCountQuery, N'@nCnt INT OUTPUT', @nCNT = @intTotalCount OUTPUT 

create table #temp(query text)
insert into #temp values(@vcQuery)
select * from #temp
drop table #temp


















GO
/****** Object:  StoredProcedure [dbo].[UP_LIST_WF_ACL_SPECIAL_FOLDER]    Script Date: 2015-10-15 오후 1:30:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
----------------------------------------------------------------------
----------------------------------------------------------------------
-- 작성자: LDCC 신상훈
-- 작성일: 2004.03.08
-- 수정일: 2004.03.08
-- 설  명: 자기부서의 특정권한문서함 조회	
-- 테스트: EXEC  UP_LIST_WF_ACL_SPECIAL_FOLDER  
----------------------------------------------------------------------
-- 수정일 : 2004.03.24
-- 수정자 : LDCC 신상훈
-- 수정내용 : 조회시 DOC_FOLDER_ID 포함
----------------------------------------------------------------------
----------------------------------------------------------------------
CREATE PROC [dbo].[UP_LIST_WF_ACL_SPECIAL_FOLDER]
	@intUserId		int,	-- 사용자/부서ID
	@intDeptId		int,	-- 소속부서ID	
	@cUserType		Char(1)
	
	
AS
IF @cUserType = 'P'	-- 사용자권한관리
SELECT	B.DOC_FOLDER_ID,
		B.DOC_FOLDER_NAME,
		A.ACLID
FROM
		(SELECT	DOC_FOLDER_ID,
				ACLID
		FROM	eWFFORM.dbo.WF_ACL_SPECIAL_FOLDER(NOLOCK)
		WHERE	USERID = @intUserId AND DEPTID = @intDeptId AND USER_TYPE = @cUserType) as A
		INNER JOIN
		(SELECT DOC_FOLDER_NAME, 
				DOC_FOLDER_ID
		FROM	eWFFORM.dbo.Wf_DOC_FOLDER) as B
	
		ON A.DOC_FOLDER_ID = B.DOC_FOLDER_ID
		
ELSE		-- 부서권한관리
SELECT	B.DOC_FOLDER_ID,
		B.DOC_FOLDER_NAME,
		A.ACLID
FROM
		(SELECT	DOC_FOLDER_ID,
				ACLID
		FROM	eWFFORM.dbo.WF_ACL_SPECIAL_FOLDER(NOLOCK)
		WHERE	DEPTID = @intDeptId AND USER_TYPE = @cUserType) as A
		INNER JOIN
		(SELECT DOC_FOLDER_NAME, 
				DOC_FOLDER_ID
		FROM	eWFFORM.dbo.Wf_DOC_FOLDER) as B
	
		ON A.DOC_FOLDER_ID = B.DOC_FOLDER_ID

GO
/****** Object:  StoredProcedure [dbo].[UP_LIST_WF_ACL_SUBDEPT]    Script Date: 2015-10-15 오후 1:30:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
----------------------------------------------------------------------
----------------------------------------------------------------------
-- 작성자: 신상훈
-- 작성일: 2004.03.08
-- 수정일: 2004.03.08
-- 설  명: 하위부서 부서문서함 조회
-- 테스트: EXEC  UP_LIST_WF_ACL_SUBDEPT	1
----------------------------------------------------------------------
-- 수정일 : 
-- 수정자 : 
-- 수정내용 : 
----------------------------------------------------------------------
----------------------------------------------------------------------
CREATE PROC [dbo].[UP_LIST_WF_ACL_SUBDEPT]
	@intUserId	int,	-- 사용자/부서ID
	@intDeptId	int,	-- 소속부서ID
	@cUserType	Char(1)
	
AS
IF @cUserType = 'P'	-- 사용자권한관리
SELECT	USERID,
		ACLID
FROM	eWFFORM.dbo.WF_ACL_SUBDEPT(NOLOCK)
WHERE	USERID = @intUserId AND DEPTID = @intDeptId AND USER_TYPE = @cUserType
ELSE		-- 부서권한관리
SELECT	USERID,
		ACLID
FROM	eWFFORM.dbo.WF_ACL_SUBDEPT(NOLOCK)
WHERE	DEPTID = @intDeptId AND USER_TYPE = @cUserType

GO
/****** Object:  StoredProcedure [dbo].[UP_LIST_WF_ACL_TEST]    Script Date: 2015-10-15 오후 1:30:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO











----------------------------------------------------------------------
----------------------------------------------------------------------
-- 작성자: 신상훈
-- 작성일: 2004.03.08
-- 수정일: 2004.03.08
-- 설  명: 사용자/부서권한 조회(리스트)
--		 : 리스트에는 사용자의 경우 소속부서와 직위, 이름만 나타난다.
--		 : 부서의 경우 부서이름만 나타난다.
-- 테스트: EXEC  UP_LIST_WF_ACL_TEST 0,1,100,'P'
----------------------------------------------------------------------
-- 수정일 : 
-- 수정자 : 
-- 수정내용 : 
----------------------------------------------------------------------
----------------------------------------------------------------------
CREATE            PROC [dbo].[UP_LIST_WF_ACL_TEST]

	@intTotalCount 			int OUTPUT,	
	@intPageNum			int,
	@intNumPerPage      		int,
	@cUserType			char(1)
--	@vcSearchColumn		varchar(20),
--	@vcSearchText       		varchar(50)
	
AS

DECLARE
	
	@vcQuery			varchar(8000),
	@nvcCountQuery      		nvarchar(4000),
	@nTotalCount			int


----------------------------------------------------------------------
-- 내용 : 총 게시물 수
----------------------------------------------------------------------
-- SET @nvcCountQuery = 	N'	SELECT	@nCnt = COUNT(*) '
-- +			N'	      FROM	'
-- +			N'	      (	'
-- +			N'	            SELECT		USERID, DEPTID'
-- +			N'		      FROM	eWFFORM.dbo.WF_ACL_SPECIAL_FOLDER(NOLOCK)		'
-- +			N'		            WHERE	USER_TYPE = ''' + @cUserType + ''''
-- +			N'	      UNION  '
-- +			N'	            SELECT		USERID, 	DEPTID'		
-- +			N'		      FROM	eWFFORM.dbo.WF_ACL_OTHER_DEPT(NOLOCK)		'
-- +			N'		            WHERE	USER_TYPE = ''' + @cUserType + ''''		
-- +			N'	      UNION  '
-- +			N'	            SELECT		USERID, 	DEPTID'		
-- +			N'		      FROM	eWFFORM.dbo.WF_ACL_SUBDEPT(NOLOCK)		'
-- +			N'		      WHERE	USER_TYPE = ''' + @cUserType + ''''
-- +			N'	      UNION  '
-- +			N'	            SELECT		USERID, 	DEPTID'		
-- +			N'		      FROM	eWFFORM.dbo.WF_ACL_FORM_LINE(NOLOCK)		'
-- +			N'		      WHERE	USER_TYPE = ''' + @cUserType + ''''
-- +			N'	      ) as A'
-- 
-- EXEC sp_executesql @nvcCountQuery, N'@nCnt INT OUTPUT', @nCNT = @intTotalCount OUTPUT



IF @cUserType = 'P'
BEGIN
----------------------------------------------------------------------
-- 내용 : 리스트 구성
----------------------------------------------------------------------


	SET @vcQuery =	'	SELECT  C.DeptName, 
					C.JikWi, 
					C.UserName, 
					CASE substring(C.ABC, 1, 1) WHEN ''Y'' THEN ''권한있음'' ELSE  ''권한없음'' END as SPEDOCFOLDER_AUTH, 
					CASE substring(C.ABC, 2, 1) WHEN ''Y'' THEN ''권한있음'' ELSE  ''권한없음'' END as OTHERFOLDER_AUTH, 
					CASE substring(C.ABC, 3, 1) WHEN ''Y'' THEN ''권한있음'' ELSE  ''권한없음'' END as SUBFOLDER_AUTH,
					CASE substring(C.ABC, 4, 1) WHEN ''Y'' THEN ''권한있음'' ELSE  ''권한없음'' END as FORMLINE_AUTH,
					C.UserID,
					C.DeptID
				FROM ('

	SET @vcQuery =	@vcQuery + '	 SELECT DISTINCT	 	TOP '+CAST(@intPageNum * @intNumPerPage AS varchar) + '
					A.DeptName,
						A.JikWi, 
						A.UserName, 										
						eWFFORM.dbo.UF_ACL_CHECK(A.DeptId, A.UserID, ''' + @cUserType + ''') as ABC,
						A.UserID, 
						A.DeptID
			     	      FROM	eManage.dbo.VW_USER as A

				INNER JOIN
				(
				SELECT		USERID, 	DEPTID 
			      	      FROM	eWFFORM.dbo.WF_ACL_SPECIAL_FOLDER(NOLOCK)
					WHERE		USER_TYPE = ''' + @cUserType + '''
				UNION ALL
				SELECT		USERID, 	DEPTID
				      FROM		eWFFORM.dbo.WF_ACL_OTHER_DEPT(NOLOCK)
					WHERE		USER_TYPE =  ''' + @cUserType + '''
				UNION ALL
				SELECT		USERID, 	DEPTID
				      FROM		eWFFORM.dbo.WF_ACL_SUBDEPT(NOLOCK)
					WHERE		USER_TYPE =  ''' + @cUserType + '''
				UNION ALL
				SELECT		USERID, 	DEPTID
				      FROM		eWFFORM.dbo.WF_ACL_FORM_LINE(NOLOCK)
					WHERE		USER_TYPE =  ''' + @cUserType + ''') as B
				ON A.UserID = B.USERID AND A.DeptID = B.DEPTID
				ORDER BY A.DeptID, A.UserID'
	SET @vcQuery =	@vcQuery + ' ) as C
		LEFT OUTER JOIN
			(SELECT	 DISTINCT	TOP '+CAST((@intPageNum-1) * @intNumPerPage AS varchar) + '
					A.DeptName,
						A.JikWi, 
						A.UserName, 				
						eWFFORM.dbo.UF_ACL_CHECK(A.DeptId, A.UserID, ''' + @cUserType + ''') as ABC,
						A.UserID, 
						A.DeptID
			     	      FROM	eManage.dbo.VW_USER as A

				INNER JOIN
				(
				SELECT		USERID, 	DEPTID 
			      	      FROM	eWFFORM.dbo.WF_ACL_SPECIAL_FOLDER(NOLOCK)
					WHERE		USER_TYPE = ''' + @cUserType + '''
				UNION ALL
				SELECT		USERID, 	DEPTID
				      FROM		eWFFORM.dbo.WF_ACL_OTHER_DEPT(NOLOCK)
					WHERE		USER_TYPE = ''' + @cUserType + '''
				UNION ALL
				SELECT		USERID, 	DEPTID
				      FROM		eWFFORM.dbo.WF_ACL_SUBDEPT(NOLOCK)
					WHERE		USER_TYPE = ''' + @cUserType + '''
				UNION ALL
				SELECT		USERID, 	DEPTID
				      FROM		eWFFORM.dbo.WF_ACL_FORM_LINE(NOLOCK)
					WHERE		USER_TYPE = ''' + @cUserType + ''') as B
				ON A.UserID = B.USERID AND A.DeptID = B.DEPTID
				ORDER BY A.DeptID, A.UserID) as D
		ON 	C.UserID = D.USERID AND C.DeptId = D.DeptId
		WHERE D.UserID IS NULL AND D.DeptId IS NULL'
END

IF @cUserType = 'D'
BEGIN

SET @vcQuery =	'	SELECT  C.DeptName, 					
				CASE substring(C.ABC, 1, 1) WHEN ''Y'' THEN ''권한있음'' ELSE  ''권한없음'' END as SPEDOCFOLDER_AUTH, 
				CASE substring(C.ABC, 2, 1) WHEN ''Y'' THEN ''권한있음'' ELSE  ''권한없음'' END as OTHERFOLDER_AUTH, 
				CASE substring(C.ABC, 3, 1) WHEN ''Y'' THEN ''권한있음'' ELSE  ''권한없음'' END as SUBFOLDER_AUTH,
				CASE substring(C.ABC, 4, 1) WHEN ''Y'' THEN ''권한있음'' ELSE  ''권한없음'' END as FORMLINE_AUTH,
				C.DeptID 
				FROM ('

	SET @vcQuery =	@vcQuery + '	 SELECT DISTINCT	 	TOP '+CAST(@intPageNum * @intNumPerPage AS varchar) + '
					A.DeptName,
														
						eWFFORM.dbo.UF_ACL_CHECK(A.DeptId, A.DeptId, ''' + @cUserType + ''') as ABC,						
						A.DeptID
			     	      FROM	eManage.dbo.VW_DEPT as A

				INNER JOIN
				(
				SELECT			DEPTID 
			      	      FROM	eWFFORM.dbo.WF_ACL_SPECIAL_FOLDER(NOLOCK)
					WHERE		USER_TYPE = ''' + @cUserType + '''
				UNION ALL
				SELECT			DEPTID
				      FROM		eWFFORM.dbo.WF_ACL_OTHER_DEPT(NOLOCK)
					WHERE		USER_TYPE =  ''' + @cUserType + '''
				UNION ALL
				SELECT			DEPTID
				      FROM		eWFFORM.dbo.WF_ACL_SUBDEPT(NOLOCK)
					WHERE		USER_TYPE =  ''' + @cUserType + '''
				UNION ALL
				SELECT			DEPTID
				      FROM		eWFFORM.dbo.WF_ACL_FORM_LINE(NOLOCK)
					WHERE		USER_TYPE =  ''' + @cUserType + ''') as B
				ON A.DeptID = B.DEPTID
				ORDER BY A.DeptID'
	SET @vcQuery =	@vcQuery + ' ) as C
		LEFT OUTER JOIN
			(SELECT	 DISTINCT	TOP '+CAST((@intPageNum-1) * @intNumPerPage AS varchar) + '
					A.DeptName,
								
						eWFFORM.dbo.UF_ACL_CHECK(A.DeptId, A.DeptId, ''' + @cUserType + ''') as ABC,						
						A.DeptID
			     	      FROM	eManage.dbo.VW_DEPT as A

				INNER JOIN
				(
				SELECT			DEPTID 
			      	      FROM	eWFFORM.dbo.WF_ACL_SPECIAL_FOLDER(NOLOCK)
					WHERE		USER_TYPE = ''' + @cUserType + '''
				UNION ALL
				SELECT			DEPTID
				      FROM		eWFFORM.dbo.WF_ACL_OTHER_DEPT(NOLOCK)
					WHERE		USER_TYPE = ''' + @cUserType + '''
				UNION ALL
				SELECT			DEPTID
				      FROM		eWFFORM.dbo.WF_ACL_SUBDEPT(NOLOCK)
					WHERE		USER_TYPE = ''' + @cUserType + '''
				UNION ALL
				SELECT			DEPTID
				      FROM		eWFFORM.dbo.WF_ACL_FORM_LINE(NOLOCK)
					WHERE		USER_TYPE = ''' + @cUserType + ''') as B
				ON A.DeptID = B.DEPTID
				ORDER BY A.DeptID) as D
		ON 	C.DeptId = D.DeptId
		WHERE	D.DeptId IS NULL
		ORDER BY D.DeptName'


END



EXEC(@vcQuery)

SET @nTotalCount = @@ROWCOUNT
-- SELECT @nTotalCount

SET @nvcCountQuery = N' SELECT @nTotalCount'
 
EXEC sp_executesql @nvcCountQuery, N'@nTotalCount INT OUTPUT', @nTotalCount = @intTotalCount OUTPUT 


-- create table #temp(query text)
-- insert into #temp values(@vcQuery)
-- select * from #temp
-- drop table #temp











GO
/****** Object:  StoredProcedure [dbo].[UP_LIST_WF_ACL_TEST_TEST]    Script Date: 2015-10-15 오후 1:30:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO












----------------------------------------------------------------------
----------------------------------------------------------------------
-- 작성자: 신상훈
-- 작성일: 2004.03.08
-- 수정일: 2004.03.08
-- 설  명: 사용자/부서권한 조회(리스트)
--		 : 리스트에는 사용자의 경우 소속부서와 직위, 이름만 나타난다.
--		 : 부서의 경우 부서이름만 나타난다.
-- 테스트: EXEC  UP_LIST_WF_ACL_TEST_TEST 0,1,100,'P'
----------------------------------------------------------------------
-- 수정일 : 
-- 수정자 : 
-- 수정내용 : 
----------------------------------------------------------------------
----------------------------------------------------------------------
CREATE    PROC [dbo].[UP_LIST_WF_ACL_TEST_TEST]

	@intTotalCount 			int OUTPUT,	
	@intPageNum			int,
	@intNumPerPage      		int,
	@cUserType			char(1)
--	@vcSearchColumn		varchar(20),
--	@vcSearchText       		varchar(50)
	
AS

DECLARE
	
	@vcQuery			varchar(8000),
	@nvcCountQuery      		nvarchar(4000),
	@nTotalCount			int


----------------------------------------------------------------------
-- 내용 : 총 게시물 수
----------------------------------------------------------------------
-- SET @nvcCountQuery = 	N'	SELECT	@nCnt = COUNT(*) '
-- +			N'	      FROM	'
-- +			N'	      (	'
-- +			N'	            SELECT		USERID, DEPTID'
-- +			N'		      FROM	eWFFORM.dbo.WF_ACL_SPECIAL_FOLDER(NOLOCK)		'
-- +			N'		            WHERE	USER_TYPE = ''' + @cUserType + ''''
-- +			N'	      UNION  '
-- +			N'	            SELECT		USERID, 	DEPTID'		
-- +			N'		      FROM	eWFFORM.dbo.WF_ACL_OTHER_DEPT(NOLOCK)		'
-- +			N'		            WHERE	USER_TYPE = ''' + @cUserType + ''''		
-- +			N'	      UNION  '
-- +			N'	            SELECT		USERID, 	DEPTID'		
-- +			N'		      FROM	eWFFORM.dbo.WF_ACL_SUBDEPT(NOLOCK)		'
-- +			N'		      WHERE	USER_TYPE = ''' + @cUserType + ''''
-- +			N'	      UNION  '
-- +			N'	            SELECT		USERID, 	DEPTID'		
-- +			N'		      FROM	eWFFORM.dbo.WF_ACL_FORM_LINE(NOLOCK)		'
-- +			N'		      WHERE	USER_TYPE = ''' + @cUserType + ''''
-- +			N'	      ) as A'

-- EXEC sp_executesql @nvcCountQuery, N'@nCnt INT OUTPUT', @nCNT = @intTotalCount OUTPUT



IF @cUserType = 'P'
BEGIN
----------------------------------------------------------------------
-- 내용 : 리스트 구성
----------------------------------------------------------------------


	SET @vcQuery =	'	SELECT  C.DeptName, 
					C.JikWi, 
					C.UserName, 
					CASE substring(C.ABC, 1, 1) WHEN ''Y'' THEN ''권한있음'' ELSE  ''권한없음'' END as SPEDOCFOLDER_AUTH, 
					CASE substring(C.ABC, 2, 1) WHEN ''Y'' THEN ''권한있음'' ELSE  ''권한없음'' END as OTHERFOLDER_AUTH, 
					CASE substring(C.ABC, 3, 1) WHEN ''Y'' THEN ''권한있음'' ELSE  ''권한없음'' END as SUBFOLDER_AUTH,
					CASE substring(C.ABC, 4, 1) WHEN ''Y'' THEN ''권한있음'' ELSE  ''권한없음'' END as FORMLINE_AUTH,
					C.UserID,
					C.DeptID
				FROM ('

	SET @vcQuery =	@vcQuery + '	 SELECT DISTINCT	 	TOP '+CAST(@intPageNum * @intNumPerPage AS varchar) + '
					A.DeptName,
						A.JikWi, 
						A.UserName, 										
						eWFFORM.dbo.UF_ACL_CHECK(A.DeptId, A.UserID, ''' + @cUserType + ''') as ABC,
						A.UserID, 
						A.DeptID
			     	      FROM	eManage.dbo.VW_USER as A

				INNER JOIN
				(
				SELECT		USERID, 	DEPTID 
			      	      FROM	eWFFORM.dbo.WF_ACL_SPECIAL_FOLDER(NOLOCK)
					WHERE		USER_TYPE = ''' + @cUserType + '''
				UNION ALL
				SELECT		USERID, 	DEPTID
				      FROM		eWFFORM.dbo.WF_ACL_OTHER_DEPT(NOLOCK)
					WHERE		USER_TYPE =  ''' + @cUserType + '''
				UNION ALL
				SELECT		USERID, 	DEPTID
				      FROM		eWFFORM.dbo.WF_ACL_SUBDEPT(NOLOCK)
					WHERE		USER_TYPE =  ''' + @cUserType + '''
				UNION ALL
				SELECT		USERID, 	DEPTID
				      FROM		eWFFORM.dbo.WF_ACL_FORM_LINE(NOLOCK)
					WHERE		USER_TYPE =  ''' + @cUserType + ''') as B
				ON A.UserID = B.USERID AND A.DeptID = B.DEPTID
				ORDER BY A.DeptID, A.UserID'
	SET @vcQuery =	@vcQuery + ' ) as C
		LEFT OUTER JOIN
			(SELECT	 DISTINCT	TOP '+CAST((@intPageNum-1) * @intNumPerPage AS varchar) + '
					A.DeptName,
						A.JikWi, 
						A.UserName, 				
						eWFFORM.dbo.UF_ACL_CHECK(A.DeptId, A.UserID, ''' + @cUserType + ''') as ABC,
						A.UserID, 
						A.DeptID
			     	      FROM	eManage.dbo.VW_USER as A

				INNER JOIN
				(
				SELECT		USERID, 	DEPTID 
			      	      FROM	eWFFORM.dbo.WF_ACL_SPECIAL_FOLDER(NOLOCK)
					WHERE		USER_TYPE = ''' + @cUserType + '''
				UNION ALL
				SELECT		USERID, 	DEPTID
				      FROM		eWFFORM.dbo.WF_ACL_OTHER_DEPT(NOLOCK)
					WHERE		USER_TYPE = ''' + @cUserType + '''
				UNION ALL
				SELECT		USERID, 	DEPTID
				      FROM		eWFFORM.dbo.WF_ACL_SUBDEPT(NOLOCK)
					WHERE		USER_TYPE = ''' + @cUserType + '''
				UNION ALL
				SELECT		USERID, 	DEPTID
				      FROM		eWFFORM.dbo.WF_ACL_FORM_LINE(NOLOCK)
					WHERE		USER_TYPE = ''' + @cUserType + ''') as B
				ON A.UserID = B.USERID AND A.DeptID = B.DEPTID
				ORDER BY A.DeptID, A.UserID) as D
		ON 	C.UserID = D.USERID AND C.DeptId = D.DeptId
		WHERE D.UserID IS NULL AND D.DeptId IS NULL'
END

IF @cUserType = 'D'
BEGIN

SET @vcQuery =	'	SELECT  C.DeptName, 					
				CASE substring(C.ABC, 1, 1) WHEN ''Y'' THEN ''권한있음'' ELSE  ''권한없음'' END as SPEDOCFOLDER_AUTH, 
				CASE substring(C.ABC, 2, 1) WHEN ''Y'' THEN ''권한있음'' ELSE  ''권한없음'' END as OTHERFOLDER_AUTH, 
				CASE substring(C.ABC, 3, 1) WHEN ''Y'' THEN ''권한있음'' ELSE  ''권한없음'' END as SUBFOLDER_AUTH,
				CASE substring(C.ABC, 4, 1) WHEN ''Y'' THEN ''권한있음'' ELSE  ''권한없음'' END as FORMLINE_AUTH,
				C.DeptID 
				FROM ('

	SET @vcQuery =	@vcQuery + '	 SELECT DISTINCT	 	TOP '+CAST(@intPageNum * @intNumPerPage AS varchar) + '
					A.DeptName,
														
						eWFFORM.dbo.UF_ACL_CHECK(A.DeptId, A.DeptId, ''' + @cUserType + ''') as ABC,						
						A.DeptID
			     	      FROM	eManage.dbo.VW_DEPT as A

				INNER JOIN
				(
				SELECT			DEPTID 
			      	      FROM	eWFFORM.dbo.WF_ACL_SPECIAL_FOLDER(NOLOCK)
					WHERE		USER_TYPE = ''' + @cUserType + '''
				UNION ALL
				SELECT			DEPTID
				      FROM		eWFFORM.dbo.WF_ACL_OTHER_DEPT(NOLOCK)
					WHERE		USER_TYPE =  ''' + @cUserType + '''
				UNION ALL
				SELECT			DEPTID
				      FROM		eWFFORM.dbo.WF_ACL_SUBDEPT(NOLOCK)
					WHERE		USER_TYPE =  ''' + @cUserType + '''
				UNION ALL
				SELECT			DEPTID
				      FROM		eWFFORM.dbo.WF_ACL_FORM_LINE(NOLOCK)
					WHERE		USER_TYPE =  ''' + @cUserType + ''') as B
				ON A.DeptID = B.DEPTID
				ORDER BY A.DeptID'
	SET @vcQuery =	@vcQuery + ' ) as C
		LEFT OUTER JOIN
			(SELECT	 DISTINCT	TOP '+CAST((@intPageNum-1) * @intNumPerPage AS varchar) + '
					A.DeptName,
								
						eWFFORM.dbo.UF_ACL_CHECK(A.DeptId, A.DeptId, ''' + @cUserType + ''') as ABC,						
						A.DeptID
			     	      FROM	eManage.dbo.VW_DEPT as A

				INNER JOIN
				(
				SELECT			DEPTID 
			      	      FROM	eWFFORM.dbo.WF_ACL_SPECIAL_FOLDER(NOLOCK)
					WHERE		USER_TYPE = ''' + @cUserType + '''
				UNION ALL
				SELECT			DEPTID
				      FROM		eWFFORM.dbo.WF_ACL_OTHER_DEPT(NOLOCK)
					WHERE		USER_TYPE = ''' + @cUserType + '''
				UNION ALL
				SELECT			DEPTID
				      FROM		eWFFORM.dbo.WF_ACL_SUBDEPT(NOLOCK)
					WHERE		USER_TYPE = ''' + @cUserType + '''
				UNION ALL
				SELECT			DEPTID
				      FROM		eWFFORM.dbo.WF_ACL_FORM_LINE(NOLOCK)
					WHERE		USER_TYPE = ''' + @cUserType + ''') as B
				ON A.DeptID = B.DEPTID
				ORDER BY A.DeptID) as D
		ON 	C.DeptId = D.DeptId
		WHERE	D.DeptId IS NULL
		ORDER BY D.DeptName'


END



EXEC(@vcQuery)
declare @a	varchar(50)


SET @a = @@ROWCOUNT

SET @nvcCountQuery = 	N'	SELECT	@nCnt = ' + @a


EXEC sp_executesql @nvcCountQuery, N'@nCnt INT OUTPUT', @nCNT = @intTotalCount OUTPUT
-- SELECT @a
-- 
-- SET @nTotalCount = @@ROWCOUNT
-- -- SELECT @nTotalCount
-- 
-- SET @nvcCountQuery = N' SELECT @nTotalCount'
--  
-- EXEC sp_executesql @nvcCountQuery, N'@nTotalCount INT OUTPUT', @nTotalCount = @intTotalCount OUTPUT


-- create table #temp(query text)
-- insert into #temp values(@vcQuery)
-- select * from #temp
-- drop table #temp












GO
/****** Object:  StoredProcedure [dbo].[UP_LIST_WF_ACL_TOTAL]    Script Date: 2015-10-15 오후 1:30:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





----------------------------------------------------------------------
----------------------------------------------------------------------
-- 작성자: 신상훈
-- 작성일: 2004.03.08
-- 수정일: 2004.03.08
-- 설  명: 사용자/부서권한 조회(리스트)
--		 : 리스트에는 사용자의 경우 소속부서와 직위, 이름만 나타난다.
--		 : 부서의 경우 부서이름만 나타난다.	
-- 테스트: EXEC  UP_LIST_WF_ACL_TOTAL 'P'
----------------------------------------------------------------------
-- 수정일 : 
-- 수정자 : 
-- 수정내용 : 
----------------------------------------------------------------------
----------------------------------------------------------------------
CREATE      PROC [dbo].[UP_LIST_WF_ACL_TOTAL]
	
	@cUserType	char(1)
	
AS

IF @cUserType = 'P'

SELECT 	DISTINCT	A.DeptName, 
					A.JikWi, 
					A.UserName, 				
					CASE substring(eWFFORM.dbo.UF_ACL_CHECK(A.DeptID, A.UserID, @cUserType), 1, 1) WHEN 'Y' THEN '권한있음' ELSE '권한없음' END as SPECIAL_FOLDER_ACLID,
					CASE substring(eWFFORM.dbo.UF_ACL_CHECK(A.DeptID, A.UserID, @cUserType), 2, 1) WHEN 'Y' THEN '권한있음' ELSE '권한없음' END as OTHER_DEPT_ACLID,
					CASE substring(eWFFORM.dbo.UF_ACL_CHECK(A.DeptID, A.UserID, @cUserType), 3, 1) WHEN 'Y' THEN '권한있음' ELSE '권한없음' END as SUB_DEPT_ACLID,
					CASE substring(eWFFORM.dbo.UF_ACL_CHECK(A.DeptID, A.UserID, @cUserType), 4, 1) WHEN 'Y' THEN '권한있음' ELSE '권한없음' END as FORM_LINE_ACLID,
					A.UserID, 
					A.DeptID
FROM	eManage.dbo.VW_USER as A
		INNER JOIN
		(SELECT		USERID, 
					DEPTID 
		FROM		eWFFORM.dbo.WF_ACL_SPECIAL_FOLDER(NOLOCK)
		WHERE		USER_TYPE = @cUserType
			
		UNION ALL
			
		SELECT		USERID, 
					DEPTID
		FROM		eWFFORM.dbo.WF_ACL_OTHER_DEPT(NOLOCK)
		WHERE		USER_TYPE =   @cUserType
			
		UNION ALL
			
		SELECT		USERID, 
					DEPTID
		FROM		eWFFORM.dbo.WF_ACL_SUBDEPT(NOLOCK)
		WHERE		USER_TYPE =   @cUserType

		UNION ALL
			
		SELECT		USERID, 
					DEPTID
		FROM		eWFFORM.dbo.WF_ACL_FORM_LINE(NOLOCK)
		WHERE		USER_TYPE =   @cUserType) as B

		ON A.UserID = B.USERID AND A.DeptID = B.DEPTID
--WHERE SPECIAL_FOLDER_ACLID = 
		
ELSE 

SELECT	DISTINCT	A.DeptName, 									
					CASE substring(eWFFORM.dbo.UF_ACL_CHECK(A.DeptID, A.UserID, @cUserType), 1, 1) WHEN 'Y' THEN '권한있음' ELSE '권한없음' END as SPECIAL_FOLDER_ACLID,
					CASE substring(eWFFORM.dbo.UF_ACL_CHECK(A.DeptID, A.UserID, @cUserType), 2, 1) WHEN 'Y' THEN '권한있음' ELSE '권한없음' END as OTHER_DEPT_ACLID,
					CASE substring(eWFFORM.dbo.UF_ACL_CHECK(A.DeptID, A.UserID, @cUserType), 3, 1) WHEN 'Y' THEN '권한있음' ELSE '권한없음' END as SUB_DEPT_ACLID,
					CASE substring(eWFFORM.dbo.UF_ACL_CHECK(A.DeptID, A.UserID, @cUserType), 4, 1) WHEN 'Y' THEN '권한있음' ELSE '권한없음' END as FORM_LINE_ACLID,
					A.DeptId
FROM	eManage.dbo.VW_USER as A
		INNER JOIN
		(SELECT		USERID, 
					DEPTID 
		FROM		eWFFORM.dbo.WF_ACL_SPECIAL_FOLDER(NOLOCK)
		WHERE		USER_TYPE = @cUserType
			
		UNION ALL
			
		SELECT		USERID, 
					DEPTID
		FROM		eWFFORM.dbo.WF_ACL_OTHER_DEPT(NOLOCK)
		WHERE		USER_TYPE =   @cUserType
			
		UNION ALL
			
		SELECT		USERID, 
					DEPTID
		FROM		eWFFORM.dbo.WF_ACL_SUBDEPT(NOLOCK)
		WHERE		USER_TYPE =   @cUserType

		UNION ALL
			
		SELECT		USERID, 
					DEPTID
		FROM		eWFFORM.dbo.WF_ACL_FORM_LINE(NOLOCK)
		WHERE		USER_TYPE =   @cUserType) as B

		ON A.DeptID = B.DEPTID

order by SPECIAL_FOLDER_ACLID 




GO
/****** Object:  StoredProcedure [dbo].[UP_LIST_WF_APR_FOLDER]    Script Date: 2015-10-15 오후 1:30:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[UP_LIST_WF_APR_FOLDER]
	/* Param List */
AS
	Select * 
	From dbo.Wf_APR_FOLDER
RETURN

GO
/****** Object:  StoredProcedure [dbo].[UP_LIST_WF_CONFIG_USER]    Script Date: 2015-10-15 오후 1:30:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*

설  	명: 사용자 결재환경 조회
작	성	자: 신상훈
작	성	일: 2004.06.16

수	정	자 : 김진시
수	정	일: 2005.08.24
내		용 : 부서 조건 추가

수	정	자:	강민성
수	정	일:	2009.03.25
내		용: eWFFORM.dbo.WF_CONFIG_USER 와 eManage.dbo.VW_User 의 JOIN을 INNER에서 LEFT JOIN으로 변경


테스트: EXEC  UP_LIST_WF_CONFIG_USER 128574 ,0

select	*	from	emanage.dbo.vw_user	where	username = '박정근'
select	*	from	eWFFORM.dbo.WF_CONFIG_USER	where	userid = 113335

exec dbo.UP_LIST_WF_CONFIG_USER 113335, 2551

*/

CREATE	Procedure	[dbo].[UP_LIST_WF_CONFIG_USER]
		@intUserId	int,
		@intDeptId	int
As

	Declare	@AttachID	int

	/*
	SET @ATTACHID = (SELECT COUNT(SIGN_ATTACHID) FROM	eWFFORM.dbo.WF_CONFIG_USER(NOLOCK) WHERE USERID = @intUserId AND SIGN_ATTACHID IS NOT NULL AND SIGN_ATTACHID <> 0)
	--	SET @ATTACHID = 0

	IF	@ATTACHID > 0
	BEGIN
		SET @ATTACHID = (SELECT TOP 1 SIGN_ATTACHID FROM	eWFFORM.dbo.WF_CONFIG_USER(NOLOCK) WHERE USERID = @intUserId AND SIGN_ATTACHID IS NOT NULL AND SIGN_ATTACHID <> 0)
		--	SET	@ATTACHID = (SELECT	TOP 1 SIGN_ATTACHID FROM	eWFFORM.dbo.WF_CONFIG_USER(NOLOCK) WHERE	USERID = @intUserId aND SIGN_ATTACHID IS NOT NULL aND SIGN_ATTACHID <> 0 and	DeptID = @intDeptId)
	END
	*/

	--	가장 최근 부서의 소속으로 설정한 도장이미지를 가져온다.	
	Select	Top 1
			@AttachID = Sign_AttachID
	From	eWFFORM.dbo.WF_CONFIG_USER c (NOLOCK)
			LEFT Join	eManage.dbo.VW_User v
				On	v.UserID = c.UserID
				and	v.DeptID = c.DeptID
	Where	c.UserID = @intUserId
		and	c.Sign_AttachID is Not Null
		and	c.Sign_AttachID <> 0
--		and	v.PositionOrder = 1
	Order by v.EndDate Desc

	Select	@AttachID = IsNull(@AttachID, 0)

	If	(@intDeptId IS NOT NULL AND @intDeptId <> 0)
	Begin
		Select	USERID, DEPTID, NOTICEMAIL, ISABSENT, ABSENCE_REASON, DEPUTYID, DEPUTYDEPTID, DEPUTYSTART, DEPUTYEND, 
				@ATTACHID SIGN_ATTACHID , AFTER_ACT, NOTICEMESSANGER
		From	eWFFORM.dbo.WF_CONFIG_USER (NOLOCK)
		Where	USERID = @intUserId
			And	DEPTID = @intDeptId
	End
	Else
	Begin
		Select	USERID, DEPTID, NOTICEMAIL, ISABSENT, ABSENCE_REASON, DEPUTYID, DEPUTYDEPTID, DEPUTYSTART, DEPUTYEND, 
				@ATTACHID SIGN_ATTACHID, AFTER_ACT, NOTICEMESSANGER
		From	eWFFORM.dbo.WF_CONFIG_USER (NOLOCK)
		Where	USERID = @intUserId 
	End

	--	Select	*	From	eWFFORM.dbo.WF_CONFIG_USER




GO
/****** Object:  StoredProcedure [dbo].[UP_LIST_WF_DOC_FOLDER]    Script Date: 2015-10-15 오후 1:30:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

----------------------------------------------------------------------
----------------------------------------------------------------------
-- 작성자: 신상훈
-- 작성일: 2004.03.10
-- 수정일: 2004.03.10
-- 설  명: 문서함 조회
-- 테스트: EXEC  UP_LIST_WF_DOC_FOLDER 'TOTAL'
----------------------------------------------------------------------
-- 수정일: 
-- 수정자: 
-- 수정내용 : 
----------------------------------------------------------------------
----------------------------------------------------------------------
CREATE  Procedure [dbo].[UP_LIST_WF_DOC_FOLDER]
	
	@vcListType	varchar(20)
AS
----------------------------------------------------------------------
-- 내용 : 문서함 리스트에서 전체 문서함 리스트 가져오기
----------------------------------------------------------------------	
IF @vcListType = 'TOTAL'
BEGIN
	SELECT		DOC_FOLDER_ID,				-- 문서함ID
				DOC_FOLDER_NAME,			-- 문서함이름	
				APR_FOLDER_ID,				-- 결재함코드
				CASE	DOC_FOLDER_TYPE		-- 문서함유형(특정권한문서함/일반문서함)
					WHEN 'S' THEN '특정권한문서함'
					WHEN 'G' THEN '일반문서함'
				END	AS DOCFOLDERTYPE,
						
				CASE	APR_FOLDER_TYPE		-- 결재함유형(개인결재함/부서결재함)
					WHEN 'P' THEN '개인결재함'
					WHEN 'D' THEN '부서결재함'
				END AS APRFOLDERTYPE,
						
				CASE	USAGE_YN			-- 사용유무(현재 사용중인지 여부)
					WHEN 'Y' THEN '사용중'
					WHEN 'N' THEN '사용안함'
				END AS USAGEYN
				
				
					
	FROM		eWFFORM.dbo.Wf_DOC_FOLDER
	WHERE		APR_FOLDER_ID != 'RT'
		
	ORDER BY	APR_FOLDER_TYPE DESC, DOC_FOLDER_TYPE ASC, SortKey ASC
END
----------------------------------------------------------------------
-- 내용 : 문서함 순서변경에서 개인결재함 가져오기
----------------------------------------------------------------------	
IF @vcListType = 'PSNLFOLDER'
BEGIN
	SELECT		DOC_FOLDER_ID,				-- 문서함ID
				DOC_FOLDER_NAME,			-- 문서함이름	
				APR_FOLDER_ID				-- 결재함코드					
	FROM		eWFFORM.dbo.Wf_DOC_FOLDER
	WHERE		APR_FOLDER_TYPE = 'P'
		
	ORDER BY	SortKey ASC
END
----------------------------------------------------------------------
-- 내용 : 문서함 순서변경에서 부서결재함 중 일반문서함 가져오기
----------------------------------------------------------------------	
IF @vcListType = 'GENDEPTFOLDER'
BEGIN
	SELECT		DOC_FOLDER_ID,				-- 문서함ID
				DOC_FOLDER_NAME,			-- 문서함이름	
				APR_FOLDER_ID				-- 결재함코드					
	FROM		eWFFORM.dbo.Wf_DOC_FOLDER
	WHERE		APR_FOLDER_TYPE = 'D' AND DOC_FOLDER_TYPE = 'G'
		
	ORDER BY	SortKey ASC
END
----------------------------------------------------------------------
-- 내용 : 문서함 순서변경에서 부서문서함 중 특정권한문서함 가져오기
----------------------------------------------------------------------	
IF @vcListType = 'SPEDEPTFOLDER'
BEGIN
	SELECT		DOC_FOLDER_ID,				-- 문서함ID
				DOC_FOLDER_NAME,			-- 문서함이름	
				APR_FOLDER_ID				-- 결재함코드					
	FROM		eWFFORM.dbo.Wf_DOC_FOLDER
	WHERE		APR_FOLDER_TYPE = 'D' AND DOC_FOLDER_TYPE = 'S'
		
	ORDER BY	SortKey ASC
END


GO
/****** Object:  StoredProcedure [dbo].[UP_LIST_WF_DOC_FOLDER_INFO]    Script Date: 2015-10-15 오후 1:30:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
----------------------------------------------------------------------
----------------------------------------------------------------------
-- 작성자: 신상훈
-- 작성일: 2004.03.10
-- 수정일: 2004.03.10
-- 설  명: 문서함 조회
-- 테스트: EXEC  UP_LIST_WF_DOC_FOLDER
----------------------------------------------------------------------
-- 수정일: 
-- 수정자: 
-- 수정내용 : 
----------------------------------------------------------------------
----------------------------------------------------------------------
CREATE Procedure [dbo].[UP_LIST_WF_DOC_FOLDER_INFO]
	
	@intDocFolderId	int
	
AS
	
SELECT		DOC_FOLDER_ID,			-- 문서함ID
			DOC_FOLDER_NAME,		-- 문서함이름								
			DOC_FOLDER_TYPE,		-- 문서함유형(특정권한문서함/일반문서함)
			APR_FOLDER_TYPE,		-- 결재함유형(개인결재함/부서결재함)
			USAGE_YN,				-- 사용유무(현재 사용중인지 여부)
			APR_FOLDER_ID			-- 결재함코드
				
FROM		eWFFORM.dbo.Wf_DOC_FOLDER
WHERE		DOC_FOLDER_ID = @intDocFolderId
	
ORDER BY	APR_FOLDER_TYPE DESC, 
			SortKey ASC

GO
/****** Object:  StoredProcedure [dbo].[UP_LIST_WF_DocumentProcessTotalList]    Script Date: 2015-10-15 오후 1:30:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO



/*----------------------------------------------------------------------
작	성	자:	강민성
작	성	일: 2009.02.03
수	정	일: 2009.02.03
설		명: 전자결재 처리현황
테	스	트: 

EXEC UP_LIST_WF_DocumentProcessTotalList 'D', '2009-01-01', '2009-06-30', '', ''
EXEC UP_LIST_WF_DocumentProcessTotalList 'U', '2009-01-01', '2009-01-31', '2568', ''
----------------------------------------------------------------------*/
CREATE	PROCEDURE	[dbo].[UP_LIST_WF_DocumentProcessTotalList]
		@pQueryType		CHAR(1)		= NULL,
		@pStartDate		CHAR(10)	= NULL,
		@pEndDate		CHAR(10)	= NULL,
		@pDeptID		CHAR(4)		= NULL,
		@pFormName		CHAR(100)	= NULL

AS
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

IF	@pQueryType = 'D'
BEGIN

	DECLARE	@UserDeptList	TABLE
	(
		UserID	VARCHAR(6),
		DeptID	INT
	)

	INSERT	INTO	@UserDeptList
		SELECT	DISTINCT
				U.UserID,
				--	LEVEL이 5인 부서는 상위부서로 합친다
				CASE
					WHEN	D.[Level] = 5	THEN
						D.ParentDeptID
					ELSE
						D.DeptID
				END 
		FROM	eManage.dbo.VW_User U
				LEFT OUTER JOIN	(SELECT	DeptID, MIN(CodeOrder) CodeOrder	--	부서별 최상급자
								FROM	eManage.dbo.VW_User 
								WHERE	PositionOrder = 1
									AND	JikChaekID IN ('0002', '0003', '0004', '0005', '0006', '0007', '0010', '0013')	--	전무 상무 이사 공장장 부장 실장 팀장
									AND	'2009-01-31 00:00:00.000' >= StartDate
									AND	'2009-01-31 00:00:00.000' <= EndDate
								GROUP BY DeptID) MC
					ON	MC.DeptID = U.DeptID
					AND	MC.CodeOrder = U.CodeOrder
				JOIN	eManage.dbo.TB_Dept D
					ON	D.DeptID = U.DeptID
		WHERE	U.PositionOrder = 1
			AND	U.JikChaekID <= '0013'
			AND	U.JikChaekID IN ('0002', '0003', '0004', '0005', '0006', '0007', '0010', '0013')
			AND	'2009-01-31 00:00:00.000' >= u.StartDate
			AND	'2009-01-31 00:00:00.000' <= u.EndDate
			AND	D.[Level] IN ('3','4','5')
			AND	D.ParentDeptID NOT IN (2537, 2538, 2542, 2543, 2544, 2545, 2546, 2547, 2557)	--	생산본부는 공장만 집계하기 위해 공장 하위부서는 제외
			AND	D.DeptName NOT LIKE '%아사히%'	--	아사히 제외



	SELECT	
			CASE
				WHEN	LEFT(D.SortKey, 4) = '0000'	THEN
					'본사'
				WHEN	LEFT(D.SortKey, 4) = '0001'	THEN
					'영업'
				WHEN	LEFT(D.SortKey, 4) = '0002'	THEN
					'생산'
			END	AS DeptGroup,
			D.DEPTNAME,
			SUM(WAIT) + SUM(COMPLETE) + SUM(REJECT) as total,
			SUM(COMPLETE)	AS COMPLETE, 
			CASE
				WHEN	SUM(COMPLETE) = 0	THEN	0
				ELSE	SUM(COMPLETE_INTERVAL) / SUM(COMPLETE)
			END	AS COMPLETE_INTERVAL,
			SUM(WAIT)		AS WAIT,
			SUM(REJECT)		AS REJECT,
			D.DEPTID,
			D.SORTKEY
	FROM	eManage.dbo.TB_Dept D
			LEFT OUTER	JOIN	(
								SELECT	DU.DEPTID, W.STATE, W.PROCESS_INSTANCE_VIEW_STATE,
										SUM(CASE
												WHEN	W.STATE = 2	THEN	1	ELSE	0	--	결재함 대기중
											END)	AS WAIT,
										SUM(CASE
												WHEN	W.STATE = 7 AND W.PROCESS_INSTANCE_VIEW_STATE <> 8	THEN	1	ELSE	0	--	본인 결재 완료된것중 반려 아닌것
											END)	AS COMPLETE,
										SUM(CASE
												WHEN	W.STATE = 7 AND W.PROCESS_INSTANCE_VIEW_STATE = 8	THEN	1	ELSE	0	--	반려된것
											END)	AS REJECT,
										SUM(CASE
												WHEN	W.STATE = 7 AND W.PROCESS_INSTANCE_VIEW_STATE <> 8	THEN	--	본인 결재 완료된것중 반려 아닌것의 시간차 계산
													CASE
														DATEDIFF(DD, W.CREATE_DATE, W.COMPLETED_DATE)
														WHEN	0	THEN
														--	결재함에 들어온 날짜와 완료된 날짜의 차이가 0 이면 들어온 시간과의 차이를 19시 기준으로 계산
															CASE
																WHEN	SUBSTRING(CONVERT(VARCHAR(20), W.CREATE_DATE, 120), 12, 9) > '19:00:00'	THEN	
																	0
																ELSE
																	DATEDIFF(MI, CONVERT(VARCHAR(20), W.CREATE_DATE, 120), SUBSTRING(CONVERT(VARCHAR(20), W.CREATE_DATE, 120), 1, 10)  + ' 19:00:00') / 60
															END
														WHEN	1	THEN
														--	결재함에 들어온 날짜와 완료된 날짜가 차이가 1 이면 들어온 시간과의 차이를 19시 기준으로 계산하고,
														--	완료된 시간과의 차이를 09시 기준으로 한다
															(CASE
																WHEN	SUBSTRING(CONVERT(VARCHAR(20), W.CREATE_DATE, 120), 12, 9) > '19:00:00'	THEN
																	0
																ELSE
																	DATEDIFF(MI, CONVERT(VARCHAR(20), W.CREATE_DATE, 120), SUBSTRING(CONVERT(VARCHAR(20), W.CREATE_DATE, 120), 1, 10)  + ' 19:00:00')
															END
															+
															CASE
																WHEN	SUBSTRING(CONVERT(VARCHAR(20), W.COMPLETED_DATE, 120), 12, 9) < '09:00:00'	THEN
																	0
																ELSE
																	DATEDIFF(MI, SUBSTRING(CONVERT(VARCHAR(20), W.COMPLETED_DATE, 120), 1, 10) + ' 09:00:00', CONVERT(VARCHAR(20), W.COMPLETED_DATE, 120))
															END)
															/ 60
														ELSE
														--	결재함에 들어온 날짜와 완료된 날짜가 차이가 1 이상이면 들어온 시간과의 차이를 19시 기준으로 계산하고,
														--	완료된 시간과의 차이를 09시 기준으로 하고, 나머지 날짜들은 10시간을 곱한다
														(CASE
															WHEN	SUBSTRING(CONVERT(VARCHAR(20), W.CREATE_DATE, 120), 12, 9) > '19:00:00'	THEN
																0
															ELSE
																DATEDIFF(MI, CONVERT(VARCHAR(20), W.CREATE_DATE, 120), SUBSTRING(CONVERT(VARCHAR(20), W.CREATE_DATE, 120), 1, 10)  + ' 19:00:00')
														END
														+
														CASE
															WHEN	SUBSTRING(CONVERT(VARCHAR(20), W.COMPLETED_DATE, 120), 12, 9) < '09:00:00'	THEN
																0
															ELSE
																DATEDIFF(MI, SUBSTRING(CONVERT(VARCHAR(20), W.COMPLETED_DATE, 120), 1, 10) + ' 09:00:00', CONVERT(VARCHAR(20), W.COMPLETED_DATE, 120))
														END)
														/ 60
														+
														CASE
															--	토요일(7)과 시작일과의 차이 + 종료일과 일요일(1)과의 차이가 5미만 이면 주말을 한번 더 뺌.
															WHEN	(7 - DATEPART(dw, W.CREATE_DATE)) + (DATEPART(dw, W.COMPLETED_DATE) - 1) < 5	THEN
																--	시작일과 종료일의 차이에 10시간을 곱한것 - 시작일과 종료일의 차이를 7(일주일)로 나눈몫에 곱하기 2(토,일) 만큼 10시간을 곱해서 뺀다 - 주말을 한번 더 뺀다
																((DATEDIFF(DD, W.CREATE_DATE, W.COMPLETED_DATE) - 1) * 10) - (DATEDIFF(DD, W.CREATE_DATE, W.COMPLETED_DATE) / 7 * 2 * 10) - 20
															ELSE
																((DATEDIFF(DD, W.CREATE_DATE, W.COMPLETED_DATE) - 1) * 10) - (DATEDIFF(DD, W.CREATE_DATE, W.COMPLETED_DATE) / 7 * 2 * 10)
														END
													END
												ELSE	0
											END)	AS COMPLETE_INTERVAL
								FROM	@UserDeptList DU
										JOIN	eWF.dbo.Work_Item W
											ON	W.Participant_ID = DU.UserID
											AND	W.NAME = '일반결재자'
											AND	W.CREATE_DATE > @pStartDate + ' 00:00:00.000'
											AND	W.CREATE_DATE < @pEndDate + ' 23:59:59.000'
										JOIN	eManage.dbo.TB_Dept D
											ON	D.DeptID = DU.DeptID
								GROUP BY DU.DEPTID, W.STATE, W.PROCESS_INSTANCE_VIEW_STATE
								) A
				ON	A.DeptID = D.DeptID
			JOIN	(SELECT	DISTINCT DEPTID
					FROM	@UserDeptList) L
				ON	L.DEPTID = D.DEPTID
	GROUP BY D.SortKey, D.DEPTNAME, D.DEPTID
	ORDER BY D.SORTKEY

END
ELSE IF	@pQueryType = 'U'
BEGIN

	DECLARE	@DeptLevel	INT

	SELECT	@DeptLevel = [Level]
	FROM	EMANAGE.DBO.TB_DEPT
	WHERE	DEPTID = @pDeptID

	DECLARE	@UserList	TABLE
	(
		UserID	VARCHAR(6)
	)
	
	INSERT	INTO	@UserList
		SELECT	DISTINCT
				U.UserID
		FROM	eManage.dbo.VW_User U
				LEFT OUTER JOIN	(SELECT	DeptID, MIN(CodeOrder) CodeOrder
								FROM	eManage.dbo.VW_User 
								WHERE	PositionOrder = 1
									AND	JikChaekID IN ('0002', '0003', '0004', '0005', '0006', '0007', '0010', '0013')
									AND	'2009-01-31 00:00:00.000' >= StartDate
									AND	'2009-01-31 00:00:00.000' <= EndDate
								GROUP BY DeptID) MC
					ON	MC.DeptID = U.DeptID
					AND	MC.CodeOrder = U.CodeOrder
				JOIN	eManage.dbo.TB_Dept D
					ON	D.DeptID = U.DeptID
		WHERE	U.PositionOrder = 1
			AND	U.JikChaekID <= '0013'
			AND	U.JikChaekID IN ('0002', '0003', '0004', '0005', '0006', '0007', '0010', '0013')
			AND	'2009-01-31 00:00:00.000' >= u.StartDate
			AND	'2009-01-31 00:00:00.000' <= u.EndDate
			AND	(
					--	4 레벨인 부서는 하위 부서까지 조회한다
					(@DeptLevel = 4	AND	'2009-01-31 00:00:00.000' <= D.DeleteDate	AND	(D.DEPTID = @pDeptID	OR	D.PARENTDEPTID = @pDeptID))
				OR	(@DeptLevel <> 4	AND	D.DEPTID = @pDeptID)
				)

	SELECT	U.DEPTNAME, U.JIKCHAEK, 
			U.USERNAME,
			SUM(WAIT) + SUM(COMPLETE) + SUM(REJECT) as total,
			SUM(COMPLETE)	AS COMPLETE, 
			CASE
				WHEN	SUM(COMPLETE) = 0	THEN	0
				ELSE	SUM(COMPLETE_INTERVAL) / SUM(COMPLETE)
			END	AS COMPLETE_INTERVAL,
			SUM(WAIT)		AS WAIT,
			SUM(REJECT)		AS REJECT,
			U.DEPTID, U.JikChaekID
	FROM	@UserList L
			LEFT OUTER	JOIN	(
								SELECT	U.USERID, W.STATE, W.PROCESS_INSTANCE_VIEW_STATE,
										SUM(CASE
												WHEN	W.STATE = 2	THEN	1	ELSE	0
											END)	AS WAIT,
										SUM(CASE
												WHEN	W.STATE = 7 AND W.PROCESS_INSTANCE_VIEW_STATE <> 8	THEN	1	ELSE	0
											END)	AS COMPLETE,
										SUM(CASE
												WHEN	W.STATE = 7 AND W.PROCESS_INSTANCE_VIEW_STATE = 8	THEN	1	ELSE	0
											END)	AS REJECT,
										SUM(CASE
												WHEN	W.STATE = 7 AND W.PROCESS_INSTANCE_VIEW_STATE <> 8	THEN	--	본인 결재 완료된것중 반려 아닌것의 시간차 계산
													CASE
														DATEDIFF(DD, W.CREATE_DATE, W.COMPLETED_DATE)
														WHEN	0	THEN
														--	결재함에 들어온 날짜와 완료된 날짜의 차이가 0 이면 들어온 시간과의 차이를 19시 기준으로 계산
															CASE
																WHEN	SUBSTRING(CONVERT(VARCHAR(20), W.CREATE_DATE, 120), 12, 9) > '19:00:00'	THEN	
																	0
																ELSE
																	DATEDIFF(MI, CONVERT(VARCHAR(20), W.CREATE_DATE, 120), SUBSTRING(CONVERT(VARCHAR(20), W.CREATE_DATE, 120), 1, 10)  + ' 19:00:00') / 60
															END
														WHEN	1	THEN
														--	결재함에 들어온 날짜와 완료된 날짜가 차이가 1 이면 들어온 시간과의 차이를 19시 기준으로 계산하고,
														--	완료된 시간과의 차이를 09시 기준으로 한다
															(CASE
																WHEN	SUBSTRING(CONVERT(VARCHAR(20), W.CREATE_DATE, 120), 12, 9) > '19:00:00'	THEN
																	0
																ELSE
																	DATEDIFF(MI, CONVERT(VARCHAR(20), W.CREATE_DATE, 120), SUBSTRING(CONVERT(VARCHAR(20), W.CREATE_DATE, 120), 1, 10)  + ' 19:00:00')
															END
															+
															CASE
																WHEN	SUBSTRING(CONVERT(VARCHAR(20), W.COMPLETED_DATE, 120), 12, 9) < '09:00:00'	THEN
																	0
																ELSE
																	DATEDIFF(MI, SUBSTRING(CONVERT(VARCHAR(20), W.COMPLETED_DATE, 120), 1, 10) + ' 09:00:00', CONVERT(VARCHAR(20), W.COMPLETED_DATE, 120))
															END)
															/ 60
														ELSE
														--	결재함에 들어온 날짜와 완료된 날짜가 차이가 1 이상이면 들어온 시간과의 차이를 19시 기준으로 계산하고,
														--	완료된 시간과의 차이를 09시 기준으로 하고, 나머지 날짜들은 10시간을 곱한다
														(CASE
															WHEN	SUBSTRING(CONVERT(VARCHAR(20), W.CREATE_DATE, 120), 12, 9) > '19:00:00'	THEN
																0
															ELSE
																DATEDIFF(MI, CONVERT(VARCHAR(20), W.CREATE_DATE, 120), SUBSTRING(CONVERT(VARCHAR(20), W.CREATE_DATE, 120), 1, 10)  + ' 19:00:00')
														END
														+
														CASE
															WHEN	SUBSTRING(CONVERT(VARCHAR(20), W.COMPLETED_DATE, 120), 12, 9) < '09:00:00'	THEN
																0
															ELSE
																DATEDIFF(MI, SUBSTRING(CONVERT(VARCHAR(20), W.COMPLETED_DATE, 120), 1, 10) + ' 09:00:00', CONVERT(VARCHAR(20), W.COMPLETED_DATE, 120))
														END)
														/ 60
														+
														CASE
															--	토요일(7)과 시작일과의 차이 + 종료일과 일요일(1)과의 차이가 5미만 이면 주말을 한번 더 뺌.
															WHEN	(7 - DATEPART(dw, W.CREATE_DATE)) + (DATEPART(dw, W.COMPLETED_DATE) - 1) < 5	THEN
																--	시작일과 종료일의 차이에 10시간을 곱한것 - 시작일과 종료일의 차이를 7(일주일)로 나눈몫에 곱하기 2(토,일) 만큼 10시간을 곱해서 뺀다 - 주말을 한번 더 뺀다
																((DATEDIFF(DD, W.CREATE_DATE, W.COMPLETED_DATE) - 1) * 10) - (DATEDIFF(DD, W.CREATE_DATE, W.COMPLETED_DATE) / 7 * 2 * 10) - 20
															ELSE
																((DATEDIFF(DD, W.CREATE_DATE, W.COMPLETED_DATE) - 1) * 10) - (DATEDIFF(DD, W.CREATE_DATE, W.COMPLETED_DATE) / 7 * 2 * 10)
														END
													END
												ELSE	0
											END)	AS COMPLETE_INTERVAL
								FROM	@UserList U
										JOIN	eWF.dbo.Work_Item W
											ON	U.UserID = W.Participant_ID
											AND	W.NAME = '일반결재자'
											AND	W.CREATE_DATE > @pStartDate + ' 00:00:00.000'
											AND	W.CREATE_DATE < @pEndDate + ' 23:59:59.000'
										JOIN	eWF.dbo.Process_Instance P
											ON	W.Process_Instance_OID = P.OID
											AND	(@pFormName = '' OR P.[NAME] = @pFormName)
								GROUP BY U.USERID, W.STATE, W.PROCESS_INSTANCE_VIEW_STATE
								) A
				ON	A.UserID = L.UserID
			INNER JOIN	eManage.dbo.VW_User U
				ON	U.UserID = L.UserID
				AND	@pEndDate > U.StartDate
				AND	@pEndDate < U.EndDate
	GROUP BY U.DEPTNAME, U.JIKCHAEK,
			U.USERNAME,
			U.USERID,
			U.DEPTID, U.JikChaekID
	ORDER BY U.DEPTID, U.JikChaekID

END

SET QUOTED_IDENTIFIER ON




GO
/****** Object:  StoredProcedure [dbo].[UP_LIST_WF_PROCESS_INSTANCE]    Script Date: 2015-10-15 오후 1:30:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO









CREATE           PROC [dbo].[UP_LIST_WF_PROCESS_INSTANCE]
    @intTotalCount     		 int OUTPUT,
    @intPageNum			int,
    @intNumPerPage      		int,
    @vcFormId			varchar(33),
    @vcSearchColumn		varchar(20),
    @vcSearchText       		varchar(50),
    @cStartDate			char(10),
    @cEndDate			char(10),
    @intSortColumn		int,    
    @vcSortOrder			varchar(4)
    
AS

----------------------------------------------------------------------
----------------------------------------------------------------------
-- 작성자: LDCC 신상훈
-- 작성일: 2004.04.02
-- 수정일: 2004.04.02
-- 설   명: 양식별 결재현황 조회
-- 테스트 :
-- @vcFormId : YA8F6C070F99844E5BEEBB8307537BC4
-- 총건수(output),페이지넘버,페이지당리스트수,양식ID,검색컬럼,검색어,시작날짜,끝날짜,정렬칼럼,정렬타입
/*

EXEC dbo.UP_LIST_WF_PROCESS_INSTANCE 0, 1000, 10, 'Y819EC4E5CCF14ABAB9325B87A797D265', '', '', '', '', '', ''

*/
----------------------------------------------------------------------
-- 수정일 : 
-- 수정자 : 
-- 수정내용 : --	SET @cEndDate = DATEADD(DD, 1, @cEndDate)
----------------------------------------------------------------------
----------------------------------------------------------------------

declare    
    @vcQuery			varchar(8000),
    @nvcCountQuery       nvarchar(4000),
    @vcSortColumnName		varchar(20),	-- Sorting 컬럼 이름
    @cMULTIYN			CHAR(1)	,	--협조처 양식인지 아닌지
    @ADDQUERY			VARCHAR(500)

SET @ADDQUERY ='  AND PARENT_OID = '''' '

SELECT @cMULTIYN = MULTI_RCV_YN FROM EWFFORM.DBO.WF_FORM_SCHEMA WHERE FORM_ID = @vcFormId

--검색종료일자
if(@cEndDate != '')	
   begin
	SET @cEndDate = DATEADD(DD, 1, @cEndDate)
   end


--총 게시물 수

SET @nvcCountQuery = 	N'	SELECT	@nCnt = COUNT(*) '
+						N'	FROM	eWFFORM.dbo.WF_FORMS_PROP as A (NOLOCK)'
+						N'			INNER JOIN '
+						N'			eWF.dbo.PROCESS_INSTANCE as B (NOLOCK)'
+						N'			ON	A.PROCESS_ID = B.OID AND '
+						N'				B.DELETE_DATE = cast(''9999-12-31 00:00:00.000'' as datetime) AND '
+						N'				A.FORM_ID = ''' + @vcFormId +''''

--협조처 양식이면 발신부서 하나만 나오도록 처리
IF(@cMULTIYN = 'Y')
BEGIN
	SET @nvcCountQuery = @nvcCountQuery + @ADDQUERY
END


--검색시작일자
if(@cStartDate != '')

	SET @nvcCountQuery = @nvcCountQuery + N' AND B.CREATE_DATE >= CAST('''+@cStartDate+N''' AS smalldatetime) '
--검색종료일자
if(@cEndDate != '')	

	SET @nvcCountQuery = @nvcCountQuery + N' AND B.CREATE_DATE <= CAST('''+@cEndDate+N''' AS smalldatetime) '
--검색항목이 있을 경우
if(@vcSearchColumn != '')

	SET @nvcCountQuery = @nvcCountQuery +N' AND B.'+@vcSearchColumn+N' like ''%'+@vcSearchText+N'%''' 



EXEC sp_executesql @nvcCountQuery, N'@nCnt INT OUTPUT', @nCNT = @intTotalCount OUTPUT
-------------------------------------------------------------------------------------------------


-------------------------------------------------------------------------------------------------
-- 내용 : Sorting 정보 설정
-------------------------------------------------------------------------------------------------
SET @vcSortColumnName = 
	(
	CASE @intSortColumn
		WHEN 1
				THEN	'SUBJECT'
		WHEN 2
				THEN	'CREATOR_DEPT'
		WHEN 3
				THEN	'CREATOR'
		WHEN 4
				THEN	'CREATE_DATE'
		WHEN 5
				THEN	'COMPLETED_DATE'
		WHEN 6
				THEN	'STATE'
		ELSE
					'CREATE_DATE'
	END
	)

IF @vcSortOrder = ''
begin
SET @vcSortOrder = 'DESC'
end


-------------------------------------------------------------------------------------------------
-- 내용 : 제목, 사용자부서명, 사용자명,부서명, 생성일, 결재완료일, 결재상태, PROCESS_ID, FORM_ID
-- 추가 : CREATOR_ID
-------------------------------------------------------------------------------------------------

SET @vcQuery = 'SELECT  C.SUBJECT,
						C.CREATOR_DEPT,
						C.CREATOR,
						CONVERT(VARCHAR(16), C.CREATE_DATE,20),
						CONVERT(VARCHAR(16), C.COMPLETED_DATE,20),
						CASE	C.STATE		
							WHEN 1  THEN ''기안작업완료''
							WHEN 2  THEN ''결재처리대상''
							WHEN 3  THEN ''결재처리중''
							WHEN 7  THEN ''결재완료''
							WHEN 8  THEN ''반려''
							WHEN 10 THEN ''결재처리대상''
							WHEN 13 THEN ''기안취소''
							ELSE		 ''기타등등''
						END AS  STATE,
						C.OID,
						C.FORM_ID,
						C.CREATOR_ID
						, C.DOC_NAME
				FROM	('
SET @vcQuery = @vcQuery +' 	SELECT	TOP '+CAST(@intPageNum * @intNumPerPage AS varchar) + '
	 			   				B.SUBJECT,
								B.CREATOR_DEPT,
								B.CREATOR,
								B.CREATE_DATE,
								B.COMPLETED_DATE,
								B.STATE,				
								B.OID,
								A.FORM_ID,
								B.CREATOR_ID
								, A.DOC_NAME
							FROM	eWFFORM.dbo.WF_FORMS_PROP as A (NOLOCK)
								INNER JOIN
								eWF.dbo.PROCESS_INSTANCE as B (NOLOCK)
								ON  A.PROCESS_ID = B.OID AND B.DELETE_DATE = cast(''9999-12-31 00:00:00.000'' as datetime) AND A.FORM_ID = ''' + @vcFormId + ''''
--협조처 양식이면 발신부서 하나만 나오도록 처리
IF(@cMULTIYN = 'Y')
BEGIN
	SET @vcQuery = @vcQuery + @ADDQUERY
END

--검색 시작일
if(@cStartDate != '')

	SET @vcQuery = @vcQuery + ' AND B.CREATE_DATE >= CAST('''+@cStartDate+ ''' AS smalldatetime) '
--검색 종료일
if(@cEndDate != '')

	SET @vcQuery = @vcQuery + ' AND B.CREATE_DATE <= CAST('''+@cEndDate+''' AS smalldatetime) '
--검색컬럼
if(@vcSearchColumn != '')

	SET @vcQuery = @vcQuery +' AND B.'+@vcSearchColumn+N' like ''%'+@vcSearchText+'%''' 
--SortingColumn
	
	SET @vcQuery = @vcQuery +' ORDER BY  B.' + @vcSortColumnName + '		' + @vcSortOrder

--페이징을 위해 삭제할 행을 가져온다.
SET @vcQuery = @vcQuery +' ) AS C  

 	LEFT OUTER JOIN

	(SELECT		TOP '+CAST((@intPageNum -1) * @intNumPerPage AS varchar)+' 
			B.SUBJECT,
			B.CREATOR_DEPT,
			B.CREATOR,
			B.CREATE_DATE,
			B.COMPLETED_DATE,
			B.STATE,		
			B.OID,
			A.FORM_ID,
			B.CREATOR_ID	
			, A.DOC_NAME		
	FROM	eWFFORM.dbo.WF_FORMS_PROP as A (NOLOCK)
				INNER JOIN
			eWF.dbo.PROCESS_INSTANCE as B (NOLOCK)
				ON A.PROCESS_ID = B.OID AND B.DELETE_DATE = cast(''9999-12-31 00:00:00.000'' as datetime)
				AND A.FORM_ID = ''' + @vcFormId + ''''

--협조처 양식이면 발신부서 하나만 나오도록 처리
IF(@cMULTIYN = 'Y')
BEGIN
	SET @vcQuery = @vcQuery + @ADDQUERY
END


--검색 시작일
if(@cStartDate != '')

	SET @vcQuery = @vcQuery + ' AND B.CREATE_DATE >= CAST('''+@cStartDate+ ''' AS smalldatetime) '

--검색 종료일
if(@cEndDate != '')
	SET @vcQuery = @vcQuery + ' AND B.CREATE_DATE <= CAST('''+@cEndDate+''' AS smalldatetime) '

--검색컬럼
if(@vcSearchColumn != '')

	SET @vcQuery = @vcQuery +' AND B.'+@vcSearchColumn+N' like ''%'+@vcSearchText+'%''' 

--SortingColumn
	
	SET @vcQuery = @vcQuery +' ORDER BY  B.' + @vcSortColumnName + '		' + @vcSortOrder


SET @vcQuery = @vcQuery +' ) AS D

    ON C.OID=D.OID AND C.FORM_ID=D.FORM_ID	
    WHERE D.OID IS NULL AND D.FORM_ID IS NULL '



-- create table #temp(query text)
-- insert into #temp values(@vcQuery)
-- select * from #temp
-- drop table #temp

exec (@vcQuery)













GO
/****** Object:  StoredProcedure [dbo].[UP_LIST_WF_PROCESS_INSTANCE_STATISTICS_FORM]    Script Date: 2015-10-15 오후 1:30:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------
-- 작성자: 김고현
-- 작성일: 2004.06.04
-- 수정일: 2004.06.14
-- 설  명: 양식/서비스 별 사용현황 조회
-- EXEC  UP_LIST_WF_PROCESS_INSTANCE_STATISTICS_FORM 'G', '3', '2004-05-01','2004-06-30', '협'
-- EXEC  UP_LIST_WF_PROCESS_INSTANCE_STATISTICS_FORM  '1', '','', ''
-------------------------------------------------------------------------------------
-- 수정일 : 
-- 수정자 : 
-- 수정내용 : 
-------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------
CREATE   PROC [dbo].[UP_LIST_WF_PROCESS_INSTANCE_STATISTICS_FORM]
(
	@cSearchDivi char(1),
	@cFrontDate char(10),
	@cAfterDate char(10),	
	@vcFormName varchar(20)
) AS
SET NOCOUNT ON
-- 1 : 전체 & 2 : 기간 & 3 : 양식명
IF @cSearchDivi = '2'
	SELECT A.NAME, A.COMP, A.REJECT, A.ING, A.ERR, A.ETC, A.TOTAL FROM(
		-- 2 : 기간으로 조회
		SELECT '1' SEQ, A.NAME,
			SUM(CASE A.STATE WHEN 7 THEN 1 ELSE 0 END) COMP,
			SUM(CASE A.STATE WHEN 8 THEN 1 ELSE 0 END) REJECT,
			SUM(CASE A.STATE WHEN 3 THEN 1 ELSE 0	END) ING,
			SUM(CASE A.STATE WHEN -1 THEN 1 ELSE 0 END) ERR,
			SUM(CASE A.STATE WHEN 7 THEN 0 WHEN 8  THEN 0 WHEN 3
					THEN 0 WHEN -1 THEN 0 ELSE 1 END) ETC,
			COUNT(OID) TOTAL
			
		FROM  eWF.dbo.PROCESS_INSTANCE A (NOLOCK)
		
		WHERE A.CREATE_DATE BETWEEN CONVERT(DateTime, @cFrontDate) AND CONVERT(DateTime, @cAfterDate)
		GROUP BY A.NAME
	
	UNION ALL
		-- 상태 별 합계(완료, 반려, 진행, 에러, 기타, 총건수)
		SELECT '9', '합계',
			SUM(CASE A.STATE WHEN 7 THEN 1 ELSE 0 END) COMP,
			SUM(CASE A.STATE WHEN 8 THEN 1 ELSE 0 END) REJECT,
			SUM(CASE A.STATE WHEN 3 THEN 1 ELSE 0	END) ING,
			SUM(CASE A.STATE WHEN -1 THEN 1 ELSE 0 END) ERR,
			SUM(CASE A.STATE WHEN 7 THEN 0 WHEN 8  THEN 0 WHEN 3
					THEN 0 WHEN -1 THEN 0 ELSE 1 END) ETC,
			COUNT(OID) TOTAL
			
		FROM  eWF.dbo.PROCESS_INSTANCE A (NOLOCK)
		WHERE A.CREATE_DATE BETWEEN CONVERT(DateTime, @cFrontDate) AND CONVERT(DateTime, @cAfterDate)
	) A
	
	ORDER BY A.SEQ, A.NAME
ELSE IF @cSearchDivi = '1'
	SELECT A.NAME, A.COMP, A.REJECT, A.ING, A.ERR, A.ETC, A.TOTAL FROM(
		-- 1 & 3 : 전체 & 양식명으로 조회
		SELECT '1' SEQ, A.NAME,
			SUM(CASE A.STATE WHEN 7 THEN 1 ELSE 0 END) COMP,
			SUM(CASE A.STATE WHEN 8 THEN 1 ELSE 0 END) REJECT,
			SUM(CASE A.STATE WHEN 3 THEN 1 ELSE 0	END) ING,
			SUM(CASE A.STATE WHEN -1 THEN 1 ELSE 0 END) ERR,
			SUM(CASE A.STATE WHEN 7 THEN 0 WHEN 8  THEN 0 WHEN 3
					THEN 0 WHEN -1 THEN 0 ELSE 1 END) ETC,
			COUNT(OID) TOTAL
			
		FROM  eWF.dbo.PROCESS_INSTANCE A (NOLOCK)
		GROUP BY A.NAME
	
	UNION ALL
		-- 상태 별 합계(완료, 반려, 진행, 에러, 기타, 총건수)
		SELECT '9', '합계',
			SUM(CASE A.STATE WHEN 7 THEN 1 ELSE 0 END) COMP,
			SUM(CASE A.STATE WHEN 8 THEN 1 ELSE 0 END) REJECT,
			SUM(CASE A.STATE WHEN 3 THEN 1 ELSE 0	END) ING,
			SUM(CASE A.STATE WHEN -1 THEN 1 ELSE 0 END) ERR,
			SUM(CASE A.STATE WHEN 7 THEN 0 WHEN 8  THEN 0 WHEN 3
					THEN 0 WHEN -1 THEN 0 ELSE 1 END) ETC,
			COUNT(OID) TOTAL
			
		FROM  eWF.dbo.PROCESS_INSTANCE A (NOLOCK)
	) A
	
	ORDER BY A.SEQ, A.NAME
ELSE
	SELECT A.NAME, A.COMP, A.REJECT, A.ING, A.ERR, A.ETC, A.TOTAL FROM(
		-- 1 & 3 : 전체 & 양식명으로 조회
		SELECT '1' SEQ, A.NAME,
			SUM(CASE A.STATE WHEN 7 THEN 1 ELSE 0 END) COMP,
			SUM(CASE A.STATE WHEN 8 THEN 1 ELSE 0 END) REJECT,
			SUM(CASE A.STATE WHEN 3 THEN 1 ELSE 0	END) ING,
			SUM(CASE A.STATE WHEN -1 THEN 1 ELSE 0 END) ERR,
			SUM(CASE A.STATE WHEN 7 THEN 0 WHEN 8  THEN 0 WHEN 3
					THEN 0 WHEN -1 THEN 0 ELSE 1 END) ETC,
			COUNT(OID) TOTAL
			
		FROM  eWF.dbo.PROCESS_INSTANCE A (NOLOCK)
		
		WHERE A.NAME LIKE '%'+@vcFormName+'%'
		GROUP BY A.NAME
	
	UNION ALL
		-- 상태 별 합계(완료, 반려, 진행, 에러, 기타, 총건수)
		SELECT '9', '합계',
			SUM(CASE A.STATE WHEN 7 THEN 1 ELSE 0 END) COMP,
			SUM(CASE A.STATE WHEN 8 THEN 1 ELSE 0 END) REJECT,
			SUM(CASE A.STATE WHEN 3 THEN 1 ELSE 0	END) ING,
			SUM(CASE A.STATE WHEN -1 THEN 1 ELSE 0 END) ERR,
			SUM(CASE A.STATE WHEN 7 THEN 0 WHEN 8  THEN 0 WHEN 3
					THEN 0 WHEN -1 THEN 0 ELSE 1 END) ETC,
			COUNT(OID) TOTAL
			
		FROM  eWF.dbo.PROCESS_INSTANCE A (NOLOCK)
		WHERE A.NAME LIKE '%'+@vcFormName+'%'
	) A
	
	ORDER BY A.SEQ, A.NAME
			

GO
/****** Object:  StoredProcedure [dbo].[UP_LIST_WF_PROCESS_INSTANCE_STATISTICS_SERVICE]    Script Date: 2015-10-15 오후 1:30:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------
-- 작성자: 김고현
-- 작성일: 2004.06.21
-- 수정일: 2004.06.21
-- 설   명: 서비스 별 사용현황 조회
-- EXEC  UP_LIST_WF_PROCESS_INSTANCE_STATISTICS_SERVICE 'A', '',''
-- EXEC  UP_LIST_WF_PROCESS_INSTANCE_STATISTICS_SERVICE 'E', '2004-05-01','2004-06-30'
-------------------------------------------------------------------------------------
-- 수정일 : 
-- 수정자 : 
-- 수정내용 : 
-------------------------------------------------------------------------------------
--EXEC  UP_LIST_WF_PROCESS_INSTANCE_STATISTICS_SERVICE 'A', '',''
--EXEC  UP_LIST_WF_PROCESS_INSTANCE_STATISTICS_SERVICE 'D', '2004-06-01','2004-06-30'
-------------------------------------------------------------------------------------
CREATE    PROCEDURE [dbo].[UP_LIST_WF_PROCESS_INSTANCE_STATISTICS_SERVICE]
(
	@cSearchDivi	CHAR(1),	-- 1:년도별, 2:월별, 3:일별, 4:요일별, 5:시간대별
	@cFrontDate	CHAR(10),	-- 검색시간일 (YYYY-MM-DD)
	@cAfterDate	CHAR(10)	-- 검색종요일 (YYYY-MM-DD)
)
	
AS
DECLARE
	@dtFrontDate DATETIME,
	@dtAfterDate DATETIME
-- 년도별 조회가 아니면 검색일자 날짜형으로 변환
-- 년도별 조회는 전체 조회로 검색일이 업음
IF @cSearchDivi <> 'A'
	BEGIN
		SET 	@dtFrontDate  	= CONVERT(DATETIME,@cFrontDate)			-- 날짜형으로 변환
		SET	@dtAfterDate 	= CONVERT(DATETIME,@cAfterDate + ' 23:59:59')		-- 날짜형으로 변환
	END 
IF @cSearchDivi = 'A'
	BEGIN
		-- 년도
		SELECT A.PROCESS_DATE, DRAFT_CNT AS 기안처리건수, APPROVAL_CNT AS 결재처리건수, TOTAL_CNT
			 FROM  (
				SELECT 1 SEQ,
					CONVERT(VARCHAR(4),PROCESS_DATE,21) PROCESS_DATE,-- 년
					SUM (
						CASE PROCESS_CD 
							WHEN 'D' THEN 1
							ELSE 0
						END ) DRAFT_CNT,
					SUM (
						CASE PROCESS_CD
							WHEN 'A' THEN 1
							ELSE 0
						END ) APPROVAL_CNT,
					COUNT(*) TOTAL_CNT
				  FROM dbo.WF_ANALY_SERVICE (NOLOCK)
				GROUP BY CONVERT(VARCHAR(4),PROCESS_DATE,21) -- 년
			UNION ALL
				SELECT 
					9, '총합계',
					SUM (
						CASE PROCESS_CD 
							WHEN 'D' THEN 1
							ELSE 0
						END ) DRAFT_CNT,
					SUM (
						CASE PROCESS_CD
							WHEN 'A' THEN 1
							ELSE 0
						END ) APPROVAL_CNT,
					COUNT(*) TOTAL_CNT
				  FROM dbo.WF_ANALY_SERVICE (NOLOCK)
			) A
			ORDER BY SEQ, PROCESS_DATE
	
	END
ELSE IF @cSearchDivi = 'B' 
	BEGIN
	
		--월별
		SELECT A.PROCESS_DATE, DRAFT_CNT AS 기안처리건수, APPROVAL_CNT AS 결재처리건수, TOTAL_CNT
			 FROM  (
				SELECT  1 SEQ,
					CONVERT(VARCHAR(7),PROCESS_DATE,21) PROCESS_DATE,-- 월
					SUM (
						CASE PROCESS_CD 
							WHEN 'D' THEN 1
							ELSE 0
						END ) DRAFT_CNT,
					SUM (
						CASE PROCESS_CD
							WHEN 'A' THEN 1
							ELSE 0
						END ) APPROVAL_CNT,
					COUNT(*) TOTAL_CNT
				  FROM dbo.WF_ANALY_SERVICE (NOLOCK)
				 WHERE PROCESS_DATE BETWEEN  @cFrontDate AND @dtAfterDate
				GROUP BY CONVERT(VARCHAR(7), PROCESS_DATE,21)-- 월
			UNION ALL
				SELECT 
					9, '총합계',
					SUM (
						CASE PROCESS_CD 
							WHEN 'D' THEN 1
							ELSE 0
						END ) DRAFT_CNT,
					SUM (
						CASE PROCESS_CD
							WHEN 'A' THEN 1
							ELSE 0
						END ) APPROVAL_CNT,
					COUNT(*) TOTAL_CNT
				  FROM dbo.WF_ANALY_SERVICE (NOLOCK)
				 WHERE PROCESS_DATE BETWEEN  @cFrontDate AND @dtAfterDate
			) A
			ORDER BY SEQ, PROCESS_DATE
	END
	
ELSE IF @cSearchDivi = 'C' 
	BEGIN
	
		-- 일별
		SELECT A.PROCESS_DATE, DRAFT_CNT AS 기안처리건수, APPROVAL_CNT AS 결재처리건수, TOTAL_CNT
			 FROM  (
				SELECT  1 SEQ,
					CONVERT(VARCHAR(10), PROCESS_DATE,21) PROCESS_DATE, --일
					SUM (
						CASE PROCESS_CD 
							WHEN 'D' THEN 1
							ELSE 0
						END ) DRAFT_CNT,
					SUM (
						CASE PROCESS_CD
							WHEN 'A' THEN 1
							ELSE 0
						END ) APPROVAL_CNT,
					COUNT(*) TOTAL_CNT
				  FROM dbo.WF_ANALY_SERVICE (NOLOCK)
				 WHERE PROCESS_DATE BETWEEN  @cFrontDate AND @dtAfterDate
				GROUP BY CONVERT(VARCHAR(10), PROCESS_DATE,21)-- 일별
			UNION ALL
				SELECT 
					9, '총합계',
					SUM (
						CASE PROCESS_CD 
							WHEN 'D' THEN 1
							ELSE 0
						END ) DRAFT_CNT,
					SUM (
						CASE PROCESS_CD
							WHEN 'A' THEN 1
							ELSE 0
						END ) APPROVAL_CNT,
					COUNT(*) TOTAL_CNT
				  FROM dbo.WF_ANALY_SERVICE (NOLOCK)
				 WHERE PROCESS_DATE BETWEEN  @cFrontDate AND @dtAfterDate
			) A
			ORDER BY SEQ, PROCESS_DATE
	END
	
ELSE IF @cSearchDivi = 'D' 
	BEGIN
		-- 요일별
		SELECT A.PROCESS_DATE, DRAFT_CNT AS 기안처리건수, APPROVAL_CNT AS 결재처리건수, TOTAL_CNT
			 FROM  (
				SELECT PROCESS_DATE_SEQ SEQ, A.PROCESS_DATE, A.DRAFT_CNT, A.APPROVAL_CNT, A.TOTAL_CNT
				   FROM  (
					SELECT 
						DATENAME(W, PROCESS_DATE) PROCESS_DATE, -- 요일
						DATEPART(W, PROCESS_DATE) PROCESS_DATE_SEQ, -- 요일
						SUM (
							CASE PROCESS_CD 
								WHEN 'D' THEN 1
								ELSE 0
							END ) DRAFT_CNT,
						SUM (
							CASE PROCESS_CD
								WHEN 'A' THEN 1
								ELSE 0
							END ) APPROVAL_CNT,
						COUNT(*) TOTAL_CNT
					  FROM dbo.WF_ANALY_SERVICE (NOLOCK)
				 WHERE PROCESS_DATE BETWEEN  @cFrontDate AND @dtAfterDate
					GROUP BY DATENAME(W, PROCESS_DATE), DATEPART(W, PROCESS_DATE) -- 요일
				  ) A
			UNION ALL
				SELECT 
					9, '총합계',
					SUM (
						CASE PROCESS_CD 
							WHEN 'D' THEN 1
							ELSE 0
						END ) DRAFT_CNT,
					SUM (
						CASE PROCESS_CD
							WHEN 'A' THEN 1
							ELSE 0
						END ) APPROVAL_CNT,
					COUNT(*) TOTAL_CNT
				  FROM dbo.WF_ANALY_SERVICE (NOLOCK)
				 WHERE PROCESS_DATE BETWEEN  @cFrontDate AND @dtAfterDate
			) A
			ORDER BY SEQ, PROCESS_DATE
	END
ELSE IF @cSearchDivi = 'E' 
	BEGIN
	
		-- 시간대별
		SELECT A.PROCESS_DATE, DRAFT_CNT AS 기안처리건수, APPROVAL_CNT AS 결재처리건수, TOTAL_CNT
			 FROM  (
				SELECT 
					1 SEQ,
					DATEPART(hour,PROCESS_DATE) PROCESS_INT, -- 시간
					DATENAME(hour,PROCESS_DATE) PROCESS_DATE,
					SUM (
						CASE PROCESS_CD 
							WHEN 'D' THEN 1
							ELSE 0
						END ) DRAFT_CNT,
					SUM (
						CASE PROCESS_CD
							WHEN 'A' THEN 1
							ELSE 0
						END ) APPROVAL_CNT,
					COUNT(*) TOTAL_CNT
				  FROM dbo.WF_ANALY_SERVICE (NOLOCK)
				 WHERE PROCESS_DATE BETWEEN  @cFrontDate AND @dtAfterDate
				GROUP BY DATEPART(hour,PROCESS_DATE), DATENAME(hour,PROCESS_DATE) --시간
			UNION ALL
				SELECT 
					9, 1,'총합계',
					SUM (
						CASE PROCESS_CD 
							WHEN 'D' THEN 1
							ELSE 0
						END ) DRAFT_CNT,
					SUM (
						CASE PROCESS_CD
							WHEN 'A' THEN 1
							ELSE 0
						END ) APPROVAL_CNT,
					COUNT(*) TOTAL_CNT
				  FROM dbo.WF_ANALY_SERVICE (NOLOCK)
				 WHERE PROCESS_DATE BETWEEN  @cFrontDate AND @dtAfterDate
			) A
			ORDER BY SEQ, PROCESS_INT, PROCESS_DATE
	END

GO
/****** Object:  StoredProcedure [dbo].[UP_LIST_WF_SUBPROCESS]    Script Date: 2015-10-15 오후 1:30:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



----------------------------------------------------------------------
----------------------------------------------------------------------
-- 작성자: LDCC 신상훈
-- 작성일: 2004.06.24
-- 수정일: 2004.06.24
-- 설   명: 양식별 결재현황 조회
-- 테스트 :
-- @vcPID : ZFE2A847F09D547CA8940B03AB92E7A73
-- EXEC dbo.UP_LIST_WF_SUBPROCESS 0, 1, 10, 'ZECD9D55ABCF74D6C986D441C87B69A29', '', '', '', '', '', ''
----------------------------------------------------------------------
-- 수정일 :    2004.05.20
-- 수정자 :    LDCC 신상훈
-- 내   용 :    SET @cEndDate = DATEADD(DD, 1, @cEndDate)
--	      날짜검색에 종료일을 포함하기 위해서
----------------------------------------------------------------------
----------------------------------------------------------------------
CREATE      PROCEDURE [dbo].[UP_LIST_WF_SUBPROCESS]
    @intTotalCount     		int OUTPUT,
    @intPageNum			int,
    @intNumPerPage      		int,
    @vcPID			varchar(33),
    @vcSearchColumn		varchar(20),
    @vcSearchText       		varchar(50),
    @cStartDate			char(10),
    @cEndDate			char(10),
    @intSortColumn		int,
    @vcSortOrder			varchar(4)
    
AS
declare    
    @vcQuery			varchar(8000),
    @nvcCountQuery       nvarchar(4000),
    @vcSortColumnName		varchar(20)	-- Sorting 컬럼 이름
--검색종료일자
if(@cEndDate != '')	
   begin
	SET @cEndDate = DATEADD(DD, 1, @cEndDate)
   end
--총 게시물 수
SET @nvcCountQuery = 	N'	SELECT	@nCnt = COUNT(*) '
+			N'		FROM	eWF.dbo.PROCESS_INSTANCE (NOLOCK)'
+			N'			WHERE DELETE_DATE =  cast(''9999-12-31 00:00:00.000'' as datetime)	'
+			N'			AND PARENT_OID = ''' + @vcPID +''''
--검색시작일자
if(@cStartDate != '')
	SET @nvcCountQuery = @nvcCountQuery + N' AND CREATE_DATE >= CAST('''+@cStartDate+N''' AS smalldatetime) '
--검색종료일자
if(@cEndDate != '')	
	SET @nvcCountQuery = @nvcCountQuery + N' AND CREATE_DATE <= CAST('''+@cEndDate+N''' AS smalldatetime) '
--검색항목이 있을 경우
if(@vcSearchColumn != '')
	SET @nvcCountQuery = @nvcCountQuery +N' AND '+@vcSearchColumn+N' like ''%'+@vcSearchText+N'%''' 
EXEC sp_executesql @nvcCountQuery, N'@nCnt INT OUTPUT', @nCNT = @intTotalCount OUTPUT
-------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------
-- 내용 : Sorting 정보 설정
-------------------------------------------------------------------------------------------------
SET @vcSortColumnName = 
	(
	CASE @intSortColumn
		WHEN 1
				THEN	'SUBJECT'
		WHEN 2
				THEN	'CREATOR_DEPT'
		WHEN 3
				THEN	'CREATOR'
		WHEN 4
				THEN	'CREATE_DATE'
		WHEN 5
				THEN	'COMPLETED_DATE'
		WHEN 6
				THEN	'STATE'
		ELSE
					'CREATE_DATE'
	END
	)
IF @vcSortOrder = ''
begin
SET @vcSortOrder = 'DESC'
end
-------------------------------------------------------------------------------------------------
-- 내용 : 제목, 사용자부서명, 사용자명,부서명, 생성일, 결재완료일, 결재상태, PROCESS_ID, FORM_ID
-------------------------------------------------------------------------------------------------
SET @vcQuery = 'SELECT  C.SUBJECT,
						C.CREATOR_DEPT,
						C.CREATOR,
						C.CREATE_DATE,
						C.COMPLETED_DATE,
						CASE	C.STATE		
							WHEN 1  THEN ''기안작업완료''
							WHEN 2  THEN ''결재처리대상''
							WHEN 3  THEN ''결재처리중''
							WHEN 7  THEN ''결재완료''
							WHEN 8  THEN ''반려''
							WHEN 10 THEN ''결재처리대상''
							WHEN 13 THEN ''기안취소''
							ELSE		 ''기타등등''
						END AS  STATE,
						C.OID		
						, C.NAME DOC_NAME 				
				FROM	('
SET @vcQuery = @vcQuery +' 	SELECT	TOP '+CAST(@intPageNum * @intNumPerPage AS varchar) + '
	 			   				SUBJECT,
								CREATOR_DEPT,
								CREATOR,
								CREATE_DATE,
								COMPLETED_DATE,
								STATE,				
								OID
								, NAME 				
								
							FROM	eWF.dbo.PROCESS_INSTANCE (NOLOCK)
							WHERE	DELETE_DATE =  cast(''9999-12-31 00:00:00.000'' as datetime) AND PARENT_OID = ''' + @vcPID + ''''
--검색 시작일
if(@cStartDate != '')
	SET @vcQuery = @vcQuery + ' AND CREATE_DATE >= CAST('''+@cStartDate+ ''' AS smalldatetime) '
--검색 종료일
if(@cEndDate != '')
	SET @vcQuery = @vcQuery + ' AND CREATE_DATE <= CAST('''+@cEndDate+''' AS smalldatetime) '
--검색컬럼
if(@vcSearchColumn != '')
	SET @vcQuery = @vcQuery +' AND '+@vcSearchColumn+N' like ''%'+@vcSearchText+'%''' 
--SortingColumn
	
	SET @vcQuery = @vcQuery +' ORDER BY ' + @vcSortColumnName + '		' + @vcSortOrder
--페이징을 위해 삭제할 행을 가져온다.
SET @vcQuery = @vcQuery +' ) AS C  
 	LEFT OUTER JOIN
	(SELECT		TOP '+CAST((@intPageNum -1) * @intNumPerPage AS varchar)+' 
			SUBJECT,
			CREATOR_DEPT,
			CREATOR,
			CREATE_DATE,
			COMPLETED_DATE,
			STATE,		
			OID		
			, NAME 					
	FROM		eWF.dbo.PROCESS_INSTANCE (NOLOCK)
	WHERE		DELETE_DATE =  cast(''9999-12-31 00:00:00.000'' as datetime) AND PARENT_OID = ''' + @vcPID + ''''		
--검색 시작일
if(@cStartDate != '')
	SET @vcQuery = @vcQuery + ' AND CREATE_DATE >= CAST('''+@cStartDate+ ''' AS smalldatetime) '
--검색 종료일
if(@cEndDate != '')
	SET @vcQuery = @vcQuery + ' AND CREATE_DATE <= CAST('''+@cEndDate+''' AS smalldatetime) '
--검색컬럼
if(@vcSearchColumn != '')
	SET @vcQuery = @vcQuery +' AND '+@vcSearchColumn+N' like ''%'+@vcSearchText+'%''' 
--SortingColumn
	
	SET @vcQuery = @vcQuery +' ORDER BY  ' + @vcSortColumnName + '		' + @vcSortOrder
SET @vcQuery = @vcQuery +' ) AS D
    ON C.OID=D.OID
    WHERE D.OID IS NULL'
-- create table #temp(query text)
-- insert into #temp values(@vcQuery)
-- select * from #temp
-- drop table #temp
exec (@vcQuery)




GO
/****** Object:  StoredProcedure [dbo].[UP_LIST_WF_USERINFO]    Script Date: 2015-10-15 오후 1:30:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
----------------------------------------------------------------------
----------------------------------------------------------------------
-- 작성자: 신상훈
-- 작성일: 2004.07.02
-- 수정일: 2004.07.02
-- 설  명: 사용자 정보조회
-- 테스트: EXEC  UP_LIST_WF_USERINFO 10021, 10007, 'D'
----------------------------------------------------------------------
----------------------------------------------------------------------
CREATE  PROCEDURE [dbo].[UP_LIST_WF_USERINFO]
	@intUserId	int,	-- 사용자/부서ID
	@intDeptId	int,	-- 소속부서ID	
	@cUserType	char(1)	-- 사용자유형(부서/사용자)
	
AS
IF @cUserType = 'P'
BEGIN
	SELECT UserName, UserAccount, PositionOrder, DeptName, JikChaek, JikGeup, JikWi
	      FROM eManage.dbo.VW_USER(NOLOCK)
		WHERE UserID = @intUserId AND DeptID = @intDeptId
END
ELSE IF @cUserType = 'D'
BEGIN
	SELECT DeptName
	      FROM eManage.dbo.VW_DEPT(NOLOCK)
		WHERE DeptID = @intDeptId
END

GO
/****** Object:  StoredProcedure [dbo].[UP_LISTCIRCULATION_SIGNERLIST]    Script Date: 2015-10-15 오후 1:30:06 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE    PROC [dbo].[UP_LISTCIRCULATION_SIGNERLIST]
	@intUserID int
AS
--------------------------------------------------------
-- 작성자 : 김창수
-- 작성일 : 2004.03.12
-- 수정일 : 2004.03.12
-- 설    명 : 회람 정보를 select
--------------------------------------------------------
SET NOCOUNT ON
SELECT ID, 
	SignListName, 
	SignInform, 
	SignerList 
FROM dbo.Wf_SIGNER_LIST (NOLOCK)
WHERE UserID = @intUserID 
   AND ListType = 'N'

GO
/****** Object:  StoredProcedure [dbo].[UP_LISTFORMLIST_FORMS]    Script Date: 2015-10-15 오후 1:30:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

----------------------------------------------------------------------
----------------------------------------------------------------------
-- 작성자: 조성균
-- 작성일: 2004.03.06
-- 수정일: 2004.03.06
-- 설   명: 폼헤더 생성
--        	테스트 :
--		EXEC  UP_LISTFORMLIST_FORMS
----------------------------------------------------------------------
----------------------------------------------------------------------
-- 수정일 : 
-- 수정자 : 
-- 수정내용 : 
----------------------------------------------------------------------
----------------------------------------------------------------------
CREATE  PROCEDURE [dbo].[UP_LISTFORMLIST_FORMS]
	(
		@vcFolderId varchar(20)
	)
AS
	/* SET NOCOUNT ON */
	SELECT WF_FORMS.FORM_ID, 
		   WF_FORMS.FORM_NAME, 
		   WF_FORMS.FORM_ENAME
	FROM WF_FOLDER_DETAIL , WF_FORMS 
	WHERE WF_FOLDER_DETAIL.FORM_ID = WF_FORMS.FORM_ID 
	AND  WF_FOLDER_DETAIL.FOLDERID 
		  IN
			(
			 SELECT FOLDERID
			 FROM WF_FOLDER
			 WHERE PARENTFOLDERID = @vcFolderId
			)
	AND CURRENT_FORMS = 'Y'
		  
	RETURN 


GO
/****** Object:  StoredProcedure [dbo].[UP_RECURSIVE_UPDATEFOLDERDEPTH]    Script Date: 2015-10-15 오후 1:30:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UP_RECURSIVE_UPDATEFOLDERDEPTH]
(
	@FolderId  		VARCHAR(100),
	@depth			INT
)	
AS	
	
BEGIN	
DECLARE
	@ChildFolderID	VARCHAR(100)
DECLARE
	FOLDERID_Cursor   CURSOR FOR
		SELECT  folderId FROM dbo.WF_FOLDER WHERE PARENTFOLDERID = @FolderId
	OPEN FOLDERID_Cursor
	FETCH NEXT FROM FOLDERID_Cursor INTO @ChildFolderID
	WHILE @@FETCH_STATUS  = 0
       	BEGIN	-- WHILE#1
	
		--EXEC dbo.UP_RECURSIVE_UPDATEFOLDERDEPTH @ChildFolderID
		FETCH NEXT FROM FOLDERID_Cursor INTO @ChildFolderID
	END	-- end of WHILE#1
	UPDATE dbo.WF_FOLDER 
	SET DEPTH  = DEPTH +@depth
	WHERE FOLDERID = @FolderId
--	EXEC @sql
	CLOSE FOLDERID_Cursor 
	DEALLOCATE FOLDERID_Cursor
	RETURN 
END

GO
/****** Object:  StoredProcedure [dbo].[UP_SELECT_AGREEDEPT_COMMENT]    Script Date: 2015-10-15 오후 1:30:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO






CREATE	Procedure	[dbo].[UP_SELECT_AGREEDEPT_COMMENT]
		@pForm_ID		char(33),
		@pPROCESS_ID	char(33),
		@pU_AGREE_DEPT_Comment	varchar(8000) output
/*

declare	@pU_AGREE_DEPT_Comment	varchar(8000) 
exec dbo.UP_Select_AgreeDept_Comment	'YFA4BC440266849EB8DBA1A1FE7C55EE6', 'ZF02A3FE0555E473EA5047D595357B92D', @pU_AGREE_DEPT_Comment output
select	@pU_AGREE_DEPT_Comment

Select	Replace(f.U_AGREE_DEPT_COMMENT, '!@', '')
		From	eWFForm.dbo.Form_Y2C2E2C72B0B24A3782D8BCAA162C52E6 f
				Join	eWF.dbo.Process_Instance p
					On	p.Oid = f.Process_Id 
				Join	eWF.dbo.Work_Item w
					On	w.Oid = p.Parent_Work_Item_Oid
		Where	p.Parent_Oid = 'ZDE8A9621477B4CD7B846B524886A6D9D'
			and	Left(w.Participant_id, 4) = '2594'

select	Process_Id, U_AGREE_DEPT,	U_AGREE_DEPT_COMMENT,	U_AGREE_DEPT_ID
from	ewfform.dbo.form_Y2C2E2C72B0B24A3782D8BCAA162C52E6	where	process_id = 'Z1960A58E52CD4E548E48EA46B41E46EF' -- 발신부서
select	Process_Id, U_AGREE_DEPT,	U_AGREE_DEPT_COMMENT,	U_AGREE_DEPT_ID
from	ewfform.dbo.form_Y2C2E2C72B0B24A3782D8BCAA162C52E6	where	process_id = 'Z6F1E725A42F64853ABF15E6B999EB9C9' -- 합의부서1
select	Process_Id, U_AGREE_DEPT,	U_AGREE_DEPT_COMMENT,	U_AGREE_DEPT_ID
from	ewfform.dbo.form_Y2C2E2C72B0B24A3782D8BCAA162C52E6	where	process_id = 'Z3364F2C9F20F4DACA4A280AD84F8F507' -- 합의부서2
select	Process_Id, U_AGREE_DEPT,	U_AGREE_DEPT_COMMENT,	U_AGREE_DEPT_ID
from	ewfform.dbo.form_Y2C2E2C72B0B24A3782D8BCAA162C52E6	where	process_id = 'ZD7BEA61B16F840B9B3B963765A8C84EA' -- 합의부서2

select	Oid, Parent_Oid, Parent_Work_Item_Oid
from	ewf.dbo.Process_instance	where	Parent_Oid = 'Z1960A58E52CD4E548E48EA46B41E46EF'

select	Oid, Parent_Oid, Parent_Work_Item_Oid
from	ewf.dbo.Process_instance	where	oid = 'Z1960A58E52CD4E548E48EA46B41E46EF'
select	Oid, Parent_Oid, Parent_Work_Item_Oid
from	ewf.dbo.Process_instance	where	oid = 'Z6F1E725A42F64853ABF15E6B999EB9C9'
select	Oid, Parent_Oid, Parent_Work_Item_Oid
from	ewf.dbo.Process_instance	where	oid = 'Z3364F2C9F20F4DACA4A280AD84F8F507'
select	Oid, Parent_Oid, Parent_Work_Item_Oid
from	ewf.dbo.Process_instance	where	oid = 'ZD7BEA61B16F840B9B3B963765A8C84EA'

Exec dbo.UP_Select_AgreeDept_Comment 'YB132CCF992074F738816938A12F7B758', 'ZF02A3FE0555E473EA5047D595357B92D', @wU_AGREE_DEPT_Comment output

*/

AS

set transaction isolation level read uncommitted

Create	Table	#U_AGREE_DEPT_ID
(
	U_AGREE_DEPT_ID	varchar(1000)
)
Create	Table	#U_AGREE_DEPT_COMMENT
(
	U_AGREE_DEPT_COMMENT	varchar(8000)
)

Declare	@wU_AGREE_DEPT_ID		varchar(1000),
		@wU_AGREE_DEPT_ID_rtn	varchar(4),
		@vcBal1					int,
		@wProcess_Id			char(33),
		@wSql					varchar(8000),
		@i						int,

		@i2	int,
		@pColComment		varchar(8000),
		@pColCommentRtn		varchar(8000),
		@wColSeparatorPos	int,

		@wU_AGREE_DEPT_COMMENT	varchar(8000)



	--	양식테이블에서 합의부서들의 코드 읽음
	Set	@wSql = "
		Insert	Into	#U_AGREE_DEPT_ID
				(U_AGREE_DEPT_ID)
				Select	Case
							When	Rtrim(Ltrim(U_AGREE_DEPT_ID)) in ('undefined', 'NULL')	Then
								''
							Else
								Replace(U_AGREE_DEPT_ID, '!@', '_/')
						End
				From	eWFForm.dbo.Form_" + @pForm_ID + "
				Where	Process_Id = '" + @pPROCESS_ID + "'
		"
	Exec (@wSql)

	Select	@wU_AGREE_DEPT_ID = U_AGREE_DEPT_ID	From	#U_AGREE_DEPT_ID
	Select	@pU_AGREE_DEPT_Comment = ''

	--	합의부서의 갯수만큼 loop
	Set	@i = 1
	While	(1 = 1)
	Begin

		--	기안부서의 ProcessID
		Select	@wProcess_Id = Parent_Oid
		From	eWF.dbo.Process_Instance
		Where	Oid = @pPROCESS_ID
	
		If	IsNull(@wProcess_Id, '') = ''
			Select	@wProcess_Id = @pPROCESS_ID

		Exec @vcBal1 = eManage.dbo.SDAOBGetCols @wU_AGREE_DEPT_ID OutPut, @wU_AGREE_DEPT_ID_rtn OutPut      

		If	@wU_AGREE_DEPT_ID_rtn = ''	Break 
--			Select	@pU_AGREE_DEPT_Comment = @pU_AGREE_DEPT_Comment + Replace(f.U_AGREE_DEPT_COMMENT, '!@', '')

		Set	@wSql = "
			Insert	Into	#U_AGREE_DEPT_COMMENT
					(U_AGREE_DEPT_COMMENT)
			Select	f.U_AGREE_DEPT_COMMENT
			From	eWFForm.dbo.Form_" + @pForm_ID + " f
					Join	eWF.dbo.Process_Instance p
						On	p.Oid = f.Process_Id 
					Join	eWF.dbo.Work_Item w
						On	w.Oid = p.Parent_Work_Item_Oid
			Where	p.Parent_Oid = '" + @wProcess_Id + "'
				and	Left(w.Participant_id, 4) = " + @wU_AGREE_DEPT_ID_rtn + ""

		Exec (@wSql)

		Select	@wU_AGREE_DEPT_COMMENT = U_AGREE_DEPT_COMMENT
		From	#U_AGREE_DEPT_COMMENT

		Exec eManage.dbo.UP_GetStringByIndex @wU_AGREE_DEPT_COMMENT, @wU_AGREE_DEPT_COMMENT output, @i

		Set	@pU_AGREE_DEPT_Comment = @pU_AGREE_DEPT_COMMENT + IsNull(Rtrim(Ltrim(@wU_AGREE_DEPT_Comment)), '')

-- select	@wProcess_Id
-- select	@wU_AGREE_DEPT_ID_rtn
		If	@wU_AGREE_DEPT_ID <> ''
			Set	@pU_AGREE_DEPT_Comment = @pU_AGREE_DEPT_COMMENT + '!@'

		Set	@i = @i + 1
	
	End









GO
/****** Object:  StoredProcedure [dbo].[UP_SELECT_AGREEDEPT_TONGJE]    Script Date: 2015-10-15 오후 1:30:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO



CREATE	Procedure	[dbo].[UP_SELECT_AGREEDEPT_TONGJE]
		@pForm_ID		char(33),
		@pPROCESS_ID	char(33),
		@pTONGJE		varchar(1000) output
/*

declare	@pU_AGREE_DEPT_Comment	varchar(1000) 
exec dbo.UP_SELECT_AGREEDEPT_TONGJE	'Y9FA891C60DF54882BAE0DA51F233AF69', 'Z7C713861D6C94E8DBCA66D947263D1B8', @pU_AGREE_DEPT_Comment output
select	@pU_AGREE_DEPT_Comment

*/

AS


set transaction isolation level read uncommitted


Create	Table	#Data
(
	Data1	varchar(8000),
	Data2	varchar(8000)
)

Declare	@wProcess_Id		char(33),
		@wLastProcess_Id	char(33),
		@wSql			varchar(1000),
		@wSubStrIdx		varchar(2)

	--	기안부서의 ProcessID
	Select	@wProcess_Id = Parent_Oid
	From	eWF.dbo.Process_Instance
	Where	Oid = @pPROCESS_ID

	If	IsNull(@wProcess_Id, '') = ''
		Select	@wProcess_Id = @pPROCESS_ID

--	Drop	Table	#ProcList
	Select	w.Process_Instance_Oid, IsNull(w.Completed_Date, w.Create_Date) as Completed_Date
	Into	#ProcList
	From	eWF.dbo.Work_Item w
			Join	(Select	@wProcess_Id	as Oid
					Union
					Select	Oid
					From	eWF.dbo.Process_Instance
					Where	Parent_Oid = @wProcess_Id) p
				On	p.Oid = w.Process_Instance_Oid
	Where	w.[Name] like '기안%'
		or	w.[Name] like '일반결재자%'

	Select	@wLastProcess_Id = p.Process_Instance_Oid
	From	#ProcList p
			Join	(Select	Max(Completed_Date) Completed_Date
					From	#ProcList) d
				On	d.Completed_Date = p.Completed_Date

	Set	@wSql = "
		Insert	Into	#Data
				(Data1, Data2)
		Select	Case
					When	Ltrim(Rtrim(f.Tongje)) = '' or Ltrim(Rtrim(f.Tongje)) = '뷁'	Then
						''
					Else
						Substring(f.Tongje, 1, charindex('뷁', f.Tongje) - 1)
				End,
				Case
					When	Ltrim(Rtrim(f.Tongje)) = '' or Ltrim(Rtrim(f.Tongje)) = '뷁'	Then
						''
					Else
						Substring(f.Tongje, charindex('뷁', f.Tongje) + 1,  len(f.Tongje) - charindex('뷁', f.Tongje))
				End
		From	eWFForm.dbo.Form_" + @pForm_ID + " f
		Where	f.Process_Id = '" + @wLastProcess_Id + "'
		"
	Exec(@wSql)


	Select	@pTONGJE = IsNull(Data1, '') + '뷁' + IsNull(Data2, '')
	From	#Data







GO
/****** Object:  StoredProcedure [dbo].[UP_SELECT_ARVALERT_WF_CONFIG_USER]    Script Date: 2015-10-15 오후 1:30:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


----------------------------------------------------------------------
----------------------------------------------------------------------
-- 작성자: 신상훈
-- 작성일: 2004.03.19
-- 수정일: 2004.03.19
-- 설  명: 타부서문서함 권한 삭제
-- 테스트: EXEC  UP_SELECT_ARVALERT_WF_CONFIG_USER
----------------------------------------------------------------------
-- 수정일: 
-- 수정자: 
-- 수정내용 : 
----------------------------------------------------------------------
----------------------------------------------------------------------

CREATE   PROCEDURE [dbo].[UP_SELECT_ARVALERT_WF_CONFIG_USER]

	@intUserId	int,
	@intDeptId	int
	
AS

	SELECT	NOTICEMAIL, NOTICEMESSANGER
	FROM	eWFFORM.dbo.WF_CONFIG_USER(NOLOCK)
	WHERE	USERID = @intUserId	AND DEPTID = @intDeptId
	
	



GO
/****** Object:  StoredProcedure [dbo].[UP_SELECT_ARVALTMAIL_WF_CONFIG_USER]    Script Date: 2015-10-15 오후 1:30:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UP_SELECT_ARVALTMAIL_WF_CONFIG_USER]
	@intUserId	int,
	@intDeptId	int
	
AS
	SELECT	NOTICEMAIL 
	FROM	eWFFORM.dbo.WF_CONFIG_USER
	WHERE	USERID = @intUserId	AND DEPTID = @intDeptId
	
	

GO
/****** Object:  StoredProcedure [dbo].[UP_SELECT_CHECK_FORMLINE_ACL]    Script Date: 2015-10-15 오후 1:30:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


----------------------------------------------------------------------
----------------------------------------------------------------------
-- 작성자: 신상훈
-- 작성일: 2004.03.08
-- 수정일: 2004.03.08
-- 설  명: 하위부서 부서문서함 조회
-- 테스트: EXEC  UP_SELECT_CHECK_FORMLINE_ACL 10021, 10007
----------------------------------------------------------------------
-- 수정일 : 
-- 수정자 : 
-- 수정내용 : 
----------------------------------------------------------------------
----------------------------------------------------------------------
CREATE   PROC [dbo].[UP_SELECT_CHECK_FORMLINE_ACL]
	@intUserId	int,	-- 사용자/부서ID
	@intDeptId	int	-- 소속부서ID	
	
AS
SELECT CASE COUNT(ACLID) WHEN 1 THEN 'Y' WHEN 0 THEN 'N' END AS ACLID
FROM
(
SELECT  CASE AVG(A.ACLID) WHEN 0 THEN 'N' WHEN 1 THEN 'Y' END AS ACLID
      FROM
	(

	SELECT	case ACLID  when 'Y' then 1 when 'N' then 0 end as ACLID
	      FROM eWFFORM.dbo.WF_ACL_FORM_LINE(NOLOCK)
		WHERE USERID = @intUserId AND DEPTID = @intDeptId AND USER_TYPE='P'
		
	UNION ALL
	
	SELECT	case ACLID  when 'Y' then 1 when 'N' then 0 end as ACLID
	      FROM eWFFORM.dbo.WF_ACL_FORM_LINE(NOLOCK)
		WHERE DEPTID = @intDeptId AND USER_TYPE='D'
	GROUP BY ACLID
	) AS A
) AS B
         WHERE ACLID='Y'


GO
/****** Object:  StoredProcedure [dbo].[UP_SELECT_CIRCULATIONSLIST]    Script Date: 2015-10-15 오후 1:30:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE    PROC [dbo].[UP_SELECT_CIRCULATIONSLIST]
	@intUserID int
AS
--------------------------------------------------------
-- 작성자 : 김창수
-- 작성일 : 2004.03.12
-- 수정일 : 2004.03.12
-- 설    명 : 회람 정보를 select
--------------------------------------------------------
SET NOCOUNT ON
SELECT ID, 
	SignListName, 
	SignInform, 
	SignerList 
FROM dbo.Wf_SIGNER_LIST (NOLOCK)
WHERE UserID = @intUserID 
   AND ListType = 'N'

GO
/****** Object:  StoredProcedure [dbo].[UP_SELECT_COUNT_ACL_GROUP]    Script Date: 2015-10-15 오후 1:30:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
----------------------------------------------------------------------
----------------------------------------------------------------------
-- 작성자: 신상훈
-- 작성일: 2004.05.21
-- 수정일: 2004.05.21
-- 설  명: 하위부서 부서문서함 조회
-- 테스트: EXEC DBO.UP_SELECT_COUNT_ACL_GROUP 0, 'W1', 'G'
----------------------------------------------------------------------
-- 수정일 : 
-- 수정자 : 
-- 수정내용 : 
----------------------------------------------------------------------
----------------------------------------------------------------------
CREATE PROC [dbo].[UP_SELECT_COUNT_ACL_GROUP]
    
    @intTotalCount		int	OUTPUT,
    @vcGroupCode		varchar(4),
    @cDocLevel			char(1)
    
AS
DECLARE @nvcCountQuery       nvarchar(400)
SET @nvcCountQuery = 	N'		SELECT	@nCnt = COUNT(*) '
+						N'		FROM	eWFFORM.dbo.WF_ACL_GROUP '
+						N'		WHERE GROUP_CODE = ''' + @vcGroupCode + ''' AND DOC_LEVEL = ''' + @cDocLevel + ''''
EXEC sp_executesql @nvcCountQuery, N'@nCnt INT OUTPUT', @nCNT = @intTotalCount OUTPUT

GO
/****** Object:  StoredProcedure [dbo].[UP_SELECT_DB_APPROVAL]    Script Date: 2015-10-15 오후 1:30:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO













CREATE	Procedure	[dbo].[UP_SELECT_DB_APPROVAL]

/*

select	count(distinct process_id)	from	EWFFORM.DBO.WF_DBAPPROVAL	where	process_id in
( 'Z2699E5CDCFD04A61A6042166FEDEE53B',
'Z119A2715EEB3405A929543F43F77A7B9')

select	top 10 *	from	ewf.dbo.work_item	where	process_instance_oid = 'ZEA27AE22617D44F68D2AB51AF1690A50'	order by create_date
select	top 10 *	from	ewf.dbo.process_instance	where	oid = 'Z1CCD237E825B4ABFB8E26B78AD0E328F'

select	*	from	emanage.dbo.vw_user	where	empid = '19009011'
select	*	from	ewfform.dbo.wf_dbapproval

*/

As

--	Drop	Table	#AppList
Create	Table	#AppList
(
	Process_ID		char(33),
	EmpID			char(8),
	DeptCd			varchar(20),
	JikChaek		varchar(10),
	Completed_Date	datetime
)

--	Drop	Table	#Process_ID
Create	Table	#Process_ID
(
	Num				int	identity(1, 1),
	Process_ID		char(33)
)

--	Drop	Table	#TmpAppList
Create	Table	#TmpAppList
(
	Num				int	identity(1, 1),
	EmpID			char(8),
	DeptCd			varchar(20),
	JikChaek		varchar(10),
	Completed_Date	varchar(23)
)

--	Drop	Table	#Result
Create	Table	#Result
(
	Process_ID		char(33),
	EmpID			varchar(500),
	DeptCd			varchar(500),
	JikChaek		varchar(500),
	Completed_Date	varchar(1000)
)

--	'기안자'로 시작하는 데이타가 없는 결재건은 Process_Instance테이블을 이용해서 결재정보를 구한다.
Insert	Into	#AppList
				(Process_ID,	EmpID,	DeptCd,	JikChaek,	Completed_Date)
		Select	Distinct
				d.Process_ID, u.EmpID, u.DeptID, u.JikChaekID, p.Create_Date
		From	eWFForm.dbo.WF_DBApproval d (NoLock)
				Left Join	eWF.dbo.Work_Item w (NoLock)
					On	w.Process_Instance_Oid = d.Process_ID
					and	(w.[Name] like '기안%')
				Join	eWF.dbo.Process_Instance p (NoLock)
					On	p.Oid = d.Process_ID
					and	p.State <> '0'
				Join	eManage.dbo.VW_User u (NoLock)
					On	u.UserID = p.Creator_ID
					and	u.PositionOrder = 1
					and GetDate() Between u.StartDate and u.EndDate
		Where	w.Oid is Null
--	and	d.process_id in ( 'Z2699E5CDCFD04A61A6042166FEDEE53B', 'Z119A2715EEB3405A929543F43F77A7B9')

--	기안자 이후의 결재자, 개인합의자 정보는 Work_Item에서 구한다
Insert	Into	#AppList
				(Process_ID,	EmpID,	DeptCd,	JikChaek,	Completed_Date)
		Select	Distinct
				d.Process_ID, u.EmpID, u.DeptID, u.JikChaekID, w.Completed_Date
		From	eWFForm.dbo.WF_DBApproval d (NoLock)
				Join	eWF.dbo.Work_Item w (NoLock)
					On	w.Process_Instance_Oid = d.Process_ID
					and	w.[Name] in ('일반결재자', '개인합의')
					and w.Completed_Date is not null
				Join	eManage.dbo.VW_User u (NoLock)
					On	u.UserID = w.Participant_ID
					and	u.PositionOrder = 1
					and GetDate() Between u.StartDate and u.EndDate
		Where	d.Retry_Time <= GetDate()
--	and	d.process_id in ( 'Z2699E5CDCFD04A61A6042166FEDEE53B', 'Z119A2715EEB3405A929543F43F77A7B9')
		Order by w.Completed_Date

Declare	@wNum		int,
		@wTmpNum	int,
		@wProcess_ID	char(33),

		@wEmpID				varchar(8),
		@wDeptCd			varchar(20),
		@wJikChaek			varchar(10),
		@wCompleted_Date	varchar(23)

Set	@wNum = 0

Insert	Into	#Process_ID
				(Process_ID)
		Select	Distinct Process_ID
		From	#AppList

--	select	*	from	#AppList

While	(1 = 1)
Begin

	--	프로세스 아이디 추출.
	Select	Top 1
			@wNum = Num,
			@wProcess_ID = Process_ID
	From	#Process_ID
	Where	Num > @wNum
	Order by Num

	If	@@RowCount = 0	Break

	--	추출한 프로세스 아이디의 모든 결재정보 Search

	Truncate	Table		#TmpAppList
	Insert	Into	#TmpAppList
					(EmpID,	DeptCd,	JikChaek,	Completed_Date)
			Select	EmpID,	DeptCd,	JikChaek,	Convert(varchar(23), Completed_Date, 121)
			From	#AppList
			Where	Process_ID = @wProcess_ID
			Order by Completed_Date

	Set	@wTmpNum = 0

--	select	*	from	#TmpAppList

	While	(1 = 1)
	Begin

		Select	Top 1
				@wTmpNum = Num,
				@wEmpID = EmpID,
				@wDeptCd = DeptCd,
				@wJikChaek = JikChaek,
				@wCompleted_Date = Convert(varchar(23), Completed_Date, 121)
		From	#TmpAppList
		Where	Num > @wTmpNum
		Order by Num

		If	@@RowCount = 0	Break

		If	@wTmpNum = 1
		Begin
			Insert	Into	#Result	(Process_ID,	EmpID,	DeptCd,	JikChaek,	Completed_Date)
				Values	(@wProcess_ID,	@wEmpID,	@wDeptCd,	@wJikChaek,	@wCompleted_Date)
		End
		Else
		Begin
			Update	#Result
			Set		EmpID = EmpID + ';' + @wEmpID,
					DeptCd = DeptCd + ';' + @wDeptCd,
					JikChaek = JikChaek + ';' + @wJikChaek,
					Completed_Date = Completed_Date + ';' + @wCompleted_Date
			Where	Process_ID = @wProcess_ID
		End

	End

End

Select	d.ApprovalSeq,
		d.Retry_Count,
		d.ModuleID,
		d.Process_ID,
		d.ApprovalName,
		d.ObjectID,
		r.Process_ID	as Process_Instance_OID,
		Case
			When	Ltrim(Rtrim(IsNull(d.DocType, ''))) = ''	Then
				f.Form_EName
			Else
				d.DocType
		End	as DocType,
		p.Doc_Name,
		r.EmpID,
		r.Completed_Date,
		r.DeptCd,
		r.JikChaek,
		d.ApprovalStatus,
		--	개발서버
/*
		Case	
			--LC_SEQURITY_DRAFT, 담보의뢰품의서
			When	f.Form_Id = 'YC4E7DFDB0B42493ABB2BDCACC76AD0F5'	Then
				(Select	U_Detail_String	From	Form_YC4E7DFDB0B42493ABB2BDCACC76AD0F5 f	Where	Process_ID = r.Process_ID)
			--LC_SUPPORT_DRAFT, 거래선지원품의서(판촉지원)
			When	f.Form_Id = 'Y91A030E57A8A46C091231D1FB5D01360'	Then
				(Select	U_Detail_String	From	Form_Y91A030E57A8A46C091231D1FB5D01360 f	Where	Process_ID = r.Process_ID)
			--LC_EQUIPCHANGE_REQUEST, 판매장비교체요청서
			When	f.Form_Id = 'Y88DAC42D65C34FCCAD6896819E08E234'	Then
				(Select	U_ADMISSIONQTY From	Form_Y88DAC42D65C34FCCAD6896819E08E234 f	Where	Process_ID = r.Process_ID)
			--LC_EQUIPINSTALL_REQUEST, 판매장비설치요청서
			When	f.Form_Id = 'YB4FE368CBBE34A16B9F92913D609C365'	Then
				(Select	U_ADMISSIONQTY	From	Form_YB4FE368CBBE34A16B9F92913D609C365 f	Where	Process_ID = r.Process_ID)
			--LC_ENVIRONCHECK_REPORT_FACTORY, 환경점검현황
			When	f.Form_Id = 'Y95A4ED74F0554359991C9CB6EF750DBB'	Then
				(Select	U_FAC_OPINION_IN_TEXTAREA	From	Form_Y95A4ED74F0554359991C9CB6EF750DBB f	Where	Process_ID = r.Process_ID)
			--LC_ENVIRONCHECK_REPORT_MAIN, 환경점검주보
			When	f.Form_Id = 'Y1A1AF1E3EDDA4173896470564D8A89E4'	Then
				(Select	U_FAC_OPINION_IN_TEXTAREA	From	Form_Y1A1AF1E3EDDA4173896470564D8A89E4 f	Where	Process_ID = r.Process_ID)
			--LC_FIRESAFECHECK_REPORT_FACTORY, 화재및안전사고점검일지
			When	f.Form_Id = 'Y12D07550C73345638CA6029ED7C7D8C8'	Then
				(Select	U_FAC_OPINION_IN_TEXTAREA	From	Form_Y12D07550C73345638CA6029ED7C7D8C8 f	Where	Process_ID = r.Process_ID)
			--LC_FIRESAFECHECK_REPORT_MAIN, 화재및안전사고점검주보
			When	f.Form_Id = 'YEEB9ACBCB3874133AD38F38A0322DC38'	Then
				(Select	U_FAC_OPINION_IN_TEXTAREA	From	Form_YEEB9ACBCB3874133AD38F38A0322DC38 f	Where	Process_ID = r.Process_ID)
			--LC_CAR_MAINTENANCE, 차량정비발생현황
			When	f.Form_Id = 'YDE32B15C4C934C80A61A6E02ACE1B626'	Then
				(Select	U_MT_NUM	From	Form_YDE32B15C4C934C80A61A6E02ACE1B626 f	Where	Process_ID = r.Process_ID)
			--LC_ORDER_REQUEST, 구매의뢰서
			When	f.Form_Id = 'Y8D4A994E63054A5EB14621BDD3A4483E'	Then
				(Select	U_RESERVED3	From	Form_Y8D4A994E63054A5EB14621BDD3A4483E f	Where	Process_ID = r.Process_ID)
			--LC_RESOLUTION_REQUEST, 구매결의서
			When	f.Form_Id = 'Y3AAADA3BB0CE45D58106CDB1CA308EE1'	Then
				(Select	U_RESERVED3	From	Form_Y3AAADA3BB0CE45D58106CDB1CA308EE1 f	Where	Process_ID = r.Process_ID)

			Else
				ISNULL(ADMISSION_QTY, '')
		End	as ADMISSION_QTY

*/
		--	운영서버
		Case	
			--LC_SEQURITY_DRAFT, 담보의뢰품의서
			When	f.Form_Id = 'YA8A03008E3B44079A4C41705CDA97979'	Then
				(Select	U_Detail_String	From	Form_YA8A03008E3B44079A4C41705CDA97979 f	Where	Process_ID = r.Process_ID)
			--LC_SUPPORT_DRAFT, 거래선지원품의서(판촉지원)
			When	f.Form_Id = 'YB9222DABFA484AC6AC97F2A23C649789'	Then
				(Select	U_Detail_String	From	Form_YB9222DABFA484AC6AC97F2A23C649789 f	Where	Process_ID = r.Process_ID)
			--LC_EQUIPCHANGE_REQUEST, 판매장비교체요청서
			When	f.Form_Id = 'YFEA425C4FB9346D0B81C119099FB5F35'	Then
				(Select	U_ADMISSIONQTY From	Form_YFEA425C4FB9346D0B81C119099FB5F35 f	Where	Process_ID = r.Process_ID)
			--LC_EQUIPINSTALL_REQUEST, 판매장비설치요청서
			When	f.Form_Id = 'Y5149C2A149D24EADA29D306082EBA5F3'	Then
				(Select	U_ADMISSIONQTY	From	Form_Y5149C2A149D24EADA29D306082EBA5F3 f	Where	Process_ID = r.Process_ID)
			--LC_ENVIRONCHECK_REPORT_FACTORY, 환경점검현황
			When	f.Form_Id = 'YB68D2E23A8F74970967B4D08912F0B9C'	Then
				(Select	U_FAC_OPINION_IN_TEXTAREA	From	Form_YB68D2E23A8F74970967B4D08912F0B9C f	Where	Process_ID = r.Process_ID)
			--LC_ENVIRONCHECK_REPORT_MAIN, 환경점검주보
			When	f.Form_Id = 'Y35CED4073A514D94875F61A63FBE3666'	Then
				(Select	U_FAC_OPINION_IN_TEXTAREA	From	Form_Y35CED4073A514D94875F61A63FBE3666 f	Where	Process_ID = r.Process_ID)
			--LC_FIRESAFECHECK_REPORT_FACTORY, 화재및안전사고점검일지
			When	f.Form_Id = 'Y8410F34EDFE44A6098AF6F9938C8F8C2'	Then
				(Select	U_FAC_OPINION_IN_TEXTAREA	From	Form_Y8410F34EDFE44A6098AF6F9938C8F8C2 f	Where	Process_ID = r.Process_ID)
			--LC_FIRESAFECHECK_REPORT_MAIN, 화재및안전사고점검주보
			When	f.Form_Id = 'Y462E36DD55F74F098C8A3D141BB0FCCF'	Then
				(Select	U_FAC_OPINION_IN_TEXTAREA	From	Form_Y462E36DD55F74F098C8A3D141BB0FCCF f	Where	Process_ID = r.Process_ID)
			
			--LC_CAR_MAINTENANCE, 차량정비발생현황
			When	f.Form_Id = 'Y9A282068897043E08905CD42881773D5'	Then
				(Select	U_MT_NUM	From	Form_Y9A282068897043E08905CD42881773D5 f	Where	Process_ID = r.Process_ID)

			--LC_ORDER_REQUEST, 구매의뢰서
			When	f.Form_Id = 'Y8D4A994E63054A5EB14621BDD3A4483E'	Then
				(Select	U_RESERVED3	From	Form_Y8D4A994E63054A5EB14621BDD3A4483E f	Where	Process_ID = r.Process_ID)

			--LC_RESOLUTION_REQUEST, 구매결의서
			When	f.Form_Id = 'Y3AAADA3BB0CE45D58106CDB1CA308EE1'	Then
				(Select	U_RESERVED3	From	Form_Y3AAADA3BB0CE45D58106CDB1CA308EE1 f	Where	Process_ID = r.Process_ID)
				
			Else
				ISNULL(ADMISSION_QTY, '')
		End	as ADMISSION_QTY

From	#Result r
		Join	eWFForm.dbo.WF_DBApproval d (NoLock)
			On	d.Process_id = r.Process_ID
			and	d.Retry_Time <= GetDate()
			AND	MODULEID NOT IN ('SD', 'MM', 'QM', 'TR','S1', 'S2', 'S3', 'S4', 'S5', 'S6')
		Join	eWFForm.dbo.WF_Forms_Prop p (NoLock)
			On	p.Process_ID = r.Process_ID
		Join	ewfform.dbo.wf_Forms f (NoLock)
			On	f.Form_ID = p.Form_ID
-- 		Join	(Select	r.Process_ID, Max(ApprovalStatus) ApprovalStatus
-- 				From	#Result r
-- 						Join	eWFForm.dbo.WF_DBApproval d (NoLock)
-- 							On	d.Process_id = r.Process_id
-- 							and	d.Retry_Time <= GetDate()
-- 				Group by r.Process_ID) s
-- 			On	s.Process_ID = r.Process_ID
-- 			and	s.ApprovalStatus = d.ApprovalStatus
Order by r.Completed_Date, d.ApprovalStatus















GO
/****** Object:  StoredProcedure [dbo].[UP_SELECT_DB_APPROVAL_ERROR]    Script Date: 2015-10-15 오후 1:30:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO




CREATE	Procedure	[dbo].[UP_SELECT_DB_APPROVAL_ERROR]
		@pForm_Name	varchar(100) = '',
		@pStartDate	char(8) = '',
		@pEndDate	char(8) = ''
/*

Select 	a.*
From 	openrowset('sqloledb','140.100.44.100\inst1'; 'sa'; 'dbadmin', 'exec lecom.dbo.UP_UPDATE_APPROVALSTATUS_temp ''200602060001'', ''Z28863C7702A04D22882E8E05C226CCF6'', ''판촉물신청서'', ''LC_PROMOTIONREQUEST_DB'', ''20047533;19845044;19112543;20100948;20200047;19400281'', ''2006-02-06 15:56:54.000;2006-02-06 16:30:29.183;2006-02-06 16:31:14.623;2006-02-06 16:58:10.853;2006-02-06 18:07:55.743;2006-02-06 18:24:47.147'', ''00256;00256;00256;00565;00565;00565'', ''0017;0016;0009;0017;0015;0013'', ''6'', ''_/2500_/_/_/_/_/_/_/END''') As a

select	p.name, f.form_name
from	ewfform.dbo.wf_forms f
		join	ewf.dbo.PROCESS p
			on	p.oid = f.def_oid
where	f.current_forms = 'y'
order by f.ClassifiCation, p.name

Select	Doc_Name, Count(*)
From	##List
Group by Doc_Name

exec dbo.UP_SELECT_DB_APPROVAL_ERROR '거래처지원품의서(판촉지원)', '20100201', '20100201'
exec dbo.UP_SELECT_DB_APPROVAL_ERROR '예산부서월실적', '20060203', '20060213'
exec dbo.UP_SELECT_DB_APPROVAL_ERROR '구매의뢰서', '20060203', '20060213'
exec dbo.UP_SELECT_DB_APPROVAL_ERROR '판매용장비신청서', '20060203', '20060213'
exec dbo.UP_SELECT_DB_APPROVAL_ERROR '항목변경신청서', '20060203', '20060213'
exec dbo.UP_SELECT_DB_APPROVAL_ERROR '출고의뢰서', '20060203', '20060213'
exec dbo.UP_SELECT_DB_APPROVAL_ERROR '부가세신고서', '20060203', '20060213'
exec dbo.UP_SELECT_DB_APPROVAL_ERROR '반납의뢰서', '20060203', '20060213'
exec dbo.UP_SELECT_DB_APPROVAL_ERROR 'SpareParts사용보고서', '20060203', '20060213'
exec dbo.UP_SELECT_DB_APPROVAL_ERROR '포장소모품신청서', '20060203', '20060213'
exec dbo.UP_SELECT_DB_APPROVAL_ERROR '거래선지원품의서', '20060203', '20060213'

exec dbo.UP_SELECT_DB_APPROVAL_ERROR '구매결의서', '20060203', '20060213'
exec dbo.UP_SELECT_DB_APPROVAL_ERROR '어음수표잔고명세서', '20060203', '20060213'
exec dbo.UP_SELECT_DB_APPROVAL_ERROR '변동예산신청서', '20060203', '20060213'

*/
As

Set	Nocount	On

Drop	Table	##List_tmp
Create	Table	##List_tmp
(
	Num			int identity(1, 1),
	Doc_Name	varchar(100),
	Process_ID	char(33),
	ObjectID	varchar(200)
)

Declare	@wFormID	char(33),
		@wFolder	varchar(50),
		@wSql		varchar(8000)

Select	@wFormID = Form_ID,
		@wFolder = 
				Case
					When	p.Name in ('(칠성)신청서결재 프로세스(V2)', '(칠성)X단 Loop 결재 프로세스(V2)', '(칠성)품의수신복합결재 프로세스(V2)')	Then
						'신청처리함'
					When	p.Name in ('(칠성)품의서결재 프로세스(V2)')	Then
						'품의함'
				End
From	eWFForm.dbo.WF_Forms f
		Join	eWF.dbo.Process p
			On	p.OID = f.Def_Oid
Where	Form_Name = @pForm_Name
	and	Current_Forms = 'Y'

Set	@wSql = "
	Insert	Into	##List_tmp
			(Doc_Name,	Process_ID, ObjectID)
		Select	Doc_Name, Process_ID, OBJECTID
		From	eWFForm.dbo.Form_" + @wFormID + "
		Where	Substring(SUGGESTDATE, 1, 4) + Substring(SUGGESTDATE, 6, 2) + Substring(SUGGESTDATE, 9, 2) between '" + @pStartDate + "' and '" + @pEndDate + "'
			and	Process_Instance_State <> '8'
		Union
		Select	Doc_Name, p.Oid, f.OBJECTID
		From	eWF.dbo.Process_Instance p
				Join	eWF.dbo.Work_Item w
					On	w.Process_Instance_Oid = p.Oid
				Join	eWFForm.dbo.Form_" + @wFormID + " f
					On	f.Process_Id = p.Oid
		Where	p.Name = '" + @pForm_Name + "'
			and	w.Name like '" + @wFolder + "%'
			and	convert(char(8), p.Completed_date, 112) between '" + @pStartDate + "' and '" + @pEndDate + "'
			and	w.Process_Instance_View_State <> '8'
	"

Exec (@wSql)

-- Select 	a.*
-- From 	openrowset('sqloledb','140.100.44.100\inst1'; 'LeCom'; 'LeCom', 'Select	*	From	LeSale.dbo.TSMGoodRequest	Where	RequestDate between ''20060203'' and ''20060213''') As a
-- 
-- Select	*	
-- From	LeSale.dbo.TSMGoodRequest m
-- 		Join	LeCom.dbo.TZAApprovalInfo i
-- 			On	i.AppKey = m.RequestNo
-- Where	m.RequestDate between '20060203' and '20060213'

-- Select	*
-- From	##List_tmp

Declare	@wNum	int,
		@wDoc_Name		varchar(50),
		@wProcess_ID	varchar(33)

Select	@wNum = 0,
		@wSql = ''

While	(1 = 1)
Begin

	Select	Top 1
			@wNum = Num,
			@wDoc_Name = Doc_Name,
			@wProcess_ID = Process_ID
	From	##List_tmp
	Where	Num > @wNum

	If	@@Rowcount = 0	Break

	Exec dbo.UP_UPDATE_DB_APPROVAL_ERROR @wDoc_Name, @wProcess_ID, @wSql OutPut

--	Select	@wSql

End





GO
/****** Object:  StoredProcedure [dbo].[UP_SELECT_DB_APPROVAL_SAP]    Script Date: 2015-10-15 오후 1:30:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO








CREATE	PROCEDURE	[dbo].[UP_SELECT_DB_APPROVAL_SAP]

/*
select	*
from	ewfform.dbo.wf_dbapproval

*/

AS

SELECT	
		d.APPROVALSEQ,
		d.Process_ID,
		d.DocType,
		d.ObjectID,
		d.ApprovalStatus
FROM	eWFForm.dbo.WF_DBApproval d (NoLock)
WHERE	d.Retry_Time <= GETDATE()
	AND	MODULEID IN ('SD', 'MM', 'QM', 'TR','S1', 'S2', 'S3', 'S4', 'S5', 'S6') 
ORDER BY D.RETRY_TIME









GO
/****** Object:  StoredProcedure [dbo].[UP_SELECT_DB_APPROVAL_Temp]    Script Date: 2015-10-15 오후 1:30:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





CREATE	Procedure	[dbo].[UP_SELECT_DB_APPROVAL_Temp]

/*

select	count(distinct process_id)	from	EWFFORM.DBO.WF_DBAPPROVAL	where	process_id in
( 'Z2699E5CDCFD04A61A6042166FEDEE53B',
'Z119A2715EEB3405A929543F43F77A7B9')

select	*
into	ewfform.dbo.wf_dbapproval20060710
from	ewfform.dbo.wf_dbapproval

select	top 10 *	from	ewf.dbo.work_item	where	process_instance_oid = 'ZEA27AE22617D44F68D2AB51AF1690A50'	order by create_date

select	top 10 *	from	ewf.dbo.process_instance	where	oid = 'Z1CCD237E825B4ABFB8E26B78AD0E328F'
select	*	from	emanage.dbo.vw_user	where	empid = '19009011'

*/

As

--	Drop	Table	#AppList
Create	Table	#AppList
(
	Process_ID		char(33),
	EmpID			char(8),
	DeptCd			varchar(20),
	JikChaek		varchar(10),
	Completed_Date	datetime
)

--	Drop	Table	#Process_ID
Create	Table	#Process_ID
(
	Num				int	identity(1, 1),
	Process_ID		char(33)
)

--	Drop	Table	#TmpAppList
Create	Table	#TmpAppList
(
	Num				int	identity(1, 1),
	EmpID			char(8),
	DeptCd			varchar(20),
	JikChaek		varchar(10),
	Completed_Date	varchar(23)
)

--	Drop	Table	#Result
Create	Table	#Result
(
	Process_ID		char(33),
	EmpID			varchar(500),
	DeptCd			varchar(500),
	JikChaek		varchar(500),
	Completed_Date	varchar(1000)
)

--	'기안자'로 시작하는 데이타가 없는 결재건은 Process_Instance테이블을 이용해서 결재정보를 구한다.
Insert	Into	#AppList
				(Process_ID,	EmpID,	DeptCd,	JikChaek,	Completed_Date)
		Select	Distinct
				d.Process_ID, u.EmpID, u.DeptID, u.JikChaekID, p.Create_Date
		From	eWFForm.dbo.WF_DBApproval d (NoLock)
				Left Join	eWF.dbo.Work_Item w (NoLock)
					On	w.Process_Instance_Oid = d.Process_ID
					and	(w.[Name] like '기안%')
				Join	eWF.dbo.Process_Instance p (NoLock)
					On	p.Oid = d.Process_ID
					and	p.State <> '0'
				Join	eManage.dbo.VW_User u (NoLock)
					On	u.UserID = p.Creator_ID
					and	u.PositionOrder = 1
					and GetDate() Between u.StartDate and u.EndDate
		Where	w.Oid is Null
--	and	d.process_id in ( 'Z2699E5CDCFD04A61A6042166FEDEE53B', 'Z119A2715EEB3405A929543F43F77A7B9')

--	기안자 이후의 결재자, 개인합의자 정보는 Work_Item에서 구한다
Insert	Into	#AppList
				(Process_ID,	EmpID,	DeptCd,	JikChaek,	Completed_Date)
		Select	Distinct
				d.Process_ID, u.EmpID, u.DeptID, u.JikChaekID, w.Completed_Date
		From	eWFForm.dbo.WF_DBApproval d (NoLock)
				Join	eWF.dbo.Work_Item w (NoLock)
					On	w.Process_Instance_Oid = d.Process_ID
					and	w.[Name] in ('일반결재자', '개인합의')
					and w.Completed_Date is not null
				Join	eManage.dbo.VW_User u (NoLock)
					On	u.UserID = w.Participant_ID
					and	u.PositionOrder = 1
					and GetDate() Between u.StartDate and u.EndDate
		Where	d.Retry_Time <= GetDate()
--	and	d.process_id in ( 'Z2699E5CDCFD04A61A6042166FEDEE53B', 'Z119A2715EEB3405A929543F43F77A7B9')
		Order by w.Completed_Date

Declare	@wNum		int,
		@wTmpNum	int,
		@wProcess_ID	char(33),

		@wEmpID				varchar(8),
		@wDeptCd			varchar(20),
		@wJikChaek			varchar(10),
		@wCompleted_Date	varchar(23)

Set	@wNum = 0

Insert	Into	#Process_ID
				(Process_ID)
		Select	Distinct Process_ID
		From	#AppList

--	select	*	from	#AppList

While	(1 = 1)
Begin

	--	프로세스 아이디 추출.
	Select	Top 1
			@wNum = Num,
			@wProcess_ID = Process_ID
	From	#Process_ID
	Where	Num > @wNum
	Order by Num

	If	@@RowCount = 0	Break

	--	추출한 프로세스 아이디의 모든 결재정보 Search

	Truncate	Table		#TmpAppList
	Insert	Into	#TmpAppList
					(EmpID,	DeptCd,	JikChaek,	Completed_Date)
			Select	EmpID,	DeptCd,	JikChaek,	Convert(varchar(23), Completed_Date, 121)
			From	#AppList
			Where	Process_ID = @wProcess_ID
			Order by Completed_Date

	Set	@wTmpNum = 0

--	select	*	from	#TmpAppList

	While	(1 = 1)
	Begin

		Select	Top 1
				@wTmpNum = Num,
				@wEmpID = EmpID,
				@wDeptCd = DeptCd,
				@wJikChaek = JikChaek,
				@wCompleted_Date = Convert(varchar(23), Completed_Date, 121)
		From	#TmpAppList
		Where	Num > @wTmpNum
		Order by Num

		If	@@RowCount = 0	Break

		If	@wTmpNum = 1
		Begin
			Insert	Into	#Result	(Process_ID,	EmpID,	DeptCd,	JikChaek,	Completed_Date)
				Values	(@wProcess_ID,	@wEmpID,	@wDeptCd,	@wJikChaek,	@wCompleted_Date)
		End
		Else
		Begin
			Update	#Result
			Set		EmpID = EmpID + ';' + @wEmpID,
					DeptCd = DeptCd + ';' + @wDeptCd,
					JikChaek = JikChaek + ';' + @wJikChaek,
					Completed_Date = Completed_Date + ';' + @wCompleted_Date
			Where	Process_ID = @wProcess_ID
		End

	End

End


Select	d.ApprovalSeq,
		d.Retry_Count,
		d.ModuleID,
		d.Process_ID,
		d.ApprovalName,
		d.ObjectID,
		r.Process_ID	as Process_Instance_OID,
		d.DocType,
		f.Doc_Name,
		r.EmpID,
		r.Completed_Date,
		r.DeptCd,
		r.JikChaek,
		d.ApprovalStatus,
/*
		--	개발서버
		Case	
			--LC_SEQURITY_DRAFT, 담보의뢰품의서
			When	f.Form_Id = 'YC4E7DFDB0B42493ABB2BDCACC76AD0F5'	Then
				(Select	U_Detail_String	From	Form_YC4E7DFDB0B42493ABB2BDCACC76AD0F5 f	Where	Process_ID = r.Process_ID)
			--LC_SUPPORT_DRAFT, 거래선지원품의서(판촉지원)
			When	f.Form_Id = 'Y91A030E57A8A46C091231D1FB5D01360'	Then
				(Select	U_Detail_String	From	Form_Y91A030E57A8A46C091231D1FB5D01360 f	Where	Process_ID = r.Process_ID)
			--LC_EQUIPCHANGE_REQUEST, 판매장비교체요청서
			When	f.Form_Id = 'Y88DAC42D65C34FCCAD6896819E08E234'	Then
				(Select	U_ADMISSIONQTY From	Form_Y88DAC42D65C34FCCAD6896819E08E234 f	Where	Process_ID = r.Process_ID)
			--LC_EQUIPINSTALL_REQUEST, 판매장비설치요청서
			When	f.Form_Id = 'YB4FE368CBBE34A16B9F92913D609C365'	Then
				(Select	U_ADMISSIONQTY	From	Form_YB4FE368CBBE34A16B9F92913D609C365 f	Where	Process_ID = r.Process_ID)
			--LC_ENVIRONCHECK_REPORT_FACTORY, 환경점검현황
			When	f.Form_Id = 'Y95A4ED74F0554359991C9CB6EF750DBB'	Then
				(Select	U_FAC_OPINION_IN_TEXTAREA	From	Form_Y95A4ED74F0554359991C9CB6EF750DBB f	Where	Process_ID = r.Process_ID)
			--LC_ENVIRONCHECK_REPORT_MAIN, 환경점검주보
			When	f.Form_Id = 'Y1A1AF1E3EDDA4173896470564D8A89E4'	Then
				(Select	U_FAC_OPINION_IN_TEXTAREA	From	Form_Y1A1AF1E3EDDA4173896470564D8A89E4 f	Where	Process_ID = r.Process_ID)
			--LC_FIRESAFECHECK_REPORT_FACTORY, 화재및안전사고점검일지
			When	f.Form_Id = 'Y12D07550C73345638CA6029ED7C7D8C8'	Then
				(Select	U_FAC_OPINION_IN_TEXTAREA	From	Form_Y12D07550C73345638CA6029ED7C7D8C8 f	Where	Process_ID = r.Process_ID)
			--LC_FIRESAFECHECK_REPORT_MAIN, 화재및안전사고점검주보
			When	f.Form_Id = 'YEEB9ACBCB3874133AD38F38A0322DC38'	Then
				(Select	U_FAC_OPINION_IN_TEXTAREA	From	Form_YEEB9ACBCB3874133AD38F38A0322DC38 f	Where	Process_ID = r.Process_ID)

			Else
				ISNULL(ADMISSION_QTY, '')
		End	as ADMISSION_QTY

*/
		--	운영서버
		Case	
			--LC_SEQURITY_DRAFT, 담보의뢰품의서
			When	f.Form_Id = 'YA8A03008E3B44079A4C41705CDA97979'	Then
				(Select	U_Detail_String	From	Form_YA8A03008E3B44079A4C41705CDA97979 f	Where	Process_ID = r.Process_ID)
			--LC_SUPPORT_DRAFT, 거래선지원품의서(판촉지원)
			When	f.Form_Id = 'YB9222DABFA484AC6AC97F2A23C649789'	Then
				(Select	U_Detail_String	From	Form_YB9222DABFA484AC6AC97F2A23C649789 f	Where	Process_ID = r.Process_ID)
			--LC_EQUIPCHANGE_REQUEST, 판매장비교체요청서
			When	f.Form_Id = 'YFEA425C4FB9346D0B81C119099FB5F35'	Then
				(Select	U_ADMISSIONQTY From	Form_YFEA425C4FB9346D0B81C119099FB5F35 f	Where	Process_ID = r.Process_ID)
			--LC_EQUIPINSTALL_REQUEST, 판매장비설치요청서
			When	f.Form_Id = 'Y5149C2A149D24EADA29D306082EBA5F3'	Then
				(Select	U_ADMISSIONQTY	From	Form_Y5149C2A149D24EADA29D306082EBA5F3 f	Where	Process_ID = r.Process_ID)
			--LC_ENVIRONCHECK_REPORT_FACTORY, 환경점검현황
			When	f.Form_Id = 'YB68D2E23A8F74970967B4D08912F0B9C'	Then
				(Select	U_FAC_OPINION_IN_TEXTAREA	From	Form_YB68D2E23A8F74970967B4D08912F0B9C f	Where	Process_ID = r.Process_ID)
			--LC_ENVIRONCHECK_REPORT_MAIN, 환경점검주보
			When	f.Form_Id = 'Y35CED4073A514D94875F61A63FBE3666'	Then
				(Select	U_FAC_OPINION_IN_TEXTAREA	From	Form_Y35CED4073A514D94875F61A63FBE3666 f	Where	Process_ID = r.Process_ID)
			--LC_FIRESAFECHECK_REPORT_FACTORY, 화재및안전사고점검일지
			When	f.Form_Id = 'Y8410F34EDFE44A6098AF6F9938C8F8C2'	Then
				(Select	U_FAC_OPINION_IN_TEXTAREA	From	Form_Y8410F34EDFE44A6098AF6F9938C8F8C2 f	Where	Process_ID = r.Process_ID)
			--LC_FIRESAFECHECK_REPORT_MAIN, 화재및안전사고점검주보
			When	f.Form_Id = 'Y462E36DD55F74F098C8A3D141BB0FCCF'	Then
				(Select	U_FAC_OPINION_IN_TEXTAREA	From	Form_Y462E36DD55F74F098C8A3D141BB0FCCF f	Where	Process_ID = r.Process_ID)

			Else
				ISNULL(ADMISSION_QTY, '')
		End	as ADMISSION_QTY

From	#Result r
		Join	eWFForm.dbo.WF_DBApproval d (NoLock)
			On	d.Process_id = r.Process_ID
			and	d.Retry_Time <= GetDate()
		Join	eWFForm.dbo.WF_Forms_Prop f (NoLock)
			On	f.Process_ID = r.Process_ID
		Join	(Select	r.Process_ID, Max(ApprovalStatus) ApprovalStatus
				From	#Result r
						Join	eWFForm.dbo.WF_DBApproval d (NoLock)
							On	d.Process_id = r.Process_id
							and	d.Retry_Time <= GetDate()
				Group by r.Process_ID) s
			On	s.Process_ID = r.Process_ID
			and	s.ApprovalStatus = d.ApprovalStatus
Order by r.Completed_Date, d.ApprovalStatus






GO
/****** Object:  StoredProcedure [dbo].[UP_SELECT_DB_APPROVAL_TEST]    Script Date: 2015-10-15 오후 1:30:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE	Procedure	[dbo].[UP_SELECT_DB_APPROVAL_TEST]

/*

select	count(distinct process_id)	from	EWFFORM.DBO.WF_DBAPPROVAL	where	process_id in
( 'Z2699E5CDCFD04A61A6042166FEDEE53B',
'Z119A2715EEB3405A929543F43F77A7B9')

select	*	from	emanage.dbo.vw_user	where	empid = '19009011'

select	top 10 *	from	ewf.dbo.process_instance	where	oid = 'Z1CCD237E825B4ABFB8E26B78AD0E328F'
select	top 10 *	from	ewf.dbo.work_item	where	process_instance_oid = 'Z39DFC15E4C8D4A1AB42674CBBBC8AB9F'	order by create_date

select	*
from	ewfform.dbo.wf_dbapproval
order by retry_time

*/

As

--	Drop	Table	#AppList
Create	Table	#AppList
(
	Process_ID		char(33),
	EmpID			char(8),
	DeptCd			varchar(20),
	JikChaek		varchar(10),
	Completed_Date	datetime
)

--	Drop	Table	#Process_ID
Create	Table	#Process_ID
(
	Num				int	identity(1, 1),
	Process_ID		char(33)
)

--	Drop	Table	#TmpAppList
Create	Table	#TmpAppList
(
	Num				int	identity(1, 1),
	EmpID			char(8),
	DeptCd			varchar(20),
	JikChaek		varchar(10),
	Completed_Date	varchar(23)
)

--	Drop	Table	#Result
Create	Table	#Result
(
	Process_ID		char(33),
	EmpID			varchar(500),
	DeptCd			varchar(500),
	JikChaek		varchar(500),
	Completed_Date	varchar(1000)
)

--	기안자의 데이터는 Process_Instance테이블을 이용해서 결재정보를 구한다.
Insert	Into	#AppList
				(Process_ID,	EmpID,	DeptCd,	JikChaek,	Completed_Date)
		Select	Distinct
				d.Process_ID, u.EmpID, u.DeptID, u.JikChaekID, p.Create_Date
		From	eWFForm.dbo.WF_DBApproval d (NoLock)
				Left Join	eWF.dbo.Work_Item w (NoLock)
					On	w.Process_Instance_Oid = d.Process_ID
					and	(w.[Name] like '기안%')
				Join	eWF.dbo.Process_Instance p (NoLock)
					On	p.Oid = d.Process_ID
					and	p.State <> '0'
				Join	eManage.dbo.VW_User u (NoLock)
					On	u.UserID = p.Creator_ID
					and	u.PositionOrder = 1
					and GetDate() Between u.StartDate and u.EndDate
		Where	w.Oid is Null
--	and	d.process_id in ( 'Z2699E5CDCFD04A61A6042166FEDEE53B', 'Z119A2715EEB3405A929543F43F77A7B9')

--	기안자 이후의 결재자, 개인합의자 정보는 Work_Item에서 구한다
Insert	Into	#AppList
				(Process_ID,	EmpID,	DeptCd,	JikChaek,	Completed_Date)
		Select	Distinct
				d.Process_ID, u.EmpID, u.DeptID, u.JikChaekID, w.Completed_Date
		From	eWFForm.dbo.WF_DBApproval d (NoLock)
				Join	eWF.dbo.Work_Item w (NoLock)
					On	w.Process_Instance_Oid = d.Process_ID
					and	w.[Name] in ('일반결재자', '개인합의')
					and w.Completed_Date is not null
				Join	eManage.dbo.VW_User u (NoLock)
					On	u.UserID = w.Participant_ID
					and	u.PositionOrder = 1
					and GetDate() Between u.StartDate and u.EndDate
		Where	d.Retry_Time <= GetDate()
--	and	d.process_id in ( 'Z2699E5CDCFD04A61A6042166FEDEE53B', 'Z119A2715EEB3405A929543F43F77A7B9')
		Order by w.Completed_Date

Declare	@wNum		int,
		@wTmpNum	int,
		@wProcess_ID	char(33),

		@wEmpID				varchar(8),
		@wDeptCd			varchar(20),
		@wJikChaek			varchar(10),
		@wCompleted_Date	varchar(23)

Set	@wNum = 0

Insert	Into	#Process_ID
				(Process_ID)
		Select	Distinct Process_ID
		From	#AppList

--	select	*	from	#AppList

While	(1 = 1)
Begin

	--	프로세스 아이디 추출.
	Select	Top 1
			@wNum = Num,
			@wProcess_ID = Process_ID
	From	#Process_ID
	Where	Num > @wNum
	Order by Num

	If	@@RowCount = 0	Break

	--	추출한 프로세스 아이디의 모든 결재정보 Search

	Truncate	Table		#TmpAppList
	Insert	Into	#TmpAppList
					(EmpID,	DeptCd,	JikChaek,	Completed_Date)
			Select	EmpID,	DeptCd,	JikChaek,	Convert(varchar(23), Completed_Date, 121)
			From	#AppList
			Where	Process_ID = @wProcess_ID
			Order by Completed_Date

	Set	@wTmpNum = 0

--	select	*	from	#TmpAppList

	While	(1 = 1)
	Begin

		Select	Top 1
				@wTmpNum = Num,
				@wEmpID = EmpID,
				@wDeptCd = DeptCd,
				@wJikChaek = JikChaek,
				@wCompleted_Date = Convert(varchar(23), Completed_Date, 121)
		From	#TmpAppList
		Where	Num > @wTmpNum
		Order by Num

		If	@@RowCount = 0	Break

		If	@wTmpNum = 1
		Begin
			Insert	Into	#Result	(Process_ID,	EmpID,	DeptCd,	JikChaek,	Completed_Date)
				Values	(@wProcess_ID,	@wEmpID,	@wDeptCd,	@wJikChaek,	@wCompleted_Date)
		End
		Else
		Begin
			Update	#Result
			Set		EmpID = EmpID + ';' + @wEmpID,
					DeptCd = DeptCd + ';' + @wDeptCd,
					JikChaek = JikChaek + ';' + @wJikChaek,
					Completed_Date = Completed_Date + ';' + @wCompleted_Date
			Where	Process_ID = @wProcess_ID
		End

	End

End

Select	d.ApprovalSeq,
		d.Retry_Count,
		d.ModuleID,
		d.Process_ID,
		d.ApprovalName,
		d.ObjectID,
		r.Process_ID	as Process_Instance_OID,
		Case
			When	Ltrim(Rtrim(IsNull(d.DocType, ''))) = ''	Then
				f.Form_EName
			Else
				d.DocType
		End	as DocType,
		p.Doc_Name,
		r.EmpID,
		r.Completed_Date,
		r.DeptCd,
		r.JikChaek,
		d.ApprovalStatus,
		--	개발서버
/*
		Case	
			--LC_SEQURITY_DRAFT, 담보의뢰품의서
			When	f.Form_Id = 'YC4E7DFDB0B42493ABB2BDCACC76AD0F5'	Then
				(Select	U_Detail_String	From	Form_YC4E7DFDB0B42493ABB2BDCACC76AD0F5 f	Where	Process_ID = r.Process_ID)
			--LC_SUPPORT_DRAFT, 거래선지원품의서(판촉지원)
			When	f.Form_Id = 'Y91A030E57A8A46C091231D1FB5D01360'	Then
				(Select	U_Detail_String	From	Form_Y91A030E57A8A46C091231D1FB5D01360 f	Where	Process_ID = r.Process_ID)
			--LC_EQUIPCHANGE_REQUEST, 판매장비교체요청서
			When	f.Form_Id = 'Y88DAC42D65C34FCCAD6896819E08E234'	Then
				(Select	U_ADMISSIONQTY From	Form_Y88DAC42D65C34FCCAD6896819E08E234 f	Where	Process_ID = r.Process_ID)
			--LC_EQUIPINSTALL_REQUEST, 판매장비설치요청서
			When	f.Form_Id = 'YB4FE368CBBE34A16B9F92913D609C365'	Then
				(Select	U_ADMISSIONQTY	From	Form_YB4FE368CBBE34A16B9F92913D609C365 f	Where	Process_ID = r.Process_ID)
			--LC_ENVIRONCHECK_REPORT_FACTORY, 환경점검현황
			When	f.Form_Id = 'Y95A4ED74F0554359991C9CB6EF750DBB'	Then
				(Select	U_FAC_OPINION_IN_TEXTAREA	From	Form_Y95A4ED74F0554359991C9CB6EF750DBB f	Where	Process_ID = r.Process_ID)
			--LC_ENVIRONCHECK_REPORT_MAIN, 환경점검주보
			When	f.Form_Id = 'Y1A1AF1E3EDDA4173896470564D8A89E4'	Then
				(Select	U_FAC_OPINION_IN_TEXTAREA	From	Form_Y1A1AF1E3EDDA4173896470564D8A89E4 f	Where	Process_ID = r.Process_ID)
			--LC_FIRESAFECHECK_REPORT_FACTORY, 화재및안전사고점검일지
			When	f.Form_Id = 'Y12D07550C73345638CA6029ED7C7D8C8'	Then
				(Select	U_FAC_OPINION_IN_TEXTAREA	From	Form_Y12D07550C73345638CA6029ED7C7D8C8 f	Where	Process_ID = r.Process_ID)
			--LC_FIRESAFECHECK_REPORT_MAIN, 화재및안전사고점검주보
			When	f.Form_Id = 'YEEB9ACBCB3874133AD38F38A0322DC38'	Then
				(Select	U_FAC_OPINION_IN_TEXTAREA	From	Form_YEEB9ACBCB3874133AD38F38A0322DC38 f	Where	Process_ID = r.Process_ID)
			--LC_CAR_MAINTENANCE, 차량정비발생현황
			When	f.Form_Id = 'YDE32B15C4C934C80A61A6E02ACE1B626'	Then
				(Select	U_MT_NUM	From	Form_YDE32B15C4C934C80A61A6E02ACE1B626 f	Where	Process_ID = r.Process_ID)

			Else
				ISNULL(ADMISSION_QTY, '')
		End	as ADMISSION_QTY

*/
		--	운영서버
		Case	
			--LC_SEQURITY_DRAFT, 담보의뢰품의서
			When	f.Form_Id = 'YA8A03008E3B44079A4C41705CDA97979'	Then
				(Select	U_Detail_String	From	Form_YA8A03008E3B44079A4C41705CDA97979 f	Where	Process_ID = r.Process_ID)
			--LC_SUPPORT_DRAFT, 거래선지원품의서(판촉지원)
			When	f.Form_Id = 'YB9222DABFA484AC6AC97F2A23C649789'	Then
				(Select	U_Detail_String	From	Form_YB9222DABFA484AC6AC97F2A23C649789 f	Where	Process_ID = r.Process_ID)
			--LC_EQUIPCHANGE_REQUEST, 판매장비교체요청서
			When	f.Form_Id = 'YFEA425C4FB9346D0B81C119099FB5F35'	Then
				(Select	U_ADMISSIONQTY From	Form_YFEA425C4FB9346D0B81C119099FB5F35 f	Where	Process_ID = r.Process_ID)
			--LC_EQUIPINSTALL_REQUEST, 판매장비설치요청서
			When	f.Form_Id = 'Y5149C2A149D24EADA29D306082EBA5F3'	Then
				(Select	U_ADMISSIONQTY	From	Form_Y5149C2A149D24EADA29D306082EBA5F3 f	Where	Process_ID = r.Process_ID)
			--LC_ENVIRONCHECK_REPORT_FACTORY, 환경점검현황
			When	f.Form_Id = 'YB68D2E23A8F74970967B4D08912F0B9C'	Then
				(Select	U_FAC_OPINION_IN_TEXTAREA	From	Form_YB68D2E23A8F74970967B4D08912F0B9C f	Where	Process_ID = r.Process_ID)
			--LC_ENVIRONCHECK_REPORT_MAIN, 환경점검주보
			When	f.Form_Id = 'Y35CED4073A514D94875F61A63FBE3666'	Then
				(Select	U_FAC_OPINION_IN_TEXTAREA	From	Form_Y35CED4073A514D94875F61A63FBE3666 f	Where	Process_ID = r.Process_ID)
			--LC_FIRESAFECHECK_REPORT_FACTORY, 화재및안전사고점검일지
			When	f.Form_Id = 'Y8410F34EDFE44A6098AF6F9938C8F8C2'	Then
				(Select	U_FAC_OPINION_IN_TEXTAREA	From	Form_Y8410F34EDFE44A6098AF6F9938C8F8C2 f	Where	Process_ID = r.Process_ID)
			--LC_FIRESAFECHECK_REPORT_MAIN, 화재및안전사고점검주보
			When	f.Form_Id = 'Y462E36DD55F74F098C8A3D141BB0FCCF'	Then
				(Select	U_FAC_OPINION_IN_TEXTAREA	From	Form_Y462E36DD55F74F098C8A3D141BB0FCCF f	Where	Process_ID = r.Process_ID)
			
			--LC_CAR_MAINTENANCE, 차량정비발생현황
			When	f.Form_Id = 'Y9A282068897043E08905CD42881773D5'	Then
				(Select	U_MT_NUM	From	Form_Y9A282068897043E08905CD42881773D5 f	Where	Process_ID = r.Process_ID)

			Else
				ISNULL(ADMISSION_QTY, '')
		End	as ADMISSION_QTY

From	#Result r
		Join	eWFForm.dbo.WF_DBApproval d (NoLock)
			On	d.Process_id = r.Process_ID
			and	d.Retry_Time <= GetDate()
		Join	eWFForm.dbo.WF_Forms_Prop p (NoLock)
			On	p.Process_ID = r.Process_ID
		Join	ewfform.dbo.wf_Forms f (NoLock)
			On	f.Form_ID = p.Form_ID
-- 		Join	(Select	r.Process_ID, Max(ApprovalStatus) ApprovalStatus
-- 				From	#Result r
-- 						Join	eWFForm.dbo.WF_DBApproval d (NoLock)
-- 							On	d.Process_id = r.Process_id
-- 							and	d.Retry_Time <= GetDate()
-- 				Group by r.Process_ID) s
-- 			On	s.Process_ID = r.Process_ID
-- 			and	s.ApprovalStatus = d.ApprovalStatus
Order by r.Completed_Date, d.ApprovalStatus



GO
/****** Object:  StoredProcedure [dbo].[UP_SELECT_DB_APPROVAL_TEST2]    Script Date: 2015-10-15 오후 1:30:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO








CREATE	Procedure	[dbo].[UP_SELECT_DB_APPROVAL_TEST2]

	@cpid char(33)

/*

select	count(distinct process_id)	from	EWFFORM.dbo.wf_dbapproval_log	where	process_id in
( 'Z2699E5CDCFD04A61A6042166FEDEE53B',
'Z119A2715EEB3405A929543F43F77A7B9')

select	*	from	emanage.dbo.vw_user	where	empid = '19009011'

select	top 10 *	from	ewf.dbo.process_instance	where	oid = 'Z1CCD237E825B4ABFB8E26B78AD0E328F'
select	top 10 *	from	ewf.dbo.work_item	where	process_instance_oid = 'Z39DFC15E4C8D4A1AB42674CBBBC8AB9F'	order by create_date

select	*
from	ewfform.dbo.wf_dbapproval_log
order by retry_time

exec [dbo].[UP_SELECT_DB_APPROVAL_TEST2] 'Z25B81FEF51E341E3B5285804708DC487'

*/

As

--	Drop	Table	#AppList
Create	Table	#AppList
(
	Process_ID		char(33),
	EmpID			char(8),
	DeptCd			varchar(20),
	JikChaek		varchar(10),
	Completed_Date	datetime
)

--	Drop	Table	#Process_ID
Create	Table	#Process_ID
(
	Num				int	identity(1, 1),
	Process_ID		char(33)
)

--	Drop	Table	#TmpAppList
Create	Table	#TmpAppList
(
	Num				int	identity(1, 1),
	EmpID			char(8),
	DeptCd			varchar(20),
	JikChaek		varchar(10),
	Completed_Date	varchar(23)
)

--	Drop	Table	#Result
Create	Table	#Result
(
	Process_ID		char(33),
	EmpID			varchar(500),
	DeptCd			varchar(500),
	JikChaek		varchar(500),
	Completed_Date	varchar(1000)
)

--	기안자의 데이터는 Process_Instance테이블을 이용해서 결재정보를 구한다.
Insert	Into	#AppList
				(Process_ID,	EmpID,	DeptCd,	JikChaek,	Completed_Date)
		Select	Distinct
				d.Process_ID, u.EmpID, u.DeptID, u.JikChaekID, p.Create_Date
		From	eWFForm.dbo.wf_dbapproval_log d (NoLock)
				Join	eWF.dbo.Process_Instance p (NoLock)
					On	p.Oid = d.Process_ID
					and	p.State <> '0'
				Join	eManage.dbo.VW_User u (NoLock)
					On	u.UserID = p.Creator_ID
					and	u.PositionOrder = 1
					and GetDate() Between u.StartDate and u.EndDate
--		Where	w.Oid is Null
--	and	d.process_id in ( 'Z2699E5CDCFD04A61A6042166FEDEE53B', 'Z119A2715EEB3405A929543F43F77A7B9')
		and d.process_id = @cpid

--	기안자 이후의 결재자, 개인합의자 정보는 Work_Item에서 구한다
Insert	Into	#AppList
				(Process_ID,	EmpID,	DeptCd,	JikChaek,	Completed_Date)
		Select	Distinct
				d.Process_ID, u.EmpID, u.DeptID, u.JikChaekID, w.Completed_Date
		From	eWFForm.dbo.wf_dbapproval_log d (NoLock)
				Join	eWF.dbo.Work_Item w (NoLock)
					On	w.Process_Instance_Oid = d.Process_ID
					and	w.[Name] in ('일반결재자', '개인합의')
					and w.Completed_Date is not null
				Join	eManage.dbo.VW_User u (NoLock)
					On	u.UserID = w.Participant_ID
					and	u.PositionOrder = 1
					and GetDate() Between u.StartDate and u.EndDate
		Where	d.Retry_Time <= GetDate()
--	and	d.process_id in ( 'Z2699E5CDCFD04A61A6042166FEDEE53B', 'Z119A2715EEB3405A929543F43F77A7B9')
		and d.process_id = @cpid
		Order by w.Completed_Date

Declare	@wNum		int,
		@wTmpNum	int,
		@wProcess_ID	char(33),

		@wEmpID				varchar(8),
		@wDeptCd			varchar(20),
		@wJikChaek			varchar(10),
		@wCompleted_Date	varchar(23)

Set	@wNum = 0

Insert	Into	#Process_ID
				(Process_ID)
		Select	Distinct Process_ID
		From	#AppList

--	select	*	from	#AppList

While	(1 = 1)
Begin

	--	프로세스 아이디 추출.
	Select	Top 1
			@wNum = Num,
			@wProcess_ID = Process_ID
	From	#Process_ID
	Where	Num > @wNum
	Order by Num

	If	@@RowCount = 0	Break

	--	추출한 프로세스 아이디의 모든 결재정보 Search

	Truncate	Table		#TmpAppList
	Insert	Into	#TmpAppList
					(EmpID,	DeptCd,	JikChaek,	Completed_Date)
			Select	EmpID,	DeptCd,	JikChaek,	Convert(varchar(23), Completed_Date, 121)
			From	#AppList
			Where	Process_ID = @wProcess_ID
			Order by Completed_Date

	Set	@wTmpNum = 0

--	select	*	from	#TmpAppList

	While	(1 = 1)
	Begin

		Select	Top 1
				@wTmpNum = Num,
				@wEmpID = EmpID,
				@wDeptCd = DeptCd,
				@wJikChaek = JikChaek,
				@wCompleted_Date = Convert(varchar(23), Completed_Date, 121)
		From	#TmpAppList
		Where	Num > @wTmpNum
		Order by Num

		If	@@RowCount = 0	Break

		If	@wTmpNum = 1
		Begin
			Insert	Into	#Result	(Process_ID,	EmpID,	DeptCd,	JikChaek,	Completed_Date)
				Values	(@wProcess_ID,	@wEmpID,	@wDeptCd,	@wJikChaek,	@wCompleted_Date)
		End
		Else
		Begin
			Update	#Result
			Set		EmpID = EmpID + ';' + @wEmpID,
					DeptCd = DeptCd + ';' + @wDeptCd,
					JikChaek = JikChaek + ';' + @wJikChaek,
					Completed_Date = Completed_Date + ';' + @wCompleted_Date
			Where	Process_ID = @wProcess_ID
		End

	End

End

Select	d.ApprovalSeq,
-- 		d.Retry_Count,
-- 		d.ModuleID,
-- 		d.Process_ID,
-- 		d.ApprovalName,
-- 		d.ObjectID,
-- 		r.Process_ID	as Process_Instance_OID,
-- 		Case
-- 			When	Ltrim(Rtrim(IsNull(d.DocType, ''))) = ''	Then
-- 				f.Form_EName
-- 			Else
-- 				d.DocType
-- 		End	as DocType,
-- 		p.Doc_Name,
-- 		r.EmpID,
-- 		r.Completed_Date,
-- 		r.DeptCd,
-- 		r.JikChaek,
-- 		d.ApprovalStatus,
		--	개발서버
/*
		Case	
			--LC_SEQURITY_DRAFT, 담보의뢰품의서
			When	f.Form_Id = 'YC4E7DFDB0B42493ABB2BDCACC76AD0F5'	Then
				(Select	U_Detail_String	From	Form_YC4E7DFDB0B42493ABB2BDCACC76AD0F5 f	Where	Process_ID = r.Process_ID)
			--LC_SUPPORT_DRAFT, 거래선지원품의서(판촉지원)
			When	f.Form_Id = 'Y91A030E57A8A46C091231D1FB5D01360'	Then
				(Select	U_Detail_String	From	Form_Y91A030E57A8A46C091231D1FB5D01360 f	Where	Process_ID = r.Process_ID)
			--LC_EQUIPCHANGE_REQUEST, 판매장비교체요청서
			When	f.Form_Id = 'Y88DAC42D65C34FCCAD6896819E08E234'	Then
				(Select	U_ADMISSIONQTY From	Form_Y88DAC42D65C34FCCAD6896819E08E234 f	Where	Process_ID = r.Process_ID)
			--LC_EQUIPINSTALL_REQUEST, 판매장비설치요청서
			When	f.Form_Id = 'YB4FE368CBBE34A16B9F92913D609C365'	Then
				(Select	U_ADMISSIONQTY	From	Form_YB4FE368CBBE34A16B9F92913D609C365 f	Where	Process_ID = r.Process_ID)
			--LC_ENVIRONCHECK_REPORT_FACTORY, 환경점검현황
			When	f.Form_Id = 'Y95A4ED74F0554359991C9CB6EF750DBB'	Then
				(Select	U_FAC_OPINION_IN_TEXTAREA	From	Form_Y95A4ED74F0554359991C9CB6EF750DBB f	Where	Process_ID = r.Process_ID)
			--LC_ENVIRONCHECK_REPORT_MAIN, 환경점검주보
			When	f.Form_Id = 'Y1A1AF1E3EDDA4173896470564D8A89E4'	Then
				(Select	U_FAC_OPINION_IN_TEXTAREA	From	Form_Y1A1AF1E3EDDA4173896470564D8A89E4 f	Where	Process_ID = r.Process_ID)
			--LC_FIRESAFECHECK_REPORT_FACTORY, 화재및안전사고점검일지
			When	f.Form_Id = 'Y12D07550C73345638CA6029ED7C7D8C8'	Then
				(Select	U_FAC_OPINION_IN_TEXTAREA	From	Form_Y12D07550C73345638CA6029ED7C7D8C8 f	Where	Process_ID = r.Process_ID)
			--LC_FIRESAFECHECK_REPORT_MAIN, 화재및안전사고점검주보
			When	f.Form_Id = 'YEEB9ACBCB3874133AD38F38A0322DC38'	Then
				(Select	U_FAC_OPINION_IN_TEXTAREA	From	Form_YEEB9ACBCB3874133AD38F38A0322DC38 f	Where	Process_ID = r.Process_ID)
			--LC_CAR_MAINTENANCE, 차량정비발생현황
			When	f.Form_Id = 'YDE32B15C4C934C80A61A6E02ACE1B626'	Then
				(Select	U_MT_NUM	From	Form_YDE32B15C4C934C80A61A6E02ACE1B626 f	Where	Process_ID = r.Process_ID)
			--LC_ORDER_REQUEST, 구매의뢰서
			When	f.Form_Id = 'Y8D4A994E63054A5EB14621BDD3A4483E'	Then
				(Select	U_RESERVED3	From	Form_Y8D4A994E63054A5EB14621BDD3A4483E f	Where	Process_ID = r.Process_ID)
			--LC_RESOLUTION_REQUEST, 구매결의서
			When	f.Form_Id = 'Y3AAADA3BB0CE45D58106CDB1CA308EE1'	Then
				(Select	U_RESERVED3	From	Form_Y3AAADA3BB0CE45D58106CDB1CA308EE1 f	Where	Process_ID = r.Process_ID)


			Else
				ISNULL(ADMISSION_QTY, '')
		End	as ADMISSION_QTY

*/
		--	운영서버
		Case	
			--LC_SEQURITY_DRAFT, 담보의뢰품의서
			When	f.Form_Id = 'YA8A03008E3B44079A4C41705CDA97979'	Then
				(Select	U_Detail_String	From	Form_YA8A03008E3B44079A4C41705CDA97979 f	Where	Process_ID = r.Process_ID)
			--LC_SUPPORT_DRAFT, 거래선지원품의서(판촉지원)
			When	f.Form_Id = 'YB9222DABFA484AC6AC97F2A23C649789'	Then
				(Select	U_Detail_String	From	Form_YB9222DABFA484AC6AC97F2A23C649789 f	Where	Process_ID = r.Process_ID)
			--LC_EQUIPCHANGE_REQUEST, 판매장비교체요청서
			When	f.Form_Id = 'YFEA425C4FB9346D0B81C119099FB5F35'	Then
				(Select	U_ADMISSIONQTY From	Form_YFEA425C4FB9346D0B81C119099FB5F35 f	Where	Process_ID = r.Process_ID)
			--LC_EQUIPINSTALL_REQUEST, 판매장비설치요청서
			When	f.Form_Id = 'Y5149C2A149D24EADA29D306082EBA5F3'	Then
				(Select	U_ADMISSIONQTY	From	Form_Y5149C2A149D24EADA29D306082EBA5F3 f	Where	Process_ID = r.Process_ID)
			--LC_ENVIRONCHECK_REPORT_FACTORY, 환경점검현황
			When	f.Form_Id = 'YB68D2E23A8F74970967B4D08912F0B9C'	Then
				(Select	U_FAC_OPINION_IN_TEXTAREA	From	Form_YB68D2E23A8F74970967B4D08912F0B9C f	Where	Process_ID = r.Process_ID)
			--LC_ENVIRONCHECK_REPORT_MAIN, 환경점검주보
			When	f.Form_Id = 'Y35CED4073A514D94875F61A63FBE3666'	Then
				(Select	U_FAC_OPINION_IN_TEXTAREA	From	Form_Y35CED4073A514D94875F61A63FBE3666 f	Where	Process_ID = r.Process_ID)
			--LC_FIRESAFECHECK_REPORT_FACTORY, 화재및안전사고점검일지
			When	f.Form_Id = 'Y8410F34EDFE44A6098AF6F9938C8F8C2'	Then
				(Select	U_FAC_OPINION_IN_TEXTAREA	From	Form_Y8410F34EDFE44A6098AF6F9938C8F8C2 f	Where	Process_ID = r.Process_ID)			--LC_FIRESAFECHECK_REPORT_MAIN, 화재및안전사고점검주보
			When	f.Form_Id = 'Y462E36DD55F74F098C8A3D141BB0FCCF'	Then
				(Select	U_FAC_OPINION_IN_TEXTAREA	From	Form_Y462E36DD55F74F098C8A3D141BB0FCCF f	Where	Process_ID = r.Process_ID)
			--LC_CAR_MAINTENANCE, 차량정비발생현황
			When	f.Form_Id = 'Y9A282068897043E08905CD42881773D5'	Then
				(Select	U_MT_NUM	From	Form_Y9A282068897043E08905CD42881773D5 f	Where	Process_ID = r.Process_ID)
			--LC_ORDER_REQUEST, 구매의뢰서
			When	f.Form_Id = 'Y8D4A994E63054A5EB14621BDD3A4483E'	Then
				(Select	U_RESERVED3	From	Form_Y8D4A994E63054A5EB14621BDD3A4483E f	Where	Process_ID = r.Process_ID)
			--LC_RESOLUTION_REQUEST, 구매결의서
			When	f.Form_Id = 'Y3AAADA3BB0CE45D58106CDB1CA308EE1'	Then
				(Select	U_RESERVED3	From	Form_Y3AAADA3BB0CE45D58106CDB1CA308EE1 f	Where	Process_ID = r.Process_ID)
			
			Else
				ISNULL(ADMISSION_QTY, '')
		End	as ADMISSION_QTY

From	#Result r
		Join	eWFForm.dbo.wf_dbapproval_log d (NoLock)
			On	d.Process_id = r.Process_ID
			and	d.Retry_Time <= GetDate()
		Join	eWFForm.dbo.WF_Forms_Prop p (NoLock)
			On	p.Process_ID = r.Process_ID
		Join	ewfform.dbo.wf_Forms f (NoLock)
			On	f.Form_ID = p.Form_ID
-- 		Join	(Select	r.Process_ID, Max(ApprovalStatus) ApprovalStatus
-- 				From	#Result r
-- 						Join	eWFForm.dbo.wf_dbapproval_log d (NoLock)
-- 							On	d.Process_id = r.Process_id
-- 							and	d.Retry_Time <= GetDate()
-- 				Group by r.Process_ID) s
-- 			On	s.Process_ID = r.Process_ID
-- 			and	s.ApprovalStatus = d.ApprovalStatus
Order by r.Completed_Date, d.ApprovalStatus









GO
/****** Object:  StoredProcedure [dbo].[UP_SELECT_DEPT_DOC_FOLDER]    Script Date: 2015-10-15 오후 1:30:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
CREATE Procedure [dbo].[UP_SELECT_DEPT_DOC_FOLDER]
	/* Param List */
AS
	SELECT		DOC_FOLDER_ID,
				DOC_FOLDER_NAME 				
				
	FROM		dbo.Wf_DOC_FOLDER
	
	WHERE		APR_FOLDER_TYPE = 'D'
	
	ORDER BY	SortKey asc
	
	
RETURN

GO
/****** Object:  StoredProcedure [dbo].[UP_SELECT_DOCFOLDERAUTH]    Script Date: 2015-10-15 오후 1:30:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
----------------------------------------------------------------------
----------------------------------------------------------------------
-- 작성자: 신상훈
-- 작성일: 2004.05.25
-- 수정일: 2004.05.25
-- 설  명: 문서함 권한정보 반환
-- 테스트: EXEC  UP_SELECT_DOCFOLDERAUTH 'AP'
----------------------------------------------------------------------
-- 수정일 : 
-- 수정자 : 
-- 수정내용 : 
----------------------------------------------------------------------
----------------------------------------------------------------------
CREATE PROC [dbo].[UP_SELECT_DOCFOLDERAUTH]
@vcAprFolderId	varchar(4)
as
SELECT DOC_FOLDER_TYPE 
FROM EWFFORM.DBO.WF_DOC_FOLDER 
WHERE APR_FOLDER_ID = @vcAprFolderId

GO
/****** Object:  StoredProcedure [dbo].[UP_SELECT_FORM_IDENTITY_INFO]    Script Date: 2015-10-15 오후 1:30:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UP_SELECT_FORM_IDENTITY_INFO]
(
	@VCWORKITEM_OID		VARCHAR(50)
)
-------------------------------------------------------------------------------------
-- 작성자: 임병태
-- 작성일: 2004.04.21
-- 수정일: 2004.04.21
-- 설명 : 결재양식 저장ID 번호 가져오기
-------------------------------------------------------------------------------------
AS
	SELECT B.PROCESS_ID, B.FORM_ID
	  FROM eWF.dbo.WORK_ITEM A (NOLOCK)  , eWFFORM.dbo.WF_FORMS_PROP B (NOLOCK) 
 	 WHERE A.OID = @VCWORKITEM_OID
 	   AND A.PROCESS_INSTANCE_OID = B.PROCESS_ID

GO
/****** Object:  StoredProcedure [dbo].[UP_SELECT_FORM_SCHEMA_INFO]    Script Date: 2015-10-15 오후 1:30:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*******
개	체	: dbo.UP_SELECT_FORM_SCHEMA_INFO
작성자	: 강민성
작성일	: 2008.06.04
수정일	: 2008.06.04
설	명	: Form Schema 정보 Search
*******/
--exec UP_SELECT_FORM_SCHEMA_INFO 'Y554019E6C220421B8E055DA484EB5305'

CREATE	PROCEDURE	[dbo].[UP_SELECT_FORM_SCHEMA_INFO]
		@Form_ID	VARCHAR(33) -- 폼 양식 ID

AS

Set Transaction isolation level read uncommitted
set	nocount on

	-- 1. 양식 폼 헤더 정보
	IF	(SELECT	Form_EName	FROM	EWFFORM.DBO.WF_FORMS	WHERE	Form_ID = @Form_ID) = 'LC_POST_TRAVELINGEXPENSES'
	BEGIN
	
		DECLARE	@tblDeptAddr	TABLE
		(
			Num			INT	IDENTITY(1, 1),
			DeptCD		CHAR(5),
			DeptNM		VARCHAR(30),
			DeptAddr	VARCHAR(100)
		)
		INSERT	INTO	@tblDeptAddr
					(DeptCD,	DeptNM,	DeptAddr)
			SELECT	DeptCD, DeptNM, LTRIM(RTRIM(TaxAddrOne)) + ' ' + LTRIM(RTRIM(TaxAddrTwo))
			FROM	[ERPSQL1\inst1].LeAcc.dbo.TDADept d
					JOIN	[ERPSQL1\inst1].LeAcc.dbo.TABTaxNo t
						ON	t.TaxNO = d.TaxNO
			WHERE	d.UseType = '0'
			ORDER BY d.DeptNM


		DECLARE	@wNum		INT,
				@wDeptCD	VARCHAR(8000),
				@wDeptNM	VARCHAR(8000),
				@wDeptAddr2	VARCHAR(8000),
				@wDeptAddr1	VARCHAR(8000),
				@wDeptAddr	VARCHAR(8000)

		SELECT	@wNum = 0,
				@wDeptCD	= '',
				@wDeptNM	= '',
				@wDeptAddr	= ''

		WHILE	(1 = 1)
		BEGIN
		
			SELECT	TOP 1
					@wNum		= Num,
					@wDeptCD	= @wDeptCD + DeptCD,
					@wDeptNM	= @wDeptNM + DeptNM,
					@wDeptAddr	= @wDeptAddr + DeptAddr
			FROM	@tblDeptAddr
			WHERE	Num > @wNum
			ORDER BY NUM

			IF	@@ROWCOUNT = 0	BREAK

			SELECT	@wDeptCD	= @wDeptCD + '|',
					@wDeptNM	= @wDeptNM + '|',
					@wDeptAddr	= @wDeptAddr + '|'

			IF	@wNum = 200
			BEGIN
				Set	@wDeptAddr2 = @wDeptAddr
				Set	@wDeptAddr = ''
			END
			ELSE IF	@wNum = 400
			BEGIN
				Set	@wDeptAddr1 = @wDeptAddr
				Set	@wDeptAddr = ''
			END

		END


		SELECT	*,
				@wDeptCD	AS DeptCD,
				@wDeptNM	AS DeptNM,
				@wDeptAddr2	AS DeptAddr2,
				@wDeptAddr1	AS DeptAddr1,
				@wDeptAddr	AS DeptAddr
		FROM	dbo.WF_FORMS (NOLOCK)
		WHERE	FORM_ID= @Form_ID

	END
	ELSE

		SELECT	* 
		FROM	dbo.WF_FORMS (NOLOCK)
		WHERE	FORM_ID = @Form_ID


	-- 2. 양식 폼의 스키마 정보
	SELECT	*
	FROM	dbo.WF_FORM_SCHEMA (NOLOCK)
	WHERE	FORM_ID = @Form_ID


	-- 3. 양식폼의 필드정보
	SELECT	*
	FROM	dbo.WF_FORM_INFORM (NOLOCK)
	WHERE	FORM_ID = @Form_ID





GO
/****** Object:  StoredProcedure [dbo].[UP_SELECT_FORM_SOTRAGE_APRLINE]    Script Date: 2015-10-15 오후 1:30:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UP_SELECT_FORM_SOTRAGE_APRLINE] 
(
	@PROCESS_ID		VARCHAR(50)
) AS
-------------------------------------------------------------------------------------
-- 작성자: 임병태
-- 작성일: 2004.04.12
-- 수정일: 2004.04.12
-- 설명 : 임시저장된 결재문서 양식 결재선을 가져온다.
-------------------------------------------------------------------------------------
	SELECT SIGN_CONTEXT
	  FROM dbo.WF_FORM_STORAGE(NOLOCK)
	 WHERE PROCESS_ID = @PROCESS_ID
	 

GO
/****** Object:  StoredProcedure [dbo].[UP_SELECT_FORM_STORAGE]    Script Date: 2015-10-15 오후 1:30:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO






CREATE      PROC [dbo].[UP_SELECT_FORM_STORAGE]
    @intTotalCount        int OUTPUT,
    @intPageNum        int,
    @intNumPerPage        int,
    @vcFormId        Varchar(33),
    @vcSearchColumn    varchar(20),
    @vcSearchText        varchar(50),
    @cStartDate		char(10),
    @cEndDate		char(10),
    @intSortColumn		int,    
    @vcSortOrder			varchar(4)
AS

declare    
    @vcQuery        varchar(8000),
    @vcCountQuery        Nvarchar(4000),
    @vcSortColumnName		varchar(20)	-- Sorting 컬럼 이름   

----------------------------------------------------------------------
----------------------------------------------------------------------
-- 작성자: 닷넷소프트 김문식
-- 작성일: 2004.03.23
-- 수정일: 2004.03.23
-- 설   명: 저장된 임시 결재문서 목록
-- 테스트 :
-- @vcFormId : Y819EC4E5CCF14ABAB9325B87A797D265
-- EXEC dbo.UP_SELECT_FORM_STORAGE 0,1,10, 'Y819EC4E5CCF14ABAB9325B87A797D265','',''
----------------------------------------------------------------------
-- 수정일 : 2004.05.15
-- 수정자 : LDCC 신상훈
-- 수정내용 : 검색부분 수정 및 소팅 기능 추가
-- 테스트 :
-- @vcFormId = Y819EC4E5CCF14ABAB9325B87A797D265
/*

EXEC dbo.UP_SELECT_FORM_STORAGE 0,1,100, 'Y819EC4E5CCF14ABAB9325B87A797D265','','','','','','ASC'

*/
----------------------------------------------------------------------
----------------------------------------------------------------------

--총 게시물 수
SET @vcCountQuery = N'SELECT @nCnt = COUNT(*) 
	FROM WF_FORM_STORAGE AS A (NOLOCK)  JOIN 
	eManage.dbo.vw_user AS  B (NOLOCK)
    ON A.UserID=B.UserID 
    WHERE  FORM_ID='''+@vcFormID+N''''


--검색시작일자
if(@cStartDate != '')

	SET @vcCountQuery = @vcCountQuery + N' AND A.CREATE_DATE >= CAST('''+@cStartDate+N''' AS smalldatetime) '
--검색종료일자
if(@cEndDate != '')

	SET @vcCountQuery = @vcCountQuery + N' AND A.CREATE_DATE <= CAST('''+@cEndDate+N''' AS smalldatetime) '
--검색항목이 있을 경우
if(@vcSearchColumn != '')

	SET @vcCountQuery = @vcCountQuery +N' AND '+@vcSearchColumn+N' like ''%'+@vcSearchText+N'%''' 



EXEC sp_executesql @vcCountQuery, N'@nCnt INT OUTPUT', @nCNT = @intTotalCount OUTPUT
-------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------



-------------------------------------------------------------------------------------------------
-- 내용 : Sorting 정보 설정
-- 작성일 : 2004.05.15
-- 작성자 : LDCC 신상훈
-------------------------------------------------------------------------------------------------
SET @vcSortColumnName = 
	(
	CASE @intSortColumn
		WHEN 1
				THEN	'SUBJECT'
		WHEN 2
				THEN	'USERNAME'
		WHEN 3
				THEN	'DEPTNAME'
		WHEN 4
				THEN	'CREATE_DATE'		
		ELSE
					'CREATE_DATE'
	END
	)	

IF @vcSortOrder = ''
begin
	SET @vcSortOrder = 'DESC'
end

-------------------------------------------------------------------------------------------------
-- 내용 : 제목,사용자명,부서명,저장일, 삭제일, 프로세스 ID, 폼ID, 사용자ID 
-------------------------------------------------------------------------------------------------

SET @vcQuery = 'SELECT  
	C.Subject, 
	C.USERNAME, 
	C.DEPTNAMe, 
	C.CREATE_DATE, 	
	C.Process_ID, 
	C.Form_ID,
	C.UserID   
	
	FROM  ('

--페이징을 위해 필요한 행+삭제할 행을 가져온다.
SET @vcQuery = @vcQuery +' SELECT TOP '+CAST(@intPageNum * @intNumPerPage AS varchar)+' 
	Process_ID,
	Form_ID, 
	Subject,
	B.UserName, 
	B.DeptName, 
	CREATE_DATE,
	B.UserID	

	FROM dbo.WF_FORM_STORAGE  AS A (NOLOCK)
	JOIN 
	eManage.dbo.vw_user AS B (NOLOCK)
	ON A.UserID=B.UserID  AND A.FORM_ID='''+@vcFormID+''''

--검색 시작일
if(@cStartDate != '')

	SET @vcQuery = @vcQuery + ' AND A.CREATE_DATE >= CAST('''+@cStartDate+ ''' AS smalldatetime) '
--검색 종료일
if(@cEndDate != '')
	SET @vcQuery = @vcQuery + ' AND A.CREATE_DATE <= CAST('''+@cEndDate+''' AS smalldatetime) '

--검색컬럼
if(@vcSearchColumn != '')
	SET @vcQuery = @vcQuery +' AND '+@vcSearchColumn+N' like ''%'+@vcSearchText+'%''' 

--Sorting Column + Sorting Order
	SET @vcQuery = @vcQuery +' ORDER BY  ' + @vcSortColumnName + '		' + @vcSortOrder


--페이징을 위해 삭제할 행을 가져온다.
SET @vcQuery = @vcQuery +' ) AS C  

 LEFT OUTER JOIN   

	 (SELECT TOP '+CAST((@intPageNum -1) * @intNumPerPage AS varchar)+' 
	 Process_ID,
	 Form_ID, 
	 Subject,
	 B.UserName, 
	 B.DeptName, 
	 CREATE_DATE,
	 B.UserID

	FROM dbo.WF_FORM_STORAGE AS A (NOLOCK)
	JOIN 
	eManage.dbo.vw_user AS B (NOLOCK)
	ON A.UserID=B.UserID  AND A.FORM_ID='''+@vcFormID+''''

if(@cStartDate != '')

	SET @vcQuery = @vcQuery + ' AND A.CREATE_DATE >= CAST('''+@cStartDate+ ''' AS smalldatetime) '

if(@cEndDate != '')

	SET @vcQuery = @vcQuery + ' AND A.CREATE_DATE <= CAST('''+@cEndDate+''' AS smalldatetime) '

if(@vcSearchColumn != '')

	SET @vcQuery = @vcQuery +' AND '+@vcSearchColumn+N' like ''%'+@vcSearchText+'%''' 

--Sorting Column + Sorting Order
	SET @vcQuery = @vcQuery +' ORDER BY  ' + @vcSortColumnName + '		' + @vcSortOrder

SET @vcQuery = @vcQuery +' ) AS D

    ON C.Process_ID=D.Process_ID AND C.FORM_ID=D.FORM_ID

WHERE  D.Process_ID is NULL AND D.Form_ID IS NULL '


exec (@vcQuery)








GO
/****** Object:  StoredProcedure [dbo].[UP_SELECT_FORM_STORAGE_DATA]    Script Date: 2015-10-15 오후 1:30:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[UP_SELECT_FORM_STORAGE_DATA]
(
	@PROCESS_ID		VARCHAR(50)	-- 프로세스 ID
)
-------------------------------------------------------------------------------------
-- 작성자: 임병태
-- 작성일: 2004.03.17
-- 수정일: 2004.03.17
-- 설명 : 결재폼 양식 데이터 정보를 가져온다
-------------------------------------------------------------------------------------
AS
	DECLARE
		@vcFORM_ID	VARCHAR(50),		-- 결재 양식 폼 ID
		@nvcDY_SQL	NVARCHAR(400)		-- 동적 양식 폼 조회 ID
	-- 프로세스 ID로 결재양식 폼 ID 가져오기
	SET @vcFORM_ID = (
  				SELECT FORM_ID
				FROM dbo.WF_FORM_STORAGE (NOLOCK)
				WHERE PROCESS_ID = @PROCESS_ID )
	
	-- 1. 양식 폼 헤더 정보
	SELECT * 
 	  FROM dbo.WF_FORMS (NOLOCK)
	 WHERE FORM_ID= @vcFORM_ID
	-- 2. 양식 폼의 스키마 정보
	SELECT  *
	  FROM dbo.WF_FORM_SCHEMA (NOLOCK)
	 WHERE FORM_ID= @vcFORM_ID
	 
	-- 3. 양식폼의 필드정보
	SELECT *
	  FROM dbo.WF_FORM_INFORM (NOLOCK)
	 WHERE FORM_ID= @vcFORM_ID
	
	-- 4. 결재양식 폼에서 프로세스 ID에 해당하는 폼 데이터를 가져오는 SQL를 생성한다.
	SET @nvcDY_SQL = N'SELECT * FROM dbo.FORM_' + @vcFORM_ID + ' (NOLOCK) WHERE PROCESS_ID=@PROCESS_ID'
	EXEC SP_EXECUTESQL  @nvcDY_SQL, N'@PROCESS_ID VARCHAR(50)', @PROCESS_ID

GO
/****** Object:  StoredProcedure [dbo].[UP_SELECT_FORM_STORAGE_test]    Script Date: 2015-10-15 오후 1:30:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[UP_SELECT_FORM_STORAGE_test]
    @iTotalCount        int OUTPUT,
    @iPageNum        int = null,
    @iNumPerPage        tinyint = null,
    @vcFormId        Varchar(33),
    @vcSearchColumn    varchar(20) = null,
    @vcSearchText        varchar(50) = null,
    @cStartDate		char(10) = null,
    @cEndDate		char(10) = null
AS
declare    
    @vcQuery        varchar(8000),
    @vcCountQuery        Nvarchar(4000)
----------------------------------------------------------------------
----------------------------------------------------------------------
-- 작성자: 닷넷소프트 김문식
-- 작성일: 2004.03.23
-- 수정일: 2004.03.23
-- 설   명: 저장된 임시 결재문서 목록
-- 테스트 :
-- @vcFormId : YA8F6C070F99844E5BEEBB8307537BC4
-- EXEC dbo.UP_SELECT_FORM_STORAGE 0,1,3, 'YA8F6C070F99844E5BEEBB8307537BC4','',''
----------------------------------------------------------------------
-- 수정일 : 
-- 수정자 : 
-- 수정내용 : 
----------------------------------------------------------------------
----------------------------------------------------------------------
--총 게시물 수
SET @vcCountQuery = N'SELECT @nCnt = COUNT(*) FROM WF_FORM_STORAGE WHERE  FORM_ID='''+@vcFormID+N''''
if(@cStartDate != '')
SET @vcCountQuery = @vcCountQuery + N' AND CREATE_DATE >= CAST('''+@cStartDate+N''' AS smalldatetime) '
if(@cEndDate != '')
SET @vcCountQuery = @vcCountQuery + N' AND CREATE_DATE <= CAST('''+@cEndDate+N''' AS smalldatetime) '
if(@vcSearchColumn != '')
SET @vcCountQuery = @vcCountQuery +N' AND '+@vcSearchColumn+N' like ''%'+@vcSearchText+N'%''' 
EXEC sp_executesql @vcCountQuery, N'@nCnt INT OUTPUT', @nCNT = @iTotalCount OUTPUT
SET @vcQuery = 'SELECT  C.Subject, C.USERNAME, C.DEPTNAMe, C.CREATE_DATE, C.DELETE_DATE   
 FROM  (
SELECT TOP '+CAST(@iPageNum * @iNumPerPage AS varchar)+' Process_ID,Form_ID, Subject,B.UserName, B.DeptName, CREATE_DATE, DELETE_DATE 
FROM dbo.WF_FORM_STORAGE AS A
    JOIN 
    eManage.dbo.vw_user AS B
    ON A.UserID=B.UserID  AND A.FORM_ID='''+@vcFormID+''''
if(@cStartDate != '')
SET @vcQuery = @vcQuery + ' AND A.CREATE_DATE >= CAST('''+@cStartDate+ ''' AS smalldatetime) '
if(@cEndDate != '')
SET @vcQuery = @vcQuery + ' AND A.CREATE_DATE <= CAST('''+@cEndDate+''' AS smalldatetime) '
if(@vcSearchColumn != '')
SET @vcQuery = @vcQuery +' AND A.'+@vcSearchColumn+N' like ''%'+@vcSearchText+'%''' 
SET @vcQuery = @vcQuery +' ) AS C  
   LEFT OUTER JOIN   
 (SELECT TOP '+CAST((@iPageNum -1) * @iNumPerPage AS varchar)+' Process_ID,Form_ID, Subject,B.UserName, B.DeptName, CREATE_DATE, DELETE_DATE 
FROM dbo.WF_FORM_STORAGE AS A
    JOIN 
    eManage.dbo.vw_user AS B
    ON
    A.UserID=B.UserID  AND A.FORM_ID='''+@vcFormID+''''
if(@cStartDate != '')
SET @vcQuery = @vcQuery + ' AND A.CREATE_DATE >= CAST('''+@cStartDate+ ''' AS smalldatetime) '
if(@cEndDate != '')
SET @vcQuery = @vcQuery + ' AND A.CREATE_DATE <= CAST('''+@cEndDate+''' AS smalldatetime) '
if(@vcSearchColumn != '')
SET @vcQuery = @vcQuery +' AND A.'+@vcSearchColumn+N' like ''%'+@vcSearchText+'%''' 
SET @vcQuery = @vcQuery +'
) AS D
    ON C.Process_ID=D.Process_ID AND C.FORM_ID=D.FORM_ID
WHERE  D.Process_ID is NULL AND D.Process_ID IS NULL '
exec (@vcQuery)

GO
/****** Object:  StoredProcedure [dbo].[UP_SELECT_FORM_USER_INFO]    Script Date: 2015-10-15 오후 1:30:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*******
개	체	: dbo.UP_SELECT_FORM_USER_INFO
작성자	: 강민성
작성일	: 2008.06.04
수정일	: 2008.06.04
설	명	: 결재폼 양식명으로 결재폼 ID를 가져온다.

exec dbo.UP_SELECT_FORM_USER_INFO '20070870'

select	*
from	emanage.dbo.tb_user
where	empid = '20070870'

*******/

CREATE	PROCEDURE	[dbo].[UP_SELECT_FORM_USER_INFO]	
		@Emp_ID	varchar(50)
AS

Set Transaction isolation level read uncommitted
set	nocount on

	--	사번으로 결재 도장 이미지 검색
	DECLARE	@wSignImageURL	varchar(200)

	SELECT	@wSignImageURL = FileURL + SavedFileName
	FROM	(SELECT	TOP	1
					Sign_AttachID
			FROM	eWFFORM.dbo.WF_CONFIG_USER c (NOLOCK)
					JOIN	eManage.dbo.VW_User v
						ON	v.UserID = c.UserID
						AND	v.DeptID = c.DeptID
			WHERE	v.EmpID = @Emp_ID
				AND	c.Sign_AttachID IS NOT NULL
				AND	c.Sign_AttachID <> 0
			ORDER BY v.EndDate DESC) A
			JOIN	eManage.dbo.TB_File F
				ON	F.AttachID = A.Sign_AttachID

	--	도장이 없는 사용자는 DEFAULT 설정
	IF	ISNULL(LTRIM(RTRIM(@wSignImageURL)), '') = ''
		SET	@wSignImageURL = 'http://lcware.lottechilsung.co.kr/eKWV2/eWF/Forms/SignDefault.gif'

	SELECT	U.EmpID, DD.DeptName, D.DeptName, JG.CodeName, JW.CodeName, JC.CodeName, U.UserName,
			@wSignImageURL	as SignImageURL
	FROM	eManage.dbo.TB_User U
			JOIN	eManage.dbo.TB_Dept_User_History H
				ON	H.UserID = U.UserID
			JOIN	(SELECT	UserID, MIN(DeptUserID) DeptUserID
					FROM	eManage.dbo.TB_Dept_User_History
					GROUP BY UserID) A
				ON	A.UserID = H.UserID
				AND	A.DeptUserID = H.DeptUserID
			JOIN	eManage.dbo.TB_Dept D
				ON	D.DeptID = H.DeptID
			LEFT OUTER JOIN	eManage.dbo.TB_Dept DD
				ON	DD.DeptID = D.ParentDeptID
			LEFT OUTER JOIN	eManage.dbo.TB_Code_Sub JG
				ON	JG.SubCode = H.JikGeupID
				AND	JG.ClassCode = '10JG'
			LEFT OUTER JOIN	eManage.dbo.TB_Code_Sub JW
				ON	JW.SubCode = H.JikWiID
				AND	JW.ClassCode = '10JW'
			LEFT OUTER JOIN	eManage.dbo.TB_Code_Sub JC
				ON	JW.SubCode = H.JikChaekID
				AND	JW.ClassCode = '10JC'
	WHERE	U.DeleteDate > GETDATE()
		AND	U.EmpID = @Emp_ID

	
RETURN

/*
Select	d.DeptName, m.*
From	eManage.dbo.TB_Dept m
	JOIN	eManage.dbo.TB_Dept d
		On	d.DeptID = m.ParentDeptID
Where	m.DeptID = '2594'
*/


GO
/****** Object:  StoredProcedure [dbo].[UP_SELECT_FORM_USER_INFO_BY_NAME]    Script Date: 2015-10-15 오후 1:30:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO






/****** 개체: 저장 프로시저 dbo.UP_SELECT_FORM_USER_INFO_BY_NAME    스크립트 날짜: 2007-10-30 오후 4:44:55 

exec dbo.UP_SELECT_FORM_USER_INFO_BY_NAME '오선희'

******/

CREATE	PROCEDURE	[dbo].[UP_SELECT_FORM_USER_INFO_BY_NAME]
		@Emp_Name	varchar(50)

As
set transaction isolation level read uncommitted

	--	사번으로 결재 도장 이미지 검색
	DECLARE	@tSignImange	TABLE
	(
		UserID	INT,
		SingImageURL	VARCHAR(200)
	)

	INSERT	INTO	@tSignImange
		SELECT	UserID,
				FileURL + SavedFileName	AS SingImageURL
		FROM	(SELECT	V.UserID,
						MAX(Sign_AttachID) AS Sign_AttachID
				FROM	eWFFORM.dbo.WF_CONFIG_USER c (NOLOCK)
						JOIN	eManage.dbo.VW_User v
							ON	v.UserID = c.UserID
							AND	v.DeptID = c.DeptID
				WHERE	v.UserName = @Emp_Name
					AND	c.Sign_AttachID IS NOT NULL
					AND	c.Sign_AttachID <> 0
				GROUP BY V.UserID) A
				JOIN	eManage.dbo.TB_File F
					ON	F.AttachID = A.Sign_AttachID


	SELECT	U.EmpID, DD.DeptName, D.DeptName, JG.CodeName, JW.CodeName, U.UserName, JC.CodeName, 
			CASE
				WHEN	I.SingImageURL IS NULL	THEN
					'http://lcware.lottechilsung.co.kr/eKWV2/eWF/Forms/SignDefault.gif'
				ELSE
					I.SingImageURL
			END	AS SingImageURL
	FROM	eManage.dbo.TB_User U
			JOIN	eManage.dbo.TB_Dept_User_History H
				ON	H.UserID = U.UserID
			JOIN	(SELECT	UserID, MIN(DeptUserID) DeptUserID
					FROM	eManage.dbo.TB_Dept_User_History
					GROUP BY UserID) A
				ON	A.UserID = H.UserID
				AND	A.DeptUserID = H.DeptUserID
			JOIN	eManage.dbo.TB_Dept D
				ON	D.DeptID = H.DeptID
			LEFT OUTER JOIN	eManage.dbo.TB_Dept DD
				ON	DD.DeptID = D.ParentDeptID
			JOIN	eManage.dbo.TB_Code_Sub JG
				ON	JG.SubCode = H.JikGeupID
				AND	JG.ClassCode = '10JG'
			JOIN	eManage.dbo.TB_Code_Sub JW
				ON	JW.SubCode = H.JikWiID
				AND	JW.ClassCode = '10JW'
			JOIN	eManage.dbo.TB_Code_Sub JC
				ON	JC.SubCode = H.JikChaekID
				AND	JC.ClassCode = '10JC'
			LEFT JOIN	@tSignImange I
				ON	I.UserID = U.UserID
	WHERE	U.DeleteDate > GETDATE()
		AND	U.UserName = @Emp_Name

/*
Select	e.EmpID,
		(
			Select	dd.DeptNm --, d.DeptNm, *
			From	[erpsql1\inst1].LeAcc.dbo.TDAOrgQ q
				Join	[erpsql1\inst1].LeAcc.dbo.TDAOrgQ qq
					On	qq.OrgCD = q.Pkey
					and	qq.OrgType = '0'
					and	qq.BegDate = (Select	Max(BegDate)	From	[erpsql1\inst1].LeAcc.dbo.TDAOrgMst	Where	OrgType = '0')
				Join	[erpsql1\inst1].LeAcc.dbo.TDADept d
					ON	d.DeptCD = q.DeptCD
				Join	[erpsql1\inst1].LeAcc.dbo.TDADept dd
					ON	dd.DeptCD = qq.DeptCD
			Where	q.DeptCd = e.DeptCD
			and	q.OrgType = '0'
			and	q.BegDate = (Select	Max(BegDate)	From	[erpsql1\inst1].LeAcc.dbo.TDAOrgMst	Where	OrgType = '0')
		) as ParentDept,
		d.DeptNm,
		mm.MinorNm,
		m.MinorNm,
		e.EmpNm

From	[erpsql1\inst1].LeAcc.dbo.TDAEmpMaster e
		Join	[erpsql1\inst1].LeAcc.dbo.TDADept d
			On	d.DeptCd = e.DeptCD
		Join	[erpsql1\inst1].LeAcc.dbo.TDAMinor m
			On	m.MinorCd = e.JpCD
		Join	[erpsql1\inst1].LeAcc.dbo.TDAMinor mm
			On	mm.MinorCd = e.PgCD
Where	EmpNm = @Emp_Name


--	관리자현황
select	r.RequestDate, r.RequestNO, u.UserName, r.EmpID, d.DeptName, JG.CodeName
from	egw.dbo.tb_trainuserequest r
		JOIN	eManage.dbo.TB_User U
			ON	U.EmpID = r.EmpID
		JOIN	eManage.dbo.TB_Dept_User_History H
			ON	H.UserID = U.UserID
		JOIN	(SELECT	UserID, MIN(DeptUserID) DeptUserID
				FROM	eManage.dbo.TB_Dept_User_History
				GROUP BY UserID) A
			ON	A.UserID = H.UserID
			AND	A.DeptUserID = H.DeptUserID
		JOIN	eManage.dbo.TB_Dept D
			ON	D.DeptID = H.DeptID
		JOIN	eManage.dbo.TB_Code_Sub JG
			ON	JG.SubCode = H.JikWiID
			AND	JG.ClassCode = '10JW'
ORDER BY r.RequestDate, r.RequestNO

*/





/*
Select	d.DeptName, m.*
From	eManage.dbo.TB_Dept m
	Join	eManage.dbo.TB_Dept d
		On	d.DeptID = m.ParentDeptID
Where	m.DeptID = '2594'
*/






GO
/****** Object:  StoredProcedure [dbo].[UP_SELECT_FORM_USER_INFO_BY_NAME_test]    Script Date: 2015-10-15 오후 1:30:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





/****** 개체: 저장 프로시저 dbo.UP_SELECT_FORM_USER_INFO_BY_NAME    스크립트 날짜: 2007-10-30 오후 4:44:55 

exec dbo.UP_SELECT_FORM_USER_INFO_BY_NAME_test '오선희'

******/

CREATE	PROCEDURE	[dbo].[UP_SELECT_FORM_USER_INFO_BY_NAME_test]
		@Emp_Name	varchar(50)

As
set transaction isolation level read uncommitted

	--	사번으로 결재 도장 이미지 검색
	DECLARE	@tSignImange	TABLE
	(
		UserID	INT,
		SingImageURL	VARCHAR(200)
	)

	INSERT	INTO	@tSignImange
		SELECT	UserID,
				FileURL + SavedFileName	AS SingImageURL
		FROM	(SELECT	V.UserID,
						MAX(Sign_AttachID) AS Sign_AttachID
				FROM	eWFFORM.dbo.WF_CONFIG_USER c (NOLOCK)
						JOIN	eManage.dbo.VW_User v
							ON	v.UserID = c.UserID
							AND	v.DeptID = c.DeptID
				WHERE	v.UserName = @Emp_Name
					AND	c.Sign_AttachID IS NOT NULL
					AND	c.Sign_AttachID <> 0
				GROUP BY V.UserID) A
				JOIN	eManage.dbo.TB_File F
					ON	F.AttachID = A.Sign_AttachID


	SELECT	U.EmpID, DD.DeptName, D.DeptName, JG.CodeName, JW.CodeName, U.UserName, 
			CASE
				WHEN	I.SingImageURL IS NULL	THEN
					'http://lcware.lottechilsung.co.kr/eKWV2/eWF/Forms/SignDefault.gif'
				ELSE
					I.SingImageURL
			END	AS SingImageURL
	FROM	eManage.dbo.TB_User U
			JOIN	eManage.dbo.TB_Dept_User_History H
				ON	H.UserID = U.UserID
			JOIN	(SELECT	UserID, MIN(DeptUserID) DeptUserID
					FROM	eManage.dbo.TB_Dept_User_History
					GROUP BY UserID) A
				ON	A.UserID = H.UserID
				AND	A.DeptUserID = H.DeptUserID
			JOIN	eManage.dbo.TB_Dept D
				ON	D.DeptID = H.DeptID
			LEFT OUTER JOIN	eManage.dbo.TB_Dept DD
				ON	DD.DeptID = D.ParentDeptID
			JOIN	eManage.dbo.TB_Code_Sub JG
				ON	JG.SubCode = H.JikGeupID
				AND	JG.ClassCode = '10JG'
			JOIN	eManage.dbo.TB_Code_Sub JW
				ON	JW.SubCode = H.JikWiID
				AND	JW.ClassCode = '10JW'
			LEFT JOIN	@tSignImange I
				ON	I.UserID = U.UserID
	WHERE	U.DeleteDate > GETDATE()
		AND	U.UserName = @Emp_Name

/*
Select	e.EmpID,
		(
			Select	dd.DeptNm --, d.DeptNm, *
			From	[erpsql1\inst1].LeAcc.dbo.TDAOrgQ q
				Join	[erpsql1\inst1].LeAcc.dbo.TDAOrgQ qq
					On	qq.OrgCD = q.Pkey
					and	qq.OrgType = '0'
					and	qq.BegDate = (Select	Max(BegDate)	From	[erpsql1\inst1].LeAcc.dbo.TDAOrgMst	Where	OrgType = '0')
				Join	[erpsql1\inst1].LeAcc.dbo.TDADept d
					ON	d.DeptCD = q.DeptCD
				Join	[erpsql1\inst1].LeAcc.dbo.TDADept dd
					ON	dd.DeptCD = qq.DeptCD
			Where	q.DeptCd = e.DeptCD
			and	q.OrgType = '0'
			and	q.BegDate = (Select	Max(BegDate)	From	[erpsql1\inst1].LeAcc.dbo.TDAOrgMst	Where	OrgType = '0')
		) as ParentDept,
		d.DeptNm,
		mm.MinorNm,
		m.MinorNm,
		e.EmpNm

From	[erpsql1\inst1].LeAcc.dbo.TDAEmpMaster e
		Join	[erpsql1\inst1].LeAcc.dbo.TDADept d
			On	d.DeptCd = e.DeptCD
		Join	[erpsql1\inst1].LeAcc.dbo.TDAMinor m
			On	m.MinorCd = e.JpCD
		Join	[erpsql1\inst1].LeAcc.dbo.TDAMinor mm
			On	mm.MinorCd = e.PgCD
Where	EmpNm = @Emp_Name


--	관리자현황
select	r.RequestDate, r.RequestNO, u.UserName, r.EmpID, d.DeptName, JG.CodeName
from	egw.dbo.tb_trainuserequest r
		JOIN	eManage.dbo.TB_User U
			ON	U.EmpID = r.EmpID
		JOIN	eManage.dbo.TB_Dept_User_History H
			ON	H.UserID = U.UserID
		JOIN	(SELECT	UserID, MIN(DeptUserID) DeptUserID
				FROM	eManage.dbo.TB_Dept_User_History
				GROUP BY UserID) A
			ON	A.UserID = H.UserID
			AND	A.DeptUserID = H.DeptUserID
		JOIN	eManage.dbo.TB_Dept D
			ON	D.DeptID = H.DeptID
		JOIN	eManage.dbo.TB_Code_Sub JG
			ON	JG.SubCode = H.JikWiID
			AND	JG.ClassCode = '10JW'
ORDER BY r.RequestDate, r.RequestNO

*/





/*
Select	d.DeptName, m.*
From	eManage.dbo.TB_Dept m
	Join	eManage.dbo.TB_Dept d
		On	d.DeptID = m.ParentDeptID
Where	m.DeptID = '2594'
*/





GO
/****** Object:  StoredProcedure [dbo].[UP_SELECT_FORMDEFAULTFIELD]    Script Date: 2015-10-15 오후 1:30:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
   CREATE
PROCEDURE [dbo].[UP_SELECT_FORMDEFAULTFIELD]
         (@vcFIELD_ID    VARCHAR(50) = ''
         )
       AS 
-- <pre-Step : 환경설정>
SET NOCOUNT ON
IF(@vcFIELD_ID='') BEGIN
    -- <Step-1-1 : 데이터 조회 - 전체>
    SELECT FIELD_NAME,   FIELD_LABEL,
           FIELD_TYPE,   FIELD_LENGTH,
           FIELD_DEFAULT, 
           CASE FIELD_CLASS 
                WHEN 'P' THEN 'PROCESS INFO<br>(프로세스 관련)'
                WHEN 'C' THEN 'CREATE INFO<br>(기안자 관련)'
                WHEN 'D' THEN 'DOCUMENT INFO<br>(결재문서 관련)'
                WHEN 'E' THEN 'EDM INFO<br>(문서관리 관련)'
                WHEN 'A' THEN 'ATTACH INFO<br>(문서파일 관련)'
                WHEN 'R' THEN 'RECEIVE INFO<br>(수신부서 관련)'
                ELSE ''
           END AS FIELD_CLASS, FIELD_ID
      FROM Wf_FORM_DEFAULT_FIELD WITH (READUNCOMMITTED)
     ORDER
        BY FIELD_CLASS, FIELD_NAME
    
    IF @@ERROR <> 0 BEGIN
        RAISERROR('데이터조회중 오류가 발생했습니다.[ES1]', 16, 1)
             WITH NOWAIT
        GOTO END_PROC
    END
END
ELSE BEGIN
    -- <Step-1-2 : 데이터 조회 - 항목>
    SELECT TOP 1 
           FIELD_NAME,    FIELD_LABEL,
           FIELD_TYPE,    FIELD_LENGTH,
           FIELD_DEFAULT, FIELD_CLASS, FIELD_ID
      FROM Wf_FORM_DEFAULT_FIELD
     WHERE FIELD_ID = @vcFIELD_ID
    
    IF @@ERROR <> 0 BEGIN
        RAISERROR('데이터조회중 오류가 발생했습니다.[ES2]', 16, 1)
             WITH NOWAIT
        GOTO END_PROC
    END
END
END_PROC:
-- <post-Step : 환경설정>
SET NOCOUNT OFF
RETURN

GO
/****** Object:  StoredProcedure [dbo].[UP_SELECT_FORMNAME]    Script Date: 2015-10-15 오후 1:30:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
----------------------------------------------------------------------
----------------------------------------------------------------------
-- 작성자: LDCC 신상훈
-- 작성일: 2004.04.02
-- 수정일: 2004.04.02
-- 설  명: 결재문서 삭제(기능상삭제, 실제로는 DataDate를 UPDATE해줌)
-- 테스트: EXEC dbo.UP_SELECT_FORMNAME 'Y819EC4E5CCF14ABAB9325B87A797D265'
----------------------------------------------------------------------
-- 수정일 : 
-- 수정자 : 
-- 수정내용 : 
----------------------------------------------------------------------
----------------------------------------------------------------------
CREATE   PROC [dbo].[UP_SELECT_FORMNAME]
    @vcFormId	    varchar(33)   
AS
SELECT B.FolderName 
	FROM	eWFFORM.dbo.WF_FOLDER_DETAIL A(NOLOCK), eWFFORM.dbo.Wf_FOLDER  B(NOLOCK)
		WHERE	A.FOLDERID = B.FolderID 
				AND A.FORM_ID = @vcFormId

GO
/****** Object:  StoredProcedure [dbo].[UP_Select_FORMS_DATA]    Script Date: 2015-10-15 오후 1:30:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

/****** 개체: 저장 프로시저 dbo.UP_Select_FORMS_DATA    스크립트 날짜: 2007-10-30 오후 4:44:57 ******/
CREATE	Procedure	[dbo].[UP_Select_FORMS_DATA]
		@PROCESS_ID	varchar(50)	-- 프로세스 ID

/*	--------------------------------------------------------------
	작성자: 임병태
	작성일: 2004.03.17
	수정일: 2005.08.31
	수정자: 김진시
	수정내용: DB결재 양식인지 구분할 FORM_TYPE 추가
	설명 : 결재폼 양식 데이터 정보를 가져온다
exec dbo.UP_Select_FORMS_DATA 'Z666C4779C246423B8449662AFABC041C'

--------------------------------------------------------------	*/
As

Set Transaction isolation level read uncommitted

	Declare	@vcFORM_ID	VARCHAR(50),		-- 결재 양식 폼 ID
			@nvcDY_SQL	NVARCHAR(4000),		-- 동적 양식 폼 조회 ID
			@cFOLDERTYPE	char(1),
			@intFOLDERID	int

	-- 프로세스 ID로 결재양식 폼 ID 가져오기
	Set	@vcFORM_ID = (Select	FORM_ID	From	dbo.WF_FORMS_PROP (NOLOCK)	Where	PROCESS_ID = @PROCESS_ID)

	Select	@intFOLDERID = FOLDERID
	From	WF_FOLDER_DETAIL (NOLOCK)
	Where	FORM_ID = @vcFORM_ID

	Select	@cFOLDERTYPE = FOLDERTYPE
	From	WF_FOLDER (NOLOCK)
	Where	FOLDERID = (Select	PARENTFOLDERID	From	WF_FOLDER (NOLOCK)	Where	FOLDERID = @intFOLDERID)

	-- 1. 양식 폼 헤더 정보
	Select	* ,@cFOLDERTYPE FOLDER_TYPE
	From	dbo.WF_FORMS (NOLOCK)
	Where	FORM_ID= @vcFORM_ID

	-- 2. 양식 폼의 스키마 정보
	Select	 *
	From	dbo.WF_FORM_SCHEMA (NOLOCK)
	Where	FORM_ID= @vcFORM_ID

	-- 3. 양식폼의 필드정보
	Select	*
	From	dbo.WF_FORM_INFORM (NOLOCK)
	Where	FORM_ID= @vcFORM_ID

	--	4. 결재양식 폼에서 프로세스 ID에 해당하는 폼 데이터를 가져오는 SQL를 생성한다.
	--	Drop	Table	#WF_FORM_INFORM
	Declare	@wTotalRowCount	int

	Declare	@WF_FORM_INFORM	Table
	(
		Field_Name	varchar(30),
		Num			int	identity(1, 1)
	)

	Insert	Into	@WF_FORM_INFORM
			(Field_Name)
	Select	Field_Name
--	Select	Field_Name, identity(int, 1, 1) as Num
--	Into	#WF_FORM_INFORM
	From	dbo.WF_FORM_INFORM
	Where	Form_ID = @vcFORM_ID
	Order by Field_Name

	Set	@wTotalRowCount = @@RowCount

	--	기안서 시리즈에 데이타 공유 작업
	Declare	@wU_AGREE_DEPT_Comment	varchar(8000),
			@wTongje				varchar(1000)

	Select	@wU_AGREE_DEPT_Comment = '',
			@wTongje = ''

	If	@vcFORM_ID in (Select	Form_ID	From	eWFForm.dbo.WF_Forms	Where	Form_EName in ('LC_DRAFT', 'LC_DRAFT_BRANCH', 'LC_SUPPORT_DRAFT'))
	Begin

		Exec dbo.UP_Select_AgreeDept_Comment @vcFORM_ID, @PROCESS_ID, @wU_AGREE_DEPT_Comment output

		If	@vcFORM_ID in (Select	Form_ID	From	eWFForm.dbo.WF_Forms	Where	Form_EName in ('LC_DRAFT', 'LC_DRAFT_BRANCH'))
			Exec dbo.UP_SELECT_AGREEDEPT_TONGJE @vcFORM_ID, @PROCESS_ID, @wTongje output

	End

	--	Select 쿼리 만드는 Loop 
	Declare	@wField_Name	varchar(1000),
			@wSql			varchar(8000),
			@wNum	int

	Select	@wField_Name = '',
			@wNum = 0,
			@wSql = ""

	While (1 = 1)
	Begin

		Select	Top 1
				@wNum = Num,
				@wField_Name = Field_Name
		From	@WF_FORM_INFORM
		Where	Num > @wNum
		Order by Num

		If	@@Rowcount = 0	Break

		If	@wField_Name = 'U_AGREE_DEPT_COMMENT'
			Set	@wSql = @wSql + '"' + IsNull(@wU_AGREE_DEPT_Comment, '') + '" as U_AGREE_DEPT_COMMENT'
		Else If	@wField_Name = 'TONGJE'
			Set	@wSql = @wSql + '"' + IsNull(@wTongje, '') + '" as TONGJE'
		Else

		Set	@wSql = @wSql + @wField_Name

--		If	@wNum < @wTotalRowCount
			Set	@wSql = @wSql + ', '

	End

	--	첨언 테이블 조회
	Declare	@wComment	varchar(8000)

	Exec UP_Select_Signer_Comment @PROCESS_ID, @wComment output

	IF	@wComment IS NULL
		SET	@wComment = "''"

	Set	@wSql = @wSql + @wComment + ' as U_Comment'

	--	조회
	Set	@wSql = "Select	" + @wSql + "	From	eWFForm.dbo.FORM_" + @vcFORM_ID + "	Where	Process_Id = '" + @PROCESS_ID + "'"
	print (@wSql)
	Exec (@wSql)

-- 	Begin
-- 
-- 		SET @nvcDY_SQL = N'Select	* From	dbo.FORM_' + @vcFORM_ID + ' (NOLOCK) Where	PROCESS_ID=@PROCESS_ID'
-- 		EXEC SP_EXECUTESQL  @nvcDY_SQL, N'@PROCESS_ID VARCHAR(50)', @PROCESS_ID
-- 
-- 	End


GO
/****** Object:  StoredProcedure [dbo].[UP_Select_FORMS_DATA_TEST]    Script Date: 2015-10-15 오후 1:30:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO


CREATE	Procedure	[dbo].[UP_Select_FORMS_DATA_TEST]
		@PROCESS_ID	varchar(50)	-- 프로세스 ID

/*	--------------------------------------------------------------

	작성자: 임병태
	작성일: 2004.03.17
	수정일: 2005.08.31
	수정자: 김진시
	수정내용: DB결재 양식인지 구분할 FORM_TYPE 추가
	설명 : 결재폼 양식 데이터 정보를 가져온다
--내부보고서
exec dbo.UP_Select_FORMS_DATA_test 'ZF02A3FE0555E473EA5047D595357B92D'
--기안서
exec dbo.UP_Select_FORMS_DATA Z7D765A1309DE4795833C03C48C967B5D
Select   CREATOR,CREATOR_JOBLEVEL,HASATTACH,REFERENCER_CODE,KEEP_YEAR,RECEPTION,SUGGESTDATE,READING,READING_CODE,DOC_NAME,HTMLDESCRIPTION,APPROVAL_STATE,PROCESS_ID,PROCESS_INSTANCE_STATE,SUBJECT,COMMAND,REFERENCER,CREATOR_DEPT,EDM_PARTCODE,DOC_LEVEL,UPFILE,DOC_NUMBER,EDMS_CATEGORY,RECEPTION_CODE,CREATOR_CODE,ARTICLE,BALSIN,CLAUSE,CREATOR_DEPT_CODE,CREATOR_SIGN,DAY_FROM,DAY_TO,DOC_GIHO,DOC_YEONDO,PHONENUM,SUSIN,RULES,SUGGESTDAY,'test뷁test' as TONGJE,U_AGREE_DEPT,'' as U_AGREE_DEPT_COMMENT,U_AGREE_DEPT_ID,U_SUBJECT_DETAIL,U_SUGGESTDEPT,U_SLOGAN_OF_THIS_YEAR,U_SUBJECT_DETAIL_INPUT   From	dbo.FORM_Y28B72F2F7EE54FB5BE13E8F2A3637978 (NOLOCK) Where	PROCESS_ID='Z7D765A1309DE4795833C03C48C967B5D'

Select	APPROVAL_STATE, ARTICLE, BALSIN, CLAUSE, COMMAND, CREATOR, CREATOR_CODE, CREATOR_DEPT, CREATOR_DEPT_CODE, CREATOR_JOBLEVEL, CREATOR_SIGN, DAY_FROM, DAY_TO, DOC_GIHO, DOC_LEVEL, DOC_NAME, DOC_NUMBER, DOC_YEONDO, EDM_PARTCODE, EDMS_CATEGORY, HASATTACH, HTMLDESCRIPTION, KEEP_YEAR, PHONENUM, PROCESS_ID, PROCESS_INSTANCE_STATE, READING, READING_CODE, RECEPTION, RECEPTION_CODE, REFERENCER, REFERENCER_CODE, RULES, SUBJECT, SUGGESTDATE, SUGGESTDAY, SUSIN,
 "test뷁test" as Tongje, U_AGREE_DEPT, "" as U_AGREE_DEPT_Comment, U_AGREE_DEPT_ID, U_SLOGAN_OF_THIS_YEAR, U_SUBJECT_DETAIL, U_SUBJECT_DETAIL_INPUT, U_SUGGESTDEPT, UPFILE	
From	eWFForm.dbo.FORM_Y28B72F2F7EE54FB5BE13E8F2A3637978	
Where	Process_Id = 'Z7D765A1309DE4795833C03C48C967B5D'

Select	APPROVAL_STATE, ARTICLE, BALSIN, CLAUSE, COMMAND, CREATOR, CREATOR_CODE, CREATOR_DEPT, CREATOR_DEPT_CODE, CREATOR_JOBLEVEL, CREATOR_SIGN, DAY_FROM, DAY_TO, DOC_GIHO, DOC_LEVEL, DOC_NAME, DOC_NUMBER, DOC_YEONDO, EDM_PARTCODE, EDMS_CATEGORY, HASATTACH, HTMLDESCRIPTION, KEEP_YEAR, PHONENUM, PROCESS_ID, PROCESS_INSTANCE_STATE, READING, READING_CODE, RECEPTION, RECEPTION_CODE, REFERENCER, REFERENCER_CODE, RULES, SUBJECT, SUGGESTDATE, SUGGESTDAY, SUSIN, "test뷁test" as TONGJE, U_AGREE_DEPT, "" as U_AGREE_DEPT_COMMENT, U_AGREE_DEPT_ID, U_SLOGAN_OF_THIS_YEAR, U_SUBJECT_DETAIL, U_SUBJECT_DETAIL_INPUT, U_SUGGESTDEPT, UPFILE	From	eWFForm.dbo.FORM_Y28B72F2F7EE54FB5BE13E8F2A3637978	Where	Process_Id = 'Z7D765A1309DE4795833C03C48C967B5D'

Select	APPROVAL_STATE, ARTICLE, BALSIN, CLAUSE, COMMAND, CREATOR, CREATOR_CODE, CREATOR_DEPT, CREATOR_DEPT_CODE, CREATOR_JOBLEVEL, CREATOR_SIGN, DAY_FROM, DAY_TO, DOC_GIHO, DOC_LEVEL, DOC_NAME, DOC_NUMBER, DOC_YEONDO, EDM_PARTCODE, EDMS_CATEGORY, HASATTACH, HTMLDESCRIPTION, KEEP_YEAR, PHONENUM, PROCESS_ID, PROCESS_INSTANCE_STATE, READING, READING_CODE, RECEPTION, RECEPTION_CODE, REFERENCER, REFERENCER_CODE, RULES, SUBJECT, SUGGESTDATE, SUGGESTDAY, SUSIN, 
"test뷁test" as TONGJE, U_AGREE_DEPT, "" as U_AGREE_DEPT_COMMENT, U_AGREE_DEPT_ID, U_SLOGAN_OF_THIS_YEAR, U_SUBJECT_DETAIL, U_SUBJECT_DETAIL_INPUT, U_SUGGESTDEPT, UPFILE	From	eWFForm.dbo.FORM_Y28B72F2F7EE54FB5BE13E8F2A3637978	Where	Process_Id = 'Z7D765A1309DE4795833C03C48C967B5D'

Select	APPROVAL_STATE, ARTICLE, BALSIN, CLAUSE, COMMAND, CREATOR, CREATOR_CODE, CREATOR_DEPT, CREATOR_DEPT_CODE, CREATOR_JOBLEVEL, CREATOR_SIGN, DAY_FROM, DAY_TO, DOC_GIHO, DOC_LEVEL, DOC_NAME, DOC_NUMBER, DOC_YEONDO, EDM_PARTCODE, EDMS_CATEGORY, HASATTACH, HTMLDESCRIPTION, KEEP_YEAR, PHONENUM, PROCESS_ID, PROCESS_INSTANCE_STATE, READING, READING_CODE, RECEPTION, RECEPTION_CODE, REFERENCER, REFERENCER_CODE, RULES, SUBJECT, SUGGESTDATE, SUGGESTDAY, SUSIN, 
"" as Tongje, U_AGREE_DEPT, "" as U_AGREE_DEPT_Comment, U_AGREE_DEPT_ID, U_SLOGAN_OF_THIS_YEAR, U_SUBJECT_DETAIL, U_SUBJECT_DETAIL_INPUT, U_SUGGESTDEPT, UPFILE	
From	eWFForm.dbo.FORM_Y28B72F2F7EE54FB5BE13E8F2A3637978	
Where	Process_Id = 'Z7D765A1309DE4795833C03C48C967B5D'

		Declare	@wU_AGREE_DEPT_Comment	varchar(1000),
				@wTongje				varchar(1000)

Exec dbo.UP_Select_AgreeDept_Comment Y28B72F2F7EE54FB5BE13E8F2A3637978, ZC09703C387A349A9B1A022381C96D8F0, @wU_AGREE_DEPT_Comment output
select @wU_AGREE_DEPT_Comment
Exec dbo.UP_SELECT_AGREEDEPT_TONGJE Y28B72F2F7EE54FB5BE13E8F2A3637978, ZC09703C387A349A9B1A022381C96D8F0, @wTongje output
select @wTongje

Select	Field_Name, identity(int, 1, 1) as Num
		Into	#WF_FORM_INFORM
		From	dbo.WF_FORM_INFORM
		Where	Form_ID = 'Y28B72F2F7EE54FB5BE13E8F2A3637978'
		Order by Field_Name
select * from #WF_FORM_INFORM Order by Field_Name
select column_name  from form_Y28B72F2F7EE54FB5BE13E8F2A3637978

select * from wf_forms where form_id = 'Y28B72F2F7EE54FB5BE13E8F2A3637978'

Declare	@wField_Name	varchar(1000),
	@wNum	int

Select	Top 1
		@wNum = Num,
		@wField_Name = Field_Name
From	#WF_FORM_INFORM
Where	Num > @wNum
Order by Num

Select	Field_Name from WF_FORM_INFORM

		Drop	Table	#WF_FORM_INFORM

--------------------------------------------------------------	*/
AS

set transaction isolation level read uncommitted

	Declare	@vcFORM_ID	VARCHAR(50),		-- 결재 양식 폼 ID
			@nvcDY_SQL	NVARCHAR(4000),		-- 동적 양식 폼 조회 ID
			@cFOLDERTYPE	char(1),
			@intFOLDERID	int

	-- 프로세스 ID로 결재양식 폼 ID 가져오기
	Set	@vcFORM_ID = (Select	FORM_ID	From	dbo.WF_FORMS_PROP (NOLOCK)	Where	PROCESS_ID = @PROCESS_ID)

	Select	@intFOLDERID = FOLDERID
	From	WF_FOLDER_DETAIL (NOLOCK)
	Where	FORM_ID = @vcFORM_ID

	Select	@cFOLDERTYPE = FOLDERTYPE
	From	WF_FOLDER (NOLOCK)
	Where	FOLDERID = (Select	PARENTFOLDERID	From	WF_FOLDER (NOLOCK)	Where	FOLDERID = @intFOLDERID)

	-- 1. 양식 폼 헤더 정보
	Select	* ,@cFOLDERTYPE FOLDER_TYPE
	From	dbo.WF_FORMS (NOLOCK)
	Where	FORM_ID= @vcFORM_ID

	-- 2. 양식 폼의 스키마 정보
	Select	 *
	From	dbo.WF_FORM_SCHEMA (NOLOCK)
	Where	FORM_ID= @vcFORM_ID
	 
	-- 3. 양식폼의 필드정보
	Select	*
	From	dbo.WF_FORM_INFORM (NOLOCK)
	Where	FORM_ID= @vcFORM_ID

	--	4. 결재양식 폼에서 프로세스 ID에 해당하는 폼 데이터를 가져오는 SQL를 생성한다.
	--	기안용지, 기안용지(지점용), 거래선지원품의서(일반)
	If	@vcFORM_ID in ('Y28B72F2F7EE54FB5BE13E8F2A3637978', 'YFA4BC440266849EB8DBA1A1FE7C55EE6', 'YB132CCF992074F738816938A12F7B758')
	Begin

		Declare	@wU_AGREE_DEPT_Comment	varchar(8000)
				,@wTongje		varchar(1000)
				,@wField_Name	varchar(1000)
				,@wSql			varchar(8000)
				,@wNum	int

		Select	@wField_Name = '',
				@wNum = 0,
				@wSql = ""
 		SET @wU_AGREE_DEPT_Comment = ''
 		SET @wTongje = ''

		Exec dbo.UP_Select_AgreeDept_Comment @vcFORM_ID, @PROCESS_ID, @wU_AGREE_DEPT_Comment output

		--	기안용지, 기안용지(지점용)
--		If	@vcFORM_ID in ('Y28B72F2F7EE54FB5BE13E8F2A3637978', 'YB132CCF992074F738816938A12F7B758')
		If	@vcFORM_ID in ('Y28B72F2F7EE54FB5BE13E8F2A3637978')
			Exec dbo.UP_SELECT_AGREEDEPT_TONGJE @vcFORM_ID, @PROCESS_ID, @wTongje output

		--Drop	Table	#WF_FORM_INFORM
		Select	Field_Name, identity(int, 1, 1) as Num
		Into	#WF_FORM_INFORM
		From	dbo.WF_FORM_INFORM
		Where	Form_ID = @vcFORM_ID
		Order by Field_Name

		While (1 = 1)
		Begin

			Select	Top 1
					@wNum = Num,
					@wField_Name = Field_Name
			From	#WF_FORM_INFORM
			Where	Num > @wNum
			Order by Num

			If	@@Rowcount = 0	Break

			If	@wField_Name = 'U_AGREE_DEPT_COMMENT'
begin 
				Set	@wSql = @wSql + '"' + IsNull(@wU_AGREE_DEPT_Comment, '') + '" as U_AGREE_DEPT_COMMENT'
select	@wSql
end

			Else If	@wField_Name = 'TONGJE'
				Set	@wSql = @wSql + '"' + IsNull(@wTongje, '') + '" as TONGJE'
			Else

				Set	@wSql = @wSql + @wField_Name

			If	@wNum < (Select	Max(Num)	From	#WF_FORM_INFORM)
				Set	@wSql = @wSql + ', '

		End

		Set	@wSql = "Select	" + @wSql + "	From	eWFForm.dbo.FORM_" + @vcFORM_ID + "	Where	Process_Id = '" + @PROCESS_ID + "'"
--print @wSql
		Exec (@wSql)

-- 		SET @nvcDY_SQL = N'Select  '
-- 				+N' CREATOR,CREATOR_JOBLEVEL,HASATTACH,REFERENCER_CODE,KEEP_YEAR,RECEPTION,SUGGESTDATE,READING,READING_CODE,DOC_NAME,HTMLDESCRIPTION,APPROVAL_STATE,PROCESS_ID,PROCESS_INSTANCE_STATE,SUBJECT,COMMAND,REFERENCER,CREATOR_DEPT,EDM_PARTCODE,DOC_LEVEL,UPFILE,DOC_NUMBER,EDMS_CATEGORY,RECEPTION_CODE,CREATOR_CODE,ARTICLE,BALSIN,CLAUSE,CREATOR_DEPT_CODE,CREATOR_SIGN,DAY_FROM,DAY_TO,DOC_GIHO,DOC_YEONDO,PHONENUM,SUSIN,RULES,SUGGESTDAY,'
-- 				+N''''+ IsNull(@wTongje, '') + ''''+' as TONGJE'
-- --				+N'TONGJE'
-- 				+N',U_AGREE_DEPT,'
-- 				+N''''+ IsNull(@wU_AGREE_DEPT_Comment, '') + ''''+' as U_AGREE_DEPT_COMMENT'
-- --				+N'U_AGREE_DEPT_COMMENT'
-- 				+N',U_AGREE_DEPT_ID,U_SUBJECT_DETAIL,U_SUGGESTDEPT,U_SLOGAN_OF_THIS_YEAR,U_SUBJECT_DETAIL_INPUT  '
-- 				+N' From	dbo.FORM_' + @vcFORM_ID + ' (NOLOCK) Where	PROCESS_ID=@PROCESS_ID'
-- 		
-- 		PRINT(@nvcDY_SQL)
-- 		EXEC SP_EXECUTESQL  @nvcDY_SQL, N'@PROCESS_ID VARCHAR(50)', @PROCESS_ID

	End
	Else
	Begin

		SET @nvcDY_SQL = N'Select	* From	dbo.FORM_' + @vcFORM_ID + ' (NOLOCK) Where	PROCESS_ID=@PROCESS_ID'
		EXEC SP_EXECUTESQL  @nvcDY_SQL, N'@PROCESS_ID VARCHAR(50)', @PROCESS_ID

	End



GO
/****** Object:  StoredProcedure [dbo].[UP_SELECT_FORMS_FORM_ID]    Script Date: 2015-10-15 오후 1:30:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE    PROCEDURE [dbo].[UP_SELECT_FORMS_FORM_ID]
(
	@FORM_ALIAS	VARCHAR(50)
	
) AS
-------------------------------------------------------------------------------------
-- 작성자: 임병태
-- 작성일: 2004.05.19
-- 수정일: 2004.05.19
-- 설명 : 결재폼 양식명으로 결재폼 ID를 가져온다.
-------------------------------------------------------------------------------------
	SELECT  TOP 1 FORM_ID FROM dbo.WF_FORMS
	WHERE FORM_ALIAS= @FORM_ALIAS



GO
/****** Object:  StoredProcedure [dbo].[UP_SELECT_FORMS_FORM_ID_ENAME]    Script Date: 2015-10-15 오후 1:30:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE   PROCEDURE [dbo].[UP_SELECT_FORMS_FORM_ID_ENAME]
(
	 @FORM_ENAME   VARCHAR(200)
) AS
-------------------------------------------------------------------------------------
-- 작성자: 임병태
-- 작성일: 2004.05.19
-- 수정일: 2004.05.19
-- 설명 : 결재폼 양식명으로 결재폼 ID를 가져온다.
-------------------------------------------------------------------------------------
	SELECT  TOP 1 FORM_ID FROM dbo.WF_FORMS
	WHERE FORM_ENAME = @FORM_ENAME


GO
/****** Object:  StoredProcedure [dbo].[UP_SELECT_FORMS_PROP]    Script Date: 2015-10-15 오후 1:30:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UP_SELECT_FORMS_PROP]
(
	@VCPROCESS_ID		VARCHAR(50)
)
-------------------------------------------------------------------------------------
-- 작성자: 임병태
-- 작성일: 2004.06.23
-- 수정일: 2004.06.23
-- 설명 : 결재폼 속성 데이터 내역을 가져온다.
-------------------------------------------------------------------------------------
AS
	SELECT *
	  FROM dbo.WF_FORMS_PROP
	 WHERE PROCESS_ID = @VCPROCESS_ID
	 

GO
/****** Object:  StoredProcedure [dbo].[UP_SELECT_FORMS_PROP_INNERHTML]    Script Date: 2015-10-15 오후 1:30:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UP_SELECT_FORMS_PROP_INNERHTML]
(
	@VCPROCESS_ID		VARCHAR(50)
)
-------------------------------------------------------------------------------------
-- 작성자: 임병태
-- 작성일: 2004.06.23
-- 수정일: 2004.06.23
-- 설명 : 결재폼 속성 데이터 내역을 가져온다.
-- 실행 : EXEC UP_SELECT_FORMS_PROP_INNERHTML 'Z5EA508F5F5054A889C71B301540126A7'
-------------------------------------------------------------------------------------
AS
	DECLARE 
		@nTEXTSIZE  	INT,
		@nvcDY_SQL	NVARCHAR(500)		-- 동적 양식 폼 조회 ID
	-- TEXT 필드 길이를 계산한다.
	SET @nTEXTSIZE = (SELECT ISNULL(DATALENGTH(INNERHTML),0)
				  FROM dbo.WF_FORMS_PROP (NOLOCK)
				 WHERE PROCESS_ID = @VCPROCESS_ID )
	-- 100 바이트 추가로 적용한다.
	SET @nTEXTSIZE = @nTEXTSIZE + 100 
	SET @nvcDY_SQL = N'SET TEXTSIZE ' + CONVERT(VARCHAR, @nTEXTSIZE) + ' SELECT INNERHTML  FROM dbo.WF_FORMS_PROP (NOLOCK)	 WHERE PROCESS_ID = @VCPROCESS_ID'
	EXEC SP_EXECUTESQL  @nvcDY_SQL, N'@vcPROCESS_ID VARCHAR(50)', @vcPROCESS_ID

GO
/****** Object:  StoredProcedure [dbo].[UP_Select_Next_ProcessID]    Script Date: 2015-10-15 오후 1:30:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO





/*
--	사용자ID,사용자부서ID,결재함종류,검색조건,검색어,현재페이지,블록(페이지)당표시건수,정렬필드,정렬방법,전체결재건수(Output)
exec dbo.UP_LIST_VW_WORKLIST_DOCUMENTLIST_NAVI @strUserId = '133342', @strSortColumn = 'CREATOR', @strSortOrder = 'ASC', @strSDate = '2006-05-01', @strEDate = '2006-08-11', @strFormsId = '"Y9FA891C60DF54882BAE0DA51F233AF69","Y2C2E2C72B0B24A3782D8BCAA162C52E6","YCE8164DCB318442B8BB5FE26F293A82B"', @pProcessID = 'Z6FCB499CCB3E46288FF5719A341EF0FB'

select top 1 * from VW_WORK_LIST 

Select	*
From	dbo.VW_WORK_LIST 
Where	Participant_id = '133342'
		and STATE = '2'
		and PROCESS_INSTANCE_VIEW_STATE = '3'
		and	ITEMSTATE = '1'
        and	CREATE_DATE >= '2006-05-01'
		and	CREATE_DATE <= '2006-08-11 23:59:59'
		and	Form_ID	in ('Y9FA891C60DF54882BAE0DA51F233AF69','Y2C2E2C72B0B24A3782D8BCAA162C52E6','YCE8164DCB318442B8BB5FE26F293A82B')
ORDER BY CREATOR ASC, ITEMCREATE_DATE DESC

exec dbo.UP_Select_Next_ProcessID @strUserId = '133342', @strSortColumn = '0', @strSortOrder = 'ASC', @strSDate = '', @strEDate = '', @strFormsId = 'all', @pProcessID = 'Z4E3E562701A9463A9585F0AD03B1E429'


exec dbo.UP_Select_Next_ProcessID @strUserId = '133342', @strSortColumn = '0', @strSortOrder = 'ASC', @strSDate = '', @strEDate = '', @strFormsId = 'all', @pProcessID = 'ZAC311A279CD3465E859B14DE1D4D0F78'

exec dbo.UP_Select_Next_ProcessID @strUserId = '133342', @strSortColumn = '0', @strSortOrder = 'ASC', @strSDate = '', @strEDate = '', @strFormsId = 'all', @pProcessID = 'Z107D30A0A72543049B6F1AB833989CCE'

*/

CREATE	Procedure	[dbo].[UP_Select_Next_ProcessID]
		--	사용자ID, 사용자부서ID, 결재함종류, 검색조건, 검색어, 현재페이지, 블록(페이지)당 표시건수, 정렬필드, 정렬방법, 전체결재건수(Output)
		@strUserId		varchar(20),
-- 		@strUserDeptId varchar(20),
-- 		@strDFType varchar(5),
-- 		@nCurPage int, 
-- 		@nRowPerPage int,
		@strSortColumn	varchar(20),
		@strSortOrder	varchar(5),
		@strSDate		varchar(50),
		@strEDate		varchar(50),
		@strFormsId		varchar(1000),
		@pProcessID		char(33)

As

Declare	@sQuery				varchar(1500),
		@strOrderBy			varchar(100),
		@strWhereForFormsId	varchar(1000)

Create	Table	#List
(
Num			int	identity(1, 1),
ProcessID			char(33),
IsUrgent 			char(1), 
Status 				char(1), 
AttachYN			char(1),
PostScript			char(1),
CATEGORYNAME 		char(50), 
SUBJECT 			varchar(400), 
DOC_LEVEL 			char(20), 
CREATOR 			varchar(50),  
CREATOR_DEPT 		varchar(50),  
CREATE_DATE		 datetime,
Open_Yn				char(1),
WorkOID				char(33),
RefDoc				char(1),
ATTACH_EXTENSION 	varchar(200),
CREATOR_ID 			varchar(50),
DOC_NUMBER			varchar(50)
)

--	FORM_ID WHERE 조건 구문을 만든다.
If	@strFormsId = 'ALL'
    Begin
		Set	@strWhereForFormsId = ''
    End
Else
    Begin
		Set	@strWhereForFormsId = '	and	Form_ID	in (''' + @strFormsId + ''')'
    End

Set	@strWhereForFormsId = Replace(@strWhereForFormsId, '"', "'")

	-- 소팅컬럼의 값이 0이 넘어오면 기본값으로 정렬
	If	@strSortColumn = '0'			Begin
			Set	@strOrderBy = ' ORDER BY CREATE_DATE DESC'
		End
	Else
		Begin
			Set	@strOrderBy = ' ORDER BY '+@strSortColumn+' '+@strSortOrder+ ' , ITEMCREATE_DATE DESC'
		End

	Select	@sQuery = "
			Insert	Into	#List
						(
							ProcessID,
							IsUrgent,
							Status,
							AttachYN,
							PostScript,
							CATEGORYNAME,
							SUBJECT,
							DOC_LEVEL,
							CREATOR,
							CREATOR_DEPT,
							CREATE_DATE,
							Open_Yn,
							WorkOID,
							RefDoc,
							ATTACH_EXTENSION,
							CREATOR_ID,
							DOC_NUMBER
						)

				select 
							v.ITEMOID,
							v.IsUrgent, 
							v.Status, 
							v.ISATTACHFILE, 
							v.PostScript, 
							v.CATEGORYNAME, 
							v.SUBJECT, 
							v.DOC_LEVEL, 
							v.CREATOR, 
							v.CREATOR_DEPT, 
							SUBSTRING(CONVERT(varchar,v.CREATE_DATE,21),0,20) as CREATE_DATE,					
							v.OPEN_YN,
							v.OID,
							v.Ref_Doc,
							v.ATTACH_EXTENSION,
							v.CREATOR_ID,
							v.DOC_NUMBER	
				From	dbo.VW_WORK_LIST v
				Where	Participant_id = '" + @strUserId + "'
						and STATE = '2'
						and PROCESS_INSTANCE_VIEW_STATE = '3'
						and	ITEMSTATE = '1'
				"

	If	@strSDate <> ''
		Select	@sQuery = @sQuery +
				"	and	CREATE_DATE >= '" + @strSDate + "'"

	If	@strEDate <> ''
		Select	@sQuery = @sQuery +
				"	and	CREATE_DATE <= '" + @strEDate + " 23:59:59'"

	Select	@sQuery = @sQuery + @strWhereForFormsId
	Select	@sQuery = @sQuery + @strOrderBy

	Print @sQuery
	Exec (@sQuery)

	--	현재문서의 다음문서
	Select	top 1 *
	From	#List
	Where	Num > (Select	Num		From	#List		Where	ProcessID = @pProcessID)
	Order by Num

	--	현재문서의 이전문서
	Select	top 1 *
	From	#List
	Where	Num < (Select	Num		From	#List		Where	ProcessID = @pProcessID)
	Order by Num Desc

Return








GO
/****** Object:  StoredProcedure [dbo].[UP_SELECT_PASSWORD_LIST]    Script Date: 2015-10-15 오후 1:30:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE   PROC [dbo].[UP_SELECT_PASSWORD_LIST]
/*
	작성자 : 김진시
	작성일 : 2005/07/11
	실행    : EXEC UP_SELECT_PASSWORD_LIST
*/
AS

/*
SELECT DISTINCT B.USERID, [PASSWORD]
FROM WF_CONFIG_USER_OLD A(NOLOCK)
INNER JOIN EMANAGE.DBO.TB_USER B(NOLOCK)
	ON A.USERACCOUNT = B.USERACCOUNT
*/

--encoding안돼 있는것들만 따로 처리
SELECT top 1 B.USERID,C.PASSWORD
FROM EMANAGE.DBO.TB_USER B(NOLOCK)
INNER JOIN WORKFLOWFORM.DBO.WF_CONFIG_USER C(NOLOCK)
	ON B.USERACCOUNT = C.USERACCOUNT
WHERE USERID IN
(

SELECT DISTINCT B.USERID 
FROM EWF.DBO.WF_CONFIG_USER_OLD A(NOLOCK)
INNER JOIN EMANAGE.DBO.TB_USER B(NOLOCK)
	ON A.PASSWORD = B.APPROVALPASS AND A.USERACCOUNT = B.USERACCOUNT
)

GO
/****** Object:  StoredProcedure [dbo].[UP_SELECT_PROCESSSIGNINFORM]    Script Date: 2015-10-15 오후 1:30:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[UP_SELECT_PROCESSSIGNINFORM]
	/* Param List */
	@strOid varchar(50)
AS
SELECT SIGN_CONTEXT FROM eWF.dbo.PROCESS_SIGN_INFORM
	WHERE PROCESS_INSTANCE_OID = @strOid
return

GO
/****** Object:  StoredProcedure [dbo].[UP_SELECT_PROCREQUEST]    Script Date: 2015-10-15 오후 1:30:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE	Procedure	[dbo].[UP_SELECT_PROCREQUEST]

As

/*
ALTER Proc [dbo].[SPJobProcSave]
	@pWorkingTag     varchar(5) = null , -- 구분자
	@pJobMngNo     varchar(12) = null , -- 업무번호
	@pEmpID     varchar(8) = null , -- 사번				= 
	@pDeptCd     varchar(5) = null , -- 부서			= 
	@pJobKind     varchar(8) = null , -- 업무구분		=	JOB_NAME
	@pTitle     varchar(200) = null , -- 제목			=	SUBJECT
	@pProcContent     varchar(1000) = null , -- 처리내역	=	REQUEST
	@pReqDate     varchar(8) = null , -- 요청일				=	DESIRED_DATE
	@pReqDeptCd     varchar(5) = null , -- 의뢰부서			=	Creator_Dept_Code
	@pReqEmpID     varchar(8) = null , -- 의뢰자			=	Creator_Code
	@pStartDate     varchar(8) = null , -- 시작일			=	Completed_Date
	@pEndDate     varchar(8) = null , -- 종료일		''
	@pPlanDate     varchar(8) = null , -- 예정일			=	Completed_Date
	@pProgClss     varchar(8) = null , -- 진행구분	''
	@pStopYN     varchar(1) = null , -- 보류여부	''
	@pStopReason     varchar(500) = null , -- 보류이유	''
	@pRegDate     varchar(8) = null , -- 등록일				=	SuggestDate
	@pRegEmpID     varchar(8) = null, -- 등록자				=	Creator_Code
	@pApprovalProcessID		varchar(33) = null -- 결재번호..
*/

	--	이미 처리된 ID
--	Drop	Table	#OldList
	Select 	a.*
	Into	#OldList
	From 	OpenRowset('sqloledb','bscdb'; 'sa'; 'bsc', 'Select	ApprovalProcessID	From	DBProg.dbo.TPJobProcConfirmInfo') As a

--	Drop	Table		#NewList
	Select	f.Process_Id,
			f.Subject, 
			Replace(Replace(substring(f.Request, charindex('뷁', f.Request) + 1, len(f.Request) - charindex('뷁', f.Request)), '퉭', ' '), '<br>', char(13))	as Request,
			f.Desired_Date, 
			Substring(f.Completed_Date, 1, 4) + Substring(f.Completed_Date, 6, 2) + Substring(f.Completed_Date, 9, 2)	as Completed_Date,
			Substring(SuggestDate, 1, 4) + Substring(SuggestDate, 6, 2) + Substring(SuggestDate, 9, 2)	as CreateDate,
			f.Creator_Dept_Code, f.Creator_Code 
	Into	#NewList
	From	eWFForm.dbo.FORM_Y00651F8C793843BDB04C6DB25765FB41 f
			Join	eManage.dbo.TB_Dept d
				On	d.DeptID = f.Creator_Dept_Code
				and	d.ParentDeptID <> '2559'	--	전산실
			Join	eWF.dbo.Work_Item w
				On	w.Process_Instance_Oid = f.Process_ID
				and	w.Participant_Name = '신청처리함'
			Left Join	#OldList p
				On	p.ApprovalProcessID = f.Process_ID
	Where		p.ApprovalProcessID is Null


	Truncate	Table	dbo.WF_PROCREQUEST

	Insert	Into	eWFForm.dbo.WF_PROCREQUEST
				(Process_ID,	Subject,	Request,		DesiredDate,
				CompletedDate,	CreateDate,	CreateEmpID,	CreateDeptID,	ProcEmpID,	ProcDeptID)
		Select	m.Process_Id,
				m.Subject,
				m.Request,
--				m.Desired_Date, 
				Convert(char(8), getdate(), 112)	as Desired_Date, 
				m.Completed_Date,
				m.CreateDate,
				u.UserCd as Creator_Code,
				d.DeptCd as Creator_Dept_Code,
				uu.UserCd as EmpID,
				dd.DeptCd as DeptCd		
		From	#NewList m
				Join	(Select	c.Process_ID, wwww.Participant_ID as UserID
						From	eWF.dbo.Work_Item wwww
								Join	(Select	ww.Process_Instance_Oid as Process_ID, Min(ww.Create_Date) as Create_Date
										From	eWF.dbo.Work_Item ww
												Join	(Select	w.Process_Instance_Oid, w.Create_Date
														From	#NewList n
																Join	eWF.dbo.Work_Item w
																	On	w.Process_Instance_Oid = n.Process_ID
																	and	w.Participant_Name = '수신함') www
													On	ww.Process_Instance_Oid = www.Process_Instance_Oid
													and	ww.Name = '일반결재자'
													and	ww.Create_Date > www.Create_Date
										Group by ww.Process_Instance_Oid) c
									On	c.Process_ID = wwww.Process_Instance_Oid
									and	c.Create_Date = wwww.Create_Date
						Where	wwww.Name = '일반결재자') p
					On	p.Process_ID = m.Process_ID
				Join	eManage.dbo.TB_User u
					On	u.UserID = m.Creator_Code
				Join	eManage.dbo.TB_Dept d
					On	d.DeptID = m.Creator_Dept_Code
				Join	eManage.dbo.TB_User uu
					On	uu.UserID = p.UserID
				Join	eManage.dbo.TB_Dept_User_History h
					On	h.UserId = uu.UserId
					and	Convert(char(8), h.EndDate, 112) = '99991231'
					and	h.PositionOrder = 1
				Join	eManage.dbo.TB_Dept dd
					On	dd.DeptId = h.DeptID





GO
/****** Object:  StoredProcedure [dbo].[UP_SELECT_RECEIVERINFO]    Script Date: 2015-10-15 오후 1:30:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  PROC [dbo].[UP_SELECT_RECEIVERINFO]
	@varID varchar(33)
AS
--------------------------------------------------------
-- 작성자 : 박재용
-- 작성일 : 2004.03.12
-- 수정일 : 2004.03.12
-- 설  명 :  협조처 정보 Select
--------------------------------------------------------
SET NOCOUNT ON
 SELECT   SIGNINFORM, SIGNERLIST
  FROM dbo.Wf_SIGNER_LIST(NOLOCK)
 WHERE ID = @varID

GO
/****** Object:  StoredProcedure [dbo].[UP_SELECT_RECEIVERLIST]    Script Date: 2015-10-15 오후 1:30:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
----------------------------------------------------------------------
----------------------------------------------------------------------
-- 작성자: 박재용
-- 작성일: 2004.03.10
-- 수정일: 2004.03.11
-- 설  명: 협조처 정보 조회
-- 테스트: EXEC UP_GETRECEIVERLIST_SELECT '10007'
----------------------------------------------------------------------
-- 수정일 : 
-- 수정자 : 
-- 수정내용 : 
----------------------------------------------------------------------
----------------------------------------------------------------------
CREATE   PROCEDURE [dbo].[UP_SELECT_RECEIVERLIST]
(
	@intUSERID	int
)
AS
	SELECT ID, SIGNLISTNAME, SIGNINFORM, SIGNERLIST
	FROM dbo.WF_SIGNER_LIST(NOLOCK)
	WHERE USERID = @intUSERID  AND LISTTYPE = 'M'	
	RETURN

GO
/****** Object:  StoredProcedure [dbo].[UP_SELECT_REFERENCERINFO]    Script Date: 2015-10-15 오후 1:30:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[UP_SELECT_REFERENCERINFO]
	@ID varchar(33)
AS
--------------------------------------------------------
-- 작성자 : 안기홍
-- 작성일 : 2004.03.12
-- 수정일 : 2004.03.12
-- 설  명 : 참조자 정보를 select
--------------------------------------------------------
SET NOCOUNT ON
SELECT SignInform, SignerList
  FROM dbo.Wf_SIGNER_LIST(NOLOCK)
 WHERE ID = @ID 

GO
/****** Object:  StoredProcedure [dbo].[UP_SELECT_REFERENCERLIST]    Script Date: 2015-10-15 오후 1:30:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[UP_SELECT_REFERENCERLIST]
	@userID int
AS
--------------------------------------------------------
-- 작성자 : 안기홍
-- 작성일 : 2004.03.12
-- 수정일 : 2004.03.12
-- 설  명 : 참조자 리스트를 select
--------------------------------------------------------
SET NOCOUNT ON
SELECT  ID, 
	SignListName, 
	SignInform, 
	SignerList 
  FROM dbo.Wf_SIGNER_LIST(NOLOCK)
 WHERE UserID = @userID
   AND ListType = 'R'

GO
/****** Object:  StoredProcedure [dbo].[UP_SELECT_SERVICE_ANALY]    Script Date: 2015-10-15 오후 1:30:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UP_SELECT_SERVICE_ANALY]
(
	@CLIST_KIND	CHAR(1),	-- A:년도별, B:월별, C:일별, D:요일별, E:시간대별
	@VCFROM	VARCHAR(20),	-- 검색시간일 (YYYY-MM-DD)
	@VCTO		VARCHAR(20)	-- 검색종요일 (YYYY-MM-DD)
)
	
AS
DECLARE
	@FORM_DATE DATETIME,
	@TO_DATE DATETIME
	-- 년도별 조회가 아니면 검색일자 날짜형으로 변환 
	-- 년도별 조회는 전체 조회로 검색일이 업음
	IF @CLIST_KIND <> 'A' 
		BEGIN
			SET 	@FORM_DATE  	= CONVERT(DATETIME,@VCFROM)			-- 날짜형으로 변환
			SET	@TO_DATE 	= CONVERT(DATETIME,@VCTO + ' 23:59:59')		-- 날짜형으로 변환
		END 
	
	IF @CLIST_KIND = 'A' 
		BEGIN
			-- 년도
			SELECT A.PROCESS_DATE, DRAFT_CNT, APPROVAL_CNT, TOTAL_CNT
 			 FROM  (
					SELECT 1 SEQ,
						CONVERT(VARCHAR(4),PROCESS_DATE,21) PROCESS_DATE,-- 년
						SUM (
							CASE PROCESS_CD 
								WHEN 'D' THEN 1
								ELSE 0
							END ) DRAFT_CNT,
						SUM (
							CASE PROCESS_CD
								WHEN 'A' THEN 1
								ELSE 0
							END ) APPROVAL_CNT,
						COUNT(*) TOTAL_CNT
					  FROM dbo.WF_ANALY_SERVICE (NOLOCK)
					GROUP BY CONVERT(VARCHAR(4),PROCESS_DATE,21) -- 년
				UNION ALL
					SELECT 
						9, '총합계',
						SUM (
							CASE PROCESS_CD 
								WHEN 'D' THEN 1
								ELSE 0
							END ) DRAFT_CNT,
						SUM (
							CASE PROCESS_CD
								WHEN 'A' THEN 1
								ELSE 0
							END ) APPROVAL_CNT,
						COUNT(*) TOTAL_CNT
					  FROM dbo.WF_ANALY_SERVICE (NOLOCK)
				) A
				ORDER BY SEQ, PROCESS_DATE
		
		END
	ELSE IF @CLIST_KIND = 'B' 
		BEGIN
		
			--월별
			SELECT A.PROCESS_DATE, DRAFT_CNT, APPROVAL_CNT, TOTAL_CNT
 			 FROM  (
					SELECT  1 SEQ,
						CONVERT(VARCHAR(7),PROCESS_DATE,21) PROCESS_DATE,-- 월
						SUM (
							CASE PROCESS_CD 
								WHEN 'D' THEN 1
								ELSE 0
							END ) DRAFT_CNT,
						SUM (
							CASE PROCESS_CD
								WHEN 'A' THEN 1
								ELSE 0
							END ) APPROVAL_CNT,
						COUNT(*) TOTAL_CNT
					  FROM dbo.WF_ANALY_SERVICE (NOLOCK)
					 WHERE PROCESS_DATE BETWEEN  @VCFROM AND @TO_DATE
					GROUP BY CONVERT(VARCHAR(7), PROCESS_DATE,21)-- 월
				UNION ALL
					SELECT 
						9, '총합계',
						SUM (
							CASE PROCESS_CD 
								WHEN 'D' THEN 1
								ELSE 0
							END ) DRAFT_CNT,
						SUM (
							CASE PROCESS_CD
								WHEN 'A' THEN 1
								ELSE 0
							END ) APPROVAL_CNT,
						COUNT(*) TOTAL_CNT
					  FROM dbo.WF_ANALY_SERVICE (NOLOCK)
					 WHERE PROCESS_DATE BETWEEN  @VCFROM AND @TO_DATE
				) A
				ORDER BY SEQ, PROCESS_DATE
		END
		
	ELSE IF @CLIST_KIND = 'C' 
		BEGIN
		
			-- 일별
			SELECT A.PROCESS_DATE, DRAFT_CNT, APPROVAL_CNT, TOTAL_CNT
 			 FROM  (
					SELECT  1 SEQ,
						CONVERT(VARCHAR(10), PROCESS_DATE,21) PROCESS_DATE, --일
						SUM (
							CASE PROCESS_CD 
								WHEN 'D' THEN 1
								ELSE 0
							END ) DRAFT_CNT,
						SUM (
							CASE PROCESS_CD
								WHEN 'A' THEN 1
								ELSE 0
							END ) APPROVAL_CNT,
						COUNT(*) TOTAL_CNT
					  FROM dbo.WF_ANALY_SERVICE (NOLOCK)
					 WHERE PROCESS_DATE BETWEEN  @VCFROM AND @TO_DATE
					GROUP BY CONVERT(VARCHAR(10), PROCESS_DATE,21)-- 일별
				UNION ALL
					SELECT 
						9, '총합계',
						SUM (
							CASE PROCESS_CD 
								WHEN 'D' THEN 1
								ELSE 0
							END ) DRAFT_CNT,
						SUM (
							CASE PROCESS_CD
								WHEN 'A' THEN 1
								ELSE 0
							END ) APPROVAL_CNT,
						COUNT(*) TOTAL_CNT
					  FROM dbo.WF_ANALY_SERVICE (NOLOCK)
					 WHERE PROCESS_DATE BETWEEN  @VCFROM AND @TO_DATE
				) A
				ORDER BY SEQ, PROCESS_DATE
		END
		
	ELSE IF @CLIST_KIND = 'D' 
		BEGIN
			-- 요일별
			SELECT A.PROCESS_DATE, DRAFT_CNT, APPROVAL_CNT, TOTAL_CNT
 			 FROM  (
					SELECT PROCESS_DATE_SEQ SEQ, A.PROCESS_DATE, A.DRAFT_CNT, A.APPROVAL_CNT, A.TOTAL_CNT
					   FROM  (
						SELECT 
							DATENAME(W, PROCESS_DATE) PROCESS_DATE, -- 요일
							DATEPART(W, PROCESS_DATE) PROCESS_DATE_SEQ, -- 요일
							SUM (
								CASE PROCESS_CD 
									WHEN 'D' THEN 1
									ELSE 0
								END ) DRAFT_CNT,
							SUM (
								CASE PROCESS_CD
									WHEN 'A' THEN 1
									ELSE 0
								END ) APPROVAL_CNT,
							COUNT(*) TOTAL_CNT
						  FROM dbo.WF_ANALY_SERVICE (NOLOCK)
					 WHERE PROCESS_DATE BETWEEN  @VCFROM AND @TO_DATE
						GROUP BY DATENAME(W, PROCESS_DATE), DATEPART(W, PROCESS_DATE) -- 요일
					  ) A
				UNION ALL
					SELECT 
						9, '총합계',
						SUM (
							CASE PROCESS_CD 
								WHEN 'D' THEN 1
								ELSE 0
							END ) DRAFT_CNT,
						SUM (
							CASE PROCESS_CD
								WHEN 'A' THEN 1
								ELSE 0
							END ) APPROVAL_CNT,
						COUNT(*) TOTAL_CNT
					  FROM dbo.WF_ANALY_SERVICE (NOLOCK)
					 WHERE PROCESS_DATE BETWEEN  @VCFROM AND @TO_DATE
				) A
				ORDER BY SEQ, PROCESS_DATE
		END
	ELSE IF @CLIST_KIND = 'E' 
		BEGIN
		
			-- 시간대별
			SELECT A.PROCESS_DATE, DRAFT_CNT, APPROVAL_CNT, TOTAL_CNT
 			 FROM  (
					SELECT 
						1 SEQ,
						DATEPART(hour,PROCESS_DATE) PROCESS_INT, -- 시간
						DATENAME(hour,PROCESS_DATE) PROCESS_DATE,
						SUM (
							CASE PROCESS_CD 
								WHEN 'D' THEN 1
								ELSE 0
							END ) DRAFT_CNT,
						SUM (
							CASE PROCESS_CD
								WHEN 'A' THEN 1
								ELSE 0
							END ) APPROVAL_CNT,
						COUNT(*) TOTAL_CNT
					  FROM dbo.WF_ANALY_SERVICE (NOLOCK)
					 WHERE PROCESS_DATE BETWEEN  @VCFROM AND @TO_DATE
					GROUP BY DATEPART(hour,PROCESS_DATE), DATENAME(hour,PROCESS_DATE) --시간
				UNION ALL
					SELECT 
						9, 1,'총합계',
						SUM (
							CASE PROCESS_CD 
								WHEN 'D' THEN 1
								ELSE 0
							END ) DRAFT_CNT,
						SUM (
							CASE PROCESS_CD
								WHEN 'A' THEN 1
								ELSE 0
							END ) APPROVAL_CNT,
						COUNT(*) TOTAL_CNT
					  FROM dbo.WF_ANALY_SERVICE (NOLOCK)
					 WHERE PROCESS_DATE BETWEEN  @VCFROM AND @TO_DATE
				) A
				ORDER BY SEQ, PROCESS_INT, PROCESS_DATE
		END

GO
/****** Object:  StoredProcedure [dbo].[UP_Select_Signer_Comment]    Script Date: 2015-10-15 오후 1:30:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO


CREATE	Procedure	[dbo].[UP_Select_Signer_Comment]
		@pProcessID		char(33)		= '',
		@pComment		varchar(8000)	= '' OutPut

As

/*	----------------------------------------------------
-- 작성자: 신철호
-- 작성일: 2004.03.05
-- 수정일: 2004.03.05
-- 설명 : 결재자정보를 추가한다

declare	@pComment	varchar(8000)
exec	UP_Select_Signer_Comment 'ZF20512C6BFBE4E478AE4044F05C40623', @pComment output
select	@pComment

----------------------------------------------------	*/

Set	Nocount On

	Declare	@wProcessID	char(33)

	--	기안부서의 ProcessID
	Select	@wProcessID = Parent_Oid
	From	eWF.dbo.Process_Instance
	Where	Oid = @pProcessID

	If	IsNull(@wProcessID, '') = ''
		Select	@wProcessID = @pProcessID

	Declare	@wRowCount	int
	Declare	@pTable		Table
	(
		RowNum		int	identity(1, 1),
		DeptName	varchar(30),
		UserName	varchar(30),
		Comment		varchar(8000)
	)
	Insert	Into	@pTable
				(DeptName,	UserName,	Comment)
		Select	u.DeptName,	u.UserName, c.Comment
		From	eWFForm.dbo.WF_Signer_Comment c with (nolock)
				Join	(Select	@wProcessID	as OID
						Union
						Select	OID
						From	eWF.dbo.Process_Instance p with (nolock)
						Where	Parent_Oid = @wProcessID) o
					On	o.OID = c.Process_Instance_OID
				Join	eWF.dbo.Work_Item w with (nolock)
					On	w.Process_Instance_OID = c.Process_Instance_OID
					and	w.OID = c.Work_Item_OID
					and	w.NAME LIKE '%일반결재자%'
				Join	eManage.dbo.VW_User u with (nolock)
					On	u.UserID = w.Participant_ID
					and	u.EndDate > GetDate()
					and	u.PositionOrder = 1
		Order by c.CreateDate

	--	전체 행수
	Set	@wRowCount = @@RowCount	

	Declare	@wRowNum	int,
			@wDeptName	varchar(500),
			@wUserName	varchar(500),
			@wComment	varchar(8000)

	Select	@wRowNum	= 0,
			@wDeptName	= '',
			@wUserName	= '',
			@wComment	= ''

	While	(1 = 1)
	Begin

		Select	Top 1
				@wRowNum	= RowNum,
				@wDeptName	= @wDeptName + DeptName,
				@wUserName	= @wUserName + UserName,
				@wComment	= @wComment	+ Comment
		From	@pTable
		Where	RowNum > @wRowNum
		Order by RowNum
		
		If	@@RowCount = 0	Break

		--	마지막 행에는 구분자를 넣지 않기 위함
		If	@wRowNum < @wRowCount
			Select	@wDeptName	= @wDeptName + '|',
					@wUserName	= @wUserName + '|',
					@wComment	= @wComment	+ '|'

	End
	
	Select	@pComment = '"' + @wDeptName + '_/' + @wUserName + '_/' + Replace(Replace(@wComment, char(13), '<br/>'), ' ', '&nbsp;') + '"'




GO
/****** Object:  StoredProcedure [dbo].[UP_SELECT_SIGNER_LIST_TEMPAPRLINE]    Script Date: 2015-10-15 오후 1:30:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UP_SELECT_SIGNER_LIST_TEMPAPRLINE]
(
	@nDEPT_ID	INT,
	@vcFORM_ID	VARCHAR(50)
)
-------------------------------------------------------------------------------------
-- 작성자: 임병태
-- 작성일: 2004.04.21
-- 수정일: 2004.04.21
-- 설명 : 양식 결재선 결재선 내역 가져오기
-------------------------------------------------------------------------------------
AS
	SET NOCOUNT ON
	SET TEXTSIZE 50000
	SELECT SIGNINFORM
	FROM WF_SIGNER_LIST
	WHERE USERID = @nDEPT_ID
	AND FORM_ID = @vcFORM_ID

GO
/****** Object:  StoredProcedure [dbo].[UP_SELECT_SIGNERLISTNAME]    Script Date: 2015-10-15 오후 1:30:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- 작성자 : 마성옥
-- 하는일 : 개인결재선 이름을 가져옴
CREATE Procedure [dbo].[UP_SELECT_SIGNERLISTNAME]
	@strID	varchar(100)
	
AS
	SELECT SignListName
	FROM dbo.WF_SIGNER_LIST
	WHERE ID = @strID
	
RETURN

GO
/****** Object:  StoredProcedure [dbo].[UP_SELECT_SIGNINFORM]    Script Date: 2015-10-15 오후 1:30:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- 작성자 : 마성옥
-- 하는일 : SIGNINFORM(XML STRING) 정보를 가져옴
CREATE Procedure [dbo].[UP_SELECT_SIGNINFORM]
	@strID	varchar(33)
	
AS
	SELECT SIGNINFORM
	FROM dbo.WF_SIGNER_LIST
	WHERE ID = @strID
RETURN

GO
/****** Object:  StoredProcedure [dbo].[UP_SELECT_SPECIAL_DOC_FOLDER]    Script Date: 2015-10-15 오후 1:30:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[UP_SELECT_SPECIAL_DOC_FOLDER]
	/* Param List */
AS
	SELECT		DOC_FOLDER_ID,
				DOC_FOLDER_NAME 				
				
	FROM		dbo.Wf_DOC_FOLDER
	
	WHERE		APR_FOLDER_TYPE = 'D' AND DOC_FOLDER_TYPE = 'S' AND USAGE_YN = 'Y'
	
	ORDER BY	SortKey asc
	
	
RETURN

GO
/****** Object:  StoredProcedure [dbo].[UP_SELECT_VW_DOCUMENTLIST_HEADERINFO]    Script Date: 2015-10-15 오후 1:30:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- 헤더정보만 DataSet 으로 리턴함
CREATE    Procedure [dbo].[UP_SELECT_VW_DOCUMENTLIST_HEADERINFO]

	@strDFType varchar(5)

AS

DECLARE @sQuery VARCHAR(1500)


if @strDFType = 'ST'
-- 임시보관함

	BEGIN
			SET @sQuery = 
			N'	SELECT  bb.PROCESS_ID,
						(SELECT Form_Name FROM dbo.WF_FORMS s WHERE s.FORM_ID = bb.FORM_ID) as FORM_NAME,
						bb.USERID,
						bb.SUBJECT,
						bb.DEPTID,
						bb.DESCRIPTION,
						SUBSTRING(CONVERT(VARCHAR,bb.CREATE_DATE,21),0,20) as CREATE_DATE

				FROM 
					dbo.WF_FORM_STORAGE bb 
				WHERE 
					bb.PROCESS_ID = ''FORHEADER'''
	END


else if  @strDFType = 'AP' OR @strDFType = 'AF' OR @strDFType = 'R' OR @strDFType = 'K'

	BEGIN
		-- 나머지 개인/부서결재함
		SET @sQuery =	
					'SELECT	 
						a.ITEMOID,				
						a.IsUrgent,
						a.Status,
						a.ISATTACHFILE,
						a.PostScript,
						a.CATEGORYNAME,
						a.SUBJECT,				
						a.DOC_LEVEL,
						a.CREATOR,
						a.CREATOR_DEPT,
						SUBSTRING(CONVERT(varchar,a.CREATE_DATE,21),0,20) as CREATE_DATE,
						a.OPEN_YN,
						a.OID,
						a.PostScript,
						a.Ref_Doc,
						a.ATTACH_EXTENSION,
						a.CREATOR_ID,
						a.DOC_NUMBER
					FROM 
						dbo.VW_WORK_LIST a WHERE a.ITEMOID = ''FORHEADER'''
	END


else if  @strDFType = 'PR' OR @strDFType = 'P' OR @strDFType = 'S'  OR @strDFType = 'A'


	BEGIN
		-- 나머지 개인/부서결재함
		SET @sQuery =	
					'SELECT	 
						a.ITEMOID,				
						a.IsUrgent,
						a.Status,
						a.ISATTACHFILE,
						a.PostScript,
						a.CATEGORYNAME,
						a.SUBJECT,				
						a.DOC_LEVEL,
						a.CREATOR,
						a.CREATOR_DEPT,
						SUBSTRING(CONVERT(VARCHAR,a.COMPLETED_DATE,21),0,20) as COMPLETED_DATE,
						a.OPEN_YN,
						a.OID,
						a.PostScript,
						a.Ref_Doc,
						a.ATTACH_EXTENSION,
						a.CREATOR_ID,
						a.DOC_NUMBER
					FROM 
						dbo.VW_WORK_LIST a WHERE a.ITEMOID = ''FORHEADER'''
	END

else  if  @strDFType = 'CO' OR @strDFType = 'RE'


	BEGIN
		-- 나머지 개인/부서결재함
		SET @sQuery =	
					'SELECT	 
						a.ITEMOID,				
						a.IsUrgent,
						a.Status,
						a.ISATTACHFILE,
						a.PostScript,
						a.CATEGORYNAME,
						a.SUBJECT,				
						a.DOC_LEVEL,
						a.CREATOR,
						a.CREATOR_DEPT,
						SUBSTRING(CONVERT(VARCHAR,a.VIEW_COMPLETE_DATE,21),0,20) as VIEW_COMPLETE_DATE,
						a.OPEN_YN,
						a.OID,
						a.PostScript,
						a.Ref_Doc,
						a.ATTACH_EXTENSION,
						a.CREATOR_ID,
						a.DOC_NUMBER
					FROM 
						dbo.VW_WORK_LIST a WHERE a.ITEMOID = ''FORHEADER'''
	END


else
	BEGIN
			-- 나머지 개인/부서결재함
		SET @sQuery =	
					'SELECT	 
						a.ITEMOID,				
						a.IsUrgent,
						a.Status,
						a.ISATTACHFILE,
						a.PostScript,
						a.CATEGORYNAME,
						a.SUBJECT,				
						a.DOC_LEVEL,
						a.CREATOR,
						a.CREATOR_DEPT,
						SUBSTRING(CONVERT(VARCHAR,a.COMPLETED_DATE,21),0,20) as COMPLETED_DATE,
						a.OPEN_YN,
						a.OID,
						a.PostScript,
						a.Ref_Doc,
						a.ATTACH_EXTENSION,
						a.CREATOR_ID,
						a.DOC_NUMBER
					FROM 
						dbo.VW_WORK_LIST a WHERE a.ITEMOID = ''FORHEADER'''
	
	END

--create table #tem(sql text)
--insert #tem(sql) values(@sQuery+@where)
--select * from #tem
--drop table #tem

exec(@sQuery)

--print @sQuery

RETURN






GO
/****** Object:  StoredProcedure [dbo].[UP_SELECT_WF_ACL_FORMLINE]    Script Date: 2015-10-15 오후 1:30:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


----------------------------------------------------------------------
----------------------------------------------------------------------
-- 작성자: 신상훈
-- 작성일: 2004.03.08
-- 수정일: 2004.03.08
-- 설  명: 하위부서 부서문서함 조회
-- 테스트: EXEC  UP_SELECT_WF_ACL_FORMLINE 0,10005,'D'
----------------------------------------------------------------------
-- 수정일 : 
-- 수정자 : 
-- 수정내용 : 
----------------------------------------------------------------------
----------------------------------------------------------------------
CREATE   PROC [dbo].[UP_SELECT_WF_ACL_FORMLINE]
	@intUserId	int,	-- 사용자/부서ID
	@intDeptId	int,	-- 소속부서ID
	@cUserType	Char(1)
	
AS
IF @cUserType = 'P'	-- 사용자권한관리
SELECT	ACLID
FROM	eWFFORM.dbo.WF_ACL_FORM_LINE(NOLOCK)
WHERE	USERID = @intUserId AND DEPTID = @intDeptId AND USER_TYPE = @cUserType
ELSE		-- 부서권한관리
SELECT	ACLID
FROM	eWFFORM.dbo.WF_ACL_FORM_LINE(NOLOCK)
WHERE	DEPTID = @intDeptId AND USER_TYPE = @cUserType



GO
/****** Object:  StoredProcedure [dbo].[UP_SELECT_WF_CONFIG_USER_COUNT]    Script Date: 2015-10-15 오후 1:30:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  PROCEDURE [dbo].[UP_SELECT_WF_CONFIG_USER_COUNT]
	@intUserId	int,
	@intDeptId	int
	
AS
	SELECT	COUNT(USERID) 
	FROM	eWFFORM.dbo.WF_CONFIG_USER
	WHERE	USERID = @intUserId AND DEPTID = @intDeptId

GO
/****** Object:  StoredProcedure [dbo].[UP_SELECT_WF_DOC_FOLDER_ROOT]    Script Date: 2015-10-15 오후 1:30:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

----------------------------------------------------------------------
----------------------------------------------------------------------
-- 작성자: LDCC 신상훈
-- 작성일: 2005.01.03
-- 수정일: 2005.01.03
-- 설   명: 사용자트리의 RootFolder이름 변경
-- 테스트: EXEC UP_UPDATE_WF_DOC_FOLDER_ROOT 'Company Name'
-- SELECT * FROM dbo.WF_DOC_FOLDER
-- TRUNCATE TABLE dbo.WF_DOC_FOLDER
----------------------------------------------------------------------
-- 수정일 : 
-- 수정자 : 
-- 수정내용 : 
----------------------------------------------------------------------
----------------------------------------------------------------------
CREATE  Procedure [dbo].[UP_SELECT_WF_DOC_FOLDER_ROOT]
	/* Param List */		
-- 	@vcDocFolderName	VarChar(50)
	
AS
	SELECT		DOC_FOLDER_NAME
   	      FROM	eWFFORM.DBO.WF_DOC_FOLDER
		WHERE 	APR_FOLDER_ID = 'RT'
RETURN


GO
/****** Object:  StoredProcedure [dbo].[UP_SELECT_WF_DOC_FOLDER_TYPE]    Script Date: 2015-10-15 오후 1:30:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



----------------------------------------------------------------------
----------------------------------------------------------------------
-- 작성자: 신상훈
-- 작성일: 2004.05.21
-- 수정일: 2004.05.21
-- 설  명: 하위부서 부서문서함 조회
-- 테스트: EXEC DBO.UP_SELECT_WF_DOC_FOLDER_TYPE 'ST'
----------------------------------------------------------------------
-- 수정일 : 
-- 수정자 : 
-- 수정내용 : 
----------------------------------------------------------------------
----------------------------------------------------------------------
CREATE    PROC [dbo].[UP_SELECT_WF_DOC_FOLDER_TYPE]
    
    @cAprFolderCode	char(2)
    
AS
	If	@cAprFolderCode = 'RF'
		Select	'회람문서조회'	as DOC_FOLDER_NAME
	Else
		SELECT APR_FOLDER_TYPE + DOC_FOLDER_TYPE
		FROM eWFFORM.dbo.WF_DOC_FOLDER
		WHERE APR_FOLDER_ID = @cAprFolderCode



GO
/****** Object:  StoredProcedure [dbo].[UP_SELECT_WF_DOCFOLDERNAME]    Script Date: 2015-10-15 오후 1:30:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


----------------------------------------------------------------------
----------------------------------------------------------------------
-- 작성자: 신상훈
-- 작성일: 2004.03.10
-- 수정일: 2004.03.10
-- 설  명: 문서함 이름 조회
-- 테스트: EXEC  UP_SELECT_WF_DOCFOLDERNAME 'rf'
----------------------------------------------------------------------
-- 수정일: 
-- 수정자: 
-- 수정내용 : 
----------------------------------------------------------------------
----------------------------------------------------------------------
CREATE   Procedure [dbo].[UP_SELECT_WF_DOCFOLDERNAME]
		@aprFolderCode	varchar(2)
	
AS

	If	@aprFolderCode = 'RF'
		Select	'회람문서조회'	as DOC_FOLDER_NAME
	Else
		Select	DOC_FOLDER_NAME		-- 문서함이름								
		From	eWFFORM.dbo.Wf_DOC_FOLDER
		Where	APR_FOLDER_ID = @aprFolderCode


GO
/****** Object:  StoredProcedure [dbo].[UP_SELECT_WF_SIGNER_FOLDER]    Script Date: 2015-10-15 오후 1:30:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE    PROCEDURE [dbo].[UP_SELECT_WF_SIGNER_FOLDER]
(	
	@PROCESS_INSTANCE_OID			VARCHAR(33)	-- 프로세스 ID		
)
AS
-------------------------------------------------------------------------------------
-- 작성자: 신철호
-- 작성일: 2005.04.11
-- 수정일: 2005.04.11
-- 설명 : 결재자별 예결함을 수정한다.
/*
     EXEC dbo.UP_SELECT_WF_SIGNER_FOLDER 'Z001767540FEC40959922830E2A9CA8C7'

select * from ewf.dbo.process_sign_inform(nolock) where process_instance_oid = 'Z001767540FEC40959922830E2A9CA8C7'
*/
-------------------------------------------------------------------------------------
	
	SELECT 	1 	AS	TAG,
		NULL	AS 	Parent,
		NULL	AS	[SIGNERFOLDER!1!],
		NULL 	AS	[SIGNER!2!SIGN_OID],
		NULL 	AS	[SIGNER!2!SIGN_SEQ],
		NULL 	AS	[SIGNER!2!PROCESS_INSTANCE_OID],
		NULL 	AS	[SIGNER!2!USER_ID],
		NULL 	AS	[SIGNER!2!USER_NAME],
		NULL 	AS	[SIGNER!2!ACTION_TYPE]		
	UNION ALL
	SELECT  2,	
		1,		
		NULL,
		SIGN_OID,
		SIGN_SEQ, 		
		PROCESS_INSTANCE_OID,
		USER_ID,
		USER_NAME,
		ACTION_TYPE
	FROM dbo.WF_SIGNER_FOLDER(nolock)
	WHERE PROCESS_INSTANCE_OID = @PROCESS_INSTANCE_OID
	ORDER BY [SIGNER!2!SIGN_SEQ]

FOR XML EXPLICIT




GO
/****** Object:  StoredProcedure [dbo].[UP_SELECT_WFFOLDER]    Script Date: 2015-10-15 오후 1:30:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UP_SELECT_WFFOLDER]
	(
		@folderId varchar(20)
	)
AS
		/* SET NOCOUNT ON */
		SELECT WF.FolderID, WF.ClassCode, WF.FolderName, WFT.TypeName, WF.FolderType, WF.Depth, WF.ParentFolderID
		, WF.HasSubFolder, WF.CreateDate, isnull(WF.DeleteDate, '') DeleteDate, isnull(WF.Description, '') Description
		FROM dbo.Wf_FOLDER as WF, dbo.wf_folder_type as WFT (NOLOCK) 
		WHERE WF.FolderID=@folderId and WF.FolderType = WFT.FolderType
RETURN 

GO
/****** Object:  StoredProcedure [dbo].[UP_SELECT_WFPWD_WF_CONFIG_USER]    Script Date: 2015-10-15 오후 1:30:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UP_SELECT_WFPWD_WF_CONFIG_USER]
	
	@intUserId	int
	
	AS
	/* SET NOCOUNT ON */
	
	Select APPROVALPASS
	From eManage.dbo.TB_USER
	Where USERID = @intUserId
	

GO
/****** Object:  StoredProcedure [dbo].[UP_SELECT_WFSIGNERLIST]    Script Date: 2015-10-15 오후 1:30:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- 작성자 : 마성옥
-- 하는일 : 개인결재선 정보를 가져옴
CREATE Procedure [dbo].[UP_SELECT_WFSIGNERLIST]
	@nUserId	int,
	@chTabKind	char(10)
	
AS
	SELECT * 
	FROM dbo.WF_SIGNER_LIST
	WHERE UserID = @nUserId
		AND ListType = @chTabKind
	
RETURN

GO
/****** Object:  StoredProcedure [dbo].[UP_SELECT_WFSIGNERLISTALL]    Script Date: 2015-10-15 오후 1:30:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- 작성자 : 마성옥
-- 하는일 : 개인결재선 모든 정보를 가져옴(결재선관리)
CREATE Procedure [dbo].[UP_SELECT_WFSIGNERLISTALL]
	@nUserId	int
	
AS
	SELECT * 
	FROM dbo.WF_SIGNER_LIST
	WHERE UserID = @nUserId
RETURN

GO
/****** Object:  StoredProcedure [dbo].[UP_SELECT_WFSIGNERLISTALL_F]    Script Date: 2015-10-15 오후 1:30:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO






create       Procedure [dbo].[UP_SELECT_WFSIGNERLISTALL_F]
	@nCurPage int,
	@iTotalCount int output
AS	

	
----------------------------------------------------------------------
----------------------------------------------------------------------
-- 작성자: 신철호
-- 작성일: 2005.04.07
-- 수정일: 2005.04.07
-- 설  명: 모든 개인결재선 및 양식결재선을 조회한다. 조직정보와 동기화하기 위해서
-- 테스트: 
/*
DECLARE @TOTALCOUNT INT
SET @TOTALCOUNT = 0
EXEC  UP_SELECT_WFSIGNERLISTALL_F 1, @TOTALCOUNT OUTPUT
SELECT @TOTALCOUNT
*/
----------------------------------------------------------------------
DECLARE @strQuery VARCHAR(8000)
DECLARE @iNum1 INT

DECLARE @strOrderBy VARCHAR(100)
DECLARE @strOrderByRevers VARCHAR(100)
DECLARE @strSortOrderRevers CHAR(4)

DECLARE @nSelectRecord INT		-- 실제로 반환할 레코드 수
DECLARE @nRowPerPage INT






SET @nRowPerPage =10 --sp 하드코딩 
SET @iNum1 = @nCurPage * @nRowPerPage
SET @nSelectRecord = @nRowPerPage

SET @iTotalCount = 	(	
				SELECT count(*) 
				FROM dbo.WF_SIGNER_LIST A(nolock)
				INNER JOIN emanage.dbo.tb_user B
				ON A.UserID = B.UserID
				where A.listtype in ('S')
			)

	----------------------실제로 조회해야할 레코드 카운트 계산----------------------*
	/* 
	총 레코드 카운트가 이론적인 총 레코드 카운트(현재페이지*페이지사이즈)보다 작을때 
	총 레코드 수에서 이전 페이지까지의 레코드 수를 빼서 나머지 필요한 레코드 카운트를 구한다.
	*/

	IF @iTotalCount < (@iNum1)
		BEGIN
			SET @nSelectRecord = @iTotalCount - ( (@nCurPage - 1) * @nRowPerPage )
		END
	

	----------------------반환할 레코드 카운트가 1 미만인 경우----------------------
	IF @nSelectRecord < 1
	BEGIN
		SET @nSelectRecord = 0
		SET @iNum1 =0
	END



	
	-------------------------------[공통]---------------------------------------------------
	SET @strOrderBy = ' ORDER BY C.UserID DESC'
			
		
		
	-------------------------------[공통]---------------------------------------------------

	SET @strOrderByRevers = ' ORDER BY C.UserID ASC'
	
	-------------------------------[공통]---------------------------------------------------		

	SET @strQuery =	
				'SELECT 
					C.ID as ID,
					C.UserName as UserName,
					C.SignListName as  SignListName,
					C.SignInform as SignInform,
					C.listtype as listtype		

				FROM  (
					select top ' + CAST(@nSelectRecord AS VARCHAR) + ' * 
					from (
							select top ' + CAST(@iNum1 AS VARCHAR) + '
							 	A.ID as ID,
								A.UserID as UserID,
								B.DeptName as UserName,
								A.SignListName as  SignListName,
								A.SignInform as SignInform,
								A.listtype as listtype
							FROM dbo.WF_SIGNER_LIST A(nolock)
							INNER JOIN emanage.dbo.tb_dept B
							ON A.UserID = B.DeptID
							where A.listtype in (''F'')
							Order By A.UserID desc
						) C
					' +@strOrderByRevers+ '
		   			) C
				' +@strOrderBy





	

PRINT(@strQuery)
EXEC(@strQuery)


/*

SET @strQuery =
+	N'SELECT 	top '+ convert(char(10),@intDivideNum)
+	N'		A.ID as ID,'
+	N'		B.UserName as UserName,'
+	N'		A.SignListName as  SignListName,'
+	N'		A.SignInform as SignInform,'
+	N'		A.listtype as listtype'
+	N'	FROM dbo.WF_SIGNER_LIST A(nolock)'
+	N'	INNER JOIN emanage.dbo.tb_user B'
+	N'	ON A.UserID = B.UserID'
+	N'	where A.listtype in (''S'')'
+	N'	Order By A.UserID desc'

+	N'	'

+	N'SELECT 	top '+ convert(char(10),@intDivideNum)
+	N'		A.ID as ID,'
+	N'		B.DeptName as UserName,'
+	N'		A.SignListName as  SignListName,'
+	N'		A.SignInform as SignInform,'
+	N'		A.listtype as listtype'
+	N'	FROM dbo.WF_SIGNER_LIST A(nolock)'
+	N'	INNER JOIN emanage.dbo.tb_dept B'
+	N'	ON A.UserID = B.DeptID'
+	N'	where A.listtype in (''F'')'
+	N'	Order By A.UserID desc'


	SELECT 	top 10

A.ID as ID,
		B.UserName as UserName,
		A.SignListName as  SignListName,
		A.SignInform as SignInform,
		A.listtype as listtype
	FROM dbo.WF_SIGNER_LIST A(nolock)
	INNER JOIN emanage.dbo.tb_user B
	ON A.UserID = B.UserID
	where A.listtype in ('S')
	Order By A.UserID desc

	SELECT top 10	A.ID as ID,
A.UserID as UserID,
		B.DeptName as UserName,
		A.SignListName as  SignListName,
		A.SignInform as SignInform,
		A.listtype as listtype
	FROM dbo.WF_SIGNER_LIST A(nolock)
	INNER JOIN emanage.dbo.tb_dept B
	ON A.UserID = B.DeptID
	where A.listtype in ('F')
	Order By A.UserID desc
*/
RETURN







GO
/****** Object:  StoredProcedure [dbo].[UP_SELECT_WFSIGNERLISTALL_S]    Script Date: 2015-10-15 오후 1:30:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





create      Procedure [dbo].[UP_SELECT_WFSIGNERLISTALL_S]
	@nCurPage int,
	@iTotalCount int output
AS	

	
----------------------------------------------------------------------
----------------------------------------------------------------------
-- 작성자: 신철호
-- 작성일: 2005.04.07
-- 수정일: 2005.04.07
-- 설  명: 모든 개인결재선 및 양식결재선을 조회한다. 조직정보와 동기화하기 위해서
-- 테스트: 
/*
DECLARE @TOTALCOUNT INT
SET @TOTALCOUNT = 0
EXEC  UP_SELECT_WFSIGNERLISTALL_S 3, @TOTALCOUNT OUTPUT
SELECT @TOTALCOUNT
*/
----------------------------------------------------------------------
DECLARE @strQuery VARCHAR(8000)
DECLARE @iNum1 INT

DECLARE @strOrderBy VARCHAR(100)
DECLARE @strOrderByRevers VARCHAR(100)
DECLARE @strSortOrderRevers CHAR(4)

DECLARE @nSelectRecord INT		-- 실제로 반환할 레코드 수
DECLARE @nRowPerPage INT






SET @nRowPerPage =10 --sp 하드코딩 
SET @iNum1 = @nCurPage * @nRowPerPage
SET @nSelectRecord = @nRowPerPage

SET @iTotalCount = 	(	
				SELECT count(*) 
				FROM dbo.WF_SIGNER_LIST A(nolock)
				INNER JOIN emanage.dbo.tb_user B
				ON A.UserID = B.UserID
				where A.listtype in ('S')
			)

	----------------------실제로 조회해야할 레코드 카운트 계산----------------------*
	/* 
	총 레코드 카운트가 이론적인 총 레코드 카운트(현재페이지*페이지사이즈)보다 작을때 
	총 레코드 수에서 이전 페이지까지의 레코드 수를 빼서 나머지 필요한 레코드 카운트를 구한다.
	*/

	IF @iTotalCount < (@iNum1)
		BEGIN
			SET @nSelectRecord = @iTotalCount - ( (@nCurPage - 1) * @nRowPerPage )
		END
	

	----------------------반환할 레코드 카운트가 1 미만인 경우----------------------
	IF @nSelectRecord < 1
	BEGIN
		SET @nSelectRecord = 0
		SET @iNum1 =0
	END



	
	-------------------------------[공통]---------------------------------------------------
	SET @strOrderBy = ' ORDER BY C.UserID DESC'
			
		
		
	-------------------------------[공통]---------------------------------------------------

	SET @strOrderByRevers = ' ORDER BY C.UserID ASC'
	
	-------------------------------[공통]---------------------------------------------------		

	SET @strQuery =	
				'SELECT 
					C.ID as ID,
					C.UserName as UserName,
					C.SignListName as  SignListName,
					C.SignInform as SignInform,
					C.listtype as listtype		

				FROM  (
					select top ' + CAST(@nSelectRecord AS VARCHAR) + ' * 
					from (
							select top ' + CAST(@iNum1 AS VARCHAR) + '
								A.ID as ID,
								A.UserID as UserID,
								B.UserName as UserName,
								A.SignListName as  SignListName,
								A.SignInform as SignInform,
								A.listtype as listtype
							FROM dbo.WF_SIGNER_LIST A(nolock)
							INNER JOIN emanage.dbo.tb_user B
							ON A.UserID = B.UserID
							where A.listtype in (''S'')
							ORDER BY A.UserID DESC
						) C
					' +@strOrderByRevers+ '
		   			) C
				' +@strOrderBy





	

PRINT(@strQuery)
EXEC(@strQuery)


/*

SET @strQuery =
+	N'SELECT 	top '+ convert(char(10),@intDivideNum)
+	N'		A.ID as ID,'
+	N'		B.UserName as UserName,'
+	N'		A.SignListName as  SignListName,'
+	N'		A.SignInform as SignInform,'
+	N'		A.listtype as listtype'
+	N'	FROM dbo.WF_SIGNER_LIST A(nolock)'
+	N'	INNER JOIN emanage.dbo.tb_user B'
+	N'	ON A.UserID = B.UserID'
+	N'	where A.listtype in (''S'')'
+	N'	Order By A.UserID desc'

+	N'	'

+	N'SELECT 	top '+ convert(char(10),@intDivideNum)
+	N'		A.ID as ID,'
+	N'		B.DeptName as UserName,'
+	N'		A.SignListName as  SignListName,'
+	N'		A.SignInform as SignInform,'
+	N'		A.listtype as listtype'
+	N'	FROM dbo.WF_SIGNER_LIST A(nolock)'
+	N'	INNER JOIN emanage.dbo.tb_dept B'
+	N'	ON A.UserID = B.DeptID'
+	N'	where A.listtype in (''F'')'
+	N'	Order By A.UserID desc'


	SELECT 	

A.ID as ID,
		B.UserName as UserName,
		A.SignListName as  SignListName,
		A.SignInform as SignInform,
		A.listtype as listtype
	FROM dbo.WF_SIGNER_LIST A(nolock)
	INNER JOIN emanage.dbo.tb_user B
	ON A.UserID = B.UserID
	where A.listtype in ('S')
	Order By A.UserID desc

	SELECT 	A.ID as ID,
		B.DeptName as UserName,
		A.SignListName as  SignListName,
		A.SignInform as SignInform,
		A.listtype as listtype
	FROM dbo.WF_SIGNER_LIST A(nolock)
	INNER JOIN emanage.dbo.tb_dept B
	ON A.UserID = B.DeptID
	where A.listtype in ('F')
	Order By A.UserID desc
*/
RETURN






GO
/****** Object:  StoredProcedure [dbo].[UP_SELECT_WFSIGNERLISTALL_SF]    Script Date: 2015-10-15 오후 1:30:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE    Procedure [dbo].[UP_SELECT_WFSIGNERLISTALL_SF]	
----------------------------------------------------------------------
----------------------------------------------------------------------
-- 작성자: 신철호
-- 작성일: 2005.04.07
-- 수정일: 2005.04.07
-- 설  명: 모든 개인결재선 및 양식결재선을 조회한다. 조직정보와 동기화하기 위해서
-- 테스트: 
/*

EXEC  UP_SELECT_WFSIGNERLISTALL_SF 

*/
----------------------------------------------------------------------

AS
	SELECT 	A.ID as ID,
		B.UserName as UserName,
		A.SignListName as  SignListName,
		A.SignInform as SignInform,
		A.listtype as listtype
	FROM dbo.WF_SIGNER_LIST A(nolock)
	INNER JOIN emanage.dbo.tb_user B
	ON A.UserID = B.UserID
	where A.listtype in ('S')
	Order By A.UserID desc

	SELECT 	A.ID as ID,
		B.DeptName as UserName,
		A.SignListName as  SignListName,
		A.SignInform as SignInform,
		A.listtype as listtype
	FROM dbo.WF_SIGNER_LIST A(nolock)
	INNER JOIN emanage.dbo.tb_dept B
	ON A.UserID = B.DeptID
	where A.listtype in ('F')
	Order By A.UserID desc


RETURN




GO
/****** Object:  StoredProcedure [dbo].[UP_SELECTCOLNAME_FORMCOLUMN]    Script Date: 2015-10-15 오후 1:30:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UP_SELECTCOLNAME_FORMCOLUMN]
	(
		@vcformId			varchar(33),
		@vcfieldName		varchar(50)
	)
AS
	/* SET NOCOUNT ON */
	SELECT COUNT(*) 
	FROM dbo.WF_FORM_INFORM (NOLOCK)
	WHERE
		FORM_ID = @vcformId AND FIELD_NAME = @vcfieldName
RETURN

GO
/****** Object:  StoredProcedure [dbo].[UP_SELECTFOLDERDEPTH_WFFOLDER]    Script Date: 2015-10-15 오후 1:30:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UP_SELECTFOLDERDEPTH_WFFOLDER]
	(
		@folderId varchar(20)
	)
AS
	/* SET NOCOUNT ON */
		SELECT depth 
		FROM dbo.Wf_FOLDER (NOLOCK) 
		WHERE FolderID=@folderId
RETURN 

GO
/****** Object:  StoredProcedure [dbo].[UP_SELECTFOLDERNAME_FOLDER]    Script Date: 2015-10-15 오후 1:30:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UP_SELECTFOLDERNAME_FOLDER]
	(
		@vccommandType		VARCHAR(30),
		@vcfolderId			VARCHAR(33),
		@vcfolderName		varchar(100)
	)
AS
	/* SET NOCOUNT ON */
	IF @vccommandType = 'Create'
		BEGIN
			SELECT COUNT(*) 
			FROM WF_FOLDER (NOLOCK)
			WHERE FOLDERNAME = @vcfolderName	
		END
	ELSE IF @vccommandType = 'Modify'
		BEGIN
			SELECT COUNT(*) 
			FROM WF_FOLDER (NOLOCK)
			WHERE FOLDERNAME = @vcfolderName AND
				FOLDERID <> @vcfolderId
		END 
RETURN 

GO
/****** Object:  StoredProcedure [dbo].[UP_SELECTFORMALIAS_FORMS]    Script Date: 2015-10-15 오후 1:30:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
----------------------------------------------------------------------
----------------------------------------------------------------------
-- 작성자: 조성균
-- 작성일: 2004.03.06
-- 수정일: 2004.03.06
-- 설   명: 폼헤더 생성
-- 테스트 :
-- EXEC  UP_SELECTFORMALIAS_FORMS
----------------------------------------------------------------------
----------------------------------------------------------------------
-- 수정일 : 
-- 수정자 : 
-- 수정내용 : 
----------------------------------------------------------------------
----------------------------------------------------------------------
CREATE PROCEDURE [dbo].[UP_SELECTFORMALIAS_FORMS]
	(
		@vcformId					VARCHAR(33),
		@vcformAlias				VARCHAR(10),
		@vccommandType				VARCHAR(10)
	)
AS
	DECLARE 
		@intCount					int
		
	SET @intCount = 0
	
	IF @vccommandType = 'Create'
		BEGIN
			SET @intCount = 
			(
				SELECT 
					COUNT(*)
					AS Counts
				FROM dbo.WF_FORMS (NOLOCK)
				WHERE FORM_ALIAS = @vcformAlias AND FORM_ALIAS <> ''
			)		
		END 
	ELSE
		BEGIN
			SET @intCount = 
			(
				SELECT 
					COUNT(*)
				FROM dbo.WF_FORMS (NOLOCK)
				WHERE FORM_ALIAS = @vcformAlias AND FORM_ALIAS <> '' AND FORM_ID <>  @vcformId
			)
		END
	SELECT @intCount As Counts
RETURN 

GO
/****** Object:  StoredProcedure [dbo].[UP_SELECTFORMCOLUMN_FORMINFORM]    Script Date: 2015-10-15 오후 1:30:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UP_SELECTFORMCOLUMN_FORMINFORM]
	(
		@formId			varchar(33)
	)
AS
	/* SET NOCOUNT ON */
	SELECT 
		FORM_ID AS FORMID, 
		Field_Name AS NAME, 
		Field_Label AS LABEL, 
		Field_Type AS TYPE, 
		Field_Length AS LENGTH, 
		Field_Default AS DEFAULTVALUE,
		Field_ID AS FIELDID
    FROM dbo.WF_FORM_INFORM (NOLOCK)
    WHERE 
		FORM_ID = @formId
	ORDER BY FIELD_NAME
	RETURN 

GO
/****** Object:  StoredProcedure [dbo].[UP_SELECTFORMCOLUMNINFORM_FORMINFORM]    Script Date: 2015-10-15 오후 1:30:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 CREATE PROCEDURE [dbo].[UP_SELECTFORMCOLUMNINFORM_FORMINFORM]
	(
		@vcfieldId		varchar(33)
	)
AS
	/* SET NOCOUNT ON */
	SELECT 
		Field_Name AS NAME, 
		Field_Label AS LABEL, 
		Field_Type AS TYPE, 
		Field_Length AS LENGTH, 
		Field_Default AS DEFAULTVALUE
    FROM 
		dbo.WF_FORM_INFORM (NOLOCK)
    WHERE 
		FIELD_ID = @vcfieldId
	RETURN

GO
/****** Object:  StoredProcedure [dbo].[UP_SELECTFORMCOLUMNINFORM_SINGLEFORMINFORM]    Script Date: 2015-10-15 오후 1:30:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE  PROCEDURE [dbo].[UP_SELECTFORMCOLUMNINFORM_SINGLEFORMINFORM]
	(
		@vcformId		varchar(33),
		@vcfieldId		varchar(33)
	)
AS
	/* SET NOCOUNT ON */
	SELECT 
		Field_Name AS NAME, 
		Field_Label AS LABEL, 
		Field_Type AS TYPE, 
		Field_Length AS LENGTH, 
		Field_Default AS DEFAULTVALUE
    FROM 
		dbo.WF_FORM_INFORM (NOLOCK)
    WHERE 
		FIELD_ID = @vcfieldId
    AND		Form_ID = @vcformId
	RETURN


GO
/****** Object:  StoredProcedure [dbo].[UP_SELECTFORMCOUNT_FORMS]    Script Date: 2015-10-15 오후 1:30:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
----------------------------------------------------------------------
----------------------------------------------------------------------
-- 작성자: 조성균
-- 작성일: 2004.03.06
-- 수정일: 2004.03.06
-- 설   명: 폼헤더 생성
--        	테스트 :
--		EXEC  UP_SELECTFORMCOUNT_FORMS
----------------------------------------------------------------------
----------------------------------------------------------------------
-- 수정일 : 
-- 수정자 : 
-- 수정내용 : 
----------------------------------------------------------------------
----------------------------------------------------------------------
CREATE PROCEDURE [dbo].[UP_SELECTFORMCOUNT_FORMS]
	(
		@vcCommand					varchar(30),
		@vcFormId					varchar(33),
		@vcKorFormName				varchar(200),
		@vcEngFormName				varchar(200)
	)
AS
	DECLARE 
		@intCount					int
		
	SET @intCount = 0
	
	IF (@vcCommand = 'Modify')
		BEGIN
			SET @intCount = 
			(
				SELECT 
					COUNT(*)
					AS Counts
				FROM dbo.WF_FORMS (NOLOCK)
				WHERE Form_Name = @vcKorFormName AND Form_eName = @vcEngFormName AND FORM_ID <> @vcformId
			)	
		END
	ELSE IF (@vcCommand = 'Create')
		BEGIN
			SET @intCount = 
			(
				SELECT 
					COUNT(*)
					AS Counts
				FROM dbo.WF_FORMS (NOLOCK)
				WHERE Form_Name = @vcKorFormName and Form_eName = @vcEngFormName
			)
		END
	SELECT @intCount As Counts
RETURN 

GO
/****** Object:  StoredProcedure [dbo].[UP_SELECTFORMID_WFFOLDERDETAIL]    Script Date: 2015-10-15 오후 1:30:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UP_SELECTFORMID_WFFOLDERDETAIL]
	@folderId		varchar(20)
AS
	/* SET NOCOUNT ON */
	SELECT FORM_ID
	FROM dbo.WF_FOLDER_DETAIL (NOLOCK)
	WHERE FolderId = @folderId
RETURN 

GO
/****** Object:  StoredProcedure [dbo].[UP_SELREFERENCE_REFINFO_SELECT]    Script Date: 2015-10-15 오후 1:30:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  PROC [dbo].[UP_SELREFERENCE_REFINFO_SELECT]
	@ID varchar(33)
AS
--------------------------------------------------------
-- 작성자 : 안기홍
-- 작성일 : 2004.03.12
-- 수정일 : 2004.03.12
-- 설  명 : 참조자 정보를 select
--------------------------------------------------------
SET NOCOUNT ON
SELECT SignInform, SignerList
  FROM dbo.Wf_SIGNER_LIST(NOLOCK)
 WHERE ID = @ID

GO
/****** Object:  StoredProcedure [dbo].[UP_SELREFERENCE_REFLIST_SELECT]    Script Date: 2015-10-15 오후 1:30:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[UP_SELREFERENCE_REFLIST_SELECT]
	@userID int
AS
--------------------------------------------------------
-- 작성자 : 안기홍
-- 작성일 : 2004.03.12
-- 수정일 : 2004.03.12
-- 설  명 : 참조자 리스트를 select
--------------------------------------------------------
SET NOCOUNT ON
SELECT  ID, 
	SignListName, 
	SignInform, 
	SignerList 
  FROM dbo.Wf_SIGNER_LIST(NOLOCK)
 WHERE UserID = @userID
   AND ListType = 'R'

GO
/****** Object:  StoredProcedure [dbo].[UP_SETFOLDER_INSERT]    Script Date: 2015-10-15 오후 1:30:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UP_SETFOLDER_INSERT]
	(
		@classCode			varchar(20),
		@folderName			varchar(100),
		@folderType			char(1),
		@depth				int,
		@parentFolderId		varchar(20),
		@hasSubFolder		int,
		@description		varchar(1000)
	)
AS
	/* SET NOCOUNT ON */
	INSERT INTO dbo.Wf_FOLDER
	(
		ClassCode, 
		FolderName, 
		FolderType, 
		Depth, 
		ParentFolderID, 
		HasSubFolder, 
		CreateDate, 
		Description 
	)
	VALUES 
	(
		@classCode, 
		@folderName, 
		@folderType, 
		@depth, 
		@parentFolderId,
		@hasSubFolder, 
		GetDate(), 
		@description 
	)
	
	SELECT 
		FOLDERID 
	FROM dbo.WF_FOLDER
	WHERE
		FOLDERNAME		= @folderName		AND 
		FOLDERTYPE		= @folderType		AND 
		PARENTFOLDERID	= @parentFolderId
	RETURN

GO
/****** Object:  StoredProcedure [dbo].[UP_SETFOLDERDELETE_DELETE]    Script Date: 2015-10-15 오후 1:30:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UP_SETFOLDERDELETE_DELETE]
	(
		@folderId varchar(20)
	)
AS
	/* SET NOCOUNT ON */
	DELETE FROM dbo.Wf_FOLDER
    WHERE FolderID = @folderId
	RETURN 

GO
/****** Object:  StoredProcedure [dbo].[UP_SETFOLDERDETAIL_INSERT]    Script Date: 2015-10-15 오후 1:30:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 CREATE PROCEDURE [dbo].[UP_SETFOLDERDETAIL_INSERT]
	(
		@vcfolderId				varchar(20),
		@vcformId				varchar(33)
	)
AS
	/* SET NOCOUNT ON */
	INSERT INTO dbo.WF_FOLDER_DETAIL 
	(
		FOLDERID,
		FORM_ID 
	)
	VALUES 
	(
		@vcfolderId, 
		@vcformId 
	)
	RETURN

GO
/****** Object:  StoredProcedure [dbo].[UP_SETFOLDERUPDATE_UPDATE]    Script Date: 2015-10-15 오후 1:30:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UP_SETFOLDERUPDATE_UPDATE]
	(
		@folderId			varchar(20),
		@classCode			varchar(20),
		@folderName			varchar(100),
		@folderType			char(1),
		@description		varchar(1000)
	)
AS
	/* SET NOCOUNT ON */
		UPDATE dbo.WF_FOLDER 
		SET ClassCode = @classCode, FolderName = @folderName, 
		FolderType = @folderType, Description = @description
		WHERE FolderID=@folderId
RETURN 

GO
/****** Object:  StoredProcedure [dbo].[UP_SIGNERLIST_TEMPAPPLINE]    Script Date: 2015-10-15 오후 1:30:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- 작성자 : 마성옥
-- 하는일 : 양식결재선 리스트를 가져옴
-- 이 SP는 부서아이디와 결재함 타입의 파라메타를 먹고 삽니다.
-- select * from dbo.WF_FOLDER
-- exec dbo.UP_SIGNERLIST_TEMPAPPLINE '1167'
CREATE   PROC [dbo].[UP_SIGNERLIST_TEMPAPPLINE]
	@nDeptID	int
AS
SELECT 	AA.FOLDERNAME, 
		AA.FORM_NAME, 
		AA.FORM_ID, 
  		CASE BB.FORM_ID WHEN AA.FORM_ID THEN 'Y'	ELSE 'N'	END ISEXIST,
  		BB.SignInform  		
FROM (
 	SELECT 	B.FOLDERNAME, 
		A.FOLDERNAME FORM_NAME, 
		D.FORM_ID
 	FROM 	WF_FOLDER A (NOLOCK), 
		WF_FOLDER B (NOLOCK), 
		WF_FOLDER_DETAIL C (NOLOCK), 
		WF_FORMS D (NOLOCK)
 	WHERE 	A.FOLDERTYPE = 'C'
   		AND A.PARENTFOLDERID = B.FOLDERID
   		AND B.FOLDERTYPE IN('A','B')
   		AND A.FOLDERID = C.FOLDERID
   		AND C.FORM_ID = D.FORM_ID
   		AND D.CURRENT_FORMS = 'Y' 
	)AA  
LEFT OUTER JOIN  WF_SIGNER_LIST BB(NOLOCK)
ON ( AA.FORM_ID = BB.FORM_ID
	AND BB.USERID = @nDeptID
	AND LISTTYPE = 'F')
	
	--AND BB.USERID = 10007 -- 부서ID
	--AND LISTTYPE ='F' )
ORDER BY AA.FOLDERNAME
	


GO
/****** Object:  StoredProcedure [dbo].[UP_SINGLEDELETE_FORM]    Script Date: 2015-10-15 오후 1:30:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UP_SINGLEDELETE_FORM]
	(
		@vcformId			VARCHAR(33),
		@vcfieldName		VARCHAR(33)
	)
AS 
	DECLARE
		@vcSql						varchar(2000),
		@vcconstraintName			varchar(2000),
		@vctableName				VARCHAR(100)
		
		SET @vcSql = ''
		
		SET	@vctableName = 'dbo.FORM_' + @vcformId
		
		SET @vcconstraintName = (SELECT NAME
									FROM sysobjects
									WHERE PARENT_OBJ = OBJECT_ID(@vctableName) 
									AND INFO = (
												SELECT TOP 1 COLID
												FROM syscolumns
												WHERE  id = OBJECT_ID(@vctableName)
												AND NAME = @vcfieldName
												)	
								)
		
		
		
		IF @vcconstraintName IS NOT NULL
			BEGIN
				SET @vcSql = N'ALTER TABLE ' + @vctableName + ' DROP CONSTRAINT ' + @vcconstraintName
				--SET @vcSql = N'ALTER TABLE dbo.FORM_' + @vcformId + ' DROP CONSTRAINT DF_FORM_' + @vcformId + '_' + @vcfieldName
				EXEC (@vcSql)
			END 
		
		SET @vcSql = N'ALTER TABLE dbo.FORM_' + @vcformId + ' DROP COLUMN ' + @vcfieldName
		EXEC (@vcSql)
RETURN 

GO
/****** Object:  StoredProcedure [dbo].[UP_SINGLEINSERT_FORM]    Script Date: 2015-10-15 오후 1:30:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UP_SINGLEINSERT_FORM]
	(
		@vcformId				VARCHAR(33),
		@vcfieldName			VARCHAR(100),
		@vcdataType				VARCHAR(100),
		@vcdataLength			VARCHAR(100),
		@vcdefaultValue			VARCHAR(100)
	)
AS 
	DECLARE
		@sql					varchar(2000)
		
		SET @sql = N'ALTER TABLE FORM_' + @vcformId + ' ADD '
		
		IF @vcdataType = 'DATETIME' OR @vcdataType = 'INT' OR @vcdataType = 'TEXT'
			SET @sql = @sql + @vcfieldName + ' ' + @vcdataType + ' NULL'
		ELSE
			SET @sql = @sql + @vcfieldName + ' ' + @vcdataType + '(' + @vcdataLength + ') NULL'
		EXEC (@sql)
		
		IF @vcdefaultValue <> ''
			BEGIN
				SET @sql = N' CONSTRAINT DF_FORM_' + @vcformId + N'_' + @vcfieldName + ' DEFAULT (''' + @vcdefaultValue + ''') FOR [' + @vcfieldName + ']' + CHAR(10)
				SET @sql = N'ALTER TABLE dbo.FORM_' + @vcformId + ' ADD' + char(10) + @sql
				Exec (@sql)
			END 
RETURN

GO
/****** Object:  StoredProcedure [dbo].[UP_SINGLEUPDATE_FORM]    Script Date: 2015-10-15 오후 1:30:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UP_SINGLEUPDATE_FORM]
	(
		@vcformId				VARCHAR(33),
		@vcfieldName			VARCHAR(100),
		@vcdataType				VARCHAR(100),
		@vcdataLength			VARCHAR(100),
		@vcdefaultValue			VARCHAR(100)
	)
AS 
	DECLARE
		@vcSql					VARCHAR(2000),
		@vcdefualtField			VARCHAR(2000),
		@vcconstraintName			varchar(2000),
		@vctableName				VARCHAR(100)
		
		SET	@vctableName = 'dbo.FORM_' + @vcformId
		
		SET @vcconstraintName = (SELECT NAME
									FROM sysobjects
									WHERE PARENT_OBJ = OBJECT_ID(@vctableName) 
									AND INFO = (
												SELECT TOP 1 COLID
												FROM syscolumns
												WHERE  id = OBJECT_ID(@vctableName)
												AND NAME = @vcfieldName
												)	
								)
						  
		IF @vcconstraintName IS NOT NULL
			BEGIN
				SET @vcSql = N'ALTER TABLE ' + @vctableName + ' DROP CONSTRAINT ' + @vcconstraintName
				EXEC (@vcSql)
			END 
		
		IF @vcdataType = 'DATETIME' OR @vcdataType = 'INT' OR @vcdataType = 'TEXT'
			SET @vcSql = N'ALTER TABLE dbo.FORM_' + @vcformId + ' ALTER COLUMN ' + @vcfieldName + ' ' + @vcdataType + ' NULL'
		ELSE
			SET @vcSql = N'ALTER TABLE dbo.FORM_' + @vcformId + ' ALTER COLUMN ' + @vcfieldName + ' ' + @vcdataType + '(' + @vcdataLength + ')' + ' NULL'
		EXEC (@vcSql)
		
		IF @vcdefaultValue <> ''
			BEGIN
				SET @vcSql = N' CONSTRAINT DF_FORM_' + @vcformId + N'_' + @vcfieldName + ' DEFAULT (''' + @vcdefaultValue + ''') FOR [' + @vcfieldName + ']' + CHAR(10)
				SET @vcSql = N'ALTER TABLE dbo.FORM_' + @vcformId + ' ADD' + char(10) + @vcSql
				Exec (@vcSql)
			END 	
RETURN

GO
/****** Object:  StoredProcedure [dbo].[UP_UPDATE_ABSENT_WF_CONFIG_USER]    Script Date: 2015-10-15 오후 1:30:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UP_UPDATE_ABSENT_WF_CONFIG_USER]
	@intUserId			int,
	@intDeptId			int,
	@cIsAbsent			char(1),
	@vcAbsStartDate		varchar(10),
	@vcAbsEndDate		varchar(10),
	@vcAbsReason		varchar(200),
	@intDeputyID		int,
	@intDeputyDeptId	int
	
AS	
	
	if @cIsAbsent = 'N'	
		begin
			set @vcAbsStartDate = null
			set @vcAbsEndDate	= null	
			set @vcAbsReason	= null
			set @intDeputyID		= null
			set	@intDeputyDeptId	= null	
		end
	
	/* SET NOCOUNT ON 	*/
	Update dbo.Wf_CONFIG_USER
	Set ISABSENT = @cIsAbsent,
		ABSENCE_REASON = @vcAbsReason,
		DEPUTYID = @intDeputyID,
		DEPUTYDEPTID = @intDeputyDeptId,
		DEPUTYSTART = isnull(@vcAbsStartDate,null),
		DEPUTYEND = isnull(@vcAbsEndDate,null)
	Where USERID = @intUserId AND DEPTID = @intDeptId
	

GO
/****** Object:  StoredProcedure [dbo].[UP_UPDATE_APRLINEINFORM]    Script Date: 2015-10-15 오후 1:30:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UP_UPDATE_APRLINEINFORM]
@vcProcessID			varchar(33)	--프로세스 OID
AS
----------------------------------------------------
-- 작성자: 신철호
-- 작성일: 2004.03.05
-- 수정일: 2004.03.05
-- 설명 : 결재자정보를 삭제한다
----------------------------------------------------
SET NOCOUNT ON
DELETE FROM dbo.PROCESS_SIGN_INFORM
WHERE PROCESS_INSTANCE_OID = @vcProcessID
	
 

GO
/****** Object:  StoredProcedure [dbo].[UP_UPDATE_ARVALTMAIL_WF_CONFIG_USER]    Script Date: 2015-10-15 오후 1:30:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UP_UPDATE_ARVALTMAIL_WF_CONFIG_USER]
	@intUserId		int,
	@intDeptId		int,
	@cIsArvAltMail	char(1)
AS
	
	Update eWFFORM.dbo.Wf_CONFIG_USER
	Set NOTICEMAIL = @cIsArvAltMail
	Where USERID = @intUserId AND DEPTID = @intDeptId
	

GO
/****** Object:  StoredProcedure [dbo].[UP_UPDATE_ARVALTMESSANGER_WF_CONFIG_USER]    Script Date: 2015-10-15 오후 1:30:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

----------------------------------------------------------------------
----------------------------------------------------------------------
-- 작성자: 신철호
-- 작성일: 2004.03.19
-- 수정일: 2004.03.19
-- 설  명: 
-- 테스트: EXEC  UP_UPDATE_ARVALTMESSANGER_WF_CONFIG_USER
----------------------------------------------------------------------
-- 수정일: 
-- 수정자: 
-- 수정내용 : 
----------------------------------------------------------------------
----------------------------------------------------------------------


CREATE  PROCEDURE [dbo].[UP_UPDATE_ARVALTMESSANGER_WF_CONFIG_USER]

	@intUserId		int,
	@intDeptId		int,
	@cIsArvAltMessanger	char(1)
AS
	
	Update eWFFORM.dbo.Wf_CONFIG_USER
	Set NOTICEMESSANGER = @cIsArvAltMessanger
	Where USERID = @intUserId AND DEPTID = @intDeptId
	




GO
/****** Object:  StoredProcedure [dbo].[UP_UPDATE_DB_APPROVAL_ERROR]    Script Date: 2015-10-15 오후 1:30:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE	Procedure	[dbo].[UP_UPDATE_DB_APPROVAL_ERROR]
		@pFormName		varchar(100) = '',
		@pProcess_ID	varchar(33) = '',
		@pSql			varchar(8000) = '' output
/*

exec dbo.UP_UPDATE_APPROVALSTATUS '200602060001', 'Z28863C7702A04D22882E8E05C226CCF6', '판촉물신청서', 'LC_PROMOTIONREQUEST_DB', '20047533;19845044;19112543;20100948;20200047;19400281', '2006-02-06 15:56:54.000;2006-02-06 16:30:29.183;2006-02-06 16:31:14.623;20
06-02-06 16:58:10.853;2006-02-06 18:07:55.743;2006-02-06 18:24:47.147', '00256;00256;00256;00565;00565;00565', '0017;0016;0009;0017;0015;0013', '6', '_/2500_/_/_/_/_/_/_/END'
select	*
from	ewfform.dbo.wf_form_Y72AEB236B04E460FA3B81DAB9125D58E
order by form_name

Select	*
From	ewf.dbo.work_item
where	Process_Instance_Oid = 'ZCF0B759DD0F943CF99639C4DA03C3895'

exec ewfform.dbo.UP_UPDATE_DB_APPROVAL_ERROR '판매장비이동요청서', 'ZF367897426A04DCFA97C93A74CE51DD9'

exec ewfform.dbo.UP_UPDATE_DB_APPROVAL_ERROR '판매장비설치요청서', 'Z181E4FCC275445BAB68AB8AC643D1FC7'

SELECT	*
FROM	EWFFORM.DBO.WF_FORMS
ORDER BY FORM_NAME

*/

As	

--	Drop	Table	#Data
	Create	Table	#Data
	(
		Doc_Ename		varchar(100),
		ObjectID		varchar(2000),
		Admission_Qty	varchar(8000)
	)

	Declare	@wOrder				datetime,
			@wUserCd			varchar(1000),
			@wCompleted_Date	varchar(1000),
			@wDeptCd			varchar(1000),
			@wJikChaekID		varchar(1000),
			@wItemCnt			int,
			@wCnt				int,
			@wAdmissionQty		varchar(100)

	Select	@wOrder		= '',
			@wUserCd			= '',
			@wCompleted_Date	= '',
			@wDeptCd			= '',
			@wJikChaekID		= '',
			@wCnt				= 1

	--	ObjectID, Doc_Ename, Admission_Qty
	Declare	@wFormID	varchar(100),
			@wDoc_Ename	varchar(100)

	Select	@wFormID = Form_ID,
			@wDoc_Ename = FORM_ENAME
	From	eWFForm.dbo.wf_Forms
	Where	Form_Name = @pFormName
		and	Current_Forms = 'Y'

	If	@wFormID = 'Y6F30F3FABC024516BD3F17E9C253669D'
		Set	@pSql = "
			Insert	Into	#Data
				Select	'" + @wDoc_Ename + "',	ObjectID,	U_ADMISSIONQTY
				From	eWFForm.dbo.Form_" + @wFormID + "
				Where	Process_ID = '" + @pProcess_ID + "'"
	Else if @wFormID = 'YA8A03008E3B44079A4C41705CDA97979'
		Set	@pSql = "
			Insert	Into	#Data
				Select	'" + @wDoc_Ename + "',	ObjectID,	U_Detail_String
				From	eWFForm.dbo.Form_" + @wFormID + "
				Where	Process_ID = '" + @pProcess_ID + "'"
	Else if @wFormID = 'YB9222DABFA484AC6AC97F2A23C649789'
		Set	@pSql = "
			Insert	Into	#Data
				Select	'" + @wDoc_Ename + "',	ObjectID,	U_Detail_String
				From	eWFForm.dbo.Form_" + @wFormID + "
				Where	Process_ID = '" + @pProcess_ID + "'"
	Else if @wFormID = 'YFEA425C4FB9346D0B81C119099FB5F35'
		Set	@pSql = "
			Insert	Into	#Data
				Select	'" + @wDoc_Ename + "',	ObjectID,	U_ADMISSIONQTY
				From	eWFForm.dbo.Form_" + @wFormID + "
				Where	Process_ID = '" + @pProcess_ID + "'"
	Else if @wFormID = 'Y5149C2A149D24EADA29D306082EBA5F3'
		Set	@pSql = "
			Insert	Into	#Data
				Select	'" + @wDoc_Ename + "',	ObjectID,	U_ADMISSIONQTY
				From	eWFForm.dbo.Form_" + @wFormID + "
				Where	Process_ID = '" + @pProcess_ID + "'"
	Else if @wFormID = 'YB68D2E23A8F74970967B4D08912F0B9C'
		Set	@pSql = "
			Insert	Into	#Data
				Select	'" + @wDoc_Ename + "',	ObjectID,	U_FAC_OPINION_IN_TEXTAREA
				From	eWFForm.dbo.Form_" + @wFormID + "
				Where	Process_ID = '" + @pProcess_ID + "'"
	Else if @wFormID = 'Y35CED4073A514D94875F61A63FBE3666'
		Set	@pSql = "
			Insert	Into	#Data
				Select	'" + @wDoc_Ename + "',	ObjectID,	U_FAC_OPINION_IN_TEXTAREA
				From	eWFForm.dbo.Form_" + @wFormID + "
				Where	Process_ID = '" + @pProcess_ID + "'"
	Else if @wFormID = 'Y8410F34EDFE44A6098AF6F9938C8F8C2'
		Set	@pSql = "
			Insert	Into	#Data
				Select	'" + @wDoc_Ename + "',	ObjectID,	U_FAC_OPINION_IN_TEXTAREA
				From	eWFForm.dbo.Form_" + @wFormID + "
				Where	Process_ID = '" + @pProcess_ID + "'"
	Else if @wFormID = 'Y462E36DD55F74F098C8A3D141BB0FCCF'
		Set	@pSql = "
			Insert	Into	#Data
				Select	'" + @wDoc_Ename + "',	ObjectID,	U_FAC_OPINION_IN_TEXTAREA
				From	eWFForm.dbo.Form_" + @wFormID + "
				Where	Process_ID = '" + @pProcess_ID + "'"
	Else if @wFormID = 'Y72AEB236B04E460FA3B81DAB9125D58E'
		Set	@pSql = "
			Insert	Into	#Data
				Select	'" + @wDoc_Ename + "',	ObjectID,	U_STR_ITEMPOINT
				From	eWFForm.dbo.Form_" + @wFormID + "
				Where	Process_ID = '" + @pProcess_ID + "'"
	Else
		Set	@pSql = "
			Insert	Into	#Data
				Select	'" + @wDoc_Ename + "',	ObjectID,	''
				From	eWFForm.dbo.Form_" + @wFormID + "
				Where	Process_ID = '" + @pProcess_ID + "'"

--	print @psql
	Exec (@pSql)

	--	결재상태
	Declare	@wStatus	char(1)
	Set	@wStatus = '1'

	If	Exists	(Select	1	From	eWF.dbo.Work_Item
				Where	Name like '일반결재자%'
					and	Process_Instance_Oid = @pProcess_ID)
		Set	@wStatus = '2'	

	If	Exists	(Select	1	From	eWF.dbo.Work_Item
				Where	Participant_Name = '발신함'
					and	Process_Instance_Oid = @pProcess_ID)
		Set	@wStatus = '3'

	If	Exists	(Select	1	From	eWF.dbo.Work_Item
				Where	(Participant_Name = '신청처리함' or Participant_Name like '품의함%')
					and	Process_Instance_Oid = @pProcess_ID)
		Set	@wStatus = '6'

	If	Exists	(Select	1	From	eWF.dbo.Work_Item
				Where	Process_Instance_View_State = '8'
					and	Process_Instance_Oid = @pProcess_ID)
		Set	@wStatus = '7'


	--	결재자정보 Loop
	Select	@wItemCnt = Count(1)
	From	eWF.dbo.Work_Item w
	Where	w.Process_Instance_Oid = @pProcess_ID
		and	(w.Name like '기안%' or w.Name like '일반결재자%')
		and	w.Completed_Date is Not Null

	While	(1 = 1)
	Begin

		Select	top 1
				@wOrder = w.Completed_Date,
				@wUserCd = @wUserCd + u.UserCd,
				@wCompleted_Date = @wCompleted_Date + Convert(varchar, w.Completed_Date, 121),
				@wDeptCd = @wDeptCd + d.DeptCd,
				@wJikChaekID = @wJikChaekID + h.JikChaekID
		From	eWF.dbo.Process_Instance p
				Join	eWF.dbo.Work_Item w
					On	w.Process_Instance_Oid = p.Oid
					and	(w.Name like '기안%' or w.Name like '일반결재자%')
				Join	eManage.dbo.TB_User u
					On	u.UserId = w.Participant_Id
				Join	eManage.dbo.TB_Dept_User_History h
					On	h.userid = u.userid
					and	Convert(char(8), h.EndDate, 112) = '99991231'
--					and	h.PositionOrder = 1
				Join	eManage.dbo.TB_Dept d
					On	d.DeptId = h.DeptID
		Where	p.Oid = @pProcess_ID
			and	w.Completed_Date > @wOrder
			and	w.Completed_Date is Not Null
			and	h.JikChaekID is Not Null
		Order by w.Completed_Date
	
		If	@@RowCount = 0
		Begin
			Break
		End
		Else If	@wCnt < @wItemCnt
		Begin
	
			Select	@wUserCd = @wUserCd + ';',
					@wCompleted_Date = @wCompleted_Date + ';',
					@wDeptCd = @wDeptCd + ';',
					@wJikChaekID = @wJikChaekID + ';'
	
		End

		Set	@wCnt = @wCnt + 1
	End

	Select	@pSql = 
				"exec LeCom.dbo.UP_UPDATE_APPROVALSTATUS '"
				+ ObjectID + "', '"
				+ @pProcess_ID + "', '"
				+ Doc_Ename + "', '"
				+ @pFormName + "', '"
				+ @wUserCd + "', '"
				+ @wCompleted_Date + "', '"
				+ @wDeptCd + "', '"
				+ @wJikChaekID + "', '"
				+ @wStatus + "', '"
				+ Admission_Qty + "'"
	From	#Data

	Select	@pSql 














GO
/****** Object:  StoredProcedure [dbo].[UP_UPDATE_DOCUMENT_FORM_DATA]    Script Date: 2015-10-15 오후 1:30:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UP_UPDATE_DOCUMENT_FORM_DATA]
(
	@FORM_ID		VARCHAR(50),
	@PROCESS_ID		VARCHAR(50),
	@COL_SQL		TEXT
)
AS
-------------------------------------------------------------------------------------
-- 작성자: 임병태
-- 작성일: 2004.03.15
-- 수정일: 2004.03.15
-- 설명 : 양식 폼을 수정한다.
-------------------------------------------------------------------------------------
	EXEC "UPDATE dbo.FORM_" --+ @FORM_ID --+ ' WITH(ROWLOCK) SET ' + @COL_SQL + ' WHERE PROCESS_ID =' + @PROCESS_ID 
	

GO
/****** Object:  StoredProcedure [dbo].[UP_UPDATE_FOLDERDEPTH]    Script Date: 2015-10-15 오후 1:30:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE  PROCEDURE [dbo].[UP_UPDATE_FOLDERDEPTH]
(
	@FolderId  		VARCHAR(100)
)	
AS	
	UPDATE dbo.WF_FOLDER SET DEPTH  = DEPTH +1 WHERE FOLDERID = @FolderId
	
RETURN

GO
/****** Object:  StoredProcedure [dbo].[UP_UPDATE_FORM_COLUMN]    Script Date: 2015-10-15 오후 1:30:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

/*

exec dbo.UP_UPDATE_FORM_COLUMN	'Y9FA891C60DF54882BAE0DA51F233AF69', 'Z7F6AADF192D64399946AEB26DCB691E7', 'U_AGREE_DEPT_COMMENT', '영업정보팀!@'
Select	*	from	form_Y5770BC516ABC4E6881567B3AB08F2638	where	process_id = 'Z7F6AADF192D64399946AEB26DCB691E7'

select	
*/

Create	Procedure	[dbo].[UP_UPDATE_FORM_COLUMN]
		@pProcessID		varchar(33),
		@pColumnValue	varchar(1000)

As

	Select	@pProcessID = IsNull(Ltrim(Rtrim(@pProcessID)), '')

	Declare	@wFormID	varchar(33),
			@wColumn	varchar(33),
			@wSql		varchar(1000)

	If	@wFormID in ('Y28B72F2F7EE54FB5BE13E8F2A3637978', 'YFA4BC440266849EB8DBA1A1FE7C55EE6', 'YB132CCF992074F738816938A12F7B758')	--	운영
--	If	@wFormID in ('Y9FA891C60DF54882BAE0DA51F233AF69', 'Y2C2E2C72B0B24A3782D8BCAA162C52E6', 'Y5770BC516ABC4E6881567B3AB08F2638')
	Begin

		Select	@wFormID = Form_ID
		From	eWFForm.dbo.WF_Forms_Prop
		Where	Process_ID = @pProcessID

		Set	@wColumn = 'U_AGREE_DEPT_COMMENT'


		Set	@wSql = "
			Update	eWFForm.dbo.Form_" + @wFormID + "
			Set		" + @wColumn + " = '" + @pColumnValue + "'
			Where	Process_ID = '" + @pProcessID + "'"

	End

--	Exec (@wSql)



GO
/****** Object:  StoredProcedure [dbo].[UP_UPDATE_FORM_UPFILE]    Script Date: 2015-10-15 오후 1:30:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO







----------------------------------------------------------------------
----------------------------------------------------------------------
-- 작성자 : LDCC 신상훈
-- 작성일 : 2004.09.30
-- 수정일 : 2004.09.30
-- 설   명 : 결재중 첨부파일 추가
-- 테스트 : exec dbo.UP_UPDATE_FORM_UPFILE 'YCA3020E01B3845C5BB17651DD2B32731', 'Z4861F211E3A54F8AA758F75531038380', '166'

-- truncate table eWFFORM.dbo.WF_DOC_NUMBER

----------------------------------------------------------------------
-- 수정일 : 
-- 수정자 : 
-- 수정내용 : 
----------------------------------------------------------------------

CREATE       PROCEDURE [dbo].[UP_UPDATE_FORM_UPFILE]
	/* Param List */	
	
	@vcFormId		varchar(33),
	@vcProcessId		varchar(33),
	@vcAttachId		varchar(500),
	@vcIsAttach		char(1),
	@vcAttachExtension	varchar(500)
	
AS	

DECLARE 
  	@vcAttachId_Old		varchar(400),
	@vcAttachId_New		varchar(700),
	@vcAttachExtension_Old	varchar(200),
	@vcAttachExtension_New 	varchar(700),
	@sql			nvarchar(2000),
  	@nvcCountQuery      	nvarchar(4000)


----------------------------------------------------------------------------------------
-- 설    명 : 기존에 저장되어 있던 첨부파일 ID를 뽑아낸다.
----------------------------------------------------------------------------------------
create table #tmp (attachId varchar(400))

SET @sql = 	N'	SELECT upfile FROM eWFFORM.dbo.FORM_' + @vcFormId
+		N'	WHERE PROCESS_ID = ''' + @vcProcessId + ''''

insert into #tmp
exec (@sql)
SET @sql = ''	-- 변수 초기화

SET @vcAttachId_Old = (select attachid from #tmp)
drop table #tmp

SET @vcAttachExtension_Old = (SELECT ATTACH_EXTENSION
				FROM eWFFORM.dbo.WF_FORMS_PROP 
				       WHERE PROCESS_ID = @vcProcessId)

----------------------------------------------------------------------------------------
-- 설    명 : 기존에 첨부파일이 없으면
----------------------------------------------------------------------------------------
IF @vcAttachId_Old = ''
begin
	----------------------------------------------------------------------------------------
	-- 테이블에 저장할 첨부파일ID를 그냥 사용한다.
	----------------------------------------------------------------------------------------
	SET	@vcAttachId_New = @vcAttachId 
	SET	@vcAttachExtension_New = @vcAttachExtension
end

----------------------------------------------------------------------------------------
-- 설    명 : 기존에 첨부파일이 있으면
----------------------------------------------------------------------------------------
IF @vcAttachId_Old <> ''
begin
	----------------------------------------------------------------------------------------
	-- 테이블에 저장할 첨부파일ID를 예전에 있던 첨부파일과 결합해서 사용한다.
	----------------------------------------------------------------------------------------
	SET	@vcAttachId_New = @vcAttachId_Old + '|' + @vcAttachId 
	SET	@vcAttachExtension_New = @vcAttachExtension_Old + '|' + @vcAttachExtension 
end

----------------------------------------------------------------------------------------
-- 설    명 : 새로 구성한 첨부파일ID를 Form_ 테이블에 UPDATE시킨다.
----------------------------------------------------------------------------------------
SET @nvcCountQuery = 	N'	UPDATE eWFFORM.dbo.FORM_' + @vcFormId
+			N'	SET UPFILE = ''' + @vcAttachId_New + ''''
+			N'	,HASATTACH = ''Y'''
+			N'	WHERE PROCESS_ID = ''' + @vcProcessId + ''''

exec (@nvcCountQuery)
SET @nvcCountQuery = '' -- 변수 초기화




----------------------------------------------------------------------------------------
-- 설    명 : 새로 구성한 첨부파일ID를 WF_FORMS_PROP 테이블에 UPDATE시킨다.
--	    Documentlist.aspx의 리스트에 첨부한 내용이 보여야 하므로 
----------------------------------------------------------------------------------------
UPDATE eWFFORM.dbo.WF_FORMS_PROP
      SET ISATTACHFILE = @vcIsAttach, ATTACH_EXTENSION = @vcAttachExtension_New
	WHERE PROCESS_ID = @vcProcessId


----------------------------------------------------------------------------------------
-- 설    명 : 다중수신부서가 선택되어 있는 양식은 해당 안됨
----------------------------------------------------------------------------------------
DECLARE @cMultiRcvCheck char(1)

SET @cMultiRcvCheck = (SELECT MULTI_RCV_YN
			FROM eWFFORM.dbo.WF_FORM_SCHEMA
			      WHERE FORM_ID = @vcFormId)

IF @cMultiRcvCheck <> 'Y'
begin
	
	----------------------------------------------------------------------------------------
	-- 설    명 : 만약 현재 첨부가 부서합의시에 첨부한 문서라면 기안자의 부서에서도 첨부파일이 보이도록 
	--	    eWF.dbo.PROCESS_INSTANCE 테이블을 조회하여 Parent_Oid를 찾아 해당하는 ProcessID
	--	    를 가진 것을 찾아 FORM_ 테이블에 넣어준다.
	----------------------------------------------------------------------------------------
	DECLARE @vcProcessOid 	varchar(33)
	
	SET @vcProcessOid = (SELECT PARENT_OID 
				FROM eWF.dbo.PROCESS_INSTANCE (NOLOCK)
				      WHERE OID=@vcProcessId)
	
	
	----------------------------------------------------------------------------------------
	-- 설    명 : 만약 ProcessOid가 들어있다면 해당 Oid를 Form_ 테이블에서 찾아 업데이트 시켜준다.
	----------------------------------------------------------------------------------------
	IF @vcProcessOid <> ''
	begin
		SET @vcAttachId_Old  = ''
		SET @vcAttachId_New = ''
		SET @vcAttachExtension_Old = ''	
		SET @vcAttachExtension_New = ''
	
		
		CREATE TABLE #tmp2 (attachId varchar(200))
		SET @sql = 	N'	SELECT upfile FROM eWFFORM.dbo.FORM_' + @vcFormId
		+		N'	WHERE PROCESS_ID = ''' + @vcProcessOid + ''''
		INSERT INTO #tmp2
		EXEC (@sql)	
		SET @vcAttachId_Old = (select attachid from #tmp2)
		DROP TABLE #tmp2
		SET @sql = ''	-- 변수 초기화
	
		----------------------------------------------------------------------------------------
		-- 설    명 : 기존에 첨부파일이 없으면
		----------------------------------------------------------------------------------------
		IF @vcAttachId_Old = ''
		begin
			----------------------------------------------------------------------------------------
			-- 테이블에 저장할 첨부파일ID를 그냥 사용한다.
			----------------------------------------------------------------------------------------
			SET	@vcAttachId_New = @vcAttachId 
			SET	@vcAttachExtension_New = @vcAttachExtension
		end
		
		----------------------------------------------------------------------------------------
		-- 설    명 : 기존에 첨부파일이 있으면
		----------------------------------------------------------------------------------------
		IF @vcAttachId_Old <> ''
		begin
			----------------------------------------------------------------------------------------
			-- 테이블에 저장할 첨부파일ID를 예전에 있던 첨부파일과 결합해서 사용한다.
			----------------------------------------------------------------------------------------
			SET	@vcAttachId_New = @vcAttachId_Old + '|' + @vcAttachId 
			SET	@vcAttachExtension_New = @vcAttachExtension_Old + '|' + @vcAttachExtension 
		end
		
		SET @nvcCountQuery = 	N'	UPDATE eWFFORM.dbo.FORM_' + @vcFormId
	+				N'	SET UPFILE = ''' + @vcAttachId_New + ''''
	+				N'	,HASATTACH = ''Y'''
	+				N'	WHERE PROCESS_ID = ''' + @vcProcessOid + ''''
	
		exec (@nvcCountQuery)
		SET @nvcCountQuery = '' -- 변수 초기화
	
		----------------------------------------------------------------------------------------
		-- 설    명 : 새로 구성한 첨부파일ID를 WF_FORMS_PROP 테이블에 UPDATE시킨다.
		--	    Documentlist.aspx의 리스트에 첨부한 내용이 보여야 하므로 
		----------------------------------------------------------------------------------------
		UPDATE eWFFORM.dbo.WF_FORMS_PROP
		      SET ISATTACHFILE = @vcIsAttach, ATTACH_EXTENSION = @vcAttachExtension_New
			WHERE PROCESS_ID = @vcProcessOid
	
	end

end
RETURN







GO
/****** Object:  StoredProcedure [dbo].[UP_UPDATE_FORMDEFAULTFIELD]    Script Date: 2015-10-15 오후 1:30:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
   CREATE 
PROCEDURE [dbo].[UP_UPDATE_FORMDEFAULTFIELD]
         (@vcFIELD_NAME    VARCHAR(30) = ''
         ,@cFIELD_CLASS       CHAR( 1) = ''
         ,@vcFIELD_LABEL   VARCHAR(30) = ''
         ,@vcFIELD_TYPE    VARCHAR(30) = ''
         ,@dFIELD_LENGTH   DECIMAL( 9) = -1
         ,@vcFIELD_DEFAULT VARCHAR(50)
         ,@vcFIELD_ID		VARCHAR(50) = ''
         )
       AS 
-- <pre-Step : 환경설정>
SET NOCOUNT ON
-- <Step-0-0 : 파라미터 확인>
IF(@vcFIELD_NAME='' OR @cFIELD_CLASS='' OR @vcFIELD_LABEL='' OR
   @vcFIELD_TYPE='' OR @dFIELD_LENGTH<0 OR @vcFIELD_ID = '') BEGIN
    RAISERROR('EC0|필수 파라미터가 부족합니다.', 16, 1)
         WITH NOWAIT
    GOTO END_PROC
END
--<Step-1-0 : 데이터 존재 확인>
IF NOT EXISTS(SELECT * 
                FROM Wf_FORM_DEFAULT_FIELD
               WHERE FIELD_ID = @vcFIELD_ID) BEGIN
    RAISERROR('EC1|수정대상 데이터가 존재하지 안습니다.', 16, 1)
         WITH NOWAIT
    GOTO END_PROC
END
-- <Step-1-1 : 데이터 수정>
UPDATE Wf_FORM_DEFAULT_FIELD
   SET FIELD_NAME	 = @vcFIELD_NAME
	  ,FIELD_CLASS   = @cFIELD_CLASS
      ,FIELD_LABEL   = @vcFIELD_LABEL
      ,FIELD_TYPE    = @vcFIELD_TYPE
      ,FIELD_LENGTH  = @dFIELD_LENGTH
      ,FIELD_DEFAULT = @vcFIELD_DEFAULT
 WHERE FIELD_ID = @vcFIELD_ID
IF @@ERROR <> 0 BEGIN
    RAISERROR('EU1|데이터수정 작업중 오류가 발생했습니다.', 16, 1)
         WITH NOWAIT
    GOTO END_PROC
END
END_PROC:
-- <post-Step : 환경설정>
SET NOCOUNT OFF
RETURN

GO
/****** Object:  StoredProcedure [dbo].[UP_UPDATE_FORMS_PROP]    Script Date: 2015-10-15 오후 1:30:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UP_UPDATE_FORMS_PROP]
(
	@PROCESS_ID			VARCHAR(50),	-- 프로세스 ID
	@INNERHTML			TEXT,			-- 문서내용
	@KEEP_YEAR			VARCHAR(50),	-- 보존연한
	@DOC_LEVEL			VARCHAR(50),	-- 문서등급
	@DOC_NAME			VARCHAR(50),	-- 문서명
	@SUBJECT			VARCHAR(500),	-- 문서제목
	@ISATTACHFILE		VARCHAR(50),	-- 첨부파일 여부
	@DOC_NUMBER			VARCHAR(100),	-- 문서번호
	@STATUS				VARCHAR(10),	-- 상태
	@ISURGENT			VARCHAR(10),	-- 긴급문서 여부
	@POSTSCRIPT			VARCHAR(10)		-- 첨언 여부
)
AS
 
			UPDATE dbo.WF_FORMS_PROP 
			SET INNERHTML		= @INNERHTML,
				KEEP_YEAR		= @KEEP_YEAR, 
				DOC_LEVEL		= @DOC_LEVEL, 
				DOC_NAME		= @DOC_NAME, 
				SUBJECT			= @SUBJECT, 
				ISATTACHFILE	= @ISATTACHFILE, 
				DOC_NUMBER		= @DOC_NUMBER, 
				STATUS			= @STATUS, 
				ISURGENT		= @ISURGENT, 
				POSTSCRIPT		= @POSTSCRIPT
			WHERE PROCESS_ID = @PROCESS_ID

GO
/****** Object:  StoredProcedure [dbo].[UP_UPDATE_FORMS_PROP_POSTSCRIPT]    Script Date: 2015-10-15 오후 1:30:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
----------------------------------------------------
-- 작성자: 김기수
-- 작성일: 2005.05.10
-- 수정일: 2005.05.10
-- 설명 : 첨언정보 업데이트
----------------------------------------------------
--EXEC dbo.UP_UPDATE_FORMS_PROP_POSTSCRIPT 'ZE3F9BCA51193434698AF5FA0FFB94E7B','N'
--SELECT * FROM dbo.WF_FORMS_PROP WHERE PROCESS_ID ='ZE3F9BCA51193434698AF5FA0FFB94E7B'
------------------------------------------------------


CREATE  PROCEDURE [dbo].[UP_UPDATE_FORMS_PROP_POSTSCRIPT]
(
	@PROCESS_ID			VARCHAR(50),	-- 프로세스 ID
	@POSTSCRIPT			VARCHAR(10)		-- 첨언 여부
)
AS
 
			UPDATE dbo.WF_FORMS_PROP 
			SET POSTSCRIPT		= @POSTSCRIPT
			WHERE PROCESS_ID = @PROCESS_ID


GO
/****** Object:  StoredProcedure [dbo].[up_update_htmldescriot]    Script Date: 2015-10-15 오후 1:30:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE	procedure	[dbo].[up_update_htmldescriot]
		@pProcessID	char(33)


/*

select *
from dbo.FORM_YAE7EEC57433B4884AAC95B65128C3F0A
where process_id = 'Z0A5641C5C19848BCBA70696DE0640EAC'

order by suggestdate

begin tran
commit
rollback

exec up_update_htmldescriot Z76DF0E6589A24903930B4C1B7E19EB4B
exec up_update_htmldescriot Z0A5641C5C19848BCBA70696DE0640EAC
exec up_update_htmldescriot ZF51D0472E0AA484386D01F354E8F186C
exec up_update_htmldescriot Z0C0BF0C1DE144BA9801A1E9E49008CFA
exec up_update_htmldescriot Z630CDD43E1D649538998940E7AEB9F95
exec up_update_htmldescriot Z4BD81B5AB7CF449C8C4DCE87702E26CB
exec up_update_htmldescriot Z6FB71387910C434794D8546D19ADB21F
exec up_update_htmldescriot ZF59B251766E24034839C4CB4840D900C
exec up_update_htmldescriot ZF934FE3BE5134C3C9B3DD633075C2B51
exec up_update_htmldescriot ZC9B69E0DC6F54E9A87E8FA9042D65B4C
exec up_update_htmldescriot Z2185B0AE151A4F79A73533C9BCBDCF85
exec up_update_htmldescriot Z1491D8CA809547629DB48A6FE3CAA5A0
exec up_update_htmldescriot Z3E66FEFDA0AF4B8DAFDE93CD46554D19
exec up_update_htmldescriot ZA53B963DFF8C4A5794A10948899A6993
exec up_update_htmldescriot ZC1C3B1847EAD4D8BBABEBE05458C37EE
exec up_update_htmldescriot Z58E952432DB94E0DA1728770EBAE8C74
exec up_update_htmldescriot Z94CCC81653904F0E93174D9370D57BE9
exec up_update_htmldescriot ZCF53D03375FE4143AE8737E5A83FEF1C
exec up_update_htmldescriot ZC7D13D05A88F42C092BE00AC365AAC75
exec up_update_htmldescriot Z0130A5E29A7349BAACE5261ADF6A5199
exec up_update_htmldescriot ZB7BEA4C0AA824A1A8D40D1B9C65B2EE5
exec up_update_htmldescriot ZC7428BEBE6174A9F93F21D7763361A93
exec up_update_htmldescriot ZB3B46533C1FA4F0A9419D8F42611A67C
exec up_update_htmldescriot ZF318632603374C45ACC8BFED759D55F1
exec up_update_htmldescriot ZE6323F51FA6942CAA47107C8F7ACD01E
exec up_update_htmldescriot ZE10C424CF42F459194C134F9DEADC13E
exec up_update_htmldescriot ZFDAB480481264473B750E77572797987
exec up_update_htmldescriot ZE874B465EB9047CB94BDB6E9AA67CFE4
exec up_update_htmldescriot Z7438976C12FD47F4B9D84C803064005E
exec up_update_htmldescriot ZD38015F2209F47C1AAC2A67AE6FC3F09
exec up_update_htmldescriot Z9F4FBD17BBCF4A77820B76FF02AE391D
exec up_update_htmldescriot Z2A625C5F68AE4612A16D0677F7471ED3
exec up_update_htmldescriot Z0C535238EBD9415FBE75BC5EB24A2E14
exec up_update_htmldescriot Z93E858F7B8D64DE895714BE9FB53C869
exec up_update_htmldescriot Z19999BB01B0D4DD08632964628AAA184
exec up_update_htmldescriot ZCE766BF2E65C4076A9D276908ED45BA5
exec up_update_htmldescriot ZD9F18ADCC5974DB9ACB3741F9B6664D8
exec up_update_htmldescriot Z62B413E86F9748E49527FF4990447E07
exec up_update_htmldescriot ZC9C30248D8F54F268A8DD706D986884D
exec up_update_htmldescriot Z13247F63ACF64BA38F35ECFB5715D8AE
exec up_update_htmldescriot Z5D25C638E7F64FA28B204DBB1E9A2CA3
exec up_update_htmldescriot Z84647A30C3A14334A5DDB8D118880B54
exec up_update_htmldescriot ZAABA3364E71948A59CEE37319BC7FCF1
exec up_update_htmldescriot ZD557D2E0081B43B8965EF9FAC2AE9808
exec up_update_htmldescriot ZE48AB9EB4A1D470882D896E83A0A2A92
exec up_update_htmldescriot ZC60A72CFDA774505BF68D77064F52538
exec up_update_htmldescriot Z686C7337A19D49428470A82526520A53
exec up_update_htmldescriot ZCABABB7C7396469B9E1B43175788ED5C
exec up_update_htmldescriot ZFBFF2940200B40488B5D4F47E2557AF2
exec up_update_htmldescriot Z73FFAF27583C4EF58D11A392021ED46E
exec up_update_htmldescriot ZB12BFA6F32F64994BDD95334D851F8E8
exec up_update_htmldescriot Z91EC0C2381524FC1AC01F13459DEB488
exec up_update_htmldescriot ZE105FC6A9368463CA5DD2A92093930A2
exec up_update_htmldescriot Z89C67A362C7D41AC825366CF051307E2
exec up_update_htmldescriot ZA15CEE4931AB48729906EF73C01D47AA
exec up_update_htmldescriot Z24104897C7C344EBBEFA9B0C2C1A0BB5
exec up_update_htmldescriot Z3FCB045B90754530ABBA306D4C760B5C
exec up_update_htmldescriot Z7737B6BBECFB40D491C3AF090E9454E2
exec up_update_htmldescriot Z14A2EA354B264FBD9A846B8F204EEA29
exec up_update_htmldescriot ZB027CB4F4B9644ACB26AFFD7391DEF82
exec up_update_htmldescriot Z1F776B1C1AFB460DA397342513E3A76E
exec up_update_htmldescriot Z5F07E30927474941ADD5E2100E73D413
exec up_update_htmldescriot ZC81BDA404E954E0397C129C893FE45F4
exec up_update_htmldescriot ZC86AA1FEA2AB4BA98165B2DB34964716
exec up_update_htmldescriot ZF677F49FC0224013A0E5F299B90A9821
exec up_update_htmldescriot ZF4D1B3C8C4A541F5B01C0EBDD40EEC1D
exec up_update_htmldescriot ZCC2C979F8A5549C5BBC77E992729FE7F
exec up_update_htmldescriot Z12AFEEBA021C4EB4B59216E80B5D9E07

*/


as

	update	dbo.FORM_YAE7EEC57433B4884AAC95B65128C3F0A
	set		u_bodycontent1 = 
				convert(text, replace(substring(u_bodycontent1, 1, 8000), '<br />(제작사/거래처)', '') + substring(u_bodycontent1, 8001, 8000) + substring(u_bodycontent1, 16001, 8000))
	where	process_id =	@pProcessID







GO
/****** Object:  StoredProcedure [dbo].[UP_UPDATE_PCONF_WF_SIGNER_FOLDER]    Script Date: 2015-10-15 오후 1:30:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





CREATE      PROCEDURE [dbo].[UP_UPDATE_PCONF_WF_SIGNER_FOLDER]
(	
	@SIGN_OID			VARCHAR(33),	-- 현결재자의 OID
	@PROCESS_INSTANCE_OID	VARCHAR(33),	-- 프로세스 인스탄스 OID
	@ACTION_TYPE			CHAR(1)		-- 결재상태	
)
AS
-------------------------------------------------------------------------------------
-- 작성자: 신철호
-- 작성일: 2005.04.11
-- 수정일: 2005.04.19
-- 설명 : 개인합의자들 결재상태를 변경한다.
-- 수정내용 : 대결자 부분 적용한다.
/*
     EXEC dbo.UP_UPDATE_PCONF_WF_SIGNER_FOLDER '','ZC0CA1F121F414A71B5535E5A9CE67304', '1'
*/
-------------------------------------------------------------------------------------

	DECLARE @iSEQ int,
		 @SIGN_TYPE			CHAR(2)

	
	IF @ACTION_TYPE = '1'			--현결재자로 변경
	   BEGIN

		--현결재자 결재종류를 조회한다.
		SELECT 	@SIGN_TYPE = SIGN_TYPE,
			@iSEQ = SIGN_SEQ
		FROM dbo.WF_SIGNER_FOLDER(NOLOCK)
		WHERE SIGN_OID = @SIGN_OID
		
		IF @SIGN_TYPE <> '04'		--대결이 아닌경우
		   BEGIN
			
			UPDATE dbo.WF_SIGNER_FOLDER
			SET ACTION_TYPE = '0'
			WHERE SIGN_OID = @SIGN_OID		
			
			UPDATE dbo.WF_SIGNER_FOLDER
			SET ACTION_TYPE = @ACTION_TYPE
			WHERE PROCESS_INSTANCE_OID = @PROCESS_INSTANCE_OID
			AND SIGN_CATEGORY = '04'
		   END
		ELSE IF @SIGN_TYPE = '04'	--대결인 경우
		   BEGIN
			SET @iSEQ = @iSEQ + 1

			--대결자
			UPDATE dbo.WF_SIGNER_FOLDER
			SET ACTION_TYPE = '0'
			WHERE SIGN_OID = @SIGN_OID

			--후열(후결)자
			UPDATE dbo.WF_SIGNER_FOLDER
			SET ACTION_TYPE = '0'
			WHERE PROCESS_INSTANCE_OID = @PROCESS_INSTANCE_OID
			AND SIGN_SEQ = @iSEQ
			
			UPDATE dbo.WF_SIGNER_FOLDER
			SET ACTION_TYPE = @ACTION_TYPE
			WHERE PROCESS_INSTANCE_OID = @PROCESS_INSTANCE_OID
			AND SIGN_CATEGORY = '04'
		   END
	   END
	ELSE IF @ACTION_TYPE = '0'
 	   BEGIN
		SELECT @iSEQ = MAX(SIGN_SEQ) 
		FROM dbo.WF_SIGNER_FOLDER(NOLOCK) 
		WHERE PROCESS_INSTANCE_OID = @PROCESS_INSTANCE_OID
		AND SIGN_CATEGORY = '04'

		SET @iSEQ = @iSEQ + 1
		

		UPDATE dbo.WF_SIGNER_FOLDER
		SET ACTION_TYPE = @ACTION_TYPE
		WHERE PROCESS_INSTANCE_OID = @PROCESS_INSTANCE_OID
		AND SIGN_CATEGORY = '04'

		UPDATE dbo.WF_SIGNER_FOLDER
		SET ACTION_TYPE = '1'
		WHERE PROCESS_INSTANCE_OID = @PROCESS_INSTANCE_OID
		AND SIGN_SEQ = @iSEQ
		
	   END


	



GO
/****** Object:  StoredProcedure [dbo].[UP_UPDATE_REFERENCER_CONFIRM]    Script Date: 2015-10-15 오후 1:30:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



/*

CREATE	TABLE	dbo.WF_REFERENCER_CONFIRM
(
	PROCESS_INSTANCE_OID	CHAR(33),
	CONFIRM_USERID			INT,
	CONFIRM_DATE			DATETIME

	CONSTRAINT PK_WF_REFERENCER_CONFIRM PRIMARY KEY	NONCLUSTERED (PROCESS_INSTANCE_OID)
	ON [PRIMARY] 
)

*/
CREATE	PROCEDURE	[dbo].[UP_UPDATE_REFERENCER_CONFIRM]
		@pPROCESS_INSTANCE_OID	VARCHAR(4000),
		@pCONFIRM_USERID		INT

AS

	DECLARE	@wPROCESS_INSTANCE_OID	VARCHAR(33)


	WHILE (1 = 1)
	BEGIN

		EXEC eManage.dbo.SDAOBGetCols @pPROCESS_INSTANCE_OID OUTPUT, @wPROCESS_INSTANCE_OID OUTPUT

		IF	@wPROCESS_INSTANCE_OID = ''	BREAK 

		IF	EXISTS	(SELECT	1	FROM	dbo.WF_REFERENCER_CONFIRM	WHERE	PROCESS_INSTANCE_OID = @wPROCESS_INSTANCE_OID)
			DELETE
			FROM	dbo.WF_REFERENCER_CONFIRM
			WHERE	PROCESS_INSTANCE_OID = @wPROCESS_INSTANCE_OID
		ELSE
			INSERT	INTO	dbo.WF_REFERENCER_CONFIRM
					(PROCESS_INSTANCE_OID,		CONFIRM_USERID,		CONFIRM_DATE)
			VALUES
					(@wPROCESS_INSTANCE_OID,	@pCONFIRM_USERID,	GETDATE())

	End





GO
/****** Object:  StoredProcedure [dbo].[UP_UPDATE_SIGN_WF_CONFIG_USER]    Script Date: 2015-10-15 오후 1:30:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
----------------------------------------------------------------------
----------------------------------------------------------------------
-- 작성자: 신상훈
-- 작성일: 2004.06.17
-- 수정일: 2004.06.17
-- 설   명: 도장이미지 저장
-- 테스트: EXEC  UP_UPDATE_SIGN_WF_CONFIG_USER 10021,10007, 900
-- 	  SELECT * FROM eWFFORM.dbo.WF_CONFIG_USER
----------------------------------------------------------------------
----------------------------------------------------------------------
CREATE  PROCEDURE [dbo].[UP_UPDATE_SIGN_WF_CONFIG_USER]
	@intUserId			int,
	@intDeptId			int,
	@intSignAttachId	int	
	
	AS
	
		/* SET NOCOUNT ON */
		
		UPDATE eWFFORM.dbo.Wf_CONFIG_USER 
		SET SIGN_ATTACHID = @intSignAttachId
		WHERE USERID = @intUserId AND DEPTID = @intDeptId
	
	

GO
/****** Object:  StoredProcedure [dbo].[UP_UPDATE_SIGNERLIST_TEMPAPPLINE]    Script Date: 2015-10-15 오후 1:30:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- 하는일: 양식결재선 Update, Insert
-- 작성자: 닷넷소프트 마성옥
-- 작성일: 2004.06.15	
CREATE Procedure [dbo].[UP_UPDATE_SIGNERLIST_TEMPAPPLINE]
	/* Param List */	
	
	@vcProcID	varchar(33),
	@vcFormID	varchar(33),
	@nDeptID    int,
	@vcSignInform text
	
AS	
	
-- 0이면 Update	
IF (@vcProcID = '0')
	BEGIN
			UPDATE eWFFORM.dbo.WF_SIGNER_LIST
			SET	SignInform = @vcSignInform
			WHERE FORM_ID = @vcFormID
			AND ListType = 'F'
			AND UserId = @nDeptID
	END
	
ELSE IF (@vcProcID = '1')
	BEGIN
			DELETE FROM eWFFORM.dbo.WF_SIGNER_LIST
			WHERE FORM_ID = @vcFormID
			AND ListType = 'F'
			AND UserId = @nDeptID
	END
	
	
-- 0,1이 아니면 	
ELSE IF (@vcProcID <> '0' AND @vcProcID <> '1')
	BEGIN
			INSERT INTO eWFFORM.dbo.WF_SIGNER_LISt
			VALUES(@vcProcID,@nDeptID,@vcFormID,'[Form Approval Line]',@vcSignInform,'','F',1)
			
	END
	
	
	

GO
/****** Object:  StoredProcedure [dbo].[up_update_udescription]    Script Date: 2015-10-15 오후 1:30:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[up_update_udescription]
	@pProcedureID char(33)

as

DECLARE @ptrval varbinary(16), @ptrtext int
DECLARE @orival varchar(50), @replval varchar(50), @lenval int
SET @orival = '<br />(제작사/거래처)'
SET @replval = ''
SET @lenval = DataLength(@orival)

SELECT @ptrtext = PatIndex('%'+@orival+'%', u_bodycontent1) +30
        , @ptrval=TextPtr(u_bodycontent1)
FROM dbo.FORM_YAE7EEC57433B4884AAC95B65128C3F0A
WHERE u_bodycontent1 like '%<br />(제작사/거래처)%' and process_id = @pProcedureID

BEGIN TRAN
	select @lenval ,@ptrtext
    UPDATETEXT dbo.FORM_YAE7EEC57433B4884AAC95B65128C3F0A.u_bodycontent1 @ptrval @ptrtext @lenval @replval
    
    SELECT u_bodycontent1
    FROM dbo.FORM_YAE7EEC57433B4884AAC95B65128C3F0A
	WHERE process_id = @pProcedureID


--ROLLBACK TRAN


commit tran



GO
/****** Object:  StoredProcedure [dbo].[UP_UPDATE_WF_ALL_SIGNER_FOLDER]    Script Date: 2015-10-15 오후 1:30:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




CREATE     PROCEDURE [dbo].[UP_UPDATE_WF_ALL_SIGNER_FOLDER]
(	
	@PROCESS_INSTANCE_OID	VARCHAR(33),	-- 프로세스 인스탄스 OID
	@SIGN_SEQ			INT		-- 현결재자의 결재순번
)
AS
-------------------------------------------------------------------------------------
-- 작성자: 신철호
-- 작성일: 2005.04.11
-- 수정일: 2005.04.11
-- 설명 : 전결인 경우, 예결함 결재상태를 기결재로 수정한다.
/*
     EXEC dbo.UP_UPDATE_WF_SIGNER_FOLDER 'Z91E02970208846B7ABCD61656B09458B', 1
*/
-------------------------------------------------------------------------------------
	--현결재자를 포함해서 다음 모든결재자의 결재상태를 기결재로 변경한다.
	UPDATE dbo.WF_SIGNER_FOLDER
	SET ACTION_TYPE = '0'
	WHERE PROCESS_INSTANCE_OID = @PROCESS_INSTANCE_OID
	AND SIGN_SEQ >= @SIGN_SEQ





GO
/****** Object:  StoredProcedure [dbo].[UP_UPDATE_WF_DOC_FOLDER]    Script Date: 2015-10-15 오후 1:30:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[UP_UPDATE_WF_DOC_FOLDER]
	/* Param List */	
	
	@intDocFolderId			int,
	@cAprFolderCode		Char(2),
	@cAprFolderType		Char(1),
	@vcDocFolderName		VarChar(50),
	@cDocFolderType		Char(1),
	@cUsage_YN			Char(1)
	
AS	
	
	/* SET NOCOUNT ON 	*/
	Update dbo.Wf_DOC_FOLDER
	Set APR_FOLDER_ID = @cAprFolderCode,		
		APR_FOLDER_TYPE = @cAprFolderType,
		DOC_FOLDER_NAME = @vcDocFolderName,
		DOC_FOLDER_TYPE = @cDocFolderType,
		USAGE_YN = @cUsage_YN		
	Where DOC_FOLDER_ID = @intDocFolderId
	
RETURN

GO
/****** Object:  StoredProcedure [dbo].[UP_UPDATE_WF_DOC_FOLDER_ORDER]    Script Date: 2015-10-15 오후 1:30:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
----------------------------------------------------------------------
----------------------------------------------------------------------
-- 작성자: LDCC 신상훈
-- 작성일: 2004.04.02
-- 수정일: 2004.04.02
-- 설   명: 양식별 결재현황 조회
-- 테스트: EXEC dbo.UP_UPDATE_WF_DOC_FOLDER_ORDER 64, 20
-- SELECT * FROM dbo.WF_DOC_FOLDER
----------------------------------------------------------------------
-- 수정일 : 
-- 수정자 : 
-- 수정내용 : 
----------------------------------------------------------------------
----------------------------------------------------------------------
CREATE Procedure [dbo].[UP_UPDATE_WF_DOC_FOLDER_ORDER]
	/* Param List */	
	
	@intDocFolderId		int,
	@intSortKey		int
	
AS	
	
	/* SET NOCOUNT ON 	*/
	Update dbo.Wf_DOC_FOLDER
	Set 	SORTKEY = @intSortKey
	Where DOC_FOLDER_ID = @intDocFolderId
	
RETURN

GO
/****** Object:  StoredProcedure [dbo].[UP_UPDATE_WF_DOC_FOLDER_ROOT]    Script Date: 2015-10-15 오후 1:30:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


----------------------------------------------------------------------
----------------------------------------------------------------------
-- 작성자: LDCC 신상훈
-- 작성일: 2004.04.02
-- 수정일: 2004.04.02
-- 설   명: 양식별 결재현황 조회
-- 테스트: EXEC dbo.UP_INSERT_WF_DOC_FOLDER 'LDCC','AA','P','상훈맨','G','N'
-- SELECT * FROM dbo.WF_DOC_FOLDER
-- TRUNCATE TABLE dbo.WF_DOC_FOLDER
----------------------------------------------------------------------
-- 수정일 : 
-- 수정자 : 
-- 수정내용 : 
----------------------------------------------------------------------
----------------------------------------------------------------------
CREATE   Procedure [dbo].[UP_UPDATE_WF_DOC_FOLDER_ROOT]
	/* Param List */		
	@vcDocFolderName	VarChar(50)
	
AS
	-- 사용자 트리 관련
	UPDATE		DBO.WF_DOC_FOLDER
   	      SET 		DOC_FOLDER_NAME = @vcDocFolderName		
		WHERE 	APR_FOLDER_ID = 'RT'
	-- 관리자 트리 관련
	UPDATE		DBO.WF_FOLDER
   	      SET 		FolderName = @vcDocFolderName		
		WHERE 	FOLDERTYPE = 'R' AND FOLDERID = 0
RETURN



GO
/****** Object:  StoredProcedure [dbo].[UP_UPDATE_WF_SIGNER_FOLDER]    Script Date: 2015-10-15 오후 1:30:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





CREATE      PROCEDURE [dbo].[UP_UPDATE_WF_SIGNER_FOLDER]
(	
	@SIGN_OID			VARCHAR(33),	-- 현결재자의 OID	
	@NEXT_SIGN_OID			VARCHAR(33)	-- 다음결재자의 OID	
)
AS
-------------------------------------------------------------------------------------
-- 작성자: 신철호
-- 작성일: 2005.04.11
-- 수정일: 2005.04.18
-- 설명 : 1. 결재자별 예결함을 수정한다.
--           2. 현결재자의 결재유형이 개인합의인 경우, 모든 개인합의자 결재상태를 기결재로 변경하고,
--               다음 결재자의 결재상태를 현결재로 변경한다.
--	3. 대결자 적용한다.
/*
     EXEC dbo.UP_UPDATE_WF_SIGNER_FOLDER 'Z91E02970208846B7ABCD61656B09458B', ''
*/
-------------------------------------------------------------------------------------
DECLARE @SIGN_CATEGORY		CHAR(2),
	 @SIGN_TYPE			CHAR(2),
	 @PROCESS_INSTANCE_OID	VARCHAR(33),
	 @iSEQ int

  	SELECT 	@SIGN_CATEGORY = SIGN_CATEGORY,
		@PROCESS_INSTANCE_OID = PROCESS_INSTANCE_OID,
		@SIGN_TYPE = SIGN_TYPE
	FROM dbo.WF_SIGNER_FOLDER(NOLOCK)
	WHERE SIGN_OID = @SIGN_OID

IF @SIGN_CATEGORY <> '04'		--일반결재
   BEGIN


	

	IF @SIGN_TYPE <> '04'		--현결재자가 대결이 아닌 경우
   	   BEGIN
		--현결재자의 결재상태를 기결재로 변경한다.
		UPDATE dbo.WF_SIGNER_FOLDER
		SET ACTION_TYPE = '0'
		WHERE SIGN_OID = @SIGN_OID

		--다음결재자의 결재상태를 현결재로 변경한다.
		UPDATE dbo.WF_SIGNER_FOLDER
		SET ACTION_TYPE = '1'
		WHERE SIGN_OID = @NEXT_SIGN_OID
	   END
	ELSE IF @SIGN_TYPE = '04'		--현결재가 대결인 경우
   	   BEGIN

		SELECT @iSEQ = SIGN_SEQ
		FROM dbo.WF_SIGNER_FOLDER(NOLOCK) 
		WHERE SIGN_OID = @NEXT_SIGN_OID
	
		SET @iSEQ = @iSEQ + 1

		--대결자 및 후결(후열)자의 결재상태를 기결재로 변경한다.
		UPDATE dbo.WF_SIGNER_FOLDER
		SET ACTION_TYPE = '0'
		WHERE SIGN_OID in (@SIGN_OID,@NEXT_SIGN_OID)

		--다음결재자의 결재상태를 현결재로 변경한다.
		UPDATE dbo.WF_SIGNER_FOLDER
		SET ACTION_TYPE = '1'
		WHERE PROCESS_INSTANCE_OID = @PROCESS_INSTANCE_OID
		AND SIGN_SEQ = @iSEQ
	   END
   END

ELSE IF @SIGN_CATEGORY = '04'	--개인합의
   BEGIN
	
	SELECT @iSEQ = MAX(SIGN_SEQ) 
	FROM dbo.WF_SIGNER_FOLDER(NOLOCK) 
	WHERE PROCESS_INSTANCE_OID = @PROCESS_INSTANCE_OID
	AND SIGN_CATEGORY = '04'

	SET @iSEQ = @iSEQ + 1

	--현결재자의 결재상태를 기결재로 변경한다.
	UPDATE dbo.WF_SIGNER_FOLDER
	SET ACTION_TYPE = '0'
	WHERE PROCESS_INSTANCE_OID = @PROCESS_INSTANCE_OID
	AND SIGN_CATEGORY = '04'

	--다음결재자의 결재상태를 현결재로 변경한다.
	UPDATE dbo.WF_SIGNER_FOLDER
	SET ACTION_TYPE = '1'
	WHERE PROCESS_INSTANCE_OID = @PROCESS_INSTANCE_OID
	AND SIGN_SEQ = @iSEQ
   END







GO
/****** Object:  StoredProcedure [dbo].[UP_UPDATE_WFSIGNERLIST]    Script Date: 2015-10-15 오후 1:30:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[UP_UPDATE_WFSIGNERLIST]
	/* Param List */	
	
	@strID	varchar(33),
	@strSignListName varchar(40),
	@strSignerList text,
	@strSignInform text
	
	
--	@strSignerList varchar(200),
--	@strSignInform varchar(200)
	
AS	
	
	/* SET NOCOUNT ON 	*/
	UPDATE dbo.Wf_SIGNER_LIST
	SET SignListName = @strSignListName,
		SignerList = @strSignerList,
		SignInform = @strSignInform
	WHERE ID = @strID 
	
RETURN

GO
/****** Object:  StoredProcedure [dbo].[UP_UPDATE_WORK_ITEM_STATE]    Script Date: 2015-10-15 오후 1:30:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO







CREATE           PROCEDURE [dbo].[UP_UPDATE_WORK_ITEM_STATE]
	@vcPROCESS_ID		VARCHAR(50), -- 프로세스 ID
	@nUSERID			INT,
	@nDEPTID			INT
/*

	exec UP_UPDATE_WORK_ITEM_STATE 'Z99CDF20979034166A9FD973EF6CB8FC8',10070,10070
*/
AS
-------------------------------------------------------------------------------------
-- 작성자: 마성옥
-- 작성일: 2004.04.12
-- 수정자: 신철호
-- 수정일: 2005.05.20
-- 설명 : 결재자 WORK_ITEM 상태변경
-- 수정내용 : DB연동결재 기안취소 상태를 만들어준다.
-- 
-- 실행순서
--     1. 기안취소대상인지 체크한다.
--     2. 결재 폼 ID가져오기
--     3. 임시저장 테이블에 저장
--     4. 프로세스 인스턴스에 기안취소 구분 설정
--     5. 결재자 내역에서 기안취소 구분설정
--     6. 결재양식 폼 상태를 기안취소 상태로 설정
--     7. DB연동결재문서일시 기안취소상태 설정
--     8. 예결함 상태 설정
--     9. 기안취소 완료 리턴
-------------------------------------------------------------------------------------
DECLARE @vcFORM_ID 	VARCHAR(50)
DECLARE @strSQL 	NVARCHAR(4000)
DECLARE @nCOUNT	INT
DECLARE @cOPEN_YN	CHAR(1)

DECLARE @FORMENAME VARCHAR(200),
	 @FOLDERID INT,
	 @FOLDERTYPE CHAR(1),
	 @OBJECTID CHAR(200),
	 @MODULEID CHAR(10)

SET @nCOUNT = (SELECT COUNT(*)
		  FROM eWF.dbo.WORK_ITEM A (NOLOCK)
		 WHERE A.PROCESS_INSTANCE_OID =@vcPROCESS_ID
		     AND A.NAME='일반결재자' )
IF @nCOUNT = 1 -- 현재 결재자가 한명일 경우만 기안취소 대상
	BEGIN
		SET  @cOPEN_YN = (SELECT ISNULL(A.OPEN_YN,'N') OPEN_YN
				  FROM eWF.dbo.WORK_ITEM A (NOLOCK)
				 WHERE A.PROCESS_INSTANCE_OID = @vcPROCESS_ID
				     AND A.NAME='일반결재자')
		IF @cOPEN_YN = 'N'  -- 결재대상자가 문서를 열어 보지 않았을 경우만 가능
			BEGIN
	
				--2.  결재 폼 ID가져오기
				SET @vcFORM_ID = (SELECT FORM_ID  
						       FROM eWFFORM.dbo.WF_FORMS_PROP (NOLOCK)
		  			                   WHERE PROCESS_ID = @vcPROCESS_ID)
		
		
				--  3. 임시저장 테이블에 저장
				SELECT @FOLDERID=CLASSIFICATION, @FORMENAME=FORM_ENAME FROM dbo.WF_FORMS(NOLOCK) WHERE FORM_ID = @vcFORM_ID
				SET @FOLDERTYPE = (SELECT TOP 1 FolderType FROM dbo.WF_FOLDER(NOLOCK) WHERE FolderID =@FOLDERID)

				--연동결재양식은 임시보관함에 저장하지 않는다.
				IF @FOLDERTYPE <> 'B'
				   BEGIN
				
			
					INSERT INTO eWFFORM.dbo.WF_FORM_STORAGE  (PROCESS_ID, FORM_ID, SUBJECT, USERID, DEPTID, DESCRIPTION, CREATE_DATE, SIGN_CONTEXT)
					SELECT  A.PROCESS_ID, A.FORM_ID, A.SUBJECT, @nUSERID, @nDEPTID, A.SUBJECT, getdate(), B.SIGN_CONTEXT
					   FROM eWFFORM.dbo.WF_FORMS_PROP A (NOLOCK), eWF.dbo.PROCESS_SIGN_INFORM B (NOLOCK)
					 WHERE A.PROCESS_ID = @vcPROCESS_ID
					      AND A.PROCESS_ID = B.PROCESS_INSTANCE_OID
				   END
		
				
				-- 4. 프로세스 인스턴스에 기안취소 구분 설정
		
				UPDATE eWF.dbo.PROCESS_INSTANCE 
				      SET STATE = 13 
				 WHERE OID = @vcPROCESS_ID
				
				-- 5. 결재자 내역에서 기안취소 구분설정
		
				UPDATE eWF.dbo.WORK_ITEM 
				      SET STATE = 13 
		                             WHERE PROCESS_INSTANCE_OID = @vcPROCESS_ID
				
				-- 6. 결재양식 폼 상태를 기안취소 상태로 설정
		
				SET @strSQL = 'UPDATE eWFFORM.dbo.FORM_'+@vcFORM_ID+' SET PROCESS_INSTANCE_STATE = 13 WHERE PROCESS_ID ='''+@vcPROCESS_ID+''''
		
				exec(@strSQL)


				--7. DB결재양식여부확인			
				
				IF @FOLDERTYPE = 'B'
				   BEGIN
				
					SET @strSQL = 	'SELECT @OBJECTID = OBJECTID, @MODULEID = MODULEID FROM eWFFORM.dbo.FORM_'+@vcFORM_ID+'(NOLOCK) WHERE PROCESS_ID ='''+@vcPROCESS_ID+''''
					EXECUTE sp_executesql @strSQL,  N'@OBJECTID CHAR(200) OUTPUT, @MODULEID CHAR(10) OUTPUT ', @OBJECTID OUTPUT, @MODULEID OUTPUT
					
					-- dbo.WF_DBAPPROVAL에 설정
					EXECUTE dbo.UP_INSERT_DBAPPROVAL @vcPROCESS_ID,'',@MODULEID,@OBJECTID,'8',@FORMENAME
				
				
				   END
		
				-- 8. 예결함 상태 변경(기결재:0)
				UPDATE eWFFORM.dbo.WF_SIGNER_FOLDER
				SET ACTION_TYPE = 0
				WHERE PROCESS_INSTANCE_OID = @vcPROCESS_ID


				-- 9. 기안취소 완료 리턴

				RETURN 1
			END
		ELSE
			BEGIN
				RETURN 0
			END
	END
ELSE
	BEGIN
		RETURN 0
	END








GO
/****** Object:  StoredProcedure [dbo].[UP_UPDATEFOLDERID_FOLDER]    Script Date: 2015-10-15 오후 1:30:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UP_UPDATEFOLDERID_FOLDER]
	(
		@vcsrcFolderId			varchar(33),
		@vcdestFolderId			varchar(33)
	)
AS
	/* SET NOCOUNT ON */
DECLARE
	@intsrcDept					INT,
	@intdestDept				INT,
	@vcDept						INT,
	@RETURNVALUE		VARCHAR(8000)
	
	SET @intsrcDept = (SELECT DEPTH FROM dbo.WF_FOLDER WHERE FOLDERID = @vcsrcFolderId)
	SET @intdestDept = (SELECT DEPTH FROM dbo.WF_FOLDER WHERE FOLDERID = @vcdestFolderId)
	
	SET @vcDept = @intdestDept - @intsrcDept  + 1
		
	UPDATE 
		dbo.WF_FOLDER
	SET 
		PARENTFOLDERID	= @vcdestFolderId
	WHERE 
		FOLDERID = @vcsrcFolderId
	-- 하위 폴더에 대해서도 depth를 올려준다
	EXEC @RETURNVALUE = dbo.UF_GETCHILD @vcsrcFolderId ,@vcDept
	SET @RETURNVALUE = REPLACE(@RETURNVALUE, ';', ' ')
	EXEC (@RETURNVALUE)
	
RETURN

GO
/****** Object:  StoredProcedure [dbo].[UP_UPDATEFOLDERNAME_FOLDER]    Script Date: 2015-10-15 오후 1:30:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UP_UPDATEFOLDERNAME_FOLDER]
	(
		@vcfolderId				varchar(33),
		@vcfolderName			varchar(100)
	)
AS
	/* SET NOCOUNT ON */
		UPDATE dbo.WF_FOLDER 
		SET FolderName = @vcfolderName
		WHERE FolderID=@vcfolderId
RETURN

GO
/****** Object:  StoredProcedure [dbo].[UP_UPDATEFORMHEADER_FORMS]    Script Date: 2015-10-15 오후 1:30:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UP_UPDATEFORMHEADER_FORMS]
	(
		@vcKorFormName			VARCHAR(200), 
		@vcEngFormName			VARCHAR(200), 
		@vcDefId				VARCHAR(33), 
		@cUserYn				CHAR(1),
		@vcDesc					VARCHAR(100),
		@vcFormId				VARCHAR(33),
		@vcFormAlias			VARCHAR(10)
	)
AS
	DECLARE
		@intCount				int
		
	SET @intCount = 
	(
		SELECT 
			COUNT(*)
			AS Counts
		FROM dbo.WF_FORMS (NOLOCK)
		WHERE Form_Name = @vcKorFormName and Form_eName = @vcEngFormName and Form_ID <> @vcFormId
	)
	
	IF(@intCount > 0)
		RETURN
	
	UPDATE dbo.WF_FORMS 
	SET 
		Form_Name = @vcKorFormName,
		Form_eName = @vcEngFormName,
		Def_OID = @vcDefId,
		Current_Forms = @cUserYn,
		Form_Desc = @vcDesc,
		FORM_ALIAS = @vcFormAlias
	WHERE Form_ID = @vcFormId
	
RETURN 

GO
/****** Object:  StoredProcedure [dbo].[UP_UPDATEFORMSCHEMA_FORMSCHEMA]    Script Date: 2015-10-15 오후 1:30:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
----------------------------------------------------------------------
----------------------------------------------------------------------
-- 작성자: 조성균
-- 작성일: 2004.03.06
-- 수정일: 2004.03.06
-- 설   명: 폼스키마 수정	
--        	테스트 :
--		EXEC  UP_UPDATEFORMSCHEMA_FORMSCHEMA
----------------------------------------------------------------------
----------------------------------------------------------------------
-- 수정일 : 
-- 수정자 : 
-- 수정내용 : 
----------------------------------------------------------------------
----------------------------------------------------------------------
CREATE PROCEDURE [dbo].[UP_UPDATEFORMSCHEMA_FORMSCHEMA]
	(
		@vcFormId				VARCHAR(33),	
		@vcSmtp_Suffix			VARCHAR(100),
		@cEdm_UseYn				CHAR(1),
		@cAudit_UserUseYn		CHAR(1),
		@vcAudit_User			VARCHAR(100),
		@vcAudit_UserCode		VARCHAR(100),
		@cAudit_DeptYn			CHAR(1),
		@vcAudit_Depart			VARCHAR(100),
		@vcAudit_DeptCode		VARCHAR(100),
		@cDraftBox_UseYn		CHAR(1),
		@cPerson_AgreeYn		CHAR(1),
		@cDept_AgreeYn			CHAR(1),
		@cRcv_UseYn				CHAR(1),
		@cMulti_RcvYn			CHAR(1),
		@cMail_UseYn			CHAR(1),
		@vcDefaultRcvName		VARCHAR(500),
		@vcDefaultRcvCode		VARCHAR(500),
		@cSreen_Orientation		CHAR(1),
		@intScrenn_Width		INT
	)
AS	
	IF(@vcSmtp_Suffix = '')
		SET @vcSmtp_Suffix = NULL
	IF(@vcAudit_User = '')
		SET @vcAudit_User = NULL
	IF(@vcAudit_Depart = '')
		SET @vcAudit_Depart = NULL
		
	IF(@vcDefaultRcvName = '')
		SET @vcDefaultRcvName = NULL
		
	IF(@vcDefaultRcvCode = '')
		SET @vcDefaultRcvCode = NULL
	
	UPDATE dbo.WF_FORM_SCHEMA
	SET 
		SMTP_SUFFIX			= @vcSmtp_Suffix,
		EDM_USE_YN			= @cEdm_UseYn,
		AUDIT_USER_USE_YN	= @cAudit_UserUseYn,
		AUDIT_USER			= @vcAudit_User,
		AUDIT_USER_CODE		= @vcAudit_UserCode,
		AUDIT_DEPART_USE_YN = @cAudit_DeptYn,
		AUDIT_DEPART		= @vcAudit_Depart,
		AUDIT_DEPART_CODE   = @vcAudit_DeptCode,
		DRAFTBOX_USE_YN		= @cDraftBox_UseYn,
		PERSON_AGREE_YN		= @cPerson_AgreeYn,
		DEPT_AGREE_YN		= @cDept_AgreeYn,
		RCV_USE_YN			= @cRcv_UseYn,
		MULTI_RCV_YN		= @cMulti_RcvYn,
		MAIL_USE_YN			= @cMail_UseYn,
		RECEPTION			= @vcDefaultRcvName,
		RECEPTION_CODE      = @vcDefaultRcvCode,
		SCREEN_ORIENTATION  = @cSreen_Orientation,
		SCREEN_WIDTH		= @intScrenn_Width
	WHERE Form_ID = @vcFormId
	
RETURN 

GO
/****** Object:  StoredProcedure [dbo].[UP_UPDATESINGLE_FORMCOLUMN]    Script Date: 2015-10-15 오후 1:30:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 CREATE PROCEDURE [dbo].[UP_UPDATESINGLE_FORMCOLUMN]
	(
		@vcfieldId			VARCHAR(33),
		@vcfieldName		VARCHAR(30),
		@vcfieldLabel		VARCHAR(30),
		@vcfieldType		VARCHAR(30),
		@vcfieldLength		VARCHAR(9),
		@vcfieldDefault		VARCHAR(50)		
	)
AS 
	UPDATE dbo.WF_FORM_INFORM 
	SET
			FIELD_NAME =	@vcfieldName, 
			FIELD_LABEL =	@vcfieldLabel, 
			FIELD_TYPE =	@vcfieldType, 
			FIELD_LENGTH =	@vcfieldLength, 
			FIELD_DEFAULT =	@vcfieldDefault
	WHERE FIELD_ID = @vcfieldId
RETURN

GO
/****** Object:  StoredProcedure [dbo].[UP_UPDATESINGLE_FORMCOLUMN_SINGLEFORM]    Script Date: 2015-10-15 오후 1:30:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE  PROCEDURE [dbo].[UP_UPDATESINGLE_FORMCOLUMN_SINGLEFORM]
	(
		@vcformId		VARCHAR(33),
		@vcfieldId		VARCHAR(33),
		@vcfieldName		VARCHAR(30),
		@vcfieldLabel		VARCHAR(30),
		@vcfieldType		VARCHAR(30),
		@vcfieldLength		VARCHAR(9),
		@vcfieldDefault		VARCHAR(50)		
	)
AS 
	UPDATE dbo.WF_FORM_INFORM 
	SET
			FIELD_NAME =	@vcfieldName, 
			FIELD_LABEL =	@vcfieldLabel, 
			FIELD_TYPE =	@vcfieldType, 
			FIELD_LENGTH =	@vcfieldLength, 
			FIELD_DEFAULT =	@vcfieldDefault
	WHERE 	FIELD_ID = @vcfieldId
	AND	Form_ID = @vcformId
RETURN


GO
/****** Object:  StoredProcedure [dbo].[UP_WPS_DBApproval_ITSM_Insert]    Script Date: 2015-10-15 오후 1:30:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




CREATE PROCEDURE [dbo].[UP_WPS_DBApproval_ITSM_Insert]
(
	@cPID		CHAR(33),	-- PROCESS_INSTANCE_OID
	@cPPID		CHAR(33),	-- 부모 PID
	@cFID		CHAR(33),	-- 폼 ID
	@vcTemp1	varchar(100),
	@vcTemp2	varchar(500),
	@vcTemp3	varchar(500)
)
--------------------------------------------------------------------------
-- 작성자: 신상훈
-- 작성일: 2011.10.31
-- 설명 :  ENGINE_DBAPPROVAL_ITSM 테이블에 INSERT
-- 실행 : 
/*
 EXEC WF.[UP_WPS_DBApproval_ITSM_Insert] 'P6FAAC301AE9B4ED3B9FC9565166B4876', '', 'Y43349E37CF514753A57820EBBB6C4D2E', '2', ''
select * from WF.ENGINE_DBAPPROVAL_ITSM
*/
--------------------------------------------------------------------------
AS
	SET NOCOUNT ON


DECLARE
		@cDBOID			char(33)
,		@vcObjectID		varchar(50)
,		@vcSubject		nvarchar(200)
,		@vcSystemID		varchar(30)
,		@vcModuleID		varchar(30)
,		@vcFormAlias	varchar(30)
,		@vcReserve1		varchar(100)
,		@vcReserve2		varchar(100)
,		@vcReserve3		varchar(2000)
,		@vcReserve4		nvarchar(200)
,		@vcReserve5		nvarchar(200)
,		@nvcAprLine		nvarchar(max)
,		@nvcSql			nvarchar(4000)
,		@nvcQuery		nvarchar(max)
,		@nvcSignXml nvarchar(max)
,		@intDoc int


set @nvcSql =	N' SELECT	@vcObjectID		= DB_OBJECTID, 
							@vcSystemID		= DB_SYSTEMID,
							@vcSubject		= SUBJECT, 
							@vcModuleID		= DB_MODULEID, 
							@vcFormAlias	= DB_FORMALIAS,	
							@vcReserve1		= DB_RESERVED1,
							@vcReserve2		= DB_RESERVED2,
							@vcReserve3		= DB_RESERVED3,
							@vcReserve4		= DB_RESERVED4,
							@vcReserve5		= DB_RESERVED5	'
+				N' FROM dbo.FORM_' + @cFID + '(NOLOCK) WHERE PROCESS_ID= '''+@cPID + ''''


EXEC SP_EXECUTESQL @nvcSql	, N'@vcObjectID		varchar(50)			output, 
								@vcSystemID		varchar(30)			output,
								@vcSubject		nvarchar(200)		output, 
								@vcModuleID		varchar(30)			output,
								@vcFormAlias	varchar(30)			output,
								@vcReserve1		varchar(100)		output,
								@vcReserve2		varchar(100)		output,
								@vcReserve3		varchar(2000)		output,
								@vcReserve4		nvarchar(200)		output,
								@vcReserve5		nvarchar(200)		output	'
							,	@vcObjectID		= @vcObjectID		output
							,	@vcSystemID		= @vcSystemID		output
							,	@vcSubject		= @vcSubject		output
							,	@vcModuleID		= @vcModuleID		output
							,	@vcFormAlias	= @vcFormAlias		output
							,	@vcReserve1		= @vcReserve1		output
							,	@vcReserve2		= @vcReserve2		output
							,	@vcReserve3		= @vcReserve3		output
							,	@vcReserve4		= @vcReserve4		output
							,	@vcReserve5		= @vcReserve5		output
							
/*
SET @nvcAprLine = (
SELECT
    '<![CDATA[' + a.USER_NAME + ']]>' NAME, 
    '<![CDATA[' + a.DEPT_NAME + ']]>' DEPTNAME,
    '<![CDATA[' + a.DUTY_NAME + ']]>' JIKCHAEK,
    '<![CDATA[' + a.POS_NAME + ']]>' JIKWI,
    '<![CDATA[' + case a.sign_state
			when '00' THEN	'기안'
			when '01' THEN	'대기'
			when '02' THEN	'승인'
			when '03' THEN	'반려'
			when '04' THEN	'전결'
			when '05' THEN	'결재안함'
			when '06' THEN	'반송'
			when '07' THEN	'반송'
			when '12' THEN	'합의'
			when '13' THEN	'합의안함'
			when '22' THEN	'동의'
			when '23' THEN	'동의안함'
			when '99' THEN	'보류'
			else	  '기타'
		end  + ']]>' AS [STATE],
	'<![CDATA[' + CASE ISNULL(a.CREATE_DATE,'') WHEN '' THEN '' ELSE CONVERT(char(16), DATEADD(HOUR, 9, a.CREATE_DATE),120) END  + ']]>' CREATE_DATE,
	'<![CDATA[' + CASE ISNULL(a.COMPLETED_DATE,'') WHEN '' THEN '' ELSE CONVERT(char(16), DATEADD(HOUR, 9, a.COMPLETED_DATE),120) END  + ']]>' COMPLETED_DATE,
	'<![CDATA[' + ISNULL(cast(b.COMMENT_TEXT as varchar), '')   + ']]>' COMMENT_TEXT
FROM WF.PROCESS_SIGNER a
left outer join
WF.PROCESS_COMMENT b
on a.SIGN_OID = b.SIGN_OID
where a.PROCESS_INSTANCE_OID = @cPID
FOR XML PATH ('USER'), ROOT('SIGNER_XML'))

SET @nvcAprLine = '<SIGNER_XML><USER><NAME><![CDATA[김지운]]></NAME><![CDATA[LDCC IS담당]]><![CDATA[-]]><![CDATA[사원]]><STATE><![CDATA[승인]]></STATE><CREATE_DATE><![CDATA[2014-11-14 20:41]]></CREATE_DATE><COMPLETED_DATE><![CDATA[2014-11-14 20:41]]></COMPLETED_DATE><COMMENT_TEXT><![CDATA[테스트]]></COMMENT_TEXT></USER><USER><NAME><![CDATA[김지운]]></NAME><![CDATA[LDCC IS담당]]><![CDATA[-]]><![CDATA[A]]><STATE><![CDATA[대기]]></STATE><CREATE_DATE><![CDATA[2014-11-14 20:41]]></CREATE_DATE><COMPLETED_DATE><![CDATA[]]></COMPLETED_DATE><COMMENT_TEXT><![CDATA[]]></COMMENT_TEXT></USER></SIGNER_XML>'
*/


select @nvcSignXml = SIGN_CONTEXT from ewf.dbo.process_sign_inform
where process_instance_oid = @cPID

set @nvcSignXml = replace(@nvcSignXml, '<?xml version="1.0" encoding="utf-8"?>', '')

--print @nvcSignXml 
exec sp_xml_preparedocument @intDoc output, @nvcSignXml
SET @nvcAprLine = (
select 
'<![CDATA[' + DISPLAYNAME + ']]>' NAME,
'<![CDATA[' + DEPARTNAME + ']]>' DEPTNAME,
'<![CDATA[' + TITLE + ']]>' JIKCHAEK,
'<![CDATA[' + STATUS + ']]>' JIKWI,
'<![CDATA[' + SIGNSTATUS + ']]>' STATE,
'<![CDATA[' + ltrim(RECEIVEDDATE) + ']]>' CREATE_DATE,
'<![CDATA[' + ltrim(SIGNDATE) + ']]>' COMPLETED_DATE,
'<![CDATA[' + COMMENT + ']]>' COMMENT_TEXT
from 
openxml (@intdoc, 'SIGN/USER/*',2)
WITH
(
	DISPLAYNAME nvarchar(30),
	DEPARTNAME nvarchar(30),
	TITLE	nvarchar(30),
	STATUS	nvarchar(30),
	SIGNSTATUS	nvarchar(10),
	RECEIVEDDATE char(16),
	SIGNDATE	char(16),
	COMMENT	nvarchar(200)
)
FOR XML PATH ('USER'), ROOT('SIGNER_XML'))
			
			INSERT INTO dbo.ENGINE_DBAPPROVAL_ITSM (
						 OID
						,PROCESS_INSTANCE_OID
						,FORM_ID
						,SUBJECT
						,MODULEID
						,FORMALIAS
						,OBJECTID
						,FLAG				
						,RESERVED1
						,RESERVED2
						,RESERVED3
						,RESERVED4
						,RESERVED5
						,SIGNER_XML
						,PRC_DATETIME
						,RETRY_CNT
					)
			VALUES	
					(	'D' + REPLACE(newid(), '-','')			--OID
					,	@cPID			--PROCESS_INSTANCE_OID
					,	@cFID			--FORM_ID
					,	@vcSubject		--SUBJECT
					,	@vcModuleID		--MODULEID
					,	@vcFormAlias	--FORMALIAS
					,	@vcObjectID		--OBJECTID
					,	@vcTemp1		--FINANCE_FLAG
					,	@vcReserve1		--RESERVED1
					,	@vcReserve2		--RESERVED2
					,	@vcReserve3		--RESERVED3
					,	@vcReserve4		--RESERVED4
					,	@vcReserve5		--RESERVED5
					,	replace(replace(@nvcAprLine, '&lt;','<'), '&gt;','>') --SIGNER_XML
					,	getdate()				--PRC_DATETIME
					,	0		)					--RETRY_CNT	' 

--print (@nvcSql)
--exec (@nvcQuery)





GO
/****** Object:  StoredProcedure [dbo].[USP_MIG_ADMIN_PROCESS_INSTANCE_DELETE]    Script Date: 2015-10-15 오후 1:30:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- 작성자 : 정은아
-- 작성일 : 2012년 06월 14일
-- 설  명 : 결재문서 삭제
-- 수정자 : 박인희
-- 수정일 : 2015-07-14
-- =============================================
CREATE PROCEDURE [dbo].[USP_MIG_ADMIN_PROCESS_INSTANCE_DELETE]
    @vcProcessId char(33)
AS
BEGIN

	UPDATE [EWF_MIG].[dbo].[PROCESS_INSTANCE]
	SET	DELETE_DATE = GETDATE()
	WHERE OID = @vcProcessId

	---- CHECK조건 해제
	--ALTER TABLE WORK_ITEM
	--NOCHECK CONSTRAINT FK_WORK_ITEM_PROCESS_INSTANCE

	--ALTER TABLE ACTIVITY_PARTICIPANT
	--NOCHECK CONSTRAINT FK_ACTIVITY_PARTICIPANT_PROCESS_INSTANCE

	--ALTER TABLE PROCESS_SIGNER
	--NOCHECK CONSTRAINT FK_PROCESS_SIGNER_PROCESS_INSTANCE

	--ALTER TABLE TRANSITION_INSTANCE
	--NOCHECK CONSTRAINT FK_TRANSITION_INSTANCE_PROCESS_INSTANCE

	--ALTER TABLE PROCESS_CODEPT
	--NOCHECK CONSTRAINT FK_PROCESS_CODEPT_PROCESS_INSTANCE

	--ALTER TABLE PROCESS_COMMENT
	--NOCHECK CONSTRAINT FK_PROCESS_COMMENT_PROCESS_INSTANCE

	--ALTER TABLE PROCESS_ATTENDANT
	--NOCHECK CONSTRAINT FK_PROCESS_ATTENDANT_PROCESS_INSTANCE

	--ALTER TABLE V_ROLE_PARTICIPANT
	--NOCHECK CONSTRAINT FK_V_ROLE_PARTICIPANT_PROCESS_INSTANCE

	--ALTER TABLE PROCESS_CODEPT
	--NOCHECK CONSTRAINT FK_PROCESS_CODEPT_PROCESS_INSTANCE1

	------------------------------------------------------------------------
	---- 데이터변경 

	--INSERT INTO dbo.PROCESS_INSTANCE_DEL_MOVE(OID, FORM_ID, PRIORITY, PROCESS_OID, STATE, NAME, CREATOR, CREATOR_ID, CREATOR_POS_NAME, PARENT_OID, CREATE_DATE, COMPLETED_DATE, PARENT_WORK_ITEM_OID, DELETE_DATE, CREATOR_DEPT, CREATOR_DEPT_ID, SUBJECT, EXIST_ATTACH, EXIST_ISURGENT, EXIST_COMMENT, EXIST_REF_DOCUMENT, ATTACH_EXTENSION, DOC_LEVEL, KEEP_YEAR, DOC_NUMBER, CURRENT_USER_ID, CURRENT_USER_NAME, CURRENT_USER_POS_NAME, CURRENT_DEPT_ID, CURRENT_DEPT_NAME, CONFIRM_YN, CONFIRM_COMPLETED_DATE)
	--SELECT OID, FORM_ID, PRIORITY, PROCESS_OID, STATE, NAME, CREATOR, CREATOR_ID, CREATOR_POS_NAME, PARENT_OID, CREATE_DATE, COMPLETED_DATE, PARENT_WORK_ITEM_OID, DELETE_DATE, CREATOR_DEPT, CREATOR_DEPT_ID, SUBJECT, EXIST_ATTACH, EXIST_ISURGENT, EXIST_COMMENT, EXIST_REF_DOCUMENT, ATTACH_EXTENSION, DOC_LEVEL, KEEP_YEAR, DOC_NUMBER, CURRENT_USER_ID, CURRENT_USER_NAME, CURRENT_USER_POS_NAME, CURRENT_DEPT_ID, CURRENT_DEPT_NAME, CONFIRM_YN, CONFIRM_COMPLETED_DATE
	--  FROM dbo.PROCESS_INSTANCE
	-- WHERE OID = @vcProcessId


	--DELETE dbo.PROCESS_INSTANCE
	-- WHERE OID = @vcProcessId


	------------------------------------------------------------------------
	---- CHECK조건 설정


	--ALTER TABLE WORK_ITEM
	--CHECK CONSTRAINT FK_WORK_ITEM_PROCESS_INSTANCE

	--ALTER TABLE ACTIVITY_PARTICIPANT
	--CHECK CONSTRAINT FK_ACTIVITY_PARTICIPANT_PROCESS_INSTANCE

	--ALTER TABLE PROCESS_SIGNER
	--CHECK CONSTRAINT FK_PROCESS_SIGNER_PROCESS_INSTANCE

	--ALTER TABLE TRANSITION_INSTANCE
	--CHECK CONSTRAINT FK_TRANSITION_INSTANCE_PROCESS_INSTANCE

	--ALTER TABLE PROCESS_CODEPT
	--CHECK CONSTRAINT FK_PROCESS_CODEPT_PROCESS_INSTANCE

	--ALTER TABLE PROCESS_COMMENT
	--CHECK CONSTRAINT FK_PROCESS_COMMENT_PROCESS_INSTANCE

	--ALTER TABLE PROCESS_ATTENDANT
	--CHECK CONSTRAINT FK_PROCESS_ATTENDANT_PROCESS_INSTANCE

	--ALTER TABLE V_ROLE_PARTICIPANT
	--CHECK CONSTRAINT FK_V_ROLE_PARTICIPANT_PROCESS_INSTANCE

	--ALTER TABLE PROCESS_CODEPT
	--CHECK CONSTRAINT FK_PRO
END


GO
/****** Object:  StoredProcedure [dbo].[USP_MIG_ADMIN_PROCESS_INSTANCE_SELECT]    Script Date: 2015-10-15 오후 1:30:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-------------------------------------------------------------------------------------
-- 작성자 : 정은아
-- 작성일 : 2012년 06월 13일
-- 설  명 : 양식별 결재현황 조회
-- 수정자 : 박인희
-- 수정일 : 2015-07-14, 구 LCWARE에 맞게 수정함, CONFIRM_YN 뭔지몰라 'Y'로 처리
-- 실  행 :
/*
	EXEC USP_MIG_ADMIN_PROCESS_INSTANCE_SELECT 1, 20, 'Y39129DC9BB6443B8A39D2D1A4EEE6449', '', '', '', '', 'CREATE_DATE', '0',''
	EXEC USP_MIG_ADMIN_PROCESS_INSTANCE_SELECT 1, 20, 'YAE2F85A901AF4B43BC6906EF06C8DB83', '', '', '', '', 'CREATE_DATE', '0','Z9ED0FEDB708B48F0ABD205D1305052AC'
*/
-------------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_MIG_ADMIN_PROCESS_INSTANCE_SELECT]
    @intPageNum			int,
    @intNumPerPage      int,
    @vcFormId			varchar(33),
    @vcSearchColumn		varchar(20),
    @vcSearchText       varchar(50),
    @cStartDate			nvarchar(19),
    @cEndDate			nvarchar(19),
    @vcSortColumn		nvarchar(20),    
    @vcSortOrder		nvarchar(10),
    @vcParendOID	    varchar(33)
AS
BEGIN
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED; 	
		
	DECLARE	 @SQL		NVARCHAR(4000)		   
			,@WHERE		NVARCHAR(1000) 
			,@ORDERBY	NVARCHAR(100)
						
						
	-- 가져올 목록수에 대한 처리를 한다.		
	DECLARE @START_ROW INT, @END_ROW INT
	SET @START_ROW = @intNumPerPage * (@intPageNum - 1) + 1;
	SET @END_ROW = @intNumPerPage * (@intPageNum);	
			
			
	--------------------------------------------------------------------------------------
	-- 조건절 처리
	--------------------------------------------------------------------------------------
	IF @vcParendOID = ''
		SET @WHERE = N' WHERE A.DELETE_DATE = CAST(''9999-12-31 00:00:00.000'' as datetime) AND ISNULL(A.PARENT_OID, '''') = '''' AND C.FORM_ID = @vcFormId ' 
	ELSE 
		--SubProcess
		SET @WHERE = N' WHERE A.DELETE_DATE = CAST(''9999-12-31 00:00:00.000'' as datetime) AND A.PARENT_OID = @vcParendOID '  
				
				
	--------------------------------------------------------------------------------------
	-- 검색어에 따른 조건절 처리
	--------------------------------------------------------------------------------------
	IF  @vcSearchColumn <> '' AND @vcSearchText <> ''
	BEGIN
		IF @vcSearchColumn = 'STATE' AND @vcSearchText = '0'
		BEGIN
			--기타등등
			SET @WHERE = @WHERE + N' AND A.STATE IN (0, 13)'
		END
		ELSE IF @vcSearchColumn = 'STATE'
		BEGIN
			SET @WHERE = @WHERE + N' AND A.' + @vcSearchColumn + N' = ''' +  @vcSearchText + N''' ' 
		END
		ELSE
		BEGIN
			SET @WHERE = @WHERE + N' AND A.' + @vcSearchColumn + N' LIKE ''%' + @vcSearchText + N'%'' '
		END
	END	
	
	
	--------------------------------------------------------------------------------------		
	-- 날짜에 따른 조건절 처리
	--------------------------------------------------------------------------------------
	IF @cStartDate <> '' AND @cEndDate <> '' 
		SET @WHERE = @WHERE + N' AND CONVERT(NVARCHAR(10), A.CREATE_DATE, 20) BETWEEN  @cStartDate AND @cEndDate '

	--------------------------------------------------------------------------------------
	-- 정렬 
	--------------------------------------------------------------------------------------
	IF @vcSortColumn <> '' AND @vcSortOrder <> ''
		SET @ORDERBY = 'A.' + @vcSortColumn + CASE @vcSortOrder WHEN '0' THEN  N' DESC '  ELSE  N' ASC ' END
			
	
	--------------------------------------------------------------------------------------
	-- 리스트 
	--------------------------------------------------------------------------------------			
	SET @SQL = N' WITH CTE_LIST AS
				(  SELECT ROW_NUMBER() OVER ( ORDER BY ' + @ORDERBY + N' ) AS RowNum
						, A.SUBJECT
						, A.CREATOR_DEPT
						, A.CREATOR
						, CONVERT(NVARCHAR(16), A.CREATE_DATE, 20) AS CREATE_DATE
						, CONVERT(NVARCHAR(16), A.COMPLETED_DATE, 20) AS COMPLETED_DATE
						, A.OID
						, A.PARENT_OID
						, C.FORM_ID
						, A.CREATOR_ID
						, CASE A.STATE		
								WHEN 1  THEN ''기안작업완료''
								WHEN 2  THEN ''결재처리대상''
								WHEN 3  THEN ''결재처리중''
								WHEN 7  THEN ''결재완료''
								WHEN 8  THEN ''반려''
								WHEN 10 THEN ''결재처리대상''
								ELSE		 ''기타등등''
						 END AS  STATE
					   --, ISNULL(EXIST_ATTACH,''N'') AS EXIST_ATTACH
					   --, ISNULL(EXIST_COMMENT,''N'') AS EXIST_COMMENT
					   --, ISNULL(EXIST_REF_DOCUMENT,''N'') AS EXIST_REF_DOCUMENT
					   --, ISNULL(CONFIRM_YN,''N'') AS CONFIRM_YN
					   , ISNULL(C.ISATTACHFILE,''N'') AS EXIST_ATTACH
					   , ISNULL(C.POSTSCRIPT,''N'') AS EXIST_COMMENT
					   , ISNULL(C.REF_DOC,''N'') AS EXIST_REF_DOCUMENT
					   , ''Y'' AS CONFIRM_YN	 
				    FROM EWF_MIG.dbo.PROCESS_INSTANCE A (NOLOCK)
					INNER JOIN WF_FORMS_PROP C (NOLOCK) ON C.PROCESS_ID = A.OID
				' + @WHERE  + N'
				)				
				SELECT * 
					 , (SELECT COUNT(*) FROM CTE_LIST) AS [RowCount]
				  FROM CTE_LIST 
				 WHERE RowNum BETWEEN @START_ROW AND @END_ROW				
			'	
					 
	EXEC SP_EXECUTESQL @SQL , N'@START_ROW INT, @END_ROW INT, @vcFormId char(33), @vcParendOID char(33),@cStartDate nvarchar(19), @cEndDate nvarchar(19)'
					 , @START_ROW
					 , @END_ROW
					 , @vcFormId 
					 , @vcParendOID 
					 , @cStartDate
					 , @cEndDate 	
						 				 
	PRINT @SQL
	
	SET NOCOUNT OFF;
END

GO
/****** Object:  StoredProcedure [dbo].[USP_MIG_ADMIN_TREE_SELECT]    Script Date: 2015-10-15 오후 1:30:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- 작성자 : 정은아
-- 작성일 : 2012년 06월 11일
-- 설  명 : 이관문서 관리자트리 가져오기
-- 수정자 : 박인희
-- 수정일 : 2015-07-14, FolderType 조건절 확인 필요.
/*
	EXEC USP_MIG_ADMIN_TREE_SELECT 0,0
	EXEC USP_MIG_ADMIN_TREE_SELECT 1,0
	EXEC USP_MIG_ADMIN_TREE_SELECT 1,10328
*/
-- =============================================
CREATE PROCEDURE [dbo].[USP_MIG_ADMIN_TREE_SELECT]
	@intDepth		    int
,	@intParentFolderID	int		
AS
BEGIN
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED; 
  
	DECLARE @cSeparator char(1)
	SET		@cSeparator = '|'
	
	IF (@intParentFolderID > 0)
		SET @intDepth = NULL ;	  	

	SELECT	A.FolderID
		,	A.FolderName
		,	A.Depth
		,	A.ParentFolderID
		,	RTRIM(ISNULL(B.FORM_ID,'FOLDER')) AS FORM_ID
		,	A.FolderType
		,	CAST(A.FolderID as varchar(5)) + @cSeparator +  RTRIM(ISNULL(B.FORM_ID,'X')) AS TREE_ID	-- 트리에서 폴더ID와 폼ID를 사용하기 위해서
		,	SortKey			
	FROM dbo.WF_FOLDER A
	LEFT OUTER JOIN dbo.WF_FOLDER_DETAIL B
		 ON A.FolderID = B.FolderID		
	WHERE A.DeleteDate IS NULL 
	AND A.FolderType IN ('A', 'B', 'C', 'R') 
	AND A.ParentFolderID = @intParentFolderID
	AND ((@intDepth IS NULL) OR ( A.Depth = @intDepth))
	ORDER BY FolderType, FolderName DESC 
END



GO
/****** Object:  StoredProcedure [dbo].[USP_MIG_DOC_REFERENCE_SELECT]    Script Date: 2015-10-15 오후 1:30:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		박인희
-- Create date: 2015-09-02
-- Description: 관련문서 조회
-- USP_MIG_DOC_REFERENCE_SELECT 마이그레이션
/*
	EXEC dbo.USP_MIG_DOC_REFERENCE_SELECT @cProcessId = 'Z1072D02EED6C4CDEBB05136DE9E31B6A'
*/
-- =============================================
CREATE PROCEDURE [dbo].[USP_MIG_DOC_REFERENCE_SELECT]
	@cProcessId	varchar(33)
AS
BEGIN

	SET NOCOUNT ON;

	DECLARE	@PARENT_OID	varchar(33)

		
	SELECT @PARENT_OID = PARENT_OID FROM EWF_MIG.dbo.PROCESS_INSTANCE(nolock) WHERE OID = @cProcessId
	IF ISNULL(LTRIM(RTRIM(@PARENT_OID)), '') <> ''
	BEGIN
		SET @cProcessId=@PARENT_OID
	END

	PRINT @PARENT_OID

	SELECT  
		REF.PROCESS_ID, 
		REF.REF_PROCESS_ID,
		INS.OID, 
		PROP.FORM_ID,
		--INS.FORM_ID, 
		INS.PRIORITY, 
		INS.PROCESS_OID, 											
		INS.STATE, 
		INS.NAME, 
		INS.CREATOR, 
		INS.CREATOR_ID,
		'' AS CREATOR_POS_NAME,
		--INS.CREATOR_POS_NAME, 
		INS.PARENT_OID, 
		INS.CREATE_DATE, 
		INS.COMPLETED_DATE, 
		INS.PARENT_WORK_ITEM_OID, 
		INS.DELETE_DATE, 
		INS.CREATOR_DEPT, 
		INS.CREATOR_DEPT_ID, 
		INS.SUBJECT, 
		PROP.ISATTACHFILE AS EXIST_ATTACH,
		PROP.ISURGENT AS EXIST_ISURGENT,
		PROP.POSTSCRIPT AS EXIST_COMMENT,
		PROP.REF_DOC AS EXIST_REF_DOCUMENT,
		PROP.ATTACH_EXTENSION, 
		PROP.DOC_LEVEL,
		PROP.KEEP_YEAR,
		PROP.DOC_NUMBER,
		'' AS CURRENT_USER_ID,
		'' AS CURRENT_USER_NAME,
		'' AS CURRENT_USER_POS_NAME,
		'' AS CURRENT_DEPT_ID,
		'' AS CURRENT_DEPT_NAME
		--INS.EXIST_ATTACH, 
		--INS.EXIST_ISURGENT, 
		--INS.EXIST_COMMENT, 
		--INS.EXIST_REF_DOCUMENT, 
		--INS.ATTACH_EXTENSION, 
		--INS.DOC_LEVEL,
		--INS.KEEP_YEAR, 
		--INS.DOC_NUMBER,
		--INS.CURRENT_USER_ID, 
		--INS.CURRENT_USER_NAME, 
		--INS.CURRENT_USER_POS_NAME, 
		--INS.CURRENT_DEPT_ID, 
		--INS.CURRENT_DEPT_NAME
	FROM  EWF_MIG.dbo.PROCESS_INSTANCE INS (NOLOCK) 
		INNER JOIN dbo.WF_FORM_REFERENCE REF (NOLOCK) ON  INS.OID =  REF.REF_PROCESS_ID
		INNER JOIN dbo.WF_FORMS_PROP PROP (NOLOCK) ON REF.REF_PROCESS_ID = PROP.PROCESS_ID
	WHERE  REF.PROCESS_ID = @cProcessId
		   
END


GO
/****** Object:  StoredProcedure [dbo].[USP_MIG_FILE_SELECT]    Script Date: 2015-10-15 오후 1:30:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-------------------------------------------------------------------------------------
-- 작성자 : 정은아
-- 작성일 : 2012년 03월 15일
-- 설  명 : 파일정보 반환
-- 실  행 : EXEC USP_MIG_FILE_SELECT 1425007
-------------------------------------------------------------------------------------
-- =============================================
-- Author:		박인희
-- Create date: 2015-09-02
-- Description:	양식 첨부파일 목록
-- UP_GET_FILE 마이그레이션
-- EXEC USP_MIG_GET_FILE  4
-- =============================================
CREATE PROCEDURE [dbo].[USP_MIG_FILE_SELECT]
	@attachID INT
AS
BEGIN

	SET NOCOUNT ON
	
	SELECT FileName
		 , SavedFileName
		 , FileSize
		 , FilePath
		 , REPLACE(FileURL, 'http://lcware.lottechilsung.co.kr/ekwv2/Data/', 'http://portal.lottechilsung.co.kr/um/Data/') as FileURL
		 , FileExtension
		 , IsFile
	FROM EMANAGE_MIG.dbo.TB_FILE WITH(NOLOCK)
	WHERE AttachID = @attachID
		
	SET NOCOUNT OFF
END


GO
/****** Object:  StoredProcedure [dbo].[USP_MIG_FORM_DATA_SELECT]    Script Date: 2015-10-15 오후 1:30:06 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
-------------------------------------------------------------------------------------
-- 작성자 : 정은아
-- 작성일 : 2012년 03월 15일
-- 설  명 : 결재폼 양식 데이터 정보를 가져온다
-- 실  행 : EXEC USP_MIG_FORM_DATA_SELECT 'Y07D3A5CE2A10422982430EBECA4E93D9','Z5D5CEDFEA69E40AF931D2AD26BDFA308'
-------------------------------------------------------------------------------------
-- =============================================
-- Author:		박인희
-- Create date: 2015-09-02
-- Description:	이전문서 결재폼 양식 데이터 정보를 가져온다
-- =============================================
CREATE PROCEDURE [dbo].[USP_MIG_FORM_DATA_SELECT]           
(
	@cFID		CHAR(33),	-- 폼 ID
	@cPID		CHAR(33)	-- 프로세스 ID
)
AS
BEGIN
	SET NOCOUNT ON

	DECLARE @nvcDY_SQL	NVARCHAR(400)		-- 동적 양식 폼 조회 ID


	-- 결재양식 폼에서 프로세스 ID에 해당하는 폼 데이터를 가져오는 SQL를 생성한다.
	-- 인라인이미지 주소 치환
	SET @nvcDY_SQL = N'SELECT REPLACE(CAST(HTMLDESCRIPTION AS NVARCHAR(MAX)),''http://lcware.lottechilsung.co.kr/ekwv2/Data/'',''http://portal.lottechilsung.co.kr/um/Data/'') HTMLDESCRIPTION
	, * FROM EWFFORM_MIG.dbo.FORM_' + @cFID + ' (NOLOCK) WHERE PROCESS_ID = @cPID'

	EXEC SP_EXECUTESQL  @nvcDY_SQL, N' @cPID CHAR(33)', @cPID

	--print @nvcDY_SQL
	
END


GO
/****** Object:  StoredProcedure [dbo].[USP_MIG_GET_FILE]    Script Date: 2015-10-15 오후 1:30:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		박인희
-- Create date: 2015-06-02
-- Description:	양식 첨부파일 목록
-- UP_GET_FILE 마이그레이션
-- EXEC USP_MIG_GET_FILE  4
-- =============================================
CREATE PROCEDURE [dbo].[USP_MIG_GET_FILE]
	@attachID INT
AS
BEGIN

	SET NOCOUNT ON;
		
	SELECT FileName
		 , SavedFileName
		 , FileSize
		 , FilePath
		 , REPLACE(FileURL, 'http://lcware.lottechilsung.co.kr/ekwv2/Data/', 'http://portal.lottechilsung.co.kr/um/Data/') as FileURL
		 , FileExtension
		 , IsFile
	FROM EMANAGE_MIG.dbo.TB_FILE WITH(NOLOCK)
	WHERE AttachID = @attachID
	
END

GO
/****** Object:  StoredProcedure [dbo].[USP_MIG_GetStringByIndex]    Script Date: 2015-10-15 오후 1:30:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

/*
Declare	@w	varchar(4000)

set	@w = '!@2'
exec	UP_ColStringByIndex	@w, @w output, 2
select	@w
*/

CREATE	Procedure	[dbo].[USP_MIG_GetStringByIndex]
		@pColString		varchar(8000),
		@pColStringRtn	varchar(8000)  output,
		@pReturnPos		int

As
	Declare	@wColSeparatorPos	int,
			@i					int

	Set	@i = 1
	While (1 = 1)
	Begin
	
		Set	@wColSeparatorPos = CharIndex('!@', @pColString)

	    If   @wColSeparatorPos = 0
	    Begin
			Select	@pColStringRtn = @pColString,
					@pColString = ''
	    End
		Else
		Begin

			Set	@pColStringRtn = Substring(@pColString, 1, @wColSeparatorPos - 1)
			Set	@pColString = Substring(@pColString, @wColSeparatorPos + 2, Len(@pColString) - @wColSeparatorPos - 1)

		End

		If	@i = @pReturnPos	Break
	
		Set	@i = @i + 1
	
	
	End


GO
/****** Object:  StoredProcedure [dbo].[USP_MIG_LIST_ADMINTREE]    Script Date: 2015-10-15 오후 1:30:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		박인희
-- Create date: 2015-06-02
-- Description:	
-- UP__LIST_ADMINTREE 마이그레이션
-- EXEC USP_MIG_LIST_ADMINTREE
-- =============================================
CREATE PROCEDURE [dbo].[USP_MIG_LIST_ADMINTREE]
AS
BEGIN

	SET NOCOUNT ON;  

	DECLARE @cSeparator char(1)
	SET		@cSeparator = '|'
	
	SELECT 	
		A.FolderID, 
		A.FolderName, 
		A.Depth, 
		A.ParentFolderID, 
		B.Form_ID,
		A.FolderType,
		-- 트리에서 폴더ID와 폼ID를 사용하기 위해서
		CAST(A.FolderID as VARCHAR(5)) + @cSeparator +  RTRIM(ISNULL(B.Form_ID,'X')) as TREE_ID
	FROM
	(	SELECT FolderID, FolderName, Depth, ParentFolderID, FolderType
		FROM	EWFFORM_MIG.dbo.Wf_FOLDER (NOLOCK) 
		WHERE	DeleteDate IS NULL AND	FolderType IN ('A', 'B', 'C', 'R')
	) as A 
	LEFT OUTER JOIN
	(	SELECT	FOLDERID, FORM_ID
		FROM	EWFFORM_MIG.dbo.WF_FOLDER_DETAIL(NOLOCK)
	) as B 
	ON A.FolderID = B.FolderID
	ORDER BY A.FolderType, A.FolderName DESC

END


GO
/****** Object:  StoredProcedure [dbo].[USP_MIG_LIST_ALLFORMS]    Script Date: 2015-10-15 오후 1:30:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		박인희
-- Create date: 2015-06-02
-- Description:	모든양식 조회
-- UP_LIST_ALLFORMS 마이그레이션
-- EXEC USP_MIG_LIST_ALLFORMS
-- =============================================
CREATE PROCEDURE [dbo].[USP_MIG_LIST_ALLFORMS]
AS
BEGIN
    SET NOCOUNT ON

    SELECT FORM_ID,
           FORM_NAME
    FROM dbo.WF_FORMS(nolock)
	WHERE CURRENT_FORMS = 'Y'
    ORDER BY FORM_NAME
END


GO
/****** Object:  StoredProcedure [dbo].[USP_MIG_LIST_VW_WORKLIST_DOCUMENTLISTSEARCH_DATE]    Script Date: 2015-10-15 오후 1:30:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		박인희
-- Create date: 2015-06-02
-- Description:	전자결재 목록 조회
-- UP_LIST_VW_WORKLIST_DOCUMENTLIST_DATE 마이그레이션
-- 서정환/128192	오포생산팀/2744
-- EXEC USP_MIG_LIST_VW_WORKLIST_DOCUMENTLISTSEARCH_DATE  '128192', '', 'CO', '', '', 1, 15, '0', '0', '', '', '', ''
-- EXEC USP_MIG_LIST_VW_WORKLIST_DOCUMENTLISTSEARCH_DATE  '128192', '', 'RE', '', '', 1, 15, '0', '0', '', '', '', ''
-- EXEC USP_MIG_LIST_VW_WORKLIST_DOCUMENTLISTSEARCH_DATE  '128192', '', 'CO', '', '', 1, 15, 'VIEW_COMPLETE_DATE', '1', '', '', '', ''
-- EXEC USP_MIG_LIST_VW_WORKLIST_DOCUMENTLISTSEARCH_DATE  '128192', '', 'S', '', '', 1, 10, '0', '0', '', '', '', ''
-- EXEC USP_MIG_LIST_VW_WORKLIST_DOCUMENTLISTSEARCH_DATE  '128192', '', 'CO', 'CATEGORYNAME', '인수', 1, 15, '0', '0', '', '', '', ''
-- EXEC USP_MIG_LIST_VW_WORKLIST_DOCUMENTLISTSEARCH_DATE  '141015', '2987', 'S', '', '', 1, 15, '0', '0', '', '', '', ''
-- =============================================
CREATE PROCEDURE [dbo].[USP_MIG_LIST_VW_WORKLIST_DOCUMENTLISTSEARCH_DATE]  
  
	@strUserId varchar(10),		-- 사용자ID
	@strUserDeptId varchar(20),	-- 사용자부서 사용자부서ID
	@strDFType varchar(5),		-- 결재함종류
	@strCondition varchar(20),
	@strKeyword varchar(50),
	@nCurPage int,				-- 현재페이지
	@nRowPerPage int,			-- 블록(페이지)당표시건수
	@strSortColumn varchar(20),	-- 정렬필드
	@strSortOrder varchar(1),	-- 정렬방법
	@strSDate varchar(10),
	@strEDate varchar(10),
	@strFolderId varchar(10),	--양식별 검색
	@strFormsId varchar(33)		--양식별 검색
AS  
BEGIN

	SET NOCOUNT ON;  
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;    

	--SET @strUserId = '128192';
  
	DECLARE  @SQL NVARCHAR(4000), @WHERE NVARCHAR(1000), @ORDERBY NVARCHAR(100), @ORDER NVARCHAR(20)  
    
	--가져올 목록수에 대한 처리를 한다. 
	DECLARE @FETCH int = @nRowPerPage
	DECLARE @OFFSET int =  (@nCurPage - 1)  * @nRowPerPage
	
	--------------------------------------------------------------------------------------  
	-- 양식TYPE 에 따른 조건절 처리  
	-- 개인함 : 완료함(CO), 반려함(RE)
	-- 부서함 : 발신함(S), 품의함(A), 업무협조함(C), 신청처리함(P), 부서합의함(H)
	--------------------------------------------------------------------------------------  
	IF @strDFType = 'CO' OR  @strDFType = 'RE'
	BEGIN
		SET @WHERE = N' WHERE PARTICIPANT_ID = ''' +  RTRIM(@strUserId) + N''' ' 
	END
	ELSE
	BEGIN
		SET @WHERE = N' WHERE PARTICIPANT_ID = ''' +  RTRIM(@strUserDeptId) + '_' +   RTRIM(@strDFType) + N''' ' 
	END

	-- 반려함(RE)
	IF  @strDFType = 'RE'
	BEGIN
		SET @WHERE = @WHERE + N' AND STATE = 7 AND PROCESS_INSTANCE_VIEW_STATE = 8 AND ITEMSTATE = 7 '
	END
	-- 발신함(S), 품의함(A), 업무협조함(C), 신청처리함(P), 부서합의함(H)
	ELSE IF @strDFType = 'S' OR  @strDFType = 'A' OR @strDFType = 'C' OR @strDFType = 'P' OR @strDFType = 'H' 
	BEGIN    
		SET @WHERE = @WHERE + N' AND STATE = 7 AND PROCESS_INSTANCE_VIEW_STATE = 3 '    
	END    
	ELSE  
	BEGIN    
		SET @WHERE = @WHERE + N' AND STATE = 7 AND PROCESS_INSTANCE_VIEW_STATE = 7 '     
	END  

	--------------------------------------------------------------------------------------  
	-- 검색어 조건절 처리
	-------------------------------------------------------------------------------------- 
	IF ISNULL(@strCondition, '') <> '' AND ISNULL(@strKeyword, '') <> ''
	BEGIN
		SET @WHERE = @WHERE + N' AND '+ @strCondition + ' LIKE ''%' + @strKeyword + '%'' '	
	END

	--------------------------------------------------------------------------------------  
	-- 폼양식 조건절 처리
	-------------------------------------------------------------------------------------- 
	IF ISNULL(@strFolderId, '') <> '' AND ISNULL(@strFormsId, '') = ''
	BEGIN
		SET @WHERE = @WHERE + 
		N' AND FORM_ID IN ( 
			SELECT WF_FORMS.FORM_ID
			FROM WF_FOLDER_DETAIL , WF_FORMS 
			WHERE WF_FOLDER_DETAIL.FORM_ID = WF_FORMS.FORM_ID 
			AND  WF_FOLDER_DETAIL.FOLDERID IN
				(	SELECT FOLDERID
					FROM WF_FOLDER
					WHERE PARENTFOLDERID = ''' + @strFolderId + ''' )
			AND CURRENT_FORMS = ''Y'' ) '
	END
	IF ISNULL(@strFormsId, '') <> ''
	BEGIN
		SET @WHERE = @WHERE + N' AND FORM_ID in (''' + @strFormsId + ''') '
	END

	--------------------------------------------------------------------------------------        
	-- 날짜에 따른 조건절 처리      
	--------------------------------------------------------------------------------------      
	IF @strSDate <> '' AND @strEDate <> '' 
	BEGIN
		SET @WHERE = @WHERE +
			CASE @strDFType
				WHEN 'CO' THEN N' AND CONVERT(NVARCHAR(10), VIEW_COMPLETE_DATE, 20) BETWEEN @SDATE AND @EDATE ' 
				WHEN 'RE' THEN N' AND CONVERT(NVARCHAR(10), VIEW_COMPLETE_DATE, 20) BETWEEN @SDATE AND @EDATE ' 
				WHEN 'S' THEN N' AND CONVERT(NVARCHAR(10), COMPLETED_DATE, 20) BETWEEN @SDATE AND @EDATE ' 
				WHEN 'A' THEN N' AND CONVERT(NVARCHAR(10), COMPLETED_DATE, 20) BETWEEN @SDATE AND @EDATE ' 
				WHEN 'C' THEN N' AND CONVERT(NVARCHAR(10), COMPLETED_DATE, 20) BETWEEN @SDATE AND @EDATE ' 
				WHEN 'P' THEN N' AND CONVERT(NVARCHAR(10), COMPLETED_DATE, 20) BETWEEN @SDATE AND @EDATE ' 
				WHEN 'H' THEN N' AND CONVERT(NVARCHAR(10), COMPLETED_DATE, 20) BETWEEN @SDATE AND @EDATE ' 
				ELSE N' AND CONVERT(NVARCHAR(10), VIEW_COMPLETE_DATE, 20) BETWEEN @SDATE AND @EDATE ' 
			END
	END     

	--------------------------------------------------------------------------------------  
	-- 정렬 
	-- 개인함 : 완료함(CO), 반려함(RE)
	-- 부서함 : 발신함(S), 품의함(A), 업무협조함(C), 신청처리함(P), 부서합의함(H)
	--------------------------------------------------------------------------------------
	IF @strSortColumn IS NULL OR @strSortColumn = ''
	BEGIN
		SET @strSortColumn = '0'
	END

	SET @ORDER = CASE @strSortOrder WHEN '0' THEN N' ASC' ELSE N' DESC' END

	SET @ORDERBY = 
		CASE 
			-- 완료함(CO)
			WHEN @strDFType = 'CO' AND @strSortColumn = '0' THEN N' ORDER BY VIEW_COMPLETE_DATE DESC '
			WHEN @strDFType = 'CO' AND @strSortColumn != '0' THEN N' ORDER BY ' + @strSortColumn + @ORDER + ', ITEMCREATE_DATE DESC'
			
			-- 반려함(RE)
			WHEN @strDFType = 'RE' AND @strSortColumn = '0' THEN N' ORDER BY VIEW_COMPLETE_DATE DESC '
			WHEN @strDFType = 'RE' AND @strSortColumn != '0' THEN N' ORDER BY ' + @strSortColumn + @ORDER + ', ITEMCREATE_DATE DESC'
			
			-- 발신함(S)
			WHEN @strDFType = 'S' AND @strSortColumn = '0' THEN N' ORDER BY COMPLETED_DATE DESC '
			WHEN @strDFType = 'S' AND @strSortColumn != '0' THEN N' ORDER BY ' + @strSortColumn + @ORDER + ', ITEMCREATE_DATE DESC' 
			
			-- 품의함(A)
			WHEN @strDFType = 'A' AND @strSortColumn = '0' THEN N' ORDER BY COMPLETED_DATE DESC '
			WHEN @strDFType = 'A' AND @strSortColumn != '0' THEN N' ORDER BY ' + @strSortColumn + @ORDER + ', ITEMCREATE_DATE DESC' 
			
			-- 업무협조함(C)
			WHEN @strDFType = 'C' AND @strSortColumn = '0' THEN N' ORDER BY COMPLETED_DATE DESC '
			WHEN @strDFType = 'C' AND @strSortColumn = 'COMPLETED_DATE' THEN N' ORDER BY ' + @strSortColumn + @ORDER
			WHEN @strDFType = 'C' AND @strSortColumn != '0' THEN N' ORDER BY ' + @strSortColumn + @ORDER + ', COMPLETED_DATE DESC' 

			-- 신청처리함(P)
			WHEN @strDFType = 'P' AND @strSortColumn = '0' THEN N' ORDER BY COMPLETED_DATE DESC '
			WHEN @strDFType = 'P' AND @strSortColumn != '0' THEN N' ORDER BY ' + @strSortColumn + @ORDER + ', ITEMCREATE_DATE DESC' 

			-- 부서합의함(H)
			WHEN @strDFType = 'H' AND @strSortColumn = '0' THEN N' ORDER BY COMPLETED_DATE DESC '
			WHEN @strDFType = 'H' AND @strSortColumn = 'COMPLETED_DATE' THEN N' ORDER BY ' + @strSortColumn + N' ' + @ORDER
			WHEN @strDFType = 'H' AND @strSortColumn != '0' THEN N' ORDER BY ' + @strSortColumn + @ORDER + ', COMPLETED_DATE ASC' 

			ELSE N' ORDER BY VIEW_COMPLETE_DATE DESC '
		END
    
    --PRINT @ORDERBY

	--------------------------------------------------------------------------------------  
	-- 리스트   
	--------------------------------------------------------------------------------------
	SET @SQL = N'
	SELECT	 
		a.ITEMOID,   
		a.ISURGENT,       
		a.STATUS,   
		a.ISATTACHFILE,   
		a.POSTSCRIPT,   
		a.CATEGORYNAME,   
		a.SUBJECT,   
		a.DOC_LEVEL,   
		a.CREATOR,   
		a.CREATOR_DEPT,  
		CASE 
			WHEN @DFTYPE = '''' OR @DFTYPE = ''CO'' OR @DFTYPE = ''RE'' 
			THEN a.VIEW_COMPLETE_DATE 
			ELSE a.COMPLETED_DATE 
		END as VIEW_COMPLETE_DATE,  
		a.OPEN_YN,  
		a.OID,  
		a.REF_DOC,  
		a.ATTACH_EXTENSION,  
		a.CREATOR_ID,  
		a.DOC_NUMBER,   
		a.FORM_ID,
		a.CREATE_DATE,
		COUNT(*) OVER () AS [ROW_COUNT]       
	from dbo.VW_MIG_WORK_LIST as a'
	+ @WHERE + @ORDERBY + '
	OFFSET @OFFSET ROWS FETCH NEXT @FETCH ROWS ONLY'

	EXEC SP_EXECUTESQL @SQL, N'@DFTYPE VARCHAR(5),  @SDATE VARCHAR(50), @EDATE VARCHAR(50), @OFFSET INT, @FETCH INT', @strDFType, @strSDate, @strEDate, @OFFSET, @FETCH
  
	PRINT @SQL
END

GO
/****** Object:  StoredProcedure [dbo].[USP_MIG_LISTFORMLIST_FORMS]    Script Date: 2015-10-15 오후 1:30:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		박인희
-- Create date: 2015-06-02
-- Description:	폼헤더 생성
-- UP_LISTFORMLIST_FORMS 마이그레이션
-- EXEC USP_MIG_LISTFORMLIST_FORMS '10002'
-- =============================================
CREATE PROCEDURE [dbo].[USP_MIG_LISTFORMLIST_FORMS]
	@vcFolderId varchar(20)
AS
BEGIN
	/* SET NOCOUNT ON */
	SELECT WF_FORMS.FORM_ID, 
		   WF_FORMS.FORM_NAME, 
		   WF_FORMS.FORM_ENAME
	FROM WF_FOLDER_DETAIL , WF_FORMS 
	WHERE WF_FOLDER_DETAIL.FORM_ID = WF_FORMS.FORM_ID 
	AND  WF_FOLDER_DETAIL.FOLDERID IN
			(
			 SELECT FOLDERID
			 FROM WF_FOLDER
			 WHERE PARENTFOLDERID = @vcFolderId
			)
	AND CURRENT_FORMS = 'Y'
		  
END

GO
/****** Object:  StoredProcedure [dbo].[USP_MIG_PROCESS_INSTANCE_ALL_SELECT]    Script Date: 2015-10-15 오후 1:30:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- 작성자 : 정은아
-- 작성일 : 2012년 03월 20일
-- 수정자 : 박인희
-- 수정일 : 2015-07-14
-- 설  명 : PROCESS_INSTANCE 관련 정보 조회
-- 실  행 : EXEC USP_MIG_PROCESS_INSTANCE_ALL_SELECT 'P30A8FD03C1BD44FC9D434FECA8DA950E'
-- =============================================
CREATE PROCEDURE [dbo].[USP_MIG_PROCESS_INSTANCE_ALL_SELECT]
	@cProcessId	 char(33)
AS
BEGIN
	SET NOCOUNT ON

	SELECT	
		A.*,
		B.FORM_ID, 
		B.DOC_NUMBER,
		B.ISATTACHFILE,
		B.STATUS,
		B.ISURGENT,
		B.POSTSCRIPT,
		B.REF_DOC
    FROM	EWF_MIG.dbo.PROCESS_INSTANCE (NOLOCK) A 
		INNER JOIN 
			WF_FORMS_PROP B (NOLOCK) ON A.OID = B.PROCESS_ID
	WHERE	OID = @cProcessId

END

GO
/****** Object:  StoredProcedure [dbo].[USP_MIG_PROCESS_SIGNER_SELECT]    Script Date: 2015-10-15 오후 1:30:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
/*
	USP_MIG_PROCESS_SIGNER_SELECT @cPID = 'Z7B42B6D9FF0343388A0AB1B47C5F818C'
*/
-- =============================================
CREATE PROCEDURE [dbo].[USP_MIG_PROCESS_SIGNER_SELECT]
	@cPID varchar(33)
AS
BEGIN
	
	SET NOCOUNT ON;
	/* 구LCWARE -> 신LCWARE 결재선 변환 안됨 */
	/*
	DECLARE @SIGN_LIST NVARCHAR(MAX)
	DECLARE @XML XML

  	SELECT @SIGN_LIST = CAST(SIGN_CONTEXT AS NVARCHAR(MAX))
	FROM EWF_MIG.dbo.PROCESS_SIGN_INFORM(NOLOCK)
	WHERE PROCESS_INSTANCE_OID = @cPID

	IF ISNULL(@SIGN_LIST, '') <> ''
	BEGIN
		SET @XML = REPLACE(@SIGN_LIST, '<?xml version="1.0" encoding="utf-8"?>', '')
	
		SELECT	
			SIGN_OID = '',
			SIGN_SEQ = '',
			PROCESS_INSTANCE_OID = @cPID,
			USER_ID = ITEM.value('./SEQ[1]', 'nvarchar(100)'),
			USER_NAME = ITEM.value('./DISPLAYNAME[1]', 'nvarchar(100)'),
			POS_NAME = '',
			DUTY_NAME = ITEM.value('./TITLE[1]', 'nvarchar(100)'),
			DEPT_ID = '',
			DEPT_NAME = ITEM.value('./DEPARTNAME[1]', 'nvarchar(100)'),
			SIGN_CATEGORY = '',
			SIGN_TYPE = ITEM.value('./SIGNTYPE[1]', 'nvarchar(100)'),
			SIGN_STATE =  ITEM.value('./SIGNSTATUS[1]', 'nvarchar(100)'),
			ACTION_TYPE = '',
			CREATE_DATE = ITEM.value('./RECEIVEDDATE[1]', 'nvarchar(100)'),
			COMPLETED_DATE = ITEM.value('./SIGNDATE[1]', 'nvarchar(100)'),
			ABSENCE_USER_ID = '',
			ABSENCE_USER_NAME = '',
			ABSENCE_USER_POS_NAME = '',
			ABSENCE_DEPT_ID = '',
			ABSENCE_DEPT_NAME = '',
			ABSENCE_TYPE = '',
			SIGN_PATH = '',
			EMAIL = '',
			IP_ADDRESS = '',
			SIGN_DESC = '',
			TERM = ''
		FROM @XML.nodes('/SIGN/USER/ITEM') T(ITEM)
	END 

	--PRINT @SIGN_LIST
	*/

	--SELECT CASE WHEN charindex('http://web.hotellotte.co.kr/eKWV2/',SIGN_PATH) > 0 THEN REPLACE(SIGN_PATH,'http://web.hotellotte.co.kr/eKWV2/','http://ep.dutyfree.lotte.net/UM/Storage/')
	--			WHEN charindex('http://lh-gw2.hotellotte.co.kr/ekwv2/Data/',SIGN_PATH)> 0 THEN REPLACE(SIGN_PATH,'http://lh-gw2.hotellotte.co.kr/ekwv2/Data/','http://ep.dutyfree.lotte.net/UM/Storage/')
	--			WHEN charindex('http://ekw.hotellotte.co.kr/ekwv2/Data/',SIGN_PATH) > 0 THEN REPLACE(SIGN_PATH,'http://ekw.hotellotte.co.kr/ekwv2/Data/','http://ep.dutyfree.lotte.net/UM/Storage/')
	--			ELSE ''
	--	   END SIGN_PATH	
	--	 , A.*
	--     , ISNULL(B.COMMENT_TEXT,'') AS COMMENT_TEXT
	--	 , ISNULL(B.COMMENT_OID,'') AS COMMENT_OID
	--  FROM dbo.PROCESS_SIGNER A (READPAST) LEFT OUTER JOIN dbo.PROCESS_COMMENT B (READPAST)
	--	ON A.SIGN_OID = B.SIGN_OID
	-- WHERE A.PROCESS_INSTANCE_OID = @cPID
	-- ORDER BY A.SIGN_SEQ

END


GO
/****** Object:  StoredProcedure [dbo].[USP_MIG_SDAOBGetCols]    Script Date: 2015-10-15 오후 1:30:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


Create	Procedure [dbo].[USP_MIG_SDAOBGetCols]
        @iColFrom       varchar(8000)  output,
        @iColTo         varchar(8000)  output,
        @iType          char(1)    = null

AS
declare
    @wnColIndexNo                   int,
    @wnColSeparatorPos              int,
    @wColString                     varchar(8000)

    select @wnColIndexNo = 1
    select @wnColSeparatorPos = charindex('_/', @iColFrom)

    if   @wnColSeparatorPos = 0
    BEGIN
        select @iColTo = @iColFrom,
               @iColFrom = ' '
    END
    else
    BEGIN
        select @iColTo  = substring(@iColFrom, 1, @wnColSeparatorPos - 1)
        select @iColFrom= substring(@iColFrom, @wnColSeparatorPos + 2 ,len(@iColFrom) - @wnColSeparatorPos - 1)     -- datalength를 Len으로 바꿈(한글 관련)
    END

    if isnull(rtrim(ltrim(@iColTo)), '') = ''
        select @iColTo = ' '

    if @iColTo = ' '
    begin
        if @iType ='N'  select @iColTo = '0'
        else            select @iColTo = ' '
    end

   if   @iColFrom   is null   select  @iColFrom = ''

    if @wnColSeparatorPos = 0
        return 0         /* Last */
    else
        return 1         /* Continue */
return



GO
/****** Object:  StoredProcedure [dbo].[USP_MIG_SELECT_AGREEDEPT_COMMENT]    Script Date: 2015-10-15 오후 1:30:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
-- =============================================
-- Author:		박인희
-- Create date: 2015-06-02
-- Description: 
-- UP_SELECT_AGREEDEPT_COMMENT 마이그레이션
/*
	declare	@pU_AGREE_DEPT_Comment	varchar(1000) 
	EXEC [USP_MIG_SELECT_AGREEDEPT_COMMENT] 'Y9FA891C60DF54882BAE0DA51F233AF69', 'Z7C713861D6C94E8DBCA66D947263D1B8', @pU_AGREE_DEPT_Comment output
	select	@pU_AGREE_DEPT_Comment
*/
-- =============================================
CREATE PROCEDURE [dbo].[USP_MIG_SELECT_AGREEDEPT_COMMENT]
		@pForm_ID		char(33),
		@pPROCESS_ID	char(33),
		@pU_AGREE_DEPT_Comment	varchar(8000) output
/*

declare	@pU_AGREE_DEPT_Comment	varchar(8000) 
exec dbo.USP_MIG_SELECT_AGREEDEPT_COMMENT	'YFA4BC440266849EB8DBA1A1FE7C55EE6', 'ZF02A3FE0555E473EA5047D595357B92D', @pU_AGREE_DEPT_Comment output
select	@pU_AGREE_DEPT_Comment

Select	Replace(f.U_AGREE_DEPT_COMMENT, '!@', '')
		From	EWFFORM_MIG.dbo.Form_Y2C2E2C72B0B24A3782D8BCAA162C52E6 f
				Join	eWF.dbo.Process_Instance p
					On	p.Oid = f.Process_Id 
				Join	eWF.dbo.Work_Item w
					On	w.Oid = p.Parent_Work_Item_Oid
		Where	p.Parent_Oid = 'ZDE8A9621477B4CD7B846B524886A6D9D'
			and	Left(w.Participant_id, 4) = '2594'

select	Process_Id, U_AGREE_DEPT,	U_AGREE_DEPT_COMMENT,	U_AGREE_DEPT_ID
from	EWFFORM_MIG.dbo.form_Y2C2E2C72B0B24A3782D8BCAA162C52E6	where	process_id = 'Z1960A58E52CD4E548E48EA46B41E46EF' -- 발신부서
select	Process_Id, U_AGREE_DEPT,	U_AGREE_DEPT_COMMENT,	U_AGREE_DEPT_ID
from	EWFFORM_MIG.dbo.form_Y2C2E2C72B0B24A3782D8BCAA162C52E6	where	process_id = 'Z6F1E725A42F64853ABF15E6B999EB9C9' -- 합의부서1
select	Process_Id, U_AGREE_DEPT,	U_AGREE_DEPT_COMMENT,	U_AGREE_DEPT_ID
from	EWFFORM_MIG.dbo.form_Y2C2E2C72B0B24A3782D8BCAA162C52E6	where	process_id = 'Z3364F2C9F20F4DACA4A280AD84F8F507' -- 합의부서2
select	Process_Id, U_AGREE_DEPT,	U_AGREE_DEPT_COMMENT,	U_AGREE_DEPT_ID
from	EWFFORM_MIG.dbo.form_Y2C2E2C72B0B24A3782D8BCAA162C52E6	where	process_id = 'ZD7BEA61B16F840B9B3B963765A8C84EA' -- 합의부서2

select	Oid, Parent_Oid, Parent_Work_Item_Oid
from	ewf.dbo.Process_instance	where	Parent_Oid = 'Z1960A58E52CD4E548E48EA46B41E46EF'

select	Oid, Parent_Oid, Parent_Work_Item_Oid
from	ewf.dbo.Process_instance	where	oid = 'Z1960A58E52CD4E548E48EA46B41E46EF'
select	Oid, Parent_Oid, Parent_Work_Item_Oid
from	ewf.dbo.Process_instance	where	oid = 'Z6F1E725A42F64853ABF15E6B999EB9C9'
select	Oid, Parent_Oid, Parent_Work_Item_Oid
from	ewf.dbo.Process_instance	where	oid = 'Z3364F2C9F20F4DACA4A280AD84F8F507'
select	Oid, Parent_Oid, Parent_Work_Item_Oid
from	ewf.dbo.Process_instance	where	oid = 'ZD7BEA61B16F840B9B3B963765A8C84EA'

Exec dbo.UP_Select_AgreeDept_Comment 'YB132CCF992074F738816938A12F7B758', 'ZF02A3FE0555E473EA5047D595357B92D', @wU_AGREE_DEPT_Comment output

*/

AS

set transaction isolation level read uncommitted

Create	Table	#U_AGREE_DEPT_ID
(
	U_AGREE_DEPT_ID	varchar(1000)
)
Create	Table	#U_AGREE_DEPT_COMMENT
(
	U_AGREE_DEPT_COMMENT	varchar(8000)
)

Declare	@wU_AGREE_DEPT_ID		varchar(1000),
		@wU_AGREE_DEPT_ID_rtn	varchar(4),
		@vcBal1					int,
		@wProcess_Id			char(33),
		@wSql					varchar(8000),
		@i						int,

		@i2	int,
		@pColComment		varchar(8000),
		@pColCommentRtn		varchar(8000),
		@wColSeparatorPos	int,

		@wU_AGREE_DEPT_COMMENT	varchar(8000)



	--	양식테이블에서 합의부서들의 코드 읽음
	Set	@wSql = "
		Insert	Into	#U_AGREE_DEPT_ID
				(U_AGREE_DEPT_ID)
				Select	Case
							When	Rtrim(Ltrim(U_AGREE_DEPT_ID)) in ('undefined', 'NULL')	Then
								''
							Else
								Replace(U_AGREE_DEPT_ID, '!@', '_/')
						End
				From	EWFFORM_MIG.dbo.Form_" + @pForm_ID + "
				Where	Process_Id = '" + @pPROCESS_ID + "'
		"
	Exec (@wSql)

	Select	@wU_AGREE_DEPT_ID = U_AGREE_DEPT_ID	From	#U_AGREE_DEPT_ID
	Select	@pU_AGREE_DEPT_Comment = ''

	--	합의부서의 갯수만큼 loop
	Set	@i = 1
	While	(1 = 1)
	Begin

		--	기안부서의 ProcessID
		Select	@wProcess_Id = Parent_Oid
		From	EWF_MIG.dbo.Process_Instance
		Where	Oid = @pPROCESS_ID
	
		If	IsNull(@wProcess_Id, '') = ''
			Select	@wProcess_Id = @pPROCESS_ID

		Exec @vcBal1 = dbo.USP_MIG_SDAOBGetCols @wU_AGREE_DEPT_ID OutPut, @wU_AGREE_DEPT_ID_rtn OutPut      

		If	@wU_AGREE_DEPT_ID_rtn = ''	Break 
--			Select	@pU_AGREE_DEPT_Comment = @pU_AGREE_DEPT_Comment + Replace(f.U_AGREE_DEPT_COMMENT, '!@', '')

		Set	@wSql = "
			Insert	Into	#U_AGREE_DEPT_COMMENT
					(U_AGREE_DEPT_COMMENT)
			Select	f.U_AGREE_DEPT_COMMENT
			From	EWFFORM_MIG.dbo.Form_" + @pForm_ID + " f
					Join	EWF_MIG.dbo.Process_Instance p
						On	p.Oid = f.Process_Id 
					Join	EWF_MIG.dbo.Work_Item w
						On	w.Oid = p.Parent_Work_Item_Oid
			Where	p.Parent_Oid = '" + @wProcess_Id + "'
				and	Left(w.Participant_id, 4) = " + @wU_AGREE_DEPT_ID_rtn + ""

		Exec (@wSql)

		Select	@wU_AGREE_DEPT_COMMENT = U_AGREE_DEPT_COMMENT
		From	#U_AGREE_DEPT_COMMENT

		Exec dbo.USP_MIG_GetStringByIndex @wU_AGREE_DEPT_COMMENT, @wU_AGREE_DEPT_COMMENT output, @i

		Set	@pU_AGREE_DEPT_Comment = @pU_AGREE_DEPT_COMMENT + IsNull(Rtrim(Ltrim(@wU_AGREE_DEPT_Comment)), '')

-- select	@wProcess_Id
-- select	@wU_AGREE_DEPT_ID_rtn
		If	@wU_AGREE_DEPT_ID <> ''
			Set	@pU_AGREE_DEPT_Comment = @pU_AGREE_DEPT_COMMENT + '!@'

		Set	@i = @i + 1
	
	End











GO
/****** Object:  StoredProcedure [dbo].[USP_MIG_SELECT_AGREEDEPT_TONGJE]    Script Date: 2015-10-15 오후 1:30:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
-- =============================================
-- Author:		박인희
-- Create date: 2015-06-02
-- Description: 
-- UP_SELECT_AGREEDEPT_TONGJE 마이그레이션
/*
	declare	@pU_AGREE_DEPT_Comment	varchar(1000) 
	EXEC USP_MIG_SELECT_AGREEDEPT_TONGJE 'Y9FA891C60DF54882BAE0DA51F233AF69', 'Z7C713861D6C94E8DBCA66D947263D1B8', @pU_AGREE_DEPT_Comment output
	select	@pU_AGREE_DEPT_Comment
*/
-- =============================================
CREATE PROCEDURE	[dbo].[USP_MIG_SELECT_AGREEDEPT_TONGJE]
		@pForm_ID		char(33),
		@pPROCESS_ID	char(33),
		@pTONGJE		varchar(1000) output
/*

declare	@pU_AGREE_DEPT_Comment	varchar(1000) 
exec dbo.USP_MIG_SELECT_AGREEDEPT_TONGJE	'Y9FA891C60DF54882BAE0DA51F233AF69', 'Z7C713861D6C94E8DBCA66D947263D1B8', @pU_AGREE_DEPT_Comment output
select	@pU_AGREE_DEPT_Comment

*/

AS
BEGIN

	set transaction isolation level read uncommitted


	Create	Table	#Data
	(
		Data1	varchar(8000),
		Data2	varchar(8000)
	)

	Declare	@wProcess_Id	char(33),
		@wLastProcess_Id	char(33),
		@wSql			varchar(1000),
		@wSubStrIdx		varchar(2)

	--	기안부서의 ProcessID
	Select	@wProcess_Id = Parent_Oid
	From	EWF_MIG.dbo.Process_Instance
	Where	Oid = @pPROCESS_ID

	If	IsNull(@wProcess_Id, '') = ''
		Select	@wProcess_Id = @pPROCESS_ID

--	Drop	Table	#ProcList
	Select	w.Process_Instance_Oid, IsNull(w.Completed_Date, w.Create_Date) as Completed_Date
	Into	#ProcList
	From	EWF_MIG.dbo.Work_Item w
			Join	(Select	@wProcess_Id	as Oid
					Union
					Select	Oid
					From	EWF_MIG.dbo.Process_Instance
					Where	Parent_Oid = @wProcess_Id) p
				On	p.Oid = w.Process_Instance_Oid
	Where	w.[Name] like '기안%'
		or	w.[Name] like '일반결재자%'

	Select	@wLastProcess_Id = p.Process_Instance_Oid
	From	#ProcList p
			Join	(Select	Max(Completed_Date) Completed_Date
					From	#ProcList) d
				On	d.Completed_Date = p.Completed_Date

	Set	@wSql = "
		Insert	Into	#Data
				(Data1, Data2)
		Select	Case
					When	Ltrim(Rtrim(f.Tongje)) = '' or Ltrim(Rtrim(f.Tongje)) = '뷁'	Then
						''
					Else
						Substring(f.Tongje, 1, charindex('뷁', f.Tongje) - 1)
				End,
				Case
					When	Ltrim(Rtrim(f.Tongje)) = '' or Ltrim(Rtrim(f.Tongje)) = '뷁'	Then
						''
					Else
						Substring(f.Tongje, charindex('뷁', f.Tongje) + 1,  len(f.Tongje) - charindex('뷁', f.Tongje))
				End
		From	EWFFORM_MIG.dbo.Form_" + @pForm_ID + " f
		Where	f.Process_Id = '" + @wLastProcess_Id + "'
		"
	Exec(@wSql)


	Select	@pTONGJE = IsNull(Data1, '') + '뷁' + IsNull(Data2, '')
	From	#Data

END


GO
/****** Object:  StoredProcedure [dbo].[USP_MIG_SELECT_APRLINEINFORM]    Script Date: 2015-10-15 오후 1:30:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-------------------------------------------------------------------------------------
-- 작성자: 신철호
-- 작성일: 2004.03.05
-- 수정일: 2004.03.05
-- 설명 : 결재자정보를 조회한다
-- 실  행:
-------------------------------------------------------------------------------------
-- =============================================
-- Author:		박인희
-- Create date: 2015-06-02
-- Description: 결제자 양식 조회
-- UP_SELECT_APRLINEINFORM 마이그레이션
/*
	EXEC USP_MIG_SELECT_APRLINEINFORM 'Z190F46A9C34C407C8D1A460840C9A4D2'
*/
-- =============================================
CREATE PROCEDURE [dbo].[USP_MIG_SELECT_APRLINEINFORM]
	@vcProcessID			varchar(33)
AS
BEGIN

	SET NOCOUNT ON


	SELECT REPLACE(CAST(SIGN_CONTEXT AS NVARCHAR(MAX)), 'http://lcware.lottechilsung.co.kr/ekwv2/Data/', 'http://portal.lottechilsung.co.kr/um/Data/') AS SIGN_CONTEXT
	from EWF_MIG.dbo.PROCESS_SIGN_INFORM(NOLOCK)
	WHERE PROCESS_INSTANCE_OID = @vcProcessID
	
END


GO
/****** Object:  StoredProcedure [dbo].[USP_MIG_SELECT_DICTIONARY]    Script Date: 2015-10-15 오후 1:30:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* =====================================================================
	화면 및 기능 : 
	작성자 : 유승호
	작성일 : 2004/03/15
	참고사항 :
						
       테스트 :
		 EXEC DBO.USP_MIG_SELECT_DICTIONARY 'KOREAN'
 ===================================================================== */
-- =============================================
-- Author:		박인희
-- Create date: 2015-06-02
-- Description: 용어테이블 조회
-- UP_SELECT_DICTIONARY 마이그레이션
/*
	EXEC USP_MIG_SELECT_DICTIONARY 'KOREAN'
*/
-- =============================================
CREATE PROCEDURE [dbo].[USP_MIG_SELECT_DICTIONARY]
	@VNCTYPE NVARCHAR(50)
AS
BEGIN
	DECLARE @VNCIMSI NVARCHAR(200)
	SET @VNCIMSI = N'SELECT LABEL, ' + @VNCTYPE + ' AS ''LANG'' FROM EMANAGE_MIG.DBO.TB_DICTIONARY'
	--PRINT @VNCIMSI
	EXEC SP_EXECUTESQL @VNCIMSI
END



GO
/****** Object:  StoredProcedure [dbo].[USP_MIG_SELECT_FORM_REFERENCE]    Script Date: 2015-10-15 오후 1:30:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		박인희
-- Create date: 2015-06-02
-- Description: 관련문서 조회
-- UP_SELECT_FORMS_DATA 마이그레이션
/*
	EXEC USP_MIG_SELECT_FORM_REFERENCE 'Z190F46A9C34C407C8D1A460840C9A4D2'
*/
-- =============================================
CREATE PROCEDURE	[dbo].[USP_MIG_SELECT_FORM_REFERENCE]
		@strRefId	varchar(33)
AS
BEGIN


	Declare	@wProcessID	varchar(33)

	Select	@wProcessID = Parent_Oid
	From	EWF_MIG.dbo.Process_Instance
	Where	Oid = @strRefId

	If	IsNull(Ltrim(Rtrim(@wProcessID)), '') <> ''
		Set	@strRefId = @wProcessID

	Select	i.OID, i.NAME, p.SUBJECT, i.CREATOR, i.COMPLETED_DATE, p.ISATTACHFILE, p.POSTSCRIPT
	From	dbo.WF_FORM_REFERENCE m (nolock)
			Join	EWF_MIG.dbo.PROCESS_INSTANCE i (nolock)
				On	i.Oid = m.REF_PROCESS_ID
			Join	dbo.WF_FORMS_PROP p (nolock)
				On	p.Process_ID = m.REF_PROCESS_ID
	Where	m.Process_ID = @strRefId


END


GO
/****** Object:  StoredProcedure [dbo].[USP_MIG_SELECT_FORMS_DATA]    Script Date: 2015-10-15 오후 1:30:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
/*	--------------------------------------------------------------
	작성자: 임병태
	작성일: 2004.03.17
	수정일: 2005.08.31
	수정자: 김진시
	수정내용: DB결재 양식인지 구분할 FORM_TYPE 추가
	설명 : 결재폼 양식 데이터 정보를 가져온다
	exec dbo.USP_MIG_SELECT_FORMS_DATA 'Z666C4779C246423B8449662AFABC041C'

--------------------------------------------------------------	*/
-- =============================================
-- Author:		박인희
-- Create date: 2015-06-02
-- Description: DB결재 양식인지 구분할 FORM_TYPE 추가
-- UP_SELECT_FORMS_DATA 마이그레이션
/*
	EXEC USP_MIG_SELECT_FORMS_DATA 'ZDB8DBD26B8974B4A834EA66C1999C051'
*/
-- =============================================
CREATE PROCEDURE	[dbo].[USP_MIG_SELECT_FORMS_DATA]
	@PROCESS_ID	varchar(50)	-- 프로세스 ID
As
BEGIN

	Set Transaction isolation level read uncommitted

	Declare	@vcFORM_ID	VARCHAR(50),		-- 결재 양식 폼 ID
			@nvcDY_SQL	NVARCHAR(4000),		-- 동적 양식 폼 조회 ID
			@cFOLDERTYPE	char(1),
			@intFOLDERID	int

	-- 프로세스 ID로 결재양식 폼 ID 가져오기
	Set	@vcFORM_ID = (Select	FORM_ID	From	dbo.WF_FORMS_PROP (NOLOCK)	Where	PROCESS_ID = @PROCESS_ID)

	Select	@intFOLDERID = FOLDERID
	From	WF_FOLDER_DETAIL (NOLOCK)
	Where	FORM_ID = @vcFORM_ID

	Select	@cFOLDERTYPE = FOLDERTYPE
	From	WF_FOLDER (NOLOCK)
	Where	FOLDERID = (Select	PARENTFOLDERID	From	WF_FOLDER (NOLOCK)	Where	FOLDERID = @intFOLDERID)

	-- 1. 양식 폼 헤더 정보
	Select	* ,@cFOLDERTYPE FOLDER_TYPE
	From	dbo.WF_FORMS (NOLOCK)
	Where	FORM_ID= @vcFORM_ID

	-- 2. 양식 폼의 스키마 정보
	Select	 *
	From	dbo.WF_FORM_SCHEMA (NOLOCK)
	Where	FORM_ID= @vcFORM_ID

	-- 3. 양식폼의 필드정보
	Select	*
	From	dbo.WF_FORM_INFORM (NOLOCK)
	Where	FORM_ID= @vcFORM_ID

	--	4. 결재양식 폼에서 프로세스 ID에 해당하는 폼 데이터를 가져오는 SQL를 생성한다.
	--	Drop	Table	#WF_FORM_INFORM
	Declare	@wTotalRowCount	int

	Declare	@WF_FORM_INFORM	Table
	(
		Field_Name	varchar(30),
		Num			int	identity(1, 1)
	)

	Insert	Into	@WF_FORM_INFORM
			(Field_Name)
	Select	Field_Name
--	Select	Field_Name, identity(int, 1, 1) as Num
--	Into	#WF_FORM_INFORM
	From	dbo.WF_FORM_INFORM
	Where	Form_ID = @vcFORM_ID
	Order by Field_Name

	Set	@wTotalRowCount = @@RowCount

	--	기안서 시리즈에 데이타 공유 작업
	Declare	@wU_AGREE_DEPT_Comment	varchar(8000),
			@wTongje				varchar(1000)

	Select	@wU_AGREE_DEPT_Comment = '',
			@wTongje = ''

	If	@vcFORM_ID in (Select	Form_ID	From	dbo.WF_Forms	Where	Form_EName in ('LC_DRAFT', 'LC_DRAFT_BRANCH', 'LC_SUPPORT_DRAFT'))
	Begin

		Exec dbo.USP_MIG_SELECT_AGREEDEPT_COMMENT @vcFORM_ID, @PROCESS_ID, @wU_AGREE_DEPT_Comment output

		If	@vcFORM_ID in (Select	Form_ID	From	dbo.WF_Forms	Where	Form_EName in ('LC_DRAFT', 'LC_DRAFT_BRANCH'))
			Exec dbo.USP_MIG_SELECT_AGREEDEPT_TONGJE @vcFORM_ID, @PROCESS_ID, @wTongje output

	End

	--	Select 쿼리 만드는 Loop 
	Declare	@wField_Name	varchar(1000),
			@wSql			varchar(8000),
			@wNum	int

	Select	@wField_Name = '',
			@wNum = 0,
			@wSql = ""

	While (1 = 1)
	Begin

		Select	Top 1
				@wNum = Num,
				@wField_Name = Field_Name
		From	@WF_FORM_INFORM
		Where	Num > @wNum
		Order by Num

		If	@@Rowcount = 0	Break

		IF	@wField_Name = 'U_AGREE_DEPT_COMMENT'
			SET	@wSql = @wSql + '"' + IsNull(@wU_AGREE_DEPT_Comment, '') + '" as U_AGREE_DEPT_COMMENT'
		ELSE IF	@wField_Name = 'TONGJE'
			SET	@wSql = @wSql + '"' + IsNull(@wTongje, '') + '" as TONGJE'
		ELSE IF @wField_Name = 'CREATOR_SIGN' 
			SET @wSql = @wSql + 'REPLACE(CREATOR_SIGN,''http://lcware.lottechilsung.co.kr/ekwv2/Data/'',''http://portal.lottechilsung.co.kr/um/Data/'') AS CREATOR_SIGN'
		ELSE IF @wField_Name = 'HTMLDESCRIPTION'
			SET @wSql = @wSql + 'REPLACE(CAST(HTMLDESCRIPTION AS NVARCHAR(MAX)),''http://lcware.lottechilsung.co.kr/ekwv2/Data/'',''http://portal.lottechilsung.co.kr/um/Data/'') AS HTMLDESCRIPTION'
		ELSE
			SET	@wSql = @wSql + @wField_Name

--		If	@wNum < @wTotalRowCount
			Set	@wSql = @wSql + ', '

	End

	--	첨언 테이블 조회
	Declare	@wComment	varchar(8000)

	Exec USP_MIG_SELECT_SIGNER_COMMENT @PROCESS_ID, @wComment output

	IF	@wComment IS NULL
		SET	@wComment = "''"

	Set	@wSql = @wSql + @wComment + ' as U_Comment'

	--	조회
	Set	@wSql = "Select	" + @wSql + "	From	dbo.FORM_" + @vcFORM_ID + "	Where	Process_Id = '" + @PROCESS_ID + "'"
	print (@wSql)
	Exec (@wSql)

-- 	Begin
-- 
-- 		SET @nvcDY_SQL = N'Select	* From	dbo.FORM_' + @vcFORM_ID + ' (NOLOCK) Where	PROCESS_ID=@PROCESS_ID'
-- 		EXEC SP_EXECUTESQL  @nvcDY_SQL, N'@PROCESS_ID VARCHAR(50)', @PROCESS_ID
-- 
-- 	End

END


GO
/****** Object:  StoredProcedure [dbo].[USP_MIG_SELECT_MULTIRCVDEPTINFO]    Script Date: 2015-10-15 오후 1:30:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
----------------------------------------------------------------------
-- 작성자: 신철호
-- 작성일: 2004.09.20
-- 수정일: 2004.09.20
-- 설  명: 협조부서 리스트 조회
-- 테스트: 

/*
-- 부모프로세스ID,폼ID
EXEC  USP_MIG_SELECT_MULTIRCVDEPTINFO 'ZF7973B0C44C94A3386387F675C72EB43'

*/
----------------------------------------------------------------------
-- =============================================
-- Author:		박인희
-- Create date: 2015-06-02
-- Description: 협조부서 리스트 조회
-- UP_SELECT_MULTIRCVDEPTINFO 마이그레이션
/*
	EXEC USP_MIG_SELECT_MULTIRCVDEPTINFO 'Z190F46A9C34C407C8D1A460840C9A4D2'
*/
-- =============================================
CREATE PROCEDURE	[dbo].[USP_MIG_SELECT_MULTIRCVDEPTINFO]
	@vcPOID		VARCHAR(33)
AS
BEGIN

	-- <pre-Step : 환경설정>
	SET NOCOUNT ON;

	DECLARE	@sQuery	VARCHAR(4000), @vcFormId VARCHAR(33)
	Set	@vcFormId = (Select	FORM_ID	From	dbo.WF_FORMS_PROP (NOLOCK)	Where	PROCESS_ID = @vcPOID)

	--PRINT @vcFormId
-- <Step-1-1 : 데이터 조회 - 전체>

/*SET @sQuery =	'Select	'''' AS NNo, PIN.OID ' +
		'FROM dbo.PROCESS_INSTANCE AS PIN  WITH (READUNCOMMITTED) ' +
		'WHERE PIN.PARENT_OID = ''' + @vcPOID + ''''*/


	If	@vcFormId in ('Y28B72F2F7EE54FB5BE13E8F2A3637978', 'YFA4BC440266849EB8DBA1A1FE7C55EE6', 'YB132CCF992074F738816938A12F7B758')	--	운영
--		@vcFormId in ('Y9FA891C60DF54882BAE0DA51F233AF69', 'Y2C2E2C72B0B24A3782D8BCAA162C52E6', 'Y5770BC516ABC4E6881567B3AB08F2638')
	Begin
		Declare	@wParentOID	varchar(50)

		Select	@wParentOID = Parent_Oid
		From	EWF_MIG.dbo.PROCESS_INSTANCE
		Where	Oid = @vcPOID

		If	IsNull(Ltrim(Rtrim(@wParentOID)), '') <> ''
			Set	@vcPOID = @wParentOID
	End


	Set	@sQuery = '
		Select	null as NNo, 
				EMDEPT.DEPTNAME,			
				FORM.APPROVAL_STATE AS STATE,
				PIN.OID
		From	EWF_MIG.dbo.PROCESS_INSTANCE AS PIN  WITH (READUNCOMMITTED)
				Join	EWF_MIG.dbo.WORK_ITEM AS WI  WITH (READUNCOMMITTED)
					On	PIN.PARENT_WORK_ITEM_OID = WI.OID
				Join	EMANAGE_MIG.dbo.TB_DEPT AS EMDEPT  WITH (READUNCOMMITTED)
	      			On	Convert(int, Left(WI.PARTICIPANT_ID, Len(WI.PARTICIPANT_ID)-2)) = EMDEPT.DEPTID       
				Join	EWFFORM_MIG.dbo.FORM_' + @vcFormId + ' AS FORM WITH (READUNCOMMITTED)
					On	PIN.OID = FORM.PROCESS_ID
		Where	PIN.PARENT_OID = ''' + @vcPOID + ''' '
	

	--PRINT @sQuery

	EXEC(@sQuery)
END



GO
/****** Object:  StoredProcedure [dbo].[USP_MIG_SELECT_PROCESS_ATTRIBUTE]    Script Date: 2015-10-15 오후 1:30:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		박인희
-- Create date: 2015-06-02
-- Description: 결재 프로세스 Attribute 내용을 가져온다.
-- UP_SELECT_PROCESS_ATTRIBUTE 마이그레이션
/*
	EXEC USP_MIG_SELECT_PROCESS_ATTRIBUTE 'Z190F46A9C34C407C8D1A460840C9A4D2'
*/
-- =============================================
CREATE PROCEDURE [dbo].[USP_MIG_SELECT_PROCESS_ATTRIBUTE]
(
	@PROCESS_ID		VARCHAR(50)
)
-------------------------------------------------------------------------------------
-- 작성자: 임병태
-- 작성일: 2004.03.10
-- 수정일: 2004.03.10
-- 설명 : 결재 프로세스 Attribute 내용을 가져온다.
-------------------------------------------------------------------------------------
-- 실행 : EXEC USP_MIG_SELECT_PROCESS_ATTRIBUTE 'Z5EA508F5F5054A889C71B301540126A7'
-------------------------------------------------------------------------------------
AS
BEGIN
	DECLARE 
		@nTEXTSIZE  	INT,
		@nvcDY_SQL	NVARCHAR(500)		-- 동적 양식 폼 조회 ID
	-- TEXT 필드 길이를 계산한다.
	SET @nTEXTSIZE = (SELECT ISNULL(DATALENGTH(ATTRIBUTE),0) FROM EWF_MIG.dbo.PROCESS_ATTRIBUTE (NOLOCK)  WHERE PROCESS_INSTANCE_OID = @PROCESS_ID )
	-- 100 바이트 추가로 적용한다.
	SET @nTEXTSIZE = @nTEXTSIZE + 100 
	SET @nvcDY_SQL = N'SET TEXTSIZE ' + CONVERT(VARCHAR, @nTEXTSIZE) + ' SELECT ATTRIBUTE  FROM EWF_MIG.dbo.PROCESS_ATTRIBUTE (NOLOCK)  WHERE PROCESS_INSTANCE_OID = @PROCESS_ID'
	EXEC SP_EXECUTESQL  @nvcDY_SQL, N'@PROCESS_ID VARCHAR(50)', @PROCESS_ID

	--PRINT(@nvcDY_SQL)
END


GO
/****** Object:  StoredProcedure [dbo].[USP_MIG_SELECT_SIGNER_COMMENT]    Script Date: 2015-10-15 오후 1:30:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
/*	----------------------------------------------------
-- 작성자: 신철호
-- 작성일: 2004.03.05
-- 수정일: 2004.03.05
-- 설명 : 결재자정보를 추가한다

declare	@pComment	varchar(8000)
exec	USP_MIG_Select_Signer_Comment 'ZF20512C6BFBE4E478AE4044F05C40623', @pComment output
select	@pComment

----------------------------------------------------	*/
-- =============================================
-- Author:		박인희
-- Create date: 2015-06-02
-- Description: 결재자 첨언 조회
-- UP_SELECT_SIGNER_COMMENT 마이그레이션
/*
 DECLARE @pComment	VARCHAR(8000)
 EXEC USP_MIG_SELECT_SIGNER_COMMENT 'Z87679F8537CB436F98A8FCEF75179889', @pComment OUTPUT
 SELECT @pComment
*/
-- =============================================
CREATE PROCEDURE	[dbo].[USP_MIG_SELECT_SIGNER_COMMENT]
	@pProcessID		char(33)		= '',
	@pComment		varchar(8000)	= '' OutPut
AS
BEGIN

	Set	Nocount On

	Declare	@wProcessID	char(33)

	--	기안부서의 ProcessID
	Select	@wProcessID = Parent_Oid
	From	EWF_MIG.dbo.Process_Instance
	Where	Oid = @pProcessID

	If	IsNull(@wProcessID, '') = ''
		Select	@wProcessID = @pProcessID

	Declare	@wRowCount	int
	Declare	@pTable		Table
	(
		RowNum		int	identity(1, 1),
		DeptName	varchar(30),
		UserName	varchar(30),
		Comment		varchar(8000)
	)
	Insert	Into	@pTable
				(DeptName,	UserName,	Comment)
		Select	u.DeptName,	u.UserName, c.Comment
		From	dbo.WF_Signer_Comment c with (nolock)
				Join	(Select	@wProcessID	as OID
						Union
						Select	OID
						From	EWF_MIG.dbo.Process_Instance p with (nolock)
						Where	Parent_Oid = @wProcessID) o
					On	o.OID = c.Process_Instance_OID
				Join	EWF_MIG.dbo.Work_Item w with (nolock)
					On	w.Process_Instance_OID = c.Process_Instance_OID
					and	w.OID = c.Work_Item_OID
					and	w.NAME LIKE '%일반결재자%'
				Join	EMANAGE_MIG.dbo.VW_User u with (nolock)
					On	u.UserID = w.Participant_ID
					and	u.EndDate > GetDate()
					and	u.PositionOrder = 1
		Order by c.CreateDate

	--	전체 행수
	Set	@wRowCount = @@RowCount	

	Declare	@wRowNum	int,
			@wDeptName	varchar(500),
			@wUserName	varchar(500),
			@wComment	varchar(8000)

	Select	@wRowNum	= 0,
			@wDeptName	= '',
			@wUserName	= '',
			@wComment	= ''

	While	(1 = 1)
	Begin

		Select	Top 1
				@wRowNum	= RowNum,
				@wDeptName	= @wDeptName + DeptName,
				@wUserName	= @wUserName + UserName,
				@wComment	= @wComment	+ Comment
		From	@pTable
		Where	RowNum > @wRowNum
		Order by RowNum
		
		If	@@RowCount = 0	Break

		--	마지막 행에는 구분자를 넣지 않기 위함
		If	@wRowNum < @wRowCount
			Select	@wDeptName	= @wDeptName + '|',
					@wUserName	= @wUserName + '|',
					@wComment	= @wComment	+ '|'

	End
	
	Select	@pComment = '"' + @wDeptName + '_/' + @wUserName + '_/' + Replace(Replace(@wComment, char(13), '<br/>'), ' ', '&nbsp;') + '"'

END


GO
/****** Object:  StoredProcedure [dbo].[USP_MIG_SELECT_SUBPROCESSID]    Script Date: 2015-10-15 오후 1:30:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		박인희
-- Create date: 2015-06-02
-- Description:	전자결재 목록 조회
-- UP_SELECT_SUBPROCESSID 마이그레이션
-- EXEC USP_MIG_SELECT_SUBPROCESSID 'Z87679F8537CB436F98A8FCEF75179889'
-- =============================================
CREATE PROCEDURE	[dbo].[USP_MIG_SELECT_SUBPROCESSID]
	@pProcessID	VARCHAR(33)

AS
BEGIN
	DECLARE	@wProcessID	varchar(33)

	--	기안부서의 ProcessID
	SELECT	@wProcessID = Parent_Oid
	FROM	EWF_MIG.dbo.Process_Instance
	WHERE	Oid = @pProcessID

	--	Parent_Oid가 없으면 현재부서가 기안부서다.
	IF	ISNULL(@wProcessID, '') = ''
		SELECT	@wProcessID = @pProcessID

	--	같은 기안부서의 OID를 ParentID로 가지고 있는 합의부서 조회
	SELECT	p.Oid, w.Create_Date, Left(w.Participant_id, 4) as DeptID
	FROM	EWF_MIG.dbo.Process_Instance p
			Join	EWF_MIG.dbo.Work_Item w
				On	w.Oid = p.Parent_Work_Item_Oid
	WHERE	p.Parent_Oid = @wProcessID
-- 	Union
-- 	Select	@wProcessID, getdate(), ''
-- 	Order by w.Create_Date

END



GO
/****** Object:  StoredProcedure [dbo].[view_data]    Script Date: 2015-10-15 오후 1:30:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create procedure [dbo].[view_data]
	@pProcedureID char(33)
as

SELECT u_bodycontent1
    FROM dbo.FORM_YAE7EEC57433B4884AAC95B65128C3F0A
	WHERE process_id = @pProcedureID


GO
