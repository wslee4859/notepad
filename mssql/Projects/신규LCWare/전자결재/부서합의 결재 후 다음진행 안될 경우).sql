USE EWF


/********************************************************************
���ڰ��� ���缱 ����
(�μ����� �Ϸ��� ���� �����ڷ� ���� �ȵ� ���) 
Action_TYPE 00 : ����� 01 : ������ 
SIGN_STATE 00 : ��� 01 : ��� 02 : ���� 03 �ݷ� 
���� ���⹰ ���缱���輭
**********************************************************************/

--�Ϸ� ��¥ �˻�(�ش�ð��� DB�� ������ �ȸ��� �˾Ƽ� ��) COMPLETED_DATE
-- ���������������� �ش� ���� OID Ȯ�� �� 
select * from EWF.WF.WORK_ITEM WHERE process_instance_oid = 'P071FE6E8BD0F4F38B7CEBE646DFB9006' 
order by CREATE_DATE 
�μ����� �Ϸ������  : 2016-02-22 08:14:00.643

���������� ��������� : 2016-08-21 23:45:08.107
�߿�!!!! �μ����� �Ϸ���!!!!! �μ����� ������ ������ڰ� �־�� ����ó���� ����. 
--����Ǿ��µ� �ȵǾ����� Ȯ���ϱ� ����  : ������ ���������� �ش� ���� OID �Է��ϸ� ������γ���. 
-- ������ �������� subProcess���� OID Ȯ���Ͽ� �Ʒ� ��ȸ 
--1. �ش� ����(������ ������)�� OID. ���� OID�� ����
select * from EWF.WF.PROCESS_SIGNER where PROCESS_INSTANCE_OID = 'P92CDFD691E9F42C79C63D30C9C037052'
order by SIGN_SEQ 
-- 2016-08-21 23:45:04.887
select * from EWF.WF.PROCESS_SIGNER where PROCESS_INSTANCE_OID = 'PC86290E7D9F34B3F99C0A7365F4FB584'
order by SIGN_SEQ 
-- 2016-06-19 23:49:26.170
-- 2016-06-19 23:49:28.993

S67CD8F32B7924DA6BC521CB346767D29	3	PFCAD03C73DBC4FE78B7996DDC2E0377B					5532	ȭ������������	10	11	01	01	2016-01-22 09:12:30.613	NULL						 				07	NULL
S7594D1009A904981869ED4FE3A7A28C8	4	PFCAD03C73DBC4FE78B7996DDC2E0377B	67391	�����	S2	����	5458	����ȹ��	01	01	01	02	NULL	NULL						 		jose1012@lottechilsung.co.kr		01	NULL


--2.
select * from EWF.WF.PROCESS_SIGNER where PROCESS_INSTANCE_OID = 'P071FE6E8BD0F4F38B7CEBE646DFB9006'



-- subprocess ���� ���� �ð� Ȯ��
select * from EWF.WF.PROCESS_INSTANCE WHERE parent_oid = 'P0948D762F2B147A49DC09B8AF787E1C9'
���1��� 2016-07-07 08:02:50.717
����������� 2016-07-08 08:00:57.663


select @@trancount

rollback
--1. ���� OID�� ��ȸ�Ͽ� SIGN_OID �˻� 
-- ���� �Ϸ�completed_date
begin tran
update EWF.WF.PROCESS_SIGNER 
set completed_date = '2016-07-07 08:02:50.717'
,     sign_state = '12'
,     action_type = '00'
where sign_oid = 'S7C7F6AFD9C4B4136B6D28A666AAD5425'

-- 2���� �μ����� �� 
update EWF.WF.PROCESS_SIGNER 
set completed_date = '2016-06-19 23:49:28.993'
,     sign_state = '12'
,     action_type = '00'
where sign_oid = 'S2BDAF20CA306433EA2DC56D62ECAC47F'

-- ���� ����create_date
update EWF.WF.PROCESS_SIGNER 
set create_date = '2016-02-22 08:14:00.643'
,     sign_state = '01'
,     action_type = '01'
where sign_oid = 'S4F181E1801B547E4AB2E245264EE8764'

rollback
commit


/********************************
�μ����� �� �ѹ�
*********************************/
begin tran
update EWF.WF.PROCESS_SIGNER 
set completed_date = NULL
,     sign_state = '01'
,     action_type = '01'
where sign_oid = 'S695CDFD5987947B9BFDC566D6F75159F'

-- ���� ����create_date
update EWF.WF.PROCESS_SIGNER 
set create_date = NULL
,     sign_state = '01'
,     action_type = '02'
where sign_oid = 'S36724FA6F4244CFDBADE62B93223C671'

commit