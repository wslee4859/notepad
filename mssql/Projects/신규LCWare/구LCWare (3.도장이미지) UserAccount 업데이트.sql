/***************************
 ���� ����� �� *************
 ****************************/
 -- �� ���ڰ��� ����ϱ� ���ؼ��� �ű� ��Ż ����, �����ּ�, ���ϻ缭��(����) �� ���� ������Ʈ ����� ��. 
 -- �����̹����� erp ����ڸ��� ��ϰ����ϹǷ� ������� �α��� �ϴ� ����� �Ʒ� ���� ������Ʈ ���ص��� 
 select * from  eManage.[dbo].[TB_USER] where UserCD = '20146174'

use eManage
begin tran
update [dbo].[TB_USER] 
set UserAccount = 'sgwb' ,
	MailAddress = 'sgwb@lottechilsung.co.kr' ,
	MailServer = 'ekw2bmail1'
where UserCD = '20150869'

--commit
rollback


 select * from  eManage.[dbo].[TB_USER] where UserCD in ( '20146174', '20150807')
  select * from  eManage.[dbo].[TB_USER] where UserName = '�̿ϻ�'
