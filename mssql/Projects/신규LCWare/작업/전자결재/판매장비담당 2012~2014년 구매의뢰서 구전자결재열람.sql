

-- �Ǹ�����翡�� �߽��� �����Ƿڼ� ���(�Ϸ�, 2012�����)
use EWF_MIG
select M.oid, M.name, M.process_oid, M.STATE , M.creator, M.CREATE_DATE, M.DELETE_DATE, M.COMPLETED_DATE, M.subject, M.CREATOR_DEPT from [dbo].[PROCESS_INSTANCE] AS M
left JOIN [eWFFORM_MIG].[dbo].[FORM_Y8D4A994E63054A5EB14621BDD3A4483E] AS F
ON M.OID = F.PROCESS_ID 
where M.name like '%�����Ƿڼ�%'
AND M.CREATE_DATE > '2012-01-01' 
AND F.PROCESS_INSTANCE_STATE = '7'
AND M.CREATOR_DEPT like '%�Ǹ����%'
order by M.create_date desc


begin tran 
update [dbo].[PROCESS_INSTANCE]
SET DELETE_DATE = '9999-12-31 00:00:00.000'  
WHERE NAME like '%�����Ƿڼ�%'
AND CREATE_DATE > '2012-01-01'
AND CREATOR_DEPT like '%�Ǹ����%'

commit
rollback

 select * from [dbo].[PROCESS_INSTANCE]  AS M
 where M.name like '%�����Ƿڼ�%'
 AND m.CREATOR_DEPT like '%�Ǹ����%'
 AND M.CREATE_DATE > '2012-01-01' 
 order by M.create_date desc


