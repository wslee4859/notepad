
/*******************************************
����ó���ϷẸ��  ���ð���� ����ó���Ƿڼ� ���� ��� 
oid = ����ó���ϷẸ����  oid

id, formid, subject �� ����ó���Ƿڼ��� ���� 

�̷� : 
2018-04-11 Ȳ���� ���
2018-04-13 �輺ȯ å��	P3F29496E30A440E8AAA82079C1D3DCD9

********************************************/
--insert into [WF].[WF_FORM_REFDOC]
--values('����ó���ϷẸ��OID(��������)','����ó���Ƿڼ�(����/����)�־���Ұ���','','�־���l���� FORMID','�־���Ұ��� ����','','','','')



-- 1.���ù����� �־���� ���� ����
oid  =  PB836C0E7B9234830851CDFF70F2D4884    ����ó���ϷẸ���� Process_id


-- 2.���� ���� ����
id =  PA9433AF1953049CC964844FB64271D47       ����ó���Ƿڼ�(����/����)�� PID
formid = Y86483E4798C143E2B61A5CC627CF6177   ����ó���Ƿڼ�(����/����) FORMID 
subject = '������� ��ȸ�� �������� �߰�'   ����ó���Ƿڼ��� ����

--���� ����ó���Ƿڼ� : YE6A8907A455743E58C86D37EC4A658C1
--�ַ� ����ó���Ƿڼ� : Y86483E4798C143E2B61A5CC627CF6177




-- 3. ����
--insert into [WF].[WF_FORM_REFDOC]
--values('����ó���ϷẸ��OID(��������)','����ó���Ƿڼ�(����/����)�־���Ұ���','','�־���l���� FORMID','�־���Ұ��� ����','','','','')
begin tran
insert into [WF].[WF_FORM_REFDOC]
values('PFEE860345F6F4236B639D541230BC9AA','PFA2B46B817F1463DA75483608B0A549A','','YE6A8907A455743E58C86D37EC4A658C1','�泲������ õ���ù�(��)���� �','','','','')



-- 3. �ַ� 
--insert into [WF].[WF_FORM_REFDOC]
--values('����ó���ϷẸ��OID(��������)','����ó���Ƿڼ�(����/����)�־���Ұ���','','�־���l���� FORMID','�־���Ұ��� ����','','','','')
begin tran
insert into [WF].[WF_FORM_REFDOC]
values('P4C49DF73867442CC84A3F6F140E709D3','PB661B4CAECD940C9955ECA4938F951E5','','Y86483E4798C143E2B61A5CC627CF6177','��� ��꼱�� ��û �׸� Ȱ��ȭ','','','','')


select * from [WF].[WF_FORM_REFDOC] WHERE SUBJECT = 'OT�ڷ� ������� ȭ�� ���� ������û'

begin tran
update [WF].[WF_FORM_REFDOC]
SET PROCESS_INSTANCE_OID = 'PE6816703188A4D63A2FAF2E228EA6340', PROCESS_ID = 'P9B50ED9D76164EC3A8FEC2CE984939C8'
 WHERE SUBJECT = 'OT�ڷ� ������� ȭ�� ���� ������û'


--commit
--rollback
select @@TRANCOUNT
--4 . ���ù��� ��ü
-- select * from [WF].[WF_FORM_REFDOC] WHERE PROCESS_INSTANCE_OID = 'PFF56DAE5C2E74828AFD28A1F221A08C8'
begin tran
update [WF].[WF_FORM_REFDOC]
set PROCESS_ID = 'P27EB518FFE8444B987434D926B669E73', FORM_ID = 'YE6A8907A455743E58C86D37EC4A658C1', SUBJECT = '���� �����Ȳ(zscr0052) ��ȸ ���� �߰�', DOC_NUMBER = '����������� ��2017-2ȣ'
WHERE PROCESS_INSTANCE_OID = 'PFF56DAE5C2E74828AFD28A1F221A08C8'







