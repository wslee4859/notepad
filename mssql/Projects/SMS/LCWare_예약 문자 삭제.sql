--LCWare ���� SMS ����

use SMS
-- ���� ��� ��ȣ �Է�
select * from SMS.[dbo].[SMS_WAIT] WHERE CALLBACKNO = '01050931607'
select * from [dbo].[SMS_WAIT] where callbackno in ('0317647810', '0317607810')

begin tran
delete 
FROM SMS.[dbo].[SMS_WAIT]
WHERE callbackno in ('0317647810', '0317607810')
--rollback
--commit



---- ���� ���� ����

--����� [dbo].[em_tran] �����ͺ��̽��� ����

select * from SMS.[dbo].[em_tran] WHERE tran_callback = '01050931607'

commit
begin tran
delete SMS.[dbo].[em_tran]
WHERE tran_callback = '01050931607' AND tran_msg = '6/13(��) Ż�ǽ� �������� �����Դϴ�. ��ĭ ������ �̿ܿ� ������ �����ٶ��ϴ�.'