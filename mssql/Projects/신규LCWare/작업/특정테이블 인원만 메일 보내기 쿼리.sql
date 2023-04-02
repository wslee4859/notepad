-- =============================================
-- �ۼ���  : BI�λ���Ʈ �̿ϻ�
-- �����ۼ���  : 2017�� 8�� 24��      
-- ����������  : BI�λ���Ʈ �̿ϻ�
-- ����������  : 1. 2014�� 12�� 22��
-- ������̺� :      
-- =============================================

/*********************************
*������ ��� �ӽ� ���̺� 
**********************************/
DROP TABLE #Temp_Users
CREATE TABLE #Temp_Users
(
	seq	int identity(1,1),
	Code nvarchar(50),
	EmpNm nvarchar(50),	
	Email nvarchar(50)
)

-- ������ ��� ���� �ּ� INSERT 
INSERT INTO #Temp_Users 
SELECT code, name, email FROM [im80].[dbo].[org_user] 
WHERE code in ('19026')
-- select * from #Temp_Users


/*********************************
* �� �Ѹ� �� ���� ������ 
**********************************/
-- �޴»�� ���� ���� 
DECLARE @wRecipients VARCHAR(200),
		@count int,
		@CountNum int,
		@bodyhtml NVARCHAR(4000),
		@bodyhtml2 NVARCHAR(MAX)


SET @Count = @@ROWCOUNT
SET @CountNum = 1

SET @bodyhtml = 	
	N'<body>'+
	N'<p><span style="font-size:10.5pt">�ȳ��Ͻʴϱ�, ��ȹ�� ��ȯ�Դϴ�.</span></p>'+	
	N'<br/>'+
	N'<p><b><span lang=EN-US style=''font-size:10.5pt''>17</span></b><b><span style=''font-size:10.5pt''>Ҵ ���� �������<span lang=EN-US>(PC, </span>��Ʈ��<span lang=EN-US>) </span>��ü �ǿ� ���� <span class=SpellE>�˸��帳�ϴ�</span><span lang=EN-US>.<o:p></o:p></span></span></b></p>'+	
	N'<p><span style=''font-size:10.5pt''>�� ������ ����������� ��ü ����ڿ� �Ҽ� ��������ںе鲲 ������ �����̴�<span lang=EN-US>, </span><b>÷������<span lang=EN-US>(</span><span class=SpellE>��ü���</span><span lang=EN-US>, </span><span class=SpellE>��ġȮ�μ�</span><span lang=EN-US>, </span>�ּ�Ȯ��<span lang=EN-US>)</span></b><span lang=EN-US> </span>Ȯ���Ͻð�<span lang=EN-US>,<o:p></o:p></span></span></p>'+	
	N'<p><span style=''font-size:10.5pt''>�Ʒ� ������ ���� �����Ͽ� �ֽñ� �ٶ��ϴ�<span lang=EN-US>.<o:p></o:p></span></span></p>'+	
	N'<br/>'+
	N'<p><span style="font-size: 17px;">&nbsp;&nbsp;&nbsp;&nbsp;<b>1. <u>�� �μ� ������� �� �ּ� Ȯ��</u></b></span></p>'	+
	N'<p><span style="font-size: 14px;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- &nbsp;��17.6�� �ڻ�ǻ�������� �ۼ��� �ڷ��̸�, ������ ����ڰ� �ƴ� ��� ��ü �Ұ��մϴ�.</span></p>'	+
	N'<p><span style="font-size: 14px;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;��ܿ� ���� ����ڰ� �ٸ� ��쿡�� ȸ�� ��û�帳�ϴ�.(8����)</span></p>'	+
	N'<p><span style="font-size: 17px;">&nbsp;&nbsp;&nbsp;&nbsp;<b>2. <u>������ ��� (8/31�� ���� �Ϸ�)</u></b></span></p>'	+
	N'<p><span style="font-size: 14px;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- &nbsp;���ü �� ���� PC �������� ������ ���</span><span style="font-size:14px;color:red"> (�̿Ϸ�� ��ü�Ұ� �������) </span></p>'	+
	N'<p><span style="font-size: 17px;">&nbsp;&nbsp;&nbsp;&nbsp;<b>3. <u>���� ��� �ݳ� (Ÿ �𵨷� ��ü �ݳ� �Ұ�)</u></b></span></p>'	+
	N'<p><span style="font-size: 14px;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- &nbsp;�ݳ���� : ��ü ���� ��ġ���� �ȳ��� ���� �� ���� ��Ƶθ� ȸ���� �湮 ȸ�� ����</span></p>'	+
	N'<p><span style="font-size: 14px;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- &nbsp;���ǻ���</span></p>'	+
	N'<p><span style="font-size: 14px;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;A. ��ü ��, ȸ�� ���� ��� ���Ұ�</span></p>'	+
	N'<p><span style="font-size: 14px;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;B. ��Ȱ�� �۾��� ���� �ű� PC ��ǰ ������ ��� �۾� �Ϸ� ��</span></p>'	+
	N'<p><span style="font-size: 17px;">&nbsp;&nbsp;&nbsp;&nbsp;<b>4. <u>��ġ �� �ݳ��� ��ġ Ȯ�μ��� ���� �� ��ĵ �� �ش� ���Ϸ� ȸ��</u></b></span></p>'	+
	N'<br/>'+
	N'<p><span style="font-size:10.5pt">�̻��Դϴ�. �߰����� ���ǻ����� ���� �� ���� �ٶ��ϴ�.</span></p>'+	
	N'<p><span style="font-size:10.5pt">�����մϴ�.</span></p>'+	
	N'</body>';
		
IF @Count > 0
BEGIN
	WHILE (@Count >= @CountNum)
	BEGIN 		
		SELECT @wRecipients = Email
		FROM #Temp_Users
		WHERE seq = @CountNum

		EXEC msdb.dbo.sp_send_dbmail @profile_name = 'Asset_Equipment',  --���� ������ 
		 @recipients = @wRecipients,
		 @subject = '�׽�Ʈ',   -- ����
		 @body = @bodyhtml ,		-- ����
		 @body_format = 'HTML', -- ���� Ÿ��
		 -- ÷������ ���� ��� ����
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
	font-family:"���� ���";
	mso-bidi-font-family:����;}' +
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
	font-family:"���� ���";
	mso-bidi-font-family:����;}'+
	N'</style>' +
	N'<body>'+
	N'<p class=MsoNormal><span style="font-size:10.5pt">�ȳ��Ͻʴϱ�<span lang=EN-US>, </span>��ȹ��	<span class=SpellE>��ȯ�Դϴ�</span><span lang=EN-US>.<o:p></o:p></span></span></p>'+
	N'<p class=MsoNormal><span lang=EN-US style=''font-size:10.5pt''><o:p>&nbsp;</o:p></span></p>'+
	N'<p class=MsoNormal><b><span lang=EN-US style=''font-size:10.5pt''>17</span></b><b><span style=''font-size:10.5pt''>Ҵ ���� �������<span lang=EN-US>(PC, </span>��Ʈ��<span lang=EN-US>) </span>��ü �ǿ� ���� <span class=SpellE>�˸��帳�ϴ�</span><span lang=EN-US>.<o:p></o:p></span></span></b></p>'+
	N'<p class=MsoNormal><span lang=EN-US style=''font-size:10.5pt''><o:p>&nbsp;</o:p></span></p>'+
	N'<p class=MsoNormal><span style=''font-size:10.5pt''>�� ������ ����������� ��ü ����ڿ� �Ҽ� ��������ںе鲲 ������ �����̴�<span lang=EN-US>, </span><b>÷������<span lang=EN-US>(</span><span class=SpellE>��ü���</span><span lang=EN-US>, </span><span class=SpellE>��ġȮ�μ�</span><span lang=EN-US>, </span>�ּ�Ȯ��<span lang=EN-US>)</span></b><span lang=EN-US> </span>Ȯ���Ͻð�<span lang=EN-US>,<o:p></o:p></span></span></p>'+	
	N'<p class=MsoNormal><span style=''font-size:10.5pt''>�Ʒ� ������ ���� �����Ͽ� �ֽñ� �ٶ��ϴ�<span lang=EN-US>.<o:p></o:p></span></span></p>'+
	N'<p class=MsoNormal><span lang=EN-US><o:p>&nbsp;</o:p></span></p>'+
	N'<p class=MsoListParagraph style="margin-left:38.0pt;mso-para-margin-left:0gd;text-indent:-18.0pt;mso-list:l3 level1 lfo1"><![if !supportLists]><b><spanlang=EN-US style="font-size:11.0pt;mso-bidi-font-family:"���� ���""><span style="mso-list:Ignore">1.<span style="font:7.0pt "Times New Roman"">&nbsp;&nbsp;&nbsp;</span></span></span></b><![endif]><b><u><span style="font-size:11.0pt">�� �μ� ������� �� �ּ� Ȯ��<span lang=EN-US><o:p></o:p></span></span></u></b></p>' +
	N'<p class=MsoListParagraph style="margin-left:56.0pt;mso-para-margin-left:0gd;text-indent:-18.0pt;mso-list:l2 level1 lfo2"><![if !supportLists]><span lang=EN-US style="font-size:10.5pt;mso-bidi-font-family:"���� ���""><span style="mso-list:Ignore">-<span style="font:7.0pt "Times New Roman"">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span></span></span><![endif]><span style="font-size:10.5pt">��<span lang=EN-US>17.6</span>�� �ڻ�ǻ�������� �ۼ��� �ڷ��̸�<span lang=EN-US>, </span>������ ����ڰ� �ƴ� ��� ��ü �Ұ��մϴ�<span lang=EN-US>.<o:p></o:p></span></span></p>'+
	N'<p class=MsoNormal style=''margin-left:38.0pt;text-indent:21.0pt''><span style=''font-size:10.5pt''>��ܿ� ���� ����ڰ� �ٸ� ��쿡�� ȸ�� <span class=SpellE>��û�帳�ϴ�</span><span class=GramE><span lang=EN-US>.(</span></span><span lang=EN-US>8</span>����<span lang=EN-US>)</span></span><span lang=EN-US><o:p></o:p></span></p>'+
	N'<p class=MsoNormal style=''margin-left:38.0pt''><span lang=EN-US><o:p>&nbsp;</o:p></span></p>'+
	N'<p class=MsoListParagraph style=''margin-left:38.0pt;mso-para-margin-left:0gd;text-indent:-18.0pt;mso-list:l3 level1 lfo1''><![if !supportLists]><b><span lang=EN-US style=''font-size:11.0pt;mso-bidi-font-family:"���� ���"''><span style=''mso-list:Ignore''>2.<span style=''font:7.0pt "Times New Roman"''>&nbsp;&nbsp;&nbsp;</span></span></span></b><![endif]><b><u><span style=''font-size:11.0pt''>������ ���<span lang=EN-US> (8/31</span>�� ���� �Ϸ�<span lang=EN-US>)<o:p></o:p></span></span></u></b></p>'+
	N'<p class=MsoListParagraph style="margin-left:56.0pt;mso-para-margin-left:0gd;text-indent:-18.0pt;mso-list:l0 level1 lfo3"><![if !supportLists]><span lang=EN-US style="font-size:10.5pt;mso-bidi-font-family:"���� ���""><span style="mso-list:Ignore">-<span style="font:7.0pt "Times New Roman"">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span></span></span><![endif]><span class=SpellE><span style="font-size:10.5pt">���ü</span></span><span style="font-size:10.5pt"> �� ����<span lang=EN-US> PC </span>�������� ������ ��� <span lang=EN-US style="color:red">(</span><span class=SpellE><span style="color:red">�̿Ϸ��</span></span><span style="color:red"> <span class=SpellE>��ü�Ұ�</span> <span class=SpellE>�������</span><span lang=EN-US>)</span></span><span lang=EN-US><o:p></o:p></span></span></p>'+
	N'</body>';
	
