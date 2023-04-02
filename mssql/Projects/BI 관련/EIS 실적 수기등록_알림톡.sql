[dbo].[kmp_log_201903] WHERE DEST_PHONE = '010-2526-4859'


-- 카톡
EXEC [kakaoTalk].[dbo].[kakaosend] @wPhoneNumber, '01020378422', @plms_msg, 'LMSG_20190116152750894994', 'MMS', @plms_msg

EXEC [sms_system].DBO.SLMS_EIS_Insert_KAKAO_IT 'Y', @SMSSUBJECT, @SMSTEXT




declare 
@SMSSUBJECT VARCHAR(40),
@SMSTEXT	VARCHAR(2000)

SELECT @SMSSUBJECT = RIGHT(CONVERT(CHAR(8), DATEADD(DD, -1, GETDATE()), 112), 8)
SELECT @SMSTEXT = '[2019-03-28 음료 EIS 실적 안내]
[달성률]
음료(3.6,93.5,+6.5)
1지역(3.2,94.5,+1.1)
2지역(3.3,94.8,+3.9)
3지역(3.2,92.5,+1.0)
신유통(4.2,92.2,+12.0)
특수(4.7,92.4,+8.3)
E-biz(3.2,100.5,+67.1)

[매출액]
음료(50억,1322억,+69억)
1지역(10억,284억,+0억)
2지역(10억,274억,+7억)
3지역(8억,239억,+0억)
신유통(20억,433억,+45억)
특수(3억,57억,+3억)
E-biz(1억,34억,+13억)'


select @SMSTEXT

EXEC [sms_system].DBO.SLMS_EIS_Insert_KAKAO 'N', @SMSSUBJECT, @SMSTEXT


-- 개인 테스트용
--EXEC [kakaoTalk].[dbo].[kakaosend] '01025264859', '01020378422', @SMSTEXT, 'LMSG_20190116152750894994', 'MMS', @SMSTEXT

-- 전산팀 테스트용
--EXEC [sms_system].DBO.SLMS_EIS_Insert_KAKAO_IT 'Y', @SMSSUBJECT, @SMSTEXT

-- 평일 용
--EXEC [sms_system].DBO.SLMS_EIS_Insert_KAKAO 'N', @SMSSUBJECT, @SMSTEXT




/*
[2019-02-28 음료 EIS 실적 안내]
[달성률]
음료(3.1,98.9,+3.6)
1지역(1.7,97.9,+1.4)
2지역(1.5,101.9,+5.9)
3지역(1.9,94.9,-1.3)
신유통(4.7,100.7,+4.8)
특수(3.7,90.9,-5.5)
E-biz(9.2,103.0,+66.1)

[매출액]
음료(36억,1160억,+41억)
1지역(4억,250억,+3억)
2지역(3억,229억,+13억)
3지역(4억,212억,-3억)
신유통(19억,394억,+18억)
특수(2억,46억,-3억)
E-biz(2억,28억,+11억)
*/