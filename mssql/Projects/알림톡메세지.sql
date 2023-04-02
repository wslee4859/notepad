7star@lotte65
lt_7star
[dbo].[kmp_msg]


SELECT * FROM [Common].[IM].[VIEW_USER] WHERE user_name = '손소영'


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
'[카카오뮤직] 회원가입 안내
'+@user_name+'님, 카카오뮤직 회원이 되신 것을 환영합니다.

▶신규 가입 회원 혜택
1개월 무료 스트리밍 서비스 제공
카카오톡 이모티콘 증정','alimtalktest_001',
'94040debee2faf0734fbd5a200a1a73077869c12', '82');


select @@TRANCOUNT
commit
--rollback