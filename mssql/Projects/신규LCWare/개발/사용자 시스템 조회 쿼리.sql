
/***************************************************
*�ۼ��� : �̿ϻ� 
*�ۼ����� : 2016-04-20
*�������� : 2016-04-20
*���� : ������ ����� �ý��� ���� ��ȸ������ ��
*
*
*****************************************************/
select 
U.domain_id,
U.sec_level,
U.code,
U.login_id,
U.name,
CASE WHEN EXISTS (select employee_num from [dbo].[VIEW_USER] where employee_num = U.code) THEN '0001' ELSE 'N' END			AS LCWARE, -- LCWare �信 �����ϸ� 0001
CASE isnull(U.ex_sap_yn,'N') WHEN 'N' THEN 'N' WHEN 'Y' THEN '0002' ELSE 'N' END																		AS WEB,		
CASE isnull(U.ex_sap_id,'N') WHEN 'N' THEN 'N' ELSE '0003' END																									AS SAP,
CASE WHEN EXISTS (select userid from [dbo].[V_TCO_USER_TEMP]  where userid = U.login_id) THEN '0003' ELSE 'N' END				AS TCO,
CASE WHEN EXISTS (select userid from [dbo].[V_NAC_USER] where userid = U.login_id) THEN '0004' ELSE 'N' END							AS TRUNAC,
CASE WHEN EXISTS (select userid from [dbo].[V_DRM_USER_TEMP]  where userid = U.login_id) THEN '0005' ELSE 'N' END				AS DRM,
CASE isnull(U.ex_mmoin_yn,'N') WHEN 'N' THEN 'N' WHEN 'Y' THEN '0006' ELSE 'N' END																	AS MMOIN
from [dbo].[org_user] AS U
left join [dbo].[V_TCO_USER_TEMP]  AS TCO
on U.login_id = TCO.userid 
left join [dbo].[V_DRM_USER_TEMP] AS DRM
on U.login_id = DRM.USERID
left join [dbo].[VIEW_USER] AS LCWARE
on LCWARE.user_code = U.user_id
WHERE U.domain_id = '11' AND status = '1'


GO