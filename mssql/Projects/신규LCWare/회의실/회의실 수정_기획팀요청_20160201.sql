use mrbook
[dbo].[roominfo]
commit
rollback

begin tran
insert into [dbo].[roominfo]
values 
('','11','3-1 ȸ�ǽ�','1','�Ե�ĳ������','3�� (���� �������� ��)','21','Y','N','N','','Y','N','Y',getdate(),getdate(),'N','1','N','','1','11'),
('','12','3-2 ȸ�ǽ�','1','�Ե�ĳ������','3�� (���� �������� ��)','6','N','N','N','','Y','N','Y',getdate(),getdate(),'N','2','N','','1','11'),
('','13','3-3 ȸ�ǽ�','1','�Ե�ĳ������','3�� (���� �������� ��)','8','N','N','N','','Y','N','Y',getdate(),getdate(),'N','3','N','','1','11'),
('','14','4-2 ȸ�ǽ�','1','�Ե�ĳ������','4�� (���� �귣���� ��)','10','Y','N','N','','Y','N','Y',getdate(),getdate(),'N','5','N','','1','11'),
('','15','�����濵�� ȸ�ǽ�','3','��Ƿ���ȸ��','6�� (�����濵�� ��)','8','N','N','N','','Y','N','Y',getdate(),getdate(),'N','2','N','','1','11')

begin tran
update [dbo].[roominfo]
set roomNm = '5-1 ȸ�ǽ�', sortOrder = '6', floor = '5�� (���� ������ ��)'
where roomNo = '2'

update [dbo].[roominfo]
set roomNm = '5-2 ȸ�ǽ�', sortOrder = '7', floor = '5�� (��������ũ ��)'
where roomNo = '3'

update [dbo].[roominfo]
set roomNm = '5-3 ȸ�ǽ�', sortOrder = '8', floor = '5�� (���� ��ȹ�� ��)'
where roomNo = '4'

update [dbo].[roominfo]
set roomNm = '5-4 ȸ�ǽ�', sortOrder = '9',  floor = '5�� (�ַ� ���������� ��)'
where roomNo = '5'

update [dbo].[roominfo]
set roomNm = '5-5 ȸ�ǽ�', sortOrder = '10', floor = '5�� (�ַ� �ؿܿ����� ��)'
where roomNo = '6'

update [dbo].[roominfo]
set roomNm = '5-6 ȸ�ǽ�', sortOrder = '11', floor = '5�� (�ַ� �ؿܿ����� ��)'
where roomNo = '7'		

update [dbo].[roominfo]
set roomNm = '4-1 ȸ�ǽ�', sortOrder = '4', numPersons = '20', projectorYn = 'Y', floor = '4�� (���� ���������� ��)'
where roomNo = '8'		

update [dbo].[roominfo]
set roomNm = '���꺻�� ȸ�ǽ�', sortOrder = '1', floor = '4�� (���꺻�� Ү)'
where roomNo = '9'	

update [dbo].[roominfo]
set roomNm = '������ ȸ�ǽ�', sortOrder = '1', floor = '6�� (������ Ү)'
where roomNo = '1'	

update [dbo].[roominfo]
set delYN = 'Y'
where roomNo = '10'




select @@trancount