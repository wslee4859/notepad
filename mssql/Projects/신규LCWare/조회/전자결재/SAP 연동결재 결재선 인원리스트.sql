/**********************************************
* ���� SAP ���ڰ��� ������ ����Ʈ
***********************************************/
use EWF
select * from [WF].[WF_FORMS] where form_id in (select  form_id from [WF].[FOLDER] where PARENT_FOLDER_ID = '1833' )


YFABBBCCCD870400DA8DA58D357AAE800
select process_id from [WF].[FORM_Y96CFB35A64CC4889BA9B50FEB49E5DB9] where suggestdate > '2016-05-01'

-- ���� SAP ī�װ� ���ڰ��� ��ȸ 
select * from [WF].[FOLDER] where PARENT_FOLDER_ID = '1833' order by sort_key

-- �ַ� SAP ī�װ� ���ڰ��� ��ȸ 
select * from [EWF].[WF].[FOLDER] where PARENT_FOLDER_ID = '1911' order by sort_key

select distinct(user_name), user_id from [WF].[PROCESS_SIGNER] where process_instance_oid in (select process_id from [WF].[FORM_Y96CFB35A64CC4889BA9B50FEB49E5DB9] where suggestdate > '2016-05-01')

select * from [WF].[PROCESS_SIGNER] where process_instance_oid = 'P176398B93F4242928A8624D33371BCD7'

select OID from  [WF].[PROCESS_INSTANCE] where FORM_ID = 'Y96CFB35A64CC4889BA9B50FEB49E5DB9' AND create_date > '2016-05-01'  

-- �ŷ�ó����ǰ�Ǽ� ���缱 �ο�
select distinct(S.user_id), U.domain_name, S.user_name, U.employee_num, U.group_name,U.parent_group_name,U.position_name, U.classpos_name, U.classpos_seq from [WF].[PROCESS_SIGNER] AS S
left join Common.[IM].[VIEW_USER] AS U
ON U.user_code = S.user_id
where process_instance_oid in 
(select OID from  [WF].[PROCESS_INSTANCE] where FORM_ID = 'Y96CFB35A64CC4889BA9B50FEB49E5DB9' AND create_date > '2016-05-01' )
order by U.classpos_seq


-- �����Ƿڼ� ���缱 �ο�
select distinct(S.user_id), U.domain_name, S.user_name, U.employee_num, U.group_name,U.parent_group_name,U.position_name, U.classpos_name, U.classpos_seq from [WF].[PROCESS_SIGNER] AS S
left join Common.[IM].[VIEW_USER] AS U
ON U.user_code = S.user_id
where process_instance_oid in 
(select OID from  [WF].[PROCESS_INSTANCE] where FORM_ID = 'YDC00CA55EAC042E4847A86FE345E1986' AND create_date > '2016-05-01' )
order by U.classpos_seq


-- ���Ű��Ǽ� ���缱 �ο�
select distinct(S.user_id), U.domain_name, S.user_name, U.employee_num, U.group_name,U.parent_group_name,U.position_name, U.classpos_name, U.classpos_seq from [WF].[PROCESS_SIGNER] AS S
left join Common.[IM].[VIEW_USER] AS U
ON U.user_code = S.user_id
where process_instance_oid in 
(select OID from  [WF].[PROCESS_INSTANCE] where FORM_ID = 'Y8D211B5B3C2B4A828381E4F5F91DD63D' AND create_date > '2016-05-01' )
order by U.classpos_seq


-- �Ⱓ�����û�� ���缱 �ο�(��ü)
select distinct(S.user_id),U.domain_name, S.user_name, U.employee_num, U.group_name,U.parent_group_name,U.position_name, U.classpos_name, U.classpos_seq from [WF].[PROCESS_SIGNER] AS S
left join Common.[IM].[VIEW_USER] AS U
ON U.user_code = S.user_id
where process_instance_oid in 
(select OID from  [WF].[PROCESS_INSTANCE] where FORM_ID = 'YA8723608CDDC494B98DF4304D4C4EB5E' )
order by U.classpos_seq


-- ��ǰ���ּ� ���缱 �ο�
select distinct(S.user_id), U.domain_name, S.user_name, U.employee_num, U.group_name,U.parent_group_name,U.position_name, U.classpos_name, U.classpos_seq from [WF].[PROCESS_SIGNER] AS S
left join Common.[IM].[VIEW_USER] AS U
ON U.user_code = S.user_id
where process_instance_oid in 
(select OID from  [WF].[PROCESS_INSTANCE] where FORM_ID = 'Y442C850A9D9847C49F6DE5FF4E64763B' AND create_date > '2016-05-01' )
order by U.classpos_seq

-- �̿�ü���û�� ���缱 �ο�
select distinct(S.user_id), U.domain_name, S.user_name, U.employee_num, U.group_name,U.parent_group_name,U.position_name, U.classpos_name, U.classpos_seq from [WF].[PROCESS_SIGNER] AS S
left join Common.[IM].[VIEW_USER] AS U
ON U.user_code = S.user_id
where process_instance_oid in 
(select OID from  [WF].[PROCESS_INSTANCE] where FORM_ID = 'Y2DE0A8AEA38F484FA78BDB33B7AA2F13' AND create_date > '2016-05-01' )
order by U.classpos_seq

-- ���������û�� ���缱 �ο�
select distinct(S.user_id), U.domain_name, S.user_name, U.employee_num, U.group_name,U.parent_group_name,U.position_name, U.classpos_name, U.classpos_seq from [WF].[PROCESS_SIGNER] AS S
left join Common.[IM].[VIEW_USER] AS U
ON U.user_code = S.user_id
where process_instance_oid in 
(select OID from  [WF].[PROCESS_INSTANCE] where FORM_ID = 'Y4D270910D958485EB826FA9519E32B13' AND create_date > '2016-05-01' )
order by U.classpos_seq

-- �������ڿ����û�� ���缱 �ο�
select distinct(S.user_id), U.domain_name, S.user_name, U.employee_num, U.group_name,U.parent_group_name,U.position_name, U.classpos_name, U.classpos_seq from [WF].[PROCESS_SIGNER] AS S
left join Common.[IM].[VIEW_USER] AS U
ON U.user_code = S.user_id
where process_instance_oid in 
(select OID from  [WF].[PROCESS_INSTANCE] where FORM_ID = 'YA1A3C6AE866F4963819EBD44DD088A49' AND create_date > '2016-05-01' )
order by U.classpos_seq

-- �������ڿ����û��2 ���缱 �ο�
select distinct(S.user_id), U.domain_name, S.user_name, U.employee_num, U.group_name,U.parent_group_name,U.position_name, U.classpos_name, U.classpos_seq from [WF].[PROCESS_SIGNER] AS S
left join Common.[IM].[VIEW_USER] AS U
ON U.user_code = S.user_id
where process_instance_oid in 
(select OID from  [WF].[PROCESS_INSTANCE] where FORM_ID = 'YD2A55D6AE6BD48C0A0E3DF5EEA9400AC' AND create_date > '2016-05-01' )
order by U.classpos_seq

-- �׸񺯰��û�� ���缱 �ο�
select distinct(S.user_id), U.domain_name, S.user_name, U.employee_num, U.group_name,U.parent_group_name,U.position_name, U.classpos_name, U.classpos_seq from [WF].[PROCESS_SIGNER] AS S
left join Common.[IM].[VIEW_USER] AS U
ON U.user_code = S.user_id
where process_instance_oid in 
(select OID from  [WF].[PROCESS_INSTANCE] where FORM_ID = 'YDEBC5C134CEE4B2A8A00C243DD6D9CBF' AND create_date > '2016-05-01' )
order by U.classpos_seq

-- ȯ��������Ȳ  ���缱 �ο�
select distinct(S.user_id), U.domain_name, S.user_name, U.employee_num, U.group_name,U.parent_group_name,U.position_name, U.classpos_name, U.classpos_seq from [WF].[PROCESS_SIGNER] AS S
left join Common.[IM].[VIEW_USER] AS U
ON U.user_code = S.user_id
where process_instance_oid in 
(select OID from  [WF].[PROCESS_INSTANCE] where FORM_ID = 'Y25F560B6AABD4668A1C58349799A9CC3' AND create_date > '2016-05-01' )
order by U.classpos_seq

-- ȯ�������ֺ�  ���缱 �ο�
select distinct(S.user_id), U.domain_name, S.user_name, U.employee_num, U.group_name,U.parent_group_name,U.position_name, U.classpos_name, U.classpos_seq from [WF].[PROCESS_SIGNER] AS S
left join Common.[IM].[VIEW_USER] AS U
ON U.user_code = S.user_id
where process_instance_oid in 
(select OID from  [WF].[PROCESS_INSTANCE] where FORM_ID = 'Y0FBDE93382124140A75E14723E0545D3' AND create_date > '2016-05-01' )
order by U.classpos_seq

-- ȭ��׾��������������  ���缱 �ο�
select distinct(S.user_id), U.domain_name, S.user_name, U.employee_num, U.group_name,U.parent_group_name,U.position_name, U.classpos_name, U.classpos_seq from [WF].[PROCESS_SIGNER] AS S
left join Common.[IM].[VIEW_USER] AS U
ON U.user_code = S.user_id
where process_instance_oid in 
(select OID from  [WF].[PROCESS_INSTANCE] where FORM_ID = 'YC665B17D1EFE4B848155893F7D1A19F3' AND create_date > '2016-05-01' )
order by U.classpos_seq

-- ����Ƿڼ�  ���缱 �ο�
select distinct(S.user_id), U.domain_name, S.user_name, U.employee_num, U.group_name,U.parent_group_name,U.position_name, U.classpos_name, U.classpos_seq from [WF].[PROCESS_SIGNER] AS S
left join Common.[IM].[VIEW_USER] AS U
ON U.user_code = S.user_id
where process_instance_oid in 
(select OID from  [WF].[PROCESS_INSTANCE] where FORM_ID = 'Y9B72E33BEB9F4243B32F47078DE8A1C5' AND create_date > '2016-05-01' )
order by U.classpos_seq


-- �㺸�Ƿ�ǰ�Ǽ�  ���缱 �ο�
select distinct(S.user_id), U.domain_name, S.user_name, U.employee_num, U.group_name,U.parent_group_name,U.position_name, U.classpos_name, U.classpos_seq from [WF].[PROCESS_SIGNER] AS S
left join Common.[IM].[VIEW_USER] AS U
ON U.user_code = S.user_id
where process_instance_oid in 
(select OID from  [WF].[PROCESS_INSTANCE] where FORM_ID = 'YE1BA179699BF4845A811D6E32BB3C86B' AND create_date > '2016-05-01' )
order by U.classpos_seq

-- ����ǰ�Ƿڼ�  ���缱 �ο�
select distinct(S.user_id), U.domain_name, S.user_name, U.employee_num, U.group_name,U.parent_group_name,U.position_name, U.classpos_name, U.classpos_seq from [WF].[PROCESS_SIGNER] AS S
left join Common.[IM].[VIEW_USER] AS U
ON U.user_code = S.user_id
where process_instance_oid in 
(select OID from  [WF].[PROCESS_INSTANCE] where FORM_ID = 'Y6A91FB07B8FD4F3980E5959CC9B0FA37' AND create_date > '2016-05-01' )
order by U.classpos_seq

-- �ݳ��Ƿڼ�  ���缱 �ο�
select distinct(S.user_id), U.domain_name, S.user_name, U.employee_num, U.group_name,U.parent_group_name,U.position_name, U.classpos_name, U.classpos_seq from [WF].[PROCESS_SIGNER] AS S
left join Common.[IM].[VIEW_USER] AS U
ON U.user_code = S.user_id
where process_instance_oid in 
(select OID from  [WF].[PROCESS_INSTANCE] where FORM_ID = 'YCB087D7C87FC4C7FA54E7953F71E1926' AND create_date > '2016-05-01' )
order by U.classpos_seq

-- ���������԰���Ȳ  ���缱 �ο�
select distinct(S.user_id), U.domain_name, S.user_name, U.employee_num, U.group_name,U.parent_group_name,U.position_name, U.classpos_name, U.classpos_seq from [WF].[PROCESS_SIGNER] AS S
left join Common.[IM].[VIEW_USER] AS U
ON U.user_code = S.user_id
where process_instance_oid in 
(select OID from  [WF].[PROCESS_INSTANCE] where FORM_ID = 'YA466D68D601541B0B62FF8BCC30C87D9' AND create_date > '2016-05-01' )
order by U.classpos_seq

-- �μ��ΰ輭  ���缱 �ο�
select distinct(S.user_id), U.domain_name, S.user_name, U.employee_num, U.group_name,U.parent_group_name,U.position_name, U.classpos_name, U.classpos_seq from [WF].[PROCESS_SIGNER] AS S
left join Common.[IM].[VIEW_USER] AS U
ON U.user_code = S.user_id
where process_instance_oid in 
(select OID from  [WF].[PROCESS_INSTANCE] where FORM_ID = 'Y5B443E9098314E3DB9A8C4A1D6AACFE2' AND create_date > '2016-05-01' )
order by U.classpos_seq

-- ������ǥ�ܰ����  ���缱 �ο�
select distinct(S.user_id), U.domain_name, S.user_name, U.employee_num, U.group_name,U.parent_group_name,U.position_name, U.classpos_name, U.classpos_seq from [WF].[PROCESS_SIGNER] AS S
left join Common.[IM].[VIEW_USER] AS U
ON U.user_code = S.user_id
where process_instance_oid in 
(select OID from  [WF].[PROCESS_INSTANCE] where FORM_ID = 'YA633B1B9DE114581B9264A01B54B298B' AND create_date > '2016-05-01' )
order by U.classpos_seq





