
use eWFFORM

select a.OPEN_YN, a.participant_name, d.deptname,  a.participant_id ,a.create_date AS 받은날짜,a.ITEMCREATE_DATE AS 기안날짜, a.creator, a.creator_dept, a.subject, b.name, b.oid, e.mailaddress
from dbo.VW_WORK_LIST a
	join ewf.dbo.PROCESS_INSTANCE b
	on a.itemoid = b.oid and b.delete_date > getdate()
	join emanage.dbo.tb_dept_user_history c 
	on (a.participant_name <> '수신함' and a.participant_name <> '부서합의') and a.participant_id = c.userid and c.enddate > getdate()  
	join emanage.dbo.tb_dept d 
	on c.deptid = d.deptid 
	join emanage.dbo.tb_user e
	on e.userid = a.participant_id
where  a.state = '2' and a.process_instance_view_state = '3' and a.ITEMSTATE = '1' and (a.participant_name <> '수신함' or a.participant_name <> '부서합의')   
		AND a.ITEMCREATE_DATE > CONVERT(datetime,'20150701',120) 
		--AND a.CREATOR != '이완상' 
		--AND a.OPEN_YN = 'Y'
		AND a.subject not in ('test','teset','박준현','테스트 입니다. ( 9/4 )','기안서테스트 ','[테스트]기안서지점용','[테스트]기안서 지점용.2','기안사 결재중 인쇄테스트','사진 이미지 테스트','[테스트] 참조 일시')
		AND a.creator_dept not like '%신협%'
order by a.ITEMCREATE_DATE 


180

28건


select top 100 * from ewf.dbo.PROCESS_INSTANCE

select top 100  * from dbo.VW_WORK_LIST where creator = '이완상' AND state = '2'

 
select top 100  * from dbo.VW_WORK_LIST where ITEMOID = 'ZCD1BC6D6811349949C914329BED4F89E' order by create_date 

