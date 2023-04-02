--(구)전자결재 조회 
-- URL : https://portal.lottechilsung.co.kr/UM/Migration/FormLoad/FormMainPreRead.aspx?mode=COMPLETE&pid=Z958D451B99964E359B69B3DB387D2108&open_yn=Y&wid=Z678331B855D74B7182F56B7128D44A1D&postscript=N&deptid=&refDoc=N&attachYN=&FolderID=&FormID=&SortCol=&SortOrder=&StartDate=&EndDate=
-- oid 붙여넣으면 됨.

-- 10.120.6.96 
use EWF_MIG
select oid, name, state, creator, subject, CREATE_DATE, COMPLETED_DATE from [dbo].[PROCESS_INSTANCE] where subject like '%대박유통%' order by create_date

select oid, name, process_oid, state, creator, CREATE_DATE, COMPLETED_DATE, subject from [dbo].[PROCESS_INSTANCE] where subject like '%업소가맹점%' AND name like '%기안서(지점용)%' AND CREATOR like '구태왕' order by create_date desc

--기안자
select oid, name, process_oid, state, creator, subject from [dbo].[PROCESS_INSTANCE] where creator like '%김동환%' AND name like '%담보%'
select oid, name, state, creator, subject, CREATE_DATE, COMPLETED_DATE from [dbo].[PROCESS_INSTANCE] where creator like '%%' AND name like '%담보%'ANd subject like '%대박유통%' order by create_date


select * from [dbo].[PROCESS_INSTANCE] where creator = '정순욱' AND name = '전산처리의뢰서' AND subject like '%2014년%'
https://portal.lottechilsung.co.kr/UM/Migration/FormLoad/FormMainPreRead.aspx?mode=COMPLETE&pid=Z209E4E16962D4F6FA26D6520CC1918EE
ZE1BCE81D78F9437C946FC7F122E2F476



-- 폼 테이블 찾기 
select * from [eWFFORM_MIG].[dbo].[WF_FORMS] where fORM_NAME like '%기안서%'





-- 전체

use EWF_MIG
select M.oid, M.name, M.process_oid, M.STATE , M.creator, M.CREATE_DATE, M.DELETE_DATE, M.COMPLETED_DATE, M.subject, M.CREATOR_DEPT 
from [dbo].[PROCESS_INSTANCE] AS M
where 1=1
--AND M.name like '%기안서%'
AND subject like '%활동비%'
--AND M.CREATOR = '이철선'
--AND M.CREATE_DATE > '2010-11-01' 
--AND M.CREATE_DATE < '2011-03-01' 
--AND F.PROCESS_INSTANCE_STATE = '7'
--AND M.CREATOR_DEPT like '%안성%'
order by M.create_date 



-- 기안서 용
use EWF_MIG
select M.name,M.OID, M.SUBJECT, M.CREATE_DATE, M.CREATOR_DEPT, M.CREATOR, F.PROCESS_INSTANCE_STATE
from [dbo].[PROCESS_INSTANCE] AS M
left JOIN [eWFFORM_MIG].[dbo].[FORM_Y28B72F2F7EE54FB5BE13E8F2A3637978] AS F
ON M.OID = F.PROCESS_ID 
where 1=1
AND name like '%기안서%'
AND M.subject like '%불용장비 폐기 및 매각%'
--AND M.CREATOR = '손외식'
--AND M.CREATOR_DEPT like '%북부산지점%'
-- AND (M.CREATOR_DEPT like '%자판사업팀%' OR M.CREATOR_DEPT like '%자판사업부%')
--AND M.CREATE_DATE > '2013-01-01' AND M.CREATE_DATE < '2015-04-01'
AND F.PROCESS_INSTANCE_STATE = '7'
order by M.CREATE_DATE

 [dbo].[PROCESS_INSTANCE] WHERE NAME like '%기안서(지점용)%' ORDER BY  CREATE_DATE 
-- 기안서 지점용 용
use EWF_MIG
select M.OID, M.SUBJECT, M.CREATE_DATE, M.CREATOR_DEPT, M.CREATOR, F.PROCESS_INSTANCE_STATE
from [dbo].[PROCESS_INSTANCE] AS M
left JOIN [eWFFORM_MIG].[dbo].[FORM_YFA4BC440266849EB8DBA1A1FE7C55EE6] AS F
ON M.OID = F.PROCESS_ID 
where 1=1
AND name like '%기안서(지점용)%'
AND M.subject like '%활동비%'
--AND M.CREATOR in ('이인규','이승용')
--AND M.CREATOR_DEPT like '%서부%'
-- AND (M.CREATOR_DEPT like '%자판사업팀%' OR M.CREATOR_DEPT like '%자판사업부%')
AND M.CREATE_DATE > '2011-11-01'  AND M.CREATE_DATE < '2012-04-01'
AND F.PROCESS_INSTANCE_STATE = '7'
order by M.CREATE_DATE


-- 기안서 지점용 용(자판담당) 
use EWF_MIG
select M.NAME, M.OID, M.SUBJECT, M.CREATE_DATE, M.CREATOR_DEPT, M.CREATOR, F.PROCESS_INSTANCE_STATE
from [dbo].[PROCESS_INSTANCE] AS M
left JOIN [eWFFORM_MIG].[dbo].[FORM_YFA4BC440266849EB8DBA1A1FE7C55EE6] AS F
ON M.OID = F.PROCESS_ID 
where 1=1
AND name like '%기안서(지점용)%'
-- AND subject like '%상품권%'
-- AND M.CREATOR = '황인보'
AND (M.CREATOR_DEPT like '%자판사업팀%' OR M.CREATOR_DEPT like '%자판사업부%')
-- AND M.CREATOR_DEPT like '%자판담당%'
AND M.CREATE_DATE > '2012-01-01' AND M.CREATE_DATE < '2015-01-01'
AND F.PROCESS_INSTANCE_STATE = '7'
--AND CREATOR_DEPT like '%판매장비%'
order by M.CREATE_DATE


-- 기안서 용(자판담당) 
use EWF_MIG
select M.NAME, M.OID, M.SUBJECT, M.CREATE_DATE, M.CREATOR_DEPT, M.CREATOR, F.PROCESS_INSTANCE_STATE
from [dbo].[PROCESS_INSTANCE] AS M
left JOIN [eWFFORM_MIG].[dbo].[FORM_Y28B72F2F7EE54FB5BE13E8F2A3637978] AS F
ON M.OID = F.PROCESS_ID 
where 1=1
AND name like '%기안서%'
-- AND subject like '%상품권%'
-- AND M.CREATOR = '황인보'
AND (M.CREATOR_DEPT like '%자판사업팀%' OR M.CREATOR_DEPT like '%자판사업부%')
-- AND M.CREATOR_DEPT like '%자판담당%'
AND M.CREATE_DATE > '2012-01-01' AND M.CREATE_DATE < '2015-01-01'
AND F.PROCESS_INSTANCE_STATE = '7'
--AND CREATOR_DEPT like '%판매장비%'
order by M.CREATE_DATE

-- 구매의뢰서용(자판담당) 
use EWF_MIG
select M.NAME, M.OID, M.SUBJECT, M.CREATE_DATE, M.CREATOR_DEPT, M.CREATOR, F.PROCESS_INSTANCE_STATE
from [dbo].[PROCESS_INSTANCE] AS M
left JOIN [eWFFORM_MIG].[dbo].[FORM_Y8D4A994E63054A5EB14621BDD3A4483E] AS F
ON M.OID = F.PROCESS_ID 
where 1=1
AND name like '%구매%'
-- AND subject like '%상품권%'
-- AND M.CREATOR = '황인보'
AND (M.CREATOR_DEPT like '%자판사업팀%' OR M.CREATOR_DEPT like '%자판사업부%')
-- AND M.CREATOR_DEPT like '%자판담당%'
AND M.CREATE_DATE > '2012-01-01' AND M.CREATE_DATE < '2015-01-01'
AND F.PROCESS_INSTANCE_STATE = '7'
--AND CREATOR_DEPT like '%판매장비%'
order by M.CREATE_DATE



-- 거래처 지원품의서 (자판담당) 
use EWF_MIG
select M.NAME, M.OID,replace(replace(M.subject,char(13),''),char(10),''), M.CREATE_DATE, M.CREATOR_DEPT, M.CREATOR, F.PROCESS_INSTANCE_STATE
from [dbo].[PROCESS_INSTANCE] AS M
left JOIN [eWFFORM_MIG].[dbo].[FORM_YB9222DABFA484AC6AC97F2A23C649789] AS F
ON M.OID = F.PROCESS_ID 
where 1=1
AND name like '%거래처%'
-- AND subject like '%상품권%'
-- AND M.CREATOR = '황인보'
AND (M.CREATOR_DEPT like '%자판사업팀%' OR M.CREATOR_DEPT like '%자판사업부%')
-- AND M.CREATOR_DEPT like '%자판담당%'
AND M.CREATE_DATE > '2012-01-01' AND M.CREATE_DATE < '2015-01-01'
AND F.PROCESS_INSTANCE_STATE = '7'
--AND CREATOR_DEPT like '%판매장비%'
order by M.CREATE_DATE


-- 거래처 지원품의서 
use EWF_MIG
select M.NAME, M.OID,replace(replace(M.subject,char(13),''),char(10),''), M.CREATE_DATE, M.CREATOR_DEPT, M.CREATOR, F.PROCESS_INSTANCE_STATE
from [dbo].[PROCESS_INSTANCE] AS M
left JOIN [eWFFORM_MIG].[dbo].[FORM_YB9222DABFA484AC6AC97F2A23C649789] AS F
ON M.OID = F.PROCESS_ID 
where 1=1
AND name like '%거래처%'
AND M.subject like '%삼성코인벤딩%'
AND M.CREATOR = '최규훈'
-- AND (M.CREATOR_DEPT like '%부산FS담당%' OR M.CREATOR_DEPT like '%부산자판담당%')
-- AND M.CREATOR_DEPT like '%부산FS담당%'
-- AND M.CREATE_DATE > '2012-01-01' AND M.CREATE_DATE < '2016-01-01'
  AND F.PROCESS_INSTANCE_STATE = '7'
--AND CREATOR_DEPT like '%판매장비%'
order by M.CREATE_DATE



Z3E2F1D9F169F47128C163F76329AF966
ZDDF1CF79ECF34DD29E56A9E151438495

-- 구매의뢰서 조회 (마케팅전략담당)
use EWF_MIG
select M.NAME, M.OID, replace(replace(M.subject,char(13),''),char(10),''), M.CREATE_DATE, M.CREATOR_DEPT, M.CREATOR, F.PROCESS_INSTANCE_STATE
from [dbo].[PROCESS_INSTANCE] AS M
left JOIN [eWFFORM_MIG].[dbo].[FORM_Y8D4A994E63054A5EB14621BDD3A4483E] AS F
ON M.OID = F.PROCESS_ID 
where 1=1
AND name like '구매의뢰서'
-- AND subject like '%상품권%'
-- AND M.CREATOR = '황인보'
--AND (M.CREATOR_DEPT like '%자판사업팀%' OR M.CREATOR_DEPT like '%자판사업부%')
-- AND (M.SUBJECT like '%상품권%' OR M.SUBJECT like '%백화점%' OR M.SUBJECT like '%주유%')
AND M.CREATOR_DEPT like '%자판사업부%'
AND M.CREATE_DATE > '2011-12-31' AND  M.CREATE_DATE < '2015-01-01'
AND F.PROCESS_INSTANCE_STATE = '7'
order by M.CREATE_DATE



-- 구매의뢰서 
use EWF_MIG
select M.NAME, M.OID, replace(replace(M.subject,char(13),''),char(10),''), M.CREATE_DATE, M.CREATOR_DEPT, M.CREATOR, F.PROCESS_INSTANCE_STATE
from [dbo].[PROCESS_INSTANCE] AS M
left JOIN [eWFFORM_MIG].[dbo].[FORM_Y8D4A994E63054A5EB14621BDD3A4483E] AS F
ON M.OID = F.PROCESS_ID 
where 1=1
AND name like '구매의뢰서'
-- AND subject like '%상품권%'
-- AND M.CREATOR = '황인보'
--AND (M.CREATOR_DEPT like '%자판사업팀%' OR M.CREATOR_DEPT like '%자판사업부%')
-- AND (M.SUBJECT like '%상품권%' OR M.SUBJECT like '%백화점%' OR M.SUBJECT like '%주유%')
AND M.CREATOR_DEPT like '%자판사업부%'
AND M.CREATE_DATE > '2011-12-31' AND  M.CREATE_DATE < '2015-01-01'
AND F.PROCESS_INSTANCE_STATE = '7'
order by M.CREATE_DATE




-- 전체문서 조회
use EWF_MIG
select M.NAME, M.OID, replace(replace(M.subject,char(13),''),char(10),''), M.CREATE_DATE, M.CREATOR_DEPT, M.CREATOR
from [dbo].[PROCESS_INSTANCE] AS M
where 1=1
AND name like '구매의뢰서'
-- AND subject like '%상품권%'
-- AND M.CREATOR = '황인보'
--AND (M.CREATOR_DEPT like '%자판사업팀%' OR M.CREATOR_DEPT like '%자판사업부%')
-- AND (M.SUBJECT like '%상품권%' OR M.SUBJECT like '%백화점%' OR M.SUBJECT like '%주유%')
AND M.CREATOR_DEPT like '%영업전략담당%'
AND M.CREATE_DATE > '2011-12-31' AND  M.CREATE_DATE < '2015-01-01'
order by M.CREATE_DATE



-- 전체문서 조회 (서부산 지점)
use EWF_MIG
select M.NAME, M.OID, replace(replace(M.subject,char(13),''),char(10),''), M.CREATE_DATE, M.CREATOR_DEPT, M.CREATOR
from [dbo].[PROCESS_INSTANCE] AS M
where 1=1
-- AND (name like '%기안서(지점용)%' OR name like '%지원품의서%')
AND M.name like '%기안서%'
AND subject like '%4월%'
-- AND (M.CREATOR = '유재권' OR M.CREATOR = '이철희')
-- AND (M.CREATOR_DEPT like '%자판사업팀%' OR M.CREATOR_DEPT like '%자판사업부%')
-- AND (M.SUBJECT like '%상품권%' OR M.SUBJECT like '%백화점%' OR M.SUBJECT like '%주유%')
AND M.CREATOR_DEPT like '%북부지점%'
AND M.CREATE_DATE > '2011-12-31' AND  M.CREATE_DATE < '2015-01-01'
order by M.CREATE_DATE 




-- 북부지사 김현주 
use EWF_MIG
select M.NAME, M.OID, replace(replace(M.subject,char(13),''),char(10),''), M.CREATE_DATE, M.CREATOR_DEPT, M.CREATOR, F.PROCESS_INSTANCE_STATE
from [dbo].[PROCESS_INSTANCE] AS M
left JOIN [eWFFORM_MIG].[dbo].[FORM_YFA4BC440266849EB8DBA1A1FE7C55EE6] AS F
ON M.OID = F.PROCESS_ID 
where 1=1
AND name like '%기안서(지점용)%'
-- AND subject like '%상품권%'
AND M.CREATOR = '김진수'
AND M.CREATOR_DEPT like '%북부지사%'
AND M.CREATE_DATE > '2014-01-01' 
AND F.PROCESS_INSTANCE_STATE = '7'
order by M.CREATE_DATE




use EWF_MIG
select M.OID, M.SUBJECT, M.CREATE_DATE, M.CREATOR_DEPT,  M.CREATOR, F.PROCESS_INSTANCE_STATE
from [dbo].[PROCESS_INSTANCE] AS M
left JOIN [eWFFORM_MIG].[dbo].[FORM_YFA4BC440266849EB8DBA1A1FE7C55EE6] AS F
ON M.OID = F.PROCESS_ID 
where 1=1
AND name like '%기안서(지점용)%'
-- AND subject like '%상품권%'
-- AND M.CREATOR = '황인보'
AND M.CREATOR_DEPT like '%자판사업부%'
AND M.CREATE_DATE > '2012-01-01' 
AND F.PROCESS_INSTANCE_STATE = '7'
--AND CREATOR_DEPT like '%판매장비%'
order by M.CREATE_DATE



select * from [eWFFORM_MIG].[dbo].[WF_FORMS] where fORM_NAME = '기안서(지점용)'


use EWF_MIG
select *, replace(replace(subject,char(13),''),char(10),'')
from [dbo].[PROCESS_INSTANCE] 
where 1=1
-- AND name like '%기안서%'
--AND subject like '%롯데시네마%'
--AND CREATOR = '황인보'
AND CREATOR_DEPT = '은평지점'
AND CREATE_DATE > '2013-01-01' AND CREATE_DATE < '2015-01-01'
-- AND state = '7'
--AND CREATOR_DEPT like '%판매장비%'
order by CREATE_DATE


ZDD81829A78904D828447638B13027353

order by create_date desc


select * from [eWFFORM_MIG].[dbo].[WF_FORMS] where FORM_NAME like '구매의뢰서'

[eWFFORM_MIG].[dbo].[FORM_Y8D4A994E63054A5EB14621BDD3A4483E]

Z5ADB5ECFDB9A4D18ABE1996414E9CEB7

https://portal.lottechilsung.co.kr/UM/Migration/FormLoad/FormMainPreRead.aspx?mode=COMPLETE&pid=Z5ADB5ECFDB9A4D18ABE1996414E9CEB7&open_yn=Y&wid=Z678331B855D74B7182F56B7128D44A1D&postscript=N&deptid=&refDoc=N&attachYN=&FolderID=&FormID=&SortCol=&SortOrder=&StartDate=&EndDate=