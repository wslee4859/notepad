-- ���� ���� �˻� 
select * from eManage.dbo.TB_USER where username='������'   


-- userid �� ����� ������ Ȯ��
-- categoryname ���繮�� ��� 

select top 100 * from eWFFORM.dbo.VW_WORK_LIST where participant_id = '128347' and creator_dept ='õ������' order by create_date desc

select top 10 * from eWFFORM.dbo.VW_WORK_LIST where oid = 'Z48BE9B61FE5044538DA6E8FC97DABE16'

begin tran
update eWFFORM.dbo.VW_WORK_LIST
set state = '7'
where oid = 'Z48BE9B61FE5044538DA6E8FC97DABE16' 
--  precess id = ZB0D45947C5634F11AA6A63F9C024F829

-- commit


-----------------------------------------------���� �������� ���繮�� ���°� 7 �� �����Ͽ� ����Ϸ�� ����


--���� ���� ���� ��ȸ(activity instance ID ��ȸ)
select top 100 * from ewf.dbo.engine_approval
where process_instance_oid = 'ZB0D45947C5634F11AA6A63F9C024F829'



select * from ewf.dbo.transition_instance  -- 3�� ���� 
where process_instance_oid='ZB0D45947C5634F11AA6A63F9C024F829'
order by create_date


begin tran
delete ewf.dbo.transition_instance
where oid in ('ZFA42BCA8535D418AA083C427181878B4', 'Z6818F524341649CD80C24805E6E5FA6B', 'ZFE5607B7FC6A4187BFBA41B69A8B20F8')
--commit


-- 2�� ���� ���� 
select * from ewf.dbo.ACTIVITY_INSTANCE WHERE PROCESS_INSTANCE_OID = 'ZB0D45947C5634F11AA6A63F9C024F829'
order by create_date

begin tran 
delete  ewf.dbo.ACTIVITY_INSTANCE
where oid in ('Z69907353FDAB4419B27382781F7FDC79', 'Z2E2B16E5DAE549A59C75BC694661C88A')

--commit


begin tran    --������ ������ Y�� 
update dbo.ACTIVITY_INSTANCE
set current_activity='Y'
where oid = 'Z51322098D3BE4C3C953D5C6F48AAAA9B'

--commit


--���� ���� ���� ��ȸ(activity instance ID ��ȸ)
select top 100 * from ewf.dbo.engine_approval
where process_instance_oid = 'ZB0D45947C5634F11AA6A63F9C024F829'

BEGIN TRAN
update ewf.dbo.ENGINE_APPROVAL
set state = 0, retry_cnt = 0, err_msg = ''
where oid = 'XF6D2A9EECFFE4E3C84F74C61B5141F77'

--commit
