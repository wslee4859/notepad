
-- �Ǹ�/�������ġ��û��
select CREATOR,SUGGESTDATE, DOC_NAME, PROCESS_ID, SUBJECT, CREATOR_DEPT, replace(replace(DB_ETC2,char(13),''),char(10),''), replace(replace(ADD_AREA_INFO,char(13),''),char(10),''), replace(replace(DB_ETC3,char(13),''),char(10),''), replace(replace(ADD_DEPT_REMARK,char(13),''),char(10),'')  from [WF].[FORM_Y75D845715B544206B1C3E905FB0348F0] order by suggestdate desc


--�Ǹ�/�������ö����û��
select CREATOR,SUGGESTDATE, DOC_NAME, PROCESS_ID, SUBJECT, CREATOR_DEPT, replace(replace(DB_ETC2,char(13),''),char(10),''), replace(replace(ADD_AREA_INFO,char(13),''),char(10),''), replace(replace(DB_ETC3,char(13),''),char(10),''), replace(replace(ADD_DEPT_REMARK,char(13),''),char(10),'')  
from [WF].[FORM_YA97369C25CDF4966BC5494C7164035BF] order by suggestdate desc

-- �Ǹ�/������� �̵� ��û��
select CREATOR,SUGGESTDATE, DOC_NAME, PROCESS_ID, SUBJECT, CREATOR_DEPT, replace(replace(DB_ETC2,char(13),''),char(10),''), replace(replace(ADD_AREA_INFO1,char(13),''),char(10),''), replace(replace(DB_ETC3,char(13),''),char(10),''), replace(replace(ADD_AREA_INFO2,char(13),''),char(10),'') , replace(replace(ADD_DEPT_REMARK,char(13),''),char(10),'') ,replace(replace(DB_ETC4,char(13),''),char(10),'') 
from [WF].[FORM_Y8ADE0663C2FA444B80DED04B4149A7FA] order by suggestdate desc


-- �Ǹ�/������� ��ü ��û��
select CREATOR,SUGGESTDATE, DOC_NAME, PROCESS_ID, SUBJECT, CREATOR_DEPT, replace(replace(DB_ETC2,char(13),''),char(10),''), replace(replace(ADD_AREA_INFO1,char(13),''),char(10),''), replace(replace(DB_ETC3,char(13),''),char(10),''), replace(replace(ADD_AREA_INFO2,char(13),''),char(10),'')
from [WF].[FORM_Y9477F44391B94C7990584C639E2D7804] order by suggestdate desc


select *
from [WF].[FORM_Y9477F44391B94C7990584C639E2D7804] 






--���ġ��û��
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

--���ö����û��
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


-- ��� �̵� ��û��
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






-- ���ü��û�� 
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

