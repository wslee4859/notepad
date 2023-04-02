[dbo].[kmp_log_201903] where send_phone = '01025264859'



declare 
@SMSSUBJECT VARCHAR(40),
@SMSTEXT	VARCHAR(2000)

SELECT @SMSSUBJECT = RIGHT(CONVERT(CHAR(8), DATEADD(DD, -1, GETDATE()), 112), 8)
SELECT @SMSTEXT = '[2019-03-27 주류 EIS 실적 안내]
합계(5.0,75.9,-2.6)
해외(0.0,49.5,-37.2)
내수(5.3,77.4,+0.2)
1지역(4.8,81.1,+2.1)
2지역(8.1,75.7,-4.0)
유통(3.8,78.0,+12.3)
와인(4.8,62.9,-13.2)
스피리츠(8.1,62.2,-5.8)'

EXEC [sms_system].DBO.SLMS_EIS_Insert_LIQ_KAKAO '', @SMSSUBJECT, @SMSTEXT


-- 전산팀 테스트 
--EXEC [kakaoTalk_LLQ].[dbo].[kakaosend_llq] '01025264859', '01090459331', @SMSTEXT, 'LMSG_20180903171857468813', 'MMS', @SMSTEXT


-- 평일 용 
-- EXEC [sms_system].DBO.SLMS_EIS_Insert_LIQ_KAKAO '', @SMSSUBJECT, @SMSTEXT


