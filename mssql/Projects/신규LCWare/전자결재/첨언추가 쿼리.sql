

/**************************************
*
* �Ϸ�� ���ڰ��� ÷���߰� 
* �ۼ� : 2018-08-10 �̿ϻ�
*
***************************************/


[WF].[PROCESS_COMMENT]  WHERE PROCESS_INSTANCE_OID = 'PE6A733977F85402EA44D3342C45EB3C8'

[WF].[PROCESS_SIGNER] WHERE PROCESS_INSTANCE_OID = 'PE6A733977F85402EA44D3342C45EB3C8'


DECLARE 
	-- @cCommentOid		char(33)	
	@vcUserId		nvarchar(50)
,	@vcUserName		nvarchar(100)
,	@vcPosName		nvarchar(100)
,	@vcDeptId		nvarchar(50)
,	@vcDeptName		nvarchar(100)
,	@dtCreateDate		datetime
,	@sign_oid		char(33)

SELECT 
@vcUserId = USER_ID
, @vcUserName = USER_NAME
, @vcPosName = DUTY_NAME
, @vcDeptId = DEPT_ID
, @vcDeptName = DEPT_NAME
, @dtCreateDate = getdate()
, @sign_oid = SIGN_OID
FROM [WF].[PROCESS_SIGNER] 
WHERE PROCESS_INSTANCE_OID = 'PE6A733977F85402EA44D3342C45EB3C8'
AND USER_NAME = '����ä'

-- select @vcUserId
begin tran
INSERT INTO WF.PROCESS_COMMENT
(
	COMMENT_OID
,	PROCESS_INSTANCE_OID
,	SIGN_OID
,	[USER_ID]
,	[USER_NAME]
,	POS_NAME
,	COMMENT_TYPE
,	COMMENT_TEXT
,	DEPT_ID
,	DEPT_NAME
,	CREATE_DATE

)
VALUES 	
(	
	''	-- NULL ó�� (�߰���)
,	'PE6A733977F85402EA44D3342C45EB3C8'	
,	@sign_oid
,	@vcUserId	
,	@vcUserName
,	@vcPosName
,	'0'
,	''		
,	@vcDeptId
,	@vcDeptName
,	@dtCreateDate	
)

commit


-- ÷����� ������ �߰��� ��� �Ʒ� UPDATE ������� 
if(@@rowcount > 0)
	UPDATE WF.PROCESS_INSTANCE
	SET EXIST_COMMENT = 'Y'
	WHERE OID = @pid	
end

