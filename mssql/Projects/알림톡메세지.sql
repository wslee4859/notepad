7star@lotte65
lt_7star
[dbo].[kmp_msg]


SELECT * FROM [Common].[IM].[VIEW_USER] WHERE user_name = '�ռҿ�'


[dbo].[kmp_log_201805]

begin tran

DECLARE @e_num nvarchar(30)
SET @e_num = 22079
--SELECT @e_num

DECLARE @user_name nvarchar(30)
SELECT @user_name = user_name FROM [Common].[IM].[VIEW_USER] WHERE employee_num = @e_num

--SELECT @user_name

INSERT INTO kmp_msg (
MSG_TYPE
, CMID
, REQUEST_TIME
, SEND_TIME
, DEST_PHONE
, SEND_PHONE
, MSG_BODY
, TEMPLATE_CODE
, SENDER_KEY
, NATION_CODE
)
VALUES 
(
6 ,'2018053015420008', getdate(), getdate(), '01056863434', '0264247426',
'[īī������] ȸ������ �ȳ�
'+@user_name+'��, īī������ ȸ���� �ǽ� ���� ȯ���մϴ�.

���ű� ���� ȸ�� ����
1���� ���� ��Ʈ���� ���� ����
īī���� �̸�Ƽ�� ����','alimtalktest_001',
'94040debee2faf0734fbd5a200a1a73077869c12', '82');


select @@TRANCOUNT
commit
--rollback