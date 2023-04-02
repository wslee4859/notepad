
--시스템 권한 신청서 수정

--************************
-- 시스템권한신청서 조회 ***
--************************
use eWFFORM
select top 100 * from [dbo].[FORM_Y96114A5C446F45EAA7DED812C7BF1A54] order by suggestdate desc

use eWFFORM
select top 100 * from [dbo].[FORM_Y96114A5C446F45EAA7DED812C7BF1A54] 
where OBJECTID = '201509010001' 
order by suggestdate DESC
--세건 Z957E3D38CFD4429186FFEF143A13095E,   Z9B915B9B680A4749BE6F3C73CB987D23 ,   ZB7E198AD704A48C28CA8FCEE8DB69C43
--박찬길 책임 ZF2E00FD2F0814668B0F1CDCA5B4C664C
--이경수  ZACA53B5C91DD4EABBC6E4FE7C086E1D9

--************************
-- 시스템권한신청서 해당 조건 조회 ***
--************************
select * from [dbo].[FORM_Y96114A5C446F45EAA7DED812C7BF1A54] 
where 1=1 
	AND OBJECTID = '201509010001' 
	--AND PROCESS_ID = 'Z42D3D958FA40479EBD1A157BB704863F'
	--Z5BE95260727942DB968A1CCC50D3C09F
	--ZF2E00FD2F0814668B0F1CDCA5B4C664C


--  HTMLDESCRIPTION 업데이트 치는 부분. (메모장에 붙여넣어서 수정한 내용을 업데이트)
select @@trancount
begin tran
update [dbo].[FORM_Y96114A5C446F45EAA7DED812C7BF1A54]
set HTMLDESCRIPTION = '<table cellSpacing="0" cellPadding="0" width="620" height="240" border="0" align="center">
<tr width="100%" height="20">
<td width="100%" height="20">1. 기본사항</td>
</tr>
<tr width="620" height="200">
<td>
<table class="table01" cellSpacing="0" cellPadding="0" width="620" height="100%" border="0" align="center">
<tr class="txt02" height="20">
<td class="tdLine05" width="60" rowspan="7" style="TEXT-ALIGN:center;background-color:#EDEDE3;">신청자</td>
<td class="tdLine05" width="80" style="TEXT-ALIGN:center;background-color:#EDEDE3;">신청번호</td>
<td class="tdLine05" width="480" style="TEXT-ALIGN:center;" colSpan="3">
201509010001
</td>
</tr>
<tr class="txt02" height="20">
<td class="tdLine05" width="80" style="TEXT-ALIGN:center;background-color:#EDEDE3;">성명</td>
<td class="tdLine05" width="480" style="TEXT-ALIGN:center;" colSpan="3">
정재형
</td>
</tr>
<tr class="txt02" height="20">
<td class="tdLine05" width="80" style="TEXT-ALIGN:center;background-color:#EDEDE3;">소속</td>
<td class="tdLine05" width="200" style="TEXT-ALIGN:center;" >
씨엔엠소프트
</td>
<td class="tdLine05" width="80" style="TEXT-ALIGN:center;background-color:#EDEDE3;">부서</td>
<td class="tdLine05" width="200" style="TEXT-ALIGN:center;">
개발팀
</td>
</tr>
<tr class="txt02" height="20">
<td class="tdLine05" width="80" style="TEXT-ALIGN:center;background-color:#EDEDE3;">E-Mail</td>
<td class="tdLine05" width="200" style="TEXT-ALIGN:center;" colSpan="3">

</td>
</tr>
<tr class="txt02" height="20">
<td class="tdLine05" width="80" style="TEXT-ALIGN:center;background-color:#EDEDE3;">신청목적</td>
<td class="tdLine05" width="480" style="TEXT-ALIGN:left;" colSpan="3">&nbsp;
업소가맹점 프로젝트 투입으로 네트워크 및 DRM 필요
</td>
</tr>
<tr class="txt02" height="80">
<td class="tdLine05" width="80" style="TEXT-ALIGN:center;background-color:#EDEDE3;">상세내용</td>
<td class="tdLine05" width="480" style="TEXT-ALIGN:left;" colSpan="3" align="right"><textarea name="content" rows="5" cols="60" align="left" readonly="yes">&nbsp;
업소가맹점 프로젝트를 수행하는 파트너사 씨엔엠소프트 개발자 1명 인력 교체
 프로젝트 철수) 황승호 부장 (10.120.45.191, activesales06)
 프로젝트 투입) 정재영 상무

* 원할한 프로젝트 진행을 위해 프로젝트 사무실에서 업무 인수인계 가능하도록
철수 인력과 투입 인력이 인터넷을 사용할 수 있는 신규 IP와 DRM ID를 요청합니다.
</textarea></td>
</tr>
<tr class="txt02" height="20">
<td class="tdLine05" width="80" style="TEXT-ALIGN:center;background-color:#EDEDE3;">신청기간</td>
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
<td width="100%" height="20">2. 작업내용</td>
</tr>
<tr width="100%" height="260">
<td>
<table class="table01" cellSpacing="0" cellPadding="0" width="620" height="260" border="0" align="center">
<tr class="txt02" height="20">
<td class="tdLine05" width="60" style="background-color:#EDEDE3;">구분</td>
<td class="tdLine05" width="480" style="background-color:#EDEDE3;">상세내역</td>
<td class="tdLine05" width="80" style="background-color:#EDEDE3;">비고</td>
</tr>
<tr class="txt02" height="80">
<td class="tdLine05" width="60">N/W</td>
<td class="tdLine05" width="480" style="TEXT-ALIGN:left;"><textarea name="content" rows="5" cols="60" align="left" readonly="yes">
IP : 10.120.45.212
통합계정 : activesales12
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
<td width="100%" height="20">3. 특이사항</td>
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










