-- =============================================
-- 작성자  : BI인사파트 이완상
-- 최초작성일  : 2017년 8월 24일      
-- 최종수정자  : BI인사파트 이완상
-- 최종수정일  : 1. 2014년 12월 22일
-- 사용테이블 :      
-- =============================================

/*********************************
*보내는 사람 임시 테이블 
**********************************/
DROP TABLE #Temp_Users
CREATE TABLE #Temp_Users
(
	seq	int identity(1,1),
	Code nvarchar(50),
	EmpNm nvarchar(50),	
	Email nvarchar(50)
)

-- 보내는 사람 메일 주소 INSERT 
INSERT INTO #Temp_Users 
SELECT code, name, email FROM [im80].[dbo].[org_user] 
WHERE code in ('19026')
-- select * from #Temp_Users


/*********************************
* 각 한명 씩 메일 보내기 
**********************************/
-- 받는사람 변수 선언 
DECLARE @wRecipients VARCHAR(200),
		@count int,
		@CountNum int,
		@bodyhtml NVARCHAR(4000),
		@bodyhtml2 NVARCHAR(MAX)


SET @Count = @@ROWCOUNT
SET @CountNum = 1

SET @bodyhtml = 	
	N'<body>'+
	N'<p><span style="font-size:10.5pt">안녕하십니까, 기획팀 고세환입니다.</span></p>'+	
	N'<br/>'+
	N'<p><b><span lang=EN-US style=''font-size:10.5pt''>17</span></b><b><span style=''font-size:10.5pt''>年 노후 전산장비<span lang=EN-US>(PC, </span>노트북<span lang=EN-US>) </span>교체 건에 대해 <span class=SpellE>알림드립니다</span><span lang=EN-US>.<o:p></o:p></span></span></b></p>'+	
	N'<p><span style=''font-size:10.5pt''>이 메일은 노후전산장비 교체 대상자와 소속 업무담당자분들께 보내는 메일이니<span lang=EN-US>, </span><b>첨부파일<span lang=EN-US>(</span><span class=SpellE>교체명단</span><span lang=EN-US>, </span><span class=SpellE>설치확인서</span><span lang=EN-US>, </span>주소확인<span lang=EN-US>)</span></b><span lang=EN-US> </span>확인하시고<span lang=EN-US>,<o:p></o:p></span></span></p>'+	
	N'<p><span style=''font-size:10.5pt''>아래 절차를 거쳐 진행하여 주시기 바랍니다<span lang=EN-US>.<o:p></o:p></span></span></p>'+	
	N'<br/>'+
	N'<p><span style="font-size: 17px;">&nbsp;&nbsp;&nbsp;&nbsp;<b>1. <u>각 부서 장비사용자 및 주소 확인</u></b></span></p>'	+
	N'<p><span style="font-size: 14px;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- &nbsp;’17.6月 자산실사기준으로 작성된 자료이며, 지정된 사용자가 아닌 경우 교체 불가합니다.</span></p>'	+
	N'<p><span style="font-size: 14px;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;명단에 나온 사용자가 다를 경우에는 회신 요청드립니다.(8月限)</span></p>'	+
	N'<p><span style="font-size: 17px;">&nbsp;&nbsp;&nbsp;&nbsp;<b>2. <u>데이터 백업 (8/31日 까지 완료)</u></b></span></p>'	+
	N'<p><span style="font-size: 14px;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- &nbsp;장비교체 전 기존 PC 업무관련 데이터 백업</span><span style="font-size:14px;color:red"> (미완료시 교체불가 대상지정) </span></p>'	+
	N'<p><span style="font-size: 17px;">&nbsp;&nbsp;&nbsp;&nbsp;<b>3. <u>기존 장비 반납 (타 모델로 대체 반납 불가)</u></b></span></p>'	+
	N'<p><span style="font-size: 14px;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- &nbsp;반납방법 : 교체 당일 설치社의 안내에 따라 한 곳에 모아두면 회수社 방문 회수 예정</span></p>'	+
	N'<p><span style="font-size: 14px;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- &nbsp;주의사항</span></p>'	+
	N'<p><span style="font-size: 14px;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;A. 교체 후, 회수 예정 장비 사용불가</span></p>'	+
	N'<p><span style="font-size: 14px;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;B. 원활한 작업을 위해 신규 PC 납품 이전에 백업 작업 완료 必</span></p>'	+
	N'<p><span style="font-size: 17px;">&nbsp;&nbsp;&nbsp;&nbsp;<b>4. <u>설치 및 반납시 설치 확인서에 서명 및 스캔 후 해당 메일로 회신</u></b></span></p>'	+
	N'<br/>'+
	N'<p><span style="font-size:10.5pt">이상입니다. 추가적인 문의사항이 있을 시 연락 바랍니다.</span></p>'+	
	N'<p><span style="font-size:10.5pt">감사합니다.</span></p>'+	
	N'</body>';
		
IF @Count > 0
BEGIN
	WHILE (@Count >= @CountNum)
	BEGIN 		
		SELECT @wRecipients = Email
		FROM #Temp_Users
		WHERE seq = @CountNum

		EXEC msdb.dbo.sp_send_dbmail @profile_name = 'Asset_Equipment',  --메일 프로필 
		 @recipients = @wRecipients,
		 @subject = '테스트',   -- 제목
		 @body = @bodyhtml ,		-- 본문
		 @body_format = 'HTML', -- 본문 타입
		 -- 첨부파일 절대 경로 수정
		 @file_attachments ='C:\test\test.txt'		
		SET @CountNum = @CountNum + 1
	END
END





N'<style>' +
	N'p.MsoListParagraph, li.MsoListParagraph, div.MsoListParagraph
	{mso-style-priority:34;
	mso-style-unhide:no;
	mso-style-qformat:yes;
	margin-top:0cm;
	margin-right:0cm;
	margin-bottom:0cm;
	margin-left:40.0pt;
	margin-bottom:.0001pt;
	mso-para-margin-top:0cm;
	mso-para-margin-right:0cm;
	mso-para-margin-bottom:0cm;
	mso-para-margin-left:4.0gd;
	mso-para-margin-bottom:.0001pt;
	text-align:justify;
	text-justify:inter-ideograph;
	mso-pagination:widow-orphan;
	text-autospace:none;
	word-break:break-hangul;
	font-size:10.0pt;
	font-family:"맑은 고딕";
	mso-bidi-font-family:굴림;}' +
	N'p.MsoNormal, li.MsoNormal, div.MsoNormal
	{mso-style-unhide:no;
	mso-style-qformat:yes;
	mso-style-parent:"";
	margin:0cm;
	margin-bottom:.0001pt;
	text-align:justify;
	text-justify:inter-ideograph;
	mso-pagination:widow-orphan;
	text-autospace:none;
	word-break:break-hangul;
	font-size:10.0pt;
	font-family:"맑은 고딕";
	mso-bidi-font-family:굴림;}'+
	N'</style>' +
	N'<body>'+
	N'<p class=MsoNormal><span style="font-size:10.5pt">안녕하십니까<span lang=EN-US>, </span>기획팀	<span class=SpellE>고세환입니다</span><span lang=EN-US>.<o:p></o:p></span></span></p>'+
	N'<p class=MsoNormal><span lang=EN-US style=''font-size:10.5pt''><o:p>&nbsp;</o:p></span></p>'+
	N'<p class=MsoNormal><b><span lang=EN-US style=''font-size:10.5pt''>17</span></b><b><span style=''font-size:10.5pt''>年 노후 전산장비<span lang=EN-US>(PC, </span>노트북<span lang=EN-US>) </span>교체 건에 대해 <span class=SpellE>알림드립니다</span><span lang=EN-US>.<o:p></o:p></span></span></b></p>'+
	N'<p class=MsoNormal><span lang=EN-US style=''font-size:10.5pt''><o:p>&nbsp;</o:p></span></p>'+
	N'<p class=MsoNormal><span style=''font-size:10.5pt''>이 메일은 노후전산장비 교체 대상자와 소속 업무담당자분들께 보내는 메일이니<span lang=EN-US>, </span><b>첨부파일<span lang=EN-US>(</span><span class=SpellE>교체명단</span><span lang=EN-US>, </span><span class=SpellE>설치확인서</span><span lang=EN-US>, </span>주소확인<span lang=EN-US>)</span></b><span lang=EN-US> </span>확인하시고<span lang=EN-US>,<o:p></o:p></span></span></p>'+	
	N'<p class=MsoNormal><span style=''font-size:10.5pt''>아래 절차를 거쳐 진행하여 주시기 바랍니다<span lang=EN-US>.<o:p></o:p></span></span></p>'+
	N'<p class=MsoNormal><span lang=EN-US><o:p>&nbsp;</o:p></span></p>'+
	N'<p class=MsoListParagraph style="margin-left:38.0pt;mso-para-margin-left:0gd;text-indent:-18.0pt;mso-list:l3 level1 lfo1"><![if !supportLists]><b><spanlang=EN-US style="font-size:11.0pt;mso-bidi-font-family:"맑은 고딕""><span style="mso-list:Ignore">1.<span style="font:7.0pt "Times New Roman"">&nbsp;&nbsp;&nbsp;</span></span></span></b><![endif]><b><u><span style="font-size:11.0pt">각 부서 장비사용자 및 주소 확인<span lang=EN-US><o:p></o:p></span></span></u></b></p>' +
	N'<p class=MsoListParagraph style="margin-left:56.0pt;mso-para-margin-left:0gd;text-indent:-18.0pt;mso-list:l2 level1 lfo2"><![if !supportLists]><span lang=EN-US style="font-size:10.5pt;mso-bidi-font-family:"맑은 고딕""><span style="mso-list:Ignore">-<span style="font:7.0pt "Times New Roman"">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span></span></span><![endif]><span style="font-size:10.5pt">’<span lang=EN-US>17.6</span>月 자산실사기준으로 작성된 자료이며<span lang=EN-US>, </span>지정된 사용자가 아닌 경우 교체 불가합니다<span lang=EN-US>.<o:p></o:p></span></span></p>'+
	N'<p class=MsoNormal style=''margin-left:38.0pt;text-indent:21.0pt''><span style=''font-size:10.5pt''>명단에 나온 사용자가 다를 경우에는 회신 <span class=SpellE>요청드립니다</span><span class=GramE><span lang=EN-US>.(</span></span><span lang=EN-US>8</span>月限<span lang=EN-US>)</span></span><span lang=EN-US><o:p></o:p></span></p>'+
	N'<p class=MsoNormal style=''margin-left:38.0pt''><span lang=EN-US><o:p>&nbsp;</o:p></span></p>'+
	N'<p class=MsoListParagraph style=''margin-left:38.0pt;mso-para-margin-left:0gd;text-indent:-18.0pt;mso-list:l3 level1 lfo1''><![if !supportLists]><b><span lang=EN-US style=''font-size:11.0pt;mso-bidi-font-family:"맑은 고딕"''><span style=''mso-list:Ignore''>2.<span style=''font:7.0pt "Times New Roman"''>&nbsp;&nbsp;&nbsp;</span></span></span></b><![endif]><b><u><span style=''font-size:11.0pt''>데이터 백업<span lang=EN-US> (8/31</span>日 까지 완료<span lang=EN-US>)<o:p></o:p></span></span></u></b></p>'+
	N'<p class=MsoListParagraph style="margin-left:56.0pt;mso-para-margin-left:0gd;text-indent:-18.0pt;mso-list:l0 level1 lfo3"><![if !supportLists]><span lang=EN-US style="font-size:10.5pt;mso-bidi-font-family:"맑은 고딕""><span style="mso-list:Ignore">-<span style="font:7.0pt "Times New Roman"">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span></span></span><![endif]><span class=SpellE><span style="font-size:10.5pt">장비교체</span></span><span style="font-size:10.5pt"> 전 기존<span lang=EN-US> PC </span>업무관련 데이터 백업 <span lang=EN-US style="color:red">(</span><span class=SpellE><span style="color:red">미완료시</span></span><span style="color:red"> <span class=SpellE>교체불가</span> <span class=SpellE>대상지정</span><span lang=EN-US>)</span></span><span lang=EN-US><o:p></o:p></span></span></p>'+
	N'</body>';
	
