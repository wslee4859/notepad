select * from mrbook.[dbo].[roominfo] where location = '1' order by sortOrder 
select * from mrbook.[dbo].[roominfo] where bookType = '2' order by sortOrder 
insert into [dbo].[roominfo] values ('023603','1','����','1','����������','1','8','N','N','N','02-3479-9299','Y','N','Y',getdate(),getdate(),'N','1','N','�뱸45��9289')


insert into [dbo].[roominfo] values ('','1','������ȸ�ǽ�','3','��Ƿ���ȸ��','6','10','N','N','N','02-3479-9299','Y','N','Y',getdate(),getdate(),'N','1','N','','1','11')
insert into [dbo].[roominfo] values ('','2','5-1','1','�Ե�ĳ������','5','10','N','N','N','','Y','N','Y',getdate(),getdate(),'N','2','N','','1','11')
insert into [dbo].[roominfo] values ('','3','5-2','1','�Ե�ĳ������','5','10','N','N','N','','Y','N','Y',getdate(),getdate(),'N','3','N','','1','11')
insert into [dbo].[roominfo] values ('','4','5-3','1','�Ե�ĳ������','5','10','N','N','N','','Y','N','Y',getdate(),getdate(),'N','4','N','','1','11')
insert into [dbo].[roominfo] values ('','5','5-4','1','�Ե�ĳ������','5','10','N','N','N','','Y','N','Y',getdate(),getdate(),'N','5','N','','1','11')
insert into [dbo].[roominfo] values ('','6','5-5','1','�Ե�ĳ������','5','10','N','N','N','','Y','N','Y',getdate(),getdate(),'N','6','N','','1','11')
insert into [dbo].[roominfo] values ('','7','5-6','1','�Ե�ĳ������','5','10','N','N','N','','Y','N','Y',getdate(),getdate(),'N','7','N','','1','11')
insert into [dbo].[roominfo] values ('','8','ȸ�ǽ� 4-1','1','�Ե�ĳ������','5','10','N','N','N','','Y','N','Y',getdate(),getdate(),'N','8','N','','1','11')
insert into [dbo].[roominfo] values ('','9','ȸ�ǽ�','2','�ñ׸�Ÿ��','7','10','N','N','N','','Y','N','Y',getdate(),getdate(),'N','9','N','','1','11')


begin tran 
insert into [dbo].[roominfo] (roomNo, roomNm, locationNm, numPersons, indate, changedate, delYN, sortOrder, carNo, bookType, domain_id, remark)
values ('2', 'BMW','������','6',getdate(),getdate(),'N','2','31��0411','2','11','�׺���̼�')

commit
rollback


-- ������Ʈ 
begin tran
update mrbook.dbo.roominfo
set delYN = 'N' , roomNm = '5-4 A ȸ�ǽ�', floor = '5�� (�ַ� ���������� ��)',
numPersons = '6', projectorYn = 'Y', wboardYn = 'Y', videoYn = 'N', sortOrder = '10'
--set numPersons = '30'
where roomNo = '10'
commit

rollback
--���̺�  �� ���� 
begin tran
delete mrbook.dbo.roominfo
where roomNo in ('7')
commit


begin tran
update mrbook.dbo.roominfo
set projectorYn = 'N'
where roomNo = '10'
commit


begin tran
update mrbook.dbo.roominfo
set roomNo = '18' , naviYn = 'N' 
--set numPersons = '30'
where roomNo = '2' AND bookType = '2'


commit