[dbo].[kmp_log_201903] WHERE DEST_PHONE = '010-2526-4859'


-- ī��
EXEC [kakaoTalk].[dbo].[kakaosend] @wPhoneNumber, '01020378422', @plms_msg, 'LMSG_20190116152750894994', 'MMS', @plms_msg

EXEC [sms_system].DBO.SLMS_EIS_Insert_KAKAO_IT 'Y', @SMSSUBJECT, @SMSTEXT




declare 
@SMSSUBJECT VARCHAR(40),
@SMSTEXT	VARCHAR(2000)

SELECT @SMSSUBJECT = RIGHT(CONVERT(CHAR(8), DATEADD(DD, -1, GETDATE()), 112), 8)
SELECT @SMSTEXT = '[2019-03-28 ���� EIS ���� �ȳ�]
[�޼���]
����(3.6,93.5,+6.5)
1����(3.2,94.5,+1.1)
2����(3.3,94.8,+3.9)
3����(3.2,92.5,+1.0)
������(4.2,92.2,+12.0)
Ư��(4.7,92.4,+8.3)
E-biz(3.2,100.5,+67.1)

[�����]
����(50��,1322��,+69��)
1����(10��,284��,+0��)
2����(10��,274��,+7��)
3����(8��,239��,+0��)
������(20��,433��,+45��)
Ư��(3��,57��,+3��)
E-biz(1��,34��,+13��)'


select @SMSTEXT

EXEC [sms_system].DBO.SLMS_EIS_Insert_KAKAO 'N', @SMSSUBJECT, @SMSTEXT


-- ���� �׽�Ʈ��
--EXEC [kakaoTalk].[dbo].[kakaosend] '01025264859', '01020378422', @SMSTEXT, 'LMSG_20190116152750894994', 'MMS', @SMSTEXT

-- ������ �׽�Ʈ��
--EXEC [sms_system].DBO.SLMS_EIS_Insert_KAKAO_IT 'Y', @SMSSUBJECT, @SMSTEXT

-- ���� ��
--EXEC [sms_system].DBO.SLMS_EIS_Insert_KAKAO 'N', @SMSSUBJECT, @SMSTEXT




/*
[2019-02-28 ���� EIS ���� �ȳ�]
[�޼���]
����(3.1,98.9,+3.6)
1����(1.7,97.9,+1.4)
2����(1.5,101.9,+5.9)
3����(1.9,94.9,-1.3)
������(4.7,100.7,+4.8)
Ư��(3.7,90.9,-5.5)
E-biz(9.2,103.0,+66.1)

[�����]
����(36��,1160��,+41��)
1����(4��,250��,+3��)
2����(3��,229��,+13��)
3����(4��,212��,-3��)
������(19��,394��,+18��)
Ư��(2��,46��,-3��)
E-biz(2��,28��,+11��)
*/