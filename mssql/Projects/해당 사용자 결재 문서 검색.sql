-- ���� ���� �˻� 
use emanage
--select * from dbo.TB_USER where username='��̸�'    --142910
--select * from dbo.TB_USER where username='�����'    --141014
select * from dbo.TB_USER where username='���ȭ'    --133564


-- userid �� ����� ������ Ȯ��
-- categoryname ���繮�� ��� 
use ewfform
select top 100 * from dbo.VW_WORK_LIST where participant_id = '128577' order by create_date desc





-- ���繮�� ���  ekwsql (sa/ admin)
-- form_id
use ewfform
select * from dbo.WF_FORMS where form_name ='��ȼ�(�����)' 



-- �ش��ϴ� ���繮�� ������� ������ ���繮�� �ֱ�100�� 
-- ���� ���μ��� ���̵� PROCESS_ID
-- ���� ��Ȳ(���3, ����7) PROCESS_INSTANCE_STATE
use ewfform

select top 100 * from dbo.FORM_YA1EA79830D1742CEA53B545BD595FF28
where 1=1 
	and creator ='���ȭ'
order by suggestdate desc



-- ���� ����� ������ ����(��������)
-- process_id �� ���� ���� Ȯ�� 

select *
from ewf.dbo.WORK_ITEM 
where 1=1 
	and process_instance_oid='ZEB9105C1EEF247F49FC544A76C40083C'
order by create_date


-- �ش� ���� ���� ����(�����޽���)
select oid,process_instance_oid, state, prc_datetime, retry_cnt, err_msg
from ewf.dbo.ENGINE_APPROVAL
where process_instance_oid = 'ZEB9105C1EEF247F49FC544A76C40083C'


select * from ewf.dbo.transition_instance
where process_instance_oid = 'ZEB9105C1EEF247F49FC544A76C40083C'
order by create_date


select * from ewf.dbo.activity_instance
where process_instance_oid = 'ZEB9105C1EEF247F49FC544A76C40083C'
order by create_date