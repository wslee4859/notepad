
use eWFFORM

select a.OPEN_YN, a.participant_name, d.deptname,  a.participant_id ,a.create_date AS ������¥,a.ITEMCREATE_DATE AS ��ȳ�¥, a.creator, a.creator_dept, a.subject, b.name, b.oid, e.mailaddress
from dbo.VW_WORK_LIST a
	join ewf.dbo.PROCESS_INSTANCE b
	on a.itemoid = b.oid and b.delete_date > getdate()
	join emanage.dbo.tb_dept_user_history c 
	on (a.participant_name <> '������' and a.participant_name <> '�μ�����') and a.participant_id = c.userid and c.enddate > getdate()  
	join emanage.dbo.tb_dept d 
	on c.deptid = d.deptid 
	join emanage.dbo.tb_user e
	on e.userid = a.participant_id
where  a.state = '2' and a.process_instance_view_state = '3' and a.ITEMSTATE = '1' and (a.participant_name <> '������' or a.participant_name <> '�μ�����')   
		AND a.ITEMCREATE_DATE > CONVERT(datetime,'20150701',120) 
		--AND a.CREATOR != '�̿ϻ�' 
		--AND a.OPEN_YN = 'Y'
		AND a.subject not in ('test','teset','������','�׽�Ʈ �Դϴ�. ( 9/4 )','��ȼ��׽�Ʈ ','[�׽�Ʈ]��ȼ�������','[�׽�Ʈ]��ȼ� ������.2','��Ȼ� ������ �μ��׽�Ʈ','���� �̹��� �׽�Ʈ','[�׽�Ʈ] ���� �Ͻ�')
		AND a.creator_dept not like '%����%'
order by a.ITEMCREATE_DATE 


180

28��


select top 100 * from ewf.dbo.PROCESS_INSTANCE

select top 100  * from dbo.VW_WORK_LIST where creator = '�̿ϻ�' AND state = '2'

 
select top 100  * from dbo.VW_WORK_LIST where ITEMOID = 'ZCD1BC6D6811349949C914329BED4F89E' order by create_date 

