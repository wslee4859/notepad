
-- 판매/판촉장비설치요청서
select CREATOR,SUGGESTDATE, DOC_NAME, PROCESS_ID, SUBJECT, CREATOR_DEPT, replace(replace(DB_ETC2,char(13),''),char(10),''), replace(replace(ADD_AREA_INFO,char(13),''),char(10),''), replace(replace(DB_ETC3,char(13),''),char(10),''), replace(replace(ADD_DEPT_REMARK,char(13),''),char(10),'')  from [WF].[FORM_Y75D845715B544206B1C3E905FB0348F0] order by suggestdate desc


--판매/판촉장비철수요청서
select CREATOR,SUGGESTDATE, DOC_NAME, PROCESS_ID, SUBJECT, CREATOR_DEPT, replace(replace(DB_ETC2,char(13),''),char(10),''), replace(replace(ADD_AREA_INFO,char(13),''),char(10),''), replace(replace(DB_ETC3,char(13),''),char(10),''), replace(replace(ADD_DEPT_REMARK,char(13),''),char(10),'')  
from [WF].[FORM_YA97369C25CDF4966BC5494C7164035BF] order by suggestdate desc

-- 판매/판촉장비 이동 요청서
select CREATOR,SUGGESTDATE, DOC_NAME, PROCESS_ID, SUBJECT, CREATOR_DEPT, replace(replace(DB_ETC2,char(13),''),char(10),''), replace(replace(ADD_AREA_INFO1,char(13),''),char(10),''), replace(replace(DB_ETC3,char(13),''),char(10),''), replace(replace(ADD_AREA_INFO2,char(13),''),char(10),'') , replace(replace(ADD_DEPT_REMARK,char(13),''),char(10),'') ,replace(replace(DB_ETC4,char(13),''),char(10),'') 
from [WF].[FORM_Y8ADE0663C2FA444B80DED04B4149A7FA] order by suggestdate desc


-- 판매/판촉장비 교체 요청서
select CREATOR,SUGGESTDATE, DOC_NAME, PROCESS_ID, SUBJECT, CREATOR_DEPT, replace(replace(DB_ETC2,char(13),''),char(10),''), replace(replace(ADD_AREA_INFO1,char(13),''),char(10),''), replace(replace(DB_ETC3,char(13),''),char(10),''), replace(replace(ADD_AREA_INFO2,char(13),''),char(10),'')
from [WF].[FORM_Y9477F44391B94C7990584C639E2D7804] order by suggestdate desc


select *
from [WF].[FORM_Y9477F44391B94C7990584C639E2D7804] 






--장비설치요청서
select CREATOR,SUGGESTDATE, DOC_NAME, PROCESS_ID, SUBJECT, CREATOR_DEPT, 
replace(replace(DB_ETC2,char(13),''),char(10),''), replace(replace(ADD_AREA_INFO,char(13),''),char(10),''), replace(replace(DB_ETC3,char(13),''),char(10),''), 
replace(replace(ADD_DEPT_REMARK,char(13),''),char(10),'')  from [WF].[FORM_Y75D845715B544206B1C3E905FB0348F0] order by suggestdate desc
select CREATOR,SUGGESTDATE, DOC_NAME, PROCESS_ID, SUBJECT, CREATOR_DEPT, 
CASE (ADD_AREA_INFO)
WHEN 'undefined' THEN replace(replace(DB_ETC2,char(13),''),char(10),'')
ELSE replace(replace(ADD_AREA_INFO,char(13),''),char(10),'')
END ,
CASE (ADD_DEPT_REMARK)
WHEN 'undefined' THEN replace(replace(DB_ETC3,char(13),''),char(10),'')
ELSE replace(replace(ADD_DEPT_REMARK,char(13),''),char(10),'')
END
from [WF].[FORM_Y75D845715B544206B1C3E905FB0348F0] order by suggestdate desc

--장비철수요청서
select CREATOR,SUGGESTDATE, DOC_NAME, PROCESS_ID, SUBJECT, CREATOR_DEPT, 
CASE (ADD_AREA_INFO)
WHEN 'undefined' THEN replace(replace(DB_ETC2,char(13),''),char(10),'')
ELSE replace(replace(ADD_AREA_INFO,char(13),''),char(10),'')
END ,
CASE (ADD_DEPT_REMARK)
WHEN 'undefined' THEN replace(replace(DB_ETC3,char(13),''),char(10),'')
ELSE replace(replace(ADD_DEPT_REMARK,char(13),''),char(10),'')
END
from [WF].[FORM_YA97369C25CDF4966BC5494C7164035BF] order by suggestdate desc


-- 장비 이동 요청서
select CREATOR,SUGGESTDATE, DOC_NAME, PROCESS_ID, SUBJECT, CREATOR_DEPT, 
CASE (ADD_AREA_INFO1)
WHEN 'undefined' THEN replace(replace(DB_ETC2,char(13),''),char(10),'')
ELSE replace(replace(ADD_AREA_INFO1,char(13),''),char(10),'')
END ,
CASE (ADD_AREA_INFO2)
WHEN 'undefined' THEN replace(replace(DB_ETC3,char(13),''),char(10),'')
ELSE replace(replace(ADD_AREA_INFO2,char(13),''),char(10),'')
END ,
CASE (ADD_DEPT_REMARK)
WHEN 'undefined' THEN replace(replace(DB_ETC4,char(13),''),char(10),'')
ELSE replace(replace(ADD_DEPT_REMARK,char(13),''),char(10),'')
END
from [WF].[FORM_Y8ADE0663C2FA444B80DED04B4149A7FA] order by suggestdate desc






-- 장비교체요청서 
select CREATOR,SUGGESTDATE, DOC_NAME, PROCESS_ID, SUBJECT, CREATOR_DEPT, 
CASE (ADD_AREA_INFO1)
WHEN 'undefined' THEN replace(replace(DB_ETC2,char(13),''),char(10),'')
ELSE replace(replace(ADD_AREA_INFO1,char(13),''),char(10),'')
END ,
CASE (ADD_AREA_INFO2)
WHEN 'undefined' THEN replace(replace(DB_ETC3,char(13),''),char(10),'')
ELSE replace(replace(ADD_AREA_INFO2,char(13),''),char(10),'')
END
from [WF].[FORM_Y9477F44391B94C7990584C639E2D7804] order by suggestdate desc

