
--�ý��� ���� ��û�� ����

--************************
-- �ý��۱��ѽ�û�� ��ȸ ***
--************************
use eWFFORM
select top 100 * from [dbo].[FORM_Y96114A5C446F45EAA7DED812C7BF1A54] order by suggestdate desc

use eWFFORM
select top 100 * from [dbo].[FORM_Y96114A5C446F45EAA7DED812C7BF1A54] 
where OBJECTID = '201509010001' 
order by suggestdate DESC
--���� Z957E3D38CFD4429186FFEF143A13095E,   Z9B915B9B680A4749BE6F3C73CB987D23 ,   ZB7E198AD704A48C28CA8FCEE8DB69C43
--������ å�� ZF2E00FD2F0814668B0F1CDCA5B4C664C
--�̰��  ZACA53B5C91DD4EABBC6E4FE7C086E1D9

--************************
-- �ý��۱��ѽ�û�� �ش� ���� ��ȸ ***
--************************
select * from [dbo].[FORM_Y96114A5C446F45EAA7DED812C7BF1A54] 
where 1=1 
	AND OBJECTID = '201509010001' 
	--AND PROCESS_ID = 'Z42D3D958FA40479EBD1A157BB704863F'
	--Z5BE95260727942DB968A1CCC50D3C09F
	--ZF2E00FD2F0814668B0F1CDCA5B4C664C


--  HTMLDESCRIPTION ������Ʈ ġ�� �κ�. (�޸��忡 �ٿ��־ ������ ������ ������Ʈ)
select @@trancount
begin tran
update [dbo].[FORM_Y96114A5C446F45EAA7DED812C7BF1A54]
set HTMLDESCRIPTION = '<table cellSpacing="0" cellPadding="0" width="620" height="240" border="0" align="center">
<tr width="100%" height="20">
<td width="100%" height="20">1. �⺻����</td>
</tr>
<tr width="620" height="200">
<td>
<table class="table01" cellSpacing="0" cellPadding="0" width="620" height="100%" border="0" align="center">
<tr class="txt02" height="20">
<td class="tdLine05" width="60" rowspan="7" style="TEXT-ALIGN:center;background-color:#EDEDE3;">��û��</td>
<td class="tdLine05" width="80" style="TEXT-ALIGN:center;background-color:#EDEDE3;">��û��ȣ</td>
<td class="tdLine05" width="480" style="TEXT-ALIGN:center;" colSpan="3">
201509010001
</td>
</tr>
<tr class="txt02" height="20">
<td class="tdLine05" width="80" style="TEXT-ALIGN:center;background-color:#EDEDE3;">����</td>
<td class="tdLine05" width="480" style="TEXT-ALIGN:center;" colSpan="3">
������
</td>
</tr>
<tr class="txt02" height="20">
<td class="tdLine05" width="80" style="TEXT-ALIGN:center;background-color:#EDEDE3;">�Ҽ�</td>
<td class="tdLine05" width="200" style="TEXT-ALIGN:center;" >
����������Ʈ
</td>
<td class="tdLine05" width="80" style="TEXT-ALIGN:center;background-color:#EDEDE3;">�μ�</td>
<td class="tdLine05" width="200" style="TEXT-ALIGN:center;">
������
</td>
</tr>
<tr class="txt02" height="20">
<td class="tdLine05" width="80" style="TEXT-ALIGN:center;background-color:#EDEDE3;">E-Mail</td>
<td class="tdLine05" width="200" style="TEXT-ALIGN:center;" colSpan="3">

</td>
</tr>
<tr class="txt02" height="20">
<td class="tdLine05" width="80" style="TEXT-ALIGN:center;background-color:#EDEDE3;">��û����</td>
<td class="tdLine05" width="480" style="TEXT-ALIGN:left;" colSpan="3">&nbsp;
���Ұ����� ������Ʈ �������� ��Ʈ��ũ �� DRM �ʿ�
</td>
</tr>
<tr class="txt02" height="80">
<td class="tdLine05" width="80" style="TEXT-ALIGN:center;background-color:#EDEDE3;">�󼼳���</td>
<td class="tdLine05" width="480" style="TEXT-ALIGN:left;" colSpan="3" align="right"><textarea name="content" rows="5" cols="60" align="left" readonly="yes">&nbsp;
���Ұ����� ������Ʈ�� �����ϴ� ��Ʈ�ʻ� ����������Ʈ ������ 1�� �η� ��ü
 ������Ʈ ö��) Ȳ��ȣ ���� (10.120.45.191, activesales06)
 ������Ʈ ����) ���翵 ��

* ������ ������Ʈ ������ ���� ������Ʈ �繫�ǿ��� ���� �μ��ΰ� �����ϵ���
ö�� �η°� ���� �η��� ���ͳ��� ����� �� �ִ� �ű� IP�� DRM ID�� ��û�մϴ�.
</textarea></td>
</tr>
<tr class="txt02" height="20">
<td class="tdLine05" width="80" style="TEXT-ALIGN:center;background-color:#EDEDE3;">��û�Ⱓ</td>
<td class="tdLine05" width="480" style="TEXT-ALIGN:left;" colSpan="3">&nbsp;
2015.09.09 ~ 2015.11.30
</td>
</tr>
</table>
</td>
</tr>
<tr width="100%" height="20">
<td width="100%" height="20"></td>
</tr>
</table>
<table cellSpacing="0" cellPadding="0" width="620" height="300" border="0" align="center">
<tr width="100%" height="20">
<td width="100%" height="20">2. �۾�����</td>
</tr>
<tr width="100%" height="260">
<td>
<table class="table01" cellSpacing="0" cellPadding="0" width="620" height="260" border="0" align="center">
<tr class="txt02" height="20">
<td class="tdLine05" width="60" style="background-color:#EDEDE3;">����</td>
<td class="tdLine05" width="480" style="background-color:#EDEDE3;">�󼼳���</td>
<td class="tdLine05" width="80" style="background-color:#EDEDE3;">���</td>
</tr>
<tr class="txt02" height="80">
<td class="tdLine05" width="60">N/W</td>
<td class="tdLine05" width="480" style="TEXT-ALIGN:left;"><textarea name="content" rows="5" cols="60" align="left" readonly="yes">
IP : 10.120.45.212
���հ��� : activesales12
</textarea></td>
<td class="tdLine05" width="80" style="TEXT-ALIGN:left;"></td>
</tr>
<tr class="txt02" height="80">
<td class="tdLine05" width="60">DB</td>
<td class="tdLine05" width="480" style="TEXT-ALIGN:left;"><textarea name="content" rows="5" cols="60" align="left" readonly="yes">

</textarea></td>
<td class="tdLine05" width="80" style="TEXT-ALIGN:left;"></td>
</tr>
<tr class="txt02" height="80">
<td class="tdLine05" width="60">System</td>
<td class="tdLine05" width="480" style="TEXT-ALIGN:left;"><textarea name="content" rows="5" cols="60" align="left" readonly="yes">

</textarea></td>
<td class="tdLine05" width="80" style="TEXT-ALIGN:left;"></td>
</tr>
</table>
</td>
</tr>
<tr width="100%" height="20">
<td width="100%" height="20"></td>
</tr>
</table>
<table cellSpacing="0" cellPadding="0" width="620" height="100" border="0" align="center">
<tr width="100%" height="20">
<td width="100%" height="20">3. Ư�̻���</td>
</tr>
<tr width="100%" height="100">
<td>
<table class="table01" cellSpacing="0" cellPadding="0" width="620" height="100%" border="0" align="center">
<tr class="txt02" height="80">
<td class="tdLine02" width="100%" style="TEXT-ALIGN:left;"><textarea name="content" rows="6" cols="75" align="left" readonly="yes"></textarea></td>
</tr>
</table>
</td>
</tr>
</table>'
where 1=1
	AND OBJECTID = '201509010001'
	--AND PROCESS_ID ='Z42D3D958FA40479EBD1A157BB704863F'

--rollback
--commit

--select @@trancount










