
-- 10.103.1.108
-- ����ȭ ���� 
--����ȭ �ǰ��ִ��� üũ, ����ȭ �����ִ� ���ȿ� status�� ���� �������. 
-- ��� ����ȭ �� ��� ��������� ��. 
use im80
select * from [dbo].[app_status]


--����
begin tran 
delete dbo.app_status

commit

